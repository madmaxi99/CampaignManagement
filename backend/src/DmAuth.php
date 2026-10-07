<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

/**
 * The single DM password and everything around it: login state in the PHP
 * session, CSRF token, and a brake against password guessing.
 *
 * Without a configured hash nobody can log in, so the DM area stays locked.
 */
final readonly class DmAuth
{
    private const int MAX_ATTEMPTS = 5;

    private const int LOCK_SECONDS = 60;

    public function __construct(
        private ?string $passwordHash,
        private string $stateDir
    ) {
    }

    public function isConfigured(): bool
    {
        return $this->passwordHash !== null && $this->passwordHash !== '';
    }

    public function isLoggedIn(): bool
    {
        return ($_SESSION['dm'] ?? false) === true;
    }

    /**
     * Seconds the client must still wait before the next attempt (0 = may try).
     */
    public function lockedSeconds(string $clientId): int
    {
        $state = $this->readState($clientId);

        return max(0, (int) ($state['until'] ?? 0) - time());
    }

    /**
     * @return 'ok'|'wrong'|'locked'|'unconfigured'
     */
    public function attempt(string $password, string $clientId): string
    {
        if (! $this->isConfigured()) {
            return 'unconfigured';
        }
        if ($this->lockedSeconds($clientId) > 0) {
            return 'locked';
        }

        if (password_verify($password, (string) $this->passwordHash)) {
            $this->writeState($clientId, []);
            session_regenerate_id(true);
            $_SESSION['dm'] = true;

            return 'ok';
        }

        $state = $this->readState($clientId);
        $fails = (int) ($state['fails'] ?? 0) + 1;
        if ($fails >= self::MAX_ATTEMPTS) {
            $this->writeState($clientId, [
                'fails' => 0,
                'until' => time() + self::LOCK_SECONDS,
            ]);
        } else {
            $this->writeState($clientId, [
                'fails' => $fails,
            ]);
        }

        return 'wrong';
    }

    public function logout(): void
    {
        $_SESSION = [];
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_regenerate_id(true);
        }
    }

    public function csrfToken(): string
    {
        $_SESSION['csrf'] ??= bin2hex(random_bytes(32));

        return $_SESSION['csrf'];
    }

    public function validCsrf(?string $token): bool
    {
        return $token !== null && $token !== '' && hash_equals($this->csrfToken(), $token);
    }

    private function stateFile(string $clientId): string
    {
        return rtrim($this->stateDir, '/') . '/dm-login-' . sha1($clientId) . '.json';
    }

    /**
     * @return array<string, mixed>
     */
    private function readState(string $clientId): array
    {
        $file = $this->stateFile($clientId);
        if (! is_file($file)) {
            return [];
        }

        return json_decode((string) file_get_contents($file), true) ?: [];
    }

    /**
     * @param array<string, mixed> $state
     */
    private function writeState(string $clientId, array $state): void
    {
        $file = $this->stateFile($clientId);
        if ($state === []) {
            if (is_file($file)) {
                unlink($file);
            }

            return;
        }
        file_put_contents($file, json_encode($state, JSON_THROW_ON_ERROR), LOCK_EX);
    }
}
