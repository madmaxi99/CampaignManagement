<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\CharacterRules;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

final class CharacterRulesTest extends TestCase
{
    /**
     * @return iterable<string, array{int, int}>
     */
    public static function baseChances(): iterable
    {
        yield 'lowest' => [1, 3];
        yield 'upper bound 5' => [5, 3];
        yield 'lower bound 6' => [6, 4];
        yield 'upper bound 8' => [8, 4];
        yield 'lower bound 9' => [9, 5];
        yield 'upper bound 12' => [12, 5];
        yield 'lower bound 13' => [13, 6];
        yield 'upper bound 15' => [15, 6];
        yield 'lower bound 16' => [16, 7];
        yield 'high' => [18, 7];
    }

    #[DataProvider('baseChances')]
    public function testBaseChance(int $value, int $expected): void
    {
        self::assertSame($expected, CharacterRules::baseChance($value));
    }

    public function testDamageBonusThresholds(): void
    {
        self::assertSame('—', CharacterRules::damageBonus(12));
        self::assertSame('W4', CharacterRules::damageBonus(13));
        self::assertSame('W4', CharacterRules::damageBonus(16));
        self::assertSame('W6', CharacterRules::damageBonus(17));
    }

    public function testDerivedStats(): void
    {
        $stats = CharacterRules::derivedStats([
            'movement_base' => '10',
        ], [
            [
                'code' => 'GEW',
                'value' => 16,
            ],
            [
                'code' => 'STA',
                'value' => '13',
            ],
        ]);

        self::assertSame([
            'movement' => 14,
            'carrying_capacity' => 7,
            'damage_bonus_sta_de' => 'W4',
            'damage_bonus_gew_de' => 'W4',
        ], $stats);
    }

    public function testMovementModifierSteps(): void
    {
        $movement = static fn (int $gew): int => CharacterRules::derivedStats([
            'movement_base' => 10,
        ], [
            [
                'code' => 'GEW',
                'value' => $gew,
            ],
        ])['movement'];

        self::assertSame(6, $movement(6));
        self::assertSame(8, $movement(9));
        self::assertSame(10, $movement(12));
        self::assertSame(12, $movement(15));
        self::assertSame(14, $movement(16));
    }
}
