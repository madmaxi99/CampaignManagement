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

    public function testRulesAndLoreAreAreasOfTheirOwn(): void
    {
        self::assertSame(302, $this->request('GET', '/dm/rules')->getStatusCode());
        self::assertSame(302, $this->request('GET', '/dm/lore')->getStatusCode());

        $this->loginAsDm();
        $expected = [
            '/dm/rules?k=spielleitung' => 'Gefolge',
            '/dm/rules?k=kampf' => 'Improvisierte Waffen: Gasthaus',
            '/dm/rules?k=monster' => 'Grimmigkeit',
            '/dm/rules?k=reise' => 'Reise-Missgeschicke',
            '/dm/rules?k=nsc' => 'Eigenart',
            '/dm/rules?k=zufallsbegegnungen' => 'Zufallsbegegnungen',
            '/dm/lore?k=orte' => 'Hohenfurt',
        ];
        foreach ($expected as $path => $text) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            self::assertStringContainsString($text, (string) $response->getBody(), $path);
            $this->assertCleanBody($response, $path);
        }
        self::assertStringContainsString(' open>', (string) $this->request('GET', '/dm/rules?k=reise')->getBody(), 'tables are open');
        self::assertSame(200, $this->request('GET', '/dm/rules')->getStatusCode(), 'the first chapter is the default');
        self::assertSame(200, $this->request('GET', '/dm/lore')->getStatusCode());
        self::assertSame(404, $this->request('GET', '/dm/rules?k=beispiele')->getStatusCode());
        self::assertSame(404, $this->request('GET', '/dm/lore?k=gibtesnicht')->getStatusCode());
        self::assertStringNotContainsString('Grimmigkeit', (string) $this->request('GET', '/rules')->getBody());

        $page = (string) $this->request('GET', '/dm/rules')
            ->getBody();
        foreach (['/dm', '/dm/catalog', '/dm/rules', '/dm/lore'] as $target) {
            self::assertStringContainsString('href="' . $target . '"', $page, 'the navigation links ' . $target);
        }
        self::assertStringNotContainsString('href="/dm/party"', $page, 'the group belongs to the campaign');
    }

    public function testCatalogHasOneMenuAndSplitsLongLists(): void
    {
        $this->loginAsDm();

        $items = (string) $this->request('GET', '/dm/catalog/items?k=armor')
            ->getBody();
        self::assertStringContainsString('class="catalog-nav"', $items);
        self::assertStringContainsString('class="catalog-browser ui-card"', $items, 'menu and list are one card');
        self::assertStringContainsString('Rüstungen', $items);
        self::assertStringContainsString('Sonstiges', $items, 'every category is in the menu');
        self::assertStringContainsString('dm-main--fill', $items);
        self::assertStringNotContainsString('Kurzschwert', $items, 'a weapon is not listed under armor');
        self::assertStringNotContainsString('catalog-groups', $items, 'no second category menu');
        self::assertStringNotContainsString('aria-label="Katalog"><a', $items);

        $creatures = (string) $this->request('GET', '/dm/catalog/bestiary?k=Untot')
            ->getBody();
        self::assertStringContainsString('Alltagsvolk', $creatures);
        self::assertMatchesRegularExpression('/aria-current="page">\s*<span>Untot<\/span>/', $creatures, 'the open category is marked');

        $first = (int) $this->db->query("SELECT id FROM catalog_bestiary WHERE category_de = 'Tier' ORDER BY name_de LIMIT 1")
            ->fetchColumn();
        $opened = (string) $this->request('GET', '/dm/catalog/bestiary?e=' . $first)
            ->getBody();
        self::assertMatchesRegularExpression('/aria-current="page">\s*<span>Tier<\/span>/', $opened, 'an opened entry selects its own category');

        $encounters = (string) $this->request('GET', '/dm/catalog/encounters')
            ->getBody();
        self::assertStringContainsString('catalog-workspace--two', $encounters);
        self::assertStringContainsString('href="/dm/catalog/encounters" aria-current="page"', $encounters, 'the open group is marked');
    }

    public function testSearchIsOnlyForTheDm(): void
    {
        self::assertSame(302, $this->request('GET', '/dm/search?q=spinne')->getStatusCode());

        $this->loginAsDm();
        $monsters = $this->json($this->request('GET', '/dm/search?q=spinne&t=monster'), 200)['results'];
        self::assertSame('Riesenspinne', $monsters[0]['title']);
        self::assertSame('bestiary', $monsters[0]['entity']);

        $spells = $this->json($this->request('GET', '/dm/search?q=Kerze'), 200)['results'];
        self::assertContains('Entzünden', array_column($spells, 'title'));

        self::assertSame([], $this->json($this->request('GET', '/dm/search?q='), 200)['results'], 'no query, no results');
        self::assertSame([], $this->json($this->request('GET', '/dm/search?q=50%25_%5C'), 200)['results'], 'wildcards are escaped');
        self::assertNotSame([], $this->json($this->request('GET', '/dm/search?t=spell'), 200)['results'], 'a category lists without a query');
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

        foreach (['/dm', '/dm/rules', '/dm/lore', '/dm/party', '/dm/styleguide', '/dm/catalog/items', '/dm/catalog/bestiary', '/dm/catalog/encounters'] as $path) {
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
