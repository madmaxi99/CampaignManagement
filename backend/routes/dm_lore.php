<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;

/**
 * DM lore: the chronicle of Weidenmark as chapters, picked with ?k=<slug>.
 * The content lives in templates/lore/chapters/<slug>.twig and ships with the deploy.
 * The path is under /dm, so DmGate already guards it.
 */
return function (App $app): void {
    $chapters = [
        ['slug' => 'uebersicht', 'title' => 'Übersicht'],
        ['slug' => 'korvanis', 'title' => 'Korvanis'],
        ['slug' => 'beifall', 'title' => 'Der Beifall'],
        ['slug' => 'ruhige-jahre', 'title' => 'Die ruhigen Jahre'],
        ['slug' => 'heute', 'title' => 'Weidenmark heute'],
        ['slug' => 'voelker', 'title' => 'Völker'],
        ['slug' => 'land', 'title' => 'Das Land'],
        ['slug' => 'orte', 'title' => 'Städte und Orte'],
        ['slug' => 'haeuser', 'title' => 'Häuser und Gilden'],
    ];

    $app->get('/dm/lore', function (Request $request, Response $response) use ($chapters) {
        $slug = (string) ($request->getQueryParams()['k'] ?? $chapters[0]['slug']);
        $index = array_search($slug, array_column($chapters, 'slug'), true);
        if ($index === false) {
            return $response->withStatus(404);
        }

        return Twig::fromRequest($request)->render($response, 'lore/dm.twig', [
            'chapters' => $chapters,
            'chapter' => $chapters[$index],
            'number' => $index === 0 ? null : $index,
            'prev' => $chapters[$index - 1] ?? null,
            'next' => $chapters[$index + 1] ?? null,
        ]);
    });
};
