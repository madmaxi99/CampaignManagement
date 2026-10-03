<?php

declare(strict_types=1);

use Slim\Factory\AppFactory;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Psr7\Factory\ResponseFactory;

require __DIR__ . '/../vendor/autoload.php';
require __DIR__ . '/../src/Database.php';
require __DIR__ . '/../src/CharacterRepository.php';
require __DIR__ . '/../src/CampaignRepository.php';
require __DIR__ . '/../src/CampaignStandRepository.php';
require __DIR__ . '/../src/WorldRepository.php';
require __DIR__ . '/../src/EntityLinker.php';
require __DIR__ . '/../src/CharacterCreationRepository.php';
require __DIR__ . '/../src/RulesRepository.php';
require __DIR__ . '/../src/DmAuth.php';
require __DIR__ . '/../src/SessionMiddleware.php';
require __DIR__ . '/../src/DmGate.php';
require __DIR__ . '/../src/CatalogEditorRepository.php';

$db = Database::connect();
$characterRepository = new CharacterRepository($db);
$campaignRepository = new CampaignRepository($db);
$standRepository = new CampaignStandRepository($db);
$worldRepository = new WorldRepository($db);
$characterCreationRepository = new CharacterCreationRepository($db);
$rulesRepository = new RulesRepository($db);
$catalogEditor = new CatalogEditorRepository($db);
$dmAuth = new DmAuth(getenv('DM_PASSWORD_HASH') ?: null, sys_get_temp_dir());

$app = AppFactory::create();

$twig = Twig::create(__DIR__ . '/../templates', ['cache' => false]);

// Middleware runs bottom-up: session first, then the DM lock, then the view globals.
$app->add(TwigMiddleware::create($app, $twig));
$app->add(function (Request $request, RequestHandler $handler) use ($twig, $dmAuth) {
    $environment = $twig->getEnvironment();
    $environment->addGlobal('is_dm', $dmAuth->isLoggedIn());
    $environment->addGlobal('csrf_token', $dmAuth->csrfToken());

    return $handler->handle($request);
});
$app->add(new DmGate($dmAuth, new ResponseFactory()));
$app->add(new SessionMiddleware());

$twig->getEnvironment()->addGlobal('app_name', 'Abenteuerbuch');
$twig->getEnvironment()->addFilter(new \Twig\TwigFilter('repeat', fn (string $text, int $times): string => str_repeat($text, max(0, $times))));
// asset('css/x.css') -> /css/x.css?v=<mtime>, so browsers pick up changes.
$twig->getEnvironment()->addFunction(new \Twig\TwigFunction('asset', function (string $path): string {
    $file = __DIR__ . '/' . $path;

    return '/' . $path . '?v=' . (is_file($file) ? filemtime($file) : 0);
}));
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

/** Login redirect target: only paths inside /dm, never an external URL. */
function safeDmTarget(mixed $next): string
{
    if (is_string($next) && preg_match('#^/dm(/[A-Za-z0-9_\-./]*)?$#', $next) === 1) {
        return $next;
    }

    return '/dm';
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

$app->get('/', function (Request $request, Response $response) {
    return $response->withHeader('Location', '/characters')->withStatus(302);
});

$app->get('/characters', function (Request $request, Response $response) use ($characterRepository) {
    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'characters/list.twig', [
        'characters' => $characterRepository->listAll(),
    ]);
});

$app->get('/rules', function (Request $request, Response $response) use ($rulesRepository) {
    return Twig::fromRequest($request)->render($response, 'rules.twig', [
        'items' => $rulesRepository->items(),
        'skills' => $rulesRepository->skills(),
        'schools' => $rulesRepository->spellsBySchool(),
        'professions' => $rulesRepository->professions(),
        'kins' => $rulesRepository->kins(),
        'heroicAbilities' => $rulesRepository->heroicAbilities(),
        'tables' => $rulesRepository->tables(),
    ]);
});

// ---- DM login / logout / old URLs ----

$app->get('/dm/login', function (Request $request, Response $response) use ($dmAuth) {
    if ($dmAuth->isLoggedIn()) {
        return $response->withHeader('Location', '/dm')->withStatus(302);
    }

    return Twig::fromRequest($request)->render($response, 'dm/login.twig', [
        'configured' => $dmAuth->isConfigured(),
        'next' => safeDmTarget($request->getQueryParams()['next'] ?? null),
        'error' => null,
    ]);
});

$app->post('/dm/login', function (Request $request, Response $response) use ($dmAuth) {
    $body = (array) $request->getParsedBody();
    $next = safeDmTarget($body['next'] ?? null);
    $render = fn (?string $error, int $status) => Twig::fromRequest($request)->render(
        $response->withStatus($status),
        'dm/login.twig',
        ['configured' => $dmAuth->isConfigured(), 'next' => $next, 'error' => $error]
    );

    if (!$dmAuth->validCsrf((string) ($body['_csrf'] ?? ''))) {
        return $render('Sitzung abgelaufen, bitte noch einmal versuchen.', 403);
    }

    $clientId = $request->getServerParams()['REMOTE_ADDR'] ?? 'unknown';
    $result = $dmAuth->attempt((string) ($body['password'] ?? ''), $clientId);

    return match ($result) {
        'ok' => $response->withHeader('Location', $next)->withStatus(302),
        'locked' => $render('Zu viele Versuche. Bitte in ' . $dmAuth->lockedSeconds($clientId) . ' Sekunden noch einmal versuchen.', 429),
        'unconfigured' => $render(null, 503),
        default => $render('Das Passwort stimmt nicht.', 401),
    };
});

$app->post('/dm/logout', function (Request $request, Response $response) use ($dmAuth) {
    $dmAuth->logout();

    return $response->withHeader('Location', '/characters')->withStatus(302);
});

$app->get('/dm/styleguide', function (Request $request, Response $response) {
    return Twig::fromRequest($request)->render($response, 'dm/styleguide.twig');
});

// Old URLs of the previous layout.
$app->get('/campaign', fn (Request $request, Response $response) => $response->withHeader('Location', '/dm')->withStatus(301));
$app->get('/campaign/{id:[0-9]+}', fn (Request $request, Response $response, array $args) => $response->withHeader('Location', '/dm/campaign/' . $args['id'])->withStatus(301));
$app->get('/world', fn (Request $request, Response $response) => $response->withHeader('Location', '/dm/catalog')->withStatus(301));

(require __DIR__ . '/../routes/dm_campaign.php')($app, $campaignRepository, $standRepository);
(require __DIR__ . '/../routes/dm_catalog.php')($app, $catalogEditor, $worldRepository);

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

$app->post('/character/{id:[0-9]+}/memory', withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository) {
    $body = json_decode((string) $request->getBody(), true);
    $characterRepository->setMemory((int) $character['id'], (string) ($body['text'] ?? ''));

    return jsonResponse($response, ['saved' => true]);
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
