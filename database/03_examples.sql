SET NAMES utf8mb4;

-- Beispieldaten: Charaktere und Kampagnen, Endstand. Pro Tabelle genau ein INSERT
-- mit festen Ids. Verweise auf den Katalog (skill_id, item_id, bestiary_id, ...)
-- sind Ids aus 02_catalog.sql. Zeitstempel (created_at/updated_at) setzt die DB.
-- Wird nach 02_catalog.sql geladen.

-- ============================================================
-- Beispiel-Charaktere: Erzmeister Aodhan und die sieben Quickstart-Pregens (Ids 1-8)
-- ============================================================

-- characters
INSERT INTO characters (id, is_default, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, memory_de, portrait_path, hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper) VALUES
    (1, 1, 'Erzmeister Aodhan', 'mensch', 3, 'magier', 5, 'Groß und drahtig. Langer weißer Bart und buschige Augenbrauen. Wissbegieriger Blick.', 'Abgegriffenes Tagebuch mit deinen Erfahrungen und Erkenntnissen.', NULL, 'images/characters/erzmeister_aodhan.jpg', 11, 11, 18, 18, 0, 7, 0),
    (2, 1, 'Orla Mondsilber', 'elf', 2, 'jaeger', 7, 'Geschmeidiger und selbstbewusster Gang. Klarer Blick, der jedes Gegenüber misstrauisch mustert. Eifrig und flink im Denken wie Handeln.', 'Hauer des Trolls, der deine Schwester getötet hat.', NULL, 'images/characters/orla_mondsilber.jpg', 15, 15, 10, 10, 0, 4, 0),
    (3, 1, 'Makander von Sichelbucht', 'ente', 2, 'ritter', 4, 'Stark, stabil und stur. Watschelnder Gang. Schnell wütend, wenn du provoziert wirst, vor allem wenn deine Familie oder Ehre beleidigt wird. Du lächelst selten.', 'Fein gearbeitete Tabakspfeife aus schwarzem Horn (ein Geschenk deines Vaters).', NULL, 'images/characters/makander_von_sichelbucht.jpg', 16, 16, 14, 14, 0, 10, 0),
    (4, 1, 'Krisanna die Kühne', 'halbling', 1, 'dieb', 12, 'Unschuldiges Gesicht mit gerissenem, stets aufmerksamem Blick. Leichtfüßiger und leiser Gang. Du siehst Gelegenheiten in jeder Situation.', 'Eine Schatzkarte, die du „gefunden“ hast.', NULL, 'images/characters/krisanna_die_kuehne.jpg', 13, 13, 15, 15, 0, 2, 0),
    (5, 1, 'Bastonn Blutschlund', 'wolfsmensch', 1, 'kaempfer', 9, 'Vernarbter Muskelberg. Du bist ein treuer Freund und ein furchteinflößender Feind. Du achtest gut auf deine Kleidung und trägst häufig wohlriechende Duftwässerchen.', 'Blauer Parfümflakon.', NULL, 'images/characters/bastonn_blutschlund.jpg', 17, 17, 13, 13, 0, 2, 0),
    (6, 1, 'Alberich Glanzherz', 'zwerg', 1, 'haendler', 11, 'Lebhaft und ungeduldig. Du stehst selten still. Durchdringende Augen, die den Vor- und Nachteil jeder Situation abwägen. Stets gut gekleidet und gepflegt.', 'Kleines Goldamulett mit dem Familienwappen.', NULL, 'images/characters/alberich_glanzherz.jpg', 14, 14, 11, 11, 0, 10, 0),
    (7, 1, 'Kapitänin Beatrix Weitsegel', 'mensch', 2, 'seefahrerin', 18, 'Sonnengebräunt, strenger Gesichtsausdruck und wachsame Augen. Praktische und strapazierfähige Kleidung. Du trägst zahlreiche Andenken an vergangene Reisen.', 'Zeichnung in wasserfester Hülle: das perfekte Schiff. Eines Tages gehört es dir!', NULL, 'images/characters/kapitaenin_beatrix_weitsegel.jpg', 12, 12, 16, 16, 0, 10, 0),
    (8, 1, 'Urd Bitterkinn', 'zwerg', 3, 'kaempfer', 19, 'Eisiger, durchdringender Blick. Wettergegerbte Haut. Du hast schon viel gesehen und es benötigt eine Menge, um dich aus der Ruhe zu bringen.', 'Deine verlässlichen alten Stiefel aus Lindwurmleder, die du mit Hingabe pflegst.', NULL, 'images/characters/urd_bitterkinn.jpg', 14, 14, 13, 13, 0, 3, 0);

-- character_attributes
INSERT INTO character_attributes (character_id, attribute_code, value) VALUES
    (1, 'CHA', 14),
    (1, 'GEW', 9),
    (1, 'INT', 16),
    (1, 'KON', 11),
    (1, 'STA', 8),
    (1, 'WIL', 18),
    (2, 'CHA', 9),
    (2, 'GEW', 17),
    (2, 'INT', 13),
    (2, 'KON', 15),
    (2, 'STA', 13),
    (2, 'WIL', 10),
    (3, 'CHA', 13),
    (3, 'GEW', 10),
    (3, 'INT', 12),
    (3, 'KON', 16),
    (3, 'STA', 16),
    (3, 'WIL', 14),
    (4, 'CHA', 10),
    (4, 'GEW', 18),
    (4, 'INT', 14),
    (4, 'KON', 13),
    (4, 'STA', 8),
    (4, 'WIL', 15),
    (5, 'CHA', 7),
    (5, 'GEW', 14),
    (5, 'INT', 11),
    (5, 'KON', 17),
    (5, 'STA', 18),
    (5, 'WIL', 13),
    (6, 'CHA', 17),
    (6, 'GEW', 13),
    (6, 'INT', 14),
    (6, 'KON', 14),
    (6, 'STA', 10),
    (6, 'WIL', 11),
    (7, 'CHA', 11),
    (7, 'GEW', 15),
    (7, 'INT', 12),
    (7, 'KON', 12),
    (7, 'STA', 14),
    (7, 'WIL', 16),
    (8, 'CHA', 9),
    (8, 'GEW', 13),
    (8, 'INT', 12),
    (8, 'KON', 14),
    (8, 'STA', 16),
    (8, 'WIL', 13);

-- character_conditions
INSERT INTO character_conditions (character_id, condition_code, active) VALUES
    (1, 'angry', 0),
    (1, 'dazed', 0),
    (1, 'disheartened', 0),
    (1, 'exhausted', 0),
    (1, 'scared', 0),
    (1, 'sickly', 0),
    (2, 'angry', 0),
    (2, 'dazed', 0),
    (2, 'disheartened', 0),
    (2, 'exhausted', 0),
    (2, 'scared', 0),
    (2, 'sickly', 0),
    (3, 'angry', 0),
    (3, 'dazed', 0),
    (3, 'disheartened', 0),
    (3, 'exhausted', 0),
    (3, 'scared', 0),
    (3, 'sickly', 0),
    (4, 'angry', 0),
    (4, 'dazed', 0),
    (4, 'disheartened', 0),
    (4, 'exhausted', 0),
    (4, 'scared', 0),
    (4, 'sickly', 0),
    (5, 'angry', 0),
    (5, 'dazed', 0),
    (5, 'disheartened', 0),
    (5, 'exhausted', 0),
    (5, 'scared', 0),
    (5, 'sickly', 0),
    (6, 'angry', 0),
    (6, 'dazed', 0),
    (6, 'disheartened', 0),
    (6, 'exhausted', 0),
    (6, 'scared', 0),
    (6, 'sickly', 0),
    (7, 'angry', 0),
    (7, 'dazed', 0),
    (7, 'disheartened', 0),
    (7, 'exhausted', 0),
    (7, 'scared', 0),
    (7, 'sickly', 0),
    (8, 'angry', 0),
    (8, 'dazed', 0),
    (8, 'disheartened', 0),
    (8, 'exhausted', 0),
    (8, 'scared', 0),
    (8, 'sickly', 0);

-- character_skills
INSERT INTO character_skills (character_id, skill_id, value, marked_for_advancement) VALUES
    (1, 1, 5, 0),
    (1, 2, 10, 0),
    (1, 3, 14, 0),
    (1, 4, 6, 0),
    (1, 5, 14, 0),
    (1, 6, 6, 0),
    (1, 7, 5, 0),
    (1, 8, 14, 0),
    (1, 9, 4, 0),
    (1, 10, 14, 0),
    (1, 11, 10, 0),
    (1, 12, 5, 0),
    (1, 13, 14, 0),
    (1, 14, 5, 0),
    (1, 15, 7, 0),
    (1, 16, 7, 0),
    (1, 17, 6, 0),
    (1, 18, 12, 0),
    (1, 19, 14, 0),
    (1, 20, 14, 0),
    (1, 21, 5, 0),
    (1, 22, 4, 0),
    (1, 23, 5, 0),
    (1, 24, 5, 0),
    (1, 25, 5, 0),
    (1, 26, 4, 0),
    (1, 27, 5, 0),
    (1, 28, 4, 0),
    (1, 29, 4, 0),
    (1, 30, 10, 0),
    (1, 31, 14, 0),
    (1, 32, 0, 0),
    (1, 33, 0, 0),
    (2, 1, 14, 0),
    (2, 2, 14, 0),
    (2, 3, 6, 0),
    (2, 4, 5, 0),
    (2, 5, 6, 0),
    (2, 6, 7, 0),
    (2, 7, 7, 0),
    (2, 8, 6, 0),
    (2, 9, 6, 0),
    (2, 10, 6, 0),
    (2, 11, 14, 0),
    (2, 12, 14, 0),
    (2, 13, 6, 0),
    (2, 14, 7, 0),
    (2, 15, 14, 0),
    (2, 16, 6, 0),
    (2, 17, 5, 0),
    (2, 18, 5, 0),
    (2, 19, 12, 0),
    (2, 20, 12, 0),
    (2, 21, 7, 0),
    (2, 22, 6, 0),
    (2, 23, 14, 0),
    (2, 24, 6, 0),
    (2, 25, 14, 0),
    (2, 26, 6, 0),
    (2, 27, 7, 0),
    (2, 28, 12, 0),
    (2, 29, 7, 0),
    (2, 30, 7, 0),
    (2, 31, 0, 0),
    (2, 32, 0, 0),
    (2, 33, 0, 0),
    (3, 1, 10, 0),
    (3, 2, 5, 0),
    (3, 3, 5, 0),
    (3, 4, 12, 0),
    (3, 5, 5, 0),
    (3, 6, 6, 0),
    (3, 7, 5, 0),
    (3, 8, 5, 0),
    (3, 9, 7, 0),
    (3, 10, 5, 0),
    (3, 11, 5, 0),
    (3, 12, 5, 0),
    (3, 13, 10, 0),
    (3, 14, 5, 0),
    (3, 15, 5, 0),
    (3, 16, 5, 0),
    (3, 17, 6, 0),
    (3, 18, 12, 0),
    (3, 19, 5, 0),
    (3, 20, 5, 0),
    (3, 21, 10, 0),
    (3, 22, 14, 0),
    (3, 23, 5, 0),
    (3, 24, 14, 0),
    (3, 25, 5, 0),
    (3, 26, 14, 0),
    (3, 27, 5, 0),
    (3, 28, 14, 0),
    (3, 29, 14, 0),
    (3, 30, 5, 0),
    (3, 31, 0, 0),
    (3, 32, 0, 0),
    (3, 33, 0, 0),
    (4, 1, 14, 0),
    (4, 2, 14, 0),
    (4, 3, 6, 0),
    (4, 4, 5, 0),
    (4, 5, 12, 0),
    (4, 6, 5, 0),
    (4, 7, 14, 0),
    (4, 8, 6, 0),
    (4, 9, 4, 0),
    (4, 10, 6, 0),
    (4, 11, 14, 0),
    (4, 12, 7, 0),
    (4, 13, 6, 0),
    (4, 14, 7, 0),
    (4, 15, 7, 0),
    (4, 16, 6, 0),
    (4, 17, 10, 0),
    (4, 18, 5, 0),
    (4, 19, 12, 0),
    (4, 20, 6, 0),
    (4, 21, 7, 0),
    (4, 22, 4, 0),
    (4, 23, 7, 0),
    (4, 24, 4, 0),
    (4, 25, 14, 0),
    (4, 26, 4, 0),
    (4, 27, 7, 0),
    (4, 28, 4, 0),
    (4, 29, 4, 0),
    (4, 30, 7, 0),
    (4, 31, 0, 0),
    (4, 32, 0, 0),
    (4, 33, 0, 0),
    (5, 1, 12, 0),
    (5, 2, 12, 0),
    (5, 3, 5, 0),
    (5, 4, 4, 0),
    (5, 5, 5, 0),
    (5, 6, 6, 0),
    (5, 7, 6, 0),
    (5, 8, 5, 0),
    (5, 9, 7, 0),
    (5, 10, 5, 0),
    (5, 11, 12, 0),
    (5, 12, 6, 0),
    (5, 13, 5, 0),
    (5, 14, 6, 0),
    (5, 15, 6, 0),
    (5, 16, 5, 0),
    (5, 17, 4, 0),
    (5, 18, 5, 0),
    (5, 19, 5, 0),
    (5, 20, 5, 0),
    (5, 21, 6, 0),
    (5, 22, 14, 0),
    (5, 23, 6, 0),
    (5, 24, 14, 0),
    (5, 25, 6, 0),
    (5, 26, 14, 0),
    (5, 27, 6, 0),
    (5, 28, 14, 0),
    (5, 29, 14, 0),
    (5, 30, 6, 0),
    (5, 31, 0, 0),
    (5, 32, 0, 0),
    (5, 33, 0, 0),
    (6, 1, 6, 0),
    (6, 2, 6, 0),
    (6, 3, 6, 0),
    (6, 4, 7, 0),
    (6, 5, 12, 0),
    (6, 6, 14, 0),
    (6, 7, 6, 0),
    (6, 8, 6, 0),
    (6, 9, 5, 0),
    (6, 10, 6, 0),
    (6, 11, 12, 0),
    (6, 12, 6, 0),
    (6, 13, 12, 0),
    (6, 14, 6, 0),
    (6, 15, 6, 0),
    (6, 16, 6, 0),
    (6, 17, 14, 0),
    (6, 18, 14, 0),
    (6, 19, 12, 0),
    (6, 20, 6, 0),
    (6, 21, 6, 0),
    (6, 22, 5, 0),
    (6, 23, 6, 0),
    (6, 24, 5, 0),
    (6, 25, 12, 0),
    (6, 26, 5, 0),
    (6, 27, 6, 0),
    (6, 28, 5, 0),
    (6, 29, 5, 0),
    (6, 30, 6, 0),
    (6, 31, 0, 0),
    (6, 32, 0, 0),
    (6, 33, 0, 0),
    (7, 1, 12, 0),
    (7, 2, 12, 0),
    (7, 3, 5, 0),
    (7, 4, 5, 0),
    (7, 5, 10, 0),
    (7, 6, 5, 0),
    (7, 7, 12, 0),
    (7, 8, 10, 0),
    (7, 9, 12, 0),
    (7, 10, 5, 0),
    (7, 11, 6, 0),
    (7, 12, 5, 0),
    (7, 13, 5, 0),
    (7, 14, 6, 0),
    (7, 15, 12, 0),
    (7, 16, 10, 0),
    (7, 17, 5, 0),
    (7, 18, 5, 0),
    (7, 19, 10, 0),
    (7, 20, 5, 0),
    (7, 21, 6, 0),
    (7, 22, 6, 0),
    (7, 23, 6, 0),
    (7, 24, 6, 0),
    (7, 25, 6, 0),
    (7, 26, 6, 0),
    (7, 27, 6, 0),
    (7, 28, 12, 0),
    (7, 29, 6, 0),
    (7, 30, 6, 0),
    (7, 31, 0, 0),
    (7, 32, 0, 0),
    (7, 33, 0, 0),
    (8, 1, 6, 0),
    (8, 2, 12, 0),
    (8, 3, 10, 0),
    (8, 4, 5, 0),
    (8, 5, 10, 0),
    (8, 6, 5, 0),
    (8, 7, 12, 0),
    (8, 8, 5, 0),
    (8, 9, 14, 0),
    (8, 10, 5, 0),
    (8, 11, 6, 0),
    (8, 12, 6, 0),
    (8, 13, 5, 0),
    (8, 14, 6, 0),
    (8, 15, 6, 0),
    (8, 16, 5, 0),
    (8, 17, 5, 0),
    (8, 18, 5, 0),
    (8, 19, 10, 0),
    (8, 20, 5, 0),
    (8, 21, 12, 0),
    (8, 22, 14, 0),
    (8, 23, 6, 0),
    (8, 24, 14, 0),
    (8, 25, 12, 0),
    (8, 26, 14, 0),
    (8, 27, 6, 0),
    (8, 28, 14, 0),
    (8, 29, 7, 0),
    (8, 30, 6, 0),
    (8, 31, 0, 0),
    (8, 32, 0, 0),
    (8, 33, 0, 0);

