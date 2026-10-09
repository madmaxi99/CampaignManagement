<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Repository;

use Flyka\CampaignManagement\Database\Connection;

/**
 * Quick search over the data in the database: the pieces of one campaign and
 * the catalog (monsters, items, spells). Rules and lore are text in templates,
 * the browser searches those (see public/js/lookup.js).
 */
final readonly class SearchRepository
{
    private const int PER_TYPE = 8;

    private const int SINGLE_TYPE = 60;

    public function __construct(
        private Connection $db
    ) {
    }

    /**
     * @param string $group "" = all, else campaign | monster | item | spell
     * @return list<array{type: string, label: string, title: string, snippet: string, url: string, entity: ?string, id: int}>
     */
    public function search(string $query, string $group, ?int $campaignId): array
    {
        $query = trim($query);
        if ($query === '' && $group === '') {
            return [];
        }
        $like = '%' . addcslashes($query, '%_\\') . '%';
        $limit = $group === '' ? self::PER_TYPE : self::SINGLE_TYPE;

        $results = [];
        if (($group === '' || $group === 'campaign') && $campaignId !== null) {
            $results = [
                ...$this->campaignRows('npc', 'NSC', 'campaign_npcs', ['description_de', 'dm_text_de', 'notes_de'], 'description_de', $like, $limit, $campaignId),
                ...$this->campaignRows('place', 'Ort', 'campaign_places', ['description_de', 'dm_text_de'], 'description_de', $like, $limit, $campaignId),
                ...$this->campaignRows('item', 'Kampagnen-Item', 'campaign_items', ['description_de', 'dm_text_de'], 'description_de', $like, $limit, $campaignId),
            ];
        }
        if ($group === '' || $group === 'monster') {
            $results = [...$results, ...$this->catalogRows('monster', 'Monster', 'catalog_bestiary', ['category_de', 'traits_de', 'kit_de'], 'kit_de', $like, $limit)];
        }
        if ($group === '' || $group === 'item') {
            $results = [...$results, ...$this->catalogRows('catalog_item', 'Item', 'catalog_items', ['description_de'], 'description_de', $like, $limit)];
        }
        if ($group === '' || $group === 'spell') {
            return [...$results, ...$this->catalogRows('spell', 'Zauber', 'catalog_spells', ['effect_de'], 'effect_de', $like, $limit)];
        }

        return $results;
    }

    /**
     * @param list<string> $searchColumns
     * @return list<array{type: string, label: string, title: string, snippet: string, url: string, entity: ?string, id: int}>
     */
    private function campaignRows(string $type, string $label, string $table, array $searchColumns, string $snippetColumn, string $like, int $limit, int $campaignId): array
    {
        $conditions = implode(' OR ', array_map(fn (string $column): string => "{$column} LIKE :like", ['name_de', ...$searchColumns]));
        $stmt = $this->db->prepare(<<<SQL
            SELECT id, name_de, {$snippetColumn} AS snippet
            FROM {$table}
            WHERE campaign_id = :campaign_id AND ({$conditions})
            ORDER BY name_de
            LIMIT {$limit}
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
            'like' => $like,
        ]);

        return array_map(fn (array $row): array => $this->result($type, $label, $row, "/dm/campaign/{$campaignId}?e={$type}-{$row['id']}", $type), $stmt->fetchAll());
    }

    /**
     * @param list<string> $searchColumns
     * @return list<array{type: string, label: string, title: string, snippet: string, url: string, entity: ?string, id: int}>
     */
    private function catalogRows(string $type, string $label, string $table, array $searchColumns, string $snippetColumn, string $like, int $limit): array
    {
        $conditions = implode(' OR ', array_map(fn (string $column): string => "{$column} LIKE :like", ['name_de', ...$searchColumns]));
        $stmt = $this->db->prepare(<<<SQL
            SELECT id, name_de, {$snippetColumn} AS snippet
            FROM {$table}
            WHERE {$conditions}
            ORDER BY name_de
            LIMIT {$limit}
            SQL);
        $stmt->execute([
            'like' => $like,
        ]);

        return array_map(fn (array $row): array => $this->result($type, $label, $row, match ($type) {
            'monster' => "/dm/catalog/bestiary?e={$row['id']}",
            'catalog_item' => "/dm/catalog/items?e={$row['id']}",
            default => '/rules#spells',
        }, $type === 'monster' ? 'bestiary' : null), $stmt->fetchAll());
    }

    /**
     * @param array<string, mixed> $row
     * @return array{type: string, label: string, title: string, snippet: string, url: string, entity: ?string, id: int}
     */
    private function result(string $type, string $label, array $row, string $url, ?string $entity): array
    {
        $snippet = trim((string) ($row['snippet'] ?? ''));

        return [
            'type' => $type,
            'label' => $label,
            'title' => (string) $row['name_de'],
            'snippet' => mb_strlen($snippet) > 160 ? mb_substr($snippet, 0, 160) . '…' : $snippet,
            'url' => $url,
            'entity' => $entity,
            'id' => (int) $row['id'],
        ];
    }
}
