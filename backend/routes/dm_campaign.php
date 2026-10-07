<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Campaign\CampaignChapterRepository;
use Flyka\CampaignManagement\Campaign\CampaignItemRepository;
use Flyka\CampaignManagement\Campaign\CampaignMonsterRepository;
use Flyka\CampaignManagement\Campaign\CampaignNpcRepository;
use Flyka\CampaignManagement\Campaign\CampaignPlaceRepository;
use Flyka\CampaignManagement\Campaign\CampaignRepository;
use Flyka\CampaignManagement\CampaignStandRepository;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;
use function Flyka\CampaignManagement\Http\jsonResponse;
use function Flyka\CampaignManagement\Http\storeUploadedImage;

/**
 * DM routes of the campaigns: list, plan, play and every write endpoint.
 * All paths live under /dm, so DmGate already guards them (login + CSRF).
 */
return function (
    App $app,
    CampaignRepository $campaigns,
    CampaignChapterRepository $chapters,
    CampaignNpcRepository $npcs,
    CampaignPlaceRepository $places,
    CampaignItemRepository $items,
    CampaignMonsterRepository $monsters,
    CampaignStandRepository $stand
): void {
    $json = fn (Request $request): array => json_decode((string) $request->getBody(), true) ?? [];

    /** Runs $action; an invalid input becomes a 422 with the message. */
    $guard = function (Response $response, callable $action) {
        try {
            return $action();
        } catch (InvalidArgumentException $e) {
            return jsonResponse($response, [
                'error' => $e->getMessage(),
            ], 422);
        }
    };

    /** Only calls the handler when {id} is an existing campaign, else 404. */
    $withCampaign = fn (callable $handler): Closure => function (Request $request, Response $response, array $args) use ($campaigns, $handler) {
        $campaign = $campaigns->find((int) $args['id']);

        return $campaign === null ? $response->withStatus(404) : $handler($request, $response, $args, $campaign);
    };

    /** The view of the campaign entity a page (plan/play) works with. */
    $pageData = function (array $campaign) use ($chapters, $npcs, $places, $items, $monsters): array {
        $id = (int) $campaign['id'];
        $campaignNpcs = $npcs->npcs($id);
        $campaignMonsters = $monsters->bestiary($id);
        $campaignPlaces = $places->places($id);

        $registry = [];
        foreach ($campaignPlaces as $place) {
            if ($place['number_label'] !== null) {
                $registry[] = [
                    'match' => '#' . $place['number_label'],
                    'type' => 'location',
                    'id' => (int) $place['id'],
                ];
            }
        }
        foreach ($campaignMonsters as $monster) {
            $registry[] = [
                'match' => $monster['name_de'],
                'type' => 'bestiary',
                'id' => (int) $monster['id'],
            ];
        }
        foreach ($campaignNpcs as $npc) {
            $registry[] = [
                'match' => $npc['name_de'],
                'type' => 'npc',
                'id' => (int) $npc['id'],
            ];
        }

        return [
            'campaign' => $campaign,
            'chapters' => $chapters->chapters($id),
            'places' => $campaignPlaces,
            'placeTree' => $places->placeTree($id),
            'npcs' => $campaignNpcs,
            'items' => $items->items($id),
            'monsters' => $campaignMonsters,
            'entityRegistry' => $registry,
        ];
    };

    // ---------- list and campaign CRUD ----------

    $app->get('/dm', function (Request $request, Response $response) use ($campaigns): Response {
        $all = $campaigns->listAll();

        return Twig::fromRequest($request)->render($response, 'campaign/list.twig', [
            'defaultCampaigns' => array_values(array_filter($all, fn (array $c): bool => (bool) $c['is_default'])),
            'customCampaigns' => array_values(array_filter($all, fn (array $c): bool => ! $c['is_default'])),
        ]);
    });

    $app->post('/dm/campaigns', fn (Request $request, Response $response) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $campaigns->create($json($request)),
    ], 201)));

    $app->post('/dm/campaign/{id:[0-9]+}', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, function () use ($campaigns, $json, $request, $response, $args): Response {
        $campaigns->update((int) $args['id'], $json($request));

        return jsonResponse($response, [
            'updated' => true,
        ]);
    })));

    $app->delete('/dm/campaign/{id:[0-9]+}', $withCampaign(fn (Request $request, Response $response, array $args): Response => $campaigns->delete((int) $args['id'])
        ? jsonResponse($response, [
            'deleted' => true,
        ])
        : jsonResponse($response, [
            'error' => 'Standard-Abenteuer lassen sich nicht löschen, nur neu starten.',
        ], 409)));

    $app->post('/dm/campaign/{id:[0-9]+}/restart', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns): Response {
        $campaigns->restart((int) $args['id']);

        return jsonResponse($response, [
            'restarted' => true,
        ]);
    }));

    // ---------- plan (edit) ----------

    $app->get('/dm/campaign/{id:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args, array $campaign) use ($places, $monsters, $pageData) {
        $data = $pageData($campaign);

        $selection = (string) ($request->getQueryParams()['e'] ?? 'overview');
        $type = 'overview';
        $entityId = null;
        if (preg_match('/^(chapter|place|npc|item)-(new|\d+)$/', $selection, $m) === 1) {
            $type = $m[1];
            $entityId = $m[2] === 'new' ? null : (int) $m[2];
        } elseif ($selection === 'monsters') {
            $type = 'monsters';
        }

        $collections = [
            'chapter' => $data['chapters'],
            'place' => $data['places'],
            'npc' => $data['npcs'],
            'item' => $data['items'],
        ];
        $entity = null;
        if ($entityId !== null) {
            $found = array_values(array_filter($collections[$type] ?? [], fn (array $row): bool => (int) $row['id'] === $entityId));
            if ($found === []) {
                return $response->withHeader('Location', '/dm/campaign/' . $campaign['id'])->withStatus(302);
            }
            $entity = $found[0];
        }

        $query = $request->getQueryParams();

        return Twig::fromRequest($request)->render($response, 'campaign/plan.twig', $data + [
            'editorType' => $type,
            'entity' => $entity,
            'preset' => [
                'parent_id' => $query['parent'] ?? null,
                'chapter_id' => $query['chapter'] ?? null,
                'place_id' => $query['place'] ?? null,
            ],
            'monsterOptions' => $monsters->monsterOptions((int) $campaign['id']),
            'bestiaryOptions' => $monsters->bestiaryOptions(),
            'encounterTableOptions' => $places->encounterTableOptions(),
        ]);
    }));

    // ---------- play ----------

    $app->get('/dm/campaign/{id:[0-9]+}/play', $withCampaign(fn (Request $request, Response $response, array $args, array $campaign): Response => Twig::fromRequest($request)->render($response, 'campaign/play.twig', $pageData($campaign) + [
        'chronicle' => $stand->chronicle((int) $campaign['id']),
        'encounterTables' => $places->encounterTables((int) $campaign['id']),
    ])));

    // ---------- chapters ----------

    $app->post('/dm/campaign/{id:[0-9]+}/chapters', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $chapters->createChapter((int) $args['id'], $json($request)),
    ], 201))));

    $app->post('/dm/campaign/{id:[0-9]+}/chapters/{chapterId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($chapters, $json, $guard) {
        if (! $chapters->chapterInCampaign((int) $args['id'], (int) $args['chapterId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($chapters, $json, $request, $response, $args): Response {
            $chapters->updateChapter((int) $args['id'], (int) $args['chapterId'], $json($request));

            return jsonResponse($response, [
                'updated' => true,
            ]);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/chapters/{chapterId:[0-9]+}/move', $withCampaign(function (Request $request, Response $response, array $args) use ($chapters, $json): Response {
        $direction = ($json($request)['direction'] ?? '') === 'up' ? 'up' : 'down';
        $chapters->moveChapter((int) $args['id'], (int) $args['chapterId'], $direction);

        return jsonResponse($response, [
            'moved' => true,
        ]);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/chapters/{chapterId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($chapters): Response {
        $chapters->deleteChapter((int) $args['id'], (int) $args['chapterId']);

        return jsonResponse($response, [
            'deleted' => true,
        ]);
    }));

    // ---------- places ----------

    $app->post('/dm/campaign/{id:[0-9]+}/places', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $places->createPlace((int) $args['id'], $json($request)),
    ], 201))));

    $app->post('/dm/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($places, $json, $guard) {
        if (! $places->placeInCampaign((int) $args['id'], (int) $args['placeId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($places, $json, $request, $response, $args): Response {
            $places->updatePlace((int) $args['id'], (int) $args['placeId'], $json($request));

            return jsonResponse($response, [
                'updated' => true,
            ]);
        });
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($places, $guard) {
        if (! $places->placeInCampaign((int) $args['id'], (int) $args['placeId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($places, $response, $args): Response {
            $places->deletePlace((int) $args['id'], (int) $args['placeId']);

            return jsonResponse($response, [
                'deleted' => true,
            ]);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}/image', $withCampaign(function (Request $request, Response $response, array $args) use ($places): Response {
        $placeId = (int) $args['placeId'];
        if (! $places->placeInCampaign((int) $args['id'], $placeId)) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['image'] ?? null, 'images/places', $placeId);
        if (isset($stored['error'])) {
            return jsonResponse($response, [
                'error' => $stored['error'],
            ], 422);
        }
        $places->setPlaceImage($placeId, $stored['path']);

        return jsonResponse($response, [
            'image_path' => $stored['path'],
        ]);
    }));

    // ---------- NPCs ----------

    $app->post('/dm/campaign/{id:[0-9]+}/npcs', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $npcs->createNpc((int) $args['id'], $json($request)),
    ], 201))));

    $app->post('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($npcs, $json, $guard) {
        if (! $npcs->npcInCampaign((int) $args['id'], (int) $args['npcId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($npcs, $json, $request, $response, $args): Response {
            $npcs->updateNpc((int) $args['id'], (int) $args['npcId'], $json($request));

            return jsonResponse($response, [
                'updated' => true,
            ]);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}/notes', $withCampaign(function (Request $request, Response $response, array $args) use ($npcs, $json): Response {
        if (! $npcs->npcInCampaign((int) $args['id'], (int) $args['npcId'])) {
            return $response->withStatus(404);
        }
        $npcs->setNpcNotes((int) $args['id'], (int) $args['npcId'], (string) ($json($request)['notes_de'] ?? ''));

        return jsonResponse($response, [
            'saved' => true,
        ]);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($npcs): Response {
        if (! $npcs->npcInCampaign((int) $args['id'], (int) $args['npcId'])) {
            return $response->withStatus(404);
        }
        $npcs->deleteNpc((int) $args['id'], (int) $args['npcId']);

        return jsonResponse($response, [
            'deleted' => true,
        ]);
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}/portrait', $withCampaign(function (Request $request, Response $response, array $args) use ($npcs): Response {
        $npcId = (int) $args['npcId'];
        if (! $npcs->npcInCampaign((int) $args['id'], $npcId)) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['portrait'] ?? null, 'images/npcs', $npcId);
        if (isset($stored['error'])) {
            return jsonResponse($response, [
                'error' => $stored['error'],
            ], 422);
        }
        $npcs->setNpcPortrait($npcId, $stored['path']);

        return jsonResponse($response, [
            'portrait_path' => $stored['path'],
        ]);
    }));

    // ---------- items ----------

    $app->post('/dm/campaign/{id:[0-9]+}/items', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $items->createItem((int) $args['id'], $json($request)),
    ], 201))));

    $app->post('/dm/campaign/{id:[0-9]+}/items/{itemId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($items, $json, $guard) {
        if (! $items->itemInCampaign((int) $args['id'], (int) $args['itemId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($items, $json, $request, $response, $args): Response {
            $items->updateItem((int) $args['id'], (int) $args['itemId'], $json($request));

            return jsonResponse($response, [
                'updated' => true,
            ]);
        });
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/items/{itemId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($items): Response {
        if (! $items->itemInCampaign((int) $args['id'], (int) $args['itemId'])) {
            return $response->withStatus(404);
        }
        $items->deleteItem((int) $args['id'], (int) $args['itemId']);

        return jsonResponse($response, [
            'deleted' => true,
        ]);
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/items/{itemId:[0-9]+}/image', $withCampaign(function (Request $request, Response $response, array $args) use ($items): Response {
        $itemId = (int) $args['itemId'];
        if (! $items->itemInCampaign((int) $args['id'], $itemId)) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['image'] ?? null, 'images/items', $itemId);
        if (isset($stored['error'])) {
            return jsonResponse($response, [
                'error' => $stored['error'],
            ], 422);
        }
        $items->setItemImage($itemId, $stored['path']);

        return jsonResponse($response, [
            'image_path' => $stored['path'],
        ]);
    }));

    // ---------- monsters of the campaign ----------

    $app->post('/dm/campaign/{id:[0-9]+}/monsters', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, function () use ($monsters, $json, $request, $response, $args): Response {
        $monsters->addMonster((int) $args['id'], (int) ($json($request)['bestiary_id'] ?? 0));

        return jsonResponse($response, [
            'added' => true,
        ], 201);
    })));

    $app->post('/dm/campaign/{id:[0-9]+}/monsters/{bestiaryId:[0-9]+}/notes', $withCampaign(function (Request $request, Response $response, array $args) use ($monsters, $json): Response {
        $monsters->setMonsterNotes((int) $args['id'], (int) $args['bestiaryId'], (string) ($json($request)['notes_de'] ?? ''));

        return jsonResponse($response, [
            'saved' => true,
        ]);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/monsters/{bestiaryId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($monsters): Response {
        $monsters->removeMonster((int) $args['id'], (int) $args['bestiaryId']);

        return jsonResponse($response, [
            'deleted' => true,
        ]);
    }));

    // ---------- chronicle ----------

    $app->post('/dm/campaign/{id:[0-9]+}/chronicle', $withCampaign(fn (Request $request, Response $response, array $args) => $guard($response, fn (): Response => jsonResponse($response, [
        'id' => $stand->addChronicleEntry((int) $args['id'], $json($request)),
    ], 201))));

    $app->post('/dm/campaign/{id:[0-9]+}/chronicle/{entryId:[0-9]+}', fn (Request $request, Response $response, array $args) => $guard($response, function () use ($stand, $json, $request, $response, $args): Response {
        $found = $stand->updateChronicleEntry((int) $args['id'], (int) $args['entryId'], $json($request));

        return $found ? jsonResponse($response, [
            'updated' => true,
        ]) : $response->withStatus(404);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/chronicle/{entryId:[0-9]+}', fn (Request $request, Response $response, array $args): Response => $stand->deleteChronicleEntry((int) $args['id'], (int) $args['entryId'])
        ? jsonResponse($response, [
            'deleted' => true,
        ])
        : $response->withStatus(404));
};
