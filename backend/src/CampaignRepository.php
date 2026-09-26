<?php

declare(strict_types=1);

final class CampaignRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function listAll(): array
    {
        $stmt = $this->db->query(
            'SELECT slug, name_de, teaser_de, is_default FROM campaigns ORDER BY name_de'
        );

        return $stmt->fetchAll();
    }

    public function findBySlug(string $slug): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM campaigns WHERE slug = :slug');
        $stmt->execute(['slug' => $slug]);
        $campaign = $stmt->fetch();

        return $campaign === false ? null : $campaign;
    }

    public function chapters(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, position, title_de, notes_de FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position'
        );
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    public function locations(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, chapter_id, position, number_label, name_de, read_aloud_de, notes_de FROM campaign_locations WHERE campaign_id = :campaign_id ORDER BY position'
        );
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    public function creatures(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT c.id, c.name_de, c.hp, c.grimmigkeit_de, c.size_de, c.movement, c.armor_de, c.resistances_de, c.immunities_de
            FROM campaign_creature_links l
            JOIN creatures c ON c.id = l.creature_id
            WHERE l.campaign_id = :campaign_id
            ORDER BY c.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);
        $creatures = $stmt->fetchAll();

        foreach ($creatures as &$creature) {
            $attackStmt = $this->db->prepare(
                'SELECT roll_de, title_de, effect_de FROM creature_attacks WHERE creature_id = :creature_id ORDER BY id'
            );
            $attackStmt->execute(['creature_id' => $creature['id']]);
            $creature['attacks'] = $attackStmt->fetchAll();
        }

        return $creatures;
    }

    public function npcs(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT n.id, n.name_de, n.role_de, n.description_de, n.motivation_de, n.stats_de
            FROM campaign_npc_links l
            JOIN npcs n ON n.id = l.npc_id
            WHERE l.campaign_id = :campaign_id
            ORDER BY n.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    public function eventTables(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, name_de FROM campaign_event_tables WHERE campaign_id = :campaign_id ORDER BY position'
        );
        $stmt->execute(['campaign_id' => $campaignId]);
        $tables = $stmt->fetchAll();

        foreach ($tables as &$table) {
            $entryStmt = $this->db->prepare(
                'SELECT min_roll, max_roll, text_de FROM campaign_event_table_entries WHERE table_id = :table_id ORDER BY min_roll'
            );
            $entryStmt->execute(['table_id' => $table['id']]);
            $table['entries'] = $entryStmt->fetchAll();
        }

        return $tables;
    }
}
