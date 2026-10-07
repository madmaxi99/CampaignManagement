<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Campaign;

use Flyka\CampaignManagement\Connection;
use Flyka\CampaignManagement\Input;
use InvalidArgumentException;

final readonly class CampaignPlaceRepository
{
    public function __construct(
        private Connection $db,
        private CampaignLookup $lookup
    ) {
    }

    /**
     * All places of this campaign with their parent's name and encounter table.
     *
     * @return list<array<string, mixed>>
     */
    public function places(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT p.id, p.parent_id, p.chapter_id, p.position, p.number_label, p.name_de, p.description_de, p.dm_text_de,
                   p.image_path, p.encounter_table_id, parent.name_de AS parent_de, t.name_de AS encounter_table_de
            FROM campaign_places p
            LEFT JOIN campaign_places parent ON parent.id = p.parent_id
            LEFT JOIN catalog_encounter_tables t ON t.id = p.encounter_table_id
            WHERE p.campaign_id = :campaign_id
            ORDER BY p.name_de
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchAll();
    }

    public function placeInCampaign(int $campaignId, int $placeId): bool
    {
        $stmt = $this->db->prepare('SELECT 1 FROM campaign_places WHERE campaign_id = :campaign_id AND id = :place_id');
        $stmt->execute([
            'campaign_id' => $campaignId,
            'place_id' => $placeId,
        ]);

        return $stmt->fetchColumn() !== false;
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function createPlace(int $campaignId, array $input): int
    {
        $fields = [
            'campaign_id' => $campaignId,
        ] + $this->validatedPlaceFields($campaignId, $input, null);
        if (! isset($fields['position'])) {
            $stmt = $this->db->prepare('SELECT COALESCE(MAX(position), 0) + 10 FROM campaign_places WHERE campaign_id = :campaign_id AND parent_id <=> :parent_id');
            $stmt->execute([
                'campaign_id' => $campaignId,
                'parent_id' => $fields['parent_id'],
            ]);
            $fields['position'] = (int) $stmt->fetchColumn();
        }
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaign_places (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /**
     * The caller checks that the place belongs to the campaign.
     *
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function updatePlace(int $campaignId, int $placeId, array $input): void
    {
        $fields = $this->validatedPlaceFields($campaignId, $input, $placeId);
        $assignments = array_map(fn (string $column): string => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare(
            'UPDATE campaign_places SET ' . implode(', ', $assignments) . ' WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute($fields + [
            'id' => $placeId,
            'campaign_id' => $campaignId,
        ]);
    }

    public function setPlaceImage(int $placeId, string $path): void
    {
        $stmt = $this->db->prepare('UPDATE campaign_places SET image_path = :path WHERE id = :id');
        $stmt->execute([
            'path' => $path,
            'id' => $placeId,
        ]);
    }

    /**
     * Random encounter tables of the catalog, for the place form.
     *
     * @return list<array<string, mixed>>
     */
    public function encounterTableOptions(): array
    {
        return $this->db->query('SELECT id, name_de FROM catalog_encounter_tables ORDER BY name_de')
            ->fetchAll();
    }

    /**
     * @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    private function validatedPlaceFields(int $campaignId, array $input, ?int $placeId): array
    {
        $name = Input::textOrNull($input['name_de'] ?? null);
        if ($name === null) {
            throw new InvalidArgumentException('Ein Ort braucht einen Namen.');
        }
        if (mb_strlen($name) > 150) {
            throw new InvalidArgumentException('Der Name darf höchstens 150 Zeichen haben.');
        }

        $parentId = Input::idOrNull($input['parent_id'] ?? null);
        if ($parentId !== null) {
            if (! $this->placeInCampaign($campaignId, $parentId)) {
                throw new InvalidArgumentException('Unbekannter übergeordneter Ort.');
            }
            if ($placeId !== null && $this->liesWithin($parentId, $placeId)) {
                throw new InvalidArgumentException('Ein Ort kann nicht in sich selbst oder in einem seiner Unterorte liegen.');
            }
        }

        $tableId = Input::idOrNull($input['encounter_table_id'] ?? null);
        if ($tableId !== null && ! $this->lookup->exists('SELECT 1 FROM catalog_encounter_tables WHERE id = ?', $tableId)) {
            throw new InvalidArgumentException('Unbekannte Begegnungstabelle.');
        }

        $fields = [
            'name_de' => $name,
            'parent_id' => $parentId,
            'chapter_id' => $this->lookup->campaignRef('campaign_chapters', $campaignId, $input['chapter_id'] ?? null, 'Unbekanntes Kapitel.'),
            'number_label' => Input::limited($input['number_label'] ?? null, 10, 'Die Nummer'),
            'description_de' => Input::textOrNull($input['description_de'] ?? null),
            'dm_text_de' => Input::textOrNull($input['dm_text_de'] ?? null),
            'encounter_table_id' => $tableId,
        ];
        if (isset($input['position']) && is_numeric($input['position'])) {
            $fields['position'] = (int) $input['position'];
        }

        return $fields;
    }

    /**
     * True when $candidateId is $ancestorId itself or lies somewhere below it.
     */
    private function liesWithin(int $candidateId, int $ancestorId): bool
    {
        $stmt = $this->db->prepare('SELECT parent_id FROM campaign_places WHERE id = ?');
        for ($depth = 0; $candidateId !== null && $depth < 50; $depth++) {
            if ($candidateId === $ancestorId) {
                return true;
            }
            $stmt->execute([$candidateId]);
            $parent = $stmt->fetchColumn();
            $candidateId = $parent === false || $parent === null ? null : (int) $parent;
        }

        return false;
    }

    /**
     * All places depth-first (parent before children) with 'depth', for the outline.
     *
     * @return list<array<string, mixed>>
     */
    public function placeTree(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT p.id, p.parent_id, p.chapter_id, p.position, p.number_label, p.name_de, ch.label AS chapter_label
            FROM campaign_places p
            LEFT JOIN campaign_chapters ch ON ch.id = p.chapter_id
            WHERE p.campaign_id = :campaign_id
            ORDER BY p.position, p.name_de
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);
        $rows = $stmt->fetchAll();

        $byParent = [];
        $ids = array_column($rows, 'id');
        foreach ($rows as $row) {
            $parent = $row['parent_id'] !== null && in_array($row['parent_id'], $ids, true) ? $row['parent_id'] : 0;
            $byParent[$parent][] = $row;
        }

        $flat = [];
        $walk = function (int $parent, int $depth) use (&$walk, &$flat, $byParent): void {
            foreach ($byParent[$parent] ?? [] as $row) {
                $flat[] = $row + [
                    'depth' => $depth,
                ];
                $walk((int) $row['id'], $depth + 1);
            }
        };
        $walk(0, 0);

        return $flat;
    }

    /**
     * Refuses places that still have sub-places. @throws InvalidArgumentException
     */
    public function deletePlace(int $campaignId, int $placeId): void
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM campaign_places WHERE parent_id = :id AND campaign_id = :campaign_id');
        $stmt->execute([
            'id' => $placeId,
            'campaign_id' => $campaignId,
        ]);
        if ((int) $stmt->fetchColumn() > 0) {
            throw new InvalidArgumentException('Dieser Ort hat noch Unterorte. Lösche oder verschiebe sie zuerst.');
        }
        $this->db->prepare('DELETE FROM campaign_places WHERE id = :id AND campaign_id = :campaign_id')
            ->execute([
                'id' => $placeId,
                'campaign_id' => $campaignId,
            ]);
    }

    /**
     * Catalog encounter tables used by this campaign's places. The entry text
     * is "quantity × creature" or the entry's own text.
     *
     * @return list<array<string, mixed>>
     */
    public function encounterTables(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT DISTINCT t.id, t.name_de
            FROM campaign_places p
            JOIN catalog_encounter_tables t ON t.id = p.encounter_table_id
            WHERE p.campaign_id = :campaign_id
            ORDER BY t.name_de
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);
        $tables = $stmt->fetchAll();

        $entryStmt = $this->db->prepare(<<<SQL
            SELECT e.min_roll, e.max_roll, e.quantity_de, e.text_de, b.name_de AS creature_de
            FROM catalog_encounter_table_entries e
            LEFT JOIN catalog_bestiary b ON b.id = e.bestiary_id
            WHERE e.table_id = :table_id
            ORDER BY e.min_roll
            SQL);
        foreach ($tables as &$table) {
            $entryStmt->execute([
                'table_id' => $table['id'],
            ]);
            $table['entries'] = array_map(function (array $entry): array {
                $parts = [];
                if ($entry['creature_de'] !== null) {
                    $parts[] = ($entry['quantity_de'] !== null ? $entry['quantity_de'] . ' × ' : '') . $entry['creature_de'];
                }
                if ($entry['text_de'] !== null) {
                    $parts[] = $entry['text_de'];
                }

                return [
                    'min_roll' => $entry['min_roll'],
                    'max_roll' => $entry['max_roll'],
                    'text_de' => implode(' – ', $parts),
                ];
            }, $entryStmt->fetchAll());
        }

        return $tables;
    }
}
