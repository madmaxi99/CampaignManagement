<?php

declare(strict_types=1);

final class Database
{
    public static function connect(): PDO
    {
        $host = getenv('DB_HOST') ?: 'mariadb';
        $port = getenv('DB_PORT') ?: '3306';
        $name = getenv('DB_NAME') ?: 'flyka';
        $user = getenv('DB_USER') ?: 'flyka';
        $password = getenv('DB_PASSWORD') ?: '';

        $dsn = "mysql:host={$host};port={$port};dbname={$name};charset=utf8mb4";

        $db = new PDO($dsn, $user, $password);
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

        return $db;
    }
}
