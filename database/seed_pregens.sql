SET NAMES utf8mb4;

-- Additional catalog items needed by the other 7 quickstart pregens.
-- Note: throwable weapons (Dolch, Beil, Kurzspeer, Messer, Dreizack) have a
-- thrown range of "STR" (or "STR×2") meters per the book -- a formula off the
-- wielder's STR score, not a fixed number. range_de stores that formula
-- literally; see seed_weapon_armor_corrections.sql, which also fixes the
-- placeholder prices/durability/traits below to the real RAW values.

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Langbogen', 'Ein großer Bogen für weite Distanzen.', 'gewöhnlich', 1, 5, 0, 'weapon'),
    ('Messer', 'Ein handliches Messer, das auch geworfen werden kann.', 'gewöhnlich', 0, 2, 0, 'weapon'),
    ('Kurzschwert', 'Ein leichtes, einhändig geführtes Schwert.', 'gewöhnlich', 1, 2, 0, 'weapon'),
    ('Schild, klein', 'Ein kleiner, leichter Schild.', 'gewöhnlich', 0, 8, 0, 'weapon'),
    ('Streitaxt', 'Eine schwere einhändige Axt.', 'gewöhnlich', 1, 0, 0, 'weapon'),
    ('Dolch', 'Eine kurze Klinge, unauffällig zu tragen.', 'gewöhnlich', 0, 3, 0, 'weapon'),
    ('Langspeer', 'Ein langer Speer für die erste Kampflinie.', 'gewöhnlich', 0, 6, 0, 'weapon'),
    ('Kurzspeer', 'Ein kurzer, wurfbarer Speer.', 'gewöhnlich', 0, 5, 0, 'weapon'),
    ('Krummsäbel', 'Ein gebogenes, einhändiges Schwert.', 'gewöhnlich', 1, 3, 0, 'weapon'),
    ('Beil', 'Eine kompakte Axt.', 'gewöhnlich', 0, 7, 0, 'weapon'),
    ('Zweihandaxt', 'Eine gewaltige, beidhändig geführte Axt.', 'ungewöhnlich', 1, 8, 0, 'weapon'),
    ('Plattenpanzer', 'Schwere Rüstung aus Metallplatten.', 'selten', 8, 0, 0, 'armor'),
    ('Beschlagenes Leder', 'Lederrüstung mit metallenen Verstärkungen.', 'ungewöhnlich', 2, 5, 0, 'armor'),
    ('Kettenpanzer', 'Rüstung aus verwobenen Metallringen.', 'ungewöhnlich', 4, 0, 0, 'armor'),
    ('Köcher', 'Ein Köcher für Pfeile.', 'gewöhnlich', 0, 1, 5, 'misc'),
    ('Seil (Hanf), 10m', 'Zehn Meter robustes Hanfseil.', 'gewöhnlich', 0, 2, 0, 'misc'),
    ('Laterne', 'Eine Öllaterne.', 'gewöhnlich', 0, 4, 0, 'misc'),
    ('Lampenöl', 'Ein Fläschchen Öl für Laternen.', 'gewöhnlich', 0, 1, 0, 'misc'),
    ('Dietriche', 'Ein Satz Dietriche zum Schlösserknacken.', 'ungewöhnlich', 0, 6, 0, 'misc'),
    ('Wurfhaken', 'Ein Enterhaken mit Seil.', 'gewöhnlich', 0, 3, 5, 'misc'),
    ('Fernrohr', 'Ein Fernrohr für die weite Sicht.', 'ungewöhnlich', 2, 0, 0, 'misc');

