<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\Application;
use Psr\Http\Message\ResponseInterface;
use Slim\App;
use Slim\Psr7\Factory\ServerRequestFactory;
use Slim\Psr7\Factory\StreamFactory;

/**
 * Drives the whole Slim app (middleware, routes, repositories, templates)
 * against the test database, logged in as DM.
 */
final class AppRoutesTest extends DatabaseTestCase
{
    private const string PASSWORD = 'test-password';

    private App $app;

    private int $campaignId = 0;

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
        if ($this->campaignId !== 0) {
            $this->db->exec('DELETE FROM campaigns WHERE id = ' . $this->campaignId);
        }
        $this->db->exec('DELETE FROM campaigns WHERE name_de LIKE \'Route-Test%\'');
        $this->db->exec('DELETE FROM characters WHERE name_de LIKE \'Route-Test%\'');
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_destroy();
        }
        putenv('DM_PASSWORD_HASH');
        restore_error_handler();
    }

    public function testPublicPages(): void
    {
        foreach (['/characters', '/rules', '/lore', '/character/create', '/dm/login'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }

        self::assertSame(302, $this->request('GET', '/')->getStatusCode());
        self::assertSame(404, $this->request('GET', '/character/999999')->getStatusCode());
        self::assertSame('/dm', $this->request('GET', '/campaign')->getHeaderLine('Location'));
        self::assertSame('/dm/campaign/3', $this->request('GET', '/campaign/3')->getHeaderLine('Location'));
        self::assertSame('/dm/catalog', $this->request('GET', '/world')->getHeaderLine('Location'));
        self::assertSame(200, $this->request('GET', '/api/character-creation/catalog')->getStatusCode());
    }

    public function testDmAreaIsLockedWithoutLogin(): void
    {
        $page = $this->request('GET', '/dm');
        self::assertSame(302, $page->getStatusCode());
        self::assertStringStartsWith('/dm/login', $page->getHeaderLine('Location'));

        self::assertSame(401, $this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test',
        ])->getStatusCode());
    }

    public function testWrongPasswordIsRejected(): void
    {
        $this->request('GET', '/dm/login');
        $response = $this->request('POST', '/dm/login', [
            'password' => 'wrong',
            '_csrf' => $_SESSION['csrf'],
        ], form: true);

        self::assertSame(401, $response->getStatusCode());
    }

    public function testDmPagesAndCampaignWorkflow(): void
    {
        $this->loginAsDm();

        foreach (['/dm', '/dm/lore', '/dm/party', '/dm/styleguide', '/dm/catalog/items', '/dm/catalog/bestiary', '/dm/catalog/encounters'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
        }

        // campaign
        $created = $this->json($this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test',
        ]), 201);
        $this->campaignId = (int) $created['id'];
        $base = '/dm/campaign/' . $this->campaignId;
        $this->ok($this->request('POST', $base, [
            'name_de' => 'Route-Test 2',
            'teaser_de' => 'x',
        ]));

        // chapters
        $chapter = (int) $this->json($this->request('POST', $base . '/chapters', [
            'title_de' => 'Kapitel',
        ]), 201)['id'];
        $second = (int) $this->json($this->request('POST', $base . '/chapters', [
            'title_de' => 'Kapitel 2',
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/chapters/' . $chapter, [
            'title_de' => 'Kapitel neu',
        ]));
        $this->ok($this->request('POST', $base . '/chapters/' . $second . '/move', [
            'direction' => 'up',
        ]));

        // places
        $place = (int) $this->json($this->request('POST', $base . '/places', [
            'name_de' => 'Turm',
            'chapter_id' => $chapter,
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/places/' . $place, [
            'name_de' => 'Turm neu',
            'number_label' => '1',
            'chapter_id' => $chapter,
        ]));

        // npcs, items
        $npc = (int) $this->json($this->request('POST', $base . '/npcs', [
            'name_de' => 'Alberta',
            'place_id' => $place,
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/npcs/' . $npc, [
            'name_de' => 'Alberta II',
        ]));
        $this->ok($this->request('POST', $base . '/npcs/' . $npc . '/notes', [
            'notes_de' => 'lebt',
        ]));
        $item = (int) $this->json($this->request('POST', $base . '/items', [
            'name_de' => 'Buch',
            'place_id' => $place,
        ]), 201)['id'];
        $this->ok($this->request('POST', $base . '/items/' . $item, [
            'name_de' => 'Altes Buch',
        ]));

        // monsters
        $creature = (int) $this->db->query('SELECT id FROM catalog_bestiary ORDER BY id LIMIT 1')
            ->fetchColumn();
        if ($creature !== 0) {
            $this->ok($this->request('POST', $base . '/monsters', [
                'bestiary_id' => $creature,
            ]));
            $this->ok($this->request('POST', $base . '/monsters/' . $creature . '/notes', [
                'notes_de' => 'viele',
            ]));
        }

        // plan and play pages render with all that data
        foreach ([$base, $base . '?mode=play'] as $path) {
            $response = $this->request('GET', $path);
            self::assertSame(200, $response->getStatusCode(), $path);
            $this->assertCleanBody($response, $path);
            self::assertStringContainsString('Alberta II', (string) $response->getBody());
        }

        // validation errors become 422
        self::assertSame(422, $this->request('POST', $base . '/npcs', [
            'name_de' => '',
        ])->getStatusCode());
        self::assertSame(404, $this->request('POST', $base . '/npcs/999999', [
            'name_de' => 'X',
        ])->getStatusCode());
        self::assertSame(404, $this->request('GET', '/dm/campaign/999999')->getStatusCode());

        // restart, then deletes
        $this->ok($this->request('POST', $base . '/restart', []));
        if ($creature !== 0) {
            $this->ok($this->request('DELETE', $base . '/monsters/' . $creature));
        }
        $this->ok($this->request('DELETE', $base . '/items/' . $item));
        $this->ok($this->request('DELETE', $base . '/npcs/' . $npc));
        $this->ok($this->request('DELETE', $base . '/places/' . $place));
        $this->ok($this->request('DELETE', $base . '/chapters/' . $chapter));
        $this->ok($this->request('DELETE', $base));
        self::assertSame(404, $this->request('GET', $base)->getStatusCode());
        $this->campaignId = 0;
    }

    public function testDmWriteWithoutCsrfTokenIsRejected(): void
    {
        $this->loginAsDm();

        $response = $this->request('POST', '/dm/campaigns', [
            'name_de' => 'Route-Test',
        ], csrf: false);

        self::assertSame(403, $response->getStatusCode());
    }

    private function loginAsDm(): void
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
    private function request(string $method, string $uri, ?array $data = null, bool $form = false, bool $csrf = true): ResponseInterface
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

    private function ok(ResponseInterface $response): void
    {
        self::assertContains($response->getStatusCode(), [200, 201], (string) $response->getBody());
    }

    /**
     * @return array<string, mixed>
     */
    private function json(ResponseInterface $response, int $status): array
    {
        self::assertSame($status, $response->getStatusCode(), (string) $response->getBody());

        return json_decode((string) $response->getBody(), true, flags: JSON_THROW_ON_ERROR);
    }

    private function assertCleanBody(ResponseInterface $response, string $path): void
    {
        $body = (string) $response->getBody();
        self::assertDoesNotMatchRegularExpression('/(Warning|Notice|Deprecated|Fatal error):/', $body, $path);
    }
}
