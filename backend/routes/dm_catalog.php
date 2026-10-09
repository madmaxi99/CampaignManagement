<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Repository\CatalogEditorRepository;
use Flyka\CampaignManagement\Repository\WorldRepository;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;
use function Flyka\CampaignManagement\Http\jsonResponse;
use function Flyka\CampaignManagement\Http\storeUploadedImage;

/**
 * DM routes of the catalog editors (items, bestiary), the read-only
 * encounter tables and the party endpoints. All under /dm, so DmGate guards them.
 */
return function (App $app, CatalogEditorRepository $catalog, WorldRepository $world): void {
    $json = fn (Request $request): array => json_decode((string) $request->getBody(), true) ?? [];

    $guard = function (Response $response, callable $action) {
        try {
            return $action();
        } catch (InvalidArgumentException $e) {
            return jsonResponse($response, [
                'error' => $e->getMessage(),
            ], 422);
        }
    };

    $redirect = fn (Response $response, string $to) => $response->withHeader('Location', $to)
        ->withStatus(302);

    $app->get('/dm/catalog', fn (Request $request, Response $response) => $redirect($response, '/dm/catalog/items'));

    // ---------- items ----------

    /**
     * Splits a long catalog list into categories so a page only shows one of them: the requested
     * category, else the one of the opened entry, else the first. "counts" lists every category.
     *
     * @param list<array<string, mixed>> $rows
     * @return array{selected: string, counts: array<string, int>, rows: list<array<string, mixed>>}
     */
    $byCategory = function (array $rows, string $field, string $requested, ?string $entityCategory): array {
        $counts = [];
        foreach ($rows as $row) {
            $key = (string) ($row[$field] ?? 'Ohne Kategorie');
            $counts[$key] = ($counts[$key] ?? 0) + 1;
        }
        $selected = match (true) {
            isset($counts[$requested]) => $requested,
            $entityCategory !== null && isset($counts[$entityCategory]) => $entityCategory,
            default => (string) array_key_first($counts),
        };

        return [
            'selected' => $selected,
            'counts' => $counts,
            'rows' => array_values(array_filter($rows, fn (array $row): bool => (string) ($row[$field] ?? 'Ohne Kategorie') === $selected)),
        ];
    };

    $app->get('/dm/catalog/items', function (Request $request, Response $response) use ($catalog, $redirect, $byCategory) {
        $selection = (string) ($request->getQueryParams()['e'] ?? '');
        $item = null;
        if (preg_match('/^\d+$/', $selection) === 1) {
            $item = $catalog->item((int) $selection);
            if ($item === null) {
                return $redirect($response, '/dm/catalog/items');
            }
        }

        $list = $byCategory($catalog->itemList(), 'kind', (string) ($request->getQueryParams()['k'] ?? ''), $item['kind'] ?? null);

        return Twig::fromRequest($request)->render($response, 'dm/catalog_items.twig', [
            'catalogNav' => $catalog->navCounts(),
            'items' => $list['rows'],
            'kinds' => $list['counts'],
            'kind' => $list['selected'],
            'itemCount' => array_sum($list['counts']),
            'entity' => $item,
            'creating' => $selection === 'new',
        ]);
    });

    $app->post('/dm/catalog/items', fn (Request $request, Response $response) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $catalog->saveItem(null, $json($request)),
    ], 201)));

    $app->post('/dm/catalog/items/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($catalog, $json, $guard) {
        if ($catalog->item((int) $args['id']) === null) {
            return $response->withStatus(404);
        }

        return $guard($response, fn (): Response => jsonResponse($response, [
            'id' => $catalog->saveItem((int) $args['id'], $json($request)),
        ]));
    });

    $app->delete('/dm/catalog/items/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($catalog, $guard) {
        if ($catalog->item((int) $args['id']) === null) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($catalog, $response, $args): Response {
            $catalog->deleteItem((int) $args['id']);

            return jsonResponse($response, [
                'deleted' => true,
            ]);
        });
    });

    // ---------- bestiary ----------

    $app->get('/dm/catalog/bestiary', function (Request $request, Response $response) use ($catalog, $redirect, $byCategory) {
        $selection = (string) ($request->getQueryParams()['e'] ?? '');
        $creature = null;
        if (preg_match('/^\d+$/', $selection) === 1) {
            $creature = $catalog->creature((int) $selection);
            if ($creature === null) {
                return $redirect($response, '/dm/catalog/bestiary');
            }
        }

        $list = $byCategory($catalog->bestiaryList(), 'category_de', (string) ($request->getQueryParams()['k'] ?? ''), $creature['category_de'] ?? null);

        return Twig::fromRequest($request)->render($response, 'dm/catalog_bestiary.twig', [
            'catalogNav' => $catalog->navCounts(),
            'creatures' => $list['rows'],
            'groups' => $list['counts'],
            'group' => $list['selected'],
            'creatureCount' => array_sum($list['counts']),
            'entity' => $creature,
            'creating' => $selection === 'new',
            'categories' => $catalog->categories(),
        ]);
    });

    $app->post('/dm/catalog/bestiary', fn (Request $request, Response $response) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $catalog->saveCreature(null, $json($request)),
    ], 201)));

    $app->post('/dm/catalog/bestiary/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($catalog, $json, $guard) {
        if ($catalog->creature((int) $args['id']) === null) {
            return $response->withStatus(404);
        }

        return $guard($response, fn (): Response => jsonResponse($response, [
            'id' => $catalog->saveCreature((int) $args['id'], $json($request)),
        ]));
    });

    $app->delete('/dm/catalog/bestiary/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($catalog, $guard) {
        if ($catalog->creature((int) $args['id']) === null) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($catalog, $response, $args): Response {
            $catalog->deleteCreature((int) $args['id']);

            return jsonResponse($response, [
                'deleted' => true,
            ]);
        });
    });

    $app->post('/dm/catalog/bestiary/{id:[0-9]+}/image', function (Request $request, Response $response, array $args) use ($catalog): Response {
        $id = (int) $args['id'];
        if ($catalog->creature($id) === null) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['image'] ?? null, 'images/bestiary', $id);
        if (isset($stored['error'])) {
            return jsonResponse($response, [
                'error' => $stored['error'],
            ], 422);
        }
        $catalog->setCreatureImage($id, $stored['path']);

        return jsonResponse($response, [
            'image_path' => $stored['path'],
        ]);
    });

    // ---------- encounter tables (read-only) ----------

    $app->get('/dm/catalog/encounters', fn (Request $request, Response $response): Response => Twig::fromRequest($request)->render($response, 'dm/catalog_encounters.twig', [
        'catalogNav' => $catalog->navCounts(),
        'encounterTables' => $world->encounterTables(),
    ]));

    // ---------- party ----------

    $app->post('/dm/party', fn (Request $request, Response $response) => $guard($response, function () use ($catalog, $json, $request, $response): Response {
        $catalog->addToParty((int) ($json($request)['character_id'] ?? 0));

        return jsonResponse($response, [
            'added' => true,
        ], 201);
    }));

    $app->post('/dm/party/session-end', function (Request $request, Response $response) use ($catalog): Response {
        $catalog->resetMementos();

        return jsonResponse($response, [
            'reset' => true,
        ]);
    });

    $app->delete('/dm/party', function (Request $request, Response $response) use ($catalog): Response {
        $catalog->clearParty();

        return jsonResponse($response, [
            'cleared' => true,
        ]);
    });

    $app->delete('/dm/party/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($catalog): Response {
        $catalog->removeFromParty((int) $args['id']);

        return jsonResponse($response, [
            'removed' => true,
        ]);
    });
};
