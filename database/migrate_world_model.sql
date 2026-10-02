SET NAMES utf8mb4;

-- Migrates a live database from the campaign-centric model to the world
-- model described in docs/CONCEPT.md and docs/SCHEMA.md. Run once, against a
-- database that has the pre-migration schema (creatures, npcs, campaigns with
-- slug, campaign_locations with campaign_id, characters with slug).
--
-- DDL is not transactional in MariaDB, so take a dump first and try this on a
-- copy of the database before running it for real.
--
-- Not covered here: the images of a campaign move from
-- backend/public/images/campaigns/<slug>/ to .../campaigns/<campaign id>/.

-- ============================================================
-- 1. World locations (needed first: catalog_npcs points at them)
-- ============================================================

CREATE TABLE catalog_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT NULL,
    name_de VARCHAR(150) NOT NULL,
    kind_de VARCHAR(50) NULL,
    status_de VARCHAR(30) NOT NULL DEFAULT 'intakt',
    player_de TEXT NULL,
    secret_de TEXT NULL,
    image_path VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES catalog_locations(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. Bestiary (creatures -> catalog_bestiary)
-- ============================================================

RENAME TABLE creatures TO catalog_bestiary, creature_attacks TO catalog_bestiary_attacks;

ALTER TABLE catalog_bestiary
    MODIFY COLUMN armor_de VARCHAR(50) NOT NULL DEFAULT '—',
    ADD COLUMN category_de VARCHAR(50) NULL AFTER name_de,
    ADD COLUMN traits_de TEXT NULL,
    ADD COLUMN kit_de TEXT NULL;

ALTER TABLE catalog_bestiary_attacks
    CHANGE COLUMN creature_id bestiary_id INT NOT NULL;

UPDATE catalog_bestiary SET category_de = 'Tier' WHERE name_de IN ('Riesenspinne', 'Vampirfledermaus', 'Monster-Aal');
UPDATE catalog_bestiary SET category_de = 'Untot' WHERE name_de IN ('Die Dame des Hügels', 'Der Gruftschrecken von Ridderhöhe', 'Geist des Bibliothekars');
UPDATE catalog_bestiary SET category_de = 'Konstrukt' WHERE name_de = 'Verzauberte Galionsfigur';
UPDATE catalog_bestiary SET category_de = 'Drache' WHERE name_de = 'Krakul';

RENAME TABLE campaign_creature_links TO campaign_bestiary;

ALTER TABLE campaign_bestiary
    CHANGE COLUMN creature_id bestiary_id INT NOT NULL,
    ADD COLUMN chapter_id INT NULL,
    ADD COLUMN notes_de TEXT NULL;

-- ============================================================
-- 3. NPCs (npcs -> catalog_npcs)
-- ============================================================

RENAME TABLE npcs TO catalog_npcs;

ALTER TABLE catalog_npcs
    ADD COLUMN is_important BOOLEAN NOT NULL DEFAULT 0 AFTER name_de,
    ADD COLUMN status_de VARCHAR(30) NOT NULL DEFAULT 'lebt' AFTER is_important,
    ADD COLUMN home_location_id INT NULL,
    ADD COLUMN bestiary_id INT NULL,
    ADD COLUMN player_de TEXT NULL AFTER role_de,
    ADD COLUMN theater_de TEXT NULL,
    ADD COLUMN secret_de TEXT NULL,
    ADD COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    MODIFY COLUMN role_de VARCHAR(150) NULL,
    MODIFY COLUMN description_de TEXT NULL,
    ADD CONSTRAINT fk_npcs_home_location FOREIGN KEY (home_location_id) REFERENCES catalog_locations(id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_npcs_bestiary FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id) ON DELETE SET NULL;

-- The NPCs that exist so far are all scripted adventure NPCs.
UPDATE catalog_npcs SET is_important = 1;

RENAME TABLE campaign_npc_links TO campaign_npcs;

ALTER TABLE campaign_npcs
    ADD COLUMN chapter_id INT NULL,
    ADD COLUMN notes_de TEXT NULL;

-- ============================================================
-- 4. Chapters: label + position in steps of 10, "Kapitel 1" for every
--    campaign that has none yet
-- ============================================================

ALTER TABLE campaign_chapters ADD COLUMN label VARCHAR(10) NOT NULL DEFAULT '' AFTER campaign_id;

UPDATE campaign_chapters SET label = CAST(position AS CHAR), position = position * 10;

ALTER TABLE campaign_chapters
    MODIFY COLUMN label VARCHAR(10) NOT NULL,
    ADD UNIQUE KEY uq_chapter_position (campaign_id, position);

INSERT INTO campaign_chapters (campaign_id, label, position, title_de)
SELECT c.id, '1', 10, c.name_de
FROM campaigns c
WHERE NOT EXISTS (SELECT 1 FROM campaign_chapters ch WHERE ch.campaign_id = c.id);

-- ============================================================
-- 5. Campaign locations become appearances of world locations:
--    one world location per existing campaign, all its areas point at it
-- ============================================================

ALTER TABLE catalog_locations ADD COLUMN tmp_campaign_id INT NULL;

INSERT INTO catalog_locations (name_de, tmp_campaign_id)
SELECT name_de, id FROM campaigns;

UPDATE catalog_locations
SET name_de = 'Magdalas Turm', kind_de = 'Turm'
WHERE tmp_campaign_id = (SELECT id FROM campaigns WHERE slug = 'versinkender-turm');

ALTER TABLE campaign_locations
    ADD COLUMN catalog_location_id INT NULL AFTER chapter_id,
    ADD COLUMN image_path VARCHAR(255) NULL;

UPDATE campaign_locations l
JOIN catalog_locations w ON w.tmp_campaign_id = l.campaign_id
SET l.catalog_location_id = w.id;

UPDATE campaign_locations l
JOIN campaign_chapters ch ON ch.campaign_id = l.campaign_id AND ch.position = (
    SELECT MIN(position) FROM campaign_chapters WHERE campaign_id = l.campaign_id
)
SET l.chapter_id = ch.id
WHERE l.chapter_id IS NULL;

ALTER TABLE catalog_locations DROP COLUMN tmp_campaign_id;

ALTER TABLE campaign_locations
    DROP FOREIGN KEY campaign_locations_ibfk_1,
    DROP FOREIGN KEY campaign_locations_ibfk_2;

ALTER TABLE campaign_locations
    DROP COLUMN campaign_id,
    MODIFY COLUMN chapter_id INT NOT NULL,
    MODIFY COLUMN catalog_location_id INT NOT NULL,
    ADD CONSTRAINT fk_campaign_locations_chapter FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_campaign_locations_location FOREIGN KEY (catalog_location_id) REFERENCES catalog_locations(id);

-- ============================================================
-- 6. Optional chapter links on the campaign lists
-- ============================================================

ALTER TABLE campaign_bestiary
    ADD CONSTRAINT fk_campaign_bestiary_chapter FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL;

ALTER TABLE campaign_npcs
    ADD CONSTRAINT fk_campaign_npcs_chapter FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL;

-- ============================================================
-- 7. slug is gone: campaigns are addressed by id, characters always were
-- ============================================================

ALTER TABLE campaigns DROP COLUMN slug;
ALTER TABLE characters DROP COLUMN slug;

-- ============================================================
-- 8. History of the world
-- ============================================================

CREATE TABLE world_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    chapter_id INT NULL,
    location_id INT NULL,
    npc_id INT NULL,
    text_de TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (location_id) REFERENCES catalog_locations(id) ON DELETE CASCADE,
    FOREIGN KEY (npc_id) REFERENCES catalog_npcs(id) ON DELETE CASCADE,
    CHECK (location_id IS NOT NULL OR npc_id IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
