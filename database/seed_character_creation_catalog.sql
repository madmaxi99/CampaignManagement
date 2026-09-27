SET NAMES utf8mb4;

-- Reference data for the character creation wizard.
-- See docs/superpowers/specs/2026-09-27-character-creation-wizard-design.md
-- for sources: user-provided rules, the 7 existing pregens in seed_pregens.sql,
-- and screenshots of the full (English) Dragonbane core rulebook.

-- ============================================================
-- New catalog items needed for the wizard's (simplified) starting gear
-- ============================================================

INSERT INTO items (name_de, description_de, rarity, price_copper, kind) VALUES
    ('Kurzbogen', 'Ein kompakter Bogen, leichter zu handhaben als ein Langbogen.', 'gewöhnlich', 90, 'weapon'),
    ('Langschwert', 'Ein robustes, vielseitiges Schwert.', 'gewöhnlich', 160, 'weapon'),
    ('Schleuder', 'Eine einfache Schleuder für Wurfgeschosse.', 'gewöhnlich', 15, 'weapon');

INSERT INTO item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de) VALUES
    ((SELECT id FROM items WHERE name_de = 'Kurzbogen'), '2-händig', '30', 'W10', 3, 'Stich, benötigt Köcher'),
    ((SELECT id FROM items WHERE name_de = 'Langschwert'), '1-händig', '2', '2W6', 12, 'Stich, Hieb'),
    ((SELECT id FROM items WHERE name_de = 'Schleuder'), '1-händig', '20', 'W8', 20, 'Wucht');

-- Weitere Ausrüstungsoptionen B/C (siehe unten), gefunden via Screenshot-Recherche
-- des vollen Ausrüstungskapitels (Kapitel 2, S.16-23). Stats hier ebenfalls grob
-- an die bestehende Preis-/Wertskala angepasst (nicht 1:1 RAW), analog zu den
-- schon vorhandenen Items oben -- keine Erfindung der Auswahlmöglichkeiten selbst,
-- die sind screenshot-verifiziert.
INSERT INTO items (name_de, description_de, rarity, price_copper, kind) VALUES
    ('Breitschwert', 'Ein breites, kräftiges Schwert.', 'gewöhnlich', 150, 'weapon'),
    ('Dreschflegel', 'Ein Kriegsflegel, ursprünglich ein Dreschwerkzeug.', 'gewöhnlich', 90, 'weapon'),
    ('Lanze', 'Eine lange Reiterlanze für den berittenen Kampf.', 'gewöhnlich', 140, 'weapon'),
    ('Leichte Armbrust', 'Eine kompakte Armbrust, schneller nachzuladen als schwere Modelle.', 'gewöhnlich', 110, 'weapon'),
    ('Dreizack', 'Eine dreizackige Stichwaffe, beliebt bei Seefahrern.', 'gewöhnlich', 90, 'weapon'),
    ('Offener Helm', 'Ein einfacher Helm, der das Gesicht frei lässt.', 'gewöhnlich', 60, 'armor'),
    ('Großhelm', 'Ein massiver, geschlossener Helm.', 'gewöhnlich', 120, 'armor'),
    ('Kampfpferd', 'Ein für den Kampf abgerichtetes Pferd.', 'ungewöhnlich', 600, 'misc'),
    ('Esel', 'Ein robustes Lasttier.', 'gewöhnlich', 150, 'misc'),
    ('Karren', 'Ein einfacher Handkarren zum Transport von Waren.', 'gewöhnlich', 200, 'misc');

