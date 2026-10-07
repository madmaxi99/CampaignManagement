<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Campaign;

use Flyka\CampaignManagement\Connection;
use Flyka\CampaignManagement\Input;
use InvalidArgumentException;

final readonly class CampaignItemRepository
{
    public function __construct(
        private Connection $db,
        private CampaignLookup $lookup
    ) {
    }

    /**
     * Story items of this campaign (books, quest items) with where they are found.
     *
     * @return list<array<string, mixed>>
     */
    public function items(int $campaignId): array
    {
        $stmt = $this->db->prepare(<<<SQL
            SELECT i.id, i.name_de, i.description_de, i.dm_text_de, i.text_de, i.found_hint_de, i.image_path,
                   i.chapter_id, i.place_id, p.name_de AS place_de
            FROM campaign_items i
            LEFT JOIN campaign_places p ON p.id = i.place_id
            WHERE i.campaign_id = :campaign_id
            ORDER BY i.name_de
            SQL);
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchAll();
    }

    public function itemInCampaign(int $campaignId, int $itemId): bool
    {
        return $this->lookup->rowInCampaign('campaign_items', $campaignId, $itemId);
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    private function validatedItemFields(int $campaignId, array $input): array
    {
        $name = Input::limited($input['name_de'] ?? null, 150, 'Der Name');
        if ($name === null) {
            throw new InvalidArgumentException('Ein Item braucht einen Namen.');
        }

        return [
            'name_de' => $name,
            'description_de' => Input::textOrNull($input['description_de'] ?? null),
            'dm_text_de' => Input::textOrNull($input['dm_text_de'] ?? null),
            'text_de' => Input::textOrNull($input['text_de'] ?? null),
            'found_hint_de' => Input::limited($input['found_hint_de'] ?? null, 255, 'Der Fundort-Hinweis'),
            'chapter_id' => $this->lookup->campaignRef('campaign_chapters', $campaignId, $input['chapter_id'] ?? null, 'Unbekanntes Kapitel.'),
            'place_id' => $this->lookup->campaignRef('campaign_places', $campaignId, $input['place_id'] ?? null, 'Unbekannter Ort.'),
        ];
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function createItem(int $campaignId, array $input): int
    {
        $fields = [
            'campaign_id' => $campaignId,
        ] + $this->validatedItemFields($campaignId, $input);
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaign_items (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function updateItem(int $campaignId, int $itemId, array $input): void
    {
        $fields = $this->validatedItemFields($campaignId, $input);
        $assignments = array_map(fn (string $column): string => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare('UPDATE campaign_items SET ' . implode(', ', $assignments) . ' WHERE id = :id AND campaign_id = :campaign_id');
        $stmt->execute($fields + [
            'id' => $itemId,
            'campaign_id' => $campaignId,
        ]);
    }

    public function deleteItem(int $campaignId, int $itemId): void
    {
        $this->db->prepare('DELETE FROM campaign_items WHERE id = :id AND campaign_id = :campaign_id')
            ->execute([
                'id' => $itemId,
                'campaign_id' => $campaignId,
            ]);
    }

    public function setItemImage(int $itemId, string $path): void
    {
        $this->db->prepare('UPDATE campaign_items SET image_path = :path WHERE id = :id')
            ->execute([
                'path' => $path,
                'id' => $itemId,
            ]);
    }
}
