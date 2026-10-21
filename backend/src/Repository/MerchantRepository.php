<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Repository;

use Flyka\CampaignManagement\Database\Connection;
use Flyka\CampaignManagement\Service\Price;

/**
 * What the DM needs at a shop: the quirks of the shopkeeper and the price lists
 * (every item and service with name, price and effect), nothing hidden and nothing rolled.
 */
final readonly class MerchantRepository
{
    private const array KIND_LABELS = [
        'weapon' => 'Waffen',
        'armor' => 'Rüstungen',
        'misc' => 'Sonstiges',
    ];

    public function __construct(
        private Connection $db
    ) {
    }

    /**
     * @return list<array{roll: int, text_de: string}>
     */
    public function quirks(): array
    {
        $rows = $this->db->query('SELECT roll, text_de FROM catalog_merchant_quirks ORDER BY roll')
            ->fetchAll();

        return array_map(static fn (array $row): array => [
            'roll' => (int) $row['roll'],
            'text_de' => (string) $row['text_de'],
        ], $rows);
    }

    /**
     * Items by kind and the services, each list cheapest first.
     *
     * @return list<array{key: string, label: string, rows: list<array{name: string, price: string, effect: string}>}>
     */
    public function priceLists(): array
    {
        $items = $this->db->query(<<<SQL
            SELECT i.name_de, i.description_de, i.kind, i.price_gold, i.price_silver, i.price_copper,
                   w.grip_de, w.damage_de, w.range_de, w.traits_de,
                   a.armor_value
            FROM catalog_items i
            LEFT JOIN catalog_item_weapons w ON w.item_id = i.id
            LEFT JOIN catalog_item_armor a ON a.item_id = i.id
            ORDER BY i.price_gold * 100 + i.price_silver * 10 + i.price_copper, i.name_de
            SQL)->fetchAll();

        $rowsByKind = array_fill_keys(array_keys(self::KIND_LABELS), []);
        foreach ($items as $item) {
            $rowsByKind[$item['kind']][] = [
                'name' => (string) $item['name_de'],
                'price' => Price::format($item),
                'effect' => $this->itemEffect($item),
            ];
        }

        $lists = [];
        foreach (self::KIND_LABELS as $kind => $label) {
            $lists[] = [
                'key' => $kind,
                'label' => $label,
                'rows' => $rowsByKind[$kind],
            ];
        }

        $services = $this->db->query(<<<SQL
            SELECT name_de, effect_de, unit_de, price_gold, price_silver, price_copper
            FROM catalog_services
            ORDER BY price_gold * 100 + price_silver * 10 + price_copper, name_de
            SQL)->fetchAll();
        $lists[] = [
            'key' => 'services',
            'label' => 'Dienste',
            'rows' => array_map(static fn (array $service): array => [
                'name' => (string) $service['name_de'],
                'price' => Price::format($service) . ($service['unit_de'] !== null ? ' ' . $service['unit_de'] : ''),
                'effect' => (string) $service['effect_de'],
            ], $services),
        ];

        return array_values(array_filter($lists, static fn (array $list): bool => $list['rows'] !== []));
    }

    /**
     * Weapon and armor values in front of the description, so the list shows what the item does.
     *
     * @param array<string, mixed> $item
     */
    private function itemEffect(array $item): string
    {
        $stats = [];
        if ($item['damage_de'] !== null) {
            $stats[] = 'Schaden ' . $item['damage_de'];
            $stats[] = 'Griff ' . $item['grip_de'];
            $stats[] = 'Reichweite ' . $item['range_de'];
            if ($item['traits_de'] !== null && $item['traits_de'] !== '') {
                $stats[] = (string) $item['traits_de'];
            }
        }
        if ($item['armor_value'] !== null) {
            $stats[] = 'Rüstung ' . $item['armor_value'];
        }

        return trim(implode(', ', $stats) . ($stats !== [] && $item['description_de'] !== '' ? '. ' : '') . $item['description_de']);
    }
}
