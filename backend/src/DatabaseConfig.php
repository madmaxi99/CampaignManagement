<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

final readonly class DatabaseConfig
{
    public function __construct(
        public string $host,
        public string $port,
        public string $name,
        public string $user,
        public string $password,
    ) {
    }

    public static function fromEnvironment(): self
    {
        return new self(
            getenv('DB_HOST') ?: 'mariadb',
            getenv('DB_PORT') ?: '3306',
            getenv('DB_NAME') ?: 'campaign-management',
            getenv('DB_USER') ?: 'flyka',
            getenv('DB_PASSWORD') ?: '',
        );
    }

    public function dsn(): string
    {
        return "mysql:host={$this->host};port={$this->port};dbname={$this->name};charset=utf8mb4";
    }
}
