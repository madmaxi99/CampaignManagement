<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

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

        // portraits: no file, then a second portrait is refused
        self::assertSame(422, $this->request('POST', $base . '/portrait')->getStatusCode());
        $this->db->exec("UPDATE characters SET portrait_path = 'images/characters/x.jpg' WHERE id = {$id}");
        self::assertSame(409, $this->request('POST', $base . '/portrait')->getStatusCode());

        $this->json($this->request('DELETE', $base), 200);
        self::assertSame(404, $this->request('GET', $base)->getStatusCode());
        self::assertSame(404, $this->request('POST', $base . '/hp', [
            'value' => 1,
        ])->getStatusCode());
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
