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

$db = Database::connect();
$characterRepository = new CharacterRepository($db);

$app = AppFactory::create();

$twig = Twig::create(__DIR__ . '/../templates', ['cache' => false]);
$app->add(TwigMiddleware::create($app, $twig));

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
        'weaponCatalog' => $repository->itemsCatalogByKind('weapon'),
        'armorCatalog' => $repository->itemsCatalogByKind('armor'),
        'miscCatalog' => $repository->itemsCatalogByKind('misc'),
    ];
}

function jsonResponse(Response $response, array $data): Response
{
    $response->getBody()->write(json_encode($data));

    return $response->withHeader('Content-Type', 'application/json');
}

function requireCharacter(CharacterRepository $repository, string $slug): ?array
{
    return $repository->findBySlug($slug);
}

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

$app->get('/character/{slug}', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $sheet = loadSheet($characterRepository, $args['slug']);
    if ($sheet === null) {
        return $response->withStatus(404);
    }

    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/sheet.twig', $sheet);
});

$app->post('/character/{slug}/hp', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setHp((int) $character['id'], (int) $body['value']);

    return jsonResponse($response, ['hp_current' => $newValue]);
});

$app->post('/character/{slug}/wp', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setWp((int) $character['id'], (int) $body['value']);

    return jsonResponse($response, ['wp_current' => $newValue]);
});

$app->post('/character/{slug}/conditions/{code}/toggle', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $active = $characterRepository->toggleCondition((int) $character['id'], $args['code']);

    return jsonResponse($response, ['code' => $args['code'], 'active' => $active]);
});

$app->post('/character/{slug}/currency', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setCurrency(
        (int) $character['id'],
        (int) $body['gold'],
        (int) $body['silver'],
        (int) $body['copper']
    );

    return jsonResponse($response, ['gold' => max(0, (int) $body['gold']), 'silver' => max(0, (int) $body['silver']), 'copper' => max(0, (int) $body['copper'])]);
});

$app->get('/character/{slug}/skills/marked', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    return jsonResponse($response, $characterRepository->markedSkills((int) $character['id']));
});

$app->post('/character/{slug}/skills/{skillId}/mark', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setSkillMark((int) $character['id'], (int) $args['skillId'], (bool) $body['marked']);

    return jsonResponse($response, ['skill_id' => (int) $args['skillId'], 'marked' => (bool) $body['marked']]);
});

$app->post('/character/{slug}/skills/{skillId}/advance', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->advanceSkill((int) $character['id'], (int) $args['skillId'], (bool) $body['apply']);

    return jsonResponse($response, ['skill_id' => (int) $args['skillId'], 'value' => $newValue]);
});

$app->post('/character/{slug}/spells', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = requireCharacter($characterRepository, $args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->learnSpell((int) $character['id'], (int) $body['spell_id']);

    return jsonResponse($response, ['learned' => true]);
});

foreach (['weapons' => 'Weapon', 'armor' => 'Armor', 'inventory' => 'InventoryItem'] as $segment => $methodSuffix) {
    $app->post("/character/{slug}/{$segment}", function (Request $request, Response $response, array $args) use ($characterRepository, $methodSuffix) {
        $character = requireCharacter($characterRepository, $args['slug']);
        if ($character === null) {
            return $response->withStatus(404);
        }

        $body = json_decode((string) $request->getBody(), true);
        $addMethod = 'add' . $methodSuffix;
        $characterRepository->$addMethod((int) $character['id'], (int) $body['item_id'], (int) $body['quantity']);

        return jsonResponse($response, ['added' => true]);
    });

    $app->post("/character/{slug}/{$segment}/{rowId}/quantity", function (Request $request, Response $response, array $args) use ($characterRepository, $methodSuffix) {
        $character = requireCharacter($characterRepository, $args['slug']);
        if ($character === null) {
            return $response->withStatus(404);
        }

        $body = json_decode((string) $request->getBody(), true);
        $updateMethod = 'update' . $methodSuffix . 'Quantity';
        $characterRepository->$updateMethod((int) $character['id'], (int) $args['rowId'], (int) $body['quantity']);

        return jsonResponse($response, ['updated' => true]);
    });

    $app->delete("/character/{slug}/{$segment}/{rowId}", function (Request $request, Response $response, array $args) use ($characterRepository, $methodSuffix) {
        $character = requireCharacter($characterRepository, $args['slug']);
        if ($character === null) {
            return $response->withStatus(404);
        }

        $removeMethod = 'remove' . $methodSuffix;
        $characterRepository->$removeMethod((int) $character['id'], (int) $args['rowId']);

        return jsonResponse($response, ['removed' => true]);
    });
}

$app->run();
