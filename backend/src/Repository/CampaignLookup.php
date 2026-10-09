<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Repository;

use Flyka\CampaignManagement\Database\Connection;
use Flyka\CampaignManagement\Http\Input;
use InvalidArgumentException;

/**
 * Existence and ownership checks shared by the campaign repositories.
 */
final readonly class CampaignLookup
{
    public function __construct(
        private Connection $db
    ) {
    }

    public function exists(string $sql, string|int $param): bool
    {
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$param]);

        return $stmt->fetchColumn() !== false;
    }

    /**
     * Id of a row of this campaign (chapter, place), or null for "none".
     *
     * @param 'campaign_chapters'|'campaign_places' $table
     * @throws InvalidArgumentException when the id is not part of the campaign
     */
    public function campaignRef(string $table, int $campaignId, mixed $value, string $message): ?int
    {
        $id = Input::idOrNull($value);
        if ($id === null) {
            return null;
        }
        if (! $this->rowInCampaign($table, $campaignId, $id)) {
            throw new InvalidArgumentException($message);
        }

        return $id;
    }

    /**
     * @param 'campaign_chapters'|'campaign_places'|'campaign_items'|'campaign_npcs' $table
     */
    public function rowInCampaign(string $table, int $campaignId, int $id): bool
    {
        $stmt = $this->db->prepare("SELECT 1 FROM {$table} WHERE id = :id AND campaign_id = :campaign_id");
        $stmt->execute([
            'id' => $id,
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchColumn() !== false;
    }
}
