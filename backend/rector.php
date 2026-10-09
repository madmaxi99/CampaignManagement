<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;

return RectorConfig::configure()
    ->withPaths([__DIR__ . '/src', __DIR__ . '/routes', __DIR__ . '/public/index.php', __DIR__ . '/bin', __DIR__ . '/tests'])
    ->withPhpSets(php83: true)
    ->withPreparedSets(deadCode: true, codeQuality: true, typeDeclarations: true)
    ->withImportNames(removeUnusedImports: true);
