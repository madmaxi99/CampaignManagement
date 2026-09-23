<?php

declare(strict_types=1);

final class ProfessionRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS professions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                description TEXT,
                key_attribute TEXT NOT NULL CHECK (key_attribute IN ('STR', 'CON', 'AGL', 'INT', 'WIL', 'CHA'))
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS profession_core_skills (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                profession_id INTEGER NOT NULL,
                skill_id INTEGER NOT NULL,
                magic_school_id INTEGER,
                UNIQUE (profession_id, skill_id, magic_school_id),
                FOREIGN KEY (profession_id) REFERENCES professions(id),
                FOREIGN KEY (skill_id) REFERENCES skills(id),
                FOREIGN KEY (magic_school_id) REFERENCES magic_schools(id)
            )
            SQL);

        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS profession_starting_heroic_abilities (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                profession_id INTEGER NOT NULL,
                heroic_ability_id INTEGER NOT NULL,
                UNIQUE (profession_id, heroic_ability_id),
                FOREIGN KEY (profession_id) REFERENCES professions(id),
                FOREIGN KEY (heroic_ability_id) REFERENCES heroic_abilities(id)
            )
            SQL);
    }

    public function all(): array
    {
        return $this->db->query('SELECT * FROM professions ORDER BY name')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM professions WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $profession = $stmt->fetch(PDO::FETCH_ASSOC);

        return $profession === false ? null : $profession;
    }

    /**
     * All core-skill rows for every profession, joined with the skill name and (if scoped
     * to a magic tradition) the magic school name. `magic_school_id`/`magic_school_name`
     * are null for skills that apply regardless of tradition (every non-Mage profession,
     * plus a Mage's tradition-independent skills).
     */
    public function coreSkillsByProfession(): array
    {
        $rows = $this->db->query(<<<SQL
            SELECT pcs.profession_id, pcs.magic_school_id, s.id AS skill_id, s.name AS skill_name,
                   s.governing_attribute, ms.name AS magic_school_name
            FROM profession_core_skills pcs
            JOIN skills s ON s.id = pcs.skill_id
            LEFT JOIN magic_schools ms ON ms.id = pcs.magic_school_id
            ORDER BY pcs.profession_id, ms.name, s.name
            SQL)->fetchAll(PDO::FETCH_ASSOC);

        $byProfession = [];
        foreach ($rows as $row) {
            $byProfession[(int) $row['profession_id']][] = $row;
        }

        return $byProfession;
    }

    /**
     * Starting Heroic Ability pool per profession (empty for Mage — a Mage gets spells
     * instead, see SpellRepository/character_spells).
     */
    public function startingHeroicAbilitiesByProfession(): array
    {
        $rows = $this->db->query(<<<SQL
            SELECT psha.profession_id, ha.id AS heroic_ability_id, ha.name
            FROM profession_starting_heroic_abilities psha
            JOIN heroic_abilities ha ON ha.id = psha.heroic_ability_id
            ORDER BY psha.profession_id, ha.name
            SQL)->fetchAll(PDO::FETCH_ASSOC);

        $byProfession = [];
        foreach ($rows as $row) {
            $byProfession[(int) $row['profession_id']][] = $row;
        }

        return $byProfession;
    }
}
