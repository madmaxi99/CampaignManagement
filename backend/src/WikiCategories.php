<?php

declare(strict_types=1);

final class WikiCategories
{
    public const CATEGORIES = [
        'bestiary' => [
            'table' => 'bestiary',
            'label' => 'Bestiarium',
            'columns' => [
                ['name' => 'name', 'label' => 'Name', 'type' => 'text'],
                ['name' => 'hp', 'label' => 'HP', 'type' => 'number'],
                ['name' => 'armor', 'label' => 'Armor', 'type' => 'number'],
                ['name' => 'attack', 'label' => 'Attack', 'type' => 'text'],
                ['name' => 'morale', 'label' => 'Morale', 'type' => 'number'],
                ['name' => 'moves', 'label' => 'Moves', 'type' => 'textarea'],
                ['name' => 'description', 'label' => 'Beschreibung', 'type' => 'textarea'],
            ],
        ],
        'items' => [
            'table' => 'items',
            'label' => 'Items',
            'columns' => [
                ['name' => 'name', 'label' => 'Name', 'type' => 'text'],
                ['name' => 'description', 'label' => 'Beschreibung', 'type' => 'textarea'],
                ['name' => 'effect', 'label' => 'Effekt', 'type' => 'textarea'],
            ],
        ],
        'spellbooks' => [
            'table' => 'spellbooks',
            'label' => 'Zauberbücher',
            'columns' => [
                ['name' => 'name', 'label' => 'Name', 'type' => 'text'],
                ['name' => 'description', 'label' => 'Enthaltene Zaubersprüche', 'type' => 'textarea'],
            ],
        ],
        'relics' => [
            'table' => 'relics',
            'label' => 'Relikte',
            'columns' => [
                ['name' => 'name', 'label' => 'Name', 'type' => 'text'],
                ['name' => 'description', 'label' => 'Beschreibung', 'type' => 'textarea'],
                ['name' => 'effect', 'label' => 'Effekt', 'type' => 'textarea'],
            ],
        ],
        'books' => [
            'table' => 'books',
            'label' => 'Bücher',
            'columns' => [
                ['name' => 'title', 'label' => 'Titel', 'type' => 'text'],
                ['name' => 'language', 'label' => 'Sprache', 'type' => 'text'],
                ['name' => 'content', 'label' => 'Inhalt', 'type' => 'textarea'],
            ],
        ],
    ];

    public static function find(string $slug): ?array
    {
        return self::CATEGORIES[$slug] ?? null;
    }

    public static function tabs(): array
    {
        $tabs = [];

        foreach (self::CATEGORIES as $slug => $config) {
            $tabs[$slug] = ['label' => $config['label']];
        }

        $tabs['places'] = ['label' => 'Orte'];

        return $tabs;
    }
}
