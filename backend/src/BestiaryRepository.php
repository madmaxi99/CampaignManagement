<?php

declare(strict_types=1);

final class BestiaryRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS bestiary (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT,
                size TEXT,
                ferocity INTEGER NOT NULL,
                movement INTEGER NOT NULL,
                armor INTEGER,
                hp INTEGER NOT NULL
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS bestiary_attacks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                bestiary_id INTEGER NOT NULL,
                roll INTEGER NOT NULL,
                name TEXT NOT NULL,
                description TEXT NOT NULL,
                UNIQUE (bestiary_id, roll),
                FOREIGN KEY (bestiary_id) REFERENCES bestiary(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS bestiary_passives (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                bestiary_id INTEGER NOT NULL,
                name TEXT NOT NULL,
                description TEXT NOT NULL,
                FOREIGN KEY (bestiary_id) REFERENCES bestiary(id)
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM bestiary ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function attacksByBestiary(): array
    {
        $rows = $this->db->query('SELECT * FROM bestiary_attacks ORDER BY bestiary_id, roll')->fetchAll(PDO::FETCH_ASSOC);
        $byBestiary = [];
        foreach ($rows as $row) {
            $byBestiary[(int) $row['bestiary_id']][] = $row;
        }

        return $byBestiary;
    }

    public function passivesByBestiary(): array
    {
        $rows = $this->db->query('SELECT * FROM bestiary_passives ORDER BY bestiary_id, id')->fetchAll(PDO::FETCH_ASSOC);
        $byBestiary = [];
        foreach ($rows as $row) {
            $byBestiary[(int) $row['bestiary_id']][] = $row;
        }

        return $byBestiary;
    }
}
