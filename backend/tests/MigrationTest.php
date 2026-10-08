<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

/**
 * The test database is built from the init scripts, which already contain every
 * migration: the runner must recognise that, only record the files and be idempotent.
 */
final class MigrationTest extends DatabaseTestCase
{
    public function testMigrationsAreRecordedOnAFreshInstallAndRunOnlyOnce(): void
    {
        $this->useTestDatabaseInApp();
        putenv('DB_ROOT_PASSWORD=' . getenv('DB_PASSWORD'));
        $script = __DIR__ . '/../bin/migrate.php';

        $first = (string) shell_exec(escapeshellarg(PHP_BINARY) . ' ' . escapeshellarg($script) . ' 2>&1');
        self::assertStringContainsString('skipped (already present)', $first);
        self::assertStringNotContainsString('ABORT', $first);

        $files = glob(dirname(__DIR__, 2) . '/database/migrations/*.sql') ?: [];
        $recorded = (int) $this->db->query('SELECT COUNT(*) FROM schema_migrations')
            ->fetchColumn();
        self::assertSame(count($files), $recorded);

        $second = (string) shell_exec(escapeshellarg(PHP_BINARY) . ' ' . escapeshellarg($script) . ' 2>&1');
        self::assertStringContainsString('Nothing to migrate.', $second);
    }
}
