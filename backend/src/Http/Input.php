<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Http;

use InvalidArgumentException;

/**
 * Normalizing of loosely typed form input.
 */
final class Input
{
    public static function textOrNull(mixed $value): ?string
    {
        if (! is_string($value)) {
            return null;
        }
        $value = trim($value);

        return $value === '' ? null : $value;
    }

    public static function idOrNull(mixed $value): ?int
    {
        if ($value === null || $value === '' || ! is_numeric($value)) {
            return null;
        }

        return (int) $value;
    }

    /**
     * @throws InvalidArgumentException when the text is longer than $max
     */
    public static function limited(mixed $value, int $max, string $label): ?string
    {
        $text = self::textOrNull($value);
        if ($text !== null && mb_strlen($text) > $max) {
            throw new InvalidArgumentException("{$label} darf höchstens {$max} Zeichen haben.");
        }

        return $text;
    }
}
