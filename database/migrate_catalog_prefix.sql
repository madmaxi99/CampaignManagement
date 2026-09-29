SET NAMES utf8mb4;

-- One-time migration for the running dev DB: renames all rules-reference
-- tables to the `catalog_` prefix and consolidates the three separate
-- heroic-ability tables into one. Run this once against the existing,
-- populated database (docker-entrypoint-initdb.d only runs on a fresh empty
-- volume, so this script must be applied by hand, e.g.:
--   docker compose exec -T mariadb mariadb -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < database/migrate_catalog_prefix.sql
-- After this, schema.sql/seed_*.sql already reflect the new names, so a
-- fresh volume (`docker compose down -v && up`) does NOT need this script.

-- ============================================================
-- Step A: straight 1:1 renames (InnoDB updates FK metadata automatically)
-- ============================================================

RENAME TABLE
    attributes                    TO catalog_attributes,
    conditions                    TO catalog_conditions,
    skills                        TO catalog_skills,
    spells                        TO catalog_spells,
    items                         TO catalog_items,
    item_weapons                  TO catalog_item_weapons,
    item_armor                    TO catalog_item_armor,
    item_misc                     TO catalog_item_misc,
    flaws                         TO catalog_flaws,
    kins                          TO catalog_kins,
    professions                   TO catalog_professions,
    profession_key_skills         TO catalog_profession_key_skills,
    profession_gear_options       TO catalog_profession_gear_options,
    profession_gear_option_items  TO catalog_profession_gear_option_items;

-- ============================================================
-- Step B: new catalog_schools (additive, no source data to migrate -- the
-- three existing magic-school skill rows just don't have lore text yet)
-- ============================================================

CREATE TABLE catalog_schools (
    skill_id INT PRIMARY KEY,
    lore_de TEXT NULL,
    display_order INT NOT NULL DEFAULT 0,
    FOREIGN KEY (skill_id) REFERENCES catalog_skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Step C: consolidate the 3 heroic-ability tables into one
-- ============================================================

CREATE TABLE catalog_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    scope ENUM('general', 'kin', 'profession') NOT NULL,
    kin_code VARCHAR(20) NULL,
    profession_code VARCHAR(30) NULL,
    granted_at_creation BOOLEAN NOT NULL DEFAULT 0,
    name_de VARCHAR(100) NOT NULL,
    requirement_de VARCHAR(100) NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    choice_group VARCHAR(50) NULL,
    FOREIGN KEY (kin_code) REFERENCES catalog_kins(code),
    FOREIGN KEY (profession_code) REFERENCES catalog_professions(code),
    CONSTRAINT chk_heroic_ability_scope CHECK (
        (scope = 'kin'        AND kin_code IS NOT NULL AND profession_code IS NULL) OR
        (scope = 'profession' AND profession_code IS NOT NULL AND kin_code IS NULL) OR
        (scope = 'general'    AND kin_code IS NULL AND profession_code IS NULL)
    ),
    INDEX idx_scope_kin (scope, kin_code),
    INDEX idx_scope_profession (scope, profession_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_heroic_abilities
    (scope, kin_code, profession_code, granted_at_creation, name_de, requirement_de, wp_note_de, description_de, choice_group)
SELECT 'kin', kin_code, NULL, 1, name_de, NULL, wp_note_de, description_de, NULL
FROM kin_heroic_abilities;

INSERT INTO catalog_heroic_abilities
    (scope, kin_code, profession_code, granted_at_creation, name_de, requirement_de, wp_note_de, description_de, choice_group)
SELECT 'profession', NULL, profession_code, granted_at_creation, name_de, requirement_de, wp_note_de, description_de, choice_group
FROM profession_heroic_abilities;

INSERT INTO catalog_heroic_abilities
    (scope, kin_code, profession_code, granted_at_creation, name_de, requirement_de, wp_note_de, description_de, choice_group)
SELECT 'general', NULL, NULL, 0, name_de, requirement_de, wp_note_de, description_de, NULL
FROM general_heroic_abilities;

-- Verification: run this SELECT and confirm every migrated_* count matches
-- its source_* count BEFORE running the DROP TABLE below.
SELECT
  (SELECT COUNT(*) FROM catalog_heroic_abilities WHERE scope='kin') AS migrated_kin,
  (SELECT COUNT(*) FROM kin_heroic_abilities) AS source_kin,
  (SELECT COUNT(*) FROM catalog_heroic_abilities WHERE scope='profession') AS migrated_prof,
  (SELECT COUNT(*) FROM profession_heroic_abilities) AS source_prof,
  (SELECT COUNT(*) FROM catalog_heroic_abilities WHERE scope='general') AS migrated_gen,
  (SELECT COUNT(*) FROM general_heroic_abilities) AS source_gen;

-- Only run this once the counts above have been confirmed to match:
DROP TABLE kin_heroic_abilities, profession_heroic_abilities, general_heroic_abilities;
