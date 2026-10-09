<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Repository;

use Flyka\CampaignManagement\Database\Connection;
use Flyka\CampaignManagement\Http\Input;
use InvalidArgumentException;

final readonly class CampaignMonsterRepository
{
    public function __construct(
        private Connection $db,
        private CampaignLookup $lookup
    ) {
    }

    /**
     * @return list<array<string, mixed>>
     */
    public function bestiary(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT b.id, b.name_de, b.category_de, b.hp, b.grimmigkeit_de, b.size_de, b.movement, b.armor_de,
                   b.resistances_de, b.immunities_de, b.traits_de, b.kit_de, b.image_path,
                   cb.notes_de AS campaign_notes_de
            FROM campaign_bestiary cb
            JOIN catalog_bestiary b ON b.id = cb.bestiary_id
            WHERE cb.campaign_id = :campaign_id
            ORDER BY b.name_de
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);
        $creatures = $stmt->fetchAll();

        return $this->withAttacks($creatures);
    }

    /**
     * Full stat block of one bestiary entry (with attacks), e.g. for the
     * template a unique NPC is based on.
     *
     * @return array<string, mixed>|null
     */
    public function bestiaryById(int $id): ?array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT id, name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de,
                   resistances_de, immunities_de, traits_de, kit_de, image_path, NULL AS campaign_notes_de
            FROM catalog_bestiary
            WHERE id = :id
            SQL);
        $stmt->execute([
            'id' => $id,
        ]);
        $creature = $stmt->fetch();

        return $creature === false ? null : $this->withAttacks([$creature])[0];
    }

    /**
     * @param list<array<string, mixed>> $creatures
     * @return list<array<string, mixed>>
     */
    private function withAttacks(array $creatures): array
    {
        $attackStmt = $this->db->prepare(
            'SELECT roll_de, title_de, effect_de FROM catalog_bestiary_attacks WHERE bestiary_id = :bestiary_id ORDER BY id'
        );
        foreach ($creatures as &$creature) {
            $attackStmt->execute([
                'bestiary_id' => $creature['id'],
            ]);
            $creature['attacks'] = $attackStmt->fetchAll();
        }

        return $creatures;
    }

    /**
     * Bestiary templates for the NPC stat block selector.
     *
     * @return list<array<string, mixed>>
     */
    public function bestiaryOptions(): array
    {
        return $this->db->query('SELECT id, name_de, category_de FROM catalog_bestiary ORDER BY category_de IS NULL, category_de, name_de')
            ->fetchAll();
    }

    /**
     * Catalog stat blocks this campaign does not use yet.
     *
     * @return list<array<string, mixed>>
     */
    public function monsterOptions(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT b.id, b.name_de, b.category_de FROM catalog_bestiary b
            WHERE b.id NOT IN (SELECT bestiary_id FROM campaign_bestiary WHERE campaign_id = :campaign_id)
            ORDER BY b.category_de IS NULL, b.category_de, b.name_de
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchAll();
    }

    /**
     * @throws InvalidArgumentException when the stat block does not exist
     */
    public function addMonster(int $campaignId, int $bestiaryId, ?int $chapterId = null): void
    {
        if (! $this->lookup->exists('SELECT 1 FROM catalog_bestiary WHERE id = ?', $bestiaryId)) {
            throw new InvalidArgumentException('Unbekannte Kampfvorlage.');
        }
        $this->db->prepare('INSERT IGNORE INTO campaign_bestiary (campaign_id, bestiary_id, chapter_id) VALUES (:campaign_id, :bestiary_id, :chapter_id)')
            ->execute([
                'campaign_id' => $campaignId,
                'bestiary_id' => $bestiaryId,
                'chapter_id' => $chapterId,
            ]);
    }

    public function removeMonster(int $campaignId, int $bestiaryId): void
    {
        $this->db->prepare('DELETE FROM campaign_bestiary WHERE campaign_id = :campaign_id AND bestiary_id = :bestiary_id')
            ->execute([
                'campaign_id' => $campaignId,
                'bestiary_id' => $bestiaryId,
            ]);
    }

    /**
     * Notes of the campaign about one stat block ("hier 4 Wölfe").
     */
    public function setMonsterNotes(int $campaignId, int $bestiaryId, ?string $notes): void
    {
        $this->db->prepare('UPDATE campaign_bestiary SET notes_de = :notes WHERE campaign_id = :campaign_id AND bestiary_id = :bestiary_id')
            ->execute([
                'notes' => Input::textOrNull($notes),
                'campaign_id' => $campaignId,
                'bestiary_id' => $bestiaryId,
            ]);
    }

    /**
     * Foes of the current fight with the stat block and attacks of their template.
     *
     * @return list<array<string, mixed>>
     */
    public function foes(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT f.id AS foe_id, f.hp_current, b.id, b.name_de, b.category_de, b.hp, b.grimmigkeit_de, b.size_de,
                   b.movement, b.armor_de, b.resistances_de, b.immunities_de, b.traits_de, b.kit_de, b.image_path
            FROM campaign_foes f
            JOIN catalog_bestiary b ON b.id = f.bestiary_id
            WHERE f.campaign_id = :campaign_id
            ORDER BY f.id
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);

        return $this->withAttacks($stmt->fetchAll());
    }

    /**
     * @throws InvalidArgumentException when the stat block does not exist
     */
    public function addFoe(int $campaignId, int $bestiaryId, int $count = 1): void
    {
        $stmt = $this->db->prepare('SELECT hp FROM catalog_bestiary WHERE id = ?');
        $stmt->execute([$bestiaryId]);
        $hp = $stmt->fetchColumn();
        if ($hp === false) {
            throw new InvalidArgumentException('Unbekannte Kampfvorlage.');
        }
        $insert = $this->db->prepare('INSERT INTO campaign_foes (campaign_id, bestiary_id, hp_current) VALUES (:campaign_id, :bestiary_id, :hp)');
        foreach (range(1, max(1, min(20, $count))) as $ignored) {
            $insert->execute([
                'campaign_id' => $campaignId,
                'bestiary_id' => $bestiaryId,
                'hp' => (int) $hp,
            ]);
        }
    }

    public function setFoeHp(int $campaignId, int $foeId, int $hp): void
    {
        $this->db->prepare(<<<SQL
            UPDATE campaign_foes f JOIN catalog_bestiary b ON b.id = f.bestiary_id
            SET f.hp_current = GREATEST(0, LEAST(:hp, b.hp))
            WHERE f.id = :id AND f.campaign_id = :campaign_id
            SQL)->execute([
            'hp' => $hp,
            'id' => $foeId,
            'campaign_id' => $campaignId,
        ]);
    }

    public function removeFoe(int $campaignId, int $foeId): void
    {
        $this->db->prepare('DELETE FROM campaign_foes WHERE id = :id AND campaign_id = :campaign_id')
            ->execute([
                'id' => $foeId,
                'campaign_id' => $campaignId,
            ]);
    }

    public function clearFoes(int $campaignId): void
    {
        $this->db->prepare('DELETE FROM campaign_foes WHERE campaign_id = ?')
            ->execute([$campaignId]);
    }
}
