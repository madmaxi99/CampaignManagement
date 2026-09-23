<?php

declare(strict_types=1);

final class PlayerCharacterRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS player_characters (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                kin_id INTEGER NOT NULL,
                profession_id INTEGER NOT NULL,
                age TEXT NOT NULL CHECK (age IN ('young', 'adult', 'old')),
                magic_tradition TEXT CHECK (magic_tradition IN ('elementalist', 'mentalist', 'animist')),
                appearance TEXT,
                attribute_str INTEGER NOT NULL,
                attribute_con INTEGER NOT NULL,
                attribute_agl INTEGER NOT NULL,
                attribute_int INTEGER NOT NULL,
                attribute_wil INTEGER NOT NULL,
                attribute_cha INTEGER NOT NULL,
                movement INTEGER NOT NULL,
                damage_bonus_str TEXT,
                damage_bonus_agl TEXT,
                hp_max INTEGER NOT NULL,
                hp_current INTEGER NOT NULL,
                wp_max INTEGER NOT NULL,
                wp_current INTEGER NOT NULL,
                condition_exhausted INTEGER NOT NULL DEFAULT 0,
                condition_sickly INTEGER NOT NULL DEFAULT 0,
                condition_dazed INTEGER NOT NULL DEFAULT 0,
                condition_angry INTEGER NOT NULL DEFAULT 0,
                condition_scared INTEGER NOT NULL DEFAULT 0,
                condition_disheartened INTEGER NOT NULL DEFAULT 0,
                weakness TEXT,
                memento TEXT,
                languages TEXT,
                coins_gold INTEGER NOT NULL DEFAULT 0,
                coins_silver INTEGER NOT NULL DEFAULT 0,
                coins_copper INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                FOREIGN KEY (kin_id) REFERENCES kins(id),
                FOREIGN KEY (profession_id) REFERENCES professions(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS character_skills (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                character_id INTEGER NOT NULL,
                skill_id INTEGER NOT NULL,
                value INTEGER NOT NULL,
                has_advancement_mark INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                UNIQUE (character_id, skill_id),
                FOREIGN KEY (character_id) REFERENCES player_characters(id),
                FOREIGN KEY (skill_id) REFERENCES skills(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS character_heroic_abilities (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                character_id INTEGER NOT NULL,
                heroic_ability_id INTEGER NOT NULL,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                UNIQUE (character_id, heroic_ability_id),
                FOREIGN KEY (character_id) REFERENCES player_characters(id),
                FOREIGN KEY (heroic_ability_id) REFERENCES heroic_abilities(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS character_spells (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                character_id INTEGER NOT NULL,
                spell_id INTEGER NOT NULL,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                UNIQUE (character_id, spell_id),
                FOREIGN KEY (character_id) REFERENCES player_characters(id),
                FOREIGN KEY (spell_id) REFERENCES spells(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS character_inventory (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                character_id INTEGER NOT NULL,
                item_id INTEGER NOT NULL,
                quantity INTEGER NOT NULL DEFAULT 1,
                equipped INTEGER NOT NULL DEFAULT 0,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                FOREIGN KEY (character_id) REFERENCES player_characters(id),
                FOREIGN KEY (item_id) REFERENCES items(id)
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query(<<<SQL
            SELECT pc.*, k.name AS kin_name, p.name AS profession_name
            FROM player_characters pc
            JOIN kins k ON k.id = pc.kin_id
            JOIN professions p ON p.id = pc.profession_id
            ORDER BY pc.name
            SQL)->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT pc.*, k.name AS kin_name, p.name AS profession_name
            FROM player_characters pc
            JOIN kins k ON k.id = pc.kin_id
            JOIN professions p ON p.id = pc.profession_id
            WHERE pc.id = :id
            SQL);
        $stmt->execute(['id' => $id]);
        $character = $stmt->fetch(PDO::FETCH_ASSOC);

        return $character === false ? null : $character;
    }

    public function skills(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT cs.*, s.name AS skill_name, s.governing_attribute
            FROM character_skills cs
            JOIN skills s ON s.id = cs.skill_id
            WHERE cs.character_id = :character_id
            ORDER BY s.name
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function heroicAbilities(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT ha.*
            FROM character_heroic_abilities cha
            JOIN heroic_abilities ha ON ha.id = cha.heroic_ability_id
            WHERE cha.character_id = :character_id
            ORDER BY ha.name
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function spells(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT sp.*
            FROM character_spells cs
            JOIN spells sp ON sp.id = cs.spell_id
            WHERE cs.character_id = :character_id
            ORDER BY sp.rank, sp.name
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function inventory(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT ci.*, i.name AS item_name, i.category, i.weight
            FROM character_inventory ci
            JOIN items i ON i.id = ci.item_id
            WHERE ci.character_id = :character_id
            ORDER BY i.name
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /** Movement modifier from the AGL attribute (Dragonbane core rules). */
    public static function movementModifier(int $agl): int
    {
        return match (true) {
            $agl <= 6 => -4,
            $agl <= 9 => -2,
            $agl <= 12 => 0,
            $agl <= 15 => 2,
            default => 4,
        };
    }

    /** Damage bonus die from a STR or AGL attribute value (Dragonbane core rules). */
    public static function damageBonus(int $value): string
    {
        return match (true) {
            $value <= 12 => 'none',
            $value <= 16 => 'D4',
            default => 'D6',
        };
    }

    /**
     * Creates a character plus its trained skills, starting Heroic Ability or spells
     * (Mage), and — for Mage — the Grimoire inventory item, in one transaction.
     *
     * Expected shape of $data:
     *   name, kin_id, profession_id, age, kin_base_movement, appearance, weakness, memento, languages,
     *   attribute_str/con/agl/int/wil/cha (int),
     *   magic_tradition (nullable string),
     *   trained_skills: list of ['id' => int, 'governing_attribute' => string],
     *   heroic_ability_id (nullable int),
     *   spell_ids (list of int, only for Mage),
     *   grimoire_item_id (nullable int, required if spell_ids is non-empty)
     */
    public function create(array $data): int
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');

        $attributes = [
            'STR' => (int) $data['attribute_str'],
            'CON' => (int) $data['attribute_con'],
            'AGL' => (int) $data['attribute_agl'],
            'INT' => (int) $data['attribute_int'],
            'WIL' => (int) $data['attribute_wil'],
            'CHA' => (int) $data['attribute_cha'],
        ];

        $movement = (int) $data['kin_base_movement'] + self::movementModifier($attributes['AGL']);
        $damageBonusStr = self::damageBonus($attributes['STR']);
        $damageBonusAgl = self::damageBonus($attributes['AGL']);

        $this->db->beginTransaction();

        try {
            $stmt = $this->db->prepare(<<<SQL
                INSERT INTO player_characters (
                    name, kin_id, profession_id, age, magic_tradition, appearance,
                    attribute_str, attribute_con, attribute_agl, attribute_int, attribute_wil, attribute_cha,
                    movement, damage_bonus_str, damage_bonus_agl,
                    hp_max, hp_current, wp_max, wp_current,
                    weakness, memento, languages,
                    created_at, updated_at
                ) VALUES (
                    :name, :kin_id, :profession_id, :age, :magic_tradition, :appearance,
                    :str, :con, :agl, :int, :wil, :cha,
                    :movement, :damage_bonus_str, :damage_bonus_agl,
                    :hp, :hp, :wp, :wp,
                    :weakness, :memento, :languages,
                    :now, :now
                )
                SQL);
            $stmt->execute([
                'name' => $data['name'],
                'kin_id' => $data['kin_id'],
                'profession_id' => $data['profession_id'],
                'age' => $data['age'],
                'magic_tradition' => $data['magic_tradition'] ?? null,
                'appearance' => $data['appearance'] ?? null,
                'str' => $attributes['STR'],
                'con' => $attributes['CON'],
                'agl' => $attributes['AGL'],
                'int' => $attributes['INT'],
                'wil' => $attributes['WIL'],
                'cha' => $attributes['CHA'],
                'movement' => $movement,
                'damage_bonus_str' => $damageBonusStr,
                'damage_bonus_agl' => $damageBonusAgl,
                'hp' => $attributes['CON'],
                'wp' => $attributes['WIL'],
                'weakness' => $data['weakness'] ?? null,
                'memento' => $data['memento'] ?? null,
                'languages' => $data['languages'] ?? null,
                'now' => $now,
            ]);

            $characterId = (int) $this->db->lastInsertId();

            $skillStmt = $this->db->prepare(<<<SQL
                INSERT INTO character_skills (character_id, skill_id, value, created_at, updated_at)
                VALUES (:character_id, :skill_id, :value, :now, :now)
                SQL);
            foreach ($data['trained_skills'] as $skill) {
                $value = SkillRepository::baseChance($attributes[$skill['governing_attribute']]) * 2;
                $skillStmt->execute([
                    'character_id' => $characterId,
                    'skill_id' => $skill['id'],
                    'value' => $value,
                    'now' => $now,
                ]);
            }

            if (!empty($data['heroic_ability_id'])) {
                $stmt = $this->db->prepare(<<<SQL
                    INSERT INTO character_heroic_abilities (character_id, heroic_ability_id, created_at, updated_at)
                    VALUES (:character_id, :heroic_ability_id, :now, :now)
                    SQL);
                $stmt->execute([
                    'character_id' => $characterId,
                    'heroic_ability_id' => $data['heroic_ability_id'],
                    'now' => $now,
                ]);
            }

            if (!empty($data['spell_ids'])) {
                $spellStmt = $this->db->prepare(<<<SQL
                    INSERT INTO character_spells (character_id, spell_id, created_at, updated_at)
                    VALUES (:character_id, :spell_id, :now, :now)
                    SQL);
                foreach ($data['spell_ids'] as $spellId) {
                    $spellStmt->execute(['character_id' => $characterId, 'spell_id' => $spellId, 'now' => $now]);
                }

                $stmt = $this->db->prepare(<<<SQL
                    INSERT INTO character_inventory (character_id, item_id, quantity, equipped, created_at, updated_at)
                    VALUES (:character_id, :item_id, 1, 1, :now, :now)
                    SQL);
                $stmt->execute([
                    'character_id' => $characterId,
                    'item_id' => $data['grimoire_item_id'],
                    'now' => $now,
                ]);
            }

            $this->db->commit();

            return $characterId;
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }
    }

    public function updateVitals(int $id, array $fields): void
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');
        $stmt = $this->db->prepare(<<<SQL
            UPDATE player_characters
            SET hp_current = :hp_current, wp_current = :wp_current,
                condition_exhausted = :exhausted, condition_sickly = :sickly,
                condition_dazed = :dazed, condition_angry = :angry,
                condition_scared = :scared, condition_disheartened = :disheartened,
                updated_at = :now
            WHERE id = :id
            SQL);
        $stmt->execute([
            'hp_current' => $fields['hp_current'],
            'wp_current' => $fields['wp_current'],
            'exhausted' => !empty($fields['condition_exhausted']) ? 1 : 0,
            'sickly' => !empty($fields['condition_sickly']) ? 1 : 0,
            'dazed' => !empty($fields['condition_dazed']) ? 1 : 0,
            'angry' => !empty($fields['condition_angry']) ? 1 : 0,
            'scared' => !empty($fields['condition_scared']) ? 1 : 0,
            'disheartened' => !empty($fields['condition_disheartened']) ? 1 : 0,
            'now' => $now,
            'id' => $id,
        ]);
    }

    public function toggleAdvancementMark(int $characterId, int $skillId): void
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');
        $stmt = $this->db->prepare(<<<SQL
            UPDATE character_skills
            SET has_advancement_mark = CASE WHEN has_advancement_mark = 1 THEN 0 ELSE 1 END, updated_at = :now
            WHERE character_id = :character_id AND skill_id = :skill_id
            SQL);
        $stmt->execute(['character_id' => $characterId, 'skill_id' => $skillId, 'now' => $now]);
    }

    public function addInventoryItem(int $characterId, int $itemId, int $quantity): void
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');
        $stmt = $this->db->prepare(<<<SQL
            INSERT INTO character_inventory (character_id, item_id, quantity, equipped, created_at, updated_at)
            VALUES (:character_id, :item_id, :quantity, 0, :now, :now)
            SQL);
        $stmt->execute(['character_id' => $characterId, 'item_id' => $itemId, 'quantity' => $quantity, 'now' => $now]);
    }

    public function removeInventoryItem(int $inventoryId): void
    {
        $stmt = $this->db->prepare('DELETE FROM character_inventory WHERE id = :id');
        $stmt->execute(['id' => $inventoryId]);
    }

    public function toggleEquipped(int $inventoryId): void
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');
        $stmt = $this->db->prepare(<<<SQL
            UPDATE character_inventory
            SET equipped = CASE WHEN equipped = 1 THEN 0 ELSE 1 END, updated_at = :now
            WHERE id = :id
            SQL);
        $stmt->execute(['id' => $inventoryId, 'now' => $now]);
    }
}
