<?php

declare(strict_types=1);

final class EntityLinker
{
    public static function linkify(string $text, array $registry): string
    {
        $escaped = htmlspecialchars($text, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');

        usort($registry, fn (array $a, array $b) => strlen($b['match']) <=> strlen($a['match']));

        foreach ($registry as $entry) {
            $needle = htmlspecialchars($entry['match'], ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
            $pattern = '/(?<!\w)' . preg_quote($needle, '/') . '(?!\w)/u';

            // Locations stay inline on the page (never a modal), so they get a
            // plain scroll-to anchor instead of the entity-link modal trigger.
            if ($entry['type'] === 'location') {
                $replacement = sprintf('<a href="#location-%d" class="location-ref">%s</a>', $entry['id'], $needle);
            } else {
                $replacement = sprintf(
                    '<a href="#" class="entity-link" data-entity-type="%s" data-entity-id="%d">%s</a>',
                    $entry['type'],
                    $entry['id'],
                    $needle
                );
            }

            $escaped = preg_replace($pattern, $replacement, $escaped);
        }

        return $escaped;
    }
}
