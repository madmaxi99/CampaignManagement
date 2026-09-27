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
require __DIR__ . '/../src/EntityLinker.php';
require __DIR__ . '/../src/CharacterCreationRepository.php';

$db = Database::connect();
$characterRepository = new CharacterRepository($db);
$campaignRepository = new CampaignRepository($db);
$characterCreationRepository = new CharacterCreationRepository($db);

$app = AppFactory::create();

$twig = Twig::create(__DIR__ . '/../templates', ['cache' => false]);
$app->add(TwigMiddleware::create($app, $twig));
$twig->getEnvironment()->addFilter(new \Twig\TwigFilter('linkify', [EntityLinker::class, 'linkify'], ['is_safe' => ['html']]));

function loadSheet(CharacterRepository $repository, string $slug): ?array
{
    $character = $repository->findBySlug($slug);
    if ($character === null) {
        return null;
    }

    $characterId = (int) $character['id'];

    return [
        'character' => $character,
        'attributes' => $repository->attributes($characterId),
        'conditions' => $repository->conditions($characterId),
        'regularSkills' => $repository->skillsByCategory($characterId, 'regular'),
        'combatSkills' => $repository->skillsByCategory($characterId, 'combat'),
        'secondarySkills' => $repository->skillsByCategory($characterId, 'secondary'),
        'markedSkills' => $repository->markedSkills($characterId),
        'talents' => $repository->talents($characterId),
        'spells' => $repository->spells($characterId),
        'availableSpells' => $repository->availableSpells($characterId),
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
 * Wraps a route handler so it only runs once the character behind {slug}
 * was found, passing it in as the fourth argument; otherwise responds 404.
 */
function withCharacter(CharacterRepository $repository, callable $handler): callable
{
    return function (Request $request, Response $response, array $args) use ($repository, $handler) {
        $character = $repository->findBySlug($args['slug']);
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
        $slug = $characterCreationRepository->createCharacter($body);
    } catch (InvalidArgumentException $e) {
        $response->getBody()->write(json_encode(['error' => $e->getMessage()]));

        return $response->withHeader('Content-Type', 'application/json')->withStatus(422);
    }

    return jsonResponse($response, ['slug' => $slug]);
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

$app->get('/campaign/{slug}', function (Request $request, Response $response, array $args) use ($campaignRepository) {
    $campaign = $campaignRepository->findBySlug($args['slug']);
    if ($campaign === null) {
        return $response->withStatus(404);
    }

    $campaignId = (int) $campaign['id'];
    $twig = Twig::fromRequest($request);

    $locations = $campaignRepository->locations($campaignId);
    $creatures = $campaignRepository->creatures($campaignId);
    $npcs = $campaignRepository->npcs($campaignId);

    $entityRegistry = [];
    foreach ($locations as $location) {
        $entityRegistry[] = ['match' => '#' . $location['number_label'], 'type' => 'location', 'id' => (int) $location['id']];
    }
    foreach ($creatures as $creature) {
        $entityRegistry[] = ['match' => $creature['name_de'], 'type' => 'creature', 'id' => (int) $creature['id']];
    }
    foreach ($npcs as $npc) {
        $entityRegistry[] = ['match' => $npc['name_de'], 'type' => 'npc', 'id' => (int) $npc['id']];
    }

    $eventTables = $campaignRepository->eventTables($campaignId);
    if (count($eventTables) <= 1) {
        $recurringEventTables = [];
        $endingEventTable = $eventTables[0] ?? null;
    } else {
        $recurringEventTables = $eventTables;
        $endingEventTable = array_pop($recurringEventTables);
    }

    return $twig->render($response, 'campaign/dm_screen.twig', [
        'campaign' => $campaign,
        'chapters' => $campaignRepository->chapters($campaignId),
        'locations' => $locations,
        'creatures' => $creatures,
        'npcs' => $npcs,
        'recurringEventTables' => $recurringEventTables,
        'endingEventTable' => $endingEventTable,
        'entityRegistry' => $entityRegistry,
    ]);
});

$app->get('/character/create', function (Request $request, Response $response) {
    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/create.twig');
});

$app->get('/character/{slug}', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $sheet = loadSheet($characterRepository, $args['slug']);
    if ($sheet === null) {
        return $response->withStatus(404);
    }

    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/sheet.twig', $sheet);
});

$app->post('/character/{slug}/hp', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setHp((int) $character['id'], (int) $body['value']);

    return jsonResponse($response, ['hp_current' => $newValue]);
}));

