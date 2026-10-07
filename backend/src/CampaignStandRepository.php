<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use InvalidArgumentException;
use PDO;

/**
 * The chronicle of one campaign: everything that happens, free text.
 */
final readonly class CampaignStandRepository
{
    public function __construct(
        private PDO $db
    ) {
    }

    public function chronicle(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, title_de, text_de, created_at FROM campaign_chronicle WHERE campaign_id = :campaign_id ORDER BY created_at DESC, id DESC'
        );
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchAll();
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     */
    public function addChronicleEntry(int $campaignId, array $input): int
    {
        [$title, $text] = $this->validatedChronicle($input);
        $stmt = $this->db->prepare(
            'INSERT INTO campaign_chronicle (campaign_id, title_de, text_de) VALUES (:campaign_id, :title_de, :text_de)'
        );
        $stmt->execute([
            'campaign_id' => $campaignId,
            'title_de' => $title,
            'text_de' => $text,
        ]);

        return (int) $this->db->lastInsertId();
    }

    /**
     * @return bool false when the entry does not exist in this campaign
     * @throws InvalidArgumentException when the input is not valid
     */
    public function updateChronicleEntry(int $campaignId, int $entryId, array $input): bool
    {
        [$title, $text] = $this->validatedChronicle($input);
        if (! $this->entryExists('campaign_chronicle', $campaignId, $entryId)) {
            return false;
        }
        $stmt = $this->db->prepare(
            'UPDATE campaign_chronicle SET title_de = :title_de, text_de = :text_de WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute([
            'title_de' => $title,
            'text_de' => $text,
            'id' => $entryId,
            'campaign_id' => $campaignId,
        ]);

        return true;
    }

    public function deleteChronicleEntry(int $campaignId, int $entryId): bool
    {
        if (! $this->entryExists('campaign_chronicle', $campaignId, $entryId)) {
            return false;
        }
        $stmt = $this->db->prepare('DELETE FROM campaign_chronicle WHERE id = :id AND campaign_id = :campaign_id');
        $stmt->execute([
            'id' => $entryId,
            'campaign_id' => $campaignId,
        ]);

        return true;
    }

    private function entryExists(string $table, int $campaignId, int $id): bool
    {
        // $table is always one of our own constants, never user input.
        $stmt = $this->db->prepare("SELECT 1 FROM {$table} WHERE id = :id AND campaign_id = :campaign_id");
        $stmt->execute([
            'id' => $id,
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchColumn() !== false;
    }

    private function text(mixed $value): ?string
    {
        if (! is_string($value)) {
            return null;
        }
        $value = trim($value);

        return $value === '' ? null : $value;
    }

    /**
     * @return array{0: ?string, 1: string}
     */
    private function validatedChronicle(array $input): array
    {
        $title = $this->text($input['title_de'] ?? null);
        $text = $this->text($input['text_de'] ?? null);
        if ($text === null) {
            throw new InvalidArgumentException('Ein Chronik-Eintrag braucht einen Text.');
        }
        if ($title !== null && mb_strlen($title) > 100) {
            throw new InvalidArgumentException('Die Überschrift darf höchstens 100 Zeichen haben.');
        }

        return [$title, $text];
    }
}
