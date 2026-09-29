SET NAMES utf8mb4;

-- Third pass on the catalog_* schema (run once against the existing,
-- populated dev DB after migrate_catalog_prefix.sql + migrate_catalog_refine.sql):
--   A) catalog_mementos / catalog_appearances (new, examples for character creation)
--   B) catalog_schools gets name_de + nullable skill_id; add "Allgemein" row;
--      point the previously-NULL general spells at it; school_id becomes NOT NULL.
--   C) catalog_creatures / catalog_creature_attacks (new, generic bestiary) +
--      4 small elemental spirits + a new Elementalism summon spell.
--   D) Item catalog completion from docs/bilder/ (clothes, tools, containers,
--      trade goods, light sources, medicine, remaining weapons, animals, etc.)

-- ============================================================
-- A) catalog_mementos / catalog_appearances
-- ============================================================

CREATE TABLE catalog_mementos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_mementos (roll_min, roll_max, description_de) VALUES
    (1, 1, 'Deine treuen alten Schuhe'),
    (2, 2, 'Ein schlichtes silbernes Medaillon'),
    (3, 3, 'Ein Brief eines alten Freundes oder Verwandten'),
    (4, 4, 'Ein zerfleddertes altes Tagebuch'),
    (5, 5, 'Ein Armband, das in deiner Familie weitergegeben wird'),
    (6, 6, 'Eine hölzerne Figur aus deiner Kindheit'),
    (7, 7, 'Ein seltsam geformter Stein'),
    (8, 8, 'Eine Kupfermünze aus einem Schatz, den deine Mutter oder dein Vater gesucht hat'),
    (9, 9, 'Ein alter Zinnkrug'),
    (10, 10, 'Ein Horn, das du als Trophäe von einem Monster erbeutet hast'),
    (11, 11, 'Ein Fang, den du als Trophäe von einer Bestie erbeutet hast'),
    (12, 12, 'Ein paar einfache Würfel aus Knochen'),
    (13, 13, 'Ein Medaillon mit einer Haarlocke'),
    (14, 14, 'Ein verzierter Schlüssel'),
    (15, 15, 'Eine handgezeichnete Karte, die du geerbt hast'),
    (16, 16, 'Ein Ring mit einer Inschrift'),
    (17, 17, 'Ein Pfeifchen aus Knochen'),
    (18, 18, 'Der zerschlissene alte Hut deiner Mutter oder deines Vaters'),
    (19, 19, 'Eine Greifenfeder'),
    (20, 20, 'Eine wunderschön geschnitzte Tabakspfeife');

CREATE TABLE catalog_appearances (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_appearances (roll_min, roll_max, description_de) VALUES
    (1, 1, 'Hässliche Narbe quer über die Wange'),
    (2, 2, 'Seltsame Kopfbedeckung'),
    (3, 3, 'Ungewöhnlich blass und käsig'),
    (4, 4, 'Ein ständiges Lächeln auf den Lippen'),
    (5, 5, 'Eisiger, durchdringender Blick'),
    (6, 6, 'Etwas Übergewicht um die Körpermitte'),
    (7, 7, 'Dünn und drahtig'),
    (8, 8, 'Ungewöhnlich viel Körperbehaarung (je nach Volk)'),
    (9, 9, 'Beginnende Glatze (je nach Volk)'),
    (10, 10, 'Auffälliges Tattoo'),
    (11, 11, 'Übler Körpergeruch'),
    (12, 12, 'Prächtige Frisur'),
    (13, 13, 'Hinkender Gang'),
    (14, 14, 'Verdreckt'),
    (15, 15, 'Ehrliche blaue Augen'),
    (16, 16, 'Silberzahn'),
    (17, 17, 'Stark parfümiert'),
    (18, 18, 'Verschiedenfarbige Augen'),
    (19, 19, 'Zischende Stimme'),
    (20, 20, 'Wettergegerbtes Gesicht');

-- ============================================================
-- B) catalog_schools: name_de + nullable skill_id + "Allgemein" row
-- ============================================================

ALTER TABLE catalog_schools DROP FOREIGN KEY catalog_schools_ibfk_1;
ALTER TABLE catalog_schools
    ADD COLUMN name_de VARCHAR(50) NULL AFTER id,
    MODIFY COLUMN skill_id INT NULL;

UPDATE catalog_schools sc JOIN catalog_skills sk ON sk.id = sc.skill_id SET sc.name_de = sk.name_de;

ALTER TABLE catalog_schools
    MODIFY COLUMN name_de VARCHAR(50) NOT NULL,
    ADD UNIQUE KEY uniq_name (name_de),
    ADD FOREIGN KEY (skill_id) REFERENCES catalog_skills(id);