INSERT INTO catalog_item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de) VALUES
    ((SELECT id FROM catalog_items WHERE name_de = 'Langbogen'), '2-händig', '100', 'W12', 6, 'Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Messer'), '1-händig', '8', 'W8', 6, 'Unauffällig, Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Kurzschwert'), '1-händig', '2', 'W10', 12, 'Hieb, Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Schild, klein'), '1-händig', '2', 'W8', 15, 'Wucht'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Streitaxt'), '1-händig', '2', '2W8', 9, 'Hieb'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Dolch'), '1-händig', '8', 'W8', 9, 'Unauffällig, Hieb, Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Langspeer'), '2-händig', '4', '2W8', 9, 'Lang, Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Kurzspeer'), '1-händig', '6', 'W10', 9, 'Stich'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Krummsäbel'), '1-händig', '2', '2W6', 12, 'Hieb'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Beil'), '1-händig', '2', '2W6', 9, 'Hieb, Niederwerfend'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Zweihandaxt'), '2-händig', '2', '2W10', 9, 'Hieb, Niederwerfend');

INSERT INTO catalog_item_armor (item_id, slot, armor_value, penalty_skills_de) VALUES
    ((SELECT id FROM catalog_items WHERE name_de = 'Plattenpanzer'), 'body', 6, 'Heimlichkeit, Ausweichen, Akrobatik'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Beschlagenes Leder'), 'body', 2, 'Heimlichkeit, Ausweichen, Akrobatik'),
    ((SELECT id FROM catalog_items WHERE name_de = 'Kettenpanzer'), 'body', 4, 'Heimlichkeit, Ausweichen, Akrobatik');

-- ============================================================
-- Character: Orla Mondsilber (Elf, Erwachsen, Jäger)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'orla_mondsilber', 'Orla Mondsilber', 'elf',
    (SELECT id FROM catalog_age WHERE name_de = 'Erwachsen'),
    'jaeger',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Voreingenommen'),
    'Geschmeidiger und selbstbewusster Gang. Klarer Blick, der jedes Gegenüber misstrauisch mustert. Eifrig und flink im Denken wie Handeln.',
    'Hauer des Trolls, der deine Schwester getötet hat.',
    'images/characters/orla_mondsilber.jpg',
    15, 15, 10, 10, 0, 4, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'orla_mondsilber');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 13 AS value UNION ALL SELECT 'KON', 15 UNION ALL SELECT 'GEW', 17
    UNION ALL SELECT 'INT', 13 UNION ALL SELECT 'WIL', 10 UNION ALL SELECT 'CHA', 9
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 14 AS value UNION ALL SELECT 'Ausweichen', 14
    UNION ALL SELECT 'Bestienkunde', 6 UNION ALL SELECT 'Darbietung', 5
    UNION ALL SELECT 'Entdecken', 6 UNION ALL SELECT 'Feilschen', 7
    UNION ALL SELECT 'Fingerfertigkeit', 7 UNION ALL SELECT 'Fremdsprachen', 6
    UNION ALL SELECT 'Handwerk', 6 UNION ALL SELECT 'Heilkunde', 6
    UNION ALL SELECT 'Heimlichkeit', 14 UNION ALL SELECT 'Jagen & Fischen', 14
    UNION ALL SELECT 'Mythen & Legenden', 6 UNION ALL SELECT 'Reiten', 7
    UNION ALL SELECT 'Schwimmen', 14 UNION ALL SELECT 'Seefahrt', 6
    UNION ALL SELECT 'Täuschen', 5 UNION ALL SELECT 'Überzeugen', 5
    UNION ALL SELECT 'Wahrnehmung', 12 UNION ALL SELECT 'Wildnisleben', 12
    UNION ALL SELECT 'Armbrüste', 7 UNION ALL SELECT 'Äxte', 6
    UNION ALL SELECT 'Bögen', 14 UNION ALL SELECT 'Hämmer', 6
    UNION ALL SELECT 'Messer', 14 UNION ALL SELECT 'Prügelei', 6
    UNION ALL SELECT 'Schleudern', 7 UNION ALL SELECT 'Schwerter', 12
    UNION ALL SELECT 'Speere', 7 UNION ALL SELECT 'Stäbe', 7
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Innerer Frieden', NULL, 'Als Elf kannst du während einer kurzen Rast meditieren. Du heilst einen zusätzlichen W6 TP sowie einen weiteren W6 WP, außerdem kannst du dich von einem zusätzlichen Zustand erholen.'),
    (@char_id, 'Doppelschuss', '3', 'Wenn du bei einem Angriff mit dem Bogen dieses Talent aktivierst, kannst du zwei Pfeile gleichzeitig abschießen.');

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY i.name_de), i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id
WHERE i.name_de IN ('Langbogen', 'Messer');

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head');

