<?php

declare(strict_types=1);

final class CharacterRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function listAll(): array
    {
        $stmt = $this->db->query(<<<SQL
            SELECT c.id, c.name_de, c.portrait_path,
                   k.name_de AS kin_de, ag.name_de AS age_de, p.name_de AS profession_de,
                   c.hp_current, c.hp_max, c.wp_current, c.wp_max, c.is_default
            FROM characters c
            JOIN catalog_kins k ON k.code = c.kin_code
            JOIN catalog_age ag ON ag.id = c.age_id
            JOIN catalog_professions p ON p.code = c.profession_code
            ORDER BY c.name_de
            SQL);

        return $stmt->fetchAll();
    }

    /**
     * Joins in kin/age/profession/flaw display text under the same field
     * names (kin_de/age_de/profession_de/flaw_de) the freetext columns used
     * to have, so templates built against those names don't need to change.
     */
    public function findById(int $id): ?array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT c.*,
                   k.name_de AS kin_de, k.movement_base,
                   ag.name_de AS age_de,
                   p.name_de AS profession_de,
                   CONCAT(fl.name_de, '. ', fl.description_de) AS flaw_de
            FROM characters c
            JOIN catalog_kins k ON k.code = c.kin_code
            JOIN catalog_age ag ON ag.id = c.age_id
            JOIN catalog_professions p ON p.code = c.profession_code
            JOIN catalog_flaws fl ON fl.id = c.flaw_id
            WHERE c.id = :id
            SQL);
        $stmt->execute(['id' => $id]);
        $character = $stmt->fetch();

        return $character === false ? null : $character;
    }

    /**
     * Movement/carrying capacity/damage bonus aren't stored -- they're always
     * derivable from the kin (movement_base, joined in by findById above) and
     * the STA/GEW attribute values. Returns them under the same field names
     * (movement/carrying_capacity/damage_bonus_sta_de/damage_bonus_gew_de)
     * the stored columns used to have.
     *
     * @param array<int,array{code:string,value:int}> $attributes
     */
    public function derivedStats(array $character, array $attributes): array
    {
        $attributeValues = [];
        foreach ($attributes as $attribute) {
            $attributeValues[$attribute['code']] = (int) $attribute['value'];
        }
        $gew = $attributeValues['GEW'] ?? 0;
        $sta = $attributeValues['STA'] ?? 0;

        $movementModifier = match (true) {
            $gew <= 6 => -4,
            $gew <= 9 => -2,
            $gew <= 12 => 0,
            $gew <= 15 => 2,
            default => 4,
        };

        return [
            'movement' => (int) $character['movement_base'] + $movementModifier,
            'carrying_capacity' => (int) ceil($sta / 2),
            'damage_bonus_sta_de' => $this->damageBonus($sta),
            'damage_bonus_gew_de' => $this->damageBonus($gew),
        ];
    }

    private function damageBonus(int $value): string
    {
        return match (true) {
            $value <= 12 => '—',
            $value <= 16 => 'W4',
            default => 'W6',
        };
    }

    /**
     * Sets the portrait once. Returns false without changing anything if the
     * character already has one -- portraits are permanent, see the
     * schema.sql comment on characters.portrait_path.
     */
    public function setPortraitPath(int $characterId, string $path): bool
    {
        $stmt = $this->db->prepare(
            'UPDATE characters SET portrait_path = :path WHERE id = :id AND portrait_path IS NULL'
        );
        $stmt->execute(['path' => $path, 'id' => $characterId]);

        return $stmt->rowCount() === 1;
    }

    public function attributes(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT a.code, a.name_de, ca.value
            FROM character_attributes ca
            JOIN catalog_attributes a ON a.code = ca.attribute_code
            WHERE ca.character_id = :character_id
            ORDER BY FIELD(a.code, 'STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA')
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function conditions(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT c.code, c.name_de, c.attribute_code, cc.active
            FROM character_conditions cc
            JOIN catalog_conditions c ON c.code = cc.condition_code
            WHERE cc.character_id = :character_id
            ORDER BY FIELD(c.attribute_code, 'STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA')
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function skillsByCategory(int $characterId, string $category): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT sk.id, sk.name_de, sk.attribute_code, sk.category, cs.value, cs.marked_for_advancement
            FROM character_skills cs
            JOIN catalog_skills sk ON sk.id = cs.skill_id
            WHERE cs.character_id = :character_id AND sk.category = :category
            ORDER BY sk.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId, 'category' => $category]);

        return $stmt->fetchAll();
    }

    public function markedSkills(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT sk.id, sk.name_de, sk.attribute_code, cs.value
            FROM character_skills cs
            JOIN catalog_skills sk ON sk.id = cs.skill_id
            WHERE cs.character_id = :character_id AND cs.marked_for_advancement = 1
            ORDER BY sk.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function setSkillMark(int $characterId, int $skillId, bool $marked): void
    {
        $stmt = $this->db->prepare(
            'UPDATE character_skills SET marked_for_advancement = :marked WHERE character_id = :character_id AND skill_id = :skill_id'
        );
        $stmt->execute(['marked' => $marked ? 1 : 0, 'character_id' => $characterId, 'skill_id' => $skillId]);
    }

    public function advanceSkill(int $characterId, int $skillId, bool $apply): int
    {
        if ($apply) {
            $update = $this->db->prepare(<<<SQL
                UPDATE character_skills
                SET value = value + 1, marked_for_advancement = 0
                WHERE character_id = :character_id AND skill_id = :skill_id
                SQL);
        } else {
            $update = $this->db->prepare(
                'UPDATE character_skills SET marked_for_advancement = 0 WHERE character_id = :character_id AND skill_id = :skill_id'
            );
        }
        $update->execute(['character_id' => $characterId, 'skill_id' => $skillId]);

        $stmt = $this->db->prepare(
            'SELECT value FROM character_skills WHERE character_id = :character_id AND skill_id = :skill_id'
        );
        $stmt->execute(['character_id' => $characterId, 'skill_id' => $skillId]);

        return (int) $stmt->fetch()['value'];
    }

    public function talents(int $characterId): array
    {
        $stmt = $this->db->prepare(
            'SELECT name_de, wp_note_de, description_de FROM character_talents WHERE character_id = :character_id ORDER BY id'
        );
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function spells(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT s.id, s.name_de, s.type, s.components_de,
                   ct.name_de AS casting_time_de, s.range_de, sd.name_de AS duration_de,
                   s.wp_note_de, s.effect_de
            FROM character_spells cs
            JOIN catalog_spells s ON s.id = cs.spell_id
            LEFT JOIN catalog_casting_times ct ON ct.code = s.casting_time_code
            LEFT JOIN catalog_spell_durations sd ON sd.code = s.duration_code
            WHERE cs.character_id = :character_id
            ORDER BY s.type DESC, s.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    /**
     * Secondary skills the character is actually trained in (value > 0). A
     * character has a character_skills row for every catalog skill including
     * untrained magic schools (value 0), so "trained" must be filtered
     * explicitly rather than just checking row existence.
     *
     * @return int[]
     */
    public function trainedSchoolSkillIds(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT sk.id
            FROM character_skills cs
            JOIN catalog_skills sk ON sk.id = cs.skill_id
            WHERE cs.character_id = :character_id AND sk.category = 'secondary' AND cs.value > 0
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return array_map('intval', array_column($stmt->fetchAll(), 'id'));
    }

    /**
     * @param int[] $schoolSkillIds
     */
    public function availableSpells(int $characterId, array $schoolSkillIds): array
    {
        if ($schoolSkillIds === []) {
            return [];
        }

        $placeholders = implode(',', array_fill(0, count($schoolSkillIds), '?'));
        $stmt = $this->db->prepare(<<<SQL
            SELECT s.id, s.name_de, s.type, s.components_de,
                   ct.name_de AS casting_time_de, s.range_de, sd.name_de AS duration_de,
                   s.wp_note_de, s.effect_de
            FROM catalog_spells s
            LEFT JOIN catalog_casting_times ct ON ct.code = s.casting_time_code
            LEFT JOIN catalog_spell_durations sd ON sd.code = s.duration_code
            WHERE s.school_id IN (
                    SELECT id FROM catalog_schools WHERE skill_id IN ($placeholders) OR skill_id IS NULL
                )
              AND (s.rank = 1 OR s.rank IS NULL)
              AND s.id NOT IN (SELECT spell_id FROM character_spells WHERE character_id = ?)
            ORDER BY s.name_de
            SQL);
        $stmt->execute([...$schoolSkillIds, $characterId]);

        return $stmt->fetchAll();
    }

    public function learnSpell(int $characterId, int $spellId): void
    {
        $stmt = $this->db->prepare('INSERT IGNORE INTO character_spells (character_id, spell_id) VALUES (:character_id, :spell_id)');
        $stmt->execute(['character_id' => $characterId, 'spell_id' => $spellId]);
    }

    /**
     * Heroic Abilities a character could still pick on the levelup page:
     * general ones (no kin/profession link at all) plus profession-linked
     * ones marked granted_at_creation = 0 (per schema.sql comment, those are
     * explicitly meant as a later pick, not a starting talent). Kin-linked
     * ones are always automatic-only and never appear here. Non-repeatable
     * abilities the character already has are filtered out.
     */
    public function learnableHeroicAbilities(int $characterId, string $professionCode): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT cha.id, cha.name_de, cha.requirement_de, cha.wp_note_de, cha.description_de, cha.repeatable,
                   (SELECT COUNT(*) FROM character_talents ct WHERE ct.character_id = :character_id AND ct.name_de = cha.name_de) AS times_owned
            FROM catalog_heroic_abilities cha
            WHERE cha.id NOT IN (SELECT heroic_ability_id FROM catalog_kin_heroic_abilities)
              AND (
                    cha.id NOT IN (SELECT heroic_ability_id FROM catalog_profession_heroic_abilities)
                    OR cha.id IN (
                        SELECT heroic_ability_id FROM catalog_profession_heroic_abilities
                        WHERE profession_code = :profession_code AND granted_at_creation = 0
                    )
                  )
            ORDER BY cha.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId, 'profession_code' => $professionCode]);

        return array_values(array_filter(
            $stmt->fetchAll(),
            static fn (array $row) => (int) $row['times_owned'] === 0 || (bool) $row['repeatable']
        ));
    }

    public function heroicAbilityById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT name_de, wp_note_de, description_de FROM catalog_heroic_abilities WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();

        return $row === false ? null : $row;
    }

    public function learnHeroicAbility(int $characterId, array $ability): void
    {
        $stmt = $this->db->prepare(
            'INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES (:character_id, :name_de, :wp_note_de, :description_de)'
        );
        $stmt->execute([
            'character_id' => $characterId,
            'name_de' => $ability['name_de'],
            'wp_note_de' => $ability['wp_note_de'],
            'description_de' => $ability['description_de'],
        ]);
    }

    /**
     * Trains a still-untrained secondary (magic school) skill straight to
     * its trained value, mirroring the character-creation formula -- used
     * when the "Magisches Talent" Heroic Ability is picked (see its own
     * description text in seed_heroic_abilities_missing.sql).
     */
    public function trainSkill(int $characterId, int $skillId): void
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT ca.value AS attribute_value
            FROM catalog_skills sk
            JOIN character_attributes ca ON ca.character_id = :character_id AND ca.attribute_code = sk.attribute_code
            WHERE sk.id = :skill_id
            SQL);
        $stmt->execute(['character_id' => $characterId, 'skill_id' => $skillId]);
        $attributeValue = (int) $stmt->fetch()['attribute_value'];

        $update = $this->db->prepare(
            'UPDATE character_skills SET value = :value WHERE character_id = :character_id AND skill_id = :skill_id AND value = 0'
        );
        $update->execute(['value' => $this->baseChance($attributeValue) * 2, 'character_id' => $characterId, 'skill_id' => $skillId]);
    }

    private function baseChance(int $value): int
    {
        return match (true) {
            $value <= 5 => 3,
            $value <= 8 => 4,
            $value <= 12 => 5,
            $value <= 15 => 6,
            default => 7,
        };
    }

    public function weapons(int $characterId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id AS row_id, name_de, grip_de, range_de, damage_de, traits_de
             FROM character_weapons WHERE character_id = :character_id ORDER BY position'
        );
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function addWeapon(int $characterId): int
    {
        $position = $this->nextPosition('character_weapons', $characterId);
        $stmt = $this->db->prepare(
            'INSERT INTO character_weapons (character_id, position, name_de) VALUES (:character_id, :position, :name_de)'
        );
        $stmt->execute(['character_id' => $characterId, 'position' => $position, 'name_de' => 'Neue Waffe']);

        return (int) $this->db->lastInsertId();
    }

    public function updateWeapon(int $characterId, int $rowId, array $fields): void
    {
        $this->updateFreeTextRow('character_weapons', $characterId, $rowId, $fields, ['name_de', 'grip_de', 'range_de', 'damage_de', 'traits_de']);
    }

    public function removeWeapon(int $characterId, int $rowId): void
    {
        $this->removeFromCharacterItemTable('character_weapons', $characterId, $rowId);
    }

    public function armor(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT slot, name_de, armor_value, penalty_stealth, penalty_evasion, penalty_acrobatics, penalty_perception, penalty_ranged
            FROM character_armor
            WHERE character_id = :character_id ORDER BY FIELD(slot, 'head', 'body')
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function updateArmorSlot(int $characterId, string $slot, array $fields): void
    {
        if (!in_array($slot, ['head', 'body'], true)) {
            throw new InvalidArgumentException('Ungültiger Rüstungs-Slot.');
        }

        $allowed = ['name_de', 'armor_value', 'penalty_stealth', 'penalty_evasion', 'penalty_acrobatics', 'penalty_perception', 'penalty_ranged'];
        $set = array_intersect_key($fields, array_flip($allowed));
        if ($set === []) {
            return;
        }
        $set = array_map(static fn ($value) => is_bool($value) ? (int) $value : $value, $set);

        $assignments = implode(', ', array_map(static fn (string $field) => "{$field} = :{$field}", array_keys($set)));
        $stmt = $this->db->prepare("UPDATE character_armor SET {$assignments} WHERE character_id = :character_id AND slot = :slot");
        $stmt->execute($set + ['character_id' => $characterId, 'slot' => $slot]);
    }

    public function inventory(int $characterId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id AS row_id, name_de, description_de, quantity
             FROM character_inventory WHERE character_id = :character_id ORDER BY position'
        );
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function addInventoryItem(int $characterId): int
    {
        $position = $this->nextPosition('character_inventory', $characterId);
        $stmt = $this->db->prepare(
            'INSERT INTO character_inventory (character_id, position, name_de) VALUES (:character_id, :position, :name_de)'
        );
        $stmt->execute(['character_id' => $characterId, 'position' => $position, 'name_de' => 'Neuer Gegenstand']);

        return (int) $this->db->lastInsertId();
    }

    public function updateInventoryItem(int $characterId, int $rowId, array $fields): void
    {
        $this->updateFreeTextRow('character_inventory', $characterId, $rowId, $fields, ['name_de', 'description_de', 'quantity']);
    }

    public function removeInventoryItem(int $characterId, int $rowId): void
    {
        $this->removeFromCharacterItemTable('character_inventory', $characterId, $rowId);
    }

    public function delete(int $characterId): void
    {
        $stmt = $this->db->prepare('DELETE FROM characters WHERE id = :id AND is_default = 0');
        $stmt->execute(['id' => $characterId]);
    }

    /** The player's private "Gedächtnis" text. Empty text clears it. */
    public function setMemory(int $characterId, string $text): void
    {
        $text = trim($text);
        $stmt = $this->db->prepare('UPDATE characters SET memory_de = :text WHERE id = :character_id');
        $stmt->execute([
            'text' => $text === '' ? null : mb_substr($text, 0, 20000),
            'character_id' => $characterId,
        ]);
    }

    public function setCurrency(int $characterId, int $gold, int $silver, int $copper): void
    {
        $stmt = $this->db->prepare(
            'UPDATE characters SET coins_gold = :gold, coins_silver = :silver, coins_copper = :copper WHERE id = :character_id'
        );
        $stmt->execute([
            'gold' => max(0, $gold),
            'silver' => max(0, $silver),
            'copper' => max(0, $copper),
            'character_id' => $characterId,
        ]);
    }

    public function setHp(int $characterId, int $value): int
    {
        return $this->setVital($characterId, 'hp', $value);
    }

    public function setWp(int $characterId, int $value): int
    {
        return $this->setVital($characterId, 'wp', $value);
    }

    private function setVital(int $characterId, string $prefix, int $value): int
    {
        $currentColumn = $prefix . '_current';
        $maxColumn = $prefix . '_max';

        $stmt = $this->db->prepare("SELECT {$maxColumn} AS max_value FROM characters WHERE id = :character_id");
        $stmt->execute(['character_id' => $characterId]);
        $row = $stmt->fetch();
        $max = (int) $row['max_value'];

        $clamped = max(0, min($max, $value));

        $update = $this->db->prepare("UPDATE characters SET {$currentColumn} = :value WHERE id = :character_id");
        $update->execute(['value' => $clamped, 'character_id' => $characterId]);

        return $clamped;
    }

    public function toggleCondition(int $characterId, string $code): bool
    {
        $stmt = $this->db->prepare(
            'SELECT active FROM character_conditions WHERE character_id = :character_id AND condition_code = :code'
        );
        $stmt->execute(['character_id' => $characterId, 'code' => $code]);
        $row = $stmt->fetch();

        $newActive = !((bool) $row['active']);

        $update = $this->db->prepare(
            'UPDATE character_conditions SET active = :active WHERE character_id = :character_id AND condition_code = :code'
        );
        $update->execute(['active' => $newActive ? 1 : 0, 'character_id' => $characterId, 'code' => $code]);

        return $newActive;
    }

    private function nextPosition(string $table, int $characterId): int
    {
        $stmt = $this->db->prepare("SELECT COALESCE(MAX(position), 0) + 1 FROM {$table} WHERE character_id = :character_id");
        $stmt->execute(['character_id' => $characterId]);

        return (int) $stmt->fetchColumn();
    }

    /**
     * Updates only the keys of $fields that are also in $allowed (a whitelist
     * of real column names) -- prevents SQL injection via arbitrary field
     * names from request bodies.
     */
    private function updateFreeTextRow(string $table, int $characterId, int $rowId, array $fields, array $allowed): void
    {
        $set = array_intersect_key($fields, array_flip($allowed));
        if ($set === []) {
            return;
        }

        $assignments = implode(', ', array_map(static fn (string $field) => "{$field} = :{$field}", array_keys($set)));
        $stmt = $this->db->prepare("UPDATE {$table} SET {$assignments} WHERE id = :id AND character_id = :character_id");
        $stmt->execute($set + ['id' => $rowId, 'character_id' => $characterId]);
    }

    private function removeFromCharacterItemTable(string $table, int $characterId, int $rowId): void
    {
        $stmt = $this->db->prepare("DELETE FROM {$table} WHERE id = :id AND character_id = :character_id");
        $stmt->execute(['id' => $rowId, 'character_id' => $characterId]);
    }
}
