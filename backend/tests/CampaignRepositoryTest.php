<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\Campaign\CampaignChapterRepository;
use Flyka\CampaignManagement\Campaign\CampaignItemRepository;
use Flyka\CampaignManagement\Campaign\CampaignLookup;
use Flyka\CampaignManagement\Campaign\CampaignMonsterRepository;
use Flyka\CampaignManagement\Campaign\CampaignNpcRepository;
use Flyka\CampaignManagement\Campaign\CampaignPlaceRepository;
use Flyka\CampaignManagement\Campaign\CampaignRepository;
use InvalidArgumentException;

final class CampaignRepositoryTest extends DatabaseTestCase
{
    private CampaignRepository $campaigns;

    private CampaignChapterRepository $chapters;

    private CampaignNpcRepository $npcs;

    private CampaignPlaceRepository $places;

    private CampaignItemRepository $items;

    private CampaignMonsterRepository $monsters;

    private int $campaignId;

    protected function setUp(): void
    {
        parent::setUp();
        $lookup = new CampaignLookup($this->db);
        $this->campaigns = new CampaignRepository($this->db);
        $this->chapters = new CampaignChapterRepository($this->db, $lookup);
        $this->monsters = new CampaignMonsterRepository($this->db, $lookup);
        $this->npcs = new CampaignNpcRepository($this->db, $lookup, $this->monsters);
        $this->places = new CampaignPlaceRepository($this->db, $lookup);
        $this->items = new CampaignItemRepository($this->db, $lookup);
        $this->campaignId = $this->campaigns->create([
            'name_de' => 'Testkampagne',
        ]);
    }

    protected function tearDown(): void
    {
        $this->db->exec('DELETE FROM campaigns WHERE id = ' . $this->campaignId);
        $this->db->exec('DELETE FROM campaigns WHERE name_de LIKE \'Test%\'');
    }

    // ---------- campaigns ----------

    public function testCreateFindUpdateDelete(): void
    {
        $campaign = $this->campaigns->find($this->campaignId);
        self::assertSame('Testkampagne', $campaign['name_de']);
        self::assertSame('', $campaign['teaser_de']);
        self::assertSame(0, (int) $campaign['is_default']);

        $this->campaigns->update($this->campaignId, [
            'name_de' => '  Testkampagne 2 ',
            'teaser_de' => 'Kurz',
            'background_de' => 'Lang',
        ]);
        $campaign = $this->campaigns->find($this->campaignId);
        self::assertSame('Testkampagne 2', $campaign['name_de']);
        self::assertSame('Kurz', $campaign['teaser_de']);
        self::assertSame('Lang', $campaign['background_de']);

        self::assertContains($this->campaignId, array_map(intval(...), array_column($this->campaigns->listAll(), 'id')));

        self::assertTrue($this->campaigns->delete($this->campaignId));
        self::assertNull($this->campaigns->find($this->campaignId));
        self::assertFalse($this->campaigns->delete($this->campaignId));
    }

    public function testDefaultCampaignCannotBeDeleted(): void
    {
        $this->db->exec('UPDATE campaigns SET is_default = 1 WHERE id = ' . $this->campaignId);

        self::assertFalse($this->campaigns->delete($this->campaignId));
        self::assertNotNull($this->campaigns->find($this->campaignId));

        $this->db->exec('UPDATE campaigns SET is_default = 0 WHERE id = ' . $this->campaignId);
    }

    public function testCampaignNeedsAName(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->campaigns->create([
            'name_de' => '  ',
        ]);
    }

    public function testCampaignNameLengthIsLimited(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->campaigns->create([
            'name_de' => str_repeat('x', 151),
        ]);
    }

    // ---------- chapters ----------

