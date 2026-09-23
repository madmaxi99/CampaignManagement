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
$db->exec('PRAGMA foreign_keys = ON');
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

require __DIR__ . '/../src/HeroicAbilityRepository.php';
require __DIR__ . '/../src/SkillRepository.php';
require __DIR__ . '/../src/ProfessionRepository.php';
require __DIR__ . '/../src/KinRepository.php';
require __DIR__ . '/../src/MagicSchoolRepository.php';
require __DIR__ . '/../src/SpellRepository.php';
require __DIR__ . '/../src/ItemRepository.php';
require __DIR__ . '/../src/PlayerCharacterRepository.php';
require __DIR__ . '/../src/BestiaryRepository.php';
require __DIR__ . '/../src/NpcRepository.php';

// Dependency order: referenced tables' ensureTable() runs before the tables that FK into them.
$heroicAbilityRepository = new HeroicAbilityRepository($db);
$heroicAbilityRepository->ensureTable();
$skillRepository = new SkillRepository($db);
$skillRepository->ensureTable();
$professionRepository = new ProfessionRepository($db);
$professionRepository->ensureTable();
$kinRepository = new KinRepository($db);
$kinRepository->ensureTable();
$magicSchoolRepository = new MagicSchoolRepository($db);
$magicSchoolRepository->ensureTable();
$spellRepository = new SpellRepository($db);
$spellRepository->ensureTable();
$itemRepository = new ItemRepository($db);
$itemRepository->ensureTable();
$playerCharacterRepository = new PlayerCharacterRepository($db);
$playerCharacterRepository->ensureTable();
$bestiaryRepository = new BestiaryRepository($db);
$bestiaryRepository->ensureTable();
$npcRepository = new NpcRepository($db);
$npcRepository->ensureTable();

$app = AppFactory::create();

$twig = Twig::create(__DIR__ . '/../templates', ['cache' => false]);
$app->add(TwigMiddleware::create($app, $twig));

/**
 * The 20 Dragonbane Weakness table entries (D20 lookup) — reference data only,
 * kept as a plain option list rather than a DB table since the stored value on
 * a character is freetext (see PlayerCharacterRepository).
 */
$weaknesses = [
    'Gullible', 'Greedy', 'Thin-skinned', 'Foolhardy', 'Fainthearted',
    'Monster Slayer', 'Intolerant', 'Slothful', 'Gluttonous', 'Kleptomaniac',
    'Vain', 'Reckless', 'Fearful of Magic', 'Craving Knowledge', 'Child of the Wild',
    'Boastful', 'Violent', 'Overbearing', 'Cynic', 'Haughty',
];

$buildCharacterCreationData = function () use (
    $kinRepository, $professionRepository, $skillRepository, $heroicAbilityRepository,
    $magicSchoolRepository, $spellRepository, $itemRepository, $weaknesses
): array {
    return [
        'kins' => $kinRepository->all(),
        'kinAbilities' => $kinRepository->abilitiesByKin(),
        'professions' => $professionRepository->all(),
        'professionCoreSkills' => $professionRepository->coreSkillsByProfession(),
        'professionHeroicAbilityPool' => $professionRepository->startingHeroicAbilitiesByProfession(),
        'skills' => $skillRepository->all(),
        'heroicAbilities' => $heroicAbilityRepository->all(),
        'magicSchools' => $magicSchoolRepository->all(),
        'spells' => $spellRepository->all(),
        'items' => $itemRepository->all(),
        'weaknesses' => $weaknesses,
        'mageProfessionName' => 'Mage',
    ];
};

// --- Chronik ---

