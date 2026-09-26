<?php

declare(strict_types=1);

final class CharacterRepository
{
    public function __construct(private PDO $db)
    {
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
            SELECT sk.name_de, sk.attribute_code, cs.value
            FROM character_skills cs
            JOIN skills sk ON sk.id = cs.skill_id
            WHERE cs.character_id = :character_id AND sk.category = :category
            ORDER BY sk.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId, 'category' => $category]);

        return $stmt->fetchAll();
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
            SELECT s.name_de, s.type, s.components_de, s.casting_time_de, s.range_de,
                   s.duration_de, s.wp_note_de, s.effect_de
            FROM character_spells cs
            JOIN spells s ON s.id = cs.spell_id
            WHERE cs.character_id = :character_id
            ORDER BY s.type DESC, s.name_de
            SQL);
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function weapons(int $characterId): array
    {
        $stmt = $this->db->prepare(
            'SELECT name_de, grip_de, range_de, damage_de, durability, traits_de FROM character_weapons WHERE character_id = :character_id ORDER BY id'
        );
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
    }

    public function armor(int $characterId): array
    {
        $stmt = $this->db->prepare(
            'SELECT slot, name_de, armor_value, penalty_skills_de FROM character_armor WHERE character_id = :character_id'
        );
        $stmt->execute(['character_id' => $characterId]);

        $bySlot = ['body' => null, 'head' => null];
        foreach ($stmt->fetchAll() as $row) {
            $bySlot[$row['slot']] = $row;
        }

        return $bySlot;
    }

    public function inventory(int $characterId): array
    {
        $stmt = $this->db->prepare(
            'SELECT item_name_de, quantity FROM character_inventory WHERE character_id = :character_id ORDER BY position'
        );
        $stmt->execute(['character_id' => $characterId]);

        return $stmt->fetchAll();
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
}
