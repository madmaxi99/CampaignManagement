<?php

declare(strict_types=1);

use Slim\Factory\AppFactory;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . '/../src/Database.php';
require __DIR__ . '/../src/CharacterRepository.php';
require __DIR__ . '/../src/CampaignRepository.php';
require __DIR__ . '/../src/CampaignStandRepository.php';
require __DIR__ . '/../src/WorldRepository.php';
require __DIR__ . '/../src/EntityLinker.php';
require __DIR__ . '/../src/CharacterCreationRepository.php';

$db = Database::connect();
$characterRepository = new CharacterRepository($db);
$campaignRepository = new CampaignRepository($db);
$standRepository = new CampaignStandRepository($db);
$worldRepository = new WorldRepository($db);
$characterCreationRepository = new CharacterCreationRepository($db);

$app = AppFactory::create();

$twig = Twig::create(__DIR__ . '/../templates', ['cache' => false]);
$app->add(TwigMiddleware::create($app, $twig));
$twig->getEnvironment()->addFilter(new \Twig\TwigFilter('linkify', [EntityLinker::class, 'linkify'], ['is_safe' => ['html']]));

function loadSheet(CharacterRepository $repository, int $id): ?array
{
    $character = $repository->findById($id);
    if ($character === null) {
        return null;
    }

    $characterId = (int) $character['id'];
    $attributes = $repository->attributes($characterId);
    $character = $character + $repository->derivedStats($character, $attributes);

    return [
        'character' => $character,
        'attributes' => $attributes,
        'conditions' => $repository->conditions($characterId),
        'regularSkills' => $repository->skillsByCategory($characterId, 'regular'),
        'combatSkills' => $repository->skillsByCategory($characterId, 'combat'),
        'secondarySkills' => $repository->skillsByCategory($characterId, 'secondary'),
        'talents' => $repository->talents($characterId),
        'spells' => $repository->spells($characterId),
        'weapons' => $repository->weapons($characterId),
        'armor' => $repository->armor($characterId),
        'inventory' => $repository->inventory($characterId),
    ];
}

function jsonResponse(Response $response, array $data, int $status = 200): Response
{
    $response->getBody()->write(json_encode($data));

    return $response->withHeader('Content-Type', 'application/json')->withStatus($status);
}

/**
 * Stores an uploaded JPG/PNG/WebP as public/<dir>/<id>.<ext>, replacing a
 * previous file of the same id with another extension.
 *
 * @return array{path: string}|array{error: string}
 */
function storeUploadedImage(?\Psr\Http\Message\UploadedFileInterface $file, string $dir, int $id): array
{
    if ($file === null || $file->getError() !== UPLOAD_ERR_OK) {
        return ['error' => 'Keine gültige Bilddatei übermittelt.'];
    }
    if ($file->getSize() > 5 * 1024 * 1024) {
        return ['error' => 'Datei ist zu groß (max. 5 MB).'];
    }

    $extensions = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    $extension = $extensions[$file->getClientMediaType()] ?? null;
    if ($extension === null) {
        return ['error' => 'Nur JPG, PNG oder WebP erlaubt.'];
    }

    $targetDir = __DIR__ . '/' . $dir;
    if (!is_dir($targetDir)) {
        mkdir($targetDir, 0755, true);
    }
    $targetPath = $targetDir . '/' . $id . '.' . $extension;
    $file->moveTo($targetPath);

    if (getimagesize($targetPath) === false) {
        unlink($targetPath);

        return ['error' => 'Datei ist kein gültiges Bild.'];
    }

    foreach (array_diff($extensions, [$extension]) as $otherExtension) {
        $old = $targetDir . '/' . $id . '.' . $otherExtension;
        if (is_file($old)) {
            unlink($old);
        }
    }

    return ['path' => $dir . '/' . $id . '.' . $extension];
}

/**
 * Wraps a route handler so it only runs once the character behind {id}
 * was found, passing it in as the fourth argument; otherwise responds 404.
 */
