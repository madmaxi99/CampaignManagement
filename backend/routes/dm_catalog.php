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
 * encounter tables and the party overview. All under /dm, so DmGate guards them.
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

    $app->get('/dm/catalog/items', function (Request $request, Response $response) use ($catalog, $redirect) {
        $selection = (string) ($request->getQueryParams()['e'] ?? '');
        $item = null;
        if (preg_match('/^\d+$/', $selection) === 1) {
            $item = $catalog->item((int) $selection);
            if ($item === null) {
                return $redirect($response, '/dm/catalog/items');
            }
        }

        return Twig::fromRequest($request)->render($response, 'dm/catalog_items.twig', [
            'items' => $catalog->itemList(),
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

    $app->get('/dm/catalog/bestiary', function (Request $request, Response $response) use ($catalog, $redirect) {
        $selection = (string) ($request->getQueryParams()['e'] ?? '');
        $creature = null;
        if (preg_match('/^\d+$/', $selection) === 1) {
            $creature = $catalog->creature((int) $selection);
            if ($creature === null) {
                return $redirect($response, '/dm/catalog/bestiary');
            }
        }

        return Twig::fromRequest($request)->render($response, 'dm/catalog_bestiary.twig', [
            'creatures' => $catalog->bestiaryList(),
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
        'encounterTables' => $world->encounterTables(),
    ]));

    // ---------- party ----------

    $app->get('/dm/party', fn (Request $request, Response $response): Response => Twig::fromRequest($request)->render($response, 'dm/party.twig', [
        'members' => $catalog->party(),
        'candidates' => $catalog->partyCandidates(),
    ]));

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
