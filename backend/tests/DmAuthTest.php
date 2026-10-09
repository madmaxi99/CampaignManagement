<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\Auth\DmAuth;
use PHPUnit\Framework\TestCase;

final class DmAuthTest extends TestCase
{
    private string $stateDir;

    protected function setUp(): void
    {
        $this->stateDir = sys_get_temp_dir() . '/dm-auth-test-' . bin2hex(random_bytes(4));
        mkdir($this->stateDir);
        $_SESSION = [];
    }

    protected function tearDown(): void
    {
        foreach (glob($this->stateDir . '/*') ?: [] as $file) {
            unlink($file);
        }
        rmdir($this->stateDir);
        $_SESSION = [];
    }

    public function testUnconfiguredNeverLogsIn(): void
    {
        $auth = new DmAuth(null, $this->stateDir);

        self::assertFalse($auth->isConfigured());
        self::assertSame('unconfigured', $auth->attempt('anything', 'client'));
        self::assertFalse($auth->isLoggedIn());
    }

    public function testWrongPasswordIsRejected(): void
    {
        $auth = new DmAuth(password_hash('secret', PASSWORD_DEFAULT), $this->stateDir);

        self::assertSame('wrong', $auth->attempt('nope', 'client'));
        self::assertFalse($auth->isLoggedIn());
    }

    public function testLocksAfterFiveWrongAttempts(): void
    {
        $auth = new DmAuth(password_hash('secret', PASSWORD_DEFAULT), $this->stateDir);

        for ($i = 0; $i < 5; ++$i) {
            self::assertSame('wrong', $auth->attempt('nope', 'client'));
        }

        self::assertSame('locked', $auth->attempt('secret', 'client'));
        self::assertGreaterThan(0, $auth->lockedSeconds('client'));
        self::assertSame(0, $auth->lockedSeconds('other-client'));
    }

    public function testCsrfTokenIsStableAndValidated(): void
    {
        $auth = new DmAuth(null, $this->stateDir);
        $token = $auth->csrfToken();

        self::assertSame($token, $auth->csrfToken());
        self::assertTrue($auth->validCsrf($token));
        self::assertFalse($auth->validCsrf('wrong'));
        self::assertFalse($auth->validCsrf(''));
        self::assertFalse($auth->validCsrf(null));
    }
}
