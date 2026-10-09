<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Service;

/**
 * Shapes the roll tables and encounter tables for the suggestion tools of the
 * play view. The page picks a random row on the client; the app never rolls
 * a check, a suggestion is something the DM accepts or discards.
 */
final class PlayTools
{
    public const array SUGGESTION_GROUPS = ['Reise & Wildnis', 'Improvisierte Waffen'];

    public const string NPC_GROUP = 'NSC erschaffen';

    /**
     * @param array<string, list<array<string, mixed>>> $groups result of RulesRepository::rollTables()
     * @return array{tables: list<array<string, mixed>>, npc: list<array<string, mixed>>}
     */
    public static function fromRollTables(array $groups): array
    {
        $shape = static fn (array $table): array => [
            'code' => (string) $table['code'],
            'title' => (string) $table['title_de'],
            'die' => (string) $table['die_de'],
            'rows' => array_map(static fn (array $row): array => [
                'roll' => $row['roll_min'] === $row['roll_max'] ? (string) $row['roll_min'] : $row['roll_min'] . '–' . $row['roll_max'],
                'text' => implode(': ', array_filter([(string) $row['name_de'], (string) ($row['effect_de'] ?? '')], static fn (string $part): bool => $part !== '')),
            ], $table['rows']),
        ];

        $tables = [];
        foreach (self::SUGGESTION_GROUPS as $group) {
            foreach ($groups[$group] ?? [] as $table) {
                $tables[] = $shape($table);
            }
        }

        return [
            'tables' => $tables,
            'npc' => array_map($shape, $groups[self::NPC_GROUP] ?? []),
        ];
    }

    /**
     * Encounter table entries of the places, keyed by the table id.
     *
     * @param list<array<string, mixed>> $encounterTables result of CampaignPlaceRepository::encounterTables()
     * @return array<int, array{title: string, rows: list<array<string, string>>}>
     */
    public static function encounters(array $encounterTables): array
    {
        $byTable = [];
        foreach ($encounterTables as $table) {
            $byTable[(int) $table['id']] = [
                'title' => (string) $table['name_de'],
                'rows' => array_values(array_map(static fn (array $entry): array => [
                    'roll' => $entry['max_roll'] === null ? $entry['min_roll'] . '+' : ($entry['min_roll'] === $entry['max_roll'] ? (string) $entry['min_roll'] : $entry['min_roll'] . '–' . $entry['max_roll']),
                    'text' => (string) $entry['text_de'],
                ], $table['entries'])),
            ];
        }

        return $byTable;
    }
}
