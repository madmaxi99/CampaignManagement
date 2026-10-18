<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use PDO;

/**
 * The player side: creating a character through the wizard endpoint and
 * playing it (HP/WP, conditions, currency, skills, gear, level-up, delete).
 */
final class CharacterRoutesTest extends AppTestCase
{
    public function testWizardCreatesCharacterWhoCanBePlayedAndDeleted(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];
        $base = '/character/' . $id;

        foreach ([$base, $base . '/levelup', '/characters'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }
        self::assertStringContainsString('Route-Test', (string) $this->request('GET', $base)->getBody());

        $max = (int) $this->db->query("SELECT hp_max FROM characters WHERE id = {$id}")
            ->fetchColumn();
        self::assertSame(1, $this->json($this->request('POST', $base . '/hp', [
            'value' => 1,
        ]), 200)['hp_current']);
        self::assertSame($max, $this->json($this->request('POST', $base . '/hp', [
            'value' => 999,
        ]), 200)['hp_current']);
        $this->json($this->request('POST', $base . '/wp', [
            'value' => 1,
        ]), 200);

        $condition = (string) $this->db->query('SELECT code FROM catalog_conditions ORDER BY code LIMIT 1')
            ->fetchColumn();
        self::assertTrue($this->json($this->request('POST', "{$base}/conditions/{$condition}/toggle"), 200)['active']);
        self::assertFalse($this->json($this->request('POST', "{$base}/conditions/{$condition}/toggle"), 200)['active']);

        $this->json($this->request('POST', $base . '/memory', [
            'text' => 'Erinnerung',
        ]), 200);
        self::assertSame([
            'gold' => 1,
            'silver' => 2,
            'copper' => 0,
        ], $this->json($this->request('POST', $base . '/currency', [
            'gold' => 1,
            'silver' => 2,
            'copper' => -5,
        ]), 200));

        $skill = (int) $this->db->query("SELECT skill_id FROM character_skills WHERE character_id = {$id} LIMIT 1")
            ->fetchColumn();
        $this->json($this->request('POST', "{$base}/skills/{$skill}/mark", [
            'marked' => true,
        ]), 200);
        $this->json($this->request('POST', "{$base}/skills/{$skill}/advance", [
            'apply' => true,
        ]), 200);

        foreach (['weapons', 'inventory'] as $segment) {
            $row = (int) $this->json($this->request('POST', "{$base}/{$segment}"), 200)['row_id'];
            $this->json($this->request('POST', "{$base}/{$segment}/{$row}", [
                'name_de' => 'Route-Test Ding',
            ]), 200);
            $this->json($this->request('DELETE', "{$base}/{$segment}/{$row}"), 200);
        }
        $this->json($this->request('POST', $base . '/armor/body', [
            'name_de' => 'Route-Test Rüstung',
        ]), 200);
        self::assertSame(422, $this->request('POST', $base . '/armor/nowhere', [
            'name_de' => 'x',
        ])->getStatusCode());

        self::assertSame(422, $this->request('POST', $base . '/heroic-abilities', [
            'heroic_ability_id' => 0,
        ])->getStatusCode());

        // portraits: without a file the upload is refused and the existing portrait stays
        $this->db->exec("UPDATE characters SET portrait_path = 'images/characters/x.jpg' WHERE id = {$id}");
        self::assertSame(422, $this->request('POST', $base . '/portrait')->getStatusCode());
        self::assertSame('images/characters/x.jpg', $this->db->query("SELECT portrait_path FROM characters WHERE id = {$id}")->fetchColumn());

        // profile: name must not be empty, texts are saved, an empty story becomes NULL
        self::assertSame(422, $this->request('POST', $base . '/profile', [
            'name' => '  ',
        ])->getStatusCode());
        $this->json($this->request('POST', $base . '/profile', [
            'name' => ' Neuer Name ',
            'appearance' => 'Narbe am Kinn',
            'story' => 'Ein langer Weg.',
        ]), 200);
        $row = $this->db->query("SELECT name_de, appearance_de, story_de FROM characters WHERE id = {$id}")
            ->fetch();
        self::assertSame(['Neuer Name', 'Narbe am Kinn', 'Ein langer Weg.'], array_values($row));
        $this->json($this->request('POST', $base . '/profile', [
            'name' => 'Neuer Name',
        ]), 200);
        self::assertNull($this->db->query("SELECT story_de FROM characters WHERE id = {$id}")->fetchColumn());

        $this->json($this->request('DELETE', $base), 200);
        self::assertSame(404, $this->request('GET', $base)->getStatusCode());
        self::assertSame(404, $this->request('POST', $base . '/hp', [
            'value' => 1,
        ])->getStatusCode());
    }

