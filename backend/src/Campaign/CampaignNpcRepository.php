<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement\Campaign;

use Flyka\CampaignManagement\Input;
use InvalidArgumentException;
use PDO;

final readonly class CampaignNpcRepository
{
    public function __construct(
        private PDO $db,
        private CampaignLookup $lookup,
        private CampaignMonsterRepository $monsters
    ) {
    }

    public function npcs(int $campaignId): array
    {
        $stmt = $this->db->prepare(
            'SELECT n.id, n.name_de, n.description_de, n.dm_text_de, n.notes_de, n.found_hint_de, n.bestiary_id,
                    n.portrait_path, n.chapter_id, n.place_id, p.name_de AS place_de
             FROM campaign_npcs n
             LEFT JOIN campaign_places p ON p.id = n.place_id
             WHERE n.campaign_id = :campaign_id ORDER BY n.name_de'
        );
        $stmt->execute([
            'campaign_id' => $campaignId,
        ]);
        $npcs = $stmt->fetchAll();

        foreach ($npcs as &$npc) {
            $npc['creature'] = $npc['bestiary_id'] !== null ? $this->monsters->bestiaryById((int) $npc['bestiary_id']) : null;
        }

        return $npcs;
    }

    public function npcInCampaign(int $campaignId, int $npcId): bool
    {
        $stmt = $this->db->prepare('SELECT 1 FROM campaign_npcs WHERE campaign_id = :campaign_id AND id = :npc_id');
        $stmt->execute([
            'campaign_id' => $campaignId,
            'npc_id' => $npcId,
        ]);

        return $stmt->fetchColumn() !== false;
    }

    /**
     * @throws InvalidArgumentException when the input is not valid
     */
    public function createNpc(int $campaignId, array $input): int
    {
        $fields = [
            'campaign_id' => $campaignId,
        ] + $this->validatedNpcFields($campaignId, $input);
        $columns = array_keys($fields);
        $stmt = $this->db->prepare(
            'INSERT INTO campaign_npcs (' . implode(', ', $columns) . ') VALUES (:' . implode(', :', $columns) . ')'
        );
        $stmt->execute($fields);

        return (int) $this->db->lastInsertId();
    }

    /**
     * The caller checks that the NPC belongs to the campaign.
     *
     * @throws InvalidArgumentException when the input is not valid
     */
    public function updateNpc(int $campaignId, int $npcId, array $input): void
    {
        $fields = $this->validatedNpcFields($campaignId, $input);
        $assignments = array_map(fn (string $column): string => "{$column} = :{$column}", array_keys($fields));
        $stmt = $this->db->prepare(
            'UPDATE campaign_npcs SET ' . implode(', ', $assignments) . ' WHERE id = :id AND campaign_id = :campaign_id'
        );
        $stmt->execute($fields + [
            'id' => $npcId,
            'campaign_id' => $campaignId,
        ]);
    }

    public function setNpcPortrait(int $npcId, string $path): void
    {
        $stmt = $this->db->prepare('UPDATE campaign_npcs SET portrait_path = :path WHERE id = :id');
        $stmt->execute([
            'path' => $path,
            'id' => $npcId,
        ]);
    }

    private function validatedNpcFields(int $campaignId, array $input): array
    {
        $name = Input::textOrNull($input['name_de'] ?? null);
        if ($name === null) {
            throw new InvalidArgumentException('Ein NPC braucht einen Namen.');
        }
        if (mb_strlen($name) > 150) {
            throw new InvalidArgumentException('Der Name darf höchstens 150 Zeichen haben.');
        }

        $bestiaryId = Input::idOrNull($input['bestiary_id'] ?? null);
        if ($bestiaryId !== null && ! $this->lookup->exists('SELECT 1 FROM catalog_bestiary WHERE id = ?', $bestiaryId)) {
            throw new InvalidArgumentException('Unbekannte Kampfvorlage.');
        }

        return [
            'name_de' => $name,
            'description_de' => Input::textOrNull($input['description_de'] ?? null),
            'dm_text_de' => Input::textOrNull($input['dm_text_de'] ?? null),
            'notes_de' => Input::textOrNull($input['notes_de'] ?? null),
            'found_hint_de' => Input::limited($input['found_hint_de'] ?? null, 255, 'Der Fundort-Hinweis'),
            'chapter_id' => $this->lookup->campaignRef('campaign_chapters', $campaignId, $input['chapter_id'] ?? null, 'Unbekanntes Kapitel.'),
            'place_id' => $this->lookup->campaignRef('campaign_places', $campaignId, $input['place_id'] ?? null, 'Unbekannter Ort.'),
            'bestiary_id' => $bestiaryId,
        ];
    }

    public function deleteNpc(int $campaignId, int $npcId): void
    {
        $this->db->prepare('DELETE FROM campaign_npcs WHERE id = :id AND campaign_id = :campaign_id')
            ->execute([
                'id' => $npcId,
                'campaign_id' => $campaignId,
            ]);
    }

    /**
     * Play notes only ("alive", "liked Aodhan"), used by the play mode.
     */
    public function setNpcNotes(int $campaignId, int $npcId, ?string $notes): void
    {
        $notes = Input::textOrNull($notes);
        $this->db->prepare('UPDATE campaign_npcs SET notes_de = :notes WHERE id = :id AND campaign_id = :campaign_id')
            ->execute([
                'notes' => $notes,
                'id' => $npcId,
                'campaign_id' => $campaignId,
            ]);
    }
}
