<?php

declare(strict_types=1);

/**
 * DM editing of the two extendable catalog parts: items (weapon/armor/misc)
 * and bestiary stat blocks with their attacks. Everything else in the
 * catalog stays read-only.
 */
final class CatalogEditorRepository
{
    private const RARITIES = ['gewöhnlich', 'ungewöhnlich', 'selten', 'episch', 'legendär', 'einzigartig'];
    private const KINDS = ['weapon', 'armor', 'misc'];
    private const PENALTIES = ['penalty_stealth', 'penalty_evasion', 'penalty_acrobatics', 'penalty_perception', 'penalty_ranged'];

    public function __construct(private PDO $db)
    {
    }

    // ---------- items ----------

    public function itemList(): array
    {
        return $this->db->query(
            'SELECT id, name_de, kind, rarity FROM catalog_items ORDER BY FIELD(kind, \'weapon\', \'armor\', \'misc\'), name_de'
        )->fetchAll();
    }

    public function item(int $id): ?array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT i.id, i.name_de, i.description_de, i.rarity, i.kind,
                   i.price_gold, i.price_silver, i.price_copper,
                   w.grip_de, w.str_requirement, w.range_de, w.damage_de, w.durability, w.traits_de,
                   a.slot AS armor_slot, a.armor_value,
                   a.penalty_stealth, a.penalty_evasion, a.penalty_acrobatics, a.penalty_perception, a.penalty_ranged
            FROM catalog_items i
            LEFT JOIN catalog_item_weapons w ON w.item_id = i.id
            LEFT JOIN catalog_item_armor a ON a.item_id = i.id
            WHERE i.id = :id
            SQL);
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();

        return $row === false ? null : $row;
    }

    /** Creates (id null) or updates an item; returns its id. */
    public function saveItem(?int $id, array $input): int
    {
        $name = $this->required($input['name_de'] ?? null, 'Der Name fehlt.', 150);
        $kind = (string) ($input['kind'] ?? '');
        if (!in_array($kind, self::KINDS, true)) {
            throw new InvalidArgumentException('Ungültige Art des Items.');
        }
        $rarity = (string) ($input['rarity'] ?? 'gewöhnlich');
        if (!in_array($rarity, self::RARITIES, true)) {
            throw new InvalidArgumentException('Ungültige Seltenheit.');
        }
        if ($id !== null && $this->item($id) === null) {
            throw new InvalidArgumentException('Item nicht gefunden.');
        }

        $base = [
            'name_de' => $name,
            'description_de' => trim((string) ($input['description_de'] ?? '')),
            'rarity' => $rarity,
            'price_gold' => $this->count($input['price_gold'] ?? 0),
            'price_silver' => $this->count($input['price_silver'] ?? 0),
            'price_copper' => $this->count($input['price_copper'] ?? 0),
            'kind' => $kind,
        ];

        $this->db->beginTransaction();
        try {
            if ($id === null) {
                $this->db->prepare(<<<SQL
                    INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind)
                    VALUES (:name_de, :description_de, :rarity, :price_gold, :price_silver, :price_copper, :kind)
                    SQL)->execute($base);
                $id = (int) $this->db->lastInsertId();
            } else {
                $this->db->prepare(<<<SQL
                    UPDATE catalog_items SET name_de = :name_de, description_de = :description_de, rarity = :rarity,
                        price_gold = :price_gold, price_silver = :price_silver, price_copper = :price_copper, kind = :kind
                    WHERE id = :id
                    SQL)->execute($base + ['id' => $id]);
            }

            // The subtype row follows the kind; switching kinds drops the other one.
            $this->db->prepare('DELETE FROM catalog_item_weapons WHERE item_id = ?')->execute([$id]);
            $this->db->prepare('DELETE FROM catalog_item_armor WHERE item_id = ?')->execute([$id]);

            if ($kind === 'weapon') {
                $this->db->prepare(<<<SQL
                    INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de)
                    VALUES (:item_id, :grip_de, :str_requirement, :range_de, :damage_de, :durability, :traits_de)
                    SQL)->execute([
                    'item_id' => $id,
                    'grip_de' => $this->required($input['grip_de'] ?? null, 'Der Griff fehlt (z. B. 1H).', 50),
                    'str_requirement' => $this->countOrNull($input['str_requirement'] ?? null),
                    'range_de' => $this->required($input['range_de'] ?? null, 'Die Reichweite fehlt (z. B. 1 oder 10).', 50),
                    'damage_de' => $this->required($input['damage_de'] ?? null, 'Der Schaden fehlt (z. B. W8).', 50),
                    'durability' => $this->countOrNull($input['durability'] ?? null),
                    'traits_de' => $this->textOrNull($input['traits_de'] ?? null),
                ]);
            } elseif ($kind === 'armor') {
                $slot = (string) ($input['armor_slot'] ?? '');
                if (!in_array($slot, ['body', 'head'], true)) {
                    throw new InvalidArgumentException('Ungültiger Rüstungs-Slot.');
                }
                $armor = ['item_id' => $id, 'slot' => $slot, 'armor_value' => $this->count($input['armor_value'] ?? 0)];
                foreach (self::PENALTIES as $penalty) {
                    $armor[$penalty] = empty($input[$penalty]) ? 0 : 1;
                }
                $this->db->prepare(<<<SQL
                    INSERT INTO catalog_item_armor (item_id, slot, armor_value, penalty_stealth, penalty_evasion, penalty_acrobatics, penalty_perception, penalty_ranged)
                    VALUES (:item_id, :slot, :armor_value, :penalty_stealth, :penalty_evasion, :penalty_acrobatics, :penalty_perception, :penalty_ranged)
                    SQL)->execute($armor);
            }
            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }

        return $id;
    }

    /** Refuses while a profession's starting gear still points at the item. */
    public function deleteItem(int $id): void
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM catalog_profession_gear_option_items WHERE item_id = ?');
        $stmt->execute([$id]);
        if ((int) $stmt->fetchColumn() > 0) {
            throw new InvalidArgumentException('Das Item gehört zur Startausrüstung eines Berufs und kann nicht gelöscht werden.');
        }
        $this->db->prepare('DELETE FROM catalog_items WHERE id = ?')->execute([$id]);
    }

    // ---------- bestiary ----------

    public function bestiaryList(): array
    {
        return $this->db->query(
            'SELECT id, name_de, category_de, is_unique, hp FROM catalog_bestiary ORDER BY category_de IS NULL, category_de, name_de'
        )->fetchAll();
    }

    public function creature(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM catalog_bestiary WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $creature = $stmt->fetch();
        if ($creature === false) {
            return null;
        }

        $attacks = $this->db->prepare('SELECT roll_de, title_de, effect_de FROM catalog_bestiary_attacks WHERE bestiary_id = :id ORDER BY id');
        $attacks->execute(['id' => $id]);
        $creature['attacks'] = $attacks->fetchAll();

        return $creature;
    }

    public function categories(): array
    {
        return $this->db->query(
            'SELECT DISTINCT category_de FROM catalog_bestiary WHERE category_de IS NOT NULL ORDER BY category_de'
        )->fetchAll(PDO::FETCH_COLUMN);
    }

    /**
     * Creates (id null) or updates a stat block. Attacks arrive as the
     * parallel lists attack_roll / attack_title / attack_effect; the attack
     * table is rewritten as a whole.
     */
    public function saveCreature(?int $id, array $input): int
    {
        if ($id !== null && $this->creature($id) === null) {
            throw new InvalidArgumentException('Eintrag nicht gefunden.');
        }

        $fields = [
            'name_de' => $this->required($input['name_de'] ?? null, 'Der Name fehlt.', 150),
            'category_de' => $this->textOrNull($input['category_de'] ?? null, 50),
            'is_unique' => empty($input['is_unique']) ? 0 : 1,
            'hp' => $this->count($input['hp'] ?? null),
            'grimmigkeit_de' => $this->required($input['grimmigkeit_de'] ?? null, 'Die Grimmigkeit fehlt.', 20),
            'size_de' => $this->required($input['size_de'] ?? null, 'Die Größe fehlt.', 50),
            'movement' => $this->count($input['movement'] ?? null),
            'armor_de' => $this->textOrNull($input['armor_de'] ?? null, 50) ?? '—',
            'resistances_de' => $this->textOrNull($input['resistances_de'] ?? null),
            'immunities_de' => $this->textOrNull($input['immunities_de'] ?? null),
            'traits_de' => $this->textOrNull($input['traits_de'] ?? null),
            'kit_de' => $this->textOrNull($input['kit_de'] ?? null),
        ];
        if ($fields['hp'] < 1) {
            throw new InvalidArgumentException('Die Trefferpunkte müssen mindestens 1 sein.');
        }

        $attacks = [];
        $rolls = (array) ($input['attack_roll'] ?? []);
        $titles = (array) ($input['attack_title'] ?? []);
        $effects = (array) ($input['attack_effect'] ?? []);
        foreach ($titles as $i => $title) {
            $title = trim((string) $title);
            $roll = trim((string) ($rolls[$i] ?? ''));
            $effect = trim((string) ($effects[$i] ?? ''));
            if ($title === '' && $roll === '' && $effect === '') {
                continue;
            }
            if ($title === '' || $roll === '' || $effect === '') {
                throw new InvalidArgumentException('Jeder Angriff braucht Wurf, Titel und Wirkung.');
            }
            $attacks[] = ['roll_de' => mb_substr($roll, 0, 10), 'title_de' => mb_substr($title, 0, 100), 'effect_de' => $effect];
        }

        $this->db->beginTransaction();
        try {
            if ($id === null) {
                $this->db->prepare(<<<SQL
                    INSERT INTO catalog_bestiary (name_de, category_de, is_unique, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de)
                    VALUES (:name_de, :category_de, :is_unique, :hp, :grimmigkeit_de, :size_de, :movement, :armor_de, :resistances_de, :immunities_de, :traits_de, :kit_de)
                    SQL)->execute($fields);
                $id = (int) $this->db->lastInsertId();
            } else {
                $this->db->prepare(<<<SQL
                    UPDATE catalog_bestiary SET name_de = :name_de, category_de = :category_de, is_unique = :is_unique, hp = :hp,
                        grimmigkeit_de = :grimmigkeit_de, size_de = :size_de, movement = :movement, armor_de = :armor_de,
                        resistances_de = :resistances_de, immunities_de = :immunities_de, traits_de = :traits_de, kit_de = :kit_de
                    WHERE id = :id
                    SQL)->execute($fields + ['id' => $id]);
            }

            $this->db->prepare('DELETE FROM catalog_bestiary_attacks WHERE bestiary_id = ?')->execute([$id]);
            $insert = $this->db->prepare(
                'INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES (:bestiary_id, :roll_de, :title_de, :effect_de)'
            );
            foreach ($attacks as $attack) {
                $insert->execute($attack + ['bestiary_id' => $id]);
            }
            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }

        return $id;
    }

    public function setCreatureImage(int $id, string $path): void
    {
        $this->db->prepare('UPDATE catalog_bestiary SET image_path = :path WHERE id = :id')->execute(['path' => $path, 'id' => $id]);
    }

    /** Refuses while a campaign or an encounter table still uses the stat block. */
    public function deleteCreature(int $id): void
    {
        $uses = [
            'campaign_bestiary' => 'in einer Kampagne',
            'catalog_encounter_table_entries' => 'in einer Begegnungstabelle',
        ];
        foreach ($uses as $table => $where) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM {$table} WHERE bestiary_id = ?");
            $stmt->execute([$id]);
            if ((int) $stmt->fetchColumn() > 0) {
                throw new InvalidArgumentException("Der Eintrag wird noch {$where} verwendet. Entferne ihn dort zuerst.");
            }
        }
        $this->db->prepare('DELETE FROM catalog_bestiary WHERE id = ?')->execute([$id]);
    }

    // ---------- party ----------

    /** The DM's party with everything the overview cards show. */
    public function party(): array
    {
        $members = $this->db->query(<<<SQL
            SELECT c.id, c.name_de, c.portrait_path,
                   k.name_de AS kin_de, p.name_de AS profession_de,
                   c.hp_current, c.hp_max, c.wp_current, c.wp_max,
                   c.coins_gold, c.coins_silver, c.coins_copper
            FROM dm_party dp
            JOIN characters c ON c.id = dp.character_id
            JOIN catalog_kins k ON k.code = c.kin_code
            JOIN catalog_professions p ON p.code = c.profession_code
            ORDER BY dp.added_at, c.name_de
            SQL)->fetchAll();

        $conditions = $this->db->prepare(<<<SQL
            SELECT cd.name_de FROM character_conditions cc
            JOIN catalog_conditions cd ON cd.code = cc.condition_code
            WHERE cc.character_id = :id AND cc.active = 1
            ORDER BY FIELD(cd.attribute_code, 'STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA')
            SQL);
        $armor = $this->db->prepare('SELECT COALESCE(SUM(armor_value), 0) FROM character_armor WHERE character_id = :id');

        foreach ($members as &$member) {
            $conditions->execute(['id' => $member['id']]);
            $member['conditions'] = $conditions->fetchAll(PDO::FETCH_COLUMN);
            $armor->execute(['id' => $member['id']]);
            $member['armor_total'] = (int) $armor->fetchColumn();
        }

        return $members;
    }

    /** Characters not in the party yet, for the picker. */
    public function partyCandidates(): array
    {
        return $this->db->query(<<<SQL
            SELECT c.id, c.name_de, k.name_de AS kin_de, p.name_de AS profession_de
            FROM characters c
            JOIN catalog_kins k ON k.code = c.kin_code
            JOIN catalog_professions p ON p.code = c.profession_code
            WHERE c.id NOT IN (SELECT character_id FROM dm_party)
            ORDER BY c.name_de
            SQL)->fetchAll();
    }

    public function addToParty(int $characterId): void
    {
        $stmt = $this->db->prepare('SELECT 1 FROM characters WHERE id = ?');
        $stmt->execute([$characterId]);
        if ($stmt->fetchColumn() === false) {
            throw new InvalidArgumentException('Charakter nicht gefunden.');
        }
        $this->db->prepare('INSERT IGNORE INTO dm_party (character_id) VALUES (?)')->execute([$characterId]);
    }

    public function removeFromParty(int $characterId): void
    {
        $this->db->prepare('DELETE FROM dm_party WHERE character_id = ?')->execute([$characterId]);
    }

    public function clearParty(): void
    {
        $this->db->exec('DELETE FROM dm_party');
    }

    // ---------- input helpers ----------

    private function required(mixed $value, string $message, int $max): string
    {
        $text = trim((string) $value);
        if ($text === '') {
            throw new InvalidArgumentException($message);
        }

        return mb_substr($text, 0, $max);
    }

    private function textOrNull(mixed $value, ?int $max = null): ?string
    {
        $text = trim((string) ($value ?? ''));
        if ($text === '') {
            return null;
        }

        return $max === null ? $text : mb_substr($text, 0, $max);
    }

    private function count(mixed $value): int
    {
        if (!is_numeric($value) || (int) $value < 0) {
            throw new InvalidArgumentException('Zahlenfelder brauchen eine Zahl ab 0.');
        }

        return (int) $value;
    }

    private function countOrNull(mixed $value): ?int
    {
        return trim((string) ($value ?? '')) === '' ? null : $this->count($value);
    }
}
