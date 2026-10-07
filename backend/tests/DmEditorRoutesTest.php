<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

/**
 * DM editors outside of the campaign plan: catalog items, bestiary, party
 * and the campaign chronicle.
 */
final class DmEditorRoutesTest extends AppTestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        $this->loginAsDm();
    }

    protected function tearDown(): void
    {
        $this->db->exec("DELETE FROM catalog_items WHERE name_de LIKE 'Route-Test%'");
        $this->db->exec("DELETE FROM catalog_bestiary WHERE name_de LIKE 'Route-Test%'");
        $this->db->exec("DELETE FROM characters WHERE name_de LIKE 'Route-Test%'");
        $this->db->exec("DELETE FROM campaigns WHERE name_de LIKE 'Route-Test%'");
        parent::tearDown();
    }

    public function testItemEditor(): void
    {
        $id = (int) $this->json($this->request('POST', '/dm/catalog/items', [
            'name_de' => 'Route-Test Schwert',
            'kind' => 'weapon',
            'grip_de' => '1H',
            'range_de' => '1',
            'damage_de' => 'W8',
        ]), 201)['id'];

        foreach (['/dm/catalog/items?e=' . $id, '/dm/catalog/items?e=new'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }
        self::assertSame(302, $this->request('GET', '/dm/catalog/items?e=999999')->getStatusCode());

        $this->json($this->request('POST', '/dm/catalog/items/' . $id, [
            'name_de' => 'Route-Test Dolch',
            'kind' => 'misc',
        ]), 200);
        self::assertSame(422, $this->request('POST', '/dm/catalog/items', [
            'name_de' => '',
            'kind' => 'misc',
        ])->getStatusCode());
        self::assertSame(404, $this->request('POST', '/dm/catalog/items/999999', [
            'name_de' => 'x',
            'kind' => 'misc',
        ])->getStatusCode());

        $this->json($this->request('DELETE', '/dm/catalog/items/' . $id), 200);
        self::assertSame(404, $this->request('DELETE', '/dm/catalog/items/' . $id)->getStatusCode());
    }

    public function testBestiaryEditor(): void
    {
        $id = (int) $this->json($this->request('POST', '/dm/catalog/bestiary', [
            'name_de' => 'Route-Test Wolf',
            'hp' => 5,
            'grimmigkeit_de' => 'W6',
            'size_de' => 'Mittel',
            'movement' => 12,
        ]), 201)['id'];

        foreach (['/dm/catalog/bestiary?e=' . $id, '/dm/catalog/bestiary?e=new'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }
        self::assertSame(422, $this->request('POST', '/dm/catalog/bestiary/' . $id . '/image')->getStatusCode());
        self::assertSame(404, $this->request('POST', '/dm/catalog/bestiary/999999/image')->getStatusCode());
        self::assertSame(422, $this->request('POST', '/dm/catalog/bestiary', [
            'name_de' => '',
        ])->getStatusCode());

        $this->json($this->request('DELETE', '/dm/catalog/bestiary/' . $id), 200);
        self::assertSame(404, $this->request('POST', '/dm/catalog/bestiary/' . $id, [
            'name_de' => 'x',
        ])->getStatusCode());
    }

    public function testPartyManagement(): void
    {
        $id = (int) $this->json($this->request('POST', '/characters', $this->wizardPayload()), 200)['id'];

        $this->json($this->request('POST', '/dm/party', [
            'character_id' => $id,
        ]), 201);
        self::assertStringContainsString('Route-Test Held', (string) $this->request('GET', '/dm/party')->getBody());
        $this->json($this->request('DELETE', '/dm/party/' . $id), 200);
        $this->json($this->request('POST', '/dm/party', [
            'character_id' => $id,
        ]), 201);
        $this->json($this->request('DELETE', '/dm/party'), 200);
    }

    public function testChronicle(): void
    {
        $campaign = (int) $this->json($this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test Chronik',
        ]), 201)['id'];
        $base = '/dm/campaign/' . $campaign . '/chronicle';

        $entry = (int) $this->json($this->request('POST', $base, [
            'title_de' => 'Tag 1',
            'text_de' => 'Die Gruppe bricht auf.',
        ]), 201)['id'];
        $this->json($this->request('POST', $base . '/' . $entry, [
            'text_de' => 'Die Gruppe kehrt um.',
        ]), 200);
        self::assertStringContainsString('Die Gruppe kehrt um.', (string) $this->request('GET', '/dm/campaign/' . $campaign . '/play')->getBody());
        self::assertSame(422, $this->request('POST', $base, [
            'text_de' => '',
        ])->getStatusCode());
        self::assertSame(404, $this->request('POST', $base . '/999999', [
            'text_de' => 'x',
        ])->getStatusCode());

        $this->json($this->request('DELETE', $base . '/' . $entry), 200);
    }
}