$app->get('/', function ($request, $response) use ($twig, $db) {
    $stmt = $db->query('SELECT text, created_at FROM messages ORDER BY id DESC');
    $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $twig->render($response, 'chronicle.twig', ['messages' => $messages, 'nav_active' => 'chronicle']);
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

// --- Orte ---

$app->get('/places', function ($request, $response) use ($twig, $placesRepository) {
    return $twig->render($response, 'places/list.twig', [
        'nav_active' => 'places',
        'places' => $placesRepository->roots(),
    ]);
});

$app->get('/places/new', function ($request, $response) use ($twig, $placesRepository) {
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
        'nav_active' => 'places',
        'place' => ['id' => null, 'name' => '', 'description' => '', 'image_path' => null, 'pin_x' => null, 'pin_y' => null],
        'parent_id' => $parentId,
        'parent_image_path' => $parent['image_path'] ?? null,
        'parent_name' => $parent['name'] ?? null,
        'error' => null,
        'mode' => 'new',
    ]);
});

$app->get('/places/{id}', function ($request, $response, array $args) use ($twig, $placesRepository) {
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
        'nav_active' => 'places',
        'place' => $place,
        'breadcrumb' => $placesRepository->breadcrumb((int) $place['id']),
        'pinned_children' => $pinnedChildren,
        'unpinned_children' => $unpinnedChildren,
    ]);
});

$app->get('/places/{id}/edit', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $parent = $place['parent_id'] !== null ? $placesRepository->find((int) $place['parent_id']) : null;

    return $twig->render($response, 'places/form.twig', [
        'nav_active' => 'places',
        'place' => $place,
        'parent_id' => $place['parent_id'],
        'parent_image_path' => $parent['image_path'] ?? null,
        'parent_name' => $parent['name'] ?? null,
        'error' => null,
        'mode' => 'edit',
    ]);
});

$app->post('/places', function ($request, $response) use ($twig, $placesRepository) {
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
            'nav_active' => 'places',
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

    $redirectTo = $parentId !== null ? '/places/' . $parentId : '/places';

    return $response->withHeader('Location', $redirectTo)->withStatus(302);
});

$app->post('/places/{id}', function ($request, $response, array $args) use ($twig, $placesRepository) {
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
            'nav_active' => 'places',
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

    $redirectTo = $parentId !== null ? '/places/' . $parentId : '/places';

    return $response->withHeader('Location', $redirectTo)->withStatus(302);
});

// --- Bücher (generische Wiki-Engine) ---

$app->get('/wiki', function ($request, $response) {
    return $response->withHeader('Location', '/wiki/books')->withStatus(302);
});

$app->get('/wiki/{category}', function ($request, $response, array $args) use ($twig, $wikiRepository) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    return $twig->render($response, 'wiki/list.twig', [
        'slug' => $args['category'],
        'category' => $categoryConfig,
        'nav_active' => 'books',
        'entries' => $wikiRepository->all($categoryConfig['table']),
    ]);
});

$app->get('/wiki/{category}/new', function ($request, $response, array $args) use ($twig) {
    $categoryConfig = WikiCategories::find($args['category']);
    if ($categoryConfig === null) {
        return $response->withStatus(404);
    }

    return $twig->render($response, 'wiki/form.twig', [
        'slug' => $args['category'],
        'category' => $categoryConfig,
        'nav_active' => 'books',
        'entry' => [],
        'error' => null,
        'mode' => 'new',
        'id' => null,
    ]);
});

$app->get('/wiki/{category}/{id}/edit', function ($request, $response, array $args) use ($twig, $wikiRepository) {
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
        'nav_active' => 'books',
        'entry' => $entry,
        'error' => null,
        'mode' => 'edit',
        'id' => $args['id'],
    ]);
});

$app->post('/wiki/{category}', function ($request, $response, array $args) use ($twig, $wikiRepository) {
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
            'nav_active' => 'books',
            'entry' => $data,
            'error' => sprintf('%s ist ein Pflichtfeld.', $primary['label']),
            'mode' => 'new',
            'id' => null,
        ]);
    }

    $wikiRepository->insert($categoryConfig['table'], $categoryConfig['columns'], $data);

    return $response->withHeader('Location', '/wiki/' . $args['category'])->withStatus(302);
});

