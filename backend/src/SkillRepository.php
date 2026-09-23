<?php

declare(strict_types=1);

final class SkillRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS skills (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                governing_attribute TEXT NOT NULL CHECK (governing_attribute IN ('STR', 'CON', 'AGL', 'INT', 'WIL', 'CHA')),
                description TEXT
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM skills ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }

    /** Base Chance table from the governing attribute value (Dragonbane core rules). */
    public static function baseChance(int $attributeValue): int
    {
        return match (true) {
            $attributeValue <= 5 => 3,
            $attributeValue <= 8 => 4,
            $attributeValue <= 12 => 5,
            $attributeValue <= 15 => 6,
            default => 7,
        };
    }
}
