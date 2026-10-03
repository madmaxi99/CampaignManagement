<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;

/**
 * DM routes of the campaigns: list, plan, play and every write endpoint.
 * All paths live under /dm, so DmGate already guards them (login + CSRF).
 */
return function (App $app, CampaignRepository $campaigns, CampaignStandRepository $stand): void {
    $json = fn (Request $request): array => json_decode((string) $request->getBody(), true) ?? [];

    /** Runs $action; an invalid input becomes a 422 with the message. */
    $guard = function (Response $response, callable $action) {
        try {
            return $action();
        } catch (InvalidArgumentException $e) {
            return jsonResponse($response, ['error' => $e->getMessage()], 422);
        }
    };

    /** Only calls the handler when {id} is an existing campaign, else 404. */
    $withCampaign = fn (callable $handler) => function (Request $request, Response $response, array $args) use ($campaigns, $handler) {
        $campaign = $campaigns->find((int) $args['id']);

        return $campaign === null ? $response->withStatus(404) : $handler($request, $response, $args, $campaign);
    };

    /** The view of the campaign entity a page (plan/play) works with. */
    $pageData = function (array $campaign) use ($campaigns): array {
        $id = (int) $campaign['id'];
        $npcs = $campaigns->npcs($id);
        $monsters = $campaigns->bestiary($id);
        $places = $campaigns->places($id);

        $registry = [];
        foreach ($places as $place) {
            if ($place['number_label'] !== null) {
                $registry[] = ['match' => '#' . $place['number_label'], 'type' => 'location', 'id' => (int) $place['id']];
            }
        }
        foreach ($monsters as $monster) {
            $registry[] = ['match' => $monster['name_de'], 'type' => 'bestiary', 'id' => (int) $monster['id']];
        }
        foreach ($npcs as $npc) {
            $registry[] = ['match' => $npc['name_de'], 'type' => 'npc', 'id' => (int) $npc['id']];
        }

        return [
            'campaign' => $campaign,
            'chapters' => $campaigns->chapters($id),
            'places' => $places,
            'placeTree' => $campaigns->placeTree($id),
            'npcs' => $npcs,
            'items' => $campaigns->items($id),
            'monsters' => $monsters,
            'entityRegistry' => $registry,
        ];
    };

    // ---------- list and campaign CRUD ----------

    $app->get('/dm', function (Request $request, Response $response) use ($campaigns) {
        $all = $campaigns->listAll();

        return Twig::fromRequest($request)->render($response, 'campaign/list.twig', [
            'defaultCampaigns' => array_values(array_filter($all, fn (array $c) => (bool) $c['is_default'])),
            'customCampaigns' => array_values(array_filter($all, fn (array $c) => !$c['is_default'])),
        ]);
    });

    $app->post('/dm/campaigns', function (Request $request, Response $response) use ($campaigns, $json, $guard) {
        return $guard($response, fn () => jsonResponse($response, ['id' => $campaigns->create($json($request))], 201));
    });

    $app->post('/dm/campaign/{id:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        return $guard($response, function () use ($campaigns, $json, $request, $response, $args) {
            $campaigns->update((int) $args['id'], $json($request));

            return jsonResponse($response, ['updated' => true]);
        });
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        return $campaigns->delete((int) $args['id'])
            ? jsonResponse($response, ['deleted' => true])
            : jsonResponse($response, ['error' => 'Standard-Abenteuer lassen sich nicht löschen, nur neu starten.'], 409);
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/restart', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        $campaigns->restart((int) $args['id']);

        return jsonResponse($response, ['restarted' => true]);
    }));

    // ---------- plan (edit) ----------

    $app->get('/dm/campaign/{id:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args, array $campaign) use ($campaigns, $pageData) {
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

        $collections = ['chapter' => $data['chapters'], 'place' => $data['places'], 'npc' => $data['npcs'], 'item' => $data['items']];
        $entity = null;
        if ($entityId !== null) {
            $found = array_values(array_filter($collections[$type] ?? [], fn (array $row) => (int) $row['id'] === $entityId));
            if ($found === []) {
                return $response->withHeader('Location', '/dm/campaign/' . $campaign['id'])->withStatus(302);
            }
            $entity = $found[0];
        }

        $query = $request->getQueryParams();

        return Twig::fromRequest($request)->render($response, 'campaign/plan.twig', $data + [
            'editorType' => $type,
            'entity' => $entity,
            'preset' => ['parent_id' => $query['parent'] ?? null, 'chapter_id' => $query['chapter'] ?? null, 'place_id' => $query['place'] ?? null],
            'monsterOptions' => $campaigns->monsterOptions((int) $campaign['id']),
            'bestiaryOptions' => $campaigns->bestiaryOptions(),
            'encounterTableOptions' => $campaigns->encounterTableOptions(),
        ]);
    }));

    // ---------- play ----------

    $app->get('/dm/campaign/{id:[0-9]+}/play', $withCampaign(function (Request $request, Response $response, array $args, array $campaign) use ($campaigns, $stand, $pageData) {
        return Twig::fromRequest($request)->render($response, 'campaign/play.twig', $pageData($campaign) + [
            'chronicle' => $stand->chronicle((int) $campaign['id']),
            'encounterTables' => $campaigns->encounterTables((int) $campaign['id']),
        ]);
    }));

    // ---------- chapters ----------

    $app->post('/dm/campaign/{id:[0-9]+}/chapters', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        return $guard($response, fn () => jsonResponse($response, ['id' => $campaigns->createChapter((int) $args['id'], $json($request))], 201));
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/chapters/{chapterId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        if (!$campaigns->chapterInCampaign((int) $args['id'], (int) $args['chapterId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($campaigns, $json, $request, $response, $args) {
            $campaigns->updateChapter((int) $args['id'], (int) $args['chapterId'], $json($request));

            return jsonResponse($response, ['updated' => true]);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/chapters/{chapterId:[0-9]+}/move', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json) {
        $direction = ($json($request)['direction'] ?? '') === 'up' ? 'up' : 'down';
        $campaigns->moveChapter((int) $args['id'], (int) $args['chapterId'], $direction);

        return jsonResponse($response, ['moved' => true]);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/chapters/{chapterId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        $campaigns->deleteChapter((int) $args['id'], (int) $args['chapterId']);

        return jsonResponse($response, ['deleted' => true]);
    }));

    // ---------- places ----------

    $app->post('/dm/campaign/{id:[0-9]+}/places', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        return $guard($response, fn () => jsonResponse($response, ['id' => $campaigns->createPlace((int) $args['id'], $json($request))], 201));
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        if (!$campaigns->placeInCampaign((int) $args['id'], (int) $args['placeId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($campaigns, $json, $request, $response, $args) {
            $campaigns->updatePlace((int) $args['id'], (int) $args['placeId'], $json($request));

            return jsonResponse($response, ['updated' => true]);
        });
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $guard) {
        if (!$campaigns->placeInCampaign((int) $args['id'], (int) $args['placeId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($campaigns, $response, $args) {
            $campaigns->deletePlace((int) $args['id'], (int) $args['placeId']);

            return jsonResponse($response, ['deleted' => true]);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}/image', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        $placeId = (int) $args['placeId'];
        if (!$campaigns->placeInCampaign((int) $args['id'], $placeId)) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['image'] ?? null, 'images/places', $placeId);
        if (isset($stored['error'])) {
            return jsonResponse($response, ['error' => $stored['error']], 422);
        }
        $campaigns->setPlaceImage($placeId, $stored['path']);

        return jsonResponse($response, ['image_path' => $stored['path']]);
    }));

    // ---------- NPCs ----------

    $app->post('/dm/campaign/{id:[0-9]+}/npcs', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        return $guard($response, fn () => jsonResponse($response, ['id' => $campaigns->createNpc((int) $args['id'], $json($request))], 201));
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        if (!$campaigns->npcInCampaign((int) $args['id'], (int) $args['npcId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($campaigns, $json, $request, $response, $args) {
            $campaigns->updateNpc((int) $args['id'], (int) $args['npcId'], $json($request));

            return jsonResponse($response, ['updated' => true]);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}/notes', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json) {
        if (!$campaigns->npcInCampaign((int) $args['id'], (int) $args['npcId'])) {
            return $response->withStatus(404);
        }
        $campaigns->setNpcNotes((int) $args['id'], (int) $args['npcId'], (string) ($json($request)['notes_de'] ?? ''));

        return jsonResponse($response, ['saved' => true]);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        if (!$campaigns->npcInCampaign((int) $args['id'], (int) $args['npcId'])) {
            return $response->withStatus(404);
        }
        $campaigns->deleteNpc((int) $args['id'], (int) $args['npcId']);

        return jsonResponse($response, ['deleted' => true]);
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}/portrait', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        $npcId = (int) $args['npcId'];
        if (!$campaigns->npcInCampaign((int) $args['id'], $npcId)) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['portrait'] ?? null, 'images/npcs', $npcId);
        if (isset($stored['error'])) {
            return jsonResponse($response, ['error' => $stored['error']], 422);
        }
        $campaigns->setNpcPortrait($npcId, $stored['path']);

        return jsonResponse($response, ['portrait_path' => $stored['path']]);
    }));

    // ---------- items ----------

    $app->post('/dm/campaign/{id:[0-9]+}/items', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        return $guard($response, fn () => jsonResponse($response, ['id' => $campaigns->createItem((int) $args['id'], $json($request))], 201));
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/items/{itemId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        if (!$campaigns->itemInCampaign((int) $args['id'], (int) $args['itemId'])) {
            return $response->withStatus(404);
        }

        return $guard($response, function () use ($campaigns, $json, $request, $response, $args) {
            $campaigns->updateItem((int) $args['id'], (int) $args['itemId'], $json($request));

            return jsonResponse($response, ['updated' => true]);
        });
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/items/{itemId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        if (!$campaigns->itemInCampaign((int) $args['id'], (int) $args['itemId'])) {
            return $response->withStatus(404);
        }
        $campaigns->deleteItem((int) $args['id'], (int) $args['itemId']);

        return jsonResponse($response, ['deleted' => true]);
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/items/{itemId:[0-9]+}/image', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        $itemId = (int) $args['itemId'];
        if (!$campaigns->itemInCampaign((int) $args['id'], $itemId)) {
            return $response->withStatus(404);
        }
        $stored = storeUploadedImage($request->getUploadedFiles()['image'] ?? null, 'images/items', $itemId);
        if (isset($stored['error'])) {
            return jsonResponse($response, ['error' => $stored['error']], 422);
        }
        $campaigns->setItemImage($itemId, $stored['path']);

        return jsonResponse($response, ['image_path' => $stored['path']]);
    }));

    // ---------- monsters of the campaign ----------

    $app->post('/dm/campaign/{id:[0-9]+}/monsters', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json, $guard) {
        return $guard($response, function () use ($campaigns, $json, $request, $response, $args) {
            $campaigns->addMonster((int) $args['id'], (int) ($json($request)['bestiary_id'] ?? 0));

            return jsonResponse($response, ['added' => true], 201);
        });
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/monsters/{bestiaryId:[0-9]+}/notes', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns, $json) {
        $campaigns->setMonsterNotes((int) $args['id'], (int) $args['bestiaryId'], (string) ($json($request)['notes_de'] ?? ''));

        return jsonResponse($response, ['saved' => true]);
    }));

    $app->delete('/dm/campaign/{id:[0-9]+}/monsters/{bestiaryId:[0-9]+}', $withCampaign(function (Request $request, Response $response, array $args) use ($campaigns) {
        $campaigns->removeMonster((int) $args['id'], (int) $args['bestiaryId']);

        return jsonResponse($response, ['deleted' => true]);
    }));

    // ---------- chronicle ----------

    $app->post('/dm/campaign/{id:[0-9]+}/chronicle', $withCampaign(function (Request $request, Response $response, array $args) use ($stand, $json, $guard) {
        return $guard($response, fn () => jsonResponse($response, ['id' => $stand->addChronicleEntry((int) $args['id'], $json($request))], 201));
    }));

    $app->post('/dm/campaign/{id:[0-9]+}/chronicle/{entryId:[0-9]+}', function (Request $request, Response $response, array $args) use ($stand, $json, $guard) {
        return $guard($response, function () use ($stand, $json, $request, $response, $args) {
            $found = $stand->updateChronicleEntry((int) $args['id'], (int) $args['entryId'], $json($request));

            return $found ? jsonResponse($response, ['updated' => true]) : $response->withStatus(404);
        });
    });

    $app->delete('/dm/campaign/{id:[0-9]+}/chronicle/{entryId:[0-9]+}', function (Request $request, Response $response, array $args) use ($stand) {
        return $stand->deleteChronicleEntry((int) $args['id'], (int) $args['entryId'])
            ? jsonResponse($response, ['deleted' => true])
            : $response->withStatus(404);
    });
};
