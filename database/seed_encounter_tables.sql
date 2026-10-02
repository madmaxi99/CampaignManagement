SET NAMES utf8mb4;

-- Random encounter tables of the catalog (W6). Entries point at bestiary stat
-- blocks with a count; entries without a creature carry only a text.

INSERT INTO catalog_encounter_tables (name_de) VALUES ('Wald');
SET @wald_id = LAST_INSERT_ID();
INSERT INTO catalog_encounter_table_entries (table_id, min_roll, max_roll, bestiary_id, quantity_de, text_de) VALUES
    (@wald_id, 1, 2, NULL, NULL, 'Nichts begegnet der Gruppe.'),
    (@wald_id, 3, 3, (SELECT id FROM catalog_bestiary WHERE name_de = 'Wolf'), 'W3', NULL),
    (@wald_id, 4, 4, (SELECT id FROM catalog_bestiary WHERE name_de = 'Wildschwein'), '1', NULL),
    (@wald_id, 5, 5, (SELECT id FROM catalog_bestiary WHERE name_de = 'Bär'), '1', NULL),
    (@wald_id, 6, NULL, (SELECT id FROM catalog_bestiary WHERE name_de = 'Goblin – Späher'), 'W3', NULL);

INSERT INTO catalog_encounter_tables (name_de) VALUES ('Straße');
SET @strasse_id = LAST_INSERT_ID();
INSERT INTO catalog_encounter_table_entries (table_id, min_roll, max_roll, bestiary_id, quantity_de, text_de) VALUES
    (@strasse_id, 1, 2, NULL, NULL, 'Nichts begegnet der Gruppe.'),
    (@strasse_id, 3, 3, (SELECT id FROM catalog_bestiary WHERE name_de = 'Zivilist'), 'W3', 'Reisende oder Händler.'),
    (@strasse_id, 4, 4, (SELECT id FROM catalog_bestiary WHERE name_de = 'Kämpfer'), '3', 'Ein Wachtrupp.'),
    (@strasse_id, 5, 5, (SELECT id FROM catalog_bestiary WHERE name_de = 'Goblin – Krieger'), 'W3', 'Wegelagerer.'),
    (@strasse_id, 6, NULL, (SELECT id FROM catalog_bestiary WHERE name_de = 'Ork – Krieger'), 'W3', 'Ein Trupp auf Beutezug.');

INSERT INTO catalog_encounter_tables (name_de) VALUES ('Ruine');
SET @ruine_id = LAST_INSERT_ID();
INSERT INTO catalog_encounter_table_entries (table_id, min_roll, max_roll, bestiary_id, quantity_de, text_de) VALUES
    (@ruine_id, 1, 1, NULL, NULL, 'Nichts regt sich.'),
    (@ruine_id, 2, 2, (SELECT id FROM catalog_bestiary WHERE name_de = 'Skelett – Krieger'), 'W3', NULL),
    (@ruine_id, 3, 3, (SELECT id FROM catalog_bestiary WHERE name_de = 'Skelett – Bogenschütze'), 'W3', NULL),
    (@ruine_id, 4, 4, (SELECT id FROM catalog_bestiary WHERE name_de = 'Geist'), '1', NULL),
    (@ruine_id, 5, 5, (SELECT id FROM catalog_bestiary WHERE name_de = 'Goblin – Späher'), 'W6', 'Plünderer.'),
    (@ruine_id, 6, NULL, (SELECT id FROM catalog_bestiary WHERE name_de = 'Gruftschrecken'), '1', NULL);