INSERT INTO character_armor (character_id, slot, name_de, armor_value, penalty_de)
SELECT @char_id, 'body', i.name_de, a.armor_value, a.penalty_skills_de
FROM catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id
WHERE i.name_de = 'Lederrüstung';

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY name_de), name_de, description_de, 1
FROM catalog_items WHERE name_de IN ('Köcher', 'Fackel', 'Seil (Hanf), 10m', 'Feuerstein & Zunder');

-- ============================================================
-- Character: Makander von Sichelbucht (Ente, Erwachsen, Ritter)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'makander_von_sichelbucht', 'Makander von Sichelbucht', 'ente',
    (SELECT id FROM catalog_age WHERE name_de = 'Erwachsen'),
    'ritter',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Tollkühn'),
    'Stark, stabil und stur. Watschelnder Gang. Schnell wütend, wenn du provoziert wirst, vor allem wenn deine Familie oder Ehre beleidigt wird. Du lächelst selten.',
    'Fein gearbeitete Tabakspfeife aus schwarzem Horn (ein Geschenk deines Vaters).',
    'images/characters/makander_von_sichelbucht.jpg',
    16, 16, 14, 14, 0, 10, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'makander_von_sichelbucht');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 16 AS value UNION ALL SELECT 'KON', 16 UNION ALL SELECT 'GEW', 10
    UNION ALL SELECT 'INT', 12 UNION ALL SELECT 'WIL', 14 UNION ALL SELECT 'CHA', 13
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 10 AS value UNION ALL SELECT 'Ausweichen', 5
    UNION ALL SELECT 'Bestienkunde', 5 UNION ALL SELECT 'Darbietung', 12
    UNION ALL SELECT 'Entdecken', 5 UNION ALL SELECT 'Feilschen', 6
    UNION ALL SELECT 'Fingerfertigkeit', 5 UNION ALL SELECT 'Fremdsprachen', 5
    UNION ALL SELECT 'Handwerk', 7 UNION ALL SELECT 'Heilkunde', 5
    UNION ALL SELECT 'Heimlichkeit', 5 UNION ALL SELECT 'Jagen & Fischen', 5
    UNION ALL SELECT 'Mythen & Legenden', 10 UNION ALL SELECT 'Reiten', 5
    UNION ALL SELECT 'Schwimmen', 5 UNION ALL SELECT 'Seefahrt', 5
    UNION ALL SELECT 'Täuschen', 6 UNION ALL SELECT 'Überzeugen', 12
    UNION ALL SELECT 'Wahrnehmung', 5 UNION ALL SELECT 'Wildnisleben', 5
    UNION ALL SELECT 'Armbrüste', 10 UNION ALL SELECT 'Äxte', 14
    UNION ALL SELECT 'Bögen', 5 UNION ALL SELECT 'Hämmer', 14
    UNION ALL SELECT 'Messer', 5 UNION ALL SELECT 'Prügelei', 14
    UNION ALL SELECT 'Schleudern', 5 UNION ALL SELECT 'Schwerter', 14
    UNION ALL SELECT 'Speere', 14 UNION ALL SELECT 'Stäbe', 5
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Übellaunig', '3', 'Enten haben ein eher cholerisches Gemüt. Du kannst dieses Talent aktivieren, wenn du eine Fertigkeitsprobe ablegst, und bekommst dadurch einen Vorteil auf deinen Wurf. Zusätzlich erhältst du den Zustand Wütend, falls du es nicht bereits bist.'),
    (@char_id, 'Schwimmhäute', NULL, 'Als Ente erhältst du einen Vorteil auf alle Schwimmen-Proben. Du bewegst dich im oder unter Wasser stets mit deiner vollen Geschwindigkeit.'),
    (@char_id, 'Beschützer', '2', 'Du zögerst nicht, einen Treffer für deine Freunde einzustecken. Wenn du und ein anderer Spielercharakter innerhalb von zwei Metern zum selben Feind seid und der Feind den anderen Charakter zu treffen versucht, kannst du dieses Talent aktivieren, um den Feind zu zwingen, stattdessen dich zu attackieren.');

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY i.name_de), i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id
WHERE i.name_de IN ('Streitaxt', 'Kurzschwert', 'Schild, klein');

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head');

