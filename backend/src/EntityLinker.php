<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

final class EntityLinker
{
    /**
     * Escapes the text and wraps every registry match in a link. All names are
     * matched in a single pass (longest first), so a short name inside a longer
     * one never produces a nested link.
     *
     * @param array<int, array{match: string, type: string, id: int}> $registry
     */
    public static function linkify(string $text, array $registry): string
    {
        $escaped = htmlspecialchars($text, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        usort($registry, fn (array $a, array $b): int => strlen($b['match']) <=> strlen($a['match']));

        $entries = [];
        foreach ($registry as $entry) {
            $needle = htmlspecialchars($entry['match'], ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
            $entries[$needle] ??= $entry;
        }
        if ($entries === []) {
            return $escaped;
        }

        $alternatives = implode('|', array_map(fn (string $needle): string => preg_quote($needle, '/'), array_keys($entries)));

        return (string) preg_replace_callback(
            '/(?<!\w)(?:' . $alternatives . ')(?!\w)/u',
            function (array $matches) use ($entries): string {
                $entry = $entries[$matches[0]];

                // Locations stay inline on the page (never a modal), so they get a
                // plain scroll-to anchor instead of the entity-link modal trigger.
                if ($entry['type'] === 'location') {
                    return sprintf('<a href="#location-%d" class="location-ref">%s</a>', $entry['id'], $matches[0]);
                }

                return sprintf(
                    '<a href="#" class="entity-link" data-entity-type="%s" data-entity-id="%d">%s</a>',
                    $entry['type'],
                    $entry['id'],
                    $matches[0]
                );
            },
            $escaped
        );
    }
}
