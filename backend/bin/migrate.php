<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Database\Connection;
use Flyka\CampaignManagement\Database\DatabaseConfig;

require __DIR__ . '/../vendor/autoload.php';

/**
 * Applies the pending files of database/migrations/ (in file name order) and
 * records them in schema_migrations.
 *
 *   rphp backend/bin/migrate.php          (in the php-fpm container: rphp bin/migrate.php)
 *
 * Uses the root credentials (DB_ROOT_PASSWORD) when set, because migrations
 * change the schema; otherwise the app user.
 *
 * A migration may start with header comments:
 *   -- skip-if: <SELECT>   non-zero result: the change is already in the database
 *                          (fresh install from the init scripts); only recorded.
 *   -- abort-if: <SELECT>  non-zero result: stops without changing anything (e.g. a
 *                          row with one of the ids this migration inserts already exists).
 * MariaDB commits DDL implicitly, so a failing file is not rolled back: fix the
 * cause and apply the rest by hand, or restore the backup taken before.
 */
$config = DatabaseConfig::fromEnvironment();
$rootPassword = getenv('DB_ROOT_PASSWORD');
$db = $rootPassword !== false && $rootPassword !== ''
    ? new Connection($config->dsn(), 'root', $rootPassword)
    : new Connection($config->dsn(), $config->user, $config->password);

$db->exec(<<<SQL
    CREATE TABLE IF NOT EXISTS schema_migrations (
        name VARCHAR(150) PRIMARY KEY,
        applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    SQL);

$applied = $db->query('SELECT name FROM schema_migrations')
    ->fetchAll(PDO::FETCH_COLUMN);
$files = glob(dirname(__DIR__, 2) . '/database/migrations/*.sql') ?: [];
sort($files);

$record = $db->prepare('INSERT INTO schema_migrations (name) VALUES (:name)');
$pending = 0;
foreach ($files as $file) {
    $name = basename($file);
    if (in_array($name, $applied, true)) {
        continue;
    }
    ++$pending;

    $sql = (string) file_get_contents($file);
    $skip = false;
    foreach (headerQueries($sql, 'skip-if') as $query) {
        $skip = $skip || (int) $db->query($query)
            ->fetchColumn() > 0;
    }
    if ($skip) {
        $record->execute([
            'name' => $name,
        ]);
        echo "skipped (already present)  {$name}\n";
        continue;
    }

    foreach (headerQueries($sql, 'abort-if') as $query) {
        if ((int) $db->query($query)->fetchColumn() > 0) {
            fwrite(STDERR, "ABORT {$name}: existing rows collide with this migration ({$query})\n");
            exit(1);
        }
    }

    $db->exec($sql);
    $record->execute([
        'name' => $name,
    ]);
    echo "applied                    {$name}\n";
}

echo $pending === 0 ? "Nothing to migrate.\n" : "Done.\n";

/**
 * @return list<string>
 */
function headerQueries(string $sql, string $directive): array
{
    preg_match_all('/^-- ' . $directive . ': (.+)$/m', $sql, $matches);

    return array_values($matches[1]);
}