$app->post('/character/{slug}/wp', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setWp((int) $character['id'], (int) $body['value']);

    return jsonResponse($response, ['wp_current' => $newValue]);
}));

$app->post('/character/{slug}/conditions/{code}/toggle', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $active = $characterRepository->toggleCondition((int) $character['id'], $args['code']);

    return jsonResponse($response, ['code' => $args['code'], 'active' => $active]);
}));

$app->post('/character/{slug}/currency', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setCurrency(
        (int) $character['id'],
        (int) $body['gold'],
        (int) $body['silver'],
        (int) $body['copper']
    );

    return jsonResponse($response, ['gold' => max(0, (int) $body['gold']), 'silver' => max(0, (int) $body['silver']), 'copper' => max(0, (int) $body['copper'])]);
}));

$app->get('/character/{slug}/skills/marked', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    return jsonResponse($response, $characterRepository->markedSkills((int) $character['id']));
}));

$app->post('/character/{slug}/skills/{skillId}/mark', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setSkillMark((int) $character['id'], (int) $args['skillId'], (bool) $body['marked']);

    return jsonResponse($response, ['skill_id' => (int) $args['skillId'], 'marked' => (bool) $body['marked']]);
}));

$app->post('/character/{slug}/skills/{skillId}/advance', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->advanceSkill((int) $character['id'], (int) $args['skillId'], (bool) $body['apply']);

    return jsonResponse($response, ['skill_id' => (int) $args['skillId'], 'value' => $newValue]);
}));

$app->post('/character/{slug}/spells', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->learnSpell((int) $character['id'], (int) $body['spell_id']);

    return jsonResponse($response, ['learned' => true]);
}));

foreach (['weapons' => 'Weapon', 'inventory' => 'InventoryItem'] as $segment => $methodSuffix) {
    $app->post("/character/{slug}/{$segment}", withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix) {
        $addMethod = 'add' . $methodSuffix;
        $rowId = $characterRepository->$addMethod((int) $character['id']);

        return jsonResponse($response, ['added' => true, 'row_id' => $rowId]);
    }));

    $app->post("/character/{slug}/{$segment}/{rowId}", withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix) {
        $body = json_decode((string) $request->getBody(), true) ?? [];
        $updateMethod = 'update' . $methodSuffix;
        $characterRepository->$updateMethod((int) $character['id'], (int) $args['rowId'], $body);

        return jsonResponse($response, ['updated' => true]);
    }));

    $app->delete("/character/{slug}/{$segment}/{rowId}", withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix) {
        $removeMethod = 'remove' . $methodSuffix;
        $characterRepository->$removeMethod((int) $character['id'], (int) $args['rowId']);

        return jsonResponse($response, ['removed' => true]);
    }));
}

$app->post('/character/{slug}/armor/{slot}', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true) ?? [];

    try {
        $characterRepository->updateArmorSlot((int) $character['id'], (string) $args['slot'], $body);
    } catch (InvalidArgumentException $e) {
        return jsonResponse($response, ['error' => $e->getMessage()], 422);
    }

    return jsonResponse($response, ['updated' => true]);
}));

$app->delete('/character/{slug}', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    if ((bool) $character['is_default']) {
        return jsonResponse($response, ['error' => 'Default-Charaktere können nicht gelöscht werden.'], 403);
    }
    $characterRepository->delete((int) $character['id']);

    return jsonResponse($response, ['deleted' => true]);
}));

$app->run();
