<?php

declare(strict_types=1);

use Slim\Factory\AppFactory;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;

require __DIR__ . '/../vendor/autoload.php';

$dataDir = __DIR__ . '/../var/data';
if (!is_dir($dataDir)) {
    mkdir($dataDir, 0775, true);
}

$db = new PDO('sqlite:' . $dataDir . '/app.sqlite');
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$db->exec(<<<SQL
    CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        created_at TEXT NOT NULL
    )
    SQL);

require __DIR__ . '/../src/WikiCategories.php';
require __DIR__ . '/../src/WikiRepository.php';

$wikiRepository = new WikiRepository($db);
foreach (WikiCategories::CATEGORIES as $categoryConfig) {
    $wikiRepository->ensureTable($categoryConfig['table'], $categoryConfig['columns']);
}

require __DIR__ . '/../src/PlacesRepository.php';
require __DIR__ . '/../src/PlaceImageStorage.php';

$placesRepository = new PlacesRepository($db);
$placesRepository->ensureTable();

$app = AppFactory::create();

$twig = Twig::create(__DIR__ . '/../templates', ['cache' => false]);
$app->add(TwigMiddleware::create($app, $twig));

$app->get('/', function ($request, $response) use ($twig, $db) {
    $stmt = $db->query('SELECT text, created_at FROM messages ORDER BY id DESC');
    $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $twig->render($response, 'hello.twig', ['messages' => $messages]);
});

$app->post('/messages', function ($request, $response) use ($db) {
    $text = trim((string) ($request->getParsedBody()['text'] ?? ''));

    if ($text !== '') {
        $stmt = $db->prepare('INSERT INTO messages (text, created_at) VALUES (:text, :created_at)');
        $stmt->execute([
            'text' => $text,
            'created_at' => (new DateTimeImmutable())->format('Y-m-d H:i:s'),
        ]);
    }

    return $response->withHeader('Location', '/')->withStatus(302);
});

$app->get('/dm', function ($request, $response) use ($twig) {
    return $twig->render($response, 'dm.twig');
});

$app->get('/dm/wiki', function ($request, $response) {
    return $response->withHeader('Location', '/dm/wiki/bestiary')->withStatus(302);
});

$app->get('/dm/wiki/places', function ($request, $response) use ($twig, $placesRepository) {
    return $twig->render($response, 'places/list.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'places' => $placesRepository->roots(),
    ]);
});

$app->get('/dm/wiki/{category}', function ($request, $response, array $args) use ($twig, $wikiRepository) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    return $twig->render($response, 'wiki/list.twig', [
        'slug' => $args['category'],
        'category' => $categoryConfig,
        'categories' => WikiCategories::tabs(),
        'entries' => $wikiRepository->all($categoryConfig['table']),
    ]);
});

$app->get('/dm/wiki/places/new', function ($request, $response) use ($twig, $placesRepository) {
    $queryParams = $request->getQueryParams();
    $parentId = isset($queryParams['parent_id']) && $queryParams['parent_id'] !== ''
        ? (int) $queryParams['parent_id']
        : null;
    $parent = null;

    if ($parentId !== null) {
        $parent = $placesRepository->find($parentId);
        if ($parent === null) {
            return $response->withStatus(404);
        }
    }

    return $twig->render($response, 'places/form.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'place' => ['id' => null, 'name' => '', 'description' => '', 'image_path' => null, 'pin_x' => null, 'pin_y' => null],
        'parent_id' => $parentId,
        'parent_image_path' => $parent['image_path'] ?? null,
        'parent_name' => $parent['name'] ?? null,
        'error' => null,
        'mode' => 'new',
    ]);
});

$app->get('/dm/wiki/places/{id}', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $children = $placesRepository->children((int) $place['id']);
    $pinnedChildren = array_values(array_filter(
        $children,
        static fn (array $c): bool => $c['pin_x'] !== null && $c['pin_y'] !== null
    ));
    $unpinnedChildren = array_values(array_filter(
        $children,
        static fn (array $c): bool => $c['pin_x'] === null || $c['pin_y'] === null
    ));

    return $twig->render($response, 'places/detail.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'place' => $place,
        'breadcrumb' => $placesRepository->breadcrumb((int) $place['id']),
        'pinned_children' => $pinnedChildren,
        'unpinned_children' => $unpinnedChildren,
    ]);
});

$app->get('/dm/wiki/{category}/new', function ($request, $response, array $args) use ($twig) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    return $twig->render($response, 'wiki/form.twig', [
        'slug' => $args['category'],
        'category' => $categoryConfig,
        'categories' => WikiCategories::tabs(),
        'entry' => [],
        'error' => null,
        'mode' => 'new',
        'id' => null,
    ]);
});

$app->post('/dm/wiki/places', function ($request, $response) use ($twig, $placesRepository) {
    $data = (array) $request->getParsedBody();
    $uploadedFiles = $request->getUploadedFiles();
    $parentId = trim((string) ($data['parent_id'] ?? '')) !== '' ? (int) $data['parent_id'] : null;

    $parent = null;
    if ($parentId !== null) {
        $parent = $placesRepository->find($parentId);
        if ($parent === null) {
            return $response->withStatus(404);
        }
    }

    $name = trim((string) ($data['name'] ?? ''));

    $renderError = function (string $message) use ($twig, $response, $data, $parentId, $parent) {
        return $twig->render($response->withStatus(422), 'places/form.twig', [
            'slug' => 'places',
            'categories' => WikiCategories::tabs(),
            'place' => $data,
            'parent_id' => $parentId,
            'parent_image_path' => $parent['image_path'] ?? null,
            'parent_name' => $parent['name'] ?? null,
            'error' => $message,
            'mode' => 'new',
        ]);
    };

    if ($name === '') {
        return $renderError('Name ist ein Pflichtfeld.');
    }

    try {
        $imagePath = PlaceImageStorage::store($uploadedFiles['image'] ?? null);
    } catch (InvalidArgumentException $exception) {
        return $renderError($exception->getMessage());
    }

    $placesRepository->insert([
        'name' => $name,
        'description' => trim((string) ($data['description'] ?? '')),
        'parent_id' => $parentId,
        'image_path' => $imagePath,
        'pin_x' => trim((string) ($data['pin_x'] ?? '')) !== '' ? (float) $data['pin_x'] : null,
        'pin_y' => trim((string) ($data['pin_y'] ?? '')) !== '' ? (float) $data['pin_y'] : null,
    ]);

    $redirectTo = $parentId !== null ? '/dm/wiki/places/' . $parentId : '/dm/wiki/places';

    return $response->withHeader('Location', $redirectTo)->withStatus(302);
});

