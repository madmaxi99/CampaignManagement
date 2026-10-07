<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Auth\DmAuth;
use Flyka\CampaignManagement\Repository\RulesRepository;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use Slim\Views\Twig;
use function Flyka\CampaignManagement\Http\safeDmTarget;

/**
 * Public pages, DM login/logout and the redirects of old URLs.
 */
return function (App $app, RulesRepository $rulesRepository, DmAuth $dmAuth): void {
    $app->get('/', fn (Request $request, Response $response) => $response->withHeader('Location', '/characters')->withStatus(302));

    $app->get('/rules', fn (Request $request, Response $response): Response => Twig::fromRequest($request)->render($response, 'rules.twig', [
        'items' => $rulesRepository->items(),
        'skills' => $rulesRepository->skills(),
        'schools' => $rulesRepository->spellsBySchool(),
        'professions' => $rulesRepository->professions(),
        'kins' => $rulesRepository->kins(),
        'heroicAbilities' => $rulesRepository->heroicAbilities(),
        'tables' => $rulesRepository->tables(),
    ]));

    $app->get('/lore', fn (Request $request, Response $response): Response => Twig::fromRequest($request)->render($response, 'lore/index.twig'));

    // ---- DM login / logout / old URLs ----

    $app->get('/dm/login', function (Request $request, Response $response) use ($dmAuth) {
        if ($dmAuth->isLoggedIn()) {
            return $response->withHeader('Location', '/dm')
                ->withStatus(302);
        }

        return Twig::fromRequest($request)->render($response, 'dm/login.twig', [
            'configured' => $dmAuth->isConfigured(),
            'next' => safeDmTarget($request->getQueryParams()['next'] ?? null),
            'error' => null,
        ]);
    });

    $app->post('/dm/login', function (Request $request, Response $response) use ($dmAuth) {
        $body = (array) $request->getParsedBody();
        $next = safeDmTarget($body['next'] ?? null);
        $render = fn (?string $error, int $status): Response => Twig::fromRequest($request)->render(
            $response->withStatus($status),
            'dm/login.twig',
            [
                'configured' => $dmAuth->isConfigured(),
                'next' => $next,
                'error' => $error,
            ]
        );

        if (! $dmAuth->validCsrf((string) ($body['_csrf'] ?? ''))) {
            return $render('Sitzung abgelaufen, bitte noch einmal versuchen.', 403);
        }

        $clientId = $request->getServerParams()['REMOTE_ADDR'] ?? 'unknown';
        $result = $dmAuth->attempt((string) ($body['password'] ?? ''), $clientId);

        return match ($result) {
            'ok' => $response->withHeader('Location', $next)
                ->withStatus(302),
            'locked' => $render('Zu viele Versuche. Bitte in ' . $dmAuth->lockedSeconds($clientId) . ' Sekunden noch einmal versuchen.', 429),
            'unconfigured' => $render(null, 503),
            default => $render('Das Passwort stimmt nicht.', 401),
        };
    });

    $app->post('/dm/logout', function (Request $request, Response $response) use ($dmAuth) {
        $dmAuth->logout();

        return $response->withHeader('Location', '/characters')
            ->withStatus(302);
    });

    $app->get('/dm/styleguide', fn (Request $request, Response $response): Response => Twig::fromRequest($request)->render($response, 'dm/styleguide.twig'));

    // Old URLs of the previous layout.
    $app->get('/campaign', fn (Request $request, Response $response) => $response->withHeader('Location', '/dm')->withStatus(301));
    $app->get('/campaign/{id:[0-9]+}', fn (Request $request, Response $response, array $args) => $response->withHeader('Location', '/dm/campaign/' . $args['id'])->withStatus(301));
    $app->get('/world', fn (Request $request, Response $response) => $response->withHeader('Location', '/dm/catalog')->withStatus(301));
};
