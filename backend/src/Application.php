<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use Flyka\CampaignManagement\Auth\DmAuth;
use Flyka\CampaignManagement\Auth\DmGate;
use Flyka\CampaignManagement\Auth\SessionMiddleware;
use Flyka\CampaignManagement\Database\Database;
use Flyka\CampaignManagement\Database\DatabaseConfig;
use Flyka\CampaignManagement\Repository\CampaignChapterRepository;
use Flyka\CampaignManagement\Repository\CampaignItemRepository;
use Flyka\CampaignManagement\Repository\CampaignLookup;
use Flyka\CampaignManagement\Repository\CampaignMonsterRepository;
use Flyka\CampaignManagement\Repository\CampaignNpcRepository;
use Flyka\CampaignManagement\Repository\CampaignPlaceRepository;
use Flyka\CampaignManagement\Repository\CampaignRepository;
use Flyka\CampaignManagement\Repository\CampaignStandRepository;
use Flyka\CampaignManagement\Repository\CatalogEditorRepository;
use Flyka\CampaignManagement\Repository\CharacterCreationRepository;
use Flyka\CampaignManagement\Repository\CharacterRepository;
use Flyka\CampaignManagement\Repository\RulesRepository;
use Flyka\CampaignManagement\Repository\SearchRepository;
use Flyka\CampaignManagement\Repository\WorldRepository;
use Flyka\CampaignManagement\Service\EntityLinker;
use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\App;
use Slim\Factory\AppFactory;
use Slim\Psr7\Factory\ResponseFactory;
use Slim\Views\Twig;
use Slim\Views\TwigMiddleware;
use Twig\TwigFilter;
use Twig\TwigFunction;

/**
 * Builds the Slim app: repositories, view setup, middleware stack and routes.
 */
final class Application
{
    /**
     * @return App<ContainerInterface|null>
     */
    public static function create(string $backendDir): App
    {
        $db = Database::connect(DatabaseConfig::fromEnvironment());
        $characterRepository = new CharacterRepository($db);
        $campaignLookup = new CampaignLookup($db);
        $campaignRepository = new CampaignRepository($db);
        $chapterRepository = new CampaignChapterRepository($db, $campaignLookup);
        $monsterRepository = new CampaignMonsterRepository($db, $campaignLookup);
        $npcRepository = new CampaignNpcRepository($db, $campaignLookup, $monsterRepository);
        $placeRepository = new CampaignPlaceRepository($db, $campaignLookup);
        $itemRepository = new CampaignItemRepository($db, $campaignLookup);
        $standRepository = new CampaignStandRepository($db);
        $worldRepository = new WorldRepository($db);
        $characterCreationRepository = new CharacterCreationRepository($db);
        $rulesRepository = new RulesRepository($db);
        $catalogEditor = new CatalogEditorRepository($db);
        $searchRepository = new SearchRepository($db);
        $dmAuth = new DmAuth(getenv('DM_PASSWORD_HASH') ?: null, sys_get_temp_dir());

        $app = AppFactory::create();
        $twig = Twig::create($backendDir . '/templates', [
            'cache' => false,
        ]);

        // Middleware runs bottom-up: session first, then the DM lock, then the view globals.
        $app->add(TwigMiddleware::create($app, $twig));
        $app->add(function (Request $request, RequestHandler $handler) use ($twig, $dmAuth): Response {
            $environment = $twig->getEnvironment();
            $environment->addGlobal('is_dm', $dmAuth->isLoggedIn());
            $environment->addGlobal('csrf_token', $dmAuth->csrfToken());

            return $handler->handle($request);
        });
        $app->add(new DmGate($dmAuth, new ResponseFactory()));
        $app->add(new SessionMiddleware());

        self::configureTwig($twig, $backendDir . '/public');

        (require $backendDir . '/routes/character.php')($app, $characterRepository, $characterCreationRepository);
        (require $backendDir . '/routes/public.php')($app, $rulesRepository, $dmAuth);
        (require $backendDir . '/routes/dm_campaign.php')(
            $app,
            $campaignRepository,
            $chapterRepository,
            $npcRepository,
            $placeRepository,
            $itemRepository,
            $monsterRepository,
            $standRepository,
            $catalogEditor,
            $rulesRepository
        );
        (require $backendDir . '/routes/dm_catalog.php')($app, $catalogEditor, $worldRepository);
        (require $backendDir . '/routes/dm_rules.php')($app, $rulesRepository, $worldRepository);
        (require $backendDir . '/routes/dm_lore.php')($app);
        (require $backendDir . '/routes/dm_search.php')($app, $searchRepository);

        return $app;
    }

    private static function configureTwig(Twig $twig, string $publicDir): void
    {
        $environment = $twig->getEnvironment();
        $environment->addGlobal('app_name', 'Abenteuerbuch');
        $environment->addFilter(new TwigFilter('repeat', fn (string $text, int $times): string => str_repeat($text, max(0, $times))));
        $environment->addFilter(new TwigFilter('linkify', EntityLinker::linkify(...), [
            'is_safe' => ['html'],
        ]));
        // asset('css/x.css') -> /css/x.css?v=<mtime>, so browsers pick up changes.
        $environment->addFunction(new TwigFunction('asset', static function (string $path) use ($publicDir): string {
            $file = $publicDir . '/' . $path;

            return '/' . $path . '?v=' . (is_file($file) ? filemtime($file) : 0);
        }));
    }
}