    public function testChaptersAreNumberedAndReordered(): void
    {
        $a = $this->chapters->createChapter($this->campaignId, [
            'title_de' => 'A',
        ]);
        $b = $this->chapters->createChapter($this->campaignId, [
            'title_de' => 'B',
        ]);
        $c = $this->chapters->createChapter($this->campaignId, [
            'title_de' => 'C',
        ]);

        self::assertSame(['1', '2', '3'], array_column($this->chapters->chapters($this->campaignId), 'label'));
        self::assertSame([$a, $b, $c], $this->chapterIds());

        $this->chapters->moveChapter($this->campaignId, $c, 'up');
        self::assertSame([$a, $c, $b], $this->chapterIds());

        $this->chapters->moveChapter($this->campaignId, $a, 'up');
        self::assertSame([$a, $c, $b], $this->chapterIds(), 'moving the first chapter up is a no-op');

        $this->chapters->moveChapter($this->campaignId, $b, 'down');
        self::assertSame([$a, $c, $b], $this->chapterIds(), 'moving the last chapter down is a no-op');

        $this->chapters->deleteChapter($this->campaignId, $c);
        self::assertSame([$a, $b], $this->chapterIds());
        self::assertSame(['1', '2'], array_column($this->chapters->chapters($this->campaignId), 'label'));
    }

    public function testChapterUpdateAndOwnership(): void
    {
        $chapter = $this->chapters->createChapter($this->campaignId, [
            'title_de' => 'Alt',
        ]);
        $this->chapters->updateChapter($this->campaignId, $chapter, [
            'title_de' => 'Neu',
            'notes_de' => 'Notiz',
        ]);

        $row = $this->chapters->chapters($this->campaignId)[0];
        self::assertSame('Neu', $row['title_de']);
        self::assertSame('Notiz', $row['notes_de']);

        self::assertTrue($this->chapters->chapterInCampaign($this->campaignId, $chapter));
        self::assertFalse($this->chapters->chapterInCampaign($this->campaignId + 999, $chapter));
    }

    public function testChapterNeedsATitle(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->chapters->createChapter($this->campaignId, [
            'title_de' => '',
        ]);
    }

    // ---------- places ----------