$app->post('/wiki/{category}/{id}', function ($request, $response, array $args) use ($twig, $wikiRepository) {
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
            'nav_active' => 'books',
            'entry' => $data,
            'error' => sprintf('%s ist ein Pflichtfeld.', $primary['label']),
            'mode' => 'edit',
            'id' => $args['id'],
        ]);
    }

    $wikiRepository->update($categoryConfig['table'], $categoryConfig['columns'], (int) $args['id'], $data);

    return $response->withHeader('Location', '/wiki/' . $args['category'])->withStatus(302);
});

// --- Regelwerk (Platzhalter-Read-Listen) ---

$app->get('/professions', function ($request, $response) use ($twig, $professionRepository) {
    return $twig->render($response, 'professions/list.twig', [
        'nav_active' => 'professions',
        'professions' => $professionRepository->all(),
        'core_skills' => $professionRepository->coreSkillsByProfession(),
        'starting_abilities' => $professionRepository->startingHeroicAbilitiesByProfession(),
    ]);
});

$app->get('/kins', function ($request, $response) use ($twig, $kinRepository) {
    return $twig->render($response, 'kins/list.twig', [
        'nav_active' => 'kins',
        'kins' => $kinRepository->all(),
        'abilities' => $kinRepository->abilitiesByKin(),
    ]);
});

$app->get('/skills', function ($request, $response) use ($twig, $skillRepository) {
    return $twig->render($response, 'skills/list.twig', [
        'nav_active' => 'skills',
        'skills' => $skillRepository->all(),
    ]);
});

$app->get('/heroic-abilities', function ($request, $response) use ($twig, $heroicAbilityRepository) {
    return $twig->render($response, 'heroic-abilities/list.twig', [
        'nav_active' => 'heroic-abilities',
        'abilities' => $heroicAbilityRepository->all(),
    ]);
});

$app->get('/magic', function ($request, $response) use ($twig, $magicSchoolRepository, $spellRepository) {
    $spellsBySchool = [];
    $unschooledSpells = [];
    foreach ($spellRepository->all() as $spell) {
        if ($spell['school_id'] === null) {
            $unschooledSpells[] = $spell;
        } else {
            $spellsBySchool[(int) $spell['school_id']][] = $spell;
        }
    }

    return $twig->render($response, 'magic/list.twig', [
        'nav_active' => 'magic',
        'schools' => $magicSchoolRepository->all(),
        'spells_by_school' => $spellsBySchool,
        'unschooled_spells' => $unschooledSpells,
    ]);
});

$app->get('/items', function ($request, $response) use ($twig, $itemRepository) {
    return $twig->render($response, 'items/list.twig', [
        'nav_active' => 'items',
        'items' => $itemRepository->all(),
    ]);
});

// --- Bestiary & NSCs ---

$app->get('/bestiary', function ($request, $response) use ($twig, $bestiaryRepository) {
    return $twig->render($response, 'bestiary/list.twig', [
        'nav_active' => 'bestiary',
        'monsters' => $bestiaryRepository->all(),
        'attacks' => $bestiaryRepository->attacksByBestiary(),
        'passives' => $bestiaryRepository->passivesByBestiary(),
    ]);
});

$app->get('/npcs', function ($request, $response) use ($twig, $npcRepository) {
    return $twig->render($response, 'npcs/list.twig', [
        'nav_active' => 'npcs',
        'npcs' => $npcRepository->all(),
    ]);
});

// --- Charaktere ---

$app->get('/characters', function ($request, $response) use ($twig, $playerCharacterRepository) {
    return $twig->render($response, 'characters/list.twig', [
        'nav_active' => 'characters',
        'characters' => $playerCharacterRepository->all(),
    ]);
});

