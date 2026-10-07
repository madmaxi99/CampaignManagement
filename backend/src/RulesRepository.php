<?php

declare(strict_types=1);

namespace Flyka\CampaignManagement;

use PDO;

/**
 * Read-only rules reference for players (/rules): the ruleset part of the
 * catalog. Deliberately without bestiary and encounter tables (DM only).
 */
final readonly class RulesRepository
{
    public function __construct(
        private PDO $db
    ) {
    }

    /**
     * Weapons, armor and misc items, each with its rule values.
     */
    public function items(): array
    {
        $rows = $this->db->query(<<<SQL
            SELECT i.id, i.name_de, i.description_de, i.rarity, i.kind,
                   i.price_gold, i.price_silver, i.price_copper,
                   w.grip_de, w.str_requirement, w.range_de, w.damage_de, w.durability, w.traits_de,
                   a.slot AS armor_slot, a.armor_value,
                   a.penalty_stealth, a.penalty_evasion, a.penalty_acrobatics, a.penalty_perception, a.penalty_ranged
            FROM catalog_items i
            LEFT JOIN catalog_item_weapons w ON w.item_id = i.id
            LEFT JOIN catalog_item_armor a ON a.item_id = i.id
            ORDER BY i.name_de
            SQL)->fetchAll();

        $groups = [
            'weapon' => [],
            'armor' => [],
            'misc' => [],
        ];
        foreach ($rows as $row) {
            $row['price_de'] = $this->price($row);
            $row['armor_penalties'] = $this->armorPenalties($row);
            $groups[$row['kind']][] = $row;
        }

        return $groups;
    }

    /**
     * Skills grouped by category.
     */
    public function skills(): array
    {
        $rows = $this->db->query(<<<SQL
            SELECT s.name_de, s.attribute_code, s.category, s.description_de
            FROM catalog_skills s
            ORDER BY s.name_de
            SQL)->fetchAll();

        $groups = [
            'regular' => [],
            'combat' => [],
            'secondary' => [],
        ];
        foreach ($rows as $row) {
            $groups[$row['category']][] = $row;
        }

        return $groups;
    }

    /**
     * Spells and tricks grouped by school.
     */
    public function spellsBySchool(): array
    {
        $rows = $this->db->query(<<<SQL
            SELECT sc.name_de AS school_de, sc.lore_de, s.name_de, s.type, s.rank, s.components_de,
                   ct.name_de AS casting_time_de, s.range_de, sd.name_de AS duration_de,
                   s.wp_note_de, s.effect_de
            FROM catalog_spells s
            JOIN catalog_schools sc ON sc.id = s.school_id
            LEFT JOIN catalog_casting_times ct ON ct.code = s.casting_time_code
            LEFT JOIN catalog_spell_durations sd ON sd.code = s.duration_code
            ORDER BY sc.display_order, sc.name_de, s.type DESC, s.rank, s.name_de
            SQL)->fetchAll();

        $schools = [];
        foreach ($rows as $row) {
            $schools[$row['school_de']]['lore_de'] = $row['lore_de'];
            $schools[$row['school_de']]['spells'][] = $row;
        }

        return $schools;
    }

    public function professions(): array
    {
        $professions = $this->db->query(<<<SQL
            SELECT p.code, p.name_de, a.name_de AS key_attribute_de, k.name_de AS kin_restriction_de, p.grants_magic
            FROM catalog_professions p
            JOIN catalog_attributes a ON a.code = p.key_attribute_code
            LEFT JOIN catalog_kins k ON k.code = p.kin_restriction
            ORDER BY p.name_de
            SQL)->fetchAll();

        $skillStmt = $this->db->prepare(<<<SQL
            SELECT s.name_de FROM catalog_profession_key_skills ks
            JOIN catalog_skills s ON s.id = ks.skill_id
            WHERE ks.profession_code = :code ORDER BY s.name_de
            SQL);
        $abilityStmt = $this->db->prepare(<<<SQL
            SELECT h.name_de, h.description_de FROM catalog_profession_heroic_abilities ph
            JOIN catalog_heroic_abilities h ON h.id = ph.heroic_ability_id
            WHERE ph.profession_code = :code ORDER BY h.name_de
            SQL);

        foreach ($professions as &$profession) {
            $skillStmt->execute([
                'code' => $profession['code'],
            ]);
            $profession['skills'] = $skillStmt->fetchAll(PDO::FETCH_COLUMN);
            $abilityStmt->execute([
                'code' => $profession['code'],
            ]);
            $profession['abilities'] = $abilityStmt->fetchAll();
        }

        return $professions;
    }

    public function kins(): array
    {
        $kins = $this->db->query(
            'SELECT code, name_de, d12_min, d12_max, movement_base FROM catalog_kins ORDER BY d12_min'
        )->fetchAll();

        $stmt = $this->db->prepare(<<<SQL
            SELECT h.name_de, h.description_de FROM catalog_kin_heroic_abilities kh
            JOIN catalog_heroic_abilities h ON h.id = kh.heroic_ability_id
            WHERE kh.kin_code = :code ORDER BY h.name_de
            SQL);
        foreach ($kins as &$kin) {
            $stmt->execute([
                'code' => $kin['code'],
            ]);
            $kin['abilities'] = $stmt->fetchAll();
        }

        return $kins;
    }

    public function heroicAbilities(): array
    {
        return $this->db->query(
            'SELECT name_de, requirement_de, wp_note_de, description_de, repeatable FROM catalog_heroic_abilities ORDER BY name_de'
        )->fetchAll();
    }

    /**
     * Roll tables and short rules: wounds, mishaps, fear, rest, hazards.
     */
    public function tables(): array
    {
        $query = fn (string $sql) => $this->db->query($sql)
            ->fetchAll();

        return [
            'injuries' => $query('SELECT roll_min, roll_max, name_de, effect_de, healing_de FROM catalog_injuries ORDER BY roll_min'),
            'combat_mishaps_melee' => $query("SELECT roll, effect_de FROM catalog_combat_mishaps WHERE context = 'melee' ORDER BY roll"),
            'combat_mishaps_ranged' => $query("SELECT roll, effect_de FROM catalog_combat_mishaps WHERE context = 'ranged' ORDER BY roll"),
            'magical_mishaps' => $query('SELECT roll, effect_de FROM catalog_magical_mishaps ORDER BY roll'),
            'fear_events' => $query('SELECT roll, name_de, effect_de FROM catalog_fear_events ORDER BY roll'),
            'rest_types' => $query('SELECT name_de, duration_de, effect_de FROM catalog_rest_types ORDER BY name_de'),
            'hazards' => $query('SELECT name_de, description_de FROM catalog_hazards ORDER BY name_de'),
        ];
    }

    private function price(array $row): string
    {
        $parts = [];
        foreach ([
            'gold' => 'Gold',
            'silver' => 'Silber',
            'copper' => 'Kupfer',
        ] as $key => $label) {
            if ((int) $row['price_' . $key] > 0) {
                $parts[] = $row['price_' . $key] . ' ' . $label;
            }
        }

        return $parts === [] ? '–' : implode(', ', $parts);
    }

    private function armorPenalties(array $row): array
    {
        $labels = [
            'penalty_stealth' => 'Heimlichkeit',
            'penalty_evasion' => 'Ausweichen',
            'penalty_acrobatics' => 'Akrobatik',
            'penalty_perception' => 'Wahrnehmung',
            'penalty_ranged' => 'Fernkampf',
        ];

        return array_values(array_filter($labels, fn (string $key): bool => ! empty($row[$key]), ARRAY_FILTER_USE_KEY));
    }
}
