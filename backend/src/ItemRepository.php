<?php

declare(strict_types=1);

final class ItemRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                category TEXT NOT NULL CHECK (category IN (
                    'armor', 'weapon_melee', 'weapon_ranged', 'clothing', 'instrument',
                    'trade_good', 'magic_item', 'transportation', 'animal', 'other'
                )),
                cost TEXT,
                supply TEXT CHECK (supply IN ('common', 'uncommon', 'rare', 'unique')),
                weight INTEGER,
                armor_rating INTEGER,
                grip TEXT,
                str_requirement INTEGER,
                damage TEXT,
                range TEXT,
                effect TEXT
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM items ORDER BY category, name')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM items WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $item = $stmt->fetch(PDO::FETCH_ASSOC);

        return $item === false ? null : $item;
    }

    public function findByName(string $name): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM items WHERE name = :name');
        $stmt->execute(['name' => $name]);
        $item = $stmt->fetch(PDO::FETCH_ASSOC);

        return $item === false ? null : $item;
    }

    /** Returns the id of the "Grimoire" item, creating it if it doesn't exist yet. */
    public function findOrCreateGrimoire(): int
    {
        $existing = $this->findByName('Grimoire');
        if ($existing !== null) {
            return (int) $existing['id'];
        }

        $stmt = $this->db->prepare(<<<SQL
            INSERT INTO items (name, category, cost, supply, weight, effect)
            VALUES ('Grimoire', 'magic_item', '50 Kronen', 'uncommon', 1,
                'Enthält die Zauber, die dein Charakter kennt — im Spiel schlägst du hier deine bekannten Zauber nach.')
            SQL);
        $stmt->execute();

        return (int) $this->db->lastInsertId();
    }
}
