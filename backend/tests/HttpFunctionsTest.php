<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use Slim\Psr7\Response;
use function Flyka\CampaignManagement\Http\jsonResponse;
use function Flyka\CampaignManagement\Http\safeDmTarget;
use function Flyka\CampaignManagement\Http\storeUploadedImage;

final class HttpFunctionsTest extends TestCase
{
    /**
     * @return iterable<string, array{mixed, string}>
     */
    public static function targets(): iterable
    {
        yield 'dm root' => ['/dm', '/dm'];
        yield 'dm subpath' => ['/dm/campaign/3', '/dm/campaign/3'];
        yield 'external url' => ['https://evil.example/dm', '/dm'];
        yield 'protocol relative' => ['//evil.example', '/dm'];
        yield 'other path' => ['/characters', '/dm'];
        yield 'prefix trick' => ['/dmx', '/dm'];
        yield 'query string' => ['/dm?x=1', '/dm'];
        yield 'not a string' => [['/dm'], '/dm'];
        yield 'null' => [null, '/dm'];
    }

    #[DataProvider('targets')]
    public function testSafeDmTarget(mixed $input, string $expected): void
    {
        self::assertSame($expected, safeDmTarget($input));
    }

    public function testJsonResponse(): void
    {
        $response = jsonResponse(new Response(), [
            'ok' => true,
        ], 201);

        self::assertSame(201, $response->getStatusCode());
        self::assertSame('application/json', $response->getHeaderLine('Content-Type'));
        self::assertSame('{"ok":true}', (string) $response->getBody());
    }

    public function testStoreUploadedImageRejectsMissingFile(): void
    {
        self::assertSame([
            'error' => 'Keine gültige Bilddatei übermittelt.',
        ], storeUploadedImage(null, 'images/test', 1));
    }
}
