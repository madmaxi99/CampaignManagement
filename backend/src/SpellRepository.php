<?php

declare(strict_types=1);

final class SpellRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS spells (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                school_id INTEGER,
                name TEXT NOT NULL,
                rank INTEGER NOT NULL,
                prerequisite_spell_id INTEGER,
                requirement TEXT,
                casting_time TEXT,
                range TEXT,
                duration TEXT,
                wp_cost INTEGER,
                description TEXT NOT NULL,
                FOREIGN KEY (school_id) REFERENCES magic_schools(id),
                FOREIGN KEY (prerequisite_spell_id) REFERENCES spells(id)
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM spells ORDER BY rank, name')->fetchAll(PDO::FETCH_ASSOC);
    }
}