function withCharacter(CharacterRepository $repository, callable $handler): callable
{
    return function (Request $request, Response $response, array $args) use ($repository, $handler) {
        $character = $repository->findById((int) $args['id']);
        if ($character === null) {
            return $response->withStatus(404);
        }

        return $handler($request, $response, $args, $character);
    };
}

$app->get('/api/character-creation/catalog', function (Request $request, Response $response) use ($characterCreationRepository) {
    return jsonResponse($response, $characterCreationRepository->catalog());
});

$app->post('/characters', function (Request $request, Response $response) use ($characterCreationRepository) {
    $body = json_decode((string) $request->getBody(), true) ?? [];

    try {
        $characterId = $characterCreationRepository->createCharacter($body);
    } catch (InvalidArgumentException $e) {
        $response->getBody()->write(json_encode(['error' => $e->getMessage()]));

        return $response->withHeader('Content-Type', 'application/json')->withStatus(422);
    }

    return jsonResponse($response, ['id' => $characterId]);
});

$app->get('/characters', function (Request $request, Response $response) use ($characterRepository) {
    $twig = Twig::fromRequest($request);

    $characters = $characterRepository->listAll();
    $defaultCharacters = array_values(array_filter($characters, fn (array $c) => (bool) $c['is_default']));
    $customCharacters = array_values(array_filter($characters, fn (array $c) => !$c['is_default']));

    return $twig->render($response, 'characters/list.twig', [
        'defaultCharacters' => $defaultCharacters,
        'customCharacters' => $customCharacters,
    ]);
});

$app->get('/world', function (Request $request, Response $response) use ($worldRepository) {
    return Twig::fromRequest($request)->render($response, 'world.twig', [
        'bestiary' => $worldRepository->bestiary(),
        'encounterTables' => $worldRepository->encounterTables(),
    ]);
});

$app->get('/campaign', function (Request $request, Response $response) use ($campaignRepository) {
    $twig = Twig::fromRequest($request);

    $campaigns = $campaignRepository->listAll();
    $defaultCampaigns = array_values(array_filter($campaigns, fn (array $c) => (bool) $c['is_default']));
    $customCampaigns = array_values(array_filter($campaigns, fn (array $c) => !$c['is_default']));

    return $twig->render($response, 'campaign/list.twig', [
        'defaultCampaigns' => $defaultCampaigns,
        'customCampaigns' => $customCampaigns,
    ]);
});

$app->get('/campaign/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($campaignRepository, $standRepository) {
    $campaign = $campaignRepository->find((int) $args['id']);
    if ($campaign === null) {
        return $response->withStatus(404);
    }

    $campaignId = (int) $campaign['id'];
    $twig = Twig::fromRequest($request);

    $locations = $campaignRepository->locations($campaignId);
    $bestiary = $campaignRepository->bestiary($campaignId);
    $npcs = $campaignRepository->npcs($campaignId);
    $places = $campaignRepository->places($campaignId);

    $entityRegistry = [];
    foreach ($locations as $location) {
        $entityRegistry[] = ['match' => '#' . $location['number_label'], 'type' => 'location', 'id' => (int) $location['id']];
    }
    foreach ($bestiary as $creature) {
        $entityRegistry[] = ['match' => $creature['name_de'], 'type' => 'bestiary', 'id' => (int) $creature['id']];
    }
    foreach ($npcs as $npc) {
        $entityRegistry[] = ['match' => $npc['name_de'], 'type' => 'npc', 'id' => (int) $npc['id']];
    }

    return $twig->render($response, 'campaign/dm_screen.twig', [
        'campaign' => $campaign,
        'chapters' => $campaignRepository->chapters($campaignId),
        'locations' => $locations,
        'bestiary' => $bestiary,
        'npcs' => $npcs,
        'npcFormData' => [
            'bestiary' => $campaignRepository->bestiaryOptions(),
            'npcs' => array_column(array_map(fn (array $n) => [
                'id' => (int) $n['id'],
                'values' => [
                    'name_de' => $n['name_de'], 'description_de' => $n['description_de'], 'dm_text_de' => $n['dm_text_de'],
                    'notes_de' => $n['notes_de'], 'found_hint_de' => $n['found_hint_de'], 'bestiary_id' => $n['bestiary_id'],
                ],
            ], $npcs), 'values', 'id'),
        ],
        'places' => $places,
        'items' => $campaignRepository->items($campaignId),
        'encounterTableOptions' => $campaignRepository->encounterTableOptions(),
        'placeFormData' => array_column(array_map(fn (array $p) => [
            'id' => (int) $p['id'],
            'values' => [
                'name_de' => $p['name_de'], 'parent_id' => $p['parent_id'],
                'description_de' => $p['description_de'], 'dm_text_de' => $p['dm_text_de'],
                'encounter_table_id' => $p['encounter_table_id'],
            ],
        ], $places), 'values', 'id'),
        'chronicle' => $standRepository->chronicle($campaignId),
        'encounterTables' => $campaignRepository->encounterTables($campaignId),
        'entityRegistry' => $entityRegistry,
    ]);
});

