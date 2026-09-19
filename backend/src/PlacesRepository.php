<?php

declare(strict_types=1);

final class PlacesRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS places (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT,
                parent_id INTEGER,
                image_path TEXT,
                pin_x REAL,
                pin_y REAL,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            )
            SQL);
    }

    public function roots(): array
    {
        $stmt = $this->db->query('SELECT * FROM places WHERE parent_id IS NULL ORDER BY id DESC');

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function children(int $placeId): array
    {
        $stmt = $this->db->prepare('SELECT * FROM places WHERE parent_id = :parent_id ORDER BY id DESC');
        $stmt->execute(['parent_id' => $placeId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM places WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        return $row === false ? null : $row;
    }

    public function insert(array $data): int
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');

        $stmt = $this->db->prepare(<<<SQL
            INSERT INTO places (name, description, parent_id, image_path, pin_x, pin_y, created_at, updated_at)
            VALUES (:name, :description, :parent_id, :image_path, :pin_x, :pin_y, :created_at, :updated_at)
            SQL);

        $stmt->execute([
            'name' => $data['name'],
            'description' => $data['description'],
            'parent_id' => $data['parent_id'],
            'image_path' => $data['image_path'],
            'pin_x' => $data['pin_x'],
            'pin_y' => $data['pin_y'],
            'created_at' => $now,
            'updated_at' => $now,
        ]);

        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $data): void
    {
        $stmt = $this->db->prepare(<<<SQL
            UPDATE places
            SET name = :name, description = :description, parent_id = :parent_id,
                image_path = :image_path, pin_x = :pin_x, pin_y = :pin_y, updated_at = :updated_at
            WHERE id = :id
            SQL);

        $stmt->execute([
            'name' => $data['name'],
            'description' => $data['description'],
            'parent_id' => $data['parent_id'],
            'image_path' => $data['image_path'],
            'pin_x' => $data['pin_x'],
            'pin_y' => $data['pin_y'],
            'updated_at' => (new DateTimeImmutable())->format('Y-m-d H:i:s'),
            'id' => $id,
        ]);
    }

    public function breadcrumb(int $id): array
    {
        $chain = [];
        $current = $this->find($id);

        while ($current !== null) {
            array_unshift($chain, $current);
            $current = $current['parent_id'] !== null ? $this->find((int) $current['parent_id']) : null;
        }

        return $chain;
    }
}
