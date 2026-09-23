<?php

declare(strict_types=1);

final class HeroicAbilityRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS heroic_abilities (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT NOT NULL,
                wp_cost INTEGER,
                requirement TEXT
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM heroic_abilities ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM heroic_abilities WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $ability = $stmt->fetch(PDO::FETCH_ASSOC);

        return $ability === false ? null : $ability;
    }
}