INSERT INTO character_armor (character_id, slot, name_de, armor_value, penalty_de)
SELECT @char_id, 'body', i.name_de, a.armor_value, a.penalty_skills_de
FROM catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id
WHERE i.name_de = 'Plattenpanzer';

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY name_de), name_de, description_de, 1
FROM catalog_items WHERE name_de IN ('Fackel', 'Feuerstein & Zunder');

-- ============================================================
-- Character: Krisanna die Kühne (Halbling, Jung, Dieb)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'krisanna_die_kuehne', 'Krisanna die Kühne', 'halbling',
    (SELECT id FROM catalog_age WHERE name_de = 'Jung'),
    'dieb',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Unbesonnen'),
    'Unschuldiges Gesicht mit gerissenem, stets aufmerksamem Blick. Leichtfüßiger und leiser Gang. Du siehst Gelegenheiten in jeder Situation.',
    'Eine Schatzkarte, die du „gefunden“ hast.',
    'images/characters/krisanna_die_kuehne.jpg',
    13, 13, 15, 15, 0, 2, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'krisanna_die_kuehne');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 8 AS value UNION ALL SELECT 'KON', 13 UNION ALL SELECT 'GEW', 18
    UNION ALL SELECT 'INT', 14 UNION ALL SELECT 'WIL', 15 UNION ALL SELECT 'CHA', 10
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 14 AS value UNION ALL SELECT 'Ausweichen', 14
    UNION ALL SELECT 'Bestienkunde', 6 UNION ALL SELECT 'Darbietung', 5
    UNION ALL SELECT 'Entdecken', 12 UNION ALL SELECT 'Feilschen', 5
    UNION ALL SELECT 'Fingerfertigkeit', 14 UNION ALL SELECT 'Fremdsprachen', 6
    UNION ALL SELECT 'Handwerk', 4 UNION ALL SELECT 'Heilkunde', 6
    UNION ALL SELECT 'Heimlichkeit', 14 UNION ALL SELECT 'Jagen & Fischen', 7
    UNION ALL SELECT 'Mythen & Legenden', 6 UNION ALL SELECT 'Reiten', 7
    UNION ALL SELECT 'Schwimmen', 7 UNION ALL SELECT 'Seefahrt', 6
    UNION ALL SELECT 'Täuschen', 10 UNION ALL SELECT 'Überzeugen', 5
    UNION ALL SELECT 'Wahrnehmung', 12 UNION ALL SELECT 'Wildnisleben', 6
    UNION ALL SELECT 'Armbrüste', 7 UNION ALL SELECT 'Äxte', 4
    UNION ALL SELECT 'Bögen', 7 UNION ALL SELECT 'Hämmer', 4
    UNION ALL SELECT 'Messer', 14 UNION ALL SELECT 'Prügelei', 4
    UNION ALL SELECT 'Schleudern', 7 UNION ALL SELECT 'Schwerter', 4
    UNION ALL SELECT 'Speere', 4 UNION ALL SELECT 'Stäbe', 7
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Schwer zu fassen', '3', 'Du kannst dieses Talent aktivieren, wenn du einem Angriff ausweichst, um einen Vorteil auf deine Ausweichen-Probe zu erhalten.'),
    (@char_id, 'Hinterhältig', '3', 'Du kannst dieses Talent bei einem Nahkampfangriff aktivieren, wenn sich dein Gegner innerhalb von 2 Metern zu einem anderen Spielercharakter befindet. Dein Angriff zählt dann als Schleichangriff. Dieses Talent kann nur mit unauffälligen Waffen eingesetzt werden.');

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @char_id, 1, i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id WHERE i.name_de = 'Dolch'
UNION ALL
SELECT @char_id, 2, i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id WHERE i.name_de = 'Messer'
UNION ALL
SELECT @char_id, 3, i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id WHERE i.name_de = 'Messer';

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head');

