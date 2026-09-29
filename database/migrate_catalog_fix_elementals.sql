SET NAMES utf8mb4;

-- Fourth pass on the catalog_* schema (run once against the existing,
-- populated dev DB after migrate_catalog_extras.sql):
--
-- migrate_catalog_extras.sql invented a "Elementar beschwören" spell and a
-- catalog_creatures/catalog_creature_attacks bestiary with made-up stats
-- (HP, movement, armor, attacks) instead of transcribing the real Dragonbane
-- data, which is printed right next to the Elementalism spell list in
-- docs/bilder/ (Chapter 5). This corrects that: removes the invented spell
-- and tables, and replaces them with the four real summon spells (Gnom,
-- Salamander, Sylphe, Undine), each rank 3, with their actual stat blocks.
--
-- Also fixes a translation slip on Frost's duration ("Stretch", not "Hour")
-- caught while re-checking this same rulebook page.

-- ============================================================
-- A) Remove the invented spell + bestiary tables
-- ============================================================

DELETE FROM catalog_spells WHERE name_de = 'Elementar beschwören';

DROP TABLE catalog_creature_attacks;
DROP TABLE catalog_creatures;

-- ============================================================
-- B) catalog_spells.rank: NULL for tricks, 1-5 for spells.
--    Character creation only offers rank 1 spells -- backfill the existing
--    (all genuinely rank 1) rows before adding the rank-3 elementals.
-- ============================================================

ALTER TABLE catalog_spells ADD COLUMN rank TINYINT UNSIGNED NULL AFTER type;

UPDATE catalog_spells SET rank = 1 WHERE type = 'spell';

UPDATE catalog_spells SET duration_de = '1 Weile' WHERE name_de = 'Frost' AND duration_de = 'Stunde';

-- ============================================================
-- C) The four real Elementalism summon spells (rank 3)
-- ============================================================

INSERT INTO catalog_spells (name_de, type, rank, school_id, components_de, casting_time_de, range_de, duration_de, wp_note_de, effect_de) VALUES
    ('Gnom', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste, Zutat (Stein oder Erde)', '1 Weile', '4 m', '1 Weile', '2 WP je Kraftstufe',
        'Voraussetzung: Steinwall. Du beschwörst einen Erdelementar. Der Gnom nimmt die Gestalt eines Humanoiden aus grau-braunem Sand und Lehm an und gilt im Kampf als Monster. Er folgt den Befehlen seines Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 8, TP: 5 pro Kraftstufe, Rüstung: 4.\nWaffe – Steinfäuste: Trifft automatisch im Nahkampf (kann pariert oder ausgewichen werden) und verursacht 1W6 Wuchtschaden pro Kraftstufe.\nPfeiler: Der Gnom kann Pfeiler mit derselben Kraftstufe wirken, mit der er beschworen wurde, unter Verwendung der WP des Magiers.'),
    ('Salamander', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste, Zutat (offenes Feuer)', '1 Weile', '4 m', '1 Weile', '2 WP je Kraftstufe',
        'Voraussetzung: Feuerstoß. Du beschwörst einen Feuerelementar. Der Salamander nimmt die Gestalt einer feurigen Echse an und gilt im Kampf als Monster. Er folgt den Befehlen seines Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 12, TP: 5 pro Kraftstufe, Rüstung: —.\nWaffe – Feuriger Griff: Trifft automatisch im Nahkampf (kann pariert oder ausgewichen werden) und verursacht 1W6 Schaden pro Kraftstufe; Rüstung hat keine Wirkung.\nFeuerkugel: Der Salamander kann Feuerstoß mit derselben Kraftstufe wirken, mit der er beschworen wurde, unter Verwendung der WP des Magiers.\nResistenz: Stichschaden wird halbiert.\nImmunität: Der Salamander ist immun gegen Feuerschaden, auch magisches.'),
    ('Sylphe', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste', '1 Weile', '4 m', '1 Weile', '2 WP je Kraftstufe',
        'Voraussetzung: Wirbelwind. Du beschwörst einen Luftelementar. Die Sylphe erscheint als sturmwolkenartiges Wesen in Vogelgestalt und gilt im Kampf als Monster. Sie folgt den Befehlen ihres Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 24, TP: 5 pro Kraftstufe, Rüstung: —.\nWaffe – Heulende Winde: Trifft automatisch im Nahkampf (kann nur ausgewichen, nicht pariert werden), schleudert das Ziel 1W4 m pro Kraftstufe zurück und verursacht denselben Wuchtschaden.\nWindstoß: Die Sylphe kann Windstoß mit derselben Kraftstufe wirken, mit der sie beschworen wurde, unter Verwendung der WP des Magiers.\nResistenz: Stichschaden wird halbiert.'),
    ('Undine', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste, Zutat (Wasser)', '1 Weile', '4 m', '1 Weile', '2 WP je Kraftstufe',
        'Voraussetzung: Flutwelle. Du beschwörst einen Wasserelementar. Die Undine erscheint wie eine Gezeitenwelle in Gestalt einer Frau, vollständig aus Wasser bestehend, und gilt im Kampf als Monster. Sie folgt den Befehlen ihres Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 12, TP: 5 pro Kraftstufe, Rüstung: —.\nWaffe – Nasse Umarmung: Trifft automatisch im Nahkampf (kann nur ausgewichen, nicht pariert werden) und verursacht 1W6 Schaden pro Kraftstufe; Rüstung hat keine Wirkung.\nFlutwelle: Die Undine kann Flutwelle mit derselben Kraftstufe wirken, mit der sie beschworen wurde, unter Verwendung der WP des Magiers.\nResistenz: Stichschaden wird halbiert.');

-- ============================================================
-- Verification (run before trusting the migration)
-- ============================================================

SELECT 'spells without rank set' AS check_name, COUNT(*) AS bad_count
FROM catalog_spells WHERE type = 'spell' AND rank IS NULL;

SELECT 'new elemental spells' AS check_name, COUNT(*) AS found_count
FROM catalog_spells WHERE name_de IN ('Gnom', 'Salamander', 'Sylphe', 'Undine') AND rank = 3;