$app->post('/campaign/{id:[0-9]+}/npcs', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    if ($campaignRepository->find((int) $args['id']) === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true) ?? [];
    try {
        $npcId = $campaignRepository->createNpc((int) $args['id'], $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['id' => $npcId], 201);
});

$app->post('/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    $campaignId = (int) $args['id'];
    $npcId = (int) $args['npcId'];
    if (!$campaignRepository->npcInCampaign($campaignId, $npcId)) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true) ?? [];
    try {
        $campaignRepository->updateNpc($campaignId, $npcId, $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['updated' => true]);
});

$app->post('/campaign/{id:[0-9]+}/npcs/{npcId:[0-9]+}/portrait', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    $campaignId = (int) $args['id'];
    $npcId = (int) $args['npcId'];
    if (!$campaignRepository->npcInCampaign($campaignId, $npcId)) {
        return $response->withStatus(404);
    }

    $stored = storeUploadedImage($request->getUploadedFiles()['portrait'] ?? null, 'images/npcs', $npcId);
    if (isset($stored['error'])) {
        return jsonResponse($response, ['error' => $stored['error']], 422);
    }
    $campaignRepository->setNpcPortrait($npcId, $stored['path']);

    return jsonResponse($response, ['portrait_path' => $stored['path']]);
});

$app->post('/campaign/{id:[0-9]+}/restart', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    if ($campaignRepository->find((int) $args['id']) === null) {
        return $response->withStatus(404);
    }
    $campaignRepository->restart((int) $args['id']);

    return jsonResponse($response, ['restarted' => true]);
});

$app->post('/campaign/{id:[0-9]+}/places', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    if ($campaignRepository->find((int) $args['id']) === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true) ?? [];
    try {
        $placeId = $campaignRepository->createPlace((int) $args['id'], $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['id' => $placeId], 201);
});

$app->post('/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    $campaignId = (int) $args['id'];
    $placeId = (int) $args['placeId'];
    if (!$campaignRepository->placeInCampaign($campaignId, $placeId)) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true) ?? [];
    try {
        $campaignRepository->updatePlace($campaignId, $placeId, $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['updated' => true]);
});

$app->post('/campaign/{id:[0-9]+}/places/{placeId:[0-9]+}/image', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    $placeId = (int) $args['placeId'];
    if (!$campaignRepository->placeInCampaign((int) $args['id'], $placeId)) {
        return $response->withStatus(404);
    }

    $stored = storeUploadedImage($request->getUploadedFiles()['image'] ?? null, 'images/places', $placeId);
    if (isset($stored['error'])) {
        return jsonResponse($response, ['error' => $stored['error']], 422);
    }
    $campaignRepository->setPlaceImage($placeId, $stored['path']);

    return jsonResponse($response, ['image_path' => $stored['path']]);
});