INSERT INTO item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de) VALUES
    ((SELECT id FROM items WHERE name_de = 'Breitschwert'), '1-händig', '2', '2W6', 12, 'Stich, Hieb'),
    ((SELECT id FROM items WHERE name_de = 'Dreschflegel'), '1-händig', '2', '2W6', 6, 'Wucht'),
    ((SELECT id FROM items WHERE name_de = 'Lanze'), '2-händig', '4', '2W8', 6, 'Lang, Stich, nur beritten'),
    ((SELECT id FROM items WHERE name_de = 'Leichte Armbrust'), '2-händig', '40', 'W10', 6, 'Stich'),
    ((SELECT id FROM items WHERE name_de = 'Dreizack'), '1-händig', '4', '2W6', 9, 'Stich, Lang');

INSERT INTO item_armor (item_id, slot, armor_value, penalty_skills_de) VALUES
    ((SELECT id FROM items WHERE name_de = 'Offener Helm'), 'head', 1, NULL),
    ((SELECT id FROM items WHERE name_de = 'Großhelm'), 'head', 2, 'Wahrnehmung');

-- ============================================================
-- Kins
-- ============================================================

INSERT INTO kins (code, name_de, d12_min, d12_max, movement_base) VALUES
    ('mensch', 'Mensch', 1, 4, 10),
    ('halbling', 'Halbling', 5, 7, 8),
    ('zwerg', 'Zwerg', 8, 9, 8),
    ('elf', 'Elf', 10, 10, 10),
    ('ente', 'Ente', 11, 11, 8),
    ('wolfsmensch', 'Wolfsmensch', 12, 12, 12);

INSERT INTO kin_heroic_abilities (kin_code, name_de, wp_note_de, description_de) VALUES
    ('mensch', 'Anpassungsfähig', '3', 'Bei einer Fertigkeitsprobe kannst du dich entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen. Du musst allerdings erklären können, wie die gewählte Fertigkeit die ursprüngliche ersetzen kann. Die Spielleitung hat dabei das letzte Wort, sollte aber großzügig sein.'),
    ('halbling', 'Schwer zu fassen', '3', 'Du kannst dieses Talent aktivieren, wenn du einem Angriff ausweichst, um einen Vorteil auf deine Ausweichen-Probe zu erhalten.'),
    ('zwerg', 'Nachtragend', '3', 'Du kannst dieses Talent aktivieren, wenn du jemanden angreifst, der dir in der Vergangenheit geschadet hat (mindestens 1 Schadenspunkt), und erhältst einen Vorteil auf den Wurf. Es spielt keine Rolle, wann der Schaden zugefügt wurde. Es kann klug sein, sich die Namen aller zu notieren, die einem geschadet haben, um sie nicht zu vergessen.'),
    ('elf', 'Innerer Frieden', NULL, 'Als Elf kannst du während einer kurzen Rast meditieren. Du heilst einen zusätzlichen W6 TP sowie einen weiteren W6 WP, außerdem kannst du dich von einem zusätzlichen Zustand erholen. Während der Meditation bist du völlig regungslos und kannst nicht aufgeweckt werden.'),
    ('ente', 'Übellaunig', '3', 'Enten neigen zu einem cholerischen Temperament. Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine Fertigkeitsprobe ablegst, und erhältst einen Vorteil auf den Wurf. Zusätzlich wirst du wütend, falls du es nicht bereits bist. Dieses Talent kann nicht für Proben auf INT oder INT-basierte Fertigkeiten verwendet werden.'),
    ('ente', 'Schwimmhäute', NULL, 'Als Ente erhältst du außerdem einen Vorteil auf alle Schwimmen-Proben. Du bewegst dich an der Wasseroberfläche oder unter Wasser stets mit voller Geschwindigkeit.'),
    ('wolfsmensch', 'Jagdinstinkt', '3', 'Du kannst dieses Talent aktivieren, um eine Kreatur in Sichtweite oder deren Geruch du wahrnehmen kannst, als deine Beute zu markieren. Dies zählt im Kampf als eine Aktion. Du kannst der Fährte deiner Beute einen ganzen Tag lang folgen und zusätzlich 1 WP ausgeben (keine Aktion), um einen Vorteil auf einen Angriff gegen deine Beute zu erhalten.');

