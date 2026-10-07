<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use PDO;
use PDOException;

/**
 * PDO in exception mode with associative rows, where query() and prepare()
 * never return false.
 */
final class Connection extends PDO
{
    public function __construct(string $dsn, ?string $username = null, ?string $password = null)
    {
        parent::__construct($dsn, $username, $password);
        $this->setAttribute(self::ATTR_ERRMODE, self::ERRMODE_EXCEPTION);
        $this->setAttribute(self::ATTR_DEFAULT_FETCH_MODE, self::FETCH_ASSOC);
        $this->setAttribute(self::ATTR_STATEMENT_CLASS, [Statement::class]);
    }

    public function query(string $query, ?int $fetchMode = null, mixed ...$fetchModeArgs): Statement
    {
        $statement = $fetchMode === null
            ? parent::query($query)
            : parent::query($query, $fetchMode, ...$fetchModeArgs);

        return $statement instanceof Statement ? $statement : throw new PDOException('Query failed: ' . $query);
    }

    /**
     * @param array<mixed> $options
     */
    public function prepare(string $query, array $options = []): Statement
    {
        $statement = parent::prepare($query, $options);

        return $statement instanceof Statement ? $statement : throw new PDOException('Prepare failed: ' . $query);
    }
}