INSERT INTO character_armor (character_id, slot, name_de, armor_value, penalty_de)
SELECT @char_id, 'body', i.name_de, a.armor_value, a.penalty_skills_de
FROM catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id
WHERE i.name_de = 'Lederrüstung';

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, 1, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Dietriche'
UNION ALL
SELECT @char_id, 2, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Fackel'
UNION ALL
SELECT @char_id, 3, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Seil (Hanf), 10m'
UNION ALL
SELECT @char_id, 4, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Feuerstein & Zunder';

-- ============================================================
-- Character: Bastonn Blutschlund (Wolfsmensch, Jung, Kämpfer)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'bastonn_blutschlund', 'Bastonn Blutschlund', 'wolfsmensch',
    (SELECT id FROM catalog_age WHERE name_de = 'Jung'),
    'kaempfer',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Verfressen'),
    'Vernarbter Muskelberg. Du bist ein treuer Freund und ein furchteinflößender Feind. Du achtest gut auf deine Kleidung und trägst häufig wohlriechende Duftwässerchen.',
    'Blauer Parfümflakon.',
    'images/characters/bastonn_blutschlund.jpg',
    17, 17, 13, 13, 0, 2, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'bastonn_blutschlund');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 18 AS value UNION ALL SELECT 'KON', 17 UNION ALL SELECT 'GEW', 14
    UNION ALL SELECT 'INT', 11 UNION ALL SELECT 'WIL', 13 UNION ALL SELECT 'CHA', 7
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 12 AS value UNION ALL SELECT 'Ausweichen', 12
    UNION ALL SELECT 'Bestienkunde', 5 UNION ALL SELECT 'Darbietung', 4
    UNION ALL SELECT 'Entdecken', 5 UNION ALL SELECT 'Feilschen', 6
    UNION ALL SELECT 'Fingerfertigkeit', 6 UNION ALL SELECT 'Fremdsprachen', 5
    UNION ALL SELECT 'Handwerk', 7 UNION ALL SELECT 'Heilkunde', 5
    UNION ALL SELECT 'Heimlichkeit', 12 UNION ALL SELECT 'Jagen & Fischen', 6
    UNION ALL SELECT 'Mythen & Legenden', 5 UNION ALL SELECT 'Reiten', 6
    UNION ALL SELECT 'Schwimmen', 6 UNION ALL SELECT 'Seefahrt', 5
    UNION ALL SELECT 'Täuschen', 4 UNION ALL SELECT 'Überzeugen', 5
    UNION ALL SELECT 'Wahrnehmung', 5 UNION ALL SELECT 'Wildnisleben', 5
    UNION ALL SELECT 'Armbrüste', 6 UNION ALL SELECT 'Äxte', 14
    UNION ALL SELECT 'Bögen', 6 UNION ALL SELECT 'Hämmer', 14
    UNION ALL SELECT 'Messer', 6 UNION ALL SELECT 'Prügelei', 14
    UNION ALL SELECT 'Schleudern', 6 UNION ALL SELECT 'Schwerter', 14
    UNION ALL SELECT 'Speere', 14 UNION ALL SELECT 'Stäbe', 6
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Jagdinstinkt', '3', 'Du kannst dieses Talent aktivieren, um eine Kreatur in Sichtweite oder deren Geruch du wahrnehmen kannst, als deine Beute zu markieren. Dies zählt im Kampf als eine Aktion.'),
    (@char_id, 'Veteran', '1', 'Wenn du dieses Talent zu Beginn einer Kampfrunde aktivierst, kannst du deine Initiativekarte aus der letzten Runde behalten anstatt eine neue zu ziehen.');

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY i.name_de), i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id
WHERE i.name_de IN ('Langspeer', 'Kurzspeer');

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head');