-- ============================================================
-- Professions (only the 7 already used by the existing pregens)
-- ============================================================

INSERT INTO professions (code, name_de, key_attribute_code, kin_restriction) VALUES
    ('kaempfer', 'Kämpfer', 'STA', NULL),
    ('zwergenkaempfer', 'Zwergenkämpfer', 'STA', 'zwerg'),
    ('jaeger', 'Jäger', 'GEW', NULL),
    ('ritter', 'Ritter', 'STA', NULL),
    ('seefahrerin', 'Seefahrerin', 'GEW', NULL),
    ('haendler', 'Händler', 'CHA', NULL),
    ('dieb', 'Dieb', 'GEW', NULL);

-- Skill pools: 8 options per profession, the player picks exactly 6.
-- Zwergenkämpfer shares the Kämpfer pool (see spec: not a distinct RAW profession).

INSERT INTO profession_key_skills (profession_code, skill_id)
SELECT 'kaempfer', id FROM skills WHERE name_de IN ('Äxte', 'Bögen', 'Prügelei', 'Armbrüste', 'Ausweichen', 'Hämmer', 'Speere', 'Schwerter')
UNION ALL
SELECT 'zwergenkaempfer', id FROM skills WHERE name_de IN ('Äxte', 'Bögen', 'Prügelei', 'Armbrüste', 'Ausweichen', 'Hämmer', 'Speere', 'Schwerter')
UNION ALL
SELECT 'jaeger', id FROM skills WHERE name_de IN ('Akrobatik', 'Wahrnehmung', 'Bögen', 'Wildnisleben', 'Jagen & Fischen', 'Messer', 'Schleudern', 'Heimlichkeit')
UNION ALL
SELECT 'ritter', id FROM skills WHERE name_de IN ('Bestienkunde', 'Hämmer', 'Mythen & Legenden', 'Darbietung', 'Überzeugen', 'Reiten', 'Speere', 'Schwerter')
UNION ALL
SELECT 'seefahrerin', id FROM skills WHERE name_de IN ('Akrobatik', 'Wahrnehmung', 'Jagen & Fischen', 'Messer', 'Fremdsprachen', 'Seefahrt', 'Schwimmen', 'Schwerter')
UNION ALL
SELECT 'haendler', id FROM skills WHERE name_de IN ('Wahrnehmung', 'Feilschen', 'Täuschen', 'Ausweichen', 'Messer', 'Überzeugen', 'Fingerfertigkeit', 'Entdecken')
UNION ALL
SELECT 'dieb', id FROM skills WHERE name_de IN ('Akrobatik', 'Wahrnehmung', 'Täuschen', 'Ausweichen', 'Messer', 'Fingerfertigkeit', 'Heimlichkeit', 'Entdecken');

-- Each profession grants exactly one fixed heroic ability at creation (RAW).

