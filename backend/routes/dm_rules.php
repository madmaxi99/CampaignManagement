<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Repository\RulesRepository;
use Flyka\CampaignManagement\Repository\WorldRepository;
use Flyka\CampaignManagement\Service\DmChapters;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;

/**
 * DM rules: what only the game master needs, one chapter per page. The random
 * tables sit in the chapter they belong to, the random encounters are a chapter
 * of their own. The path is under /dm, so DmGate already guards it. Player rules live on /rules.
 */
return function (App $app, RulesRepository $rulesRepository, WorldRepository $world): void {
    $chapters = DmChapters::rules();

    $app->get('/dm/rules', function (Request $request, Response $response) use ($chapters, $rulesRepository, $world): Response {
        $slug = (string) ($request->getQueryParams()['k'] ?? $chapters[0]['slug']);
        $index = array_search($slug, array_column($chapters, 'slug'), true);
        if ($index === false) {
            return $response->withStatus(404);
        }

        return Twig::fromRequest($request)->render($response, 'dm/rules.twig', [
            'chapters' => $chapters,
            'chapter' => $chapters[$index],
            'tables' => $rulesRepository->tables(),
            'encounterTables' => $slug === 'zufallsbegegnungen' ? $world->encounterTables() : [],
        ]);
    });
};