$app->post('/campaign/{id:[0-9]+}/chronicle', function (Request $request, Response $response, array $args) use ($campaignRepository, $standRepository) {
    if ($campaignRepository->find((int) $args['id']) === null) {
        return $response->withStatus(404);
    }
    $body = json_decode((string) $request->getBody(), true) ?? [];
    try {
        $entryId = $standRepository->addChronicleEntry((int) $args['id'], $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['id' => $entryId], 201);
});

$app->post('/campaign/{id:[0-9]+}/chronicle/{entryId:[0-9]+}', function (Request $request, Response $response, array $args) use ($standRepository) {
    $body = json_decode((string) $request->getBody(), true) ?? [];
    try {
        $found = $standRepository->updateChronicleEntry((int) $args['id'], (int) $args['entryId'], $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return $found ? jsonResponse($response, ['updated' => true]) : $response->withStatus(404);
});

$app->delete('/campaign/{id:[0-9]+}/chronicle/{entryId:[0-9]+}', function (Request $request, Response $response, array $args) use ($standRepository) {
    return $standRepository->deleteChronicleEntry((int) $args['id'], (int) $args['entryId'])
        ? jsonResponse($response, ['deleted' => true])
        : $response->withStatus(404);
});

$app->get('/character/create', function (Request $request, Response $response) {
    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/create.twig');
});

$app->get('/character/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $sheet = loadSheet($characterRepository, (int) $args['id']);
    if ($sheet === null) {
        return $response->withStatus(404);
    }

    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/sheet.twig', $sheet);
});

$app->post('/character/{id:[0-9]+}/hp', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setHp((int) $character['id'], (int) $body['value']);

    return jsonResponse($response, ['hp_current' => $newValue]);
}));

$app->post('/character/{id:[0-9]+}/wp', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setWp((int) $character['id'], (int) $body['value']);

    return jsonResponse($response, ['wp_current' => $newValue]);
}));

$app->post('/character/{id:[0-9]+}/conditions/{code}/toggle', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $active = $characterRepository->toggleCondition((int) $character['id'], $args['code']);

    return jsonResponse($response, ['code' => $args['code'], 'active' => $active]);
}));

$app->post('/character/{id:[0-9]+}/currency', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setCurrency(
        (int) $character['id'],
        (int) $body['gold'],
        (int) $body['silver'],
        (int) $body['copper']
    );

    return jsonResponse($response, ['gold' => max(0, (int) $body['gold']), 'silver' => max(0, (int) $body['silver']), 'copper' => max(0, (int) $body['copper'])]);
}));

$app->post('/character/{id:[0-9]+}/skills/{skillId}/mark', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setSkillMark((int) $character['id'], (int) $args['skillId'], (bool) $body['marked']);

    return jsonResponse($response, ['skill_id' => (int) $args['skillId'], 'marked' => (bool) $body['marked']]);
}));

$app->post('/character/{id:[0-9]+}/skills/{skillId}/advance', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->advanceSkill((int) $character['id'], (int) $args['skillId'], (bool) $body['apply']);

    return jsonResponse($response, ['skill_id' => (int) $args['skillId'], 'value' => $newValue]);
}));

$app->post('/character/{id:[0-9]+}/spells', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->learnSpell((int) $character['id'], (int) $body['spell_id']);

    return jsonResponse($response, ['learned' => true]);
}));

$app->get('/character/{id:[0-9]+}/levelup', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $characterId = (int) $character['id'];
    $secondarySkills = $characterRepository->skillsByCategory($characterId, 'secondary');
    $untrainedSchoolSkills = array_values(array_filter($secondarySkills, static fn (array $s) => (int) $s['value'] === 0));

    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/levelup.twig', [
        'character' => $character,
        'markedSkills' => $characterRepository->markedSkills($characterId),
        'learnableHeroicAbilities' => $characterRepository->learnableHeroicAbilities($characterId, $character['profession_code']),
        'untrainedSchoolSkills' => $untrainedSchoolSkills,
        'availableSpells' => $characterRepository->availableSpells($characterId, $characterRepository->trainedSchoolSkillIds($characterId)),
    ]);
}));

$app->post('/character/{id:[0-9]+}/heroic-abilities', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true) ?? [];
    $ability = $characterRepository->heroicAbilityById((int) ($body['heroic_ability_id'] ?? 0));
    if ($ability === null) {
        return jsonResponse($response, ['error' => 'Unbekanntes Talent.'], 422);
    }

    $characterRepository->learnHeroicAbility((int) $character['id'], $ability);

    if ($ability['name_de'] === 'Magisches Talent' && isset($body['school_skill_id'])) {
        $characterRepository->trainSkill((int) $character['id'], (int) $body['school_skill_id']);
    }

    return jsonResponse($response, ['learned' => true]);
}));