$app->get('/characters/new', function ($request, $response) use ($twig, $buildCharacterCreationData) {
    $characterData = $buildCharacterCreationData();

    return $twig->render($response, 'characters/new.twig', [
        'nav_active' => 'characters',
        'kins' => $characterData['kins'],
        'professions' => $characterData['professions'],
        'character_data' => json_encode($characterData, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
        'error' => null,
    ]);
});

$app->post('/characters', function ($request, $response) use (
    $twig, $kinRepository, $professionRepository, $skillRepository, $heroicAbilityRepository,
    $magicSchoolRepository, $spellRepository, $itemRepository, $playerCharacterRepository,
    $buildCharacterCreationData
) {
    $data = (array) $request->getParsedBody();

    $renderError = function (string $message) use ($twig, $response, $buildCharacterCreationData) {
        $characterData = $buildCharacterCreationData();

        return $twig->render($response->withStatus(422), 'characters/new.twig', [
            'nav_active' => 'characters',
            'kins' => $characterData['kins'],
            'professions' => $characterData['professions'],
            'character_data' => json_encode($characterData, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
            'error' => $message,
        ]);
    };

    $name = trim((string) ($data['name'] ?? ''));
    $kinId = (int) ($data['kin_id'] ?? 0);
    $professionId = (int) ($data['profession_id'] ?? 0);
    $age = (string) ($data['age'] ?? '');

    if ($name === '' || $kinId <= 0 || $professionId <= 0 || !in_array($age, ['young', 'adult', 'old'], true)) {
        return $renderError('Bitte alle Pflichtfelder ausfüllen.');
    }

    $kin = $kinRepository->find($kinId);
    $profession = $professionRepository->find($professionId);
    if ($kin === null || $profession === null) {
        return $renderError('Ungültige Auswahl bei Kin oder Profession.');
    }

    $attributes = [];
    foreach (['str', 'con', 'agl', 'int', 'wil', 'cha'] as $attr) {
        $value = (int) ($data['attribute_' . $attr] ?? 0);
        if ($value < 3 || $value > 18) {
            return $renderError('Attribute müssen zwischen 3 und 18 liegen.');
        }
        $attributes[$attr] = $value;
    }

    $isMage = $profession['name'] === 'Mage';
    $magicTradition = null;
    $traditionSchoolId = null;

    if ($isMage) {
        $magicTradition = (string) ($data['magic_tradition'] ?? '');
        if (!in_array($magicTradition, ['elementalist', 'mentalist', 'animist'], true)) {
            return $renderError('Bitte eine Magic Tradition wählen.');
        }

        $traditionSchoolName = ['elementalist' => 'Elementalism', 'mentalist' => 'Mentalism', 'animist' => 'Animism'];
        $school = $magicSchoolRepository->findByName($traditionSchoolName[$magicTradition]);
        $traditionSchoolId = $school !== null ? (int) $school['id'] : null;
    }

    $coreSkillRows = $professionRepository->coreSkillsByProfession()[$professionId] ?? [];
    if ($isMage) {
        $coreSkillRows = array_values(array_filter($coreSkillRows, static function (array $row) use ($traditionSchoolId) {
            return $row['magic_school_id'] === null || (int) $row['magic_school_id'] === $traditionSchoolId;
        }));
    }
    $coreSkillIds = array_map(static fn (array $r): int => (int) $r['skill_id'], $coreSkillRows);

    $ageSlots = ['young' => 2, 'adult' => 4, 'old' => 6];
    $extraSkillIds = array_map('intval', (array) ($data['trained_skill_ids'] ?? []));
    $extraSkillIds = array_values(array_unique(array_diff($extraSkillIds, $coreSkillIds)));

    if (count($extraSkillIds) !== $ageSlots[$age]) {
        return $renderError(sprintf('Bitte genau %d zusätzliche Skills für dieses Alter wählen.', $ageSlots[$age]));
    }

    $allSkillsById = [];
    foreach ($skillRepository->all() as $skill) {
        $allSkillsById[(int) $skill['id']] = $skill;
    }

    $trainedSkills = [];
    foreach (array_merge($coreSkillIds, $extraSkillIds) as $skillId) {
        if (!isset($allSkillsById[$skillId])) {
            return $renderError('Ungültiger Skill ausgewählt.');
        }
        $trainedSkills[] = ['id' => $skillId, 'governing_attribute' => $allSkillsById[$skillId]['governing_attribute']];
    }

    $heroicAbilityId = null;
    $spellIds = [];
    $grimoireItemId = null;

    if ($isMage) {
        $submittedSpellIds = array_map('intval', (array) ($data['spell_ids'] ?? []));
        $spellsById = [];
        foreach ($spellRepository->all() as $spell) {
            $spellsById[(int) $spell['id']] = $spell;
        }

        $rank1Selected = array_values(array_filter($submittedSpellIds, static function (int $id) use ($spellsById, $traditionSchoolId) {
            return isset($spellsById[$id])
                && (int) $spellsById[$id]['rank'] === 1
                && $spellsById[$id]['school_id'] !== null
                && (int) $spellsById[$id]['school_id'] === $traditionSchoolId;
        }));

        $generalSchool = $magicSchoolRepository->findByName('General');
        $generalSchoolId = $generalSchool !== null ? (int) $generalSchool['id'] : null;

        $trickSelected = array_values(array_filter($submittedSpellIds, static function (int $id) use ($spellsById, $traditionSchoolId, $generalSchoolId) {
            if (!isset($spellsById[$id]) || (int) $spellsById[$id]['rank'] !== 0) {
                return false;
            }
            $schoolId = $spellsById[$id]['school_id'] !== null ? (int) $spellsById[$id]['school_id'] : null;

            return $schoolId === $traditionSchoolId || $schoolId === $generalSchoolId;
        }));

        if (count($rank1Selected) !== 3 || count($trickSelected) !== 3) {
            return $renderError('Bitte genau 3 Rank-1-Zauber und 3 Magic Tricks wählen.');
        }

        $spellIds = array_merge($rank1Selected, $trickSelected);
        $grimoireItemId = $itemRepository->findOrCreateGrimoire();
    } else {
        $heroicAbilityId = (int) ($data['heroic_ability_id'] ?? 0);
        if ($heroicAbilityId <= 0 || $heroicAbilityRepository->find($heroicAbilityId) === null) {
            return $renderError('Bitte eine Heroic Ability wählen.');
        }
    }

    $characterId = $playerCharacterRepository->create([
        'name' => $name,
        'kin_id' => $kinId,
        'profession_id' => $professionId,
        'age' => $age,
        'magic_tradition' => $magicTradition,
        'appearance' => trim((string) ($data['appearance'] ?? '')) ?: null,
        'weakness' => trim((string) ($data['weakness'] ?? '')) ?: null,
        'memento' => trim((string) ($data['memento'] ?? '')) ?: null,
        'languages' => trim((string) ($data['languages'] ?? '')) ?: null,
        'attribute_str' => $attributes['str'],
        'attribute_con' => $attributes['con'],
        'attribute_agl' => $attributes['agl'],
        'attribute_int' => $attributes['int'],
        'attribute_wil' => $attributes['wil'],
        'attribute_cha' => $attributes['cha'],
        'kin_base_movement' => $kin['base_movement'],
        'trained_skills' => $trainedSkills,
        'heroic_ability_id' => $heroicAbilityId,
        'spell_ids' => $spellIds,
        'grimoire_item_id' => $grimoireItemId,
    ]);

    $itemIds = (array) ($data['item_id'] ?? []);
    $itemQuantities = (array) ($data['item_qty'] ?? []);
    foreach ($itemIds as $index => $itemId) {
        $itemId = (int) $itemId;
        $quantity = (int) ($itemQuantities[$index] ?? 1);
        if ($itemId > 0 && $quantity > 0) {
            $playerCharacterRepository->addInventoryItem($characterId, $itemId, $quantity);
        }
    }

    return $response->withHeader('Location', '/characters/' . $characterId)->withStatus(302);
});

$app->get('/characters/{id}', function ($request, $response, array $args) use ($twig, $playerCharacterRepository, $skillRepository, $itemRepository) {
    $characterId = (int) $args['id'];
    $character = $playerCharacterRepository->find($characterId);
    if ($character === null) {
        return $response->withStatus(404);
    }

    $trainedRows = $playerCharacterRepository->skills($characterId);
    $trainedSkills = [];
    foreach ($trainedRows as $row) {
        $trainedSkills[(int) $row['skill_id']] = $row;
    }

    $allSkills = $skillRepository->all();
    $untrainedBaseChance = [];
    foreach ($allSkills as $skill) {
        if (!isset($trainedSkills[(int) $skill['id']])) {
            $attrKey = 'attribute_' . strtolower($skill['governing_attribute']);
            $untrainedBaseChance[(int) $skill['id']] = SkillRepository::baseChance((int) $character[$attrKey]);
        }
    }

    return $twig->render($response, 'characters/show.twig', [
        'nav_active' => 'characters',
        'character' => $character,
        'all_skills' => $allSkills,
        'trained_skills' => $trainedSkills,
        'untrained_base_chance' => $untrainedBaseChance,
        'heroic_abilities' => $playerCharacterRepository->heroicAbilities($characterId),
        'spells' => $playerCharacterRepository->spells($characterId),
        'inventory' => $playerCharacterRepository->inventory($characterId),
        'items' => $itemRepository->all(),
    ]);
});

$app->post('/characters/{id}/vitals', function ($request, $response, array $args) use ($playerCharacterRepository) {
    $data = (array) $request->getParsedBody();
    $playerCharacterRepository->updateVitals((int) $args['id'], [
        'hp_current' => (int) ($data['hp_current'] ?? 0),
        'wp_current' => (int) ($data['wp_current'] ?? 0),
        'condition_exhausted' => isset($data['condition_exhausted']),
        'condition_sickly' => isset($data['condition_sickly']),
        'condition_dazed' => isset($data['condition_dazed']),
        'condition_angry' => isset($data['condition_angry']),
        'condition_scared' => isset($data['condition_scared']),
        'condition_disheartened' => isset($data['condition_disheartened']),
    ]);

    return $response->withHeader('Location', '/characters/' . $args['id'])->withStatus(302);
});

$app->post('/characters/{id}/skills/{skillId}/toggle-mark', function ($request, $response, array $args) use ($playerCharacterRepository) {
    $playerCharacterRepository->toggleAdvancementMark((int) $args['id'], (int) $args['skillId']);

    return $response->withHeader('Location', '/characters/' . $args['id'])->withStatus(302);
});

$app->post('/characters/{id}/inventory', function ($request, $response, array $args) use ($playerCharacterRepository) {
    $data = (array) $request->getParsedBody();
    $itemId = (int) ($data['item_id'] ?? 0);
    $quantity = max(1, (int) ($data['quantity'] ?? 1));

    if ($itemId > 0) {
        $playerCharacterRepository->addInventoryItem((int) $args['id'], $itemId, $quantity);
    }

    return $response->withHeader('Location', '/characters/' . $args['id'])->withStatus(302);
});

$app->post('/characters/{id}/inventory/{inventoryId}/toggle-equipped', function ($request, $response, array $args) use ($playerCharacterRepository) {
    $playerCharacterRepository->toggleEquipped((int) $args['inventoryId']);

    return $response->withHeader('Location', '/characters/' . $args['id'])->withStatus(302);
});

$app->post('/characters/{id}/inventory/{inventoryId}/delete', function ($request, $response, array $args) use ($playerCharacterRepository) {
    $playerCharacterRepository->removeInventoryItem((int) $args['inventoryId']);

    return $response->withHeader('Location', '/characters/' . $args['id'])->withStatus(302);
});

$app->run();
