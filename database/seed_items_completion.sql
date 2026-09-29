SET NAMES utf8mb4;

-- Vervollständigung des Item-Katalogs anhand der vollen Ausrüstungskapitel-
-- Screenshots in docs/bilder/ (Waffen/Rüstung waren schon größtenteils
-- vorhanden; hier kommen die restlichen Waffen sowie alle bisher fehlenden
-- Kategorien dazu: Kleidung, Musikinstrumente, Handelswaren, Lichtquellen,
-- Werkzeuge, Behälter, Studien & Magie, Jagd & Fischen, Transportmittel,
-- Tiere, Medizin). Bereits vorhandene Items (z.B. Dolch, Streitaxt, Fackel,
-- Laterne, Notizbuch, Bandagen) werden nicht erneut angelegt.

-- ============================================================
-- Restliche Waffen
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

-- ============================================================
-- Kleidung
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Stiefel', 'Robuste Stiefel, die vor manchem Missgeschick auf Reisen schützen.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Umhang', 'Ein wetterfester Umhang.', 'ungewöhnlich', 0, 8, 0, 'misc'),
    ('Feine Gewänder', 'Edle Kleidung für gehobene Anlässe.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    ('Pelzumhang', 'Ein warmer Umhang aus Tierfell.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    ('Lumpen', 'Zerschlissene, ärmliche Kleidung.', 'gewöhnlich', 0, 0, 5, 'misc'),
    ('Einfache Kleidung', 'Schlichte, alltagstaugliche Kleidung.', 'gewöhnlich', 0, 5, 0, 'misc');

-- ============================================================
-- Musikinstrumente (Leier/Flöte/Horn existieren bereits)
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Dudelsack', 'Ein Sackpfeifeninstrument mit durchdringendem Klang.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    ('Trommel', 'Eine einfache Handtrommel.', 'gewöhnlich', 4, 0, 0, 'misc'),
    ('Harfe', 'Ein aufwendig gebautes Saiteninstrument.', 'ungewöhnlich', 8, 0, 0, 'misc');

-- ============================================================
-- Handelswaren
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
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
    ('Sattel', 'Ein Reitsattel für Pferde.', 'gewöhnlich', 10, 0, 0, 'misc');

-- ============================================================
-- Lichtquellen (Fackel/Laterne/Lampenöl existieren bereits)
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Öllampe', 'Eine einfache Öllampe.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Talgkerze', 'Eine einfache Kerze aus Talg.', 'gewöhnlich', 0, 0, 1, 'misc');

-- ============================================================
-- Werkzeuge (Schmiede-/Zimmermanns-/Gerberwerkzeug existieren bereits)
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Brecheisen', 'Ein stabiles Brecheisen zum Aufbrechen von Türen.', 'gewöhnlich', 9, 0, 0, 'misc'),
    ('Hammer', 'Ein gewöhnlicher Handwerkshammer.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Nadel & Faden', 'Zum Ausbessern von Kleidung.', 'gewöhnlich', 0, 3, 0, 'misc'),
    ('Spitzhacke', 'Ein Werkzeug zum Graben und Abbauen von Gestein.', 'gewöhnlich', 3, 0, 0, 'misc'),
    ('Säge', 'Eine Säge zum Durchtrennen von Holz oder Metall.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    ('Schaufel', 'Eine robuste Schaufel.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Vorschlaghammer', 'Ein schwerer Hammer für grobe Arbeiten.', 'gewöhnlich', 3, 0, 0, 'misc');

-- ============================================================
-- Behälter
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Rucksack', 'Ein geräumiger Rucksack für Ausrüstung.', 'gewöhnlich', 3, 0, 0, 'misc'),
    ('Fass', 'Ein hölzernes Fass.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Korb', 'Ein geflochtener Weidenkorb.', 'gewöhnlich', 0, 4, 0, 'misc'),
    ('Flasche', 'Eine Flasche für Flüssigkeiten.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Eimer', 'Ein einfacher Eimer.', 'gewöhnlich', 0, 0, 5, 'misc'),
    ('Truhe', 'Eine verschließbare Holztruhe.', 'gewöhnlich', 5, 0, 0, 'misc'),
    ('Tonkrug', 'Ein Krug aus gebranntem Ton.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Satteltasche', 'Eine Tasche zur Befestigung am Sattel.', 'gewöhnlich', 6, 0, 0, 'misc');

-- ============================================================
-- Studien & Magie (Notizbuch/Feder/Orduculum/Zauberstab/Amulett/Grimoire/
-- Buch existieren bereits)
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Kreide', 'Ein Stück Kreide zum Zeichnen magischer Symbole.', 'gewöhnlich', 0, 0, 1, 'misc'),
    ('Sanduhr', 'Eine Sanduhr zur präzisen Zeitmessung.', 'selten', 25, 0, 0, 'misc'),
    ('Papier (Blatt)', 'Ein Blatt hochwertiges Papier.', 'ungewöhnlich', 0, 2, 0, 'misc'),
    ('Pergament (Blatt)', 'Ein Blatt Pergament.', 'gewöhnlich', 0, 1, 0, 'misc'),
    ('Reliquiar', 'Ein kleiner Schrein für ein geweihtes Andenken.', 'ungewöhnlich', 5, 0, 0, 'misc');

-- ============================================================
-- Jagd & Fischen
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Falle/Schlinge, groß', 'Eine kräftige Falle für größeres Wild.', 'ungewöhnlich', 3, 0, 0, 'misc'),
    ('Angel', 'Eine einfache Angelrute.', 'gewöhnlich', 0, 8, 0, 'misc'),
    ('Fischernetz', 'Ein Netz zum Fischfang.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Schlinge', 'Eine einfache Drahtschlinge, nur einmal verwendbar.', 'gewöhnlich', 0, 0, 5, 'misc');

-- ============================================================
-- Transportmittel (Karren/Kampfpferd/Esel existieren bereits)
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Kanu', 'Ein schmales, wendiges Kanu.', 'gewöhnlich', 6, 0, 0, 'misc'),
    ('Ruderboot', 'Ein einfaches Ruderboot.', 'gewöhnlich', 15, 0, 0, 'misc'),
    ('Segelboot', 'Ein kleines Segelboot für Küstenfahrten.', 'ungewöhnlich', 40, 0, 0, 'misc'),
    ('Planwagen', 'Ein von zwei Zugtieren gezogener Wagen.', 'gewöhnlich', 30, 0, 0, 'misc');

-- ============================================================
-- Tiere (Esel/Kampfpferd existieren bereits)
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Huhn', 'Liefert eine Ration Fleisch, wenn geschlachtet.', 'gewöhnlich', 0, 4, 0, 'misc'),
    ('Kuh', 'Liefert täglich Milch und viel Fleisch, wenn geschlachtet.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    ('Wachhund', 'Ein treuer Wächter für Haus und Hof.', 'gewöhnlich', 15, 0, 0, 'misc'),
    ('Brieftaube (im Käfig)', 'Fliegt zu ihrem Schlag zurück, egal woher sie freigelassen wird.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Schwein', 'Liefert reichlich Fleisch, wenn geschlachtet.', 'gewöhnlich', 2, 0, 0, 'misc'),
    ('Reitpferd', 'Ein gut abgerichtetes Reitpferd.', 'ungewöhnlich', 60, 0, 0, 'misc'),
    ('Schaf', 'Liefert Fleisch und Wolle.', 'gewöhnlich', 3, 0, 0, 'misc');

-- ============================================================
-- Medizin
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Gift, tödlich (Dosis)', 'Ein tödliches Gift.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Gift, lähmend (Dosis)', 'Ein lähmendes Gift.', 'ungewöhnlich', 1, 2, 0, 'misc'),
    ('Gift, einschläfernd (Dosis)', 'Ein einschläferndes Gift.', 'ungewöhnlich', 0, 6, 0, 'misc'),
    ('Kräutersud (Dosis)', 'Ein Sud aus Heilkräutern gegen Krankheiten.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    ('Heiltrank (Dosis)', 'Ein magischer Trank, der Wunden augenblicklich heilt.', 'selten', 50, 0, 0, 'misc'),
    ('Chirurgenbesteck', 'Feines Werkzeug für schwierige Heilkunde-Proben.', 'ungewöhnlich', 15, 0, 0, 'misc');
