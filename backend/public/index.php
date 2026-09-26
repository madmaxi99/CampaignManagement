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
        'talents' => $repository->talents($characterId),
        'spells' => $repository->spells($characterId),
        'weapons' => $repository->weapons($characterId),
        'armor' => $repository->armor($characterId),
        'inventory' => $repository->inventory($characterId),
    ];
}

$app->get('/character/{slug}', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $sheet = loadSheet($characterRepository, $args['slug']);
    if ($sheet === null) {
        return $response->withStatus(404);
    }

    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/sheet.twig', $sheet);
});

$app->post('/character/{slug}/hp', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = $characterRepository->findBySlug($args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setHp((int) $character['id'], (int) $body['value']);

    $response->getBody()->write(json_encode(['hp_current' => $newValue]));

    return $response->withHeader('Content-Type', 'application/json');
});

$app->post('/character/{slug}/wp', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = $characterRepository->findBySlug($args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $body = json_decode((string) $request->getBody(), true);
    $newValue = $characterRepository->setWp((int) $character['id'], (int) $body['value']);

    $response->getBody()->write(json_encode(['wp_current' => $newValue]));

    return $response->withHeader('Content-Type', 'application/json');
});

$app->post('/character/{slug}/conditions/{code}/toggle', function (Request $request, Response $response, array $args) use ($characterRepository) {
    $character = $characterRepository->findBySlug($args['slug']);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $active = $characterRepository->toggleCondition((int) $character['id'], $args['code']);

    $response->getBody()->write(json_encode(['code' => $args['code'], 'active' => $active]));

    return $response->withHeader('Content-Type', 'application/json');
});

$app->run();