INSERT INTO character_armor (character_id, slot, name_de, armor_value, penalty_de)
SELECT @char_id, 'body', i.name_de, a.armor_value, a.penalty_skills_de
FROM catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id
WHERE i.name_de = 'Beschlagenes Leder';

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY name_de), name_de, description_de, 1
FROM catalog_items WHERE name_de IN ('Fackel', 'Feuerstein & Zunder');

-- ============================================================
-- Character: Alberich Glanzherz (Zwerg, Jung, Händler)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'alberich_glanzherz', 'Alberich Glanzherz', 'zwerg',
    (SELECT id FROM catalog_age WHERE name_de = 'Jung'),
    'haendler',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Eitel'),
    'Lebhaft und ungeduldig. Du stehst selten still. Durchdringende Augen, die den Vor- und Nachteil jeder Situation abwägen. Stets gut gekleidet und gepflegt.',
    'Kleines Goldamulett mit dem Familienwappen.',
    'images/characters/alberich_glanzherz.jpg',
    14, 14, 11, 11, 0, 10, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'alberich_glanzherz');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 10 AS value UNION ALL SELECT 'KON', 14 UNION ALL SELECT 'GEW', 13
    UNION ALL SELECT 'INT', 14 UNION ALL SELECT 'WIL', 11 UNION ALL SELECT 'CHA', 17
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 6 AS value UNION ALL SELECT 'Ausweichen', 6
    UNION ALL SELECT 'Bestienkunde', 6 UNION ALL SELECT 'Darbietung', 7
    UNION ALL SELECT 'Entdecken', 12 UNION ALL SELECT 'Feilschen', 14
    UNION ALL SELECT 'Fingerfertigkeit', 6 UNION ALL SELECT 'Fremdsprachen', 6
    UNION ALL SELECT 'Handwerk', 5 UNION ALL SELECT 'Heilkunde', 6
    UNION ALL SELECT 'Heimlichkeit', 12 UNION ALL SELECT 'Jagen & Fischen', 6
    UNION ALL SELECT 'Mythen & Legenden', 12 UNION ALL SELECT 'Reiten', 6
    UNION ALL SELECT 'Schwimmen', 6 UNION ALL SELECT 'Seefahrt', 6
    UNION ALL SELECT 'Täuschen', 14 UNION ALL SELECT 'Überzeugen', 14
    UNION ALL SELECT 'Wahrnehmung', 12 UNION ALL SELECT 'Wildnisleben', 6
    UNION ALL SELECT 'Armbrüste', 6 UNION ALL SELECT 'Äxte', 5
    UNION ALL SELECT 'Bögen', 6 UNION ALL SELECT 'Hämmer', 5
    UNION ALL SELECT 'Messer', 12 UNION ALL SELECT 'Prügelei', 5
    UNION ALL SELECT 'Schleudern', 6 UNION ALL SELECT 'Schwerter', 5
    UNION ALL SELECT 'Speere', 5 UNION ALL SELECT 'Stäbe', 6
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Nachtragend', '3', 'Du kannst dieses Talent aktivieren, wenn du jemanden angreifst, der dich in der Vergangenheit verletzt hat, um einen Vorteil auf den Wurf zu erhalten.'),
    (@char_id, 'Goldnase', '3', 'Du kannst dieses Talent aktivieren, wenn du an einem Scheideweg bist, um herauszufinden, welcher Weg oder welche Entscheidung dich zu den größten Reichtümern führt.');

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head'), (@char_id, 'body');

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, 1, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Seil (Hanf), 10m'
UNION ALL
SELECT @char_id, 2, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Laterne'
UNION ALL
SELECT @char_id, 3, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Lampenöl'
UNION ALL
SELECT @char_id, 4, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Feuerstein & Zunder';

