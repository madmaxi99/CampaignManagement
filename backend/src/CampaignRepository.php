<?php

declare(strict_types=1);

final class CampaignRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function listAll(): array
    {
        $stmt = $this->db->query(<<<SQL
            SELECT c.id, c.name_de, c.teaser_de, c.is_default, c.created_at,
                   (SELECT COUNT(*) FROM campaign_chapters WHERE campaign_id = c.id) AS chapter_count,
                   (SELECT COUNT(*) FROM campaign_places WHERE campaign_id = c.id) AS place_count,
                   (SELECT COUNT(*) FROM campaign_npcs WHERE campaign_id = c.id) AS npc_count,
                   (SELECT COUNT(*) FROM campaign_chronicle WHERE campaign_id = c.id) AS chronicle_count
            FROM campaigns c
            ORDER BY c.name_de
            SQL);

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
                   b.resistances_de, b.immunities_de, b.traits_de, b.kit_de, b.image_path,
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
                   resistances_de, immunities_de, traits_de, kit_de, image_path, NULL AS campaign_notes_de
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
                    n.portrait_path, n.chapter_id, n.place_id, p.name_de AS place_de
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
        $fields = ['campaign_id' => $campaignId] + $this->validatedNpcFields($campaignId, $input);
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
        $fields = $this->validatedNpcFields($campaignId, $input);
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

    private function validatedNpcFields(int $campaignId, array $input): array
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
            'found_hint_de' => $this->limited($input['found_hint_de'] ?? null, 255, 'Der Fundort-Hinweis'),
            'chapter_id' => $this->campaignRef('campaign_chapters', $campaignId, $input['chapter_id'] ?? null, 'Unbekanntes Kapitel.'),
            'place_id' => $this->campaignRef('campaign_places', $campaignId, $input['place_id'] ?? null, 'Unbekannter Ort.'),
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
            SELECT p.id, p.parent_id, p.chapter_id, p.position, p.number_label, p.name_de, p.description_de, p.dm_text_de,
                   p.image_path, p.encounter_table_id, parent.name_de AS parent_de, t.name_de AS encounter_table_de
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
        if (!isset($fields['position'])) {
            $stmt = $this->db->prepare('SELECT COALESCE(MAX(position), 0) + 10 FROM campaign_places WHERE campaign_id = :campaign_id AND parent_id <=> :parent_id');
            $stmt->execute(['campaign_id' => $campaignId, 'parent_id' => $fields['parent_id']]);
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

        $fields = [
            'name_de' => $name,
            'parent_id' => $parentId,
            'chapter_id' => $this->campaignRef('campaign_chapters', $campaignId, $input['chapter_id'] ?? null, 'Unbekanntes Kapitel.'),
            'number_label' => $this->limited($input['number_label'] ?? null, 10, 'Die Nummer'),
            'description_de' => $this->textOrNull($input['description_de'] ?? null),
            'dm_text_de' => $this->textOrNull($input['dm_text_de'] ?? null),
            'encounter_table_id' => $tableId,
        ];
        if (isset($input['position']) && is_numeric($input['position'])) {
            $fields['position'] = (int) $input['position'];
        }

        return $fields;
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
                   i.chapter_id, i.place_id, p.name_de AS place_de
            FROM campaign_items i
            LEFT JOIN campaign_places p ON p.id = i.place_id
            WHERE i.campaign_id = :campaign_id
            ORDER BY i.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    // ---------- helpers ----------

    private function limited(mixed $value, int $max, string $label): ?string
    {
        $text = $this->textOrNull($value);
        if ($text !== null && mb_strlen($text) > $max) {
            throw new InvalidArgumentException("{$label} darf höchstens {$max} Zeichen haben.");
        }

        return $text;
    }

    /**
     * Id of a row of this campaign (chapter, place), or null for "none".
     *
     * @param 'campaign_chapters'|'campaign_places' $table
     * @throws InvalidArgumentException when the id is not part of the campaign
     */
    private function campaignRef(string $table, int $campaignId, mixed $value, string $message): ?int
    {
        $id = $this->idOrNull($value);
        if ($id === null) {
            return null;
        }
        $stmt = $this->db->prepare("SELECT 1 FROM {$table} WHERE id = :id AND campaign_id = :campaign_id");
        $stmt->execute(['id' => $id, 'campaign_id' => $campaignId]);
        if ($stmt->fetchColumn() === false) {
            throw new InvalidArgumentException($message);
        }

        return $id;
    }

    /** @param 'campaign_chapters'|'campaign_places'|'campaign_items'|'campaign_npcs' $table */
    private function rowInCampaign(string $table, int $campaignId, int $id): bool
    {
        $stmt = $this->db->prepare("SELECT 1 FROM {$table} WHERE id = :id AND campaign_id = :campaign_id");
        $stmt->execute(['id' => $id, 'campaign_id' => $campaignId]);

        return $stmt->fetchColumn() !== false;
    }

    // ---------- campaigns ----------

    /** @throws InvalidArgumentException when the input is not valid */
    private function validatedCampaignFields(array $input): array
    {
        $name = $this->limited($input['name_de'] ?? null, 150, 'Der Name');
        if ($name === null) {
            throw new InvalidArgumentException('Eine Kampagne braucht einen Namen.');
        }

        return [
            'name_de' => $name,
            'teaser_de' => $this->limited($input['teaser_de'] ?? null, 255, 'Der Teaser') ?? '',
            'background_de' => $this->textOrNull($input['background_de'] ?? null) ?? '',
        ];
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function create(array $input): int
    {
        $fields = $this->validatedCampaignFields($input) + ['is_default' => 0];
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaigns (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function update(int $campaignId, array $input): void
    {
        $fields = $this->validatedCampaignFields($input);
        $assignments = array_map(fn (string $column) => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare('UPDATE campaigns SET ' . implode(', ', $assignments) . ' WHERE id = :id');
        $stmt->execute($fields + ['id' => $campaignId]);
    }

    /** Standard adventures cannot be deleted (only restarted). */
    public function delete(int $campaignId): bool
    {
        $stmt = $this->db->prepare('DELETE FROM campaigns WHERE id = :id AND is_default = 0');
        $stmt->execute(['id' => $campaignId]);

        return $stmt->rowCount() > 0;
    }

    // ---------- chapters ----------

    public function chapterInCampaign(int $campaignId, int $chapterId): bool
    {
        return $this->rowInCampaign('campaign_chapters', $campaignId, $chapterId);
    }

    /** @throws InvalidArgumentException when the input is not valid */
    private function validatedChapterFields(array $input): array
    {
        $title = $this->limited($input['title_de'] ?? null, 150, 'Der Titel');
        if ($title === null) {
            throw new InvalidArgumentException('Ein Kapitel braucht einen Titel.');
        }

        return ['title_de' => $title, 'notes_de' => $this->textOrNull($input['notes_de'] ?? null)];
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function createChapter(int $campaignId, array $input): int
    {
        $fields = $this->validatedChapterFields($input);
        $stmt = $this->db->prepare(<<<SQL
            INSERT INTO campaign_chapters (campaign_id, label, position, title_de, notes_de)
            SELECT :campaign_id, '0', COALESCE(MAX(position), 0) + 10, :title_de, :notes_de
            FROM campaign_chapters WHERE campaign_id = :campaign_id2
            SQL);
        $stmt->execute($fields + ['campaign_id' => $campaignId, 'campaign_id2' => $campaignId]);
        $id = (int) $this->db->lastInsertId();
        $this->renumberChapters($campaignId);

        return $id;
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function updateChapter(int $campaignId, int $chapterId, array $input): void
    {
        $fields = $this->validatedChapterFields($input);
        $stmt = $this->db->prepare(
            'UPDATE campaign_chapters SET title_de = :title_de, notes_de = :notes_de WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute($fields + ['id' => $chapterId, 'campaign_id' => $campaignId]);
    }

    /** Places, NPCs and items of the chapter stay (they lose the chapter). */
    public function deleteChapter(int $campaignId, int $chapterId): void
    {
        $stmt = $this->db->prepare('DELETE FROM campaign_chapters WHERE id = :id AND campaign_id = :campaign_id');
        $stmt->execute(['id' => $chapterId, 'campaign_id' => $campaignId]);
        $this->renumberChapters($campaignId);
    }

    /** @param 'up'|'down' $direction */
    public function moveChapter(int $campaignId, int $chapterId, string $direction): void
    {
        $stmt = $this->db->prepare('SELECT id FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position, id');
        $stmt->execute(['campaign_id' => $campaignId]);
        $ids = array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN));

        $index = array_search($chapterId, $ids, true);
        $target = $direction === 'up' ? $index - 1 : $index + 1;
        if ($index === false || $target < 0 || $target >= count($ids)) {
            return;
        }
        [$ids[$index], $ids[$target]] = [$ids[$target], $ids[$index]];
        $this->renumberChapters($campaignId, $ids);
    }

    /** Positions 10, 20, ... and labels "1", "2", ... in the given (or current) order. */
    private function renumberChapters(int $campaignId, ?array $orderedIds = null): void
    {
        if ($orderedIds === null) {
            $stmt = $this->db->prepare('SELECT id FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position, id');
            $stmt->execute(['campaign_id' => $campaignId]);
            $orderedIds = array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN));
        }

        $this->db->beginTransaction();
        try {
            // (campaign_id, position) is unique: move everything out of the way first.
            $this->db->prepare('UPDATE campaign_chapters SET position = position + 100000 WHERE campaign_id = :campaign_id')
                ->execute(['campaign_id' => $campaignId]);
            $stmt = $this->db->prepare('UPDATE campaign_chapters SET position = :position, label = :label WHERE id = :id AND campaign_id = :campaign_id');
            foreach ($orderedIds as $index => $id) {
                $stmt->execute(['position' => ($index + 1) * 10, 'label' => (string) ($index + 1), 'id' => $id, 'campaign_id' => $campaignId]);
            }
            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }
    }

    // ---------- places (tree) ----------

    /** All places depth-first (parent before children) with 'depth', for the outline. */
    public function placeTree(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT p.id, p.parent_id, p.chapter_id, p.position, p.number_label, p.name_de, ch.label AS chapter_label
            FROM campaign_places p
            LEFT JOIN campaign_chapters ch ON ch.id = p.chapter_id
            WHERE p.campaign_id = :campaign_id
            ORDER BY p.position, p.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);
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
                $flat[] = $row + ['depth' => $depth];
                $walk((int) $row['id'], $depth + 1);
            }
        };
        $walk(0, 0);

        return $flat;
    }

    /** Refuses places that still have sub-places. @throws InvalidArgumentException */
    public function deletePlace(int $campaignId, int $placeId): void
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM campaign_places WHERE parent_id = :id AND campaign_id = :campaign_id');
        $stmt->execute(['id' => $placeId, 'campaign_id' => $campaignId]);
        if ((int) $stmt->fetchColumn() > 0) {
            throw new InvalidArgumentException('Dieser Ort hat noch Unterorte. Lösche oder verschiebe sie zuerst.');
        }
        $this->db->prepare('DELETE FROM campaign_places WHERE id = :id AND campaign_id = :campaign_id')
            ->execute(['id' => $placeId, 'campaign_id' => $campaignId]);
    }

    // ---------- items ----------

    public function itemInCampaign(int $campaignId, int $itemId): bool
    {
        return $this->rowInCampaign('campaign_items', $campaignId, $itemId);
    }

    /** @throws InvalidArgumentException when the input is not valid */
    private function validatedItemFields(int $campaignId, array $input): array
    {
        $name = $this->limited($input['name_de'] ?? null, 150, 'Der Name');
        if ($name === null) {
            throw new InvalidArgumentException('Ein Item braucht einen Namen.');
        }

        return [
            'name_de' => $name,
            'description_de' => $this->textOrNull($input['description_de'] ?? null),
            'dm_text_de' => $this->textOrNull($input['dm_text_de'] ?? null),
            'text_de' => $this->textOrNull($input['text_de'] ?? null),
            'found_hint_de' => $this->limited($input['found_hint_de'] ?? null, 255, 'Der Fundort-Hinweis'),
            'chapter_id' => $this->campaignRef('campaign_chapters', $campaignId, $input['chapter_id'] ?? null, 'Unbekanntes Kapitel.'),
            'place_id' => $this->campaignRef('campaign_places', $campaignId, $input['place_id'] ?? null, 'Unbekannter Ort.'),
        ];
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function createItem(int $campaignId, array $input): int
    {
        $fields = ['campaign_id' => $campaignId] + $this->validatedItemFields($campaignId, $input);
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaign_items (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /** @throws InvalidArgumentException when the input is not valid */
    public function updateItem(int $campaignId, int $itemId, array $input): void
    {
        $fields = $this->validatedItemFields($campaignId, $input);
        $assignments = array_map(fn (string $column) => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare('UPDATE campaign_items SET ' . implode(', ', $assignments) . ' WHERE id = :id AND campaign_id = :campaign_id');
        $stmt->execute($fields + ['id' => $itemId, 'campaign_id' => $campaignId]);
    }

    public function deleteItem(int $campaignId, int $itemId): void
    {
        $this->db->prepare('DELETE FROM campaign_items WHERE id = :id AND campaign_id = :campaign_id')
            ->execute(['id' => $itemId, 'campaign_id' => $campaignId]);
    }

    public function setItemImage(int $itemId, string $path): void
    {
        $this->db->prepare('UPDATE campaign_items SET image_path = :path WHERE id = :id')->execute(['path' => $path, 'id' => $itemId]);
    }

    // ---------- NPCs (rest) ----------

    public function deleteNpc(int $campaignId, int $npcId): void
    {
        $this->db->prepare('DELETE FROM campaign_npcs WHERE id = :id AND campaign_id = :campaign_id')
            ->execute(['id' => $npcId, 'campaign_id' => $campaignId]);
    }

    /** Play notes only ("alive", "liked Aodhan"), used by the play mode. */
    public function setNpcNotes(int $campaignId, int $npcId, ?string $notes): void
    {
        $notes = $this->textOrNull($notes);
        $this->db->prepare('UPDATE campaign_npcs SET notes_de = :notes WHERE id = :id AND campaign_id = :campaign_id')
            ->execute(['notes' => $notes, 'id' => $npcId, 'campaign_id' => $campaignId]);
    }

    // ---------- monsters used by the campaign ----------

    /** Catalog stat blocks this campaign does not use yet. */
    public function monsterOptions(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT b.id, b.name_de, b.category_de FROM catalog_bestiary b
            WHERE b.id NOT IN (SELECT bestiary_id FROM campaign_bestiary WHERE campaign_id = :campaign_id)
            ORDER BY b.category_de IS NULL, b.category_de, b.name_de
            SQL);
        $stmt->execute(['campaign_id' => $campaignId]);

        return $stmt->fetchAll();
    }

    /** @throws InvalidArgumentException when the stat block does not exist */
    public function addMonster(int $campaignId, int $bestiaryId, ?int $chapterId = null): void
    {
        if (!$this->exists('SELECT 1 FROM catalog_bestiary WHERE id = ?', $bestiaryId)) {
            throw new InvalidArgumentException('Unbekannte Kampfvorlage.');
        }
        $this->db->prepare('INSERT IGNORE INTO campaign_bestiary (campaign_id, bestiary_id, chapter_id) VALUES (:campaign_id, :bestiary_id, :chapter_id)')
            ->execute(['campaign_id' => $campaignId, 'bestiary_id' => $bestiaryId, 'chapter_id' => $chapterId]);
    }

    public function removeMonster(int $campaignId, int $bestiaryId): void
    {
        $this->db->prepare('DELETE FROM campaign_bestiary WHERE campaign_id = :campaign_id AND bestiary_id = :bestiary_id')
            ->execute(['campaign_id' => $campaignId, 'bestiary_id' => $bestiaryId]);
    }

    /** Notes of the campaign about one stat block ("hier 4 Wölfe"). */
    public function setMonsterNotes(int $campaignId, int $bestiaryId, ?string $notes): void
    {
        $this->db->prepare('UPDATE campaign_bestiary SET notes_de = :notes WHERE campaign_id = :campaign_id AND bestiary_id = :bestiary_id')
            ->execute(['notes' => $this->textOrNull($notes), 'campaign_id' => $campaignId, 'bestiary_id' => $bestiaryId]);
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
