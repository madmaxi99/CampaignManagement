<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use PDO;

final class Database
{
    public static function connect(DatabaseConfig $config): PDO
    {
        $db = new PDO($config->dsn(), $config->user, $config->password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

        return $db;
    }
}
