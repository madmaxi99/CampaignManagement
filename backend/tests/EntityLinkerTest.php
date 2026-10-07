<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Tests;

use Flyka\CampaignManagement\EntityLinker;
use PHPUnit\Framework\TestCase;

final class EntityLinkerTest extends TestCase
{
    public function testLinksEntityAndEscapesHtml(): void
    {
        $result = EntityLinker::linkify('<b>Alberta</b> kommt', [
            [
                'match' => 'Alberta',
                'type' => 'npc',
                'id' => 7,
            ],
        ]);

        self::assertSame(
            '&lt;b&gt;<a href="#" class="entity-link" data-entity-type="npc" data-entity-id="7">Alberta</a>&lt;/b&gt; kommt',
            $result
        );
    }

    public function testLocationsGetScrollAnchor(): void
    {
        $result = EntityLinker::linkify('Im Turm', [
            [
                'match' => 'Turm',
                'type' => 'location',
                'id' => 3,
            ],
        ]);

        self::assertSame('Im <a href="#location-3" class="location-ref">Turm</a>', $result);
    }

    public function testLongestMatchWinsAndWordsAreNotSplit(): void
    {
        $registry = [
            [
                'match' => 'Rat',
                'type' => 'npc',
                'id' => 1,
            ],
            [
                'match' => 'Rat der Stadt',
                'type' => 'npc',
                'id' => 2,
            ],
        ];

        $result = EntityLinker::linkify('Der Rat der Stadt und Ratten', $registry);

        self::assertStringContainsString('data-entity-id="2">Rat der Stadt</a>', $result);
        self::assertStringNotContainsString('>Ratten<', $result);
        self::assertStringContainsString(' und Ratten', $result);
    }
}
