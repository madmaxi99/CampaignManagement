SET NAMES utf8mb4;

-- Eighth pass: same problem as migrate_item_stats_fix.sql (weapons/armor),
-- now for the remaining non-weapon/armor catalog_items -- musical
-- instruments, trade goods, studies & magic, light sources, tools, medicine,
-- animals, means of travel. Cross-checked against docs/bilder/ (Chapter 2 -
-- Equipment). Most were priced far too low (some 10-100x under the real
-- price); a few items were missing entirely. See
-- seed_item_stats_corrections_2.sql for the fresh-install version.

ALTER TABLE catalog_items MODIFY COLUMN rarity
    ENUM('gewöhnlich', 'ungewöhnlich', 'selten', 'episch', 'legendär', 'einzigartig')
    NOT NULL DEFAULT 'gewöhnlich';

-- ============================================================
-- Musical instruments (price fixes + real mechanical effect text)
-- ============================================================

UPDATE catalog_items SET price_gold = 2, price_silver = 0, price_copper = 0,
    description_de = 'Eine einfache Holzflöte. Senkt die WP-Kosten der Musiker-Fähigkeit auf 2.'
    WHERE name_de = 'Flöte';

UPDATE catalog_items SET price_gold = 6, price_silver = 0, price_copper = 0,
    description_de = 'Ein Blashorn für Signale und Musik. Erhöht die Reichweite der Musiker-Fähigkeit auf 100 Meter.'
    WHERE name_de = 'Horn';

UPDATE catalog_items SET price_gold = 20, price_silver = 0, price_copper = 0,
    description_de = 'Ein kleines Saiteninstrument. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1.'
    WHERE name_de = 'Leier';

UPDATE catalog_items SET description_de = 'Ein Sackpfeifeninstrument mit durchdringendem Klang. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1 und erhöht die Reichweite auf 50 Meter.'
    WHERE name_de = 'Dudelsack';

UPDATE catalog_items SET description_de = 'Eine einfache Handtrommel. Erhöht die Reichweite der Musiker-Fähigkeit auf 20 Meter.'
    WHERE name_de = 'Trommel';

UPDATE catalog_items SET description_de = 'Ein aufwendig gebautes Saiteninstrument. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1.'
    WHERE name_de = 'Harfe';

-- ============================================================
-- Trade goods
-- ============================================================

UPDATE catalog_items SET price_gold = 3, price_silver = 0, price_copper = 0,
    description_de = 'Ein Enterhaken mit Seil. Kann verwendet werden, um ein Seil zu sichern; wird mit einer Akrobatik-Probe bis zu STÄ Meter weit geworfen (STÄ×2 mit einem Nachteil).'
    WHERE name_de = 'Wurfhaken';

UPDATE catalog_items SET price_gold = 1, price_silver = 0, price_copper = 0 WHERE name_de = 'Dietriche';

UPDATE catalog_items SET price_gold = 0, price_silver = 5, price_copper = 0 WHERE name_de = 'Karte';

UPDATE catalog_items SET description_de = 'Ein solides Schloss für Türen oder Truhen. Verschließt eine Tür oder Truhe; kann bis zu 20 Schadenspunkte einstecken, Rüstungswert 5.'
    WHERE name_de = 'Vorhängeschloss';

UPDATE catalog_items SET price_gold = 1, price_silver = 0, price_copper = 0 WHERE name_de = 'Seil (Hanf), 10m';

UPDATE catalog_items SET price_gold = 50, price_silver = 0, price_copper = 0, rarity = 'selten',
    description_de = 'Ein Fernrohr für die weite Sicht. Bonus auf Wildnisleben-Proben, um während einer Reise den Weg zu weisen.'
    WHERE name_de = 'Fernrohr';

