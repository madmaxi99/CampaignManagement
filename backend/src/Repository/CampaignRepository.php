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
