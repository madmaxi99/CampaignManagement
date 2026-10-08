<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Repository\RulesRepository;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;

/**
 * DM rules: everything only the game master needs (NPCs, monsters, journey, roll tables), picked with ?k=<slug>.
 * The path is under /dm, so DmGate already guards it. Player rules live on /rules.
 */
return function (App $app, RulesRepository $rulesRepository): void {
    $chapters = [
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
            'slug' => 'beispiele',
            'title' => 'Beispiele',
        ],
    ];

    $app->get('/dm/rules', function (Request $request, Response $response) use ($chapters, $rulesRepository): Response {
        $slug = (string) ($request->getQueryParams()['k'] ?? $chapters[0]['slug']);
        $index = array_search($slug, array_column($chapters, 'slug'), true);
        if ($index === false) {
            return $response->withStatus(404);
        }

        return Twig::fromRequest($request)->render($response, 'dm/rules.twig', [
            'chapters' => $chapters,
            'chapter' => $chapters[$index],
            'tables' => $rulesRepository->tables(),
        ]);
    });
};
