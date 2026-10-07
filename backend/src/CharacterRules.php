<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

/**
 * Pure rule calculations of the own system, independent of the database.
 */
final class CharacterRules
{
    /**
     * Base chance of a skill for an attribute value.
     */
    public static function baseChance(int $value): int
    {
        return match (true) {
            $value <= 5 => 3,
            $value <= 8 => 4,
            $value <= 12 => 5,
            $value <= 15 => 6,
            default => 7,
        };
    }

    public static function damageBonus(int $value): string
    {
        return match (true) {
            $value <= 12 => '—',
            $value <= 16 => 'W4',
            default => 'W6',
        };
    }

    /**
     * Movement/carrying capacity/damage bonus aren't stored -- they're always
     * derivable from the kin (movement_base) and the STA/GEW attribute values.
     *
     * @param array{movement_base: int|string} $character
     * @param array<int, array{code: string, value: int|string}> $attributes
     * @return array{movement: int, carrying_capacity: int, damage_bonus_sta_de: string, damage_bonus_gew_de: string}
     */
    public static function derivedStats(array $character, array $attributes): array
    {
        $attributeValues = [];
        foreach ($attributes as $attribute) {
            $attributeValues[$attribute['code']] = (int) $attribute['value'];
        }
        $gew = $attributeValues['GEW'] ?? 0;
        $sta = $attributeValues['STA'] ?? 0;

        $movementModifier = match (true) {
            $gew <= 6 => -4,
            $gew <= 9 => -2,
            $gew <= 12 => 0,
            $gew <= 15 => 2,
            default => 4,
        };

        return [
            'movement' => (int) $character['movement_base'] + $movementModifier,
            'carrying_capacity' => (int) ceil($sta / 2),
            'damage_bonus_sta_de' => self::damageBonus($sta),
            'damage_bonus_gew_de' => self::damageBonus($gew),
        ];
    }
}