foreach (['weapons' => 'Weapon', 'inventory' => 'InventoryItem'] as $segment => $methodSuffix) {
    $app->post("/character/{id:[0-9]+}/{$segment}", withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix) {
        $addMethod = 'add' . $methodSuffix;
        $rowId = $characterRepository->$addMethod((int) $character['id']);

        return jsonResponse($response, ['added' => true, 'row_id' => $rowId]);
    }));

    $app->post("/character/{id:[0-9]+}/{$segment}/{rowId}", withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix) {
        $body = json_decode((string) $request->getBody(), true) ?? [];
        $updateMethod = 'update' . $methodSuffix;
        $characterRepository->$updateMethod((int) $character['id'], (int) $args['rowId'], $body);

        return jsonResponse($response, ['updated' => true]);
    }));

    $app->delete("/character/{id:[0-9]+}/{$segment}/{rowId}", withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix) {
        $removeMethod = 'remove' . $methodSuffix;
        $characterRepository->$removeMethod((int) $character['id'], (int) $args['rowId']);

        return jsonResponse($response, ['removed' => true]);
    }));
}

$app->post('/character/{id:[0-9]+}/armor/{slot}', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true) ?? [];

    try {
        $characterRepository->updateArmorSlot((int) $character['id'], (string) $args['slot'], $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['updated' => true]);
}));

$app->delete('/character/{id:[0-9]+}', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    if ((bool) $character['is_default']) {
        return jsonResponse($response, ['error' => 'Default-Charaktere können nicht gelöscht werden.'], 403);
    }

    if ($character['portrait_path'] !== null && str_starts_with($character['portrait_path'], 'images/characters/uploads/')) {
        $path = __DIR__ . '/' . $character['portrait_path'];
        if (is_file($path)) {
            unlink($path);
        }
    }

    $characterRepository->delete((int) $character['id']);

    return jsonResponse($response, ['deleted' => true]);
}));

// Portraits are permanent once set (default roster seed data, or this
// upload) -- see the schema.sql comment on characters.portrait_path.
$app->post('/character/{id:[0-9]+}/portrait', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    if ($character['portrait_path'] !== null) {
        return jsonResponse($response, ['error' => 'Dieser Charakter hat bereits ein Bild.'], 409);
    }

    $file = $request->getUploadedFiles()['portrait'] ?? null;
    if ($file === null || $file->getError() !== UPLOAD_ERR_OK) {
        return jsonResponse($response, ['error' => 'Keine gültige Bilddatei übermittelt.'], 422);
    }
    if ($file->getSize() > 5 * 1024 * 1024) {
        return jsonResponse($response, ['error' => 'Datei ist zu groß (max. 5 MB).'], 422);
    }

    $extensions = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    $extension = $extensions[$file->getClientMediaType()] ?? null;
    if ($extension === null) {
        return jsonResponse($response, ['error' => 'Nur JPG, PNG oder WebP erlaubt.'], 422);
    }

    $characterId = (int) $character['id'];
    $targetDir = __DIR__ . '/images/characters/uploads';
    if (!is_dir($targetDir)) {
        mkdir($targetDir, 0755, true);
    }
    $targetPath = $targetDir . '/' . $characterId . '.' . $extension;
    $file->moveTo($targetPath);

    if (getimagesize($targetPath) === false) {
        unlink($targetPath);

        return jsonResponse($response, ['error' => 'Datei ist kein gültiges Bild.'], 422);
    }

    $relativePath = 'images/characters/uploads/' . $characterId . '.' . $extension;
    if (!$characterRepository->setPortraitPath($characterId, $relativePath)) {
        unlink($targetPath);

        return jsonResponse($response, ['error' => 'Dieser Charakter hat bereits ein Bild.'], 409);
    }

    return jsonResponse($response, ['portrait_path' => $relativePath]);
}));

$app->run();