INSERT INTO catalog_schools (name_de, skill_id, display_order) VALUES ('Allgemein', NULL, 0);

UPDATE catalog_spells SET school_id = (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein')
WHERE school_id IS NULL;

ALTER TABLE catalog_spells MODIFY COLUMN school_id INT NOT NULL;

-- ============================================================
-- C) Generic bestiary + elemental spirits + summon spell
-- ============================================================

CREATE TABLE catalog_creatures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    hp INT NOT NULL,
    grimmigkeit_de VARCHAR(20) NOT NULL,
    size_de VARCHAR(50) NOT NULL,
    movement INT NOT NULL,
    armor_de VARCHAR(20) NOT NULL DEFAULT '—',
    resistances_de TEXT NULL,
    immunities_de TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_creature_attacks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    creature_id INT NOT NULL,
    roll_de VARCHAR(10) NOT NULL,
    title_de VARCHAR(100) NOT NULL,
    effect_de TEXT NOT NULL,
    FOREIGN KEY (creature_id) REFERENCES catalog_creatures(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_creatures (name_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de) VALUES
    ('Gnom', 10, '1', 'Klein', 4, '2', 'Erhält halben Schaden durch Wuchtwaffen.', NULL),
    ('Salamander', 8, '1', 'Klein', 8, '—', NULL, 'Immun gegen Feuerschaden.'),
    ('Sylphe', 6, '1', 'Klein', 16, '—', 'Erhält halben Schaden durch nicht-magische Fernkampfangriffe.', NULL),
    ('Undine', 8, '1', 'Klein', 10, '—', 'Erhält halben Schaden durch Hiebwaffen.', NULL);

INSERT INTO catalog_creature_attacks (creature_id, roll_de, title_de, effect_de)
SELECT id, 'D6', 'Steinfaust', '1W6 Wuchtschaden.' FROM catalog_creatures WHERE name_de = 'Gnom'
UNION ALL
SELECT id, 'D6', 'Flammenberührung', '1W6 Feuerschaden; entzündet brennbare Objekte.' FROM catalog_creatures WHERE name_de = 'Salamander'
UNION ALL
SELECT id, 'D4', 'Windstoß', '1W4 Schaden, Ziel wird 2 m zurückgestoßen.' FROM catalog_creatures WHERE name_de = 'Sylphe'
UNION ALL
SELECT id, 'D6', 'Wasserpeitsche', '1W6 Schaden; bei Erfolg gilt das Ziel bis zum nächsten Zug als durchnässt (Nachteil auf Feuer-Proben gegen es).' FROM catalog_creatures WHERE name_de = 'Undine';

INSERT INTO catalog_spells (name_de, type, school_id, components_de, casting_time_de, range_de, duration_de, wp_note_de, effect_de) VALUES
    ('Elementar beschwören', 'spell',
        (SELECT id FROM catalog_schools WHERE name_de = 'Elementarismus'),
        'Wort, Geste, Zutat (ein Klumpen des jeweiligen Elements)', 'Aktion', '10 m', '1 Weile', '3 WP je Kraftstufe',
        'Du beschwörst einen kleinen Elementargeist passend zur Umgebung: Gnom (Erde), Salamander (Feuer), Sylphe (Luft) oder Undine (Wasser). Der Geist kämpft und gehorcht dir treu, bis der Zauber endet oder er auf 0 TP fällt. Je weiterer Kraftstufe kannst du einen zusätzlichen Elementargeist beschwören.');

-- ============================================================
-- D) Item catalog completion
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Parierdolch', 'Ein schmaler Dolch, eigens zum Parieren geformt.', 'ungewöhnlich', 2, 0, 0, 'weapon'),
    ('Morgenstern', 'Ein Streitkolben mit metallenem, dornenbesetztem Kopf.', 'ungewöhnlich', 14, 0, 0, 'weapon'),
    ('Kriegshammer, schwer', 'Ein wuchtiger, beidhändig geführter Kriegshammer.', 'ungewöhnlich', 20, 0, 0, 'weapon'),
    ('Hellebarde', 'Eine lange Stangenwaffe mit Axtklinge und Spitze.', 'selten', 20, 0, 0, 'weapon'),
    ('Schild, groß', 'Ein großer, schwerer Schild.', 'ungewöhnlich', 12, 0, 0, 'weapon'),
    ('Keule', 'Ein einfacher, wuchtiger Streitkolben.', 'gewöhnlich', 8, 0, 0, 'weapon'),
    ('Schwere Armbrust', 'Eine mächtige Armbrust mit großer Durchschlagskraft, aber langsam nachzuladen.', 'selten', 200, 0, 0, 'weapon'),
    ('Handarmbrust', 'Eine kompakte, einhändig zu bedienende Armbrust.', 'selten', 90, 0, 0, 'weapon');