-- character_talents
INSERT INTO character_talents (id, character_id, name_de, wp_note_de, description_de) VALUES
    (1, 1, 'Anpassungsfähig', NULL, 'Bei einer Fertigkeitsprobe kannst du dich entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen.'),
    (2, 1, 'Magie', 'unterschiedlich', 'Als Zauberer kannst du Magie benutzen.'),
    (3, 2, 'Innerer Frieden', NULL, 'Als Elf kannst du während einer kurzen Rast meditieren. Du heilst einen zusätzlichen W6 TP sowie einen weiteren W6 WP, außerdem kannst du dich von einem zusätzlichen Zustand erholen.'),
    (4, 2, 'Doppelschuss', '3', 'Wenn du bei einem Angriff mit dem Bogen dieses Talent aktivierst, kannst du zwei Pfeile gleichzeitig abschießen.'),
    (5, 3, 'Übellaunig', '3', 'Enten haben ein eher cholerisches Gemüt. Du kannst dieses Talent aktivieren, wenn du eine Fertigkeitsprobe ablegst, und bekommst dadurch einen Vorteil auf deinen Wurf. Zusätzlich erhältst du den Zustand Wütend, falls du es nicht bereits bist.'),
    (6, 3, 'Schwimmhäute', NULL, 'Als Ente erhältst du einen Vorteil auf alle Schwimmen-Proben. Du bewegst dich im oder unter Wasser stets mit deiner vollen Geschwindigkeit.'),
    (7, 3, 'Beschützer', '2', 'Du zögerst nicht, einen Treffer für deine Freunde einzustecken. Wenn du und ein anderer Spielercharakter innerhalb von zwei Metern zum selben Feind seid und der Feind den anderen Charakter zu treffen versucht, kannst du dieses Talent aktivieren, um den Feind zu zwingen, stattdessen dich zu attackieren.'),
    (8, 4, 'Schwer zu fassen', '3', 'Du kannst dieses Talent aktivieren, wenn du einem Angriff ausweichst, um einen Vorteil auf deine Ausweichen-Probe zu erhalten.'),
    (9, 4, 'Hinterhältig', '3', 'Du kannst dieses Talent bei einem Nahkampfangriff aktivieren, wenn sich dein Gegner innerhalb von 2 Metern zu einem anderen Spielercharakter befindet. Dein Angriff zählt dann als Schleichangriff. Dieses Talent kann nur mit unauffälligen Waffen eingesetzt werden.'),
    (10, 5, 'Jagdinstinkt', '3', 'Du kannst dieses Talent aktivieren, um eine Kreatur in Sichtweite oder deren Geruch du wahrnehmen kannst, als deine Beute zu markieren. Dies zählt im Kampf als eine Aktion.'),
    (11, 5, 'Veteran', '1', 'Wenn du dieses Talent zu Beginn einer Kampfrunde aktivierst, kannst du deine Initiativekarte aus der letzten Runde behalten anstatt eine neue zu ziehen.'),
    (12, 6, 'Nachtragend', '3', 'Du kannst dieses Talent aktivieren, wenn du jemanden angreifst, der dich in der Vergangenheit verletzt hat, um einen Vorteil auf den Wurf zu erhalten.'),
    (13, 6, 'Goldnase', '3', 'Du kannst dieses Talent aktivieren, wenn du an einem Scheideweg bist, um herauszufinden, welcher Weg oder welche Entscheidung dich zu den größten Reichtümern führt.'),
    (14, 7, 'Anpassungsfähig', '3', 'Bei einer Fertigkeitsprobe kannst du dich entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen. Du musst allerdings erklären können, wie die gewählte Fertigkeit die ursprüngliche ersetzen kann.'),
    (15, 7, 'Seebeine', '1', 'Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine Aktion im Wasser ausführst, selbst wenn es nur hüfttief ist. Daraufhin bist du eine Runde lang gegen alle negativen Effekte geschützt, die üblicherweise im Wasser auftreten, einschließlich der Gefahr, zu ertrinken.'),
    (16, 8, 'Nachtragend', '3', 'Du kannst dieses Talent aktivieren, wenn du jemanden angreifst, der dich in der Vergangenheit verletzt hat, um einen Vorteil auf den Wurf zu erhalten.'),
    (17, 8, 'Furchtlos', '2', 'Du widerstehst von vornherein Furchtangriffen, ohne eine WIL-Probe ablegen zu müssen.');

-- character_spells
INSERT INTO character_spells (character_id, spell_id) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6);

-- character_weapons
INSERT INTO character_weapons (id, character_id, position, name_de, grip_de, range_de, damage_de, traits_de) VALUES
    (1, 1, 1, 'Stab', '2-händig', '2', 'W8', 'Wucht, Niederwerfend'),
    (2, 2, 1, 'Langbogen', '2-händig', '100', 'W12', 'Stich, benötigt Köcher, kein Schadensbonus'),
    (3, 2, 2, 'Messer', '1-händig', 'STR', 'W8', 'Unauffällig, Stich, kann geworfen werden'),
    (5, 3, 1, 'Kurzschwert', '1-händig', '2', 'W10', 'Hieb, Stich'),
    (6, 3, 2, 'Schild, klein', '1-händig', '2', 'W8', 'Wucht'),
    (7, 3, 3, 'Streitaxt', '1-händig', '2', '2W8', 'Niederwerfend, Hieb'),
    (8, 4, 1, 'Dolch', '1-händig', 'STR', 'W8', 'Unauffällig, Stich, Hieb, kann geworfen werden'),
    (9, 4, 2, 'Messer', '1-händig', 'STR', 'W8', 'Unauffällig, Stich, kann geworfen werden'),
    (10, 4, 3, 'Messer', '1-händig', 'STR', 'W8', 'Unauffällig, Stich, kann geworfen werden'),
    (11, 5, 1, 'Kurzspeer', '1-händig', 'STR×2', 'W10', 'Stich, kann geworfen werden'),
    (12, 5, 2, 'Langspeer', '2-händig', '4', '2W8', 'Lang, Stich'),
    (14, 7, 1, 'Krummsäbel', '1-händig', '2', '2W6', 'Niederwerfend, Hieb'),
    (15, 8, 1, 'Beil', '1-händig', 'STR', '2W6', 'Niederwerfend, Hieb, kann geworfen werden'),
    (16, 8, 2, 'Dolch', '1-händig', 'STR', 'W8', 'Unauffällig, Stich, Hieb, kann geworfen werden'),
    (17, 8, 3, 'Zweihandaxt', '2-händig', '2', '2W10', 'Hieb, Niederwerfend');

