SET NAMES utf8mb4;

-- Spielstand pro Kampagne (siehe docs/SCHEMA.md, Abschnitt "Spielstand pro
-- Kampagne"). status_de / home_location_id in catalog_* sind ab jetzt der
-- Grundzustand der Welt. Was in einer Kampagne passiert, steht in der Kampagne.

-- 1. NPC-Stand pro Kampagne. NULL heißt: es gilt der Grundzustand.
ALTER TABLE campaign_npcs
    ADD COLUMN status_de VARCHAR(30) NULL,
    ADD COLUMN home_location_id INT NULL,
    ADD CONSTRAINT fk_campaign_npcs_home FOREIGN KEY (home_location_id) REFERENCES catalog_locations(id) ON DELETE SET NULL;

-- 2. Ort-Stand pro Kampagne.
CREATE TABLE campaign_location_states (
    campaign_id INT NOT NULL,
    location_id INT NOT NULL,
    status_de VARCHAR(30) NOT NULL,
    PRIMARY KEY (campaign_id, location_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES catalog_locations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Verlauf gehört zur Kampagne. world_events war leer und wurde nirgends benutzt.
RENAME TABLE world_events TO campaign_events;
ALTER TABLE campaign_events
    ADD COLUMN set_status_de VARCHAR(30) NULL AFTER text_de,
    ADD COLUMN set_home_location_id INT NULL AFTER set_status_de,
    ADD COLUMN adopted_at DATETIME NULL AFTER set_home_location_id,
    ADD CONSTRAINT fk_campaign_events_home FOREIGN KEY (set_home_location_id) REFERENCES catalog_locations(id) ON DELETE SET NULL;
