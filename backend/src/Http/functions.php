<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Http;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\UploadedFileInterface;

/**
 * Absolute path inside the web root (backend/public).
 */
function publicPath(string $relative = ''): string
{
    return dirname(__DIR__, 2) . '/public' . ($relative === '' ? '' : '/' . $relative);
}

/**
 * Login redirect target: only paths inside /dm, never an external URL.
 */
function safeDmTarget(mixed $next): string
{
    if (is_string($next) && preg_match('#^/dm(/[A-Za-z0-9_\-./]*)?$#', $next) === 1) {
        return $next;
    }

    return '/dm';
}

/**
 * @param array<string, mixed> $data
 */
function jsonResponse(Response $response, array $data, int $status = 200): Response
{
    $response->getBody()
        ->write(json_encode($data, JSON_THROW_ON_ERROR));

    return $response->withHeader('Content-Type', 'application/json')
        ->withStatus($status);
}

/**
 * Stores an uploaded JPG/PNG/WebP as public/<dir>/<id>.<ext>, replacing a
 * previous file of the same id with another extension.
 *
 * @return array{path: string}|array{error: string}
 */
function storeUploadedImage(?UploadedFileInterface $file, string $dir, int $id): array
{
    if (! $file instanceof UploadedFileInterface || $file->getError() !== UPLOAD_ERR_OK) {
        return [
            'error' => 'Keine gültige Bilddatei übermittelt.',
        ];
    }
    if ($file->getSize() > 5 * 1024 * 1024) {
        return [
            'error' => 'Datei ist zu groß (max. 5 MB).',
        ];
    }

    $extensions = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/webp' => 'webp',
    ];
    $extension = $extensions[$file->getClientMediaType()] ?? null;
    if ($extension === null) {
        return [
            'error' => 'Nur JPG, PNG oder WebP erlaubt.',
        ];
    }

    $targetDir = publicPath($dir);
    if (! is_dir($targetDir)) {
        mkdir($targetDir, 0755, true);
    }
    $targetPath = $targetDir . '/' . $id . '.' . $extension;
    $file->moveTo($targetPath);

    if (getimagesize($targetPath) === false) {
        unlink($targetPath);

        return [
            'error' => 'Datei ist kein gültiges Bild.',
        ];
    }

    foreach (array_diff($extensions, [$extension]) as $otherExtension) {
        $old = $targetDir . '/' . $id . '.' . $otherExtension;
        if (is_file($old)) {
            unlink($old);
        }
    }

    return [
        'path' => $dir . '/' . $id . '.' . $extension,
    ];
}
