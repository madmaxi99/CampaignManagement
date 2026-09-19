<?php

declare(strict_types=1);

use Psr\Http\Message\UploadedFileInterface;

final class PlaceImageStorage
{
    private const ALLOWED_MIME_TYPES = [
        'image/png' => 'png',
        'image/jpeg' => 'jpg',
        'image/webp' => 'webp',
    ];

    private const MAX_BYTES = 8 * 1024 * 1024;

    public static function store(?UploadedFileInterface $file): ?string
    {
        if ($file === null || $file->getError() === UPLOAD_ERR_NO_FILE) {
            return null;
        }

        if ($file->getError() !== UPLOAD_ERR_OK) {
            throw new InvalidArgumentException('Der Datei-Upload ist fehlgeschlagen.');
        }

        if ($file->getSize() === null || $file->getSize() > self::MAX_BYTES) {
            throw new InvalidArgumentException('Die Datei ist zu groß (max. 8 MB).');
        }

        $stream = $file->getStream();
        $stream->rewind();
        $contents = $stream->getContents();

        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = (string) finfo_buffer($finfo, $contents);
        finfo_close($finfo);

        if (!array_key_exists($mimeType, self::ALLOWED_MIME_TYPES)) {
            throw new InvalidArgumentException('Nur PNG-, JPEG- oder WebP-Bilder sind erlaubt.');
        }

        $uploadDir = __DIR__ . '/../public/uploads/places';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0775, true);
        }

        $filename = bin2hex(random_bytes(8)) . '.' . self::ALLOWED_MIME_TYPES[$mimeType];
        $file->moveTo($uploadDir . '/' . $filename);

        return $filename;
    }
}