    public function testRestHealsAccordingToTheRestType(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];
        $base = '/character/' . $id;
        $condition = (string) $this->db->query('SELECT code FROM catalog_conditions ORDER BY code LIMIT 1')
            ->fetchColumn();
        $hpMax = (int) $this->db->query("SELECT hp_max FROM characters WHERE id = {$id}")
            ->fetchColumn();
        $wpMax = (int) $this->db->query("SELECT wp_max FROM characters WHERE id = {$id}")
            ->fetchColumn();
        $this->request('POST', $base . '/hp', [
            'value' => 0,
        ]);
        $this->request('POST', $base . '/wp', [
            'value' => 0,
        ]);
        $this->request('POST', "{$base}/conditions/{$condition}/toggle");

        $breather = $this->json($this->request('POST', $base . '/rest', [
            'type' => 'breather',
            'wp_roll' => 4,
        ]), 200);
        self::assertSame(0, $breather['hp_gain']);
        self::assertSame(min(4, $wpMax), $breather['wp_gain']);
        self::assertSame([], $breather['cleared']);

        $short = $this->json($this->request('POST', $base . '/rest', [
            'type' => 'short',
            'tended' => true,
            'hp_roll' => 9,
            'wp_roll' => 2,
            'condition' => $condition,
        ]), 200);
        self::assertSame(min(9, $hpMax), $short['hp_gain']);
        self::assertSame([$condition], $short['cleared']);

        $this->request('POST', "{$base}/conditions/{$condition}/toggle");
        $long = $this->json($this->request('POST', $base . '/rest', [
            'type' => 'long',
        ]), 200);
        self::assertSame($hpMax, $long['hp_current']);
        self::assertSame($wpMax, $long['wp_current']);
        self::assertSame([$condition], $long['cleared']);

