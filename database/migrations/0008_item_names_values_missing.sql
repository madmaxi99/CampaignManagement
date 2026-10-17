-- skip-if: SELECT COUNT(*) FROM catalog_items WHERE name_de = 'Streitkolben'
-- abort-if: SELECT COUNT(*) FROM catalog_items WHERE name_de IN ('Stumpfer Gegenstand, leicht', 'Stumpfer Gegenstand, schwer', 'Zweihandschwert', 'Holzkeule, klein', 'Holzkeule, groß', 'Köcher, Eisenspitzen', 'Streitkolben', 'Feder & Tinte', 'Bärenfalle', 'Köcher, Holzspitzen')
-- Gegenstände nach dem Regelbuch: Namen (Mace, Quill & Ink, Bear Trap, zwei Köcher), Werte (Breitschwert, Karte, Harfe, Schild groß), Supply und fehlende Waffen/Köcher.

-- Namen
UPDATE catalog_items SET name_de = 'Streitkolben' WHERE name_de = 'Keule';
UPDATE catalog_items SET name_de = 'Feder & Tinte' WHERE name_de = 'Feder';
UPDATE catalog_items SET name_de = 'Bärenfalle' WHERE name_de = 'Falle/Schlinge, groß';
UPDATE catalog_items SET name_de = 'Köcher, Holzspitzen' WHERE name_de = 'Köcher';

-- Werte
UPDATE catalog_item_weapons w JOIN catalog_items i ON i.id = w.item_id SET w.durability = 15 WHERE i.name_de = 'Breitschwert';
UPDATE catalog_items SET price_gold = 5, price_silver = 0, price_copper = 0 WHERE name_de = 'Karte';
UPDATE catalog_items SET weight = 2 WHERE name_de = 'Harfe';

-- Supply
UPDATE catalog_items SET rarity = 'gewöhnlich' WHERE name_de = 'Schild, groß';
UPDATE catalog_items SET rarity = 'ungewöhnlich' WHERE name_de IN ('Langschwert', 'Krummsäbel', 'Streitaxt', 'Dreschflegel', 'Kriegshammer, klein', 'Dreizack', 'Langbogen', 'Leichte Armbrust', 'Offener Helm', 'Leier', 'Amulett', 'Buch', 'Feder & Tinte', 'Zauberstab', 'Schmiedewerkzeug', 'Zimmermannswerkzeug', 'Gerberwerkzeug');
UPDATE catalog_items SET rarity = 'selten' WHERE name_de IN ('Lanze', 'Großhelm');

-- Fehlende Gegenstände (IDs per AUTO_INCREMENT, falls die SL im Katalog-Editor schon eigene angelegt hat)
INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Stumpfer Gegenstand, leicht', 'Ein improvisierter Gegenstand, der als Waffe benutzt wird.', 'gewöhnlich', 0, 0, 0, 'weapon'),
    ('Stumpfer Gegenstand, schwer', 'Ein schwerer, improvisierter Gegenstand, der als Waffe benutzt wird.', 'gewöhnlich', 0, 0, 0, 'weapon'),
    ('Zweihandschwert', 'Ein mächtiges Schwert, das mit beiden Händen geführt wird.', 'selten', 50, 0, 0, 'weapon'),
    ('Holzkeule, klein', 'Ein kleiner Knüppel aus Holz.', 'gewöhnlich', 0, 1, 0, 'weapon'),
    ('Holzkeule, groß', 'Eine große, schwere Keule aus Holz.', 'gewöhnlich', 0, 2, 0, 'weapon'),
    ('Köcher, Eisenspitzen', 'Nötig, um mit Bögen oder Armbrüsten zu schießen.', 'gewöhnlich', 2, 0, 0, 'misc');

INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de)
    SELECT id, '1-händig', NULL, 'STR', 'W8', 3, 'Wucht, kann geworfen werden' FROM catalog_items WHERE name_de = 'Stumpfer Gegenstand, leicht';
INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de)
    SELECT id, '2-händig', 16, '2', '2W8', 3, 'Wucht' FROM catalog_items WHERE name_de = 'Stumpfer Gegenstand, schwer';
INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de)
    SELECT id, '2-händig', 16, '2', '2W10', 15, 'Stich, Hieb' FROM catalog_items WHERE name_de = 'Zweihandschwert';
INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de)
    SELECT id, '1-händig', 7, '2', 'W8', 9, 'Wucht' FROM catalog_items WHERE name_de = 'Holzkeule, klein';
INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de)
    SELECT id, '2-händig', 16, '2', '2W8', 12, 'Wucht' FROM catalog_items WHERE name_de = 'Holzkeule, groß';
