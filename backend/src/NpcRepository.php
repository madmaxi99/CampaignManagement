<?php

declare(strict_types=1);

final class NpcRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS npcs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT,
                kin TEXT,
                ferocity INTEGER,
                movement INTEGER,
                armor INTEGER,
                hp INTEGER NOT NULL,
                wp INTEGER NOT NULL
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS npc_skills (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                npc_id INTEGER NOT NULL,
                skill_id INTEGER NOT NULL,
                value INTEGER NOT NULL,
                UNIQUE (npc_id, skill_id),
                FOREIGN KEY (npc_id) REFERENCES npcs(id),
                FOREIGN KEY (skill_id) REFERENCES skills(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS npc_inventory (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                npc_id INTEGER NOT NULL,
                item_id INTEGER NOT NULL,
                quantity INTEGER NOT NULL DEFAULT 1,
                FOREIGN KEY (npc_id) REFERENCES npcs(id),
                FOREIGN KEY (item_id) REFERENCES items(id)
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM npcs ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }
}