INSERT INTO profession_heroic_abilities (profession_code, granted_at_creation, name_de, requirement_de, wp_note_de, description_de) VALUES
    ('kaempfer', 1, 'Veteran', 'Beliebige Waffenfertigkeit 12', '1', 'Wenn du dieses Talent zu Beginn einer Kampfrunde aktivierst, kannst du deine Initiativekarte aus der letzten Runde behalten, anstatt eine neue zu ziehen. Das zählt nicht als Aktion.'),
    ('zwergenkaempfer', 1, 'Veteran', 'Beliebige Waffenfertigkeit 12', '1', 'Wenn du dieses Talent zu Beginn einer Kampfrunde aktivierst, kannst du deine Initiativekarte aus der letzten Runde behalten, anstatt eine neue zu ziehen. Das zählt nicht als Aktion.'),
    ('jaeger', 1, 'Gefährte', 'Jagen & Fischen 12', '3', 'Du kannst dieses Talent aktivieren, um ein Tier (kein Monster) zu deinem Gefährten zu machen. Das dauert eine Weile, und du kannst immer nur einen Tiergefährten gleichzeitig haben. Die Spielleitung entscheidet, welche Tiere in der Nähe sind. Das Tier folgt dir, solange du dich in seiner natürlichen Umgebung aufhältst, und kann für dich ohne zusätzliche WP-Kosten aufklären. Für 3 weitere WP kannst du dem Tier befehlen, einen Feind anzugreifen (das kostet dich keine Aktion).'),
    ('ritter', 1, 'Beschützer', 'Äxte, Hämmer oder Schwerter 12', '2', 'Du zögerst nicht, einen Treffer für deine Freunde einzustecken. Wenn du und ein anderer Spielercharakter innerhalb von zwei Metern zum selben Feind seid und der Feind den anderen Charakter zu treffen versucht, kannst du dieses Talent aktivieren, um den Feind zu zwingen, stattdessen dich zu attackieren.'),
    ('seefahrerin', 1, 'Seebeine', 'Schwimmen 12', '1', 'Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine Aktion im Wasser ausführst, selbst wenn es nur hüfttief ist. Daraufhin bist du eine Runde lang gegen alle negativen Effekte geschützt, die üblicherweise im Wasser auftreten, einschließlich der Gefahr, zu ertrinken.'),
    ('haendler', 1, 'Goldnase', 'Feilschen 12', '3', 'Du kannst dieses Talent aktivieren, wenn du an einem Scheideweg bist, um herauszufinden, welcher Weg oder welche Entscheidung dich zu den größten Reichtümern führt.'),
    ('dieb', 1, 'Hinterhältig', 'Messer 12', '3', 'Du kannst dieses Talent bei einem Nahkampfangriff aktivieren, wenn sich dein Gegner innerhalb von 2 Metern zu einem anderen Spielercharakter befindet. Dein Angriff zählt dann als Schleichangriff, das heißt, er kann nicht ausgewichen oder pariert werden, du erhältst einen Nachteil auf den Wurf, und die Anzahl der Schadenswürfel erhöht sich um eins (2W8 statt W8). Dieses Talent kann nur mit unauffälligen Waffen eingesetzt werden.'),
    -- Zusätzliche Talente, die in den bestehenden Pregens auftauchen, aber laut
    -- Regelwerk nicht die automatische Start-Vergabe sind (vermutlich schon
    -- "dazugewonnene" Talente aus Weiterentwicklung). Auf Wunsch des Nutzers
    -- trotzdem katalogisiert, für spätere Aufleveln-Auswahl.
    ('jaeger', 0, 'Doppelschuss', 'Bögen 12', '3', 'Wenn du bei einem Angriff mit dem Bogen dieses Talent aktivierst, kannst du zwei Pfeile gleichzeitig abschießen. Du würfelst nur einmal auf Treffer, mit einem Nachteil; der Schaden wird für beide Pfeile separat gewürfelt. Die Pfeile können auf dasselbe oder zwei verschiedene Ziele gerichtet werden.'),
    ('kaempfer', 0, 'Furchtlos', NULL, '2', 'Du widerstehst von vornherein Furchtangriffen, ohne eine WIL-Probe ablegen zu müssen.'),
    ('zwergenkaempfer', 0, 'Furchtlos', NULL, '2', 'Du widerstehst von vornherein Furchtangriffen, ohne eine WIL-Probe ablegen zu müssen.');

-- Starting gear: all 3 official W6 equipment options (A=1-2, B=3-4, C=5-6) per
-- profession, screenshot-verified against the full rulebook's equipment
-- chapter (Kapitel 2, S.16-23). Where the book offers an "either/or" weapon
-- choice within one option (e.g. Kämpfer 1-2: Streitaxt/Kriegshammer/
-- Morgenstern), only the first-listed weapon is modeled -- the wizard doesn't
-- support an in-option sub-choice, so this is a deliberate simplification, not
-- a misreading. Small consumables/currency (rations, silver, torch, rope,
-- etc.) that don't need structured catalog items live in `extra_de` as
-- freetext, same convention as `misc_items_de` elsewhere in this project.

