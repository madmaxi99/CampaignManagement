<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Campaign;

use Flyka\CampaignManagement\Connection;
use Flyka\CampaignManagement\Input;
use InvalidArgumentException;
use PDO;
use Throwable;

final readonly class CampaignChapterRepository
{
    public function __construct(
        private Connection $db,
        private CampaignLookup $lookup
    ) {
    }

    /**
     * @return list<array<string, mixed>>
     */
    public function chapters(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, label, position, title_de, notes_de FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position'
        );
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);

        return $stmt->fetchAll();
    }

    public function chapterInCampaign(int $campaignId, int $chapterId): bool
    {
        return $this->lookup->rowInCampaign('campaign_chapters', $campaignId, $chapterId);
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    private function validatedChapterFields(array $input): array
    {
        $title = Input::limited($input['title_de'] ?? null, 150, 'Der Titel');
        if ($title === null) {
            throw new InvalidArgumentException('Ein Kapitel braucht einen Titel.');
        }

        return [
            'title_de' => $title,
            'notes_de' => Input::textOrNull($input['notes_de'] ?? null),
        ];
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function createChapter(int $campaignId, array $input): int
    {
        $fields = $this->validatedChapterFields($input);
        $stmt = $this->db->prepare(<<<SQL
            INSERT INTO campaign_chapters (campaign_id, label, position, title_de, notes_de)
            SELECT :campaign_id, '0', COALESCE(MAX(position), 0) + 10, :title_de, :notes_de
            FROM campaign_chapters WHERE campaign_id = :campaign_id2
            SQL);
        $stmt->execute($fields + [
            'campaign_id' => $campaignId,
            'campaign_id2' => $campaignId,
        ]);
        $id = (int) $this->db->lastInsertId();
        $this->renumberChapters($campaignId);

        return $id;
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function updateChapter(int $campaignId, int $chapterId, array $input): void
    {
        $fields = $this->validatedChapterFields($input);
        $stmt = $this->db->prepare(
            'UPDATE campaign_chapters SET title_de = :title_de, notes_de = :notes_de WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute($fields + [
            'id' => $chapterId,
            'campaign_id' => $campaignId,
        ]);
    }

    /**
     * Places, NPCs and items of the chapter stay (they lose the chapter).
     */
    public function deleteChapter(int $campaignId, int $chapterId): void
    {
        $stmt = $this->db->prepare('DELETE FROM campaign_chapters WHERE id = :id AND campaign_id = :campaign_id');
        $stmt->execute([
            'id' => $chapterId,
            'campaign_id' => $campaignId,
        ]);
        $this->renumberChapters($campaignId);
    }

    /**
     * @param 'up'|'down' $direction
     */
    public function moveChapter(int $campaignId, int $chapterId, string $direction): void
    {
        $stmt = $this->db->prepare('SELECT id FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position, id');
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);
        $ids = array_map(intval(...), $stmt->fetchAll(PDO::FETCH_COLUMN));

        $index = array_search($chapterId, $ids, true);
        if ($index === false) {
            return;
        }
        $target = $direction === 'up' ? $index - 1 : $index + 1;
        if ($target < 0 || $target >= count($ids)) {
            return;
        }
        [$ids[$index], $ids[$target]] = [$ids[$target], $ids[$index]];
        $this->renumberChapters($campaignId, $ids);
    }

    /**
     * Positions 10, 20, ... and labels "1", "2", ... in the given (or current) order.
     *
     * @param array<int>|null $orderedIds
     */
    private function renumberChapters(int $campaignId, ?array $orderedIds = null): void
    {
        if ($orderedIds === null) {
            $stmt = $this->db->prepare('SELECT id FROM campaign_chapters WHERE campaign_id = :campaign_id ORDER BY position, id');
            $stmt->execute([
                'campaign_id' => $campaignId,
            ]);
            $orderedIds = array_map(intval(...), $stmt->fetchAll(PDO::FETCH_COLUMN));
        }

        $this->db->beginTransaction();
        try {
            // (campaign_id, position) is unique: move everything out of the way first.
            $this->db->prepare('UPDATE campaign_chapters SET position = position + 100000 WHERE campaign_id = :campaign_id')
                ->execute([
                    'campaign_id' => $campaignId,
                ]);
            $stmt = $this->db->prepare('UPDATE campaign_chapters SET position = :position, label = :label WHERE id = :id AND campaign_id = :campaign_id');
            foreach ($orderedIds as $index => $id) {
                $stmt->execute([
                    'position' => ($index + 1) * 10,
                    'label' => (string) ($index + 1),
                    'id' => $id,
                    'campaign_id' => $campaignId,
                ]);
            }
            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }
    }
}
