<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/**
 * Locks everything under /dm (except the login page) by construction: no
 * route can forget the check. Without a DM session: redirect (pages) or 401
 * (JSON/API). With a session, every state-changing request needs the CSRF
 * token (header X-CSRF-Token or form field _csrf).
 */
final readonly class DmGate implements MiddlewareInterface
{
    public function __construct(
        private DmAuth $auth,
        private ResponseFactoryInterface $responses
    ) {
    }

    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $path = '/' . trim($request->getUri()->getPath(), '/');
        $protected = $path === '/dm' || str_starts_with($path, '/dm/');
        if (! $protected || $path === '/dm/login') {
            return $handler->handle($request);
        }

        $safeMethod = in_array($request->getMethod(), ['GET', 'HEAD', 'OPTIONS'], true);

        if (! $this->auth->isLoggedIn()) {
            if ($this->wantsJson($request, $safeMethod)) {
                return $this->json(401, 'Nicht angemeldet.');
            }

            return $this->noStore($this->responses->createResponse(302)
                ->withHeader('Location', '/dm/login?next=' . rawurlencode($path)));
        }

        if (! $safeMethod) {
            $body = $request->getParsedBody();
            $token = $request->getHeaderLine('X-CSRF-Token')
                ?: (is_array($body) ? (string) ($body['_csrf'] ?? '') : '');
            if (! $this->auth->validCsrf($token)) {
                return $this->json(403, 'Ungültiges Sicherheitstoken. Bitte Seite neu laden.');
            }
        }

        return $this->noStore($handler->handle($request));
    }

    private function wantsJson(ServerRequestInterface $request, bool $safeMethod): bool
    {
        return ! $safeMethod
            || str_contains($request->getHeaderLine('Accept'), 'application/json')
            || $request->getHeaderLine('X-Requested-With') !== '';
    }

    private function json(int $status, string $message): ResponseInterface
    {
        $response = $this->responses->createResponse($status)
            ->withHeader('Content-Type', 'application/json');
        $response->getBody()
            ->write(json_encode([
                'error' => $message,
            ], JSON_THROW_ON_ERROR));

        return $this->noStore($response);
    }

    private function noStore(ResponseInterface $response): ResponseInterface
    {
        return $response->withHeader('Cache-Control', 'no-store');
    }
}