    public function testPlacesNestAndTreeIsDepthFirst(): void
    {
        $root = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Turm',
        ]);
        $floor = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Erdgeschoss',
            'parent_id' => $root,
            'number_label' => '1',
        ]);
        $room = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Halle',
            'parent_id' => (string) $floor,
        ]);
        $other = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Hof',
        ]);

        $tree = $this->places->placeTree($this->campaignId);
        self::assertSame([$root, $floor, $room, $other], array_map(intval(...), array_column($tree, 'id')));
        self::assertSame([0, 1, 2, 0], array_map(intval(...), array_column($tree, 'depth')));

        $places = $this->places->places($this->campaignId);
        self::assertSame(['Erdgeschoss', 'Halle', 'Hof', 'Turm'], array_column($places, 'name_de'));
        self::assertSame('Turm', $places[0]['parent_de']);

        self::assertTrue($this->places->placeInCampaign($this->campaignId, $room));
        self::assertFalse($this->places->placeInCampaign($this->campaignId + 999, $room));
    }

    public function testPlacePositionsAutoIncrementWithinParent(): void
    {
        $this->places->createPlace($this->campaignId, [
            'name_de' => 'Eins',
        ]);
        $this->places->createPlace($this->campaignId, [
            'name_de' => 'Zwei',
        ]);

        $positions = array_map(intval(...), array_column($this->places->places($this->campaignId), 'position'));
        sort($positions);
        self::assertSame([10, 20], $positions);
    }

    public function testPlaceCannotBecomeItsOwnDescendant(): void
    {
        $root = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Wurzel',
        ]);
        $child = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Kind',
            'parent_id' => $root,
        ]);

        $this->expectException(InvalidArgumentException::class);
        $this->places->updatePlace($this->campaignId, $root, [
            'name_de' => 'Wurzel',
            'parent_id' => $child,
        ]);
    }

    public function testPlaceRejectsForeignReferences(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->places->createPlace($this->campaignId, [
            'name_de' => 'Ort',
            'chapter_id' => 999999,
        ]);
    }

    public function testPlaceWithSubplacesCannotBeDeleted(): void
    {
        $root = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Wurzel',
        ]);
        $child = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Kind',
            'parent_id' => $root,
        ]);

        try {
            $this->places->deletePlace($this->campaignId, $root);
            self::fail('expected InvalidArgumentException');
        } catch (InvalidArgumentException) {
            self::assertTrue($this->places->placeInCampaign($this->campaignId, $root));
        }

        $this->places->deletePlace($this->campaignId, $child);
        $this->places->deletePlace($this->campaignId, $root);
        self::assertSame([], $this->places->places($this->campaignId));
    }

    public function testPlaceImageAndUpdate(): void
    {
        $place = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Ort',
        ]);
        $this->places->updatePlace($this->campaignId, $place, [
            'name_de' => 'Ort neu',
            'description_de' => 'Beschreibung',
            'position' => 5,
        ]);
        $this->places->setPlaceImage($place, 'images/places/' . $place . '.jpg');

        $row = $this->places->places($this->campaignId)[0];
        self::assertSame('Ort neu', $row['name_de']);
        self::assertSame('Beschreibung', $row['description_de']);
        self::assertSame(5, (int) $row['position']);
        self::assertSame('images/places/' . $place . '.jpg', $row['image_path']);
    }

    public function testEncounterTables(): void
    {
        $table = $this->db->query('SELECT id, name_de FROM catalog_encounter_tables ORDER BY id LIMIT 1')
            ->fetch();
        if ($table === false) {
            self::markTestSkipped('catalog has no encounter tables');
        }

        self::assertContains($table['name_de'], array_column($this->places->encounterTableOptions(), 'name_de'));
        self::assertSame([], $this->places->encounterTables($this->campaignId));

        $this->places->createPlace($this->campaignId, [
            'name_de' => 'Mit Tabelle',
            'encounter_table_id' => $table['id'],
        ]);
        $tables = $this->places->encounterTables($this->campaignId);
        self::assertCount(1, $tables);
        self::assertSame($table['name_de'], $tables[0]['name_de']);
        self::assertIsArray($tables[0]['entries']);
    }

    // ---------- NPCs ----------

    public function testNpcLifecycle(): void
    {
        $chapter = $this->chapters->createChapter($this->campaignId, [
            'title_de' => 'K1',
        ]);
        $place = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Taverne',
        ]);
        $npc = $this->npcs->createNpc($this->campaignId, [
            'name_de' => 'Alberta',
            'description_de' => 'Wirtin',
            'chapter_id' => $chapter,
            'place_id' => (string) $place,
            'found_hint_de' => 'Hinter dem Tresen',
        ]);

        $row = $this->npcs->npcs($this->campaignId)[0];
        self::assertSame('Alberta', $row['name_de']);
        self::assertSame('Taverne', $row['place_de']);
        self::assertNull($row['creature']);
        self::assertTrue($this->npcs->npcInCampaign($this->campaignId, $npc));
        self::assertFalse($this->npcs->npcInCampaign($this->campaignId + 999, $npc));

        $this->npcs->updateNpc($this->campaignId, $npc, [
            'name_de' => 'Alberta II',
        ]);
        $this->npcs->setNpcNotes($this->campaignId, $npc, '  lebt  ');
        $this->npcs->setNpcPortrait($npc, 'images/npcs/x.jpg');

        $row = $this->npcs->npcs($this->campaignId)[0];
        self::assertSame('Alberta II', $row['name_de']);
        self::assertSame('lebt', $row['notes_de']);
        self::assertSame('images/npcs/x.jpg', $row['portrait_path']);
        self::assertNull($row['place_de'], 'update without place_id clears the place');

        $this->npcs->setNpcNotes($this->campaignId, $npc, '   ');
        self::assertNull($this->npcs->npcs($this->campaignId)[0]['notes_de']);

        $this->npcs->deleteNpc($this->campaignId, $npc);
        self::assertSame([], $this->npcs->npcs($this->campaignId));
    }

    public function testNpcWithStatBlock(): void
    {
        $creature = $this->db->query('SELECT id, name_de FROM catalog_bestiary ORDER BY id LIMIT 1')
            ->fetch();
        if ($creature === false) {
            self::markTestSkipped('catalog has no bestiary');
        }

        $this->npcs->createNpc($this->campaignId, [
            'name_de' => 'Bestie',
            'bestiary_id' => $creature['id'],
        ]);

        $npc = $this->npcs->npcs($this->campaignId)[0];
        self::assertSame($creature['name_de'], $npc['creature']['name_de']);
        self::assertIsArray($npc['creature']['attacks']);
        self::assertSame($creature['name_de'], $this->monsters->bestiaryById((int) $creature['id'])['name_de']);
        self::assertNull($this->monsters->bestiaryById(999999));
        self::assertNotEmpty($this->monsters->bestiaryOptions());
    }

    public function testNpcValidation(): void
    {
        foreach ([
            [
                'name_de' => '',
            ],
            [
                'name_de' => str_repeat('x', 151),
            ],
            [
                'name_de' => 'X',
                'bestiary_id' => 999999,
            ],
            [
                'name_de' => 'X',
                'found_hint_de' => str_repeat('x', 256),
            ],
            [
                'name_de' => 'X',
                'chapter_id' => 999999,
            ],
        ] as $input) {
            try {
                $this->npcs->createNpc($this->campaignId, $input);
                self::fail('expected InvalidArgumentException for ' . json_encode($input));
            } catch (InvalidArgumentException) {
                self::assertSame([], $this->npcs->npcs($this->campaignId));
            }
        }
    }

    // ---------- items ----------

    public function testItemLifecycle(): void
    {
        $place = $this->places->createPlace($this->campaignId, [
            'name_de' => 'Keller',
        ]);
        $item = $this->items->createItem($this->campaignId, [
            'name_de' => 'Buch',
            'text_de' => 'Inhalt',
            'place_id' => $place,
        ]);

        $row = $this->items->items($this->campaignId)[0];
        self::assertSame('Buch', $row['name_de']);
        self::assertSame('Keller', $row['place_de']);
        self::assertTrue($this->items->itemInCampaign($this->campaignId, $item));
        self::assertFalse($this->items->itemInCampaign($this->campaignId + 999, $item));

        $this->items->updateItem($this->campaignId, $item, [
            'name_de' => 'Altes Buch',
        ]);
        $this->items->setItemImage($item, 'images/items/x.jpg');
        $row = $this->items->items($this->campaignId)[0];
        self::assertSame('Altes Buch', $row['name_de']);
        self::assertNull($row['text_de']);
        self::assertSame('images/items/x.jpg', $row['image_path']);

        $this->items->deleteItem($this->campaignId, $item);
        self::assertSame([], $this->items->items($this->campaignId));
    }

    public function testItemNeedsAName(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->items->createItem($this->campaignId, []);
    }

    // ---------- monsters ----------

    public function testMonstersOfTheCampaign(): void
    {
        $creature = $this->db->query('SELECT id, name_de FROM catalog_bestiary ORDER BY id LIMIT 1')
            ->fetch();
        if ($creature === false) {
            self::markTestSkipped('catalog has no bestiary');
        }
        $id = (int) $creature['id'];

        self::assertContains($id, array_map(intval(...), array_column($this->monsters->monsterOptions($this->campaignId), 'id')));

        $this->monsters->addMonster($this->campaignId, $id);
        $this->monsters->addMonster($this->campaignId, $id);
        $this->monsters->setMonsterNotes($this->campaignId, $id, ' hier 4 Wölfe ');

        $monsters = $this->monsters->bestiary($this->campaignId);
        self::assertCount(1, $monsters);
        self::assertSame($creature['name_de'], $monsters[0]['name_de']);
        self::assertSame('hier 4 Wölfe', $monsters[0]['campaign_notes_de']);
        self::assertIsArray($monsters[0]['attacks']);
        self::assertNotContains($id, array_map(intval(...), array_column($this->monsters->monsterOptions($this->campaignId), 'id')));

        $this->monsters->removeMonster($this->campaignId, $id);
        self::assertSame([], $this->monsters->bestiary($this->campaignId));
    }

    public function testUnknownMonsterIsRejected(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->monsters->addMonster($this->campaignId, 999999);
    }

    // ---------- restart ----------

    public function testRestartClearsChronicleAndNpcNotesButKeepsContent(): void
    {
        $npc = $this->npcs->createNpc($this->campaignId, [
            'name_de' => 'Alberta',
            'notes_de' => 'lebt',
        ]);
        $this->db->exec('INSERT INTO campaign_chronicle (campaign_id, text_de) VALUES (' . $this->campaignId . ', \'Etwas geschah\')');

        $this->campaigns->restart($this->campaignId);

        self::assertSame('0', (string) $this->db->query('SELECT COUNT(*) FROM campaign_chronicle WHERE campaign_id = ' . $this->campaignId)->fetchColumn());
        $row = $this->npcs->npcs($this->campaignId)[0];
        self::assertSame($npc, (int) $row['id']);
        self::assertNull($row['notes_de']);
    }

    /**
     * @return int[]
     */
    private function chapterIds(): array
    {
        return array_map(intval(...), array_column($this->chapters->chapters($this->campaignId), 'id'));
    }
}