-- character_armor
INSERT INTO character_armor (id, character_id, slot, name_de, armor_value, penalty_stealth, penalty_evasion, penalty_acrobatics, penalty_perception, penalty_ranged) VALUES
    (1, 1, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (2, 1, 'body', 'Lederrüstung', 1, 0, 0, 0, 0, 0),
    (3, 2, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (4, 2, 'body', 'Lederrüstung', 1, 0, 0, 0, 0, 0),
    (5, 3, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (6, 3, 'body', 'Plattenpanzer', 6, 1, 1, 1, 0, 0),
    (7, 4, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (8, 4, 'body', 'Lederrüstung', 1, 0, 0, 0, 0, 0),
    (9, 5, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (10, 5, 'body', 'Beschlagenes Leder', 2, 1, 0, 0, 0, 0),
    (11, 6, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (12, 6, 'body', NULL, NULL, 0, 0, 0, 0, 0),
    (13, 7, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (14, 7, 'body', NULL, NULL, 0, 0, 0, 0, 0),
    (15, 8, 'head', NULL, NULL, 0, 0, 0, 0, 0),
    (16, 8, 'body', 'Kettenpanzer', 4, 1, 1, 0, 0, 0);

-- character_inventory
INSERT INTO character_inventory (id, character_id, position, name_de, description_de, quantity) VALUES
    (1, 1, 1, 'Zauberbuch', 'Ein abgegriffenes Buch voller handschriftlicher Notizen zu Zaubersprüchen.', 1),
    (2, 1, 2, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 2),
    (3, 1, 3, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1),
    (4, 2, 1, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 1),
    (5, 2, 2, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1),
    (6, 2, 3, 'Köcher', 'Ein Köcher für Pfeile.', 1),
    (7, 2, 4, 'Seil (Hanf), 10m', 'Zehn Meter robustes Hanfseil.', 1),
    (11, 3, 1, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 1),
    (12, 3, 2, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1),
    (14, 4, 1, 'Dietriche', 'Ein Satz Dietriche zum Schlösserknacken.', 1),
    (15, 4, 2, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 1),
    (16, 4, 3, 'Seil (Hanf), 10m', 'Zehn Meter robustes Hanfseil.', 1),
    (17, 4, 4, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1),
    (21, 5, 1, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 1),
    (22, 5, 2, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1),
    (24, 6, 1, 'Seil (Hanf), 10m', 'Zehn Meter robustes Hanfseil.', 1),
    (25, 6, 2, 'Laterne', 'Eine Öllaterne.', 1),
    (26, 6, 3, 'Lampenöl', 'Ein Fläschchen Öl für Laternen.', 1),
    (27, 6, 4, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1),
    (31, 7, 1, 'Seil (Hanf), 10m', 'Zehn Meter robustes Hanfseil.', 1),
    (32, 7, 2, 'Wurfhaken', 'Ein Enterhaken mit Seil. Kann verwendet werden, um ein Seil zu sichern; wird mit einer Akrobatik-Probe bis zu STÄ Meter weit geworfen (STÄ×2 mit einem Nachteil).', 1),
    (33, 7, 3, 'Fernrohr', 'Ein Fernrohr für die weite Sicht. Bonus auf Wildnisleben-Proben, um während einer Reise den Weg zu weisen.', 1),
    (34, 8, 1, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 1),
    (35, 8, 2, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 1);

-- ============================================================
-- Beispiel-Kampagnen: Ridderhöhe (1), Der Versinkende Turm (2), Der Hundekampfring (3), Die Burg des Raubritters (4)
-- ============================================================

-- campaigns
INSERT INTO campaigns (id, name_de, teaser_de, background_de, is_default) VALUES
    (1, 'Ridderhöhe', 'Ein von Goblins geplünderter Grabhügel im Nebeltal, ein rachsüchtiger untoter Ritter und eine sagenumwobene Krone – ein kurzer Dungeon-Einstieg für 3–5 Charaktere.', 'Tief in den ausgedehnten Wäldern des Nebeltals liegt ein Grabhügel namens Ridderhöhe. In der Umgebung ist dieser Ort gefürchtet, da hier der Geist eines mächtigen Ritters im Dienste des Drachenkaisers sein Unwesen treibt – doch heißt es auch, dass dieser Gruftschrecken im Hügel über verborgene Schätze wacht. Das Abenteuer ist als kurzer, einfacher Einstieg in Dragonbane gedacht, für drei bis fünf Spielende plus Spielleitung.

Die Charaktere sind Abenteurerinnen und Abenteurer, die auf der Suche nach Ruhm und Reichtum ins Nebeltal gekommen sind. Sie haben Gerüchte über eine uralte, wertvolle Krone gehört, die sich innerhalb der Ridderhöhe verbergen soll, und haben einen mehrtägigen, strapaziösen Marsch hinter sich. Bei Spielbeginn befinden sie sich am Punkt #1 des Bodenplans.

Wenn die Charaktere am Grabhügel ankommen, wurde er bereits von einer Gruppe Goblins geöffnet, die von der Ork-Stammesführerin Maladûk geschickt wurde. Diese Grabräuber haben sich jedoch bereits den Zorn des Gruftschreckens und einiger niederer Untoter eingehandelt, die dieses düstere Reich der Schatten bewohnen. Bei Ankunft der Charaktere wurden bereits alle Goblins getötet oder in die Flucht geschlagen – mit Ausnahme des armen Grub in Raum #5.

Der Gruftschrecken ist immer noch auf der Jagd nach den Grabräubern. Er bewegt sich langsam, aber beharrlich durch den Grabhügel, voller Zorn über die Dreistigkeit der Eindringlinge. Er kann durch geschlossene Fallgitter und Türen hindurchgehen und so überall plötzlich auftauchen.

DM-Tipp: Versuche während des Abenteuers eine spannende Atmosphäre zu schaffen und den Spielenden das Gefühl zu geben, wie in einem Horrorfilm durch die Gänge im Grabhügel gejagt zu werden. Setze dazu den Gruftschrecken ein, um die Charaktere zu verunsichern, während sie im Dunkeln des Hügels herumschleichen – sie können seine schweren, schleppenden Schritte hören, das grässliche Rasseln des Kettenhemdes und die dumpfen Geräusche seines Morgensterns, der gegen die Wände schlägt.', 1),
    (2, 'Der Versinkende Turm', 'Ein verzauberter Steinturm taucht für zwei Stunden aus dem Meer auf: Rätsel, Fallen, Schätze und der rachsüchtige Lindwurm Krakul warten in sieben Stockwerken – ein temporeiches Turnierabenteuer für 3–5 Charaktere.', 'Vor langer Zeit lebten zwei Geschwister am Ufer eines großen Meeres. Kamandur und Magdala waren schon als Kinder eng verbunden. Sie erkundeten die Strände, Klippen und Wälder rund um ihr kleines Häuschen am Meer und entdeckten dabei Muster und Kräfte, die andere nicht sahen. Schon bald merkten ihre Eltern, dass die Kinder ein Talent für das Studium der Magie besaßen. Sie schickten die Geschwister zu einem alten Einsiedler im Wald, unter dessen Aufsicht ihre Kräfte stärker wurden.

Als ihre Eltern schließlich starben, waren die Geschwister erwachsen. Sie lebten weiterhin in dem kleinen Haus am Meer und verbrachten ihre Tage damit, Magie zu studieren und arkane Experimente durchzuführen. Eines Tages jedoch, während Kamandur Kräuter im Wald sammelte, geschah etwas, das alles verändern sollte: Ein Piratenschiff legte vor der Küste an, um Vorräte aufzufüllen. Da das Haus der Geschwister das einzige in der Gegend war, wurde es geplündert – und Magdala wurde von den brutalen Piraten getötet.

Als Kamandur zurückkehrte, fand er sein Haus niedergebrannt und seine Schwester tot am Strand. Seine ganze Welt brach über ihm zusammen, als wäre in seinem Inneren etwas zerbrochen. Er schwor, seine Schwester zu rächen, koste es, was es wolle.

Mit der Zeit wurde Kamandur zu einem mächtigen Zauberer, der die Welt bereiste, doch der Gedanke an seine tote Schwester verfolgte ihn unablässig. Kamandur erinnerte sich an die Legende vom Lindwurm Krakul, der im Meer hausen sollte und dessen Blick jeden, der ihm begegnete, bezaubern und in die Irre führen konnte. Kamandur fand den Lindwurm und stahl eines seiner Augen – einen grünen Smaragd von schrecklicher Macht.

Der Zauberer errichtete einen Steinturm am Meer. Er nannte ihn Magdalas Turm und legte seine Schwester in einem wunderschönen schwarzen Steinsarkophag an dessen Spitze zur letzten Ruhe. Auf einem Podest daneben platzierte er den Smaragd des Lindwurms.

Dann setzte er seinen Plan in die Tat um: Unzählige Schiffe fanden ihr Verhängnis an den scharfen Felsen, als sie das grüne Leuchten von Magdalas Turm sahen. Piraten und Handelsschiffe gingen gleichermaßen zugrunde, denn der Zauberer machte in seiner Wut keinen Unterschied zwischen seinen Opfern. Doch selbst das genügte Kamandur nicht. Nichts konnte ihn den schmerzhaften Tod seiner Schwester vergessen lassen. Und so lockte er weiterhin Schiffe in ihr Verderben, bis er im hohen Alter eines natürlichen Todes in seinem Bett starb. Mit Kamandurs Tod verlor der Turm einen Großteil seiner magischen Kraft. Er sank unter den Meeresspiegel und verschwand. Doch nicht für immer!

So groß war Kamandurs Trauer, dass Magdalas Turm weiterhin seine unheilige Arbeit verrichtete, selbst nachdem der Zauberer diese Welt verlassen hatte: Denn seither erhebt sich der Turm alle zwanzig Jahre am Tag von Magdalas Tod für wenige Stunden vom Meeresgrund, bevor er wieder verschwindet. Viele Abenteurer haben versucht, die Spitze des Turms zu erreichen, um den wertvollen Smaragd zu bergen, doch niemand hat je Erfolg gehabt.

Nun ist der Turm erneut aus dem Meer aufgetaucht, und sein geisterhaft grünes Licht schimmert wieder über dem Wasser. Werden die Charaktere der Spielenden dort Erfolg haben, wo alle anderen gescheitert sind?

Lies den Spielenden den folgenden Text laut vor: „Der Seewind heult, und der Geruch von Seetang und Verwesung sticht euch in die Nase. Ihr zieht eure Umhänge enger um euch, während das Ruderboot durch das unruhige Meer auf euer Ziel zusteuert. Dann lichtet sich der Nebel und gibt den Blick auf den versunkenen Turm frei, der sich gerade aus dem Wasser erhebt. Dies ist der Moment, auf den ihr alle gewartet habt: der Tag, an dem der verzauberte Steinturm, von dem man sagt, er sei von einem wahnsinnigen Magier errichtet worden, nach zwanzig Jahren wieder einmal aus dem Meer aufsteigt. Laut den Fischern am Kaminfeuer des Gasthauses bleibt er nur zwei Stunden über Wasser. Dann sinkt er wieder in die Tiefe – und mit ihm seine Schätze. Ein geisterhaft grünes Licht glimmt unheilvoll an der Spitze des Turms. Dort soll sich der Smaragd des Zauberers befinden. Vielleicht seid ihr die Ersten, die ihn finden?“

Am Fuß des Turms wartet in einem Ruderboot Der Einäugige, der den Charakteren ein Angebot macht (siehe NPC-Eintrag „Der Einäugige"). Bei Spielbeginn befinden sich die Charaktere anschließend vor der Tür zur Statuenhalle (#1).

DM-Tipp – Turnierspiel: Der Versinkende Turm ist so gestaltet, dass es als zweistündiges Turnierabenteuer gespielt werden kann. Stelle einen Timer von einer Stunde und platziere ihn sichtbar für alle. Ist die Stunde abgelaufen, verkündige den Charakteren: „Plötzlich bebt der Boden unter euren Füßen und für einen Moment fühlt es sich an, als würde der ganze Turm schwanken. Ihr hört ein fernes Grollen, doch das Geräusch endet so abrupt, wie es begonnen hat, und der Turm stabilisiert sich wieder. Wenn die Legende stimmt, bleibt euch nur noch eine Stunde, bevor der Rest des Turms unter der Oberfläche verschwindet.“ Starte den Timer erneut. Nach Ablauf der zweiten Stunde beginnt der Turm endgültig zu sinken (siehe „Der Turm sinkt" im Observatorium #7). Stirbt eine Spielfigur, kann sie durch einen der beiden Ersatzcharaktere ersetzt werden: den Zwerg Alberich Glanzherz (gefangen in der Schatzkammer #4) oder die Seefahrerin Beatrix Segelweit (gefangen im Labor #5) – stelle diese daher nicht schon zu Beginn zur Auswahl. An mehreren Orten im Turm finden die Charaktere zufällige Schätze (Schatzfundkarten); für die Wertung am Ende zählt nur die Anzahl der gefundenen Schätze, nicht ihr Inhalt. Halte das Tempo hoch, lass die Spielenden entscheiden und belohne kreative Lösungen – letztlich soll es vor allem Spaß machen.', 1),
    (3, 'Der Hundekampfring', 'Ein Fremder sucht in Rynda nach einem verschwundenen Hund.', 'Beispielkampagne in der Nebelmark: Alberta, die Bäckerin von Rynda, leitet im Keller einen Hundekampfring. Die Gruppe soll herausfinden, wer dort kämpfen lässt.', 0);

-- campaign_chapters
INSERT INTO campaign_chapters (id, campaign_id, label, position, title_de, notes_de) VALUES
    (1, 1, '1', 10, 'Ridderhöhe', NULL),
    (2, 2, '1', 10, 'Der Versinkende Turm', NULL),
    (3, 3, '1', 10, 'Rynda', NULL);

-- campaign_places
INSERT INTO campaign_places (id, campaign_id, parent_id, chapter_id, position, number_label, name_de, description_de, dm_text_de, image_path, encounter_table_id) VALUES
    (1, 1, NULL, 1, 0, NULL, 'Ridderhöhe', NULL, NULL, NULL, NULL),
    (2, 1, 1, 1, 1, '1', 'Der Grabhügel', 'Auf einer Lichtung, mitten im Wald erhebt sich ein Hügel, auf dessen Kuppe massive Steine thronen. Es ist seltsam ruhig hier und ein schwacher, aber unheilvoller Geruch liegt in der Luft – ein modriger Gestank von Fäulnis.', '✦ Steinplatte: Eine grob behauene, 2×2 m große Steinplatte ist auf der Hügelkuppe in die Erde eingelassen. Sie wurde leicht aus ihrer ursprünglichen Position verschoben, wodurch ein schmaler Spalt den Hohlraum darunter offenbart. Die Platte ist schwer, aber um sie beiseitezuschieben, ist keine Probe nötig.
✦ Spuren & Abdrücke: Im Gras sind deutliche Fußspuren zu erkennen. Ein Charakter mit einer erfolgreichen Wildnisleben-Probe entdeckt außerdem kleine Häufchen von Wolfskot und Goblin-Exkrementen. Der Geruch kommt von Letzterem.
✦ Den Hügel verlassen: Wenn die Charaktere den Hügel verlassen, um draußen zu rasten oder sich zu heilen, würfle für jeden vergehenden Tagesabschnitt auf der Tabelle „Den Hügel verlassen".

Tabelle „Den Hügel verlassen" (W6):
1–3: Nichts passiert.
4–5: Eine Goblin-Patrouille taucht auf und greift sofort an. Die Gruppe ist den Charakteren um zwei Goblins überlegen und besitzt die gleichen Werte wie Grub.
6: Der Gruftschrecken taucht im Lager der Charaktere auf und greift sie sofort an, verschwindet jedoch, sobald er Schaden nimmt.', NULL, NULL),
    (3, 1, 1, 1, 2, '2', 'Schacht', 'Unter der Steinplatte befindet sich ein unterirdischer Schacht, dessen Ende nicht zu sehen ist. Aus seiner Tiefe steigt ein muffiger Geruch nach abgestandener Luft und ausgetrockneten Leichen empor.', '✦ Tiefer Fall: Bis zum Boden des Schachtes sind es fünf Meter. Jeder Charakter muss eine Akrobatik-Probe ablegen, um sicher hinabzuklettern. Mit einem Seil erhalten sie einen Vorteil. Wer die Probe verpatzt, stürzt und erleidet Sturzschaden (siehe Seite 19).
✦ Gewölbe: Lassen die Charaktere eine Fackel in den Schacht fallen, sehen sie, dass er in einer gewölbeartigen Kammer endet, an deren Nordwand sich eine Tür befindet.
✦ NORD: führt hinab ins Vestibül (#3).', NULL, NULL),
    (4, 1, 1, 1, 3, '3', 'Vestibül', 'Unter dem Schacht liegt eine gewölbeartige Kammer, deren Boden aus verdichteter Erde besteht. Weit oben an der Decke wirkt die Öffnung zur Erdoberfläche wie ein schwach leuchtendes Quadrat. An der Nordwand der Kammer befindet sich eine Doppeltür aus massivem Eichenholz mit Eisenbeschlägen. Ein silbernes Symbol erstreckt sich über beide Türflügel, die von Ritterstatuen in altertümlichen Rüstungen flankiert werden.', '✦ Durchbrochene Eichentür: Die Goblins haben die Tür bereits aufgebrochen; sie steht nur noch leicht angelehnt.
✦ Stilisierte Krone: Eine erfolgreiche Mythen & Legenden-Probe identifiziert das Symbol als stilisierte Krone aus der Zeit, als das Nebeltal von einem drachenanbetenden Königreich regiert wurde.
✦ Spuren im Dreck: Viele Fußabdrücke und Schleifspuren im Erdboden.
✦ NORD: Flügeltür zu den Hügeltunneln (#4).', NULL, NULL),
    (5, 1, 1, 1, 4, '4', 'Hügeltunnel', 'Ein dunkler, feuchter Erdtunnel führt vom Vestibül in ein sich verzweigendes Tunnelsystem. Die Luft ist kühl und erfüllt von muffigen Gerüchen. Kriechende Wurzeln, Würmer und Tausendfüßler hängen von der Decke wie Stalaktiten und erschweren das Vorankommen.', '✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel, das die Charaktere hier verbringen.
✦ NORD: Zugang zur Wachstube (#7).
✦ OST: Feuchter Erdtunnel zur Familiengruft (#6).
✦ SÜD: Flügeltür zum Vestibül (#3).
✦ WEST: Feuchter Erdtunnel zur Gruft der Dienerschaft (#5).

Tabelle „Zufällige Ereignisse" (W12 pro Viertel):
1: Goblin-Angriff! Eine Goblin-Patrouille kehrt auf Anweisung ihrer orkischen Anführerin zum Grabhügel zurück, um den Schatz zu bergen und (möglicherweise) ihre zurückgelassenen Kameraden zu retten. Die Gruppe ist den Charakteren um zwei Goblins überlegen und greift sofort an, flieht jedoch, sobald die Hälfte von ihnen besiegt ist. Die Goblins haben die gleichen Werte wie Grub.
2: Massakrierter Goblin. Die Charaktere finden die Überreste eines toten Goblins, dessen Körper verstümmelt ist. Bei einer Heilkunde-Probe stellen sie fest, dass dieser noch nicht lange tot ist.
3: Riesige Spinne. Die Charaktere werden von einer riesigen Spinne angegriffen, die in einem Hohlraum hinter einer der Wände haust (siehe Bestiary „Riesenspinne"). Dieses Ereignis kann nur einmal stattfinden.
4: Der Gruftschrecken. Der Gruftschrecken wurde gestört und greift an. Da er keinen materiellen Körper besitzt, kann er durch geschlossene Fallgitter und Türen hindurchgehen (benötigt dafür eine Aktion). Er zieht sich in seine Grabkammer (#9) zurück, wenn er die Hälfte seiner Lebenspunkte verloren hat, und erholt sich dort innerhalb eines Viertels vollständig.
5: Ruhelose Geister. Durchsichtige Gestalten mit verzerrten Gesichtern tauchen aus den Schatten auf und greifen mit kreischendem Geschrei an. Die Charaktere müssen eine WIL-Probe ablegen, um der Angst zu widerstehen. Die Geister dienten einst dem Drachenritter, der durch ihre Schreie nach W3 Runden zur Gruppe gelockt wird (siehe Ereignis „Der Gruftschrecken").
6: Drakonische Vision. Eine diffuse Erinnerung überkommt einen Charakter, der plötzlich eine seltsame Stadt mit zahlreichen Türmchen, Zinnen und hörnerartigen Turmspitzen vor sich sieht – ein riesiger Drache, geritten von einem Ritter in goldenem Kettenhemd und gehörntem Helm, kommt direkt auf ihn zu. Der Charakter muss eine WIL-Probe mit Nachteil ablegen, um dem Furchtangriff zu widerstehen. Dieses Ereignis kann nur einmal stattfinden.
7+: Nichts passiert.', NULL, NULL),
    (6, 1, 1, 1, 5, '5', 'Gruft der Dienerschaft', 'Die Kammer ist dunkel und feucht. Ausgehöhlte Grabnischen bedecken die Wände vom Boden bis zur Decke, und überall liegen zerfallene Skelette, zerfetzte Lumpen und zerschlagene Tonscherben.', '✦ Verwüstet: Die Gruft wurde von Grabräubern heimgesucht – Skelette auf den Boden geschleift, Gefäße zertrümmert, Kleidung aufgeschlitzt.
✦ Verschlossenes Fallgitter: Versperrt den Durchgang zur Halle der Dame (#8). Ein abgebrochener Schlüssel steckt fest, das Fallgitter lässt sich so nicht öffnen. Rüstungswert 10, kann mit 30 Schadenspunkten oder einem Zauber wie Pfeiler überwunden werden – lockt dabei sofort den Gruftschrecken an.
✦ Versteckter Goblin: Hinter Skelettresten in einer niedrigen Grabnische versteckt sich Grub, ein hyperventilierender Goblin. Nur durch gezieltes Absuchen der Nischen oder eine Entdecken-Probe zu finden.
✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Feuchter Erdtunnel zur Halle der Dame (#8), durch ein verschlossenes Fallgitter versperrt.
✦ SÜD: Feuchter Erdtunnel zu den Hügeltunneln (#4).', NULL, NULL),
    (7, 1, 1, 1, 6, '6', 'Familiengruft', 'In der finsteren Kammer sind an den Wänden sieben schlichte Steinsarkophage aufgereiht. Mehrere von ihnen sind geöffnet, und zwei Skelette liegen achtlos auf dem schmutzigen Erdboden.', '✦ Verwüstet: Drei der sieben Sarkophage wurden von den Goblins geöffnet und geplündert.
✦ Schätze: Die vier ungeöffneten Sarkophage enthalten einzeln beigesetzte Skelette (teils in Kindergröße) in zerfallenen zeremoniellen Gewändern. Alle tragen vergoldete Stirnbänder (je 5 Goldstück) und juwelenbesetzte Ringe (je 3 Goldstück).
✦ Verschlossenes Fallgitter: Ein eisernes Fallgitter versperrt den Durchgang zur Halle der Dame (#8). Lässt sich mit einem von Grubs unbeschädigten Schlüsseln öffnen (Fingerfertigkeit-Probe nötig; bei Misserfolg bricht der Schlüssel ab). Rüstungswert 10, alternativ 30 Schadenspunkte oder ein Zauber wie Pfeiler – lockt sofort den Gruftschrecken an.
✦ Falle: Vor dem Fallgitter liegt unter einer dünnen Erdschicht eine versteckte Falltür (Entdecken-Probe nötig). Unentdeckt stürzt der erste Charakter, der sich nähert, in eine Grube mit Holzpflöcken (3W6 Stichschaden, bei erfolgreicher Ausweichen-Probe halbiert).
✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Feuchter Erdtunnel zur Halle der Dame (#8), durch ein eisernes Fallgitter versperrt.
✦ SÜD: Feuchter Erdtunnel zu den Hügeltunneln (#4).', NULL, NULL),
    (8, 1, 1, 1, 7, '7', 'Wachstube', 'Die Wachstube ist ein kleiner Raum mit festgetretenem Erdboden. Das flackernde Licht einer Fackel dringt durch ein schwarzes, eisernes Fallgitter an der hinteren Wand, das von zwei mumifizierten Wachen mit verrosteten Kettenhemden und langen Speeren flankiert wird.', '✦ Verrostetes Fallgitter: Völlig verrostet, lässt sich selbst mit Grubs Schlüssel nicht öffnen. Rüstungswert 10, alternativ 30 Schadenspunkte oder ein Zauber wie Pfeiler – lockt sofort den Gruftschrecken an.
✦ Waffen & Rüstungen: Die mumifizierten Wachen bleiben regungslos. Ihre rostigen Kettenhemden zerfallen bei Berührung, doch jede Wache hält einen Langspeer, der mitgenommen werden kann.
✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Rostiges Fallgitter zur Halle der Dame (#8).
✦ SÜD: Zugang zu den Hügeltunneln (#4).', NULL, NULL),
    (9, 1, 1, 1, 8, '8', 'Die Halle der Dame', 'Der kleine Raum wird von Fackeln an den Wänden beleuchtet. In der Mitte befindet sich ein Eichentisch, an dessen Kopfende eine mumifizierte Frau mit vergoldetem Kettenhemd sitzt. Hinter der Mumie befindet sich eine eisenbeschlagene Eichentür, auf der ein uraltes Symbol aus glänzendem Silber prangt.', '✦ Die Dame des Hügels: Die mumifizierte Frau ist die Ehefrau des Drachenritters und bewacht den Eingang zu seiner letzten Ruhestätte. Sie erwacht als Geist, sobald die Charaktere versuchen, die Eichentür zu Raum #9 zu öffnen oder den Streithammer „Dämonenbrecher" zu berühren. Siehe Bestiary-Eintrag „Die Dame des Hügels".
✦ Der Dämonenbrecher: Ein prächtiger, juwelenbesetzter Streithammer (1h, Reichweite 2, 2W6 Wuchtschaden, Haltbarkeit 15) in den Händen der Mumie – magisch, leuchtet rot, wenn sich Dämonen im Umkreis von 10 m befinden.
✦ Kettenhemd: Das vergoldete Kettenhemd ist leicht und flexibel (Rüstungswert 4, Nachteil auf Heimlichkeit-Proben).
✦ Stilisierte Krone: Eine Mythen & Legenden-Probe zeigt, dass das Symbol auf der Eichentür dieselbe stilisierte Krone wie im Vestibül (#3) ist.
✦ Fackeln: Brennen mit magischem Feuer, das automatisch erlischt, sobald sie aus dem Grabhügel entfernt werden.
✦ Zufälliges Ereignis: Würfle einen W6+3 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Eiserne Eichentür zur Grabkammer des Drachenritters (#9).
✦ OST: Feuchter Erdtunnel zur Familiengruft (#6), versperrt durch ein eisernes Fallgitter.
✦ SÜD: Eisernes Fallgatter zur Wachstube (#7).
✦ WEST: Feuchter Erdtunnel zur Gruft der Dienerschaft (#5), versperrt durch ein eisernes Fallgitter.', NULL, NULL),
    (10, 1, 1, 1, 9, '9', 'Grabkammer des Drachenritters', 'In der Mitte der mit Fackeln beleuchteten Grabkammer steht ein Podest, auf dem ein kunstvoller, steinerner Sarkophag ruht. Wände, Decke und Boden sind mit Steinziegeln verkleidet, und an der gegenüberliegenden Wand prangt das Bild eines Drachenreiters.', '✦ Der geöffnete Sarkophag: Wurde mit enormer Kraft von innen geöffnet; Teile des zerbrochenen Deckels liegen verstreut auf dem Boden.
✦ Dämonenkrone: Eine vergoldete Krone, verzaubert um Schaden durch Dämonenangriffe zu halbieren (aufrunden). Die Wirkung erklären Runen, die mit einer Fremdsprachen-Probe entziffert werden können.
✦ Grabfalle: Eine Entdecken-Probe offenbart, dass die Krone mit einem Fallenmechanismus verbunden ist. Wird sie ohne einen gleichschweren Ersatzgegenstand entfernt, schießen zwanzig Klingen aus dem Sarkophag (Fingerfertigkeit-Probe zum sicheren Austausch; bei Misserfolg Ausweichen-Probe oder 2W6 Stichschaden für jeden Charakter im Umkreis von 2 m).
✦ Der Gruftschrecken: Falls noch nicht besiegt oder wieder auferstanden, greift er die Charaktere hier in seiner Grabkammer an.
✦ Fresko: Der Drachenreiter auf dem Wandgemälde trägt genau dieselbe Rüstung und denselben gehörnten Helm wie der Gruftschrecken.
✦ Inschrift: Uralte Runen neben dem Fresko. Eine Fremdsprachen-Probe verrät etwas über „das Geschenk des Kaisers" und einen „Heiligen Zorn", der alle verzehrt, die es wagen, dieses Geschenk zu entehren.
✦ Zufälliges Ereignis: Würfle einen W4+4 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ SÜD: Eisenbeschlagene Eichentür zur Halle der Dame (#8).', NULL, NULL),
    (11, 2, NULL, 2, 0, NULL, 'Magdalas Turm', NULL, NULL, NULL, NULL),
    (12, 2, 11, 2, 1, '1', 'Statuenhalle', 'Mit einem Knarren öffnet sich die schwere Holztür nach innen. Der Gestank von Seetang schlägt euch aus dem Inneren des Turms entgegen. Eine große Steinhalle – zweifellos einst prächtig – liegt nun vor euch wie eine Parodie ihrer selbst: Der Steinboden ist von einer Handbreit Wasser überflutet, ein Wandgemälde an der Nordwand ist mit verrottendem Seetang bedeckt und direkt vor euch, in der Mitte des Raumes, stehen zwei hohe Steinstatuen. Zwischen ihnen erkennt ihr etwas am Boden unter dem flachen Wasser.', '✦ Wandgemälde: Die gegenüberliegende Wand ist mit dem Bild einer idyllischen Szene bedeckt: ein Häuschen am Meer, zwei spielende Kinder, Vögel, die über das Wasser gleiten.
✦ Statue von Kamandur: Die westliche Statue in der Mitte des Raumes zeigt einen vermummten Mann mit langem Bart, der geradeaus blickt. Der rechte Arm der Statue ist erhoben, der Zeigefinger zeigt nach oben.
✦ Statue von Magdala: Die östliche Statue zeigt eine junge Frau in einem Gewand, deren Gesicht nach unten zum Boden geneigt ist. Die linke Hand der Statue ruht auf ihrer Brust, wobei Mittel- und Ringfinger ausgestreckt sind.
✦ Kupferplatten: Sechs runde Platten aus grünem Kupfer, jeweils einen Meter im Durchmesser, sind im Boden zwischen den Statuen eingelassen. Ein Entdecken-Erfolg erkennt sie als Druckplatten. Drückt jemand fest auf eine oder mehrere Platten oder steht darauf, ertönt ein lautes Klicken. Werden eine, drei, vier, fünf oder sechs Platten gedrückt, schießt ein Blitz von der Decke und verursacht W6 Schaden bei jedem, der auf dem überfluteten Boden steht (Rüstung wirkungslos). Werden genau zwei Platten gedrückt, entfaltet sich stattdessen eine Steintreppe in der südwestlichen Ecke des Raumes.
✦ Handsymbol: Genau in der Mitte des Raumes ist eine riesige Hand in den Steinboden gemeißelt.
✦ Treppe in die Tiefe: Am gegenüberliegenden Ende der Halle führt eine Steintreppe hinunter ins Wasser, in den Keller (#2), der vollständig unter Wasser steht.
✦ Verborgene Treppe: Erscheint nur, wenn genau zwei Kupferplatten gleichzeitig gedrückt werden, und führt hinauf zur Bibliothek (#3).', 'images/campaigns/2/floor-1.jpg', NULL),
    (13, 2, 11, 2, 2, '2', 'Keller', 'Das kalte Wasser ist dunkel und trüb, aber die Umrisse dessen, was einst ein Keller war, lassen sich in der Finsternis erkennen. Das Bild eines Auges ist in den Steinboden gemeißelt und starrt euch entgegen.', '✦ Unter Wasser: Der gesamte Keller liegt unter dem Meeresspiegel, daher müssen die Charaktere schwimmen, um sich fortzubewegen. Wer sich bewegen oder etwas untersuchen möchte, muss eine Schwimmen-Probe ablegen (keine Aktion). Zusätzlich muss jede Runde eine KON-Probe gelingen, um die Luft anzuhalten (Seite 19).
✦ Monster-Aal: Ein drei Meter langer Monster-Aal hat sein Nest in der südwestlichen Ecke des Kellers und greift die Charaktere aus dem Hinterhalt an, unmittelbar nachdem einer von ihnen ins Wasser gegangen ist (siehe Bestiary „Monster-Aal").
✦ Augensymbol: Ein großes Auge ist in den Boden gemeißelt, an derselben Stelle und in derselben Größe wie das Handsymbol in der Statuenhalle. Es ist ein Hinweis auf das Rätsel in der Bibliothek, zwei Stockwerke höher (#3).
✦ Galionsfiguren: In der nordwestlichen Ecke lehnen ein Dutzend halbverrotteter Galionsfiguren an der Wand. Ihre grinsenden Gesichter zwingen jeden, der an ihnen vorbeischwimmt, zu einer WIL-Probe; bei Misserfolg Ergebnis #2 der Furchttabelle (Seite 19), also der Zustand Verängstigt.
✦ Fässer: In der südöstlichen Ecke liegen zwanzig zerbrochene Fässer übereinandergestapelt. Ein Charakter, der sie untersucht und eine Entdecken-Probe schafft, findet einen zufälligen Schatz.
✦ Öffnung & Schiffswrack: Die südwestliche Ecke des Kellers ist zum Meer hin aufgerissen. Wer sich nähert, erkennt das Wrack eines zweimastigen Schiffs auf dem Meeresboden – „Blaue Medusa" steht verblasst am Rumpf. Zwei erfolgreiche Schwimmen-Proben sind nötig, um es zu erreichen und zu betreten; im Inneren finden sich zwei zufällige Schätze.
✦ Treppe: Führt hinauf zurück in die Statuenhalle (#1).', 'images/campaigns/2/floor-2.jpg', NULL),
    (14, 2, 11, 2, 3, '3', 'Bibliothek', 'Hohe Bücherregale, die sich vom Boden bis zur Decke erstrecken und ein kleines Labyrinth bilden. Die durchhängenden Regale sind dicht gefüllt mit ledergebundenen Bänden, und der Raum riecht nach Papier und Schimmel. Aus der Mitte des Raumes ist ein leises Kratzen zu hören.', '✦ Das Buch: Alle Bücher hier tragen den Titel „Das Leben und der unzeitige Tod der Magdala", verfasst von Kamandur mit Hilfe des Schreibers Arlidus. Ein erfolgreicher Fremdsprachen-Wurf enthüllt Huldigungen an Magdala sowie Flüche gegen die Piraten, die sie getötet haben.
✦ Geist des Bibliothekars: An einem Schreibtisch in der Raummitte sitzt der Geist des Bibliothekars Arlidus, der seinen Dienst auch nach dem Tod fortsetzt (siehe Bestiary „Geist des Bibliothekars"). Die Charaktere müssen jede Runde eine Heimlichkeit-Probe bestehen, um mehr zu tun als stillzustehen. Beim ersten Fehlschlag fährt der Geist hoch und erschreckt alle in Sichtweite (Furchtangriff); beim zweiten Fehlschlag greift er an. Bleiben alle Charaktere still, kehrt er zu seiner Arbeit zurück.
✦ Schiffssymbol: Das Bild eines Schiffes ist in der Raummitte in den Steinboden gemeißelt – ein Hinweis auf das Rätsel im Labor, zwei Stockwerke höher (#5).
✦ Buchständer: Drei hölzerne Sockel tragen je ein Buch mit eingraviertem Symbol: Schwert (öffnet die Nordtür, dahinter ein zufälliger Schatz), Kreuz (öffnet die Südtür, löst aber sofort den Angriff des Geistes aus, dahinter ebenfalls ein zufälliger Schatz) und Auge (öffnet die Osttür, ohne den Geist zu alarmieren, dahinter eine Treppe hinauf zur Schatzkammer #4).
✦ Verborgene Türen: Drei verborgene Türen (Nord/Süd/Ost) lassen sich am einfachsten über die Bücher öffnen, alternativ durch eine Entdecken-Probe beim Durchsuchen oder mit Fingerfertigkeit mit Nachteil aufbrechen.
✦ Treppe: Führt hinunter in die Statuenhalle (#1) zurück (verborgene Treppe von dort).', 'images/campaigns/2/floor-3.jpg', NULL),
    (15, 2, 11, 2, 4, '4', 'Schatzkammer', 'Zehn hölzerne, sargartige Truhen stehen fächerförmig in der Halle, fünf auf jeder Seite. Entlang der Wände stehen fünf Plattenrüstungen, bewaffnet mit Dreizacken. Durch die Lücken in den Rüstungen könnt ihr grinsende Totenschädel erkennen. An der Nordwand ist ein verblasstes Wandgemälde zu sehen.', '✦ Skelettwachen: Fünf Skelette in den Plattenrüstungen erwachen und greifen an, sobald jemand sie oder eine der Truhen berührt (siehe NPC-Eintrag „Skelettwache").
✦ Truhen: Drei der zehn sargartigen Truhen enthalten Schätze, der Rest sind Fallen. Die Statuen in der Statuenhalle (#1) zwei Stockwerke tiefer verraten die Lösung: Kamandur (Westen, rechter Zeigefinger erhoben) zeigt, dass auf der Westseite die zweite Truhe von Norden aus gesehen richtig ist. Magdala (Osten, Mittel- und Ringfinger ausgestreckt) zeigt, dass auf der Ostseite die dritte und vierte Truhe von Norden aus gesehen richtig sind. Sobald zwei richtige Truhen geöffnet wurden, entfaltet sich eine Steintreppe aus der Südwand. Öffnet ein Charakter eine falsche Truhe, öffnet sich stattdessen eine Falltür: Der Charakter stürzt durch einen Schacht ins Meer (siehe „Das Meer" unten), und sofort erwachen alle Skelettwachen zum Leben.
✦ Sonnensymbol: Ein Symbol in Form einer Sonne ist in der Raummitte in den Steinboden gemeißelt – ein Hinweis für die Kammer des Zauberers, zwei Stockwerke höher (#6).
✦ Wandgemälde: Zeigt zwei junge Menschen an einem Strand, Hand in Hand, umgeben von magischer Energie, leicht über dem Boden schwebend und glücklich wirkend.
✦ Das Meer: Charaktere, die ins Meer stürzen, müssen einen Zustand wählen und eine Schwimmen-Probe ablegen, um zurück in den Turm zu gelangen (jeder Versuch zählt als eine Aktion). Drinnen muss pro Stockwerk einmal gesprintet werden – von der Statuenhalle (#1) bis zur Schatzkammer dauert es also zwei Runden.
✦ Der Abenteurer: Sind die Skelette besiegt, hören die Charaktere ein gedämpftes Geräusch unter einer ungeöffneten, leeren Truhe. Öffnen sie diese vorsichtig mit einem langen Gegenstand, lösen sie eine Falltür aus, ohne selbst hineinzufallen, und finden den Zwerg Alberich Glanzherz, der in den Schacht gestürzt ist und sich am Rand festhält (siehe NPC-Eintrag „Alberich Glanzherz"). Mit einem Seil oder einer erfolgreichen Akrobatik-Probe kann er heraufgeholt werden; aus Dankbarkeit gibt er den Charakteren einen zufälligen Schatz.
✦ Treppen: Hinunter zur Bibliothek (#3); eine verborgene Treppe führt hinauf zum Labor (#5), sobald zwei richtige Truhen geöffnet wurden.', 'images/campaigns/2/floor-4.jpg', NULL),
    (16, 2, 11, 2, 5, '5', 'Labor', 'Der gesamte Raum wird von Holzregalen und Werkbänken eingerahmt, übersät mit zerbrochenem Glas und Überresten dessen, was einst alte Experimente gewesen sein müssen. In der Mitte des Raumes steht ein zwei Meter hoher, gebogener Eisenkäfig, und in der Dunkelheit darin siehst du eine Gestalt, die euch beobachtet.', '✦ Käfig: Die Gefangene ist Kapitänin Beatrix Segelweit, ehemalige Gefährtin des Zwergs Alberich (siehe NPC-Eintrag „Beatrix Segelweit"). Sie versucht drohend, schmeichelnd und bestechend, befreit zu werden. Das Anheben des Käfigs erfordert eine STÄ-Probe mit Nachteil (mehrere Charaktere können zusammenarbeiten).
✦ Lindwurmsymbol: Ein Lindwurm ist in den Steinboden gemeißelt, vom Käfig verdeckt – sichtbar erst, wenn dieser angehoben wird. Es ist ein Hinweis auf das Rätsel im Observatorium (#7).
✦ Elixier: Eine unbeschädigte Flasche mit klarer roter Flüssigkeit enthält Kamandurs Schrumpfmagie-Elixier. Wer davon trinkt, schrumpft sofort auf etwa 10 cm Körpergröße (Vorteil auf Heimlichkeit-Proben, aber nie mehr als ein Schadenspunkt pro Angriff). Der Effekt endet bei Wasserkontakt oder durch Gegenzauber.
✦ Magisches Rezept: Eine sorgfältige Untersuchung der Werkbänke oder eine Entdecken-Probe findet ein Pergament mit einer Schrumpfformel (Fremdsprachen-Probe zum Verständnis); eine Mythen & Legenden- oder Elementarmagie-Probe verrät, dass die Schrumpfmagie durch Wasserkontakt gebrochen wird.
✦ Glasgefäße: Ein intaktes Glas enthält eine geschrumpfte Riesenspinne (gleiche Werte wie in Ridderhöhe, siehe Bestiary „Riesenspinne"). Zerbricht das Glas und die Spinne kommt mit Wasser in Kontakt, wächst sie auf gigantische Größe und greift sofort die nächstgelegene Bedrohung an.
✦ Buddelschiff: Ein intaktes Buddelschiff ist in Wahrheit ein von Kamandur geschrumpftes echtes Schiff. Wird es vom Regal genommen, entfaltet sich mit einem Grollen die Treppe zum nächsten Stockwerk. Kommt es mit Wasser in Kontakt, wächst es zu seiner wahren Größe heran.
✦ DM-Tipp – Die Experimente: Riesenspinne, Buddelschiff und Elixier lassen sich klug einsetzen: Die Spinne kann gegen die Galionsfiguren in der Kammer des Zauberers (#6) gehetzt werden (beide erledigen sich gegenseitig, keine Würfe nötig) oder Krakul im Observatorium (#7) ablenken. Das Schiff kann zur Flucht am Ende des Abenteuers dienen oder ebenfalls Krakul ablenken. Das Elixier kann Krakul in den Mund geworfen werden (Wurf mit Nachteil gegen eine GEW-basierte Waffenfertigkeit nötig) und schrumpft ihn sofort zu einer harmlosen kleinen Schlange – bis er mit Wasser in Kontakt kommt.
✦ Treppen: Hinunter zur Schatzkammer (#4); eine verborgene Treppe führt hinauf zur Kammer des Zauberers (#6), sobald das Buddelschiff entnommen wurde.', 'images/campaigns/2/floor-5.jpg', NULL),
    (17, 2, 11, 2, 6, '6', 'Kammer des Zauberers', 'Schwere, dunkle Vorhänge bedecken die Fenster und hüllen das gesamte Stockwerk in Schatten und Düsternis. An der Nordwand steht ein prächtiges Himmelbett, dessen geschlossene Vorhänge das Innere verbergen. An der Südwand befindet sich ein weiteres Wandgemälde. In den vier Ecken des Raumes kannst du die Konturen riesiger, furchterregender Galionsfiguren erkennen, geformt wie Bestien mit grinsenden Kiefern.', '✦ Galionsfiguren: Vier verzauberte Galionsfiguren erwachen sofort zum Leben, sobald jemand eine Figur, einen Vorhang oder das Himmelbett berührt, und greifen dann gemeinsam an (siehe Bestiary „Verzauberte Galionsfigur").
✦ Vorhänge: Schwere Vorhänge bedecken die vier Wände und können mühsam mit einem Seil pro Ecke zur Seite gezogen werden (eine Aktion je Seite). Für jeden geöffneten Vorhang erstarrt eine Galionsfigur wieder zu unbelebter Materie. Wird der vierte Vorhang zurückgezogen, entfaltet sich die Treppe zum Observatorium (#7) aus der Decke.
✦ Wandgemälde: Zeigt denselben Strand wie die anderen Wandbilder, umrahmt von dunklen Wolken – der junge Mann kniet bei der toten jungen Frau, das Haus brennt, im Hintergrund segelt ein Schiff fort.
✦ Himmelbett: Im Bett liegt der wächserne Leichnam des Zauberers Kamandur selbst, die Hände über der Brust gefaltet. An seinem Körper findet sich ein zufälliger Schatz.
✦ Treppen: Hinunter zum Labor (#5); die Treppe hinauf zum Observatorium (#7) entfaltet sich, sobald alle vier Vorhänge geöffnet wurden.', 'images/campaigns/2/floor-6.jpg', NULL),
    (18, 2, 11, 2, 7, '7', 'Observatorium', 'Die Spitze des Turms besteht aus einer großen Glaskuppel, die in ein unnatürlich grünes Licht getaucht ist. Außerhalb der Kuppel erstreckt sich das Meer in alle Richtungen, und ein Balkon verläuft rund um den Turm. In der Mitte des Raumes befindet sich ein Steinpodest, auf dem zwei hell leuchtende, smaragdartige Steine ruhen. Am nördlichen Ende des Stockwerks steht ein schwarzer Steinsarkophag.', '✦ Der Junge: Hinter dem Podest sitzt schluchzend Orvild, der Geist eines Schiffsjungen (siehe NPC-Eintrag „Orvild"). Mit Freundlichkeit oder einer erfolgreichen Überzeugen-Probe erzählt er von seiner Lage; bringen die Charaktere ihn zum Wrack der Blauen Medusa im Keller (#2, dafür eine Schwimmen-Probe durch die überflutete Statuenhalle #1 und den Keller nötig), dankt er ihnen und verschwindet für immer.
✦ Sarkophag: Das Relief auf dem Deckel zeigt Magdala, wiedererkennbar von den Wandgemälden weiter unten. Eine STÄ-Probe mit Nachteil hebt den Deckel (mehrere Charaktere können zusammenarbeiten). Im Sarkophag liegt Magdalas Skelett samt einem zufälligen Schatz; eine abgetrennte Skeletthand am Deckelrand deutet auf einen früheren Abenteurer hin, der in der Fesselfalle gefangen war.
✦ Fesselfalle: Wird das Innere des Sarkophags berührt, schließt sich eine schwere Eisenfessel ums Handgelenk. Sie ist am Sarkophag befestigt (Rüstungswert 10), lässt sich aber mit 20 Punkten Hieb- oder Wuchtschaden gewaltsam sprengen.
✦ Die Zwillingssteine: Zwei identische Smaragde ruhen auf dem Podest. Unter dem westlichen Stein ist das Bild eines Dämons, unter dem östlichen das eines Lindwurms verborgen. Wird der Stein vom Dämonenbild entfernt, beginnt der Turm sofort zu sinken (siehe „Der Turm sinkt" unten). Wird der Stein vom Lindwurmbild entfernt, erscheint der Lindwurm Krakul, um seinen gestohlenen Smaragd zurückzufordern (siehe Bestiary „Krakul" und „Krakuls Rache" unten). Werden beide Steine genommen, passiert beides gleichzeitig.
✦ Krakuls Rache: Hat ein Charakter im Ruderboot das Angebot Des Einäugigen angenommen, fordert Krakul beim Erscheinen den Smaragd zurück; erhält er ihn, füllt der Stein seine leere Augenhöhle, er dankt den Charakteren und taucht ins Meer ab. Wurde das Angebot nicht angenommen, greift Krakul sofort an, ist aber bereit, die Charaktere zu verschonen, wenn sie ihm den Smaragd überlassen.
✦ Balkon: Ein Sprung ins Meer ist möglich; eine Schwimmen-Probe verhindert W6 Wuchtschaden durch den Aufprall.
✦ Der Turm sinkt: Wird ein Smaragd genommen, die Sarkophag-Falle ausgelöst oder läuft der Zwei-Stunden-Timer ab, beginnt der Turm rasch zu sinken. Sofort verschwindet ein Stockwerk im Meer, danach jede Runde ein weiteres, beginnend bei der Statuenhalle (#1), dann Bibliothek (#3), Schatzkammer (#4), Labor (#5), Kammer des Zauberers (#6) und schließlich – zu Beginn der vierten Runde – das Observatorium (#7) selbst. Spiele diese letzten Runden im schnellen Tempo: Dies ist das Finale des Abenteuers!
✦ Wertung (Kurzfassung): Punkte gibt es u. a. für gefundene Schätze und entdeckte Stockwerke (je 1), für besiegte oder umgangene Monster und gelöste Rätsel beim ersten Versuch (meist 1–2), für gerettete Ersatzcharaktere (Alberich 2, Beatrix 1), für Orvild zum Wrack gebracht (1), den Smaragd an Krakul übergeben (1) oder Krakul besiegt (3) sowie −1 pro getötetem Spielercharakter. Bei Gleichstand gewinnt die Gruppe mit den meisten verbleibenden TP der ursprünglichen Charaktere.', 'images/campaigns/2/floor-7.jpg', NULL),
    (19, 3, NULL, NULL, 10, NULL, 'Die Nebelmark', 'Ein Landstrich aus Wiesen und Mooren, über dem selbst mittags ein feiner Dunst hängt. Wer hier reist, hört Wasser, aber sieht es selten.', 'Grenzland ohne Herrscher. Die Dörfer verwalten sich selbst; Banditen und Untote sind das größere Problem als jeder Steuereintreiber.', NULL, 1),
    (20, 3, 19, 3, 10, NULL, 'Rynda', 'Ein kleines Dorf am Fluss. Fachwerkhäuser, ein Brunnen auf dem Platz und überall der Geruch von frischem Brot.', 'Rund 150 Einwohner. Der Dorfvorsteher ist ein Schwächling, die eigentliche Macht liegt bei Alberta und ihrem Hundekampfring.', NULL, NULL),
    (21, 3, 19, NULL, 20, NULL, 'Die verlassene Bibliothek', 'Ein eingestürzter Seitenflügel, Regale voller feuchter Bücher, durch das Dach fällt Licht. Es riecht nach Moder.', 'Das Buch „Schwächen der Untoten“ steckt in der Ecke hinter dem umgekippten Regal. Wer 10 Minuten sucht, findet es ohne Probe.', NULL, 3),
    (22, 3, 20, 3, 10, '1', 'Wirtshaus „Zum schiefen Krug“', 'Niedrige Decke, Rauch, ein Wirt, der jeden Gast mit Namen begrüßt. Auf dem Tresen klebt etwas, das einmal Honig war.', 'Hier laufen Gerüchte zusammen. Der Wirt verkauft Roten Bahringer unter dem Tisch.', NULL, NULL),
    (23, 3, 20, 3, 20, '2', 'Bäckerei Segenreich', 'Warme Stube, hinter der Theke Regale voller Brote. Neben der Tür hängt ein Hundehalsband an einem Haken.', 'Der Keller führt zum Hundekampfring (Zugang über eine Falltür hinter dem Mehlsack).', NULL, NULL),
    (24, 3, 23, 3, 10, '3', 'Der Hundekampfring', 'Ein Kellerraum mit Sand auf dem Boden, Holzbänken an den Wänden und einem Käfig an der Stirnseite.', 'Kämpfe jeden dritten Abend. Einsatz: 1 Silber. Die Hunde zählen als Wölfe, aber mit 2 TP weniger.', NULL, NULL);

-- campaign_items
INSERT INTO campaign_items (id, campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, text_de, image_path) VALUES
    (1, 3, 3, 22, 'Unter dem Tisch, wenn der Wirt der Gruppe traut', 'Roter Bahringer', 'Ein dunkelroter, schwerer Wein mit einem Hauch von Kirsche. Er wärmt von innen.', 'Orvild, der Wirt und jeder Trinker der Nebelmark würden dafür einiges tun. Ein Schluck verscheucht Kälte.', NULL, NULL),
    (2, 3, 3, 21, 'In der Ecke hinter dem umgekippten Regal, nach etwa 10 Minuten Suchen', 'Schwächen der Untoten', 'Ein dünnes, in Leder gebundenes Buch mit Randnotizen. Zwei Seiten sind verklebt.', 'Zeigt, dass der Gruftschrecken Silber fürchtet und dass Geister Salz nicht überqueren können. Zwei Seiten Text, kein Epos.', 'Silber brennt, wo Stahl nur kratzt: Der Gruftschrecken weicht jeder versilberten Klinge. Geister vermögen keine Linie aus Salz zu überschreiten, ob an Tür, Fenster oder Grabstein.', NULL),
    (3, 3, 3, NULL, NULL, 'Rostiger Schlüsselring', 'Drei Schlüssel an einem verrosteten Ring. Einer ist abgebrochen.', 'Passt zu den Fallgittern in einer Gruft. Nur ein Schloss funktioniert wirklich.', NULL, NULL);

-- campaign_npcs
INSERT INTO campaign_npcs (id, campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, notes_de, bestiary_id, portrait_path) VALUES
    (1, 1, NULL, NULL, NULL, 'Grub', 'Grub, der Goblin, ist ein erbärmlicher Anblick: schmutzig, mit aufgerissenen Augen und hysterisch keuchend. Er trägt eine ramponierte und kaputte Lederrüstung und stinkt nach Angst und verschiedenen Goblin-Körperflüssigkeiten. Er versteckt sich hinter skelettierten Überresten in einer niedrigen Grabnische in der Gruft der Dienerschaft (#5) und ist das letzte überlebende Mitglied von Maladûks Expedition.', 'Rolle: Überlebender Goblin-Grabräuber

Grub ist zu Tode verängstigt und will nur noch lebend aus dem Hügel herauskommen. Lassen die Charaktere ihn in Ruhe, versucht er zu fliehen. Können sie ihn mit einer Überzeugen-Probe beruhigen, hilft er ihnen: Er hat die Bewegungen des Gruftschreckens beobachtet und weiß, dass dieser sich ungehindert durch die Erdwände bewegen kann, aber bislang nicht durch die Eichentür des Vestibüls (#3) gegangen ist. Außerdem trägt er einen rostigen Eisenring mit drei Eisenschlüsseln – zwei unbeschädigt (passend zu den Fallgittern in #6 und #7, wobei nur das Schloss in #6 tatsächlich funktioniert) und einen abgebrochenen (der Rest steckt im Schloss von #5).

TP: 9 · Bewegung: 12 · Schadensbonus: — · Rüstung: Lederrüstung (1)
Fertigkeiten: Ausweichen 12, Heimlichkeit 14, Wahrnehmung 10
Waffen: Kurzschwert (Fertigkeitswert 12, Schaden W10), Kurzbogen (Fertigkeitswert 10, Schaden W10)', NULL, NULL, NULL),
    (2, 1, NULL, NULL, NULL, 'Die Dame des Hügels', NULL, NULL, NULL, 10, 'images/creatures/3.jpg'),
    (3, 1, NULL, NULL, NULL, 'Der Gruftschrecken von Ridderhöhe', NULL, NULL, NULL, 4, NULL),
    (4, 2, NULL, NULL, NULL, 'Der Einäugige', 'In einem Ruderboot am Fuß des Turms steht ein alter Mann, eingehüllt in einen braunen Umhang. Sein Gesicht ist vom Wetter gezeichnet und mit Falten durchzogen, und eine schwarze Augenklappe bedeckt sein linkes Auge. Er beginnt zu sprechen: „Ihr seid nicht die Ersten, die nach dem suchen, was euch nicht gehört, aber ich hoffe, ihr seid die Letzten. Wer ich bin, spielt keine Rolle, aber im Turm liegt etwas, das mir gehört. Ein grüner Smaragd, der mir vor langer Zeit gestohlen wurde. Bringt mir den Smaragd zurück, und ihr dürft den Rest der Schätze behalten, die ihr dort findet. Im Gegenzug biete ich euch ein Lebenselixier. Wer davon trinkt, wird aus dem Reich der Toten zurückgeholt.“', 'Rolle: Mysteriöser Fremder (in Wahrheit der Lindwurm Krakul)

Der alte Mann ist in Wahrheit die Lindwurmkreatur Krakul in Menschengestalt (siehe Bestiary „Krakul"). Nimmt ein Charakter sein Angebot an, erhält er eine Flasche mit einer Dosis Elixier: Ein Spielercharakter mit 0 TP heilt damit automatisch W6 TP und muss keine Todeswürfe mehr ablegen (wirkt nicht bei Sofortigem Tod). Im Gegenzug muss der Charakter versprechen, Krakul den Smaragd zurückzubringen – das wird später im Observatorium (#7) bei den Zwillingssteinen wichtig (siehe „Krakuls Rache").', NULL, NULL, NULL),
    (5, 2, NULL, NULL, NULL, 'Alberich Glanzherz', 'Ein Zwerg, der den Turm bereits auf eigene Faust erkundet hat und versehentlich in eine Falltür in der Schatzkammer (#4) gestürzt ist. Er hat es geschafft, sich am Rand des Schachts festzuhalten und steckt nun dort fest.', 'Rolle: Zwergischer Abenteurer, Ersatzcharakter

Aus Dankbarkeit für seine Rettung gibt Alberich den Charakteren einen zufälligen Schatz und bittet danach darum, im Ruderboot der Abenteurer warten zu dürfen – er hat genug Abenteuer erlebt. Er dient als Ersatzcharakter, falls einer der Abenteurer während des Spiels stirbt.

TP: 14 · WP: 11 · Bewegung: 10 · Schadensbonus: GEW+W4 · Rüstung: —
Fertigkeiten: Entdecken 12, Feilschen 14, Heimlichkeit 12, Mythen & Legenden 12, Täuschen 14, Überzeugen 14, Wahrnehmung 8
Talente: Goldnase, Nachtragend
Ausrüstung: Dolch (Fertigkeitswert 12, Schaden W8), Seil (Hanf), Laterne, Lampenöl, Feuerstein & Zunder, 10 Silberstücke', NULL, NULL, NULL),
    (6, 2, NULL, NULL, NULL, 'Beatrix Segelweit', 'Gefangen in einem zwei Meter hohen, gebogenen Eisenkäfig im Labor (#5) – vermutlich Teil einer ausgelösten Falle. Kapitänin Beatrix Segelweit ist die ehemalige Gefährtin des Zwergs Alberich Glanzherz.', 'Rolle: Seefahrerin, Ersatzcharakter

Beatrix versucht alles – drohen, schmeicheln, einschüchtern und bestechen –, um die Charaktere dazu zu bringen, sie zu befreien (Anheben des Käfigs: STÄ-Probe mit Nachteil, mehrere Charaktere können zusammenarbeiten). Wird sie nicht befreit, erkundet sie den Turm auf eigene Faust weiter. Sie dient als Ersatzcharakter, falls einer der Abenteurer während des Spiels stirbt.

TP: 12 · WP: 16 · Bewegung: 12 · Schadensbonus: STÄ/GEW+W4 · Rüstung: —
Fertigkeiten: Akrobatik 12, Ausweichen 12, Entdecken 10, Fingerfertigkeit 12, Fremdsprachen 10, Handwerk 12, Schwimmen 12, Seefahrt 10, Wahrnehmung 10
Talente: Anpassungsfähig, Seebeine
Ausrüstung: Krummsäbel (Fertigkeitswert 14, Schaden 2W6), Seil (Hanf), Wurfhaken, Fernglas, 10 Silberstücke', NULL, NULL, NULL),
    (7, 2, NULL, NULL, NULL, 'Skelettwache', 'In den uralten, von Wasser und Seetang grün verfärbten Plattenrüstungen entlang der Wände der Schatzkammer (#4) befinden sich fünf Skelette, bewaffnet mit Dreizacken.', 'Rolle: Wiederbelebtes Skelett in Plattenrüstung

Die Skelette erwachen zum Leben und greifen an, sobald jemand sie oder eine der Truhen in der Schatzkammer berührt.

TP: 8 · Bewegung: 8 · Schadensbonus: — · Rüstung: Plattenharnisch (6)
Fertigkeiten: Ausweichen 6, Wahrnehmung 8
Waffen: Dreizack (Fertigkeitswert 12, Schaden W10)', NULL, NULL, NULL),
    (8, 2, NULL, NULL, NULL, 'Orvild', 'Ein schluchzender Junge sitzt mit dem Kopf in den Händen auf dem Boden hinter dem Podest mit den Zwillingssteinen im Observatorium (#7). Es ist Orvild, ein Schiffsjunge, der als Geist weiterexistiert – getrieben von der Trauer darüber, verloren und von seiner Mannschaft sowie dem Schiff, auf dem er diente, alleingelassen worden zu sein.', 'Rolle: Geist eines Schiffsjungen

Mit Freundlichkeit oder einer erfolgreichen Überzeugen-Probe erklärt Orvild den Charakteren, dass er nicht weiß, wo er ist oder wohin sein Schiff, die Blaue Medusa, verschwunden ist. Sagen ihm die Charaktere, wo sich das Wrack befindet (siehe „Schiffswrack" im Keller #2), ist er dankbar, weiß aber nicht, wie er dorthin gelangen soll. Führen die Charaktere Orvild zum Wrack, dankt er ihnen freudestrahlend und verschwindet für immer.', NULL, NULL, NULL),
    (9, 2, NULL, NULL, NULL, 'Krakul', NULL, 'Rolle: Lindwurm

In Menschengestalt tritt Krakul als „Der Einäugige“ auf.', NULL, 8, NULL),
    (10, 3, 3, 23, NULL, 'Alberta', 'Eine ältere Frau mit Mehl an den Händen und einem Blick, der durch Wände geht. Sie ist die Bäckerin von Rynda.', 'Theater: raue Stimme, unterbricht gern, wird bei Hunden weich. Geheimnis: leitet im Keller einen Hundekampfring.', NULL, NULL, NULL),
    (11, 3, 3, 22, NULL, 'Der Wirt Ottmar', 'Breit, rotgesichtig und immer eine Schürze um den Bauch. Er kennt jeden Namen.', 'Theater: leise, verschwörerisch. Verkauft Roten Bahringer unter der Hand und kennt jedes Gerücht der Nebelmark.', NULL, NULL, NULL);

-- campaign_bestiary
INSERT INTO campaign_bestiary (campaign_id, bestiary_id, chapter_id, notes_de) VALUES
    (1, 1, NULL, NULL),
    (1, 2, NULL, NULL),
    (2, 1, NULL, NULL),
    (2, 5, NULL, NULL),
    (2, 6, NULL, NULL),
    (2, 7, NULL, NULL);

-- ============================================================
-- Kampagne 4: Die Burg des Raubritters (Grundregelwerk, Kapitel 8)
-- ============================================================

INSERT INTO campaigns (id, name_de, teaser_de, background_de, is_default) VALUES
    (4, 'Die Burg des Raubritters', 'Eine Burgruine, ein kopfloser Raubritter und eine Bande listiger Goblins: ein einfacher Einstieg in Dragonbane für 3–5 Charaktere.', 'Dieses Abenteuer ist eine einfache Einführung in Dragonbane. Wie alle Abenteuer hat es keine vorgegebene Handlung, die Spielenden erkunden einen interessanten Ort. Es gibt also kein festgelegtes Ende für Die Burg des Raubritters.

Zeige den Spielenden die Karte der Burg und lies ihnen den Text darüber vor. Zeichne den Umriss der Burg anhand der Karte und fülle ihn aus, während die Charaktere die verschiedenen Räume erkunden. Viel Glück!

Die Lage

Vor langer Zeit verwüstete ein brutaler Raubritter die Gegend, in der dieses Abenteuer spielt. Sein Name war Rothgar Wolfsbane, und er bekämpfte alle, die ihm in den Weg kamen: Menschen, Zwerge, Elfen und Orks. Der Klang seines gefürchteten Kriegshorns ließ das Blut seiner Feinde gefrieren.

So verhasst war Wolfsbane, dass die Alten Völker, die seit Ewigkeiten verfeindet gewesen waren, ihre Fehden beiseitelegten und sich gegen ihren gemeinsamen Feind vereinten. Schließlich belagerte eine Horde Orks die Burg, in der sich Wolfsbane verschanzt hatte. Die Schlacht um die Burg war blutig, und viele Orks fielen unter der Klinge des Raubritters, doch am Ende überwältigten sie ihn: Rothgar Wolfsbane wurde von einem Ork-Krummsäbel der Kopf abgeschlagen, während seine Burg in Flammen stand. Die Schreckensherrschaft des Raubritters war vorbei.

Viele Jahre später ist der Lärm der Schlacht verhallt, aber die Ruinen der Burg stehen noch. In mondhellen Nächten haben vorbeiziehende Reisende den Klang von Wolfsbanes Kriegshorn gehört und den kopflosen Raubritter als Geistererscheinung gesehen. Gerüchte erzählen von verschwundenen Karawanen und Abenteurern in der Nähe der Ruine, und heutzutage machen die meisten Leute einen Bogen um den Hügel.

Es stimmt, dass der Raubritter wieder umgeht. Aber niemand weiß, dass eine Bande Goblin-Banditen unter der Führung des gerissenen Jaldo den kopflosen Wiedergänger beschwört, um Leute zu verscheuchen. Sie haben die Burg zu ihrem Zuhause gemacht, und von dort aus rauben sie die Umgebung aus.

DM-Tipp – Zufällige Ereignisse: Für jedes volle Viertel, das die Charaktere in der Burg verbringen, etwa beim Durchsuchen eines Raums oder bei einer kurzen Rast, kannst du am Tisch einen W6 auf der Tabelle „Zufällige Ereignisse: Burg des Raubritters“ würfeln (Tabelle im Tab „Tabellen“). Wollen die Charaktere die Burg für mindestens einen Tagesabschnitt verlassen, würfle auf der Tabelle „Den Abenteuerort verlassen“ (siehe Regelwerk, Abenteuer).

Schatz: Wo „Schatz“ steht, legst du den Fund selbst fest: Münzen, Schmuck oder ein Gegenstand, der zur Gegend passt.', 1);

INSERT INTO campaign_chapters (id, campaign_id, label, position, title_de, notes_de) VALUES
    (4, 4, '1', 10, 'Die Burg des Raubritters', NULL);

INSERT INTO campaign_places (id, campaign_id, parent_id, chapter_id, position, number_label, name_de, description_de, dm_text_de, image_path, encounter_table_id) VALUES
    (25, 4, NULL, 4, 0, NULL, 'Die Burg des Raubritters', NULL, NULL, 'images/campaigns/4/map.jpg', NULL),
    (26, 4, 25, 4, 1, '1', 'Alte Straße', 'Kaum erkennbar unter Gestrüpp und Unkraut windet sich eine alte Pflasterstraße den Hügel hinauf. An ihrem Ende ragt eine dunkle, verfallene Burgruine auf. Irgendwo in der Nähe krächzt ein Rabe.', '✦ Das Gestrüpp: Die Straße ist teilweise zugewachsen und seit langem nicht benutzt. Die Goblins bevorzugen einen schmalen Pfad, der parallel zur Straße verläuft. Die Charaktere entdecken ihn, wenn sie die Gegend untersuchen.
✦ Der Helm: Auf halbem Weg den Hügel hinauf liegt ein alter Helm aus verkohltem Metall, halb im Unterholz verborgen. Trotz seines Alters ist er voll funktionsfähig (Rüstungswert +1), gibt aber einen Nachteil auf Wahrnehmung-Proben. Der Helm sieht mit seinen scharfen Stacheln an den Seiten bedrohlich aus. Lass die Charaktere eine Mythen & Legenden-Probe ablegen: Bei Erfolg erkennen sie, dass er von Orks geschmiedet wurde. Wer ihn trägt, bekommt Ärger, wenn die Gruppe später dem Wiedergänger des Raubritters begegnet.', NULL, NULL),
    (27, 4, 25, 4, 2, '2', 'Torhaus', 'Am Ende der Straße erhebt sich eine alte Burg, die einmal ein beeindruckender Anblick gewesen sein muss. Jetzt ist sie eine heruntergekommene Ruine mit teils eingestürzten Mauern, die sich grau vor dem Himmel abzeichnen. Vor euch liegt ein verfallenes Tor aus verkohltem, morschem Holz. Der Wind heult leise, während er in den Burghof weht.', '✦ Das Tor: Das doppelte Tor aus verkohltem Holz hängt offen am Eingang zum Burghof.
✦ Die Stolperschnur: Sagen die Spielenden, dass sie das Tor untersuchen, können sie eine Entdecken-Probe ablegen. Bei Erfolg finden sie eine dünne, in Kniehöhe über den Eingang gespannte Schnur, die mit Glocken auf der Innenseite des Tores verbunden ist. Bemerken die Charaktere die Falle nicht, löst sie aus, sobald sie das Tor passieren, und die Goblins locken sie im Burghof (#3) in einen Hinterhalt vom Baum aus.
✦ Das Loch: Direkt hinter dem Eingang klafft ein dunkles Loch. Der Boden ist in den alten Keller eingestürzt, vier Meter tief auf kalten, harten Stein. Die Charaktere müssen eine Akrobatik-Probe bestehen, um zum Burghof hinüberzukommen. Auf der anderen Seite des Lochs liegt ein langes Brett als behelfsmäßige Brücke: Wer es benutzt, erhält einen Vorteil auf die Probe. Misslingt sie, stürzt der Charakter in den Keller (#5) und erleidet 2W6 Wuchtschaden. Jeder Charakter kann den Sturz mit einer weiteren Akrobatik-Probe abfedern und den Schaden auf W6 senken.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (28, 4, 25, 4, 3, '3', 'Burghof', 'Die zerbrochenen Mauern der Burg ragen um euch auf und umrahmen einen mit Steinen und Schutt übersäten Hof. Mitten im Hof streckt eine knorrige alte Eiche ihre Äste in den Himmel. In der Nordostecke führt eine Steintreppe hinauf zu einem baufälligen alten Turm. Im Westen klafft eine offene Tür in ein Steingebäude an der Westmauer. Im Osten liegt eine hölzerne Luke im Boden.', '✦ Die Eiche: Der längst abgestorbene Baum dient den Goblins als Aussichtsturm und als Ort für Hinterhalte gegen eindringende Abenteurer. Seine Äste erlauben es den Goblins, sich mühelos zwischen den Burgmauern und anderen Orten zu bewegen, ohne den Boden zu betreten.
✦ Die versteckten Goblins: Haben die Charaktere die Falle im Torhaus (#2) ausgelöst, haben die Goblins einen Hinterhalt vorbereitet. Sie warten, bis die Charaktere einen Ort in der Burg erkundet haben und wieder in den Burghof zurückkommen. Dann stürzen sie sich von den Ästen. Jeder Charakter darf eine Wahrnehmung-Probe ablegen: Wer scheitert, gilt als überrascht und handelt in der ersten Kampfrunde zuletzt. Die Goblins sind den Charakteren um einen überlegen. Sie handeln alle im selben Zug und teilen sich eine Initiativkarte.
✦ Schatz: Klettern die Charaktere auf die Eiche, bemerken sie etwas Glitzerndes in einem Loch im Stamm. Die Goblins haben hier Beute für unerwartete Ausgaben versteckt. Würfle am Tisch einmal auf den Schatztabellen.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (29, 4, 25, 4, 4, '4', 'Große Halle', 'Was einst die große Halle der Burg gewesen sein muss, ist heute ein trauriges Durcheinander aus halb verrotteten Dachbalken, zerbrochenem Geschirr und herabgefallenem Mörtel. Die Raummitte beherrscht ein langer Eichentisch, an der Nordwand hängt ein großes Gemälde schief. Aus einem Schrank in der Ecke hört ihr ein leises Gluckern.', '✦ Der Eichentisch: Hier aßen der Raubritter und seine Adjutanten. Jetzt ist der Tisch mit Trümmern bedeckt: Tonscherben, alte Zinnbecher, zerbrochene Weinflaschen und schimmelige Essensreste. Letztere zeigen, dass hier vor kurzem jemand gegessen hat. Eine Handwerk-Probe verrät, dass die Tonscherben und Weinflaschen aus heutiger Zeit stammen und halblingischen Ursprungs sind.
✦ Das Porträt: Ein großes Gemälde hängt schief an der Nordwand. Es zeigt einen strengen Mann mit bösen grauen Augen, wüstem Grinsen und rabenschwarzem Haar. Er trägt eine volle Rüstung und hält einen gehörnten Großhelm unter dem Arm.
✦ Die Rückseite des Gemäldes: Untersuchen Charaktere das Gemälde genau oder sehen sich im Raum um und bestehen eine Entdecken-Probe, finden sie eine Notiz auf der Rückseite der Leinwand. Sie lautet: „Der Schuft Rothgar Wolfsbane hat mich gezwungen, ihn zu malen. Wenn ich es nicht lebend hier heraus schaffe, verfluche ich seinen Namen für alle Ewigkeit! – Embarius“
✦ Der schlafende Goblin: Der Goblin-Häuptling Jaldo hat sich zwischen den verrottenden Tischdecken und zerbrochenem Geschirr im Eckschrank eine kleine Höhle gebaut. Er schläft fest nach den nächtlichen Feierlichkeiten, mit einer leeren Weinflasche und einem alten, ungewöhnlich großen Trinkhorn in den Armen (eine Handwerk-Probe zeigt, dass es in Wahrheit ein Kriegshorn ist). Das Horn kann später im Abenteuer wichtig werden, denn mit ihm lässt sich der untote Raubritter beschwören. Machen die Charaktere zu viel Lärm, wacht Jaldo auf und schleicht durch ein Loch in den Burghof, um seine Handlanger zu warnen, die einen Hinterhalt in der Eiche vorbereiten.
✦ Jaldos Jammergeschichte: Überraschen die Charaktere Jaldo und wecken ihn, erkennt er, dass er in der Unterzahl ist, und tut so, als wäre er ein armer, einsamer Goblin, der sich verirrt und in der Burg Schutz gesucht hat. Schnell erfindet er eine weitschweifige, schlecht ausgedachte Geschichte über einen brutalen Orkclan, der die Burg übernommen und ihn in den Schrank gezwungen habe. Jaldo bietet an, ihnen zu zeigen, wo sich die Orks verstecken. Er will sie in den Keller führen, wo die nicht ganz so gewalttätige Orkin Grunta gefangen ist, und sie dort einsperren.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (30, 4, 25, 4, 5, '5', 'Keller', 'Unter der Luke führt eine steile Steintreppe in den Untergrund. Es ist feucht und riecht nach Erde. Die Treppe endet in einem großen Raum mit gestapelten Fässern an der Ostwand. Im südlichen Teil des Raumes liegen mehrere Nischen, die das Licht der Fackel nicht erreicht. In einer Ecke sitzt eine große Orkin, die sich überrascht umdreht.', '✦ Die Luke: Die hölzerne Luke zum Keller ist nicht verschlossen, wenn die Charaktere eintreffen, aber von außen verriegelt. Sie hat Rüstungswert 8 und lässt sich mit 20 Schadenspunkten aufbrechen.
✦ Grunta: Im Dunkel des Kellers lebt die Orkin Grunta, die aus ihrem Clan verstoßen und von Jaldo und seinen Goblin-Banditen benutzt wird. Ihre einzige Aufgabe ist es, auf Jaldos Befehl in das Horn des Raubritters zu blasen und seinen Wiedergänger zu beschwören (die Lungen der Goblins sind zu schwach, mehr als ein jämmerliches Quieken bringen sie nicht hervor). Grunta ist zutiefst unglücklich und will die Burg verlassen, wagt es aber aus Angst vor Jaldo nicht. Ihr einziger Lebensinhalt ist ihr Schwein Merle (siehe NSC „Grunta“).
✦ Das Skelett: Untersuchen die Charaktere den Raum und bestehen eine Entdecken-Probe, finden sie unter dem Schutt ein versteckt liegendes Skelett. Rostige Ketten zeigen, dass der Tote an eine Wand gekettet war. Beim Durchsuchen der Knochen finden sie ein zusammengerolltes Pergament mit der Skizze eines jungen Mannes, betitelt „Der Künstler Embarius in seiner Jugend“.
✦ Das Goblin-Nest: Die Nischen an der Südwand sind mit einfachen Matratzen aus Stroh und Stöcken ausgestattet. Falls kein Alarm ausgelöst wurde, ruhen hier Goblins (einer mehr als Spielercharaktere).
✦ Schätze: In einer der Nischen horten die Goblins gestohlene Dinge von geringem Wert. Spielercharaktere, die ein wenig herumstöbern und eine Entdecken-Probe bestehen, finden etwas Wertvolles. Würfle am Tisch einmal auf den Schatztabellen.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (31, 4, 25, 4, 6, '6', 'Turm', 'Was einst ein mächtiger Steinturm war, ist heute nur noch eine hohle Hülle. Die oberen Stockwerke sind eingestürzt, das Dach ist längst fort. Übrig sind heruntergefallene Steine, moosbewachsene Mauern und eine Steintreppe, die sich nach unten windet, teils unter Schutt und Trümmern begraben.', '✦ Die Raben: Ein Schwarm Raben hat hoch oben im Turm genistet. Wo einst das dritte Stockwerk war, ragt nur noch ein kleiner Steinsims aus der Wand. Ein Charakter, der eine Akrobatik-Probe besteht, kann zum Rabennest hinaufklettern. Würfle am Tisch einmal auf den Schatztabellen, um zu sehen, was dort liegt.
✦ Die Treppe: Der Weg nach unten ist fast vollständig von Steinen der eingestürzten Stockwerke versperrt, aber man kann sich vorsichtig geduckt am Schutt vorbeiquetschen.
✦ Hufspuren: Eine erfolgreiche Entdecken-Probe zeigt die schlammigen Hufspuren eines Schweins, die die Treppe hinabführen.
✦ Herabstürzender Felsbrocken: Sind die Charaktere auf halbem Weg die Treppe hinunter, löst sich weiter oben ein großer Stein und poltert auf sie zu. Alle müssen eine Ausweichen-Probe ablegen. Wer scheitert, wird nach vorn gestoßen und landet am Ende der Treppe im Wasser, wobei er W8 Wuchtschaden erleidet.
✦ Das Schwein: Die Treppe verschwindet im schwarzen Wasser auf der untersten Ebene des Turms. Jahrzehntelanger Regen hat aus dem einstigen Weinkeller einen tiefen Brunnen gemacht. Auf einem Sims am Wasser hat sich das Schwein Merle ein Nest gebaut. Sind die Charaktere ihr noch nicht begegnet (siehe Zufälliges Ereignis 2), ruht sie im Nest und begrüßt die Abenteurer mit einem überraschten Grunzen.
✦ Der Helm: Blicken die Charaktere in die Tiefe, sehen sie etwas im schwarzen Wasser schimmern. Der Brunnen ist vier Meter tief, und es braucht eine erfolgreiche Schwimmen-Probe, um den Grund zu erreichen und den Schatz zu finden. Würfle am Tisch zweimal auf den Schatztabellen. Dort liegt auch ein grinsender Totenschädel in einem rostigen, gehörnten Helm: der Schädel von Rothgar Wolfsbane, mit dem sich der Wiedergänger bannen lässt. Haben die Charaktere das Porträt in der Großen Halle (#4) gesehen, erkennen sie den Helm sofort, den der Raubritter unter dem Arm trug. Der Helm hat Rüstungswert +2, gibt aber einen Nachteil auf Wahrnehmung-Proben und Fernkampfangriffe.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4);

INSERT INTO campaign_items (id, campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, text_de, image_path) VALUES
    (4, 4, 4, 26, 'Auf halbem Weg den Hügel hinauf, im Unterholz', 'Orkhelm', 'Ein alter, halb im Unterholz verborgener Helm aus verkohltem Metall mit scharfen Stacheln an den Seiten. Trotz seines Alters voll funktionsfähig.', 'Rüstungswert +1, Nachteil auf Wahrnehmung-Proben. Mythen & Legenden-Probe: von Orks geschmiedet. Wer ihn trägt, bekommt Ärger, wenn er dem Wiedergänger des Raubritters begegnet: Orks und Träger des Orkhelms greift er zuerst an.', NULL, NULL),
    (5, 4, 4, 29, 'In Jaldos Armen, im Eckschrank', 'Jaldos Kriegshorn', 'Ein alter, ungewöhnlich großes Trinkhorn.', 'Eine Handwerk-Probe zeigt, dass es ein Kriegshorn ist: Rothgar Wolfsbanes Kriegshorn. Wer es mit kräftigen Lungen bläst (STÄ 14 oder höher), beschwört den Wiedergänger des Raubritters.', NULL, NULL),
    (6, 4, 4, 29, 'An der Nordwand der Großen Halle', 'Das Porträt', 'Ein großes Gemälde: ein strenger Mann mit bösen grauen Augen, wüstem Grinsen und rabenschwarzem Haar in voller Rüstung, einen gehörnten Großhelm unter dem Arm.', 'Zeigt Rothgar Wolfsbane. Auf der Rückseite steht eine Notiz (Entdecken-Probe).', '„Der Schuft Rothgar Wolfsbane hat mich gezwungen, ihn zu malen. Wenn ich es nicht lebend hier heraus schaffe, verfluche ich seinen Namen für alle Ewigkeit! – Embarius“', NULL),
    (7, 4, 4, 30, 'Unter dem Schutt, bei dem angeketteten Skelett (Entdecken-Probe)', 'Selbstporträt des Embarius', 'Ein zusammengerolltes Pergament mit der Skizze eines jungen Mannes, betitelt „Der Künstler Embarius in seiner Jugend“.', 'Das Skelett im Keller ist der Maler Embarius, der das Porträt in der Großen Halle malen musste.', NULL, NULL),
    (8, 4, 4, 31, 'Auf dem Grund des Brunnens im Turm (Schwimmen-Probe)', 'Der gehörnte Helm mit Schädel', 'Ein rostiger gehörnter Helm mit einem grinsenden Totenschädel darin. Der Helm hat Rüstungswert +2.', 'Der Schädel von Rothgar Wolfsbane, mit dem sich der Wiedergänger bannen lässt (siehe NSC Der Raubritter). Nachteil auf Wahrnehmung-Proben und Fernkampfangriffe.', NULL, NULL);

INSERT INTO campaign_npcs (id, campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, notes_de, bestiary_id, portrait_path) VALUES
    (12, 4, 4, 29, NULL, 'Jaldo', 'Klein, verschlagen und sehr einfallsreich. Jaldo hat die Gabe des Redens und hat ein Dutzend Goblin-Anhänger mit Versprechen von Wein, Silber und einem eigenen Zuhause um sich geschart. Versprechen, die er zu seiner eigenen Überraschung halten konnte, indem er die Burg fand und schnell begriff, dass er die Legende vom Raubritter zu seinem Vorteil nutzen konnte.', 'Rolle: Goblin-Häuptling

Siehe auch die Jammergeschichte in der Großen Halle (#4). Jaldo schläft zu Spielbeginn im Eckschrank der Großen Halle.

TP: 10 · Bewegung: 10 · Schadensbonus: — · Rüstung: Beschlagenes Leder (2), offener Helm (+1)
Fertigkeiten: Wahrnehmung 12, Ausweichen 10, Heimlichkeit 12
Waffe: Krummsäbel (Fertigkeitswert 12, Schaden 2W6)', NULL, 52, NULL),
    (13, 4, 4, 30, NULL, 'Grunta', 'Grunta ist eine Orkin ohne Heim und ohne Ziel. Aus ihrem Clan verstoßen, wanderte sie auf der Suche nach einem neuen durch die Lande. Ihre ständige Begleiterin ist das Schwein Merle, das sie vor einem hungrigen Wolfsmenschen gerettet hat. Die beiden sind seither unzertrennlich.', 'Rolle: Gefangene der Goblins

Als sie Jaldo und seinen Goblins begegnete, wurde Grunta vom Versprechen neuer Freunde geblendet und fiel auf seine Lügen herein. Nun steckt sie im Keller fest, weil sie zu viel Angst hat, wegzugehen: Angst vor Jaldo, vor dem Wiedergänger des Raubritters und davor, dass die Goblins ihr geliebtes Schwein fressen könnten. Gäbe es eine Chance, mit Merle zu entkommen, würde sie sie ergreifen.

TP: 12 · Bewegung: 10 · Schadensbonus STÄ: +W4
Fertigkeiten: Wahrnehmung 14, Ausweichen 10
Waffe: Kleine Holzkeule (Fertigkeitswert 12, Schaden W8)', NULL, 53, NULL),
    (14, 4, 4, 31, NULL, 'Merle (Schwein)', 'Ein rosiges Hausschwein, das gern in den Ecken der Burg wühlt und grunzt.', 'Rolle: Grunts Gefährtin

Merle ist Gruntas ganzer Stolz. Wer sie verletzt, macht sich Grunta zur Feindin fürs Leben. Wurde Merle durch das Zufällige Ereignis 2 noch nicht getroffen, ruht sie im Nest am Brunnen im Turm (#6).', NULL, NULL, NULL),
    (15, 4, 4, 28, NULL, 'Die Goblins', 'Etwa zehn Goblins leben in der Burg. Ein paar Späher halten hoch oben im alten Eichenbaum Wache. Eine Gruppe ruht meist in den Nischen im Keller, die übrigen huschen auf verschiedenen Besorgungen durch die Burg.', 'Rolle: Banditen

Die Goblins können die Charaktere aus dem Hinterhalt angreifen, im Keller (#5) angetroffen werden oder als Zufälliges Ereignis auftauchen. Als SL kannst du sie die Charaktere treffen lassen, wann immer es passt.

TP: 9 · Bewegung: 10 · Schadensbonus: — · Rüstung: Lederrüstung (1)
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12
Waffen: Kurzbogen (Fertigkeitswert 12, Schaden W10), Kurzschwert (Fertigkeitswert 10, Schaden W10)', NULL, 54, NULL),
    (16, 4, 4, NULL, NULL, 'Der Raubritter (Wiedergänger)', NULL, 'Rolle: Untoter Raubritter Rothgar Wolfsbane

Der Raubritter ist ein Wiedergänger und wird wie ein Monster behandelt. Er trägt einen Morgenstern (Wuchtschaden 2W8).

Die ewige Wache des Rothgar Wolfsbane: Als Rothgar Wolfsbane bei der Belagerung der Burg durch die Orks vor vielen Jahrhunderten fiel, starb nur seine körperliche Hülle. Obwohl er seinen Kopf verloren hatte, war Wolfsbane so erfüllt von Hass und so verflucht, dass er zu ewigem Untod verdammt wurde. Seitdem patrouilliert er als kopfloser Wiedergänger durch die Burg und sucht ewig nach seinen sterblichen Feinden: den Orks.

Der Raubritter kann nach Ermessen der SL erscheinen, der Wiedergänger kann aber auch von jemandem mit starken Lungen (STÄ 14 oder höher) beschworen werden, der Jaldos Kriegshorn (#4) bläst. Der Wiedergänger greift alle Lebenden an, außer der Person mit dem Horn. Orks und Träger des Orkhelms (#1) greift er zuerst an.

Mit etwas List können die Charaktere den untoten Raubritter überzeugen, dass die Goblins in Wahrheit winzige Orks sind (der Wiedergänger ist so geblendet von seinem Hass auf Orks, dass er mit einer gelungenen Überzeugen-Probe überredet werden kann). Gelingt das, können sie sich zurücklehnen und ihre brillante Idee genießen, während der Wiedergänger kurzen Prozess mit den Goblins macht.

Es gibt drei Wege, den Raubritter zu überwinden:
✦ Ihn im Kampf besiegen. Er steht jedoch nach einem Tagesabschnitt (etwa sechs Stunden) wieder auf und spukt weiter in der Burg.
✦ Den Schädel des Raubritters am Grund des Turmes (#6) zerschmettern. Dann wird der Wiedergänger für zwei Runden rasend (seine Grimmigkeit steigt auf 3), bevor er in einem Haufen Knochen zusammenfällt. Dann beginnt die ganze Burg einzustürzen. Alle Spielercharaktere müssen jede Runde, die sie in den Burgmauern bleiben, eine Ausweichen-Probe ablegen (keine Aktion). Beim ersten Misslingen erleiden sie W6 Wuchtschaden, beim zweiten 2W6, und so weiter.
✦ Den Schädel dem kopflosen Wiedergänger bringen. Dann bleibt er stehen und setzt seinen Kopf auf. Er stößt einen langen Seufzer aus und fällt zusammen wie oben beschrieben. Die Burg stürzt ebenfalls ein.

Werte: TP 38, Grimmigkeit: Zahl der SC − 1, Größe: Normal, Bewegung 10, Rüstung 8. Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden.', NULL, 55, NULL);

INSERT INTO campaign_bestiary (campaign_id, bestiary_id, chapter_id, notes_de) VALUES
    (4, 52, NULL, NULL),
    (4, 53, NULL, NULL),
    (4, 54, NULL, NULL),
    (4, 55, NULL, NULL);
