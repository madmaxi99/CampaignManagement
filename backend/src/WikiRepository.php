<?php

declare(strict_types=1);

final class WikiRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(string $table, array $columns): void
    {
        $columnDefs = array_map(
            static fn (array $col): string => sprintf(
                '%s %s',
                $col['name'],
                $col['type'] === 'number' ? 'INTEGER' : 'TEXT'
            ),
            $columns
        );

        $sql = sprintf(
            'CREATE TABLE IF NOT EXISTS %s (id INTEGER PRIMARY KEY AUTOINCREMENT, %s, created_at TEXT NOT NULL, updated_at TEXT NOT NULL)',
            $table,
            implode(', ', $columnDefs)
        );

        $this->db->exec($sql);
    }

    public function all(string $table): array
    {
        $stmt = $this->db->query(sprintf('SELECT * FROM %s ORDER BY id DESC', $table));

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(string $table, int $id): ?array
    {
        $stmt = $this->db->prepare(sprintf('SELECT * FROM %s WHERE id = :id', $table));
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        return $row === false ? null : $row;
    }

    public function insert(string $table, array $columns, array $data): void
    {
        $names = array_map(static fn (array $c): string => $c['name'], $columns);
        $placeholders = array_map(static fn (string $n): string => ':' . $n, $names);
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');

        $sql = sprintf(
            'INSERT INTO %s (%s, created_at, updated_at) VALUES (%s, :created_at, :updated_at)',
            $table,
            implode(', ', $names),
            implode(', ', $placeholders)
        );

        $params = $this->normalizeParams($columns, $data);
        $params['created_at'] = $now;
        $params['updated_at'] = $now;

        $this->db->prepare($sql)->execute($params);
    }

    public function update(string $table, array $columns, int $id, array $data): void
    {
        $names = array_map(static fn (array $c): string => $c['name'], $columns);
        $assignments = array_map(static fn (string $n): string => sprintf('%s = :%s', $n, $n), $names);

        $sql = sprintf(
            'UPDATE %s SET %s, updated_at = :updated_at WHERE id = :id',
            $table,
            implode(', ', $assignments)
        );

        $params = $this->normalizeParams($columns, $data);
        $params['updated_at'] = (new DateTimeImmutable())->format('Y-m-d H:i:s');
        $params['id'] = $id;

        $this->db->prepare($sql)->execute($params);
    }

    private function normalizeParams(array $columns, array $data): array
    {
        $params = [];

        foreach ($columns as $col) {
            $name = $col['name'];
            $raw = trim((string) ($data[$name] ?? ''));

            if ($col['type'] === 'number') {
                $params[$name] = $raw === '' ? null : (int) $raw;
            } else {
                $params[$name] = $raw;
            }
        }

        return $params;
    }
}
