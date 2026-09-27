<?php

declare(strict_types=1);

final class CharacterRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function listAll(): array
    {
        $stmt = $this->db->query(
            'SELECT slug, name_de, kin_de, age_de, profession_de, hp_current, hp_max, wp_current, wp_max, is_default FROM characters ORDER BY name_de'
        );

        return $stmt->fetchAll();
    }

    public function findBySlug(string $slug): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM characters WHERE slug = :slug');
        $stmt->execute(['slug' => $slug]);
        $character = $stmt->fetch();

        return $character === false ? null : $character;
    }

    public function attributes(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT a.code, a.name_de, ca.value
            FROM character_attributes ca
            JOIN attributes a ON a.code = ca.attribute_code
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
            JOIN conditions c ON c.code = cc.condition_code
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
            JOIN skills sk ON sk.id = cs.skill_id
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
            JOIN skills sk ON sk.id = cs.skill_id
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
            SELECT s.id, s.name_de, s.type, s.components_de, s.casting_time_de, s.range_de,
                   s.duration_de, s.wp_note_de, s.effect_de
            FROM character_spells cs
            JOIN spells s ON s.id = cs.spell_id
            WHERE cs.character_id = :character_id
            ORDER BY s.type DESC, s.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function availableSpells(int $characterId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT id, name_de
            FROM spells
            WHERE id NOT IN (SELECT spell_id FROM character_spells WHERE character_id = :character_id)
            ORDER BY name_de
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function learnSpell(int $characterId, int $spellId): void
    {
        $stmt = $this->db->prepare('INSERT IGNORE INTO character_spells (character_id, spell_id) VALUES (:character_id, :spell_id)');
        $stmt->execute(['character_id' => $characterId, 'spell_id' => $spellId]);
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
        $stmt = $this->db->prepare(
            "SELECT slot, name_de, armor_value, penalty_de FROM character_armor
             WHERE character_id = :character_id ORDER BY FIELD(slot, 'head', 'body')"
        );
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function updateArmorSlot(int $characterId, string $slot, array $fields): void
    {
        if (!in_array($slot, ['head', 'body'], true)) {
            throw new InvalidArgumentException('Ungültiger Rüstungs-Slot.');
        }

        $allowed = ['name_de', 'armor_value', 'penalty_de'];
        $set = array_intersect_key($fields, array_flip($allowed));
        if ($set === []) {
            return;
        }

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
