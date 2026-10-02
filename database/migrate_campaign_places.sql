-- A campaign only shows the catalog places it actually uses.
CREATE TABLE campaign_places (
    campaign_id INT NOT NULL,
    location_id INT NOT NULL,
    PRIMARY KEY (campaign_id, location_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES catalog_locations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO campaign_places (campaign_id, location_id)
SELECT DISTINCT ch.campaign_id, cl.catalog_location_id
FROM campaign_locations cl JOIN campaign_chapters ch ON ch.id = cl.chapter_id;

-- Example content belongs in its own campaign, not in a standard adventure.
INSERT INTO campaigns (name_de, teaser_de, background_de, is_default) VALUES
    ('Der Hundekampfring', 'Ein Fremder sucht in Rynda nach einem verschwundenen Hund.',
     'Beispielkampagne in der Nebelmark: Alberta, die Bäckerin von Rynda, leitet im Keller einen Hundekampfring. Die Gruppe soll herausfinden, wer dort kämpfen lässt.', 0);
SET @example_id = LAST_INSERT_ID();
INSERT INTO campaign_chapters (campaign_id, label, position, title_de) VALUES (@example_id, '1', 10, 'Rynda');
SET @example_chapter_id = LAST_INSERT_ID();
UPDATE campaign_npcs SET campaign_id = @example_id, chapter_id = @example_chapter_id
WHERE name_de IN ('Alberta', 'Der Wirt Ottmar');
INSERT INTO campaign_places (campaign_id, location_id)
SELECT @example_id, id FROM catalog_locations
WHERE name_de IN ('Die Nebelmark', 'Rynda', 'Die verlassene Bibliothek', 'Bäckerei Segenreich', 'Der Hundekampfring')
   OR name_de LIKE 'Wirtshaus%';
INSERT INTO campaign_locations (chapter_id, catalog_location_id, position, number_label, name_de, read_aloud_de, notes_de)
SELECT @example_chapter_id, id, 10, '1', 'Bäckerei Segenreich', 'Warme Stube, hinter der Theke Regale voller Brote.', 'Der Keller führt zum Hundekampfring.'
FROM catalog_locations WHERE name_de = 'Bäckerei Segenreich';
INSERT INTO campaign_locations (chapter_id, catalog_location_id, position, number_label, name_de, read_aloud_de, notes_de)
SELECT @example_chapter_id, id, 20, '2', 'Hundekampfring', 'Ein Kellerraum mit Sand auf dem Boden und einem Käfig an der Stirnseite.', 'Kämpfe jeden dritten Abend.'
FROM catalog_locations WHERE name_de = 'Der Hundekampfring';