        self::assertSame(422, $this->request('POST', $base . '/rest', [
            'type' => 'nap',
        ])->getStatusCode());
        self::assertSame(422, $this->request('POST', $base . '/rest', [
            'type' => 'breather',
        ])->getStatusCode(), 'a rest needs the roll made at the table');
        self::assertSame(422, $this->request('POST', $base . '/rest', [
            'type' => 'short',
            'hp_roll' => 7,
            'wp_roll' => 3,
        ])->getStatusCode(), 'W6 TP cannot exceed 6 unless tended');
    }

    public function testDeathRollsLeadToSurvivalWithAnInjuryOrDeath(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];
        $base = '/character/' . $id;

        self::assertSame(422, $this->request('POST', $base . '/death-rolls', [
            'result' => 'success',
        ])->getStatusCode(), 'only at 0 HP');

        $this->request('POST', $base . '/hp', [
            'value' => 0,
        ]);
        $counts = $this->json($this->request('POST', $base . '/death-rolls', [
            'result' => 'dragon',
        ]), 200);
        self::assertSame([
            'death_successes' => 2,
            'death_failures' => 0,
        ], $counts);
        self::assertSame(1, $this->json($this->request('POST', $base . '/death-rolls', [
            'result' => 'damage',
        ]), 200)['death_failures']);
        self::assertSame(3, $this->json($this->request('POST', $base . '/death-rolls', [
            'result' => 'demon',
        ]), 200)['death_failures'], 'counters stop at three');
        self::assertSame(422, $this->request('POST', $base . '/death-rolls', [
            'result' => 'nonsense',
        ])->getStatusCode());
        self::assertSame(0, $this->json($this->request('POST', $base . '/death-rolls', [
            'result' => 'reset',
        ]), 200)['death_failures']);

        self::assertSame(422, $this->request('POST', $base . '/death-rolls/survive', [
            'hp_roll' => 3,
        ])->getStatusCode(), 'needs three successes');
        $this->request('POST', $base . '/death-rolls', [
            'result' => 'dragon',
        ]);
        $this->request('POST', $base . '/death-rolls', [
            'result' => 'success',
        ]);
        self::assertSame(422, $this->request('POST', $base . '/death-rolls/survive', [
            'hp_roll' => 7,
        ])->getStatusCode(), 'W6 only');
        self::assertSame(422, $this->request('POST', $base . '/death-rolls/survive', [
            'hp_roll' => 3,
            'injury_id' => 999999,
        ])->getStatusCode());

        $injuryId = (int) $this->db->query('SELECT id FROM catalog_injuries ORDER BY id LIMIT 1')
            ->fetchColumn();
        $survived = $this->json($this->request('POST', $base . '/death-rolls/survive', [
            'hp_roll' => 3,
            'injury_id' => $injuryId,
        ]), 200);
        self::assertSame(3, $survived['hp_current']);
        self::assertIsArray($survived['injury']);
        self::assertStringContainsString($survived['injury']['name_de'], (string) $this->request('GET', $base)->getBody());

        $row = $this->db->query("SELECT hp_current, death_successes, death_failures FROM characters WHERE id = {$id}")
            ->fetch();
        self::assertSame([3, 0, 0], [(int) $row['hp_current'], (int) $row['death_successes'], (int) $row['death_failures']]);

        $rowId = (int) $this->db->query("SELECT id FROM character_injuries WHERE character_id = {$id}")
            ->fetchColumn();
        self::assertSame(200, $this->request('DELETE', "{$base}/injuries/{$rowId}")->getStatusCode());
        self::assertSame(0, (int) $this->db->query("SELECT COUNT(*) FROM character_injuries WHERE character_id = {$id}")->fetchColumn());

        $this->request('POST', $base . '/hp', [
            'value' => 0,
        ]);
        $this->request('POST', $base . '/death-rolls', [
            'result' => 'failure',
        ]);
        $this->request('POST', $base . '/hp', [
            'value' => 2,
        ]);
        self::assertSame(0, (int) $this->db->query("SELECT death_failures FROM characters WHERE id = {$id}")->fetchColumn(), 'healing above 0 HP resets the rolls');
    }

    public function testMementoHealsAnotherConditionOncePerSession(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];
        $base = '/character/' . $id;
        $this->db->exec("UPDATE characters SET memento_de = 'Ein Zahn' WHERE id = {$id}");
        $codes = $this->db->query('SELECT code FROM catalog_conditions ORDER BY code LIMIT 3')
            ->fetchAll(PDO::FETCH_COLUMN);
        foreach ($codes as $code) {
            $this->request('POST', "{$base}/conditions/{$code}/toggle");
        }
        $short = [
            'type' => 'short',
            'hp_roll' => 2,
            'wp_roll' => 2,
        ];

        self::assertSame(422, $this->request('POST', $base . '/rest', $short + [
            'condition' => $codes[0],
            'memento_condition' => $codes[0],
        ])->getStatusCode(), 'the memento heals a further condition');
        self::assertSame(422, $this->request('POST', $base . '/rest', [
            'type' => 'breather',
            'wp_roll' => 2,
            'memento_condition' => $codes[1],
        ])->getStatusCode(), 'only on a short rest');

        $result = $this->json($this->request('POST', $base . '/rest', $short + [
            'condition' => $codes[0],
            'memento_condition' => $codes[1],
        ]), 200);
        self::assertSame([$codes[0], $codes[1]], $result['cleared']);
        self::assertTrue($result['memento_used']);
        self::assertSame(422, $this->request('POST', $base . '/rest', $short + [
            'memento_condition' => $codes[2],
        ])->getStatusCode(), 'once per session');

        $this->loginAsDm();
    }

    public function testWizardRejectsInvalidInput(): void
    {
        $payload = $this->wizardPayload();

        foreach ([
            [
                'age_code' => 'greis',
            ],
            [
                'name_de' => ' ',
            ],
            [
                'kin_code' => 'nope',
            ],
            [
                'profession_code' => 'nope',
            ],
            [
                'raw_attributes' => [
                    'STA' => 99,
                ],
            ],
            [
                'learned_skill_ids' => [],
            ],
            [
                'heroic_ability_choice' => 'magic',
            ],
            [
                'flaw_roll' => 0,
            ],
            [
                'gear_option_id' => 0,
            ],
        ] as $override) {
            $response = $this->request('POST', '/characters', $override + $payload);
            self::assertSame(422, $response->getStatusCode(), json_encode($override) . $response->getBody());
        }
    }

    public function testWizardGivesFixedGearOnePickPerChoiceAndRepeatedItems(): void
    {
        $itemId = fn (string $name): int => (int) $this->db->query('SELECT id FROM catalog_items WHERE name_de = ' . $this->db->quote($name))
            ->fetchColumn();
        $names = fn (int $id, string $table): array => $this->db->query("SELECT name_de FROM {$table} WHERE character_id = {$id} ORDER BY position")
            ->fetchAll(PDO::FETCH_COLUMN);

        $knight = $this->wizardPayload('kaempfer', 1);

        self::assertSame(422, $this->request('POST', '/characters', $knight)->getStatusCode(), 'pick missing');
        self::assertSame(422, $this->request('POST', '/characters', [
            'gear_choices' => [
                1 => $itemId('Langspeer'),
            ],
        ] + $knight)->getStatusCode(), 'pick from another option');

        $id = (int) $this->json($this->request('POST', '/characters', [
            'gear_choices' => [
                1 => $itemId('Streitaxt'),
            ],
        ] + $knight), 200)['id'];
        self::assertSame(['Streitaxt', 'Schild, klein'], $names($id, 'character_weapons'));
        self::assertContains('Fackel', $names($id, 'character_inventory'));
        self::assertSame('Kettenpanzer', $this->db->query("SELECT name_de FROM character_armor WHERE character_id = {$id} AND slot = 'body'")->fetchColumn());

        $thief = $this->wizardPayload('dieb', 18);
        $id = (int) $this->json($this->request('POST', '/characters', $thief), 200)['id'];
        self::assertSame(['Dolch', 'Dolch'], $names($id, 'character_weapons'));
    }

    public function testDefaultCharactersCannotBeDeleted(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];
        $this->db->exec("UPDATE characters SET is_default = 1 WHERE id = {$id}");

        self::assertSame(403, $this->request('DELETE', '/character/' . $id)->getStatusCode());
    }

    protected function tearDown(): void
    {
        $this->db->exec("DELETE FROM characters WHERE name_de LIKE 'Route-Test%'");
        parent::tearDown();
    }
}
