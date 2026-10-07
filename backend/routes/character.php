<?php

declare(strict_types=1);

use Flyka\CampaignManagement\CharacterCreationRepository;
use Flyka\CampaignManagement\CharacterRepository;
use Flyka\CampaignManagement\CharacterRules;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;
use function Flyka\CampaignManagement\Http\jsonResponse;
use function Flyka\CampaignManagement\Http\publicPath;
use function Flyka\CampaignManagement\Http\storeUploadedImage;

/**
 * Player-facing character routes: sheet, level-up, creation wizard and every write endpoint.
 */
return function (App $app, CharacterRepository $characterRepository, CharacterCreationRepository $characterCreationRepository): void {
    $loadSheet = static function (CharacterRepository $repository, int $id): ?array {
        $character = $repository->findById($id);
        if ($character === null) {
            return null;
        }

        $characterId = (int) $character['id'];
        $attributes = $repository->attributes($characterId);
        $character += CharacterRules::derivedStats($character, $attributes);

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
    };

    /**
     * Wraps a route handler so it only runs once the character behind {id}
     * was found, passing it in as the fourth argument; otherwise responds 404.
     */
    $withCharacter = (static fn (CharacterRepository $repository, callable $handler): callable => function (Request $request, Response $response, array $args) use ($repository, $handler) {
        $character = $repository->findById((int) $args['id']);
        if ($character === null) {
            return $response->withStatus(404);
        }

        return $handler($request, $response, $args, $character);
    });

    $app->get('/api/character-creation/catalog', fn (Request $request, Response $response): Response => jsonResponse($response, $characterCreationRepository->catalog()));

    $app->post('/characters', function (Request $request, Response $response) use ($characterCreationRepository) {
        $body = json_decode((string) $request->getBody(), true) ?? [];

        try {
            $characterId = $characterCreationRepository->createCharacter($body);
        } catch (InvalidArgumentException $e) {
            $response->getBody()
                ->write(json_encode([
                    'error' => $e->getMessage(),
                ]));

            return $response->withHeader('Content-Type', 'application/json')
                ->withStatus(422);
        }

        return jsonResponse($response, [
            'id' => $characterId,
        ]);
    });

    $app->get('/characters', function (Request $request, Response $response) use ($characterRepository): Response {
        $twig = Twig::fromRequest($request);

        return $twig->render($response, 'characters/list.twig', [
            'characters' => $characterRepository->listAll(),
        ]);
    });

    $app->get('/character/create', function (Request $request, Response $response): Response {
        $twig = Twig::fromRequest($request);

        return $twig->render($response, 'character/create.twig');
    });

    $app->get('/character/{id:[0-9]+}', function (Request $request, Response $response, array $args) use ($characterRepository, $loadSheet): Response {
        $sheet = $loadSheet($characterRepository, (int) $args['id']);
        if ($sheet === null) {
            return $response->withStatus(404);
        }

        $twig = Twig::fromRequest($request);

        return $twig->render($response, 'character/sheet.twig', $sheet);
    });

    $app->post('/character/{id:[0-9]+}/hp', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $newValue = $characterRepository->setHp((int) $character['id'], (int) $body['value']);

        return jsonResponse($response, [
            'hp_current' => $newValue,
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/wp', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $newValue = $characterRepository->setWp((int) $character['id'], (int) $body['value']);

        return jsonResponse($response, [
            'wp_current' => $newValue,
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/conditions/{code}/toggle', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $active = $characterRepository->toggleCondition((int) $character['id'], $args['code']);

        return jsonResponse($response, [
            'code' => $args['code'],
            'active' => $active,
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/memory', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $characterRepository->setMemory((int) $character['id'], (string) ($body['text'] ?? ''));

        return jsonResponse($response, [
            'saved' => true,
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/currency', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $characterRepository->setCurrency(
            (int) $character['id'],
            (int) $body['gold'],
            (int) $body['silver'],
            (int) $body['copper']
        );

        return jsonResponse($response, [
            'gold' => max(0, (int) $body['gold']),
            'silver' => max(0, (int) $body['silver']),
            'copper' => max(0, (int) $body['copper']),
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/skills/{skillId}/mark', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $characterRepository->setSkillMark((int) $character['id'], (int) $args['skillId'], (bool) $body['marked']);

        return jsonResponse($response, [
            'skill_id' => (int) $args['skillId'],
            'marked' => (bool) $body['marked'],
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/skills/{skillId}/advance', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $newValue = $characterRepository->advanceSkill((int) $character['id'], (int) $args['skillId'], (bool) $body['apply']);

        return jsonResponse($response, [
            'skill_id' => (int) $args['skillId'],
            'value' => $newValue,
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/spells', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true);
        $characterRepository->learnSpell((int) $character['id'], (int) $body['spell_id']);

        return jsonResponse($response, [
            'learned' => true,
        ]);
    }));

    $app->get('/character/{id:[0-9]+}/levelup', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $characterId = (int) $character['id'];
        $secondarySkills = $characterRepository->skillsByCategory($characterId, 'secondary');
        $untrainedSchoolSkills = array_values(array_filter($secondarySkills, static fn (array $s): bool => (int) $s['value'] === 0));

        $twig = Twig::fromRequest($request);

        return $twig->render($response, 'character/levelup.twig', [
            'character' => $character,
            'markedSkills' => $characterRepository->markedSkills($characterId),
            'learnableHeroicAbilities' => $characterRepository->learnableHeroicAbilities($characterId, $character['profession_code']),
            'untrainedSchoolSkills' => $untrainedSchoolSkills,
            'availableSpells' => $characterRepository->availableSpells($characterId, $characterRepository->trainedSchoolSkillIds($characterId)),
        ]);
    }));

    $app->post('/character/{id:[0-9]+}/heroic-abilities', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true) ?? [];
        $ability = $characterRepository->heroicAbilityById((int) ($body['heroic_ability_id'] ?? 0));
        if ($ability === null) {
            return jsonResponse($response, [
                'error' => 'Unbekanntes Talent.',
            ], 422);
        }

        $characterRepository->learnHeroicAbility((int) $character['id'], $ability);

        if ($ability['name_de'] === 'Magisches Talent' && isset($body['school_skill_id'])) {
            $characterRepository->trainSkill((int) $character['id'], (int) $body['school_skill_id']);
        }

        return jsonResponse($response, [
            'learned' => true,
        ]);
    }));

    foreach ([
        'weapons' => 'Weapon',
        'inventory' => 'InventoryItem',
    ] as $segment => $methodSuffix) {
        $app->post("/character/{id:[0-9]+}/{$segment}", $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix): Response {
            $addMethod = 'add' . $methodSuffix;
            $rowId = $characterRepository->{$addMethod}((int) $character['id']);

            return jsonResponse($response, [
                'added' => true,
                'row_id' => $rowId,
            ]);
        }));

        $app->post("/character/{id:[0-9]+}/{$segment}/{rowId}", $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix): Response {
            $body = json_decode((string) $request->getBody(), true) ?? [];
            $updateMethod = 'update' . $methodSuffix;
            $characterRepository->{$updateMethod}((int) $character['id'], (int) $args['rowId'], $body);

            return jsonResponse($response, [
                'updated' => true,
            ]);
        }));

        $app->delete("/character/{id:[0-9]+}/{$segment}/{rowId}", $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository, $methodSuffix): Response {
            $removeMethod = 'remove' . $methodSuffix;
            $characterRepository->{$removeMethod}((int) $character['id'], (int) $args['rowId']);

            return jsonResponse($response, [
                'removed' => true,
            ]);
        }));
    }

    $app->post('/character/{id:[0-9]+}/armor/{slot}', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        $body = json_decode((string) $request->getBody(), true) ?? [];

        try {
            $characterRepository->updateArmorSlot((int) $character['id'], (string) $args['slot'], $body);
        } catch (InvalidArgumentException $e) {
            return jsonResponse($response, [
                'error' => $e->getMessage(),
            ], 422);
        }

        return jsonResponse($response, [
            'updated' => true,
        ]);
    }));

    $app->delete('/character/{id:[0-9]+}', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        if ((bool) $character['is_default']) {
            return jsonResponse($response, [
                'error' => 'Default-Charaktere können nicht gelöscht werden.',
            ], 403);
        }

        if ($character['portrait_path'] !== null && str_starts_with($character['portrait_path'], 'images/characters/uploads/')) {
            $path = publicPath($character['portrait_path']);
            if (is_file($path)) {
                unlink($path);
            }
        }

        $characterRepository->delete((int) $character['id']);

        return jsonResponse($response, [
            'deleted' => true,
        ]);
    }));

    // Portraits are permanent once set (default roster seed data, or this
    // upload) -- see the schema.sql comment on characters.portrait_path.
    $app->post('/character/{id:[0-9]+}/portrait', $withCharacter($characterRepository, function (Request $request, Response $response, array $args, array $character) use ($characterRepository): Response {
        if ($character['portrait_path'] !== null) {
            return jsonResponse($response, [
                'error' => 'Dieser Charakter hat bereits ein Bild.',
            ], 409);
        }

        $characterId = (int) $character['id'];
        $stored = storeUploadedImage($request->getUploadedFiles()['portrait'] ?? null, 'images/characters/uploads', $characterId);
        if (isset($stored['error'])) {
            return jsonResponse($response, [
                'error' => $stored['error'],
            ], 422);
        }

        $relativePath = $stored['path'];
        if (! $characterRepository->setPortraitPath($characterId, $relativePath)) {
            unlink(publicPath($relativePath));

            return jsonResponse($response, [
                'error' => 'Dieser Charakter hat bereits ein Bild.',
            ], 409);
        }

        return jsonResponse($response, [
            'portrait_path' => $relativePath,
        ]);
    }));
};
