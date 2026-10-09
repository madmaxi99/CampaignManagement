<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Repository\SearchRepository;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\App;
use function Flyka\CampaignManagement\Http\jsonResponse;

/**
 * JSON search over the campaign and the catalog. Parked: no page uses it right now,
 * the search comes back per area (see docs/PLAN.md). Under /dm, so DmGate guards it.
 */
return function (App $app, SearchRepository $search): void {
    $app->get('/dm/search', function (Request $request, Response $response) use ($search): Response {
        $params = $request->getQueryParams();
        $group = (string) ($params['t'] ?? '');
        $campaignId = (int) ($params['c'] ?? 0);

        return jsonResponse($response, [
            'results' => $search->search(
                (string) ($params['q'] ?? ''),
                in_array($group, ['campaign', 'monster', 'item', 'spell'], true) ? $group : '',
                $campaignId > 0 ? $campaignId : null
            ),
        ]);
    });
};
