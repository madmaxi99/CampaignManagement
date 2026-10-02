-- Simplified model: catalog = static (locations, items, bestiary), campaign
-- owns its NPCs and its chronicle. Every text is name / description / DM text.
-- NPC ids are kept so portraits in images/npcs/<id>.<ext> stay valid.
-- DDL is not transactional in MariaDB: take a backup first.

-- Old play-state system goes away
DROP TABLE campaign_events;
DROP TABLE campaign_location_states;
DROP TABLE campaign_known_places;
DROP TABLE campaign_threads;

-- Campaign NPCs become their own table
CREATE TABLE campaign_npcs_new (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    chapter_id INT NULL,
    name_de VARCHAR(150) NOT NULL,
    description_de TEXT NULL,
    dm_text_de TEXT NULL,
    notes_de TEXT NULL,
    bestiary_id INT NULL,
    portrait_path VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO campaign_npcs_new (id, campaign_id, chapter_id, name_de, description_de, dm_text_de, notes_de, bestiary_id, portrait_path)
SELECT n.id, cn.campaign_id, cn.chapter_id, n.name_de,
       COALESCE(n.player_de, n.description_de),
       NULLIF(CONCAT_WS('\n\n',
           CASE WHEN n.role_de IS NOT NULL THEN CONCAT('Rolle: ', n.role_de) END,
           CASE WHEN n.player_de IS NOT NULL THEN n.description_de END,
           n.theater_de, n.secret_de, n.motivation_de, n.stats_de), ''),
       cn.notes_de, n.bestiary_id, n.portrait_path
FROM campaign_npcs cn
JOIN catalog_npcs n ON n.id = cn.npc_id;

DROP TABLE campaign_npcs;
RENAME TABLE campaign_npcs_new TO campaign_npcs;
DROP TABLE catalog_npcs;

-- Locations: name / description / DM text
ALTER TABLE catalog_locations
    ADD COLUMN description_de TEXT NULL AFTER name_de,
    ADD COLUMN dm_text_de TEXT NULL AFTER description_de;
UPDATE catalog_locations SET description_de = player_de, dm_text_de = secret_de;
ALTER TABLE catalog_locations
    DROP COLUMN kind_de,
    DROP COLUMN status_de,
    DROP COLUMN player_de,
    DROP COLUMN secret_de;

-- Items: description_de exists already
ALTER TABLE catalog_items ADD COLUMN dm_text_de TEXT NULL AFTER description_de;
