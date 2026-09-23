<?php

declare(strict_types=1);

final class MagicSchoolRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS magic_schools (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                description TEXT
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM magic_schools ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM magic_schools WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $school = $stmt->fetch(PDO::FETCH_ASSOC);

        return $school === false ? null : $school;
    }

    public function findByName(string $name): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM magic_schools WHERE name = :name');
        $stmt->execute(['name' => $name]);
        $school = $stmt->fetch(PDO::FETCH_ASSOC);

        return $school === false ? null : $school;
    }
}
