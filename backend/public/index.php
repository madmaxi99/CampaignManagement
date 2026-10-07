<?php

declare(strict_types=1);

use Flyka\CampaignManagement\Application;

require __DIR__ . '/../vendor/autoload.php';

Application::create(dirname(__DIR__))->run();
