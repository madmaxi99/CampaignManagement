<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Repository;

use Flyka\CampaignManagement\Database\Connection;
use Flyka\CampaignManagement\Http\Input;
use InvalidArgumentException;
use Throwable;

final readonly class CampaignRepository
{
    public function __construct(
        private Connection $db
    ) {
    }

    /**
     * @return list<array<string, mixed>>
     */
    public function listAll(): array
    {
        $stmt = $this->db->query(<<<SQL
            SELECT c.id, c.name_de, c.teaser_de, c.is_default, c.created_at,
                   (SELECT COUNT(*) FROM campaign_chapters WHERE campaign_id = c.id) AS chapter_count,
                   (SELECT COUNT(*) FROM campaign_places WHERE campaign_id = c.id) AS place_count,
                   (SELECT COUNT(*) FROM campaign_npcs WHERE campaign_id = c.id) AS npc_count,
                   (SELECT COUNT(*) FROM campaign_chronicle WHERE campaign_id = c.id) AS chronicle_count
            FROM campaigns c
            ORDER BY c.name_de
            SQL);

        return $stmt->fetchAll();
    }

    /**
     * @return array<string, mixed>|null
     */
    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM campaigns WHERE id = :id');
        $stmt->execute([
            'id' => $id,
        ]);
        $campaign = $stmt->fetch();

        return $campaign === false ? null : $campaign;
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    private function validatedCampaignFields(array $input): array
    {
        $name = Input::limited($input['name_de'] ?? null, 150, 'Der Name');
        if ($name === null) {
            throw new InvalidArgumentException('Eine Kampagne braucht einen Namen.');
        }

        return [
            'name_de' => $name,
            'teaser_de' => Input::limited($input['teaser_de'] ?? null, 255, 'Der Teaser') ?? '',
            'background_de' => Input::textOrNull($input['background_de'] ?? null) ?? '',
        ];
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function create(array $input): int
    {
        $fields = $this->validatedCampaignFields($input) + [
            'is_default' => 0,
        ];
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaigns (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     * @param array<string, mixed> $input
     */
    public function update(int $campaignId, array $input): void
    {
        $fields = $this->validatedCampaignFields($input);
        $assignments = array_map(fn (string $column): string => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare('UPDATE campaigns SET ' . implode(', ', $assignments) . ' WHERE id = :id');
        $stmt->execute($fields + [
            'id' => $campaignId,
        ]);
    }

    /**
     * Standard adventures cannot be deleted (only restarted).
     */
    public function delete(int $campaignId): bool
    {
        $stmt = $this->db->prepare('DELETE FROM campaigns WHERE id = :id AND is_default = 0');
        $stmt->execute([
            'id' => $campaignId,
        ]);

        return $stmt->rowCount() > 0;
    }

    /**
     * Moves the group to a chapter and/or a place of this campaign. A place also
     * moves the group to the chapter of that place. Optionally the move is noted in the chronicle.
     *
     * @throws InvalidArgumentException when chapter or place do not belong to the campaign
     */
    public function setCurrent(int $campaignId, ?int $chapterId, ?int $placeId, bool $note = false): void
    {
        $place = null;
        if ($placeId !== null) {
            $stmt = $this->db->prepare('SELECT name_de, chapter_id FROM campaign_places WHERE id = :id AND campaign_id = :campaign_id');
            $stmt->execute([
                'id' => $placeId,
                'campaign_id' => $campaignId,
            ]);
            $place = $stmt->fetch();
            if ($place === false) {
                throw new InvalidArgumentException('Unbekannter Ort.');
            }
            $chapterId ??= $place['chapter_id'] === null ? null : (int) $place['chapter_id'];
        }
        if ($chapterId !== null) {
            $stmt = $this->db->prepare('SELECT 1 FROM campaign_chapters WHERE id = :id AND campaign_id = :campaign_id');
            $stmt->execute([
                'id' => $chapterId,
                'campaign_id' => $campaignId,
            ]);
            if ($stmt->fetchColumn() === false) {
                throw new InvalidArgumentException('Unbekanntes Kapitel.');
            }
        }

        $assignments = [];
        $params = [
            'campaign_id' => $campaignId,
        ];
        if ($chapterId !== null) {
            $assignments[] = 'current_chapter_id = :chapter_id';
            $params['chapter_id'] = $chapterId;
        }
        if ($placeId !== null) {
            $assignments[] = 'current_place_id = :place_id';
            $params['place_id'] = $placeId;
        }
        if ($assignments === []) {
            throw new InvalidArgumentException('Kapitel oder Ort fehlt.');
        }
        $this->db->prepare('UPDATE campaigns SET ' . implode(', ', $assignments) . ' WHERE id = :campaign_id')
            ->execute($params);

        if ($note && $place !== null) {
            $this->db->prepare('INSERT INTO campaign_chronicle (campaign_id, text_de) VALUES (:campaign_id, :text_de)')
                ->execute([
                    'campaign_id' => $campaignId,
                    'text_de' => 'Die Gruppe wechselt zu: ' . $place['name_de'] . '.',
                ]);
        }
    }

    /**
     * New group: clears the chronicle, the foes and the play notes of the NPCs. Content and catalog stay.
     */
    public function restart(int $campaignId): void
    {
        $this->db->beginTransaction();
        try {
            foreach ([
                'DELETE FROM campaign_chronicle WHERE campaign_id = :campaign_id',
                'UPDATE campaign_npcs SET notes_de = NULL WHERE campaign_id = :campaign_id',
                'DELETE FROM campaign_foes WHERE campaign_id = :campaign_id',
            ] as $sql) {
                $stmt = $this->db->prepare($sql);
                $stmt->execute([
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
