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
            'SELECT id, name_de, teaser_de, is_default FROM campaigns ORDER BY name_de'
        );

        return $stmt->fetchAll();
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM campaigns WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $campaign = $stmt->fetch();

        return $campaign === false ? null : $campaign;
    }

    public function chapters(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, label, position, title_de, notes_de FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position'
        );
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    /** Numbered places (rooms, floors) of the chapters, in reading order. */
    public function locations(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT p.id, p.chapter_id, p.parent_id, p.position, p.number_label, p.name_de,
                   p.description_de, p.dm_text_de, p.image_path
            FROM campaign_places p
            JOIN campaign_chapters ch ON ch.id = p.chapter_id
            WHERE p.campaign_id = :campaign_id AND p.number_label IS NOT NULL
            ORDER BY ch.position, p.position
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    public function bestiary(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT b.id, b.name_de, b.category_de, b.hp, b.grimmigkeit_de, b.size_de, b.movement, b.armor_de,
                   b.resistances_de, b.immunities_de, b.traits_de, b.kit_de,
                   cb.notes_de AS campaign_notes_de
            FROM campaign_bestiary cb
            JOIN catalog_bestiary b ON b.id = cb.bestiary_id
            WHERE cb.campaign_id = :campaign_id
            ORDER BY b.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);
        $creatures = $stmt->fetchAll();

        return $this->withAttacks($creatures);
    }

    /**
     * Full stat block of one bestiary entry (with attacks), e.g. for the
     * template a unique NPC is based on.
     */
    public function bestiaryById(int $id): ?array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT id, name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de,
                   resistances_de, immunities_de, traits_de, kit_de, NULL AS campaign_notes_de
            FROM catalog_bestiary
            WHERE id = :id
            SQL);
        $stmt->execute(['id' => $id]);
        $creature = $stmt->fetch();

        return $creature === false ? null : $this->withAttacks([$creature])[0];
    }

    private function withAttacks(array $creatures): array
    {
        $attackStmt = $this->db->prepare(
            'SELECT roll_de, title_de, effect_de FROM catalog_bestiary_attacks WHERE bestiary_id = :bestiary_id ORDER BY id'
        );
        foreach ($creatures as &$creature) {
            $attackStmt->execute(['bestiary_id' => $creature['id']]);
            $creature['attacks'] = $attackStmt->fetchAll();
        }

        return $creatures;
    }

    public function npcs(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT n.id, n.name_de, n.description_de, n.dm_text_de, n.notes_de, n.found_hint_de, n.bestiary_id,
                    n.portrait_path, p.name_de AS place_de
             FROM campaign_npcs n
             LEFT JOIN campaign_places p ON p.id = n.place_id
             WHERE n.campaign_id = :campaign_id ORDER BY n.name_de'
        );
        $stmt->execute(['campaign_id' => $campaignId]);
        $npcs = $stmt->fetchAll();

        foreach ($npcs as &$npc) {
            $npc['creature'] = $npc['bestiary_id'] !== null ? $this->bestiaryById((int) $npc['bestiary_id']) : null;
        }

        return $npcs;
    }

    /** Bestiary templates for the NPC stat block selector. */
    public function bestiaryOptions(): array
    {
        return $this->db->query('SELECT id, name_de, category_de FROM catalog_bestiary ORDER BY category_de IS NULL, category_de, name_de')->fetchAll();
    }

    public function npcInCampaign(int $campaignId, int $npcId): bool
    {
        $stmt = $this->db->prepare('SELECT 1 FROM campaign_npcs WHERE campaign_id = :campaign_id AND id = :npc_id');
        $stmt->execute(['campaign_id' => $campaignId, 'npc_id' => $npcId]);

        return $stmt->fetchColumn() !== false;
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function createNpc(int $campaignId, array $input): int
    {
        $fields = ['campaign_id' => $campaignId] + $this->validatedNpcFields($input);
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaign_npcs (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /**
     * The caller checks that the NPC belongs to the campaign.
     *
     * @throws InvalidArgumentException when the input is not valid
     */
    public function updateNpc(int $campaignId, int $npcId, array $input): void
    {
        $fields = $this->validatedNpcFields($input);
        $assignments = array_map(fn (string $column) => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare(
            'UPDATE campaign_npcs SET ' . implode(', ', $assignments) . ' WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute($fields + ['id' => $npcId, 'campaign_id' => $campaignId]);
    }

    public function setNpcPortrait(int $npcId, string $path): void
    {
        $stmt = $this->db->prepare('UPDATE campaign_npcs SET portrait_path = :path WHERE id = :id');
        $stmt->execute(['path' => $path, 'id' => $npcId]);
    }

    private function textOrNull(mixed $value): ?string
    {
        if (!is_string($value)) {
            return null;
        }
        $value = trim($value);

        return $value === '' ? null : $value;
    }

    private function validatedNpcFields(array $input): array
    {
        $name = $this->textOrNull($input['name_de'] ?? null);
        if ($name === null) {
            throw new InvalidArgumentException('Ein NPC braucht einen Namen.');
        }
        if (mb_strlen($name) > 150) {
            throw new InvalidArgumentException('Der Name darf höchstens 150 Zeichen haben.');
        }

        $bestiaryId = $this->idOrNull($input['bestiary_id'] ?? null);
        if ($bestiaryId !== null && !$this->exists('SELECT 1 FROM catalog_bestiary WHERE id = ?', $bestiaryId)) {
            throw new InvalidArgumentException('Unbekannte Kampfvorlage.');
        }

        return [
            'name_de' => $name,
            'description_de' => $this->textOrNull($input['description_de'] ?? null),
            'dm_text_de' => $this->textOrNull($input['dm_text_de'] ?? null),
            'notes_de' => $this->textOrNull($input['notes_de'] ?? null),
            'found_hint_de' => $this->textOrNull($input['found_hint_de'] ?? null),
            'bestiary_id' => $bestiaryId,
        ];
    }

    private function idOrNull(mixed $value): ?int
    {
        if ($value === null || $value === '' || !is_numeric($value)) {
            return null;
        }

        return (int) $value;
    }

    private function exists(string $sql, string|int $param): bool
    {
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$param]);

        return $stmt->fetchColumn() !== false;
    }

    /** All places of this campaign with their parent's name and encounter table. */
    public function places(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT p.id, p.parent_id, p.number_label, p.name_de, p.description_de, p.dm_text_de, p.image_path,
                   p.encounter_table_id, parent.name_de AS parent_de, t.name_de AS encounter_table_de
            FROM campaign_places p
            LEFT JOIN campaign_places parent ON parent.id = p.parent_id
            LEFT JOIN catalog_encounter_tables t ON t.id = p.encounter_table_id
            WHERE p.campaign_id = :campaign_id
            ORDER BY p.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    public function placeInCampaign(int $campaignId, int $placeId): bool
    {
        $stmt = $this->db->prepare('SELECT 1 FROM campaign_places WHERE campaign_id = :campaign_id AND id = :place_id');
        $stmt->execute(['campaign_id' => $campaignId, 'place_id' => $placeId]);

        return $stmt->fetchColumn() !== false;
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function createPlace(int $campaignId, array $input): int
    {
        $fields = ['campaign_id' => $campaignId] + $this->validatedPlaceFields($campaignId, $input, null);
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
     */
    public function updatePlace(int $campaignId, int $placeId, array $input): void
    {
        $fields = $this->validatedPlaceFields($campaignId, $input, $placeId);
        $assignments = array_map(fn (string $column) => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare(
            'UPDATE campaign_places SET ' . implode(', ', $assignments) . ' WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute($fields + ['id' => $placeId, 'campaign_id' => $campaignId]);
    }

    public function setPlaceImage(int $placeId, string $path): void
    {
        $stmt = $this->db->prepare('UPDATE campaign_places SET image_path = :path WHERE id = :id');
        $stmt->execute(['path' => $path, 'id' => $placeId]);
    }

    /** Random encounter tables of the catalog, for the place form. */
    public function encounterTableOptions(): array
    {
        return $this->db->query('SELECT id, name_de FROM catalog_encounter_tables ORDER BY name_de')->fetchAll();
    }

    private function validatedPlaceFields(int $campaignId, array $input, ?int $placeId): array
    {
        $name = $this->textOrNull($input['name_de'] ?? null);
        if ($name === null) {
            throw new InvalidArgumentException('Ein Ort braucht einen Namen.');
        }
        if (mb_strlen($name) > 150) {
            throw new InvalidArgumentException('Der Name darf höchstens 150 Zeichen haben.');
        }

        $parentId = $this->idOrNull($input['parent_id'] ?? null);
        if ($parentId !== null) {
            if (!$this->placeInCampaign($campaignId, $parentId)) {
                throw new InvalidArgumentException('Unbekannter übergeordneter Ort.');
            }
            if ($placeId !== null && $this->liesWithin($parentId, $placeId)) {
                throw new InvalidArgumentException('Ein Ort kann nicht in sich selbst oder in einem seiner Unterorte liegen.');
            }
        }

        $tableId = $this->idOrNull($input['encounter_table_id'] ?? null);
        if ($tableId !== null && !$this->exists('SELECT 1 FROM catalog_encounter_tables WHERE id = ?', $tableId)) {
            throw new InvalidArgumentException('Unbekannte Begegnungstabelle.');
        }

        return [
            'name_de' => $name,
            'parent_id' => $parentId,
            'description_de' => $this->textOrNull($input['description_de'] ?? null),
            'dm_text_de' => $this->textOrNull($input['dm_text_de'] ?? null),
            'encounter_table_id' => $tableId,
        ];
    }

    /** True when $candidateId is $ancestorId itself or lies somewhere below it. */
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

    /** Story items of this campaign (books, quest items) with where they are found. */
    public function items(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT i.id, i.name_de, i.description_de, i.dm_text_de, i.text_de, i.found_hint_de, i.image_path,
                   p.name_de AS place_de
            FROM campaign_items i
            LEFT JOIN campaign_places p ON p.id = i.place_id
            WHERE i.campaign_id = :campaign_id
            ORDER BY i.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    /** New group: clears the chronicle and the play notes of the NPCs. Content and catalog stay. */
    public function restart(int $campaignId): void
    {
        $this->db->beginTransaction();
        try {
            foreach ([
                'DELETE FROM campaign_chronicle WHERE campaign_id = :campaign_id',
                'UPDATE campaign_npcs SET notes_de = NULL WHERE campaign_id = :campaign_id',
            ] as $sql) {
                $stmt = $this->db->prepare($sql);
                $stmt->execute(['campaign_id' => $campaignId]);
            }
            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }
    }

    /**
     * Catalog encounter tables used by this campaign's places. The entry text
     * is "quantity × creature" or the entry's own text.
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
        $stmt->execute(['campaign_id' => $campaignId]);
        $tables = $stmt->fetchAll();

        $entryStmt = $this->db->prepare(<<<SQL
            SELECT e.min_roll, e.max_roll, e.quantity_de, e.text_de, b.name_de AS creature_de
            FROM catalog_encounter_table_entries e
            LEFT JOIN catalog_bestiary b ON b.id = e.bestiary_id
            WHERE e.table_id = :table_id
            ORDER BY e.min_roll
            SQL);
        foreach ($tables as &$table) {
            $entryStmt->execute(['table_id' => $table['id']]);
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