INSERT INTO catalog_item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de) VALUES
    ((SELECT id FROM catalog_items WHERE name_de = 'Parierdolch'), '1-händig', '2', 'W6', 15, 'Unauffällig, Stich, Hieb'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Morgenstern'), '1-händig', '2', '2W8', 12, 'Wucht, Niederwerfend'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Kriegshammer, schwer'), '2-händig', '2', '2W10', 12, 'Wucht, Niederwerfend'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Hellebarde'), '2-händig', '4', '2W8', 12, 'Lang, Niederwerfend, Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Schild, groß'), '1-händig', '2', 'W8', 18, 'Wucht'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Keule'), '1-händig', '2', '2W4', 12, 'Wucht'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Schwere Armbrust'), '2-händig', '60', '2W8', 9, 'Stich, benötigt Köcher'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Handarmbrust'), '1-händig', '30', '2W6', 6, 'Stich, benötigt Köcher');

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Stiefel', 'Robuste Stiefel, die vor manchem Missgeschick auf Reisen schützen.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Umhang', 'Ein wetterfester Umhang.', 'ungewöhnlich', 0, 8, 0, 'misc'),
    ('Feine Gewänder', 'Edle Kleidung für gehobene Anlässe.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    ('Pelzumhang', 'Ein warmer Umhang aus Tierfell.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    ('Lumpen', 'Zerschlissene, ärmliche Kleidung.', 'gewöhnlich', 0, 0, 5, 'misc'),
    ('Einfache Kleidung', 'Schlichte, alltagstaugliche Kleidung.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Dudelsack', 'Ein Sackpfeifeninstrument mit durchdringendem Klang.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    ('Trommel', 'Eine einfache Handtrommel.', 'gewöhnlich', 4, 0, 0, 'misc'),
    ('Harfe', 'Ein aufwendig gebautes Saiteninstrument.', 'ungewöhnlich', 8, 0, 0, 'misc'),
    ('Abakus', 'Ein Rechenbrett mit Kugeln zum Zählen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Wolldecke', 'Eine dicke Wolldecke gegen die Kälte.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Schachspiel', 'Ein geschnitztes Schachspiel.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Würfel', 'Ein Satz Spielwürfel.', 'gewöhnlich', 0, 1, 0, 'misc'),
    ('Feldküche', 'Tragbares Kochgeschirr für unterwegs.', 'gewöhnlich', 4, 0, 0, 'misc'),
    ('Tagesration', 'Getrocknete Vorräte für einen Tag.', 'gewöhnlich', 0, 1, 0, 'misc'),
    ('Feines Diebeswerkzeug', 'Hochwertige Dietriche für heikle Schlösser.', 'selten', 20, 0, 0, 'misc'),
    ('Lupe', 'Eine Lupe zur genauen Untersuchung kleiner Details.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    ('Karte', 'Eine gezeichnete Karte einer Region.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    ('Murmeln', 'Ein Beutel bunter Glasmurmeln.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Vorhängeschloss', 'Ein solides Schloss für Türen oder Truhen.', 'gewöhnlich', 10, 0, 0, 'misc'),
    ('Parfüm (10 Dosen)', 'Ein Fläschchen mit angenehmem Duft.', 'gewöhnlich', 5, 0, 0, 'misc'),
    ('Spielkarten', 'Ein Satz bebilderter Spielkarten.', 'ungewöhnlich', 0, 5, 0, 'misc'),
    ('Seil (Seide), 10m', 'Zehn Meter feines, leichtes Seidenseil.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    ('Sattel', 'Ein Reitsattel für Pferde.', 'gewöhnlich', 10, 0, 0, 'misc'),
    ('Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Öllampe', 'Eine einfache Öllampe.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Talgkerze', 'Eine einfache Kerze aus Talg.', 'gewöhnlich', 0, 0, 1, 'misc'),
    ('Brecheisen', 'Ein stabiles Brecheisen zum Aufbrechen von Türen.', 'gewöhnlich', 9, 0, 0, 'misc'),
    ('Hammer', 'Ein gewöhnlicher Handwerkshammer.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Nadel & Faden', 'Zum Ausbessern von Kleidung.', 'gewöhnlich', 0, 3, 0, 'misc'),
    ('Spitzhacke', 'Ein Werkzeug zum Graben und Abbauen von Gestein.', 'gewöhnlich', 3, 0, 0, 'misc'),
    ('Säge', 'Eine Säge zum Durchtrennen von Holz oder Metall.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    ('Schaufel', 'Eine robuste Schaufel.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Vorschlaghammer', 'Ein schwerer Hammer für grobe Arbeiten.', 'gewöhnlich', 3, 0, 0, 'misc'),
    ('Rucksack', 'Ein geräumiger Rucksack für Ausrüstung.', 'gewöhnlich', 3, 0, 0, 'misc'),
    ('Fass', 'Ein hölzernes Fass.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Korb', 'Ein geflochtener Weidenkorb.', 'gewöhnlich', 0, 4, 0, 'misc'),
    ('Flasche', 'Eine Flasche für Flüssigkeiten.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Eimer', 'Ein einfacher Eimer.', 'gewöhnlich', 0, 0, 5, 'misc'),
    ('Truhe', 'Eine verschließbare Holztruhe.', 'gewöhnlich', 5, 0, 0, 'misc'),
    ('Tonkrug', 'Ein Krug aus gebranntem Ton.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Satteltasche', 'Eine Tasche zur Befestigung am Sattel.', 'gewöhnlich', 6, 0, 0, 'misc'),
    ('Kreide', 'Ein Stück Kreide zum Zeichnen magischer Symbole.', 'gewöhnlich', 0, 0, 1, 'misc'),
    ('Sanduhr', 'Eine Sanduhr zur präzisen Zeitmessung.', 'selten', 25, 0, 0, 'misc'),
    ('Papier (Blatt)', 'Ein Blatt hochwertiges Papier.', 'ungewöhnlich', 0, 2, 0, 'misc'),
    ('Pergament (Blatt)', 'Ein Blatt Pergament.', 'gewöhnlich', 0, 1, 0, 'misc'),
    ('Reliquiar', 'Ein kleiner Schrein für ein geweihtes Andenken.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    ('Falle/Schlinge, groß', 'Eine kräftige Falle für größeres Wild.', 'ungewöhnlich', 3, 0, 0, 'misc'),
    ('Angel', 'Eine einfache Angelrute.', 'gewöhnlich', 0, 8, 0, 'misc'),
    ('Fischernetz', 'Ein Netz zum Fischfang.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Schlinge', 'Eine einfache Drahtschlinge, nur einmal verwendbar.', 'gewöhnlich', 0, 0, 5, 'misc'),
    ('Kanu', 'Ein schmales, wendiges Kanu.', 'gewöhnlich', 6, 0, 0, 'misc'),
    ('Ruderboot', 'Ein einfaches Ruderboot.', 'gewöhnlich', 15, 0, 0, 'misc'),
    ('Segelboot', 'Ein kleines Segelboot für Küstenfahrten.', 'ungewöhnlich', 40, 0, 0, 'misc'),
    ('Planwagen', 'Ein von zwei Zugtieren gezogener Wagen.', 'gewöhnlich', 30, 0, 0, 'misc'),
    ('Huhn', 'Liefert eine Ration Fleisch, wenn geschlachtet.', 'gewöhnlich', 0, 4, 0, 'misc'),
    ('Kuh', 'Liefert täglich Milch und viel Fleisch, wenn geschlachtet.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    ('Wachhund', 'Ein treuer Wächter für Haus und Hof.', 'gewöhnlich', 15, 0, 0, 'misc'),
    ('Brieftaube (im Käfig)', 'Fliegt zu ihrem Schlag zurück, egal woher sie freigelassen wird.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Schwein', 'Liefert reichlich Fleisch, wenn geschlachtet.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Reitpferd', 'Ein gut abgerichtetes Reitpferd.', 'ungewöhnlich', 60, 0, 0, 'misc'),
    ('Schaf', 'Liefert Fleisch und Wolle.', 'gewöhnlich', 3, 0, 0, 'misc'),
    ('Gift, tödlich (Dosis)', 'Ein tödliches Gift.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Gift, lähmend (Dosis)', 'Ein lähmendes Gift.', 'ungewöhnlich', 1, 2, 0, 'misc'),
    ('Gift, einschläfernd (Dosis)', 'Ein einschläferndes Gift.', 'ungewöhnlich', 0, 6, 0, 'misc'),
    ('Kräutersud (Dosis)', 'Ein Sud aus Heilkräutern gegen Krankheiten.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    ('Heiltrank (Dosis)', 'Ein magischer Trank, der Wunden augenblicklich heilt.', 'selten', 50, 0, 0, 'misc'),
    ('Chirurgenbesteck', 'Feines Werkzeug für schwierige Heilkunde-Proben.', 'ungewöhnlich', 15, 0, 0, 'misc');
