<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Service\DmChapters;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;

/**
 * DM lore: the player lore plus what only the game master knows, one chapter per page.
 * The path is under /dm, so DmGate already guards it.
 */
return function (App $app): void {
    $chapters = DmChapters::lore();

    $app->get('/dm/lore', function (Request $request, Response $response) use ($chapters): Response {
        $slug = (string) ($request->getQueryParams()['k'] ?? $chapters[0]['slug']);
        $index = array_search($slug, array_column($chapters, 'slug'), true);
        if ($index === false) {
            return $response->withStatus(404);
        }

        return Twig::fromRequest($request)->render($response, 'dm/lore.twig', [
            'chapters' => $chapters,
            'chapter' => $chapters[$index],
            'number' => $index === 0 ? null : $index,
            'prev' => $chapters[$index - 1] ?? null,
            'next' => $chapters[$index + 1] ?? null,
        ]);
    });
};
