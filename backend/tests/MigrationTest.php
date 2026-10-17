<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

/**
 * An empty database is built completely by the migrations: the runner applies every
 * file once, records it, and a second run has nothing left to do.
 */
final class MigrationTest extends DatabaseTestCase
{
    private const string SCRATCH = 'campaign-management_migrate_test';

    protected function tearDown(): void
    {
        $this->db->exec('DROP DATABASE IF EXISTS `' . self::SCRATCH . '`');
        parent::tearDown();
    }

    public function testMigrationsBuildAnEmptyDatabaseAndRunOnlyOnce(): void
    {
        $this->db->exec('DROP DATABASE IF EXISTS `' . self::SCRATCH . '`');
        $this->db->exec('CREATE DATABASE `' . self::SCRATCH . '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
        $this->useTestDatabaseInApp();
        putenv('DB_NAME=' . self::SCRATCH);
        putenv('DB_ROOT_PASSWORD=' . getenv('DB_PASSWORD'));
        $script = __DIR__ . '/../bin/migrate.php';
        $run = static fn (): string => (string) shell_exec(escapeshellarg(PHP_BINARY) . ' ' . escapeshellarg($script) . ' 2>&1');

        $first = $run();
        self::assertStringNotContainsString('ABORT', $first);
        self::assertStringContainsString('applied                    0001_schema.sql', $first);
        self::assertStringContainsString('Done.', $first);

        $files = glob(dirname(__DIR__, 2) . '/database/migrations/*.sql') ?: [];
        $scratch = $this->db->query('SELECT COUNT(*) FROM `' . self::SCRATCH . '`.schema_migrations')
            ->fetchColumn();
        self::assertSame(count($files), (int) $scratch);
        self::assertGreaterThan(0, (int) $this->db->query('SELECT COUNT(*) FROM `' . self::SCRATCH . '`.characters')->fetchColumn());
        self::assertGreaterThan(0, (int) $this->db->query('SELECT COUNT(*) FROM `' . self::SCRATCH . '`.campaigns')->fetchColumn());

        self::assertStringContainsString('Nothing to migrate.', $run());
    }

    public function testBaselineRefusesANonEmptyDatabase(): void
    {
        $this->useTestDatabaseInApp();
        putenv('DB_ROOT_PASSWORD=' . getenv('DB_PASSWORD'));
        $this->db->exec('DROP TABLE IF EXISTS schema_migrations');

        $output = (string) shell_exec(escapeshellarg(PHP_BINARY) . ' ' . escapeshellarg(__DIR__ . '/../bin/migrate.php') . ' 2>&1');
        $this->db->exec('DROP TABLE IF EXISTS schema_migrations');

        self::assertStringContainsString('ABORT 0001_schema.sql', $output);
    }
}