-- Start-Silber ist NICHT mehr Teil von extra_de -- der Spieler würfelt am
-- Tisch und trägt das Ergebnis im Wizard ein (siehe starting_silver_dice,
-- CharacterCreationRepository::createCharacter()).
INSERT INTO profession_gear_options (profession_code, option_label, extra_de, starting_silver_dice) VALUES
    ('kaempfer', 'A', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    ('zwergenkaempfer', 'A', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    ('kaempfer', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    ('zwergenkaempfer', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    ('kaempfer', 'C', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    ('zwergenkaempfer', 'C', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    ('jaeger', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, Falle/Schlinge, W8 Tagesrationen', 'W6'),
    ('jaeger', 'B', 'Schlafpelz, Seil (Hanf), Angel, W6 Tagesrationen', NULL),
    ('jaeger', 'C', 'Schlafpelz, Falle/Schlinge, Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W6'),
    ('ritter', 'A', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W12'),
    ('ritter', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W12'),
    ('ritter', 'C', 'W6 Tagesrationen', 'W12'),
    ('seefahrerin', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    ('seefahrerin', 'B', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    ('seefahrerin', 'C', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    ('haendler', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W12'),
    ('haendler', 'B', 'Schlafpelz, Feldküche, Lampenöl, Feuerstein & Zunder', 'W12'),
    ('haendler', 'C', 'Schlafpelz, großes Zelt, Öllampe, Lampenöl, Feuerstein & Zunder, Rucksack, W6 Tagesrationen', 'W12'),
    ('dieb', 'A', 'Fackel, Feuerstein & Zunder, W10 Tagesrationen', 'W10'),
    ('dieb', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W10'),
    ('dieb', 'C', 'Murmeln, Fackel, Feuerstein & Zunder, W10 Tagesrationen', 'W10');

INSERT INTO profession_gear_option_items (gear_option_id, item_id, quantity)
SELECT go.id, i.id, gear.qty
FROM profession_gear_options go
JOIN (
    SELECT 'kaempfer' AS profession_code, 'A' AS option_label, 'Streitaxt' AS name_de, 1 AS qty UNION ALL
    SELECT 'kaempfer', 'A', 'Schild, klein', 1 UNION ALL
    SELECT 'kaempfer', 'A', 'Kettenpanzer', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'A', 'Streitaxt', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'A', 'Schild, klein', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'A', 'Kettenpanzer', 1 UNION ALL
    SELECT 'kaempfer', 'B', 'Kurzschwert', 1 UNION ALL
    SELECT 'kaempfer', 'B', 'Leichte Armbrust', 1 UNION ALL
    SELECT 'kaempfer', 'B', 'Köcher', 1 UNION ALL
    SELECT 'kaempfer', 'B', 'Lederrüstung', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'B', 'Kurzschwert', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'B', 'Leichte Armbrust', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'B', 'Köcher', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'B', 'Lederrüstung', 1 UNION ALL
    SELECT 'kaempfer', 'C', 'Langspeer', 1 UNION ALL
    SELECT 'kaempfer', 'C', 'Beschlagenes Leder', 1 UNION ALL
    SELECT 'kaempfer', 'C', 'Offener Helm', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'C', 'Langspeer', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'C', 'Beschlagenes Leder', 1 UNION ALL
    SELECT 'zwergenkaempfer', 'C', 'Offener Helm', 1 UNION ALL
    SELECT 'jaeger', 'A', 'Dolch', 1 UNION ALL
    SELECT 'jaeger', 'A', 'Kurzbogen', 1 UNION ALL
    SELECT 'jaeger', 'A', 'Köcher', 1 UNION ALL
    SELECT 'jaeger', 'A', 'Lederrüstung', 1 UNION ALL
    SELECT 'jaeger', 'B', 'Messer', 1 UNION ALL
    SELECT 'jaeger', 'B', 'Langbogen', 1 UNION ALL
    SELECT 'jaeger', 'B', 'Köcher', 1 UNION ALL
    SELECT 'jaeger', 'B', 'Lederrüstung', 1 UNION ALL
    SELECT 'jaeger', 'C', 'Dolch', 1 UNION ALL
    SELECT 'jaeger', 'C', 'Schleuder', 1 UNION ALL
    SELECT 'jaeger', 'C', 'Lederrüstung', 1 UNION ALL
    -- Ritter Option A: das Buch nennt hier "Breitschwert oder Morgenstern",
    -- nicht "Langschwert" -- ursprünglich falsch geseedet, hier korrigiert.
    SELECT 'ritter', 'A', 'Breitschwert', 1 UNION ALL
    SELECT 'ritter', 'A', 'Schild, klein', 1 UNION ALL
    SELECT 'ritter', 'A', 'Plattenpanzer', 1 UNION ALL
    SELECT 'ritter', 'A', 'Großhelm', 1 UNION ALL
    SELECT 'ritter', 'B', 'Dreschflegel', 1 UNION ALL
    SELECT 'ritter', 'B', 'Schild, klein', 1 UNION ALL
    SELECT 'ritter', 'B', 'Kettenpanzer', 1 UNION ALL
    SELECT 'ritter', 'B', 'Offener Helm', 1 UNION ALL
    SELECT 'ritter', 'C', 'Kurzschwert', 1 UNION ALL
    SELECT 'ritter', 'C', 'Lanze', 1 UNION ALL
    SELECT 'ritter', 'C', 'Schild, klein', 1 UNION ALL
    SELECT 'ritter', 'C', 'Kettenpanzer', 1 UNION ALL
    SELECT 'ritter', 'C', 'Offener Helm', 1 UNION ALL
    SELECT 'ritter', 'C', 'Kampfpferd', 1 UNION ALL
    SELECT 'seefahrerin', 'A', 'Dolch', 1 UNION ALL
    SELECT 'seefahrerin', 'A', 'Kurzbogen', 1 UNION ALL
    SELECT 'seefahrerin', 'A', 'Köcher', 1 UNION ALL
    SELECT 'seefahrerin', 'A', 'Wurfhaken', 1 UNION ALL
    SELECT 'seefahrerin', 'A', 'Seil (Hanf), 10m', 1 UNION ALL
    SELECT 'seefahrerin', 'B', 'Krummsäbel', 1 UNION ALL
    SELECT 'seefahrerin', 'B', 'Lederrüstung', 1 UNION ALL
    SELECT 'seefahrerin', 'B', 'Seil (Hanf), 10m', 1 UNION ALL
    SELECT 'seefahrerin', 'B', 'Wurfhaken', 1 UNION ALL
    SELECT 'seefahrerin', 'C', 'Dreizack', 1 UNION ALL
    SELECT 'seefahrerin', 'C', 'Fernrohr', 1 UNION ALL
    SELECT 'seefahrerin', 'C', 'Seil (Hanf), 10m', 1 UNION ALL
    SELECT 'seefahrerin', 'C', 'Wurfhaken', 1 UNION ALL
    SELECT 'haendler', 'A', 'Dolch', 1 UNION ALL
    SELECT 'haendler', 'A', 'Seil (Hanf), 10m', 1 UNION ALL
    SELECT 'haendler', 'B', 'Messer', 1 UNION ALL
    SELECT 'haendler', 'B', 'Laterne', 1 UNION ALL
    SELECT 'haendler', 'B', 'Esel', 1 UNION ALL
    SELECT 'haendler', 'B', 'Karren', 1 UNION ALL
    SELECT 'haendler', 'C', 'Dolch', 1 UNION ALL
    SELECT 'dieb', 'A', 'Dolch', 1 UNION ALL
    SELECT 'dieb', 'A', 'Schleuder', 1 UNION ALL
    SELECT 'dieb', 'A', 'Seil (Hanf), 10m', 1 UNION ALL
    SELECT 'dieb', 'A', 'Wurfhaken', 1 UNION ALL
    SELECT 'dieb', 'B', 'Messer', 1 UNION ALL
    SELECT 'dieb', 'B', 'Dietriche', 1 UNION ALL
    SELECT 'dieb', 'C', 'Dolch', 2 UNION ALL
    SELECT 'dieb', 'C', 'Seil (Hanf), 10m', 1
) gear ON gear.profession_code = go.profession_code AND gear.option_label = go.option_label
JOIN items i ON i.name_de = gear.name_de;

-- ============================================================
-- General heroic abilities (available regardless of profession)
-- ============================================================

INSERT INTO general_heroic_abilities (name_de, requirement_de, wp_note_de, description_de) VALUES
    ('Robust', NULL, NULL, 'Deine maximalen TP werden dauerhaft um 2 erhöht. Dieses Talent kann beliebig oft gewählt werden, ohne Limit.'),
    ('Fokussiert', NULL, NULL, 'Deine maximalen WP werden dauerhaft um 2 erhöht. Dieses Talent kann beliebig oft gewählt werden, ohne Limit.');

-- ============================================================
-- Flaws (D20)
-- ============================================================

INSERT INTO flaws (roll_min, roll_max, name_de, description_de) VALUES
    (1, 1, 'Leichtgläubig', 'Ich glaube alles, was andere mir erzählen.'),
    (2, 2, 'Gierig', 'Ich will immer einen größeren Anteil an jedem Schatz.'),
    (3, 3, 'Dünnhäutig', 'Ich ertrage keine Provokation.'),
    (4, 4, 'Tollkühn', 'Ich stürze mich stets als erster in Gefahr.'),
    (5, 5, 'Ängstlich', 'Ich halte mich immer im Hintergrund der Gruppe.'),
    (6, 6, 'Monsterjäger', 'Alle Monster sind böse und müssen getötet werden.'),
    (7, 7, 'Voreingenommen', 'Nachtvolk wie Orks und Goblins ist böse und muss bekämpft werden.'),
    (8, 8, 'Faul', 'Ich nutze jede Gelegenheit, um mich auszuruhen.'),
    (9, 9, 'Verfressen', 'Ich nutze jede Gelegenheit, um etwas Schmackhaftes zu essen.'),
    (10, 10, 'Kleptomanisch', 'Ich kann nicht anders, als Wertgegenstände zu stehlen.'),
    (11, 11, 'Eitel', 'Ich helfe jedem, der mich lobt oder mir Komplimente macht.'),
    (12, 12, 'Unbesonnen', 'Ich gehe immer große Risiken ein, ohne über die Konsequenzen nachzudenken.'),
    (13, 13, 'Magiefeindlich', 'Magie ist eine böse Macht, Magiern kann nicht vertraut werden.'),
    (14, 14, 'Wissbegierig', 'Die Jagd nach Wissen ist mir wichtiger als meine Freunde.'),
    (15, 15, 'Kind der Wildnis', 'Ich schlafe niemals in Innenräumen.'),
    (16, 16, 'Prahlerisch', 'Ich übertreibe stets meine Heldentaten.'),
    (17, 17, 'Gewalttätig', 'Ich greife bei jedem Hindernis zur Gewalt.'),
    (18, 18, 'Anmaßend', 'Ich sage anderen ständig, was sie tun sollen.'),
    (19, 19, 'Pessimistisch', 'Ich glaube immer, dass sich die Dinge zum Schlechteren wenden.'),
    (20, 20, 'Hochnäsig', 'Ich schaue auf jeden herab, den ich treffe.');
