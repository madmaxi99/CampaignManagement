SET NAMES utf8mb4;

-- Second refinement pass on the catalog_* schema (run once against the
-- existing, populated dev DB after migrate_catalog_prefix.sql). Covers:
--   A) catalog_heroic_abilities: drop scope/kin_code/profession_code/
--      granted_at_creation/choice_group, add `repeatable`; move ownership
--      into two new junction tables (catalog_kin_heroic_abilities /
--      catalog_profession_heroic_abilities), deduplicating abilities shared
--      by more than one profession (e.g. "Veteran").
--   B) Drop catalog_item_misc (no extra columns over catalog_items.kind='misc').
--   C) catalog_items: price_copper (flattened) -> price_gold/price_silver/price_copper.
--   D) catalog_schools: own `id` PK (skill_id becomes a plain FK column);
--      catalog_spells.school_skill_id -> school_id referencing catalog_schools(id).

-- ============================================================
-- A) Heroic abilities: deduplicate + split ownership into junction tables
-- ============================================================

CREATE TABLE catalog_heroic_abilities_new (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL UNIQUE,
    requirement_de VARCHAR(100) NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    repeatable BOOLEAN NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- name_de is unique per ability in the source data (the only repeats --
-- "Veteran", "Furchtlos" -- have identical text across their two
-- professions), so grouping by name_de and taking MAX() is safe.
INSERT INTO catalog_heroic_abilities_new (name_de, requirement_de, wp_note_de, description_de, repeatable)
SELECT name_de, MAX(requirement_de), MAX(wp_note_de), MAX(description_de),
       name_de IN ('Robust', 'Fokussiert')
FROM catalog_heroic_abilities
GROUP BY name_de;

CREATE TABLE catalog_kin_heroic_abilities (
    kin_code VARCHAR(20) NOT NULL,
    heroic_ability_id INT NOT NULL,
    PRIMARY KEY (kin_code, heroic_ability_id),
    FOREIGN KEY (kin_code) REFERENCES catalog_kins(code),
    FOREIGN KEY (heroic_ability_id) REFERENCES catalog_heroic_abilities_new(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_kin_heroic_abilities (kin_code, heroic_ability_id)
SELECT DISTINCT cha.kin_code, new_cha.id
FROM catalog_heroic_abilities cha
JOIN catalog_heroic_abilities_new new_cha ON new_cha.name_de = cha.name_de
WHERE cha.scope = 'kin';

CREATE TABLE catalog_profession_heroic_abilities (
    profession_code VARCHAR(30) NOT NULL,
    heroic_ability_id INT NOT NULL,
    granted_at_creation BOOLEAN NOT NULL DEFAULT 1,
    choice_group VARCHAR(50) NULL,
    PRIMARY KEY (profession_code, heroic_ability_id),
    FOREIGN KEY (profession_code) REFERENCES catalog_professions(code),
    FOREIGN KEY (heroic_ability_id) REFERENCES catalog_heroic_abilities_new(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_profession_heroic_abilities (profession_code, heroic_ability_id, granted_at_creation, choice_group)
SELECT cha.profession_code, new_cha.id, cha.granted_at_creation, cha.choice_group
FROM catalog_heroic_abilities cha
JOIN catalog_heroic_abilities_new new_cha ON new_cha.name_de = cha.name_de
WHERE cha.scope = 'profession';

-- Verification: row counts before swapping the tables in.
SELECT
  (SELECT COUNT(*) FROM catalog_heroic_abilities_new) AS new_unique_abilities,
  (SELECT COUNT(DISTINCT name_de) FROM catalog_heroic_abilities) AS source_unique_names,
  (SELECT COUNT(*) FROM catalog_kin_heroic_abilities) AS new_kin_links,
  (SELECT COUNT(*) FROM catalog_heroic_abilities WHERE scope = 'kin') AS source_kin_rows,
  (SELECT COUNT(*) FROM catalog_profession_heroic_abilities) AS new_profession_links,
  (SELECT COUNT(*) FROM catalog_heroic_abilities WHERE scope = 'profession') AS source_profession_rows;

-- Only run once the counts above have been confirmed to match:
DROP TABLE catalog_heroic_abilities;
RENAME TABLE catalog_heroic_abilities_new TO catalog_heroic_abilities;

-- ============================================================
-- B) Drop catalog_item_misc (redundant with catalog_items.kind='misc')
-- ============================================================

DROP TABLE catalog_item_misc;

-- ============================================================
-- C) catalog_items: price_copper (flattened) -> gold/silver/copper
-- ============================================================

ALTER TABLE catalog_items
    ADD COLUMN price_gold INT NOT NULL DEFAULT 0 AFTER rarity,
    ADD COLUMN price_silver INT NOT NULL DEFAULT 0 AFTER price_gold;

UPDATE catalog_items SET
    price_gold = FLOOR(price_copper / 100),
    price_silver = FLOOR((price_copper % 100) / 10),
    price_copper = price_copper % 10;

-- ============================================================
-- D) catalog_schools gets its own id; catalog_spells.school_skill_id -> school_id
-- ============================================================

-- Find the actual FK constraint name for school_skill_id before dropping it:
-- SHOW CREATE TABLE catalog_spells;  (look for the FOREIGN KEY on school_skill_id)
-- Replace fk_school_skill below with that name if it differs.

ALTER TABLE catalog_spells DROP FOREIGN KEY catalog_spells_ibfk_1;

DROP TABLE catalog_schools;
CREATE TABLE catalog_schools (
    id INT AUTO_INCREMENT PRIMARY KEY,
    skill_id INT NOT NULL UNIQUE,
    lore_de TEXT NULL,
    display_order INT NOT NULL DEFAULT 0,
    FOREIGN KEY (skill_id) REFERENCES catalog_skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_schools (skill_id, display_order)
SELECT id, ROW_NUMBER() OVER (ORDER BY name_de) FROM catalog_skills WHERE category = 'secondary';

ALTER TABLE catalog_spells CHANGE COLUMN school_skill_id school_id INT NULL;

UPDATE catalog_spells sp
JOIN catalog_schools sc ON sc.skill_id = sp.school_id
SET sp.school_id = sc.id;

ALTER TABLE catalog_spells ADD FOREIGN KEY (school_id) REFERENCES catalog_schools(id);