-- ============================================================
-- Character: Kapitänin Beatrix Weitsegel (Mensch, Erwachsen, Seefahrerin)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'kapitaenin_beatrix_weitsegel', 'Kapitänin Beatrix Weitsegel', 'mensch',
    (SELECT id FROM catalog_age WHERE name_de = 'Erwachsen'),
    'seefahrerin',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Anmaßend'),
    'Sonnengebräunt, strenger Gesichtsausdruck und wachsame Augen. Praktische und strapazierfähige Kleidung. Du trägst zahlreiche Andenken an vergangene Reisen.',
    'Zeichnung in wasserfester Hülle: das perfekte Schiff. Eines Tages gehört es dir!',
    'images/characters/kapitaenin_beatrix_weitsegel.jpg',
    12, 12, 16, 16, 0, 10, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'kapitaenin_beatrix_weitsegel');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 14 AS value UNION ALL SELECT 'KON', 12 UNION ALL SELECT 'GEW', 15
    UNION ALL SELECT 'INT', 12 UNION ALL SELECT 'WIL', 16 UNION ALL SELECT 'CHA', 11
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 12 AS value UNION ALL SELECT 'Ausweichen', 12
    UNION ALL SELECT 'Bestienkunde', 5 UNION ALL SELECT 'Darbietung', 5
    UNION ALL SELECT 'Entdecken', 10 UNION ALL SELECT 'Feilschen', 5
    UNION ALL SELECT 'Fingerfertigkeit', 12 UNION ALL SELECT 'Fremdsprachen', 10
    UNION ALL SELECT 'Handwerk', 12 UNION ALL SELECT 'Heilkunde', 5
    UNION ALL SELECT 'Heimlichkeit', 6 UNION ALL SELECT 'Jagen & Fischen', 5
    UNION ALL SELECT 'Mythen & Legenden', 5 UNION ALL SELECT 'Reiten', 6
    UNION ALL SELECT 'Schwimmen', 12 UNION ALL SELECT 'Seefahrt', 10
    UNION ALL SELECT 'Täuschen', 5 UNION ALL SELECT 'Überzeugen', 5
    UNION ALL SELECT 'Wahrnehmung', 10 UNION ALL SELECT 'Wildnisleben', 5
    UNION ALL SELECT 'Armbrüste', 6 UNION ALL SELECT 'Äxte', 6
    UNION ALL SELECT 'Bögen', 6 UNION ALL SELECT 'Hämmer', 6
    UNION ALL SELECT 'Messer', 6 UNION ALL SELECT 'Prügelei', 6
    UNION ALL SELECT 'Schleudern', 6 UNION ALL SELECT 'Schwerter', 12
    UNION ALL SELECT 'Speere', 6 UNION ALL SELECT 'Stäbe', 6
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Anpassungsfähig', '3', 'Bei einer Fertigkeitsprobe kannst du dich entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen. Du musst allerdings erklären können, wie die gewählte Fertigkeit die ursprüngliche ersetzen kann.'),
    (@char_id, 'Seebeine', '1', 'Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine Aktion im Wasser ausführst, selbst wenn es nur hüfttief ist. Daraufhin bist du eine Runde lang gegen alle negativen Effekte geschützt, die üblicherweise im Wasser auftreten, einschließlich der Gefahr, zu ertrinken.');

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @char_id, 1, i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id WHERE i.name_de = 'Krummsäbel';

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head'), (@char_id, 'body');

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, 1, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Seil (Hanf), 10m'
UNION ALL
SELECT @char_id, 2, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Wurfhaken'
UNION ALL
SELECT @char_id, 3, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Fernrohr';

