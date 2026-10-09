<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Service;

/**
 * Shapes the "NSC erschaffen" roll tables for the NPC suggestion of the play
 * view. The page picks a random row on the client: a suggestion the DM saves
 * or discards, never a rule outcome.
 */
final class PlayTools
{
    public const string NPC_GROUP = 'NSC erschaffen';

    /**
     * @param array<string, list<array<string, mixed>>> $groups result of RulesRepository::rollTables()
     * @return list<array{code: string, rows: list<string>}>
     */
    public static function npcTables(array $groups): array
    {
        return array_map(static fn (array $table): array => [
            'code' => (string) $table['code'],
            'rows' => array_values(array_map(
                static fn (array $row): string => implode(': ', array_filter([(string) $row['name_de'], (string) ($row['effect_de'] ?? '')], static fn (string $part): bool => $part !== '')),
                $table['rows']
            )),
        ], $groups[self::NPC_GROUP] ?? []);
    }
}
