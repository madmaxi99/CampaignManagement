<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Service;

/**
 * Prices as text in Dukaten, Kronen and Heller (the columns keep their old names price_gold/silver/copper).
 */
final class Price
{
    /**
     * @param array<string, mixed> $row a row with price_gold, price_silver and price_copper
     */
    public static function format(array $row): string
    {
        $parts = [];
        foreach ([
            'gold' => ['Dukat', 'Dukaten'],
            'silver' => ['Krone', 'Kronen'],
            'copper' => ['Heller', 'Heller'],
        ] as $key => [$one, $many]) {
            $amount = (int) $row['price_' . $key];
            if ($amount > 0) {
                $parts[] = $amount . ' ' . ($amount === 1 ? $one : $many);
            }
        }

        return $parts === [] ? '–' : implode(', ', $parts);
    }
}
