<?php

declare(strict_types=1);

final class KinRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS kins (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                description TEXT,
                base_movement INTEGER NOT NULL DEFAULT 10
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS kin_abilities (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                kin_id INTEGER NOT NULL,
                name TEXT NOT NULL,
                description TEXT NOT NULL,
                wp_cost INTEGER,
                FOREIGN KEY (kin_id) REFERENCES kins(id)
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM kins ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM kins WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $kin = $stmt->fetch(PDO::FETCH_ASSOC);

        return $kin === false ? null : $kin;
    }

    public function abilities(int $kinId): array
    {
        $stmt = $this->db->prepare('SELECT * FROM kin_abilities WHERE kin_id = :kin_id ORDER BY id');
        $stmt->execute(['kin_id' => $kinId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function abilitiesByKin(): array
    {
        $rows = $this->db->query('SELECT * FROM kin_abilities ORDER BY kin_id, id')->fetchAll(PDO::FETCH_ASSOC);
        $byKin = [];
        foreach ($rows as $row) {
            $byKin[(int) $row['kin_id']][] = $row;
        }

        return $byKin;
    }
}
