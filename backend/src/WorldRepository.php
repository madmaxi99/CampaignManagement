<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use PDO;

/**
 * Read-only lists of the static rule catalog, independent of any campaign.
 */
final readonly class WorldRepository
{
    public function __construct(
        private PDO $db
    ) {
    }

    public function bestiary(): array
    {
        return $this->db->query(
            'SELECT id, name_de, category_de, hp FROM catalog_bestiary ORDER BY category_de, name_de'
        )->fetchAll(PDO::FETCH_ASSOC);
    }

    public function encounterTables(): array
    {
        $tables = $this->db->query('SELECT id, name_de FROM catalog_encounter_tables ORDER BY name_de')
            ->fetchAll(PDO::FETCH_ASSOC);
        $stmt = $this->db->prepare(<<<SQL
            SELECT e.min_roll, e.max_roll, e.quantity_de, e.text_de, b.name_de AS creature_de
            FROM catalog_encounter_table_entries e
            LEFT JOIN catalog_bestiary b ON b.id = e.bestiary_id
            WHERE e.table_id = :table_id
            ORDER BY e.min_roll
            SQL);
        foreach ($tables as &$table) {
            $stmt->execute([
                'table_id' => $table['id'],
            ]);
            $table['entries'] = $stmt->fetchAll(PDO::FETCH_ASSOC);
        }

        return $tables;
    }
}
