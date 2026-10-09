<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Service;

/**
 * The chapters of the DM rules and DM lore areas, in one place so the pages and
 * the search agree on slugs and titles.
 */
final class DmChapters
{
    /**
     * @return list<array{slug: string, title: string}>
     */
    public static function rules(): array
    {
        return [
            [
                'slug' => 'spielleitung',
                'title' => 'Spielleitung & NSC',
            ],
            [
                'slug' => 'kampf',
                'title' => 'NSC im Kampf',
            ],
            [
                'slug' => 'monster',
                'title' => 'Monster',
            ],
            [
                'slug' => 'reise',
                'title' => 'Reise & Abenteuerorte',
            ],
            [
                'slug' => 'nsc',
                'title' => 'NSC erschaffen',
            ],
            [
                'slug' => 'zufallsbegegnungen',
                'title' => 'Zufallsbegegnungen',
            ],
        ];
    }

    /**
     * @return list<array{slug: string, title: string}>
     */
    public static function lore(): array
    {
        return [
            [
                'slug' => 'uebersicht',
                'title' => 'Übersicht',
            ],
            [
                'slug' => 'korvanis',
                'title' => 'Korvanis',
            ],
            [
                'slug' => 'beifall',
                'title' => 'Der Beifall',
            ],
            [
                'slug' => 'ruhige-jahre',
                'title' => 'Die ruhigen Jahre',
            ],
            [
                'slug' => 'heute',
                'title' => 'Weidenmark heute',
            ],
            [
                'slug' => 'voelker',
                'title' => 'Völker',
            ],
            [
                'slug' => 'land',
                'title' => 'Das Land',
            ],
            [
                'slug' => 'orte',
                'title' => 'Städte und Orte',
            ],
            [
                'slug' => 'schauplaetze',
                'title' => 'Schauplätze',
            ],
            [
                'slug' => 'haeuser',
                'title' => 'Häuser und Gilden',
            ],
            [
                'slug' => 'personen',
                'title' => 'Personen',
            ],
        ];
    }
}
