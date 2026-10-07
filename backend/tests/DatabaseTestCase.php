<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\Database\Connection;
use PDO;
use PHPUnit\Framework\TestCase;

/**
 * Base class for tests that need the real schema. The test database is
 * rebuilt once per run from database/01_schema.sql and 02_catalog.sql; tests
 * clean up their own rows. Skipped when no database server is configured
 * (TEST_DB_HOST or DB_HOST plus TEST_DB_PASSWORD or DB_ROOT_PASSWORD).
 */
abstract class DatabaseTestCase extends TestCase
{
    private static ?Connection $pdo = null;

    /**
     * @var array<string, string>
     */
    private static array $environment = [];

    protected Connection $db;

    protected function setUp(): void
    {
        $this->db = $this->connection();
    }

    /**
     * Points the app's own database configuration (DB_*) at the test database.
     */
    protected function useTestDatabaseInApp(): void
    {
        foreach (self::$environment as $key => $value) {
            putenv($key . '=' . $value);
        }
    }

    private function connection(): Connection
    {
        if (self::$pdo instanceof Connection) {
            return self::$pdo;
        }

        $host = getenv('TEST_DB_HOST') ?: getenv('DB_HOST');
        $password = getenv('TEST_DB_PASSWORD') ?: getenv('DB_ROOT_PASSWORD');
        if (! $host || $password === false || $password === '') {
            self::markTestSkipped('No test database configured (TEST_DB_HOST/TEST_DB_PASSWORD).');
        }

        $port = getenv('TEST_DB_PORT') ?: '3306';
        $user = getenv('TEST_DB_USER') ?: 'root';
        $name = getenv('TEST_DB_NAME') ?: 'campaign-management_test';

        $server = new PDO("mysql:host={$host};port={$port};charset=utf8mb4", $user, $password, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        ]);
        $server->exec("DROP DATABASE IF EXISTS `{$name}`");
        $server->exec("CREATE DATABASE `{$name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");

        $pdo = new Connection("mysql:host={$host};port={$port};dbname={$name};charset=utf8mb4", $user, $password);
        foreach (['01_schema.sql', '02_catalog.sql'] as $file) {
            $pdo->exec((string) file_get_contents(dirname(__DIR__, 2) . '/database/' . $file));
        }

        self::$environment = [
            'DB_HOST' => $host,
            'DB_PORT' => $port,
            'DB_NAME' => $name,
            'DB_USER' => $user,
            'DB_PASSWORD' => $password,
        ];

        return self::$pdo = $pdo;
    }
}
