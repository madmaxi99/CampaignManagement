<?php

declare(strict_types=1);

use Symplify\EasyCodingStandard\Config\ECSConfig;

return ECSConfig::configure()
    ->withPaths([__DIR__ . '/src', __DIR__ . '/routes', __DIR__ . '/public/index.php', __DIR__ . '/bin', __DIR__ . '/tests'])
    ->withPreparedSets(psr12: true, common: true)
    ->withRootFiles();