$app->post('/dm/wiki/{category}', function ($request, $response, array $args) use ($twig, $wikiRepository) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    $data = (array) $request->getParsedBody();
    $primary = $categoryConfig['columns'][0];

    if (trim((string) ($data[$primary['name']] ?? '')) === '') {
        return $twig->render($response->withStatus(422), 'wiki/form.twig', [
            'slug' => $args['category'],
            'category' => $categoryConfig,
            'categories' => WikiCategories::tabs(),
            'entry' => $data,
            'error' => sprintf('%s ist ein Pflichtfeld.', $primary['label']),
            'mode' => 'new',
            'id' => null,
        ]);
    }

    $wikiRepository->insert($categoryConfig['table'], $categoryConfig['columns'], $data);

    return $response->withHeader('Location', '/dm/wiki/' . $args['category'])->withStatus(302);
});

$app->get('/dm/wiki/places/{id}/edit', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $parent = $place['parent_id'] !== null ? $placesRepository->find((int) $place['parent_id']) : null;

    return $twig->render($response, 'places/form.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'place' => $place,
        'parent_id' => $place['parent_id'],
        'parent_image_path' => $parent['image_path'] ?? null,
        'parent_name' => $parent['name'] ?? null,
        'error' => null,
        'mode' => 'edit',
    ]);
});

$app->get('/dm/wiki/{category}/{id}/edit', function ($request, $response, array $args) use ($twig, $wikiRepository) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    $entry = $wikiRepository->find($categoryConfig['table'], (int) $args['id']);
    if ($entry === null) {
        return $response->withStatus(404);
    }

    return $twig->render($response, 'wiki/form.twig', [
        'slug' => $args['category'],
        'category' => $categoryConfig,
        'categories' => WikiCategories::tabs(),
        'entry' => $entry,
        'error' => null,
        'mode' => 'edit',
        'id' => $args['id'],
    ]);
});

$app->post('/dm/wiki/places/{id}', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $data = (array) $request->getParsedBody();
    $uploadedFiles = $request->getUploadedFiles();
    $parentId = $place['parent_id'] !== null ? (int) $place['parent_id'] : null;
    $parent = $parentId !== null ? $placesRepository->find($parentId) : null;

    $name = trim((string) ($data['name'] ?? ''));

    $renderError = function (string $message) use ($twig, $response, $data, $place, $parentId, $parent) {
        $formPlace = $data;
        $formPlace['id'] = $place['id'];
        $formPlace['image_path'] = $place['image_path'];

        return $twig->render($response->withStatus(422), 'places/form.twig', [
            'slug' => 'places',
            'categories' => WikiCategories::tabs(),
            'place' => $formPlace,
            'parent_id' => $parentId,
            'parent_image_path' => $parent['image_path'] ?? null,
            'parent_name' => $parent['name'] ?? null,
            'error' => $message,
            'mode' => 'edit',
        ]);
    };

    if ($name === '') {
        return $renderError('Name ist ein Pflichtfeld.');
    }

    try {
        $newImagePath = PlaceImageStorage::store($uploadedFiles['image'] ?? null);
    } catch (InvalidArgumentException $exception) {
        return $renderError($exception->getMessage());
    }

    $placesRepository->update((int) $place['id'], [
        'name' => $name,
        'description' => trim((string) ($data['description'] ?? '')),
        'parent_id' => $parentId,
        'image_path' => $newImagePath ?? $place['image_path'],
        'pin_x' => trim((string) ($data['pin_x'] ?? '')) !== '' ? (float) $data['pin_x'] : null,
        'pin_y' => trim((string) ($data['pin_y'] ?? '')) !== '' ? (float) $data['pin_y'] : null,
    ]);

    $redirectTo = $parentId !== null ? '/dm/wiki/places/' . $parentId : '/dm/wiki/places';

    return $response->withHeader('Location', $redirectTo)->withStatus(302);
});

$app->post('/dm/wiki/{category}/{id}', function ($request, $response, array $args) use ($twig, $wikiRepository) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    $data = (array) $request->getParsedBody();
    $primary = $categoryConfig['columns'][0];

    if (trim((string) ($data[$primary['name']] ?? '')) === '') {
        return $twig->render($response->withStatus(422), 'wiki/form.twig', [
            'slug' => $args['category'],
            'category' => $categoryConfig,
            'categories' => WikiCategories::tabs(),
            'entry' => $data,
            'error' => sprintf('%s ist ein Pflichtfeld.', $primary['label']),
            'mode' => 'edit',
            'id' => $args['id'],
        ]);
    }

    $wikiRepository->update($categoryConfig['table'], $categoryConfig['columns'], (int) $args['id'], $data);

    return $response->withHeader('Location', '/dm/wiki/' . $args['category'])->withStatus(302);
});

$app->run();