-- ============================================================
-- Character: Urd Bitterkinn (Zwerg, Alt, Zwergenkämpfer)
-- ============================================================

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'urd_bitterkinn', 'Urd Bitterkinn', 'zwerg',
    (SELECT id FROM catalog_age WHERE name_de = 'Alt'),
    'zwergenkaempfer',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Pessimistisch'),
    'Eisiger, durchdringender Blick. Wettergegerbte Haut. Du hast schon viel gesehen und es benötigt eine Menge, um dich aus der Ruhe zu bringen.',
    'Deine verlässlichen alten Stiefel aus Lindwurmleder, die du mit Hingabe pflegst.',
    'images/characters/urd_bitterkinn.jpg',
    14, 14, 13, 13, 0, 3, 0
);

SET @char_id = (SELECT id FROM characters WHERE slug = 'urd_bitterkinn');

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @char_id, code, value FROM (
    SELECT 'STA' AS code, 16 AS value UNION ALL SELECT 'KON', 14 UNION ALL SELECT 'GEW', 13
    UNION ALL SELECT 'INT', 12 UNION ALL SELECT 'WIL', 13 UNION ALL SELECT 'CHA', 9
) v;

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @char_id, code, 0 FROM catalog_conditions;

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @char_id, s.id, v.value FROM catalog_skills s JOIN (
    SELECT 'Akrobatik' AS name_de, 6 AS value UNION ALL SELECT 'Ausweichen', 12
    UNION ALL SELECT 'Bestienkunde', 10 UNION ALL SELECT 'Darbietung', 5
    UNION ALL SELECT 'Entdecken', 10 UNION ALL SELECT 'Feilschen', 5
    UNION ALL SELECT 'Fingerfertigkeit', 12 UNION ALL SELECT 'Fremdsprachen', 5
    UNION ALL SELECT 'Handwerk', 14 UNION ALL SELECT 'Heilkunde', 5
    UNION ALL SELECT 'Heimlichkeit', 6 UNION ALL SELECT 'Jagen & Fischen', 6
    UNION ALL SELECT 'Mythen & Legenden', 5 UNION ALL SELECT 'Reiten', 6
    UNION ALL SELECT 'Schwimmen', 6 UNION ALL SELECT 'Seefahrt', 5
    UNION ALL SELECT 'Täuschen', 5 UNION ALL SELECT 'Überzeugen', 5
    UNION ALL SELECT 'Wahrnehmung', 10 UNION ALL SELECT 'Wildnisleben', 5
    UNION ALL SELECT 'Armbrüste', 12 UNION ALL SELECT 'Äxte', 14
    UNION ALL SELECT 'Bögen', 6 UNION ALL SELECT 'Hämmer', 14
    UNION ALL SELECT 'Messer', 12 UNION ALL SELECT 'Prügelei', 14
    UNION ALL SELECT 'Schleudern', 6 UNION ALL SELECT 'Schwerter', 14
    UNION ALL SELECT 'Speere', 7 UNION ALL SELECT 'Stäbe', 6
) v ON v.name_de = s.name_de;

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@char_id, 'Nachtragend', '3', 'Du kannst dieses Talent aktivieren, wenn du jemanden angreifst, der dich in der Vergangenheit verletzt hat, um einen Vorteil auf den Wurf zu erhalten.'),
    (@char_id, 'Furchtlos', '2', 'Du widerstehst von vornherein Furchtangriffen, ohne eine WIL-Probe ablegen zu müssen.');

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY i.name_de), i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id
WHERE i.name_de IN ('Dolch', 'Beil', 'Zweihandaxt');

INSERT INTO character_armor (character_id, slot) VALUES (@char_id, 'head');

INSERT INTO character_armor (character_id, slot, name_de, armor_value, penalty_de)
SELECT @char_id, 'body', i.name_de, a.armor_value, a.penalty_skills_de
FROM catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id
WHERE i.name_de = 'Kettenpanzer';

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @char_id, ROW_NUMBER() OVER (ORDER BY name_de), name_de, description_de, 1
FROM catalog_items WHERE name_de IN ('Fackel', 'Feuerstein & Zunder');

-- All 8 pregens from the quickstart PDF are the shipped default roster.
UPDATE characters SET is_default = 1;