UPDATE catalog_items SET price_gold = 0, price_silver = 5, price_copper = 0 WHERE name_de = 'Köcher';

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Schlafpelz', 'Ein Fell zum Schlafen. Erforderlich, um einen Nachteil auf Wildnisleben-Proben beim Wegführen während einer Reise zu vermeiden.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Zelt, klein', 'Bietet Platz für bis zu zwei Personen. Gewährt einen Vorteil auf Wildnisleben-Proben beim Lagern; nur eine Person würfelt, andere können helfen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Zelt, groß', 'Bietet Platz für bis zu sechs Personen. Gewährt einen Vorteil auf Wildnisleben-Proben beim Lagern; nur eine Person würfelt, andere können helfen.', 'gewöhnlich', 4, 0, 0, 'misc'),
    ('Pfeife (Signalpfeife)', 'Kann aus bis zu 100 Metern Entfernung gehört werden.', 'gewöhnlich', 0, 5, 0, 'misc');

-- ============================================================
-- Studies & magic
-- ============================================================

UPDATE catalog_items SET price_gold = 3, price_silver = 0, price_copper = 0 WHERE name_de = 'Amulett';
UPDATE catalog_items SET price_gold = 25, price_silver = 0, price_copper = 0 WHERE name_de = 'Buch';
UPDATE catalog_items SET price_gold = 5, price_silver = 0, price_copper = 0 WHERE name_de = 'Notizbuch';
UPDATE catalog_items SET price_gold = 10, price_silver = 0, price_copper = 0 WHERE name_de = 'Feder';
UPDATE catalog_items SET price_gold = 10, price_silver = 0, price_copper = 0 WHERE name_de = 'Zauberstab';

UPDATE catalog_items SET name_de = 'Orbuculum', price_gold = 18, price_silver = 0, price_copper = 0
    WHERE name_de = 'Orduculum';

UPDATE catalog_items SET price_gold = 50, price_silver = 0, price_copper = 0, rarity = 'einzigartig'
    WHERE name_de = 'Grimoire';

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Brosche', 'Kann als magischer Fokus für Zauber verwendet werden.', 'ungewöhnlich', 5, 0, 0, 'misc');

-- ============================================================
-- Light sources
-- ============================================================

UPDATE catalog_items SET price_gold = 0, price_silver = 3, price_copper = 0 WHERE name_de = 'Lampenöl';
UPDATE catalog_items SET price_gold = 10, price_silver = 0, price_copper = 0 WHERE name_de = 'Laterne';
UPDATE catalog_items SET description_de = 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.' WHERE name_de = 'Fackel';

-- ============================================================
-- Tools
-- ============================================================

UPDATE catalog_items SET price_gold = 2, price_silver = 0, price_copper = 0 WHERE name_de = 'Brecheisen';
UPDATE catalog_items SET price_gold = 20, price_silver = 0, price_copper = 0 WHERE name_de = 'Schmiedewerkzeug';
UPDATE catalog_items SET price_gold = 8, price_silver = 0, price_copper = 0 WHERE name_de = 'Zimmermannswerkzeug';
UPDATE catalog_items SET price_gold = 5, price_silver = 0, price_copper = 0 WHERE name_de = 'Gerberwerkzeug';

-- ============================================================
-- Medicine
-- ============================================================

UPDATE catalog_items SET price_gold = 0, price_silver = 5, price_copper = 0 WHERE name_de = 'Bandagen';

-- ============================================================
-- Animals / means of travel
-- ============================================================

UPDATE catalog_items SET price_gold = 400, price_silver = 0, price_copper = 0, rarity = 'selten' WHERE name_de = 'Kampfpferd';
UPDATE catalog_items SET price_gold = 12, price_silver = 0, price_copper = 0 WHERE name_de = 'Esel';
UPDATE catalog_items SET price_gold = 15, price_silver = 0, price_copper = 0,
    description_de = 'Ein Karren, gezogen von einem Pferd oder Esel. Bietet Platz für zwei Personen und 50 Gewichtseinheiten.'
    WHERE name_de = 'Karren';

-- ============================================================
-- Verification
-- ============================================================

SELECT COUNT(*) AS total_items FROM catalog_items;
SELECT name_de FROM catalog_items WHERE name_de IN ('Orduculum') ;
