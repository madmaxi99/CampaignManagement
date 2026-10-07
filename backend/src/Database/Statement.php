<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Database;

use PDOStatement;

/**
 * PDOStatement with row types for static analysis; behaviour is unchanged.
 */
final class Statement extends PDOStatement
{
    /**
     * @return list<mixed>
     */
    public function fetchAll(int $mode = Connection::FETCH_DEFAULT, mixed ...$args): array
    {
        /** @var list<mixed> $rows */
        $rows = parent::fetchAll($mode, ...$args);

        return $rows;
    }

    /**
     * @return array<string, mixed>|false
     */
    public function fetch(int $mode = Connection::FETCH_DEFAULT, int $cursorOrientation = Connection::FETCH_ORI_NEXT, int $cursorOffset = 0): mixed
    {
        return parent::fetch($mode, $cursorOrientation, $cursorOffset);
    }
}
