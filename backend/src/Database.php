<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

final class Database
{
    public static function connect(DatabaseConfig $config): Connection
    {
        return new Connection($config->dsn(), $config->user, $config->password);
    }
}
