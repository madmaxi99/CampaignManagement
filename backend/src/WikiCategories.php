<?php

declare(strict_types=1);

final class WikiCategories
{
    public const CATEGORIES = [
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
}
