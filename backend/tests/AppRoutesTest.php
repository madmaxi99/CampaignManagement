<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

/**
 * Public pages, DM login and the campaign workflow, driven as a visitor or DM.
 */
final class AppRoutesTest extends AppTestCase
{
    private int $campaignId = 0;

    protected function tearDown(): void
    {
        if ($this->campaignId !== 0) {
            $this->db->exec('DELETE FROM campaigns WHERE id = ' . $this->campaignId);
        }
        parent::tearDown();
    }

    public function testPublicPages(): void
    {
        foreach (['/characters', '/rules', '/lore', '/character/create', '/dm/login'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }

        $rules = (string) $this->request('GET', '/rules')
            ->getBody();
        foreach (['Traglast', 'Leibwächter', 'Rasten', 'Sturzschaden', 'Jagd'] as $text) {
            self::assertStringContainsString($text, $rules);
        }
        foreach (['Improvisierte Waffen: Gasthaus', 'Grimmigkeit', 'panel-dm'] as $text) {
            self::assertStringNotContainsString($text, $rules);
        }

        self::assertSame(302, $this->request('GET', '/')->getStatusCode());
        self::assertSame(404, $this->request('GET', '/character/999999')->getStatusCode());
        self::assertSame('/dm', $this->request('GET', '/campaign')->getHeaderLine('Location'));
        self::assertSame('/dm/campaign/3', $this->request('GET', '/campaign/3')->getHeaderLine('Location'));
        self::assertSame('/dm/catalog', $this->request('GET', '/world')->getHeaderLine('Location'));
        self::assertSame(200, $this->request('GET', '/api/character-creation/catalog')->getStatusCode());
    }

    public function testExampleCampaignsCanBePlannedAndPlayed(): void
    {
        $this->loginAsDm();

        foreach ([1, 2, 3, 4] as $id) {
            foreach (['', '/play'] as $suffix) {
                $path = "/dm/campaign/{$id}{$suffix}";
                $response = $this->request('GET', $path);
                self::assertSame(200, $response->getStatusCode(), $path);
                $this->assertCleanBody($response, $path);
            }
        }

        $play = (string) $this->request('GET', '/dm/campaign/4/play')
            ->getBody();
        self::assertStringContainsString('Wurf am Tisch', $play);
        self::assertStringNotContainsString('data-die', $play, 'the app never rolls dice');
        self::assertStringContainsString('Jaldo', $play);
    }

    public function testDmAreaIsLockedWithoutLogin(): void
    {
        $page = $this->request('GET', '/dm');
        self::assertSame(302, $page->getStatusCode());
        self::assertStringStartsWith('/dm/login', $page->getHeaderLine('Location'));

        self::assertSame(401, $this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test',
        ])->getStatusCode());
    }

    public function testGameMasterRulesAreOnlyForTheDm(): void
    {
        self::assertSame(302, $this->request('GET', '/dm/rules')->getStatusCode());

        $this->loginAsDm();
        $expected = [
            'spielleitung' => 'Gefolge',
            'kampf' => 'NSC bei null TP',
            'monster' => 'Grimmigkeit',
            'reise' => 'Reise-Missgeschicke',
            'nsc' => 'Eigenart',
            'beispiele' => 'Improvisierte Waffen: Gasthaus',
        ];
        foreach ($expected as $slug => $text) {
            $response = $this->request('GET', '/dm/rules?k=' . $slug);
            self::assertSame(200, $response->getStatusCode(), $slug);
            self::assertStringContainsString($text, (string) $response->getBody(), $slug);
        }

        self::assertSame(404, $this->request('GET', '/dm/rules?k=gibtesnicht')->getStatusCode());
        self::assertStringNotContainsString('Grimmigkeit', (string) $this->request('GET', '/rules')->getBody());
    }

    public function testWrongPasswordIsRejected(): void
    {
        $this->request('GET', '/dm/login');
        $response = $this->request('POST', '/dm/login', [
            'password' => 'wrong',
            '_csrf' => $_SESSION['csrf'],
        ], form: true);

        self::assertSame(401, $response->getStatusCode());
    }

    public function testDmPagesAndCampaignWorkflow(): void
    {
        $this->loginAsDm();

        foreach (['/dm', '/dm/lore', '/dm/party', '/dm/styleguide', '/dm/catalog/items', '/dm/catalog/bestiary', '/dm/catalog/encounters'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }

        // campaign
        $created = $this->json($this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test',
        ]), 201);
        $this->campaignId = (int) $created['id'];
        $base = '/dm/campaign/' . $this->campaignId;
        $this->ok($this->request('POST', $base, [
            'name_de' => 'Route-Test 2',
            'teaser_de' => 'x',
        ]));

        // chapters
        $chapter = (int) $this->json($this->request('POST', $base . '/chapters', [
            'title_de' => 'Kapitel',
        ]), 201)['id'];
        $second = (int) $this->json($this->request('POST', $base . '/chapters', [
            'title_de' => 'Kapitel 2',
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/chapters/' . $chapter, [
            'title_de' => 'Kapitel neu',
        ]));
        $this->ok($this->request('POST', $base . '/chapters/' . $second . '/move', [
            'direction' => 'up',
        ]));

        // places
        $place = (int) $this->json($this->request('POST', $base . '/places', [
            'name_de' => 'Turm',
            'chapter_id' => $chapter,
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/places/' . $place, [
            'name_de' => 'Turm neu',
            'number_label' => '1',
            'chapter_id' => $chapter,
        ]));

        // npcs, items
        $npc = (int) $this->json($this->request('POST', $base . '/npcs', [
            'name_de' => 'Alberta',
            'place_id' => $place,
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/npcs/' . $npc, [
            'name_de' => 'Alberta II',
        ]));
        $this->ok($this->request('POST', $base . '/npcs/' . $npc . '/notes', [
            'notes_de' => 'lebt',
        ]));
        $item = (int) $this->json($this->request('POST', $base . '/items', [
            'name_de' => 'Buch',
            'place_id' => $place,
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/items/' . $item, [
            'name_de' => 'Altes Buch',
        ]));

        // monsters
        $creature = (int) $this->db->query('SELECT id FROM catalog_bestiary ORDER BY id LIMIT 1')
            ->fetchColumn();
        if ($creature !== 0) {
            $this->ok($this->request('POST', $base . '/monsters', [
                'bestiary_id' => $creature,
            ]));
            $this->ok($this->request('POST', $base . '/monsters/' . $creature . '/notes', [
                'notes_de' => 'viele',
            ]));
        }

        // plan and play pages render with all that data
        foreach ([$base, $base . '/play'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
            self::assertStringContainsString('Alberta II', (string) $response->getBody());
        }

        // validation errors become 422
        self::assertSame(422, $this->request('POST', $base . '/npcs', [
            'name_de' => '',
        ])->getStatusCode());
        self::assertSame(404, $this->request('POST', $base . '/npcs/999999', [
            'name_de' => 'X',
        ])->getStatusCode());
        self::assertSame(404, $this->request('GET', '/dm/campaign/999999')->getStatusCode());

        // restart, then deletes
        $this->ok($this->request('POST', $base . '/restart', []));
        if ($creature !== 0) {
            $this->ok($this->request('DELETE', $base . '/monsters/' . $creature));
        }
        $this->ok($this->request('DELETE', $base . '/items/' . $item));
        $this->ok($this->request('DELETE', $base . '/npcs/' . $npc));
        $this->ok($this->request('DELETE', $base . '/places/' . $place));
        $this->ok($this->request('DELETE', $base . '/chapters/' . $chapter));
        $this->ok($this->request('DELETE', $base));
        self::assertSame(404, $this->request('GET', $base)->getStatusCode());
        $this->campaignId = 0;
    }

    public function testDmWriteWithoutCsrfTokenIsRejected(): void
    {
        $this->loginAsDm();

        $response = $this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test',
        ], csrf: false);

        self::assertSame(403, $response->getStatusCode());
    }
}
