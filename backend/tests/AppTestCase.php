<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\Application;
use PDO;
use Psr\Http\Message\ResponseInterface;
use Slim\App;
use Slim\Psr7\Factory\ServerRequestFactory;
use Slim\Psr7\Factory\StreamFactory;

/**
 * Base for tests that drive the whole Slim app (middleware, routes,
 * repositories, templates) against the test database.
 */
abstract class AppTestCase extends DatabaseTestCase
{
    private const string PASSWORD = 'test-password';

    private App $app;

    protected function setUp(): void
    {
        parent::setUp();
        $this->useTestDatabaseInApp();
        putenv('DM_PASSWORD_HASH=' . password_hash(self::PASSWORD, PASSWORD_DEFAULT));

        // The session must work without cookies/headers inside the CLI test run.
        ini_set('session.use_cookies', '0');
        ini_set('session.use_only_cookies', '0');
        ini_set('session.cache_limiter', '');
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_destroy();
        }
        $_SESSION = [];

        // SessionMiddleware sets cookie params, which PHP flags when cookies are off (CLI only).
        set_error_handler(static fn (int $severity, string $message): bool => str_contains($message, 'session.use_cookies'));

        $this->app = Application::create(dirname(__DIR__));
    }

    protected function tearDown(): void
    {
        $this->db->exec('DELETE FROM campaigns WHERE name_de LIKE \'Route-Test%\'');
        $this->db->exec('DELETE FROM characters WHERE name_de LIKE \'Route-Test%\'');
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_destroy();
        }
        putenv('DM_PASSWORD_HASH');
        restore_error_handler();
    }

    protected function loginAsDm(): void
    {
        $this->request('GET', '/dm/login');
        $response = $this->request('POST', '/dm/login', [
            'password' => self::PASSWORD,
            '_csrf' => $_SESSION['csrf'],
            'next' => '/dm',
        ], form: true);

        self::assertSame(302, $response->getStatusCode());
        self::assertSame('/dm', $response->getHeaderLine('Location'));
    }

    /**
     * @param array<string, mixed>|null $data
     */
    protected function request(string $method, string $uri, ?array $data = null, bool $form = false, bool $csrf = true): ResponseInterface
    {
        $request = (new ServerRequestFactory())->createServerRequest($method, 'http://localhost' . $uri, [
            'REMOTE_ADDR' => '127.0.0.1',
        ]);
        parse_str((string) parse_url($uri, PHP_URL_QUERY), $query);
        $request = $request->withQueryParams($query);

        if ($data !== null) {
            if ($form) {
                $request = $request->withParsedBody($data)
                    ->withHeader('Content-Type', 'application/x-www-form-urlencoded');
            } else {
                $request = $request->withBody((new StreamFactory())->createStream(json_encode($data, JSON_THROW_ON_ERROR)))
                    ->withHeader('Content-Type', 'application/json');
            }
        }
        if (! $form && $method !== 'GET' && $csrf && isset($_SESSION['csrf'])) {
            $request = $request->withHeader('X-CSRF-Token', $_SESSION['csrf']);
        }

        return $this->app->handle($request);
    }

    protected function ok(ResponseInterface $response): void
    {
        self::assertContains($response->getStatusCode(), [200, 201], (string) $response->getBody());
    }

    /**
     * @return array<string, mixed>
     */
    protected function json(ResponseInterface $response, int $status): array
    {
        self::assertSame($status, $response->getStatusCode(), (string) $response->getBody());

        return json_decode((string) $response->getBody(), true, flags: JSON_THROW_ON_ERROR);
    }

    protected function assertCleanBody(ResponseInterface $response, string $path): void
    {
        $body = (string) $response->getBody();
        self::assertDoesNotMatchRegularExpression('/(Warning|Notice|Deprecated|Fatal error):/', $body, $path);
    }

    /**
     * A valid wizard submission for a non-magical, unrestricted profession.
     *
     * @return array<string, mixed>
     */
    protected function wizardPayload(): array
    {
        $profession = $this->db->query(<<<SQL
            SELECT p.code FROM catalog_professions p
            WHERE p.grants_magic = 0 AND p.kin_restriction IS NULL
              AND (SELECT COUNT(*) FROM catalog_profession_key_skills k WHERE k.profession_code = p.code) >= 6
              AND EXISTS (SELECT 1 FROM catalog_profession_gear_options g WHERE g.profession_code = p.code)
            ORDER BY p.code LIMIT 1
            SQL)->fetchColumn();
        self::assertNotFalse($profession, 'catalog has no suitable profession');

        $pool = $this->db->query("SELECT skill_id FROM catalog_profession_key_skills WHERE profession_code = '{$profession}'")
            ->fetchAll(PDO::FETCH_COLUMN);
        $others = $this->db->query('SELECT id FROM catalog_skills ORDER BY id')
            ->fetchAll(PDO::FETCH_COLUMN);
        $skills = array_slice(array_values(array_unique(array_merge($pool, $others))), 0, 8);

        $gear = $this->db->query("SELECT id, starting_silver_dice FROM catalog_profession_gear_options WHERE profession_code = '{$profession}' ORDER BY id LIMIT 1")
            ->fetch();

        return [
            'name_de' => 'Route-Test Held',
            'kin_code' => (string) $this->db->query('SELECT code FROM catalog_kins ORDER BY code LIMIT 1')
                ->fetchColumn(),
            'profession_code' => $profession,
            'age_code' => 'jung',
            'raw_attributes' => [
                'STA' => 10,
                'KON' => 10,
                'GEW' => 10,
                'INT' => 10,
                'WIL' => 10,
                'CHA' => 10,
            ],
            'learned_skill_ids' => array_map(intval(...), $skills),
            'heroic_ability_choice' => 'robust',
            'flaw_roll' => (int) $this->db->query('SELECT roll_min FROM catalog_flaws ORDER BY roll_min LIMIT 1')
                ->fetchColumn(),
            'gear_option_id' => (int) $gear['id'],
            'rolled_silver' => $gear['starting_silver_dice'] === null ? 0 : 1,
            'memento_de' => 'Ein Andenken',
            'appearance_de' => 'Narbig',
        ];
    }
}
