SET NAMES utf8mb4;

-- Round 2 of the character-creation wizard: 4 new professions (Handwerker,
-- Gelehrter, Magier, Barde), magic (schools/tricks/rank-1-spells), skill
-- descriptions. See docs/superpowers/specs/2026-09-27-character-creation-wizard-design.md
-- and the follow-up plan for sources (screenshots + user-confirmed rulings).

-- ============================================================
-- New magic-school skills (Animismus, Mentalismus; Elementarismus already
-- existed). All three are INT-based secondary skills -- RAW-confirmed via
-- screenshot ("Each school of magic is a separate secondary skill... based
-- on INT").
-- ============================================================

INSERT INTO catalog_skills (name_de, attribute_code, category) VALUES
    ('Animismus', 'INT', 'secondary'),
    ('Mentalismus', 'INT', 'secondary');

INSERT INTO catalog_schools (name_de, skill_id, display_order)
SELECT 'Animismus', id, 2 FROM catalog_skills WHERE name_de = 'Animismus'
UNION ALL
SELECT 'Mentalismus', id, 3 FROM catalog_skills WHERE name_de = 'Mentalismus';

-- "Allgemein" (general magic) has no backing skill -- tricks/spells here are
-- usable regardless of which school you trained in, so it's skill_id NULL.
INSERT INTO catalog_schools (name_de, skill_id, display_order) VALUES
    ('Allgemein', NULL, 0);

-- ============================================================
-- New catalog items for the 4 new professions' gear options
-- ============================================================

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Kriegshammer, klein', 'Ein kompakter Kriegshammer.', 'gewöhnlich', 0, 9, 0, 'weapon'),
    ('Schmiedewerkzeug', 'Werkzeug eines Schmieds: Hammer, Zange und Feile.', 'gewöhnlich', 1, 2, 0, 'misc'),
    ('Zimmermannswerkzeug', 'Werkzeug eines Zimmermanns: Säge, Beil und Maßband.', 'gewöhnlich', 1, 2, 0, 'misc'),
    ('Gerberwerkzeug', 'Werkzeug eines Gerbers zur Lederverarbeitung.', 'gewöhnlich', 1, 2, 0, 'misc'),
    ('Notizbuch', 'Ein leeres Notizbuch für Beobachtungen und Skizzen.', 'gewöhnlich', 0, 3, 0, 'misc'),
    ('Feder', 'Eine Schreibfeder samt kleinem Tintenfass.', 'gewöhnlich', 0, 1, 0, 'misc'),
    ('Bandagen', 'Sauberer Verbandsstoff für Wundversorgung.', 'gewöhnlich', 0, 1, 5, 'misc'),
    ('Orduculum', 'Ein magisches Hilfsmittel, mit dem ein Magier neue Zauber studiert.', 'ungewöhnlich', 2, 5, 0, 'misc'),
    ('Zauberstab', 'Ein schlanker Stab, der als magischer Fokus dient.', 'gewöhnlich', 1, 0, 0, 'misc'),
    ('Amulett', 'Ein einfaches Amulett, das als magischer Fokus dient.', 'gewöhnlich', 0, 8, 0, 'misc'),
    ('Grimoire', 'Ein Zauberbuch, in dem ein Magier seine bekannten Zauber festhält. Neu erschaffene Magier erhalten automatisch eines.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Leier', 'Ein kleines Saiteninstrument.', 'gewöhnlich', 0, 6, 0, 'misc'),
    ('Flöte', 'Eine einfache Holzflöte.', 'gewöhnlich', 0, 2, 5, 'misc'),
    ('Horn', 'Ein Blashorn für Signale und Musik.', 'gewöhnlich', 0, 3, 0, 'misc');

INSERT INTO catalog_item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de) VALUES
    ((SELECT id FROM catalog_items WHERE name_de = 'Kriegshammer, klein'), '1-händig', '2', '2W6', 9, 'Wucht');

-- ============================================================
-- New professions
-- ============================================================

INSERT INTO catalog_professions (code, name_de, key_attribute_code, kin_restriction, grants_magic) VALUES
    ('handwerker', 'Handwerker', 'STA', NULL, 0),
    ('gelehrter', 'Gelehrter', 'INT', NULL, 0),
    ('magier', 'Magier', 'WIL', NULL, 1),
    ('barde', 'Barde', 'CHA', NULL, 0);

INSERT INTO catalog_profession_key_skills (profession_code, skill_id)
SELECT 'handwerker', id FROM catalog_skills WHERE name_de IN ('Äxte', 'Prügelei', 'Handwerk', 'Hämmer', 'Messer', 'Fingerfertigkeit', 'Entdecken', 'Schwerter')
UNION ALL
SELECT 'gelehrter', id FROM catalog_skills WHERE name_de IN ('Wahrnehmung', 'Bestienkunde', 'Wildnisleben', 'Ausweichen', 'Heilkunde', 'Fremdsprachen', 'Mythen & Legenden', 'Entdecken')
UNION ALL
-- Magiers 8. Pool-Slot ist die gewählte Zauberschule (Animismus/Elementarismus/
-- Mentalismus), gewählt in Schritt 2 des Wizards und clientseitig an den Pool
-- angehängt -- deshalb hier nur die 7 festen Fertigkeiten, keine hartkodierte Schule.
SELECT 'magier', id FROM catalog_skills WHERE name_de IN ('Bestienkunde', 'Wildnisleben', 'Ausweichen', 'Heilkunde', 'Jagen & Fischen', 'Heimlichkeit', 'Stäbe')
UNION ALL
SELECT 'barde', id FROM catalog_skills WHERE name_de IN ('Akrobatik', 'Täuschen', 'Ausweichen', 'Messer', 'Fremdsprachen', 'Mythen & Legenden', 'Darbietung', 'Überzeugen');

-- Heroic abilities: Gelehrter (Intuition) and Barde (Musiker) are single
-- fixed abilities like the original 7 professions. Handwerker is a 3-way
-- choice (choice_group). Magier gets none (grants_magic=1 covers it).
-- Full text screenshot-transcribed from "Chapter 3 - Skills" (heroic
-- abilities pages 37-38).
INSERT INTO catalog_heroic_abilities (name_de, requirement_de, wp_note_de, description_de) VALUES
    ('Meister-Schmied', 'Handwerk 12', 'unterschiedlich', 'Erfordert Schmiedewerkzeug. Innerhalb einer Rast kannst du für 3 WP eine geschärfte oder spitze Waffe schärfen: Gegen eine geschärfte Waffe zählt die Rüstung eines Ziels einen Schritt niedriger. Der Effekt hält bis zum Ende des nächsten Kampfes an, in dem die Waffe benutzt wurde. In einer Schicht kannst du eine Metallwaffe oder Metallrüstung deiner Wahl anfertigen; dafür benötigst du eine Schmiede, einen Amboss und Eisen (Gewicht 1). Die WP-Kosten entsprechen dem aufgerundeten Goldpreis des Gegenstands; die Arbeit kann auf mehrere Schichten verteilt werden, falls nicht genug WP vorhanden sind.'),
    ('Meister-Zimmermann', 'Handwerk 12', 'unterschiedlich', 'Erfordert Zimmermannswerkzeug. Als Aktion kannst du pro eingesetztem WP W12 Schaden an einer Tür, Wand oder einem anderen unbelebten Objekt verursachen, ohne dessen Rüstung zu berücksichtigen. In einer Schicht kannst du einen hölzernen Gegenstand deiner Wahl anfertigen (z. B. Keule, Stab oder Schild); dafür benötigst du Holz (Gewicht 1 oder nach Ansage der Spielleitung). Die WP-Kosten entsprechen dem aufgerundeten Goldpreis des Gegenstands, bei unaufgelisteten Gegenständen legt die Spielleitung die Kosten fest.'),
    ('Meister-Gerber', 'Handwerk 12', 'unterschiedlich', 'Erfordert Gerberwerkzeug. Du kannst aus der Haut eines Tieres oder Monsters einen Satz Lederrüstung anfertigen. Die Rüstung erhält die Hälfte (aufgerundet) des Rüstungswerts der Kreatur, mindestens aber 1. Die Arbeit dauert eine Schicht, die WP-Kosten entsprechen dem Rüstungswert der fertigen Rüstung.'),
    ('Intuition', 'Mythen & Legenden 12', '3', 'Wenn du vor einer schwierigen Entscheidung stehst, kannst du dieses Talent aktivieren, um der Spielleitung direkt eine Frage zu stellen und eine hilfreiche Antwort zu erhalten. Die Antwort spiegelt dein umfangreiches Allgemeinwissen wider und soll dir nur bei der Entscheidung helfen, nicht alles verraten.'),
    ('Musiker', 'Darbietung 12', '3', 'Deine wunderbare Stimme flößt deinen Freunden Mut ein oder deinen Feinden Furcht. Aktivierst du dieses Talent (eine Aktion im Kampf), erhalten entweder alle Verbündeten in 10 Metern einen Vorteil auf alle Würfe oder alle Feinde in derselben Reichweite einen Nachteil — du wählst eins von beidem. Der Effekt hält bis zu deinem Zug in der nächsten Runde an. Mit Instrumenten lässt sich die Reichweite erhöhen oder die WP-Kosten senken.');

INSERT INTO catalog_profession_heroic_abilities (profession_code, heroic_ability_id, granted_at_creation, choice_group)
SELECT 'handwerker', id, 1, 'handwerker_meister' FROM catalog_heroic_abilities WHERE name_de = 'Meister-Schmied'
UNION ALL SELECT 'handwerker', id, 1, 'handwerker_meister' FROM catalog_heroic_abilities WHERE name_de = 'Meister-Zimmermann'
UNION ALL SELECT 'handwerker', id, 1, 'handwerker_meister' FROM catalog_heroic_abilities WHERE name_de = 'Meister-Gerber'
UNION ALL SELECT 'gelehrter', id, 1, NULL FROM catalog_heroic_abilities WHERE name_de = 'Intuition'
UNION ALL SELECT 'barde', id, 1, NULL FROM catalog_heroic_abilities WHERE name_de = 'Musiker';

-- Gear options (A=W6 1-2, B=3-4, C=5-6). Small consumables/currency in
-- extra_de, same convention as the first 7 professions.

-- Start-Silber ist NICHT mehr Teil von extra_de, siehe starting_silver_dice.
INSERT INTO catalog_profession_gear_options (profession_code, option_label, extra_de, starting_silver_dice) VALUES
    ('handwerker', 'A', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    ('handwerker', 'B', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    ('handwerker', 'C', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    ('gelehrter', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    ('gelehrter', 'B', 'Schlafpelz, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    ('gelehrter', 'C', 'Schlafpelz, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    ('magier', 'A', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    ('magier', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    ('magier', 'C', 'Schlafpelz, Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    ('barde', 'A', 'Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    ('barde', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    ('barde', 'C', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8');

INSERT INTO catalog_profession_gear_option_items (gear_option_id, item_id, quantity)
SELECT go.id, i.id, gear.qty
FROM catalog_profession_gear_options go
JOIN (
    SELECT 'handwerker' AS profession_code, 'A' AS option_label, 'Kriegshammer, klein' AS name_de, 1 AS qty UNION ALL
    SELECT 'handwerker', 'A', 'Lederrüstung', 1 UNION ALL
    SELECT 'handwerker', 'A', 'Schmiedewerkzeug', 1 UNION ALL
    SELECT 'handwerker', 'B', 'Beil', 1 UNION ALL
    SELECT 'handwerker', 'B', 'Lederrüstung', 1 UNION ALL
    SELECT 'handwerker', 'B', 'Zimmermannswerkzeug', 1 UNION ALL
    SELECT 'handwerker', 'C', 'Messer', 1 UNION ALL
    SELECT 'handwerker', 'C', 'Lederrüstung', 1 UNION ALL
    SELECT 'handwerker', 'C', 'Gerberwerkzeug', 1 UNION ALL
    SELECT 'handwerker', 'C', 'Laterne', 1 UNION ALL
    SELECT 'handwerker', 'C', 'Lampenöl', 1 UNION ALL
    SELECT 'gelehrter', 'A', 'Stab', 1 UNION ALL
    SELECT 'gelehrter', 'A', 'Notizbuch', 1 UNION ALL
    SELECT 'gelehrter', 'A', 'Feder', 1 UNION ALL
    SELECT 'gelehrter', 'B', 'Messer', 1 UNION ALL
    SELECT 'gelehrter', 'B', 'Buch', 1 UNION ALL
    SELECT 'gelehrter', 'B', 'Laterne', 1 UNION ALL
    SELECT 'gelehrter', 'B', 'Lampenöl', 1 UNION ALL
    SELECT 'gelehrter', 'C', 'Kurzschwert', 1 UNION ALL
    SELECT 'gelehrter', 'C', 'Bandagen', 1 UNION ALL
    SELECT 'gelehrter', 'C', 'Laterne', 1 UNION ALL
    SELECT 'gelehrter', 'C', 'Lampenöl', 1 UNION ALL
    SELECT 'magier', 'A', 'Stab', 1 UNION ALL
    SELECT 'magier', 'A', 'Orduculum', 1 UNION ALL
    SELECT 'magier', 'A', 'Grimoire', 1 UNION ALL
    SELECT 'magier', 'B', 'Messer', 1 UNION ALL
    SELECT 'magier', 'B', 'Zauberstab', 1 UNION ALL
    SELECT 'magier', 'B', 'Grimoire', 1 UNION ALL
    SELECT 'magier', 'C', 'Amulett', 1 UNION ALL
    SELECT 'magier', 'C', 'Grimoire', 1 UNION ALL
    SELECT 'barde', 'A', 'Leier', 1 UNION ALL
    SELECT 'barde', 'A', 'Dolch', 1 UNION ALL
    SELECT 'barde', 'A', 'Laterne', 1 UNION ALL
    SELECT 'barde', 'A', 'Lampenöl', 1 UNION ALL
    SELECT 'barde', 'B', 'Flöte', 1 UNION ALL
    SELECT 'barde', 'B', 'Dolch', 1 UNION ALL
    SELECT 'barde', 'B', 'Seil (Hanf), 10m', 1 UNION ALL
    SELECT 'barde', 'C', 'Horn', 1 UNION ALL
    SELECT 'barde', 'C', 'Dolch', 1
) gear ON gear.profession_code = go.profession_code AND gear.option_label = go.option_label
JOIN catalog_items i ON i.name_de = gear.name_de;

-- ============================================================
-- Skill descriptions (screenshot-transcribed, Chapter 3 "The Core Skills")
-- ============================================================

UPDATE catalog_skills SET description_de = 'Für Springen, Klettern, Balancieren oder ähnliche körperliche Aktionen.' WHERE name_de = 'Akrobatik';
UPDATE catalog_skills SET description_de = 'Um einem Angriff im Kampf auszuweichen.' WHERE name_de = 'Ausweichen';
UPDATE catalog_skills SET description_de = 'Um Tiere oder Monster zu identifizieren oder ihre Gewohnheiten, Fähigkeiten und Schwächen zu kennen.' WHERE name_de = 'Bestienkunde';
UPDATE catalog_skills SET description_de = 'Um mit Gesang, Gedichten, Witzen oder Ähnlichem eine Menge zu unterhalten.' WHERE name_de = 'Darbietung';
UPDATE catalog_skills SET description_de = 'Um Verstecktes zu finden; jeder Versuch dauert etwa eine Weile, nur ein Versuch pro Ort.' WHERE name_de = 'Entdecken';
UPDATE catalog_skills SET description_de = 'Beim Handeln über den Preis einer Ware — bei Erfolg ±20 %, bei einem Drachen halbiert oder verdoppelt.' WHERE name_de = 'Feilschen';
UPDATE catalog_skills SET description_de = 'Um unbemerkt etwas zu stehlen, ein Schloss zu knacken oder andere feinmotorische Aktionen auszuführen.' WHERE name_de = 'Fingerfertigkeit';
UPDATE catalog_skills SET description_de = 'Um fremde oder alte Sprachen und Texte zu verstehen (die Gemeinsprache und die eigene Kin-Sprache beherrscht jeder automatisch).' WHERE name_de = 'Fremdsprachen';
UPDATE catalog_skills SET description_de = 'Um ausgerüstetes Werkzeug zu reparieren; braucht in der Regel eine Rastdauer.' WHERE name_de = 'Handwerk';
UPDATE catalog_skills SET description_de = 'Um gefallene Gefährten wieder auf die Beine zu bringen oder vor dem Tod zu bewahren.' WHERE name_de = 'Heilkunde';
UPDATE catalog_skills SET description_de = 'Um Kampf oder Konfrontation zu vermeiden oder sich anzuschleichen; nur gegen eine aktiv suchende Wahrnehmung eine Gegenprobe.' WHERE name_de = 'Heimlichkeit';
UPDATE catalog_skills SET description_de = 'Um in der Wildnis eigene Nahrung zu finden.' WHERE name_de = 'Jagen & Fischen';
UPDATE catalog_skills SET description_de = 'Um sich an alte Geschichten oder Sagen aus fernen Landen zu erinnern.' WHERE name_de = 'Mythen & Legenden';
UPDATE catalog_skills SET description_de = 'Zum Aufsteigen und gemächlichen Reiten ohne Probe; anspruchsvollere Manöver erfordern eine Reiten-Probe.' WHERE name_de = 'Reiten';
UPDATE catalog_skills SET description_de = 'Um sich kurz über Wasser zu halten; bei anspruchsvolleren Situationen ist eine Probe nötig.' WHERE name_de = 'Schwimmen';
UPDATE catalog_skills SET description_de = 'Um ein Boot oder Kanu zu rudern oder zu paddeln; bei schwierigeren Situationen oder zum Steuern eines Schiffs braucht es eine Probe.' WHERE name_de = 'Seefahrt';
UPDATE catalog_skills SET description_de = 'Um überzeugend zu lügen; bei einer unglaubwürdigen Lüge Nachteil auf den Wurf.' WHERE name_de = 'Täuschen';
UPDATE catalog_skills SET description_de = 'Um jemanden durch Charme, Drohungen oder vernünftige Argumente von etwas zu überzeugen.' WHERE name_de = 'Überzeugen';
UPDATE catalog_skills SET description_de = 'Um stets wachsam zu sein und drohende Gefahren rechtzeitig zu bemerken (passive Probe möglich).' WHERE name_de = 'Wahrnehmung';
UPDATE catalog_skills SET description_de = 'Um sicher durch die Wildnis zu führen, ein Lager aufzuschlagen, zu kochen oder in der Kälte zu überleben.' WHERE name_de = 'Wildnisleben';
UPDATE catalog_skills SET description_de = 'Für Angriffe mit allen Arten von Armbrüsten.' WHERE name_de = 'Armbrüste';
UPDATE catalog_skills SET description_de = 'Für den Kampf mit allen Arten von Äxten, auch als Wurfwaffe.' WHERE name_de = 'Äxte';
UPDATE catalog_skills SET description_de = 'Für Angriffe mit allen Arten von Bögen (außer Armbrust).' WHERE name_de = 'Bögen';
UPDATE catalog_skills SET description_de = 'Für den Kampf mit Kriegshämmern und anderen Wuchtwaffen wie Keulen.' WHERE name_de = 'Hämmer';
UPDATE catalog_skills SET description_de = 'Für den Kampf mit Messern und Dolchen, auch als Wurfwaffe.' WHERE name_de = 'Messer';
UPDATE catalog_skills SET description_de = 'Für unbewaffneten Kampf mit Fäusten, Füßen und Zähnen.' WHERE name_de = 'Prügelei';
UPDATE catalog_skills SET description_de = 'Für Angriffe mit der Schleuder.' WHERE name_de = 'Schleudern';
UPDATE catalog_skills SET description_de = 'Für den Kampf mit allen Arten von Schwertern.' WHERE name_de = 'Schwerter';
UPDATE catalog_skills SET description_de = 'Für Nahkampf mit Speeren, Dreizacken (auch als Wurfwaffe) sowie Lanzen.' WHERE name_de = 'Speere';
UPDATE catalog_skills SET description_de = 'Für den Kampf mit dem Stab.' WHERE name_de = 'Stäbe';

-- ============================================================
-- Magic: General tricks + rank-1 spells (school = "Allgemein")
-- ============================================================

INSERT INTO catalog_spells (name_de, type, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    ('Herbeirufen', 'trick', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), NULL, NULL, NULL, NULL, '1 WP', 'Ein loser Gegenstand (Gewicht höchstens 1) in 10 Metern Entfernung schwebt zu dir.'),
    ('Antippen', 'trick', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), NULL, NULL, NULL, NULL, '1 WP', 'Du versetzt einem Objekt oder einer Kreatur in 10 Metern Entfernung einen magischen Stups. Der „Angriff" verursacht 1 Schadenspunkt und kann z. B. Glas zerbrechen.'),
    ('Licht', 'trick', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), NULL, NULL, NULL, NULL, '1 WP', 'Du erzeugst helles Licht, das von einem Fokus deiner Wahl ausgeht. Es erhellt einen Radius von 10 Metern um den Fokus und hält eine Weile an. Das Licht erlischt, wenn du 0 TP erreichst.'),
    ('Öffnen/Schließen', 'trick', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), NULL, NULL, NULL, NULL, '1 WP', 'Du öffnest oder schließt eine unverschlossene Tür in 10 Metern Sichtweite.'),
    ('Kleidung reparieren', 'trick', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), NULL, NULL, NULL, NULL, '1 WP', 'Kleidung, die dir oder jemandem in 10 Metern Entfernung gehört, wird sofort repariert und gereinigt.'),
    ('Aufheben', 'spell', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), 'Wort, Geste', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', 'Du hebst einen bestehenden Zauber mit gleicher oder niedrigerer Kraftstufe auf. Aufheben kann auch verwendet werden, um andere magische Effekte zu beenden, falls das Abenteuer oder die Spielleitung es erlaubt.'),
    ('Beschützer', 'spell', (SELECT id FROM catalog_schools WHERE name_de = 'Allgemein'), 'Geste, Zutat (etwas zum Zeichnen)', 'aktion', 'Berührung', 'viertel', '2 WP je Kraftstufe', 'Schützt eine Person oder einen Ort (nicht größer als ein Mensch) vor Magie; kann auch auf dich selbst gewirkt werden. Die Kraftstufe aller gegen das Ziel gewirkten Zauber wird um die Kraftstufe von Beschützer reduziert. Kann auch gegen magische Monsterangriffe schützen (dann -1 Schadenswürfel je Kraftstufe).');

-- ============================================================
-- Magic: Animismus tricks + rank-1 spells
-- ============================================================

INSERT INTO catalog_spells (name_de, type, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    ('Vogelgesang', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), NULL, NULL, NULL, NULL, '1 WP', 'Umgibt dich für eine Weile mit Vogelgesang; die Vögel geben einen Vorteil auf Wahrnehmung. Funktioniert nur im Freien.'),
    ('Saubermachen', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), NULL, NULL, NULL, NULL, '1 WP', 'Der Raum, in dem du dich befindest, wird gereinigt, Staub und Schmutz verschwinden.'),
    ('Essen kochen', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), NULL, NULL, NULL, NULL, '1 WP', 'Automatischer Erfolg beim Kochen ohne Wildnisleben-Probe, sofort (eine Aktion).'),
    ('Blütenspur', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), NULL, NULL, NULL, NULL, '1 WP', 'Hübsche Blumen sprießen für eine Weile, wo du entlangläufst, und welken danach.'),
    ('Frisur', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), NULL, NULL, NULL, NULL, '1 WP', 'Ändert Farbe, Länge und Stil deiner Haare nach Belieben; kann in manchen Situationen einen Vorteil auf Täuschen/Überzeugen geben.'),
    ('Tiersprache', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), 'Wort', 'viertel', '2 m', 'sofort', '2 WP je Kraftstufe', 'Sprich mit einem Vogel oder Säugetier, stelle so viele Fragen wie deine Kraftstufe. Tiere lügen nie, ihre Antworten sind aber schwer zu deuten.'),
    ('Verbannen', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), 'Wort, Geste, Fokus (heiliges Symbol)', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', '2W8 Schaden gegen Dämonen/Untote (+W8 je weiterer Kraftstufe), Rüstung wirkungslos, kann nicht ausgewichen oder pariert werden.'),
    ('Wurzelgriff', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), 'Geste, Zutat (Äste/Wurzeln)', 'aktion', '10 m', 'viertel', '2 WP je Kraftstufe', 'Dornen/Wurzeln fesseln alle (außer dir) im Wirkungsbereich; Befreiung erfordert eine Ausweichen-Probe (Vorteil bei Kraftstufe 2, Nachteil bei Kraftstufe 3). Wirkt nicht auf Monster.'),
    ('Blitzschlag', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), 'Geste', 'aktion', '30 m', 'sofort', '2 WP je Kraftstufe', '2W6 Schaden, springt zu einem weiteren Ziel im Umkreis von 2 m (2W4 Schaden); je weiterer Kraftstufe ein zusätzlicher Sprung. Metallrüstung wirkungslos, kann ausgewichen oder pariert werden.'),
    ('Wunden heilen', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Animismus')), 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Heilt 2W6 TP (+W6 je weiterer Kraftstufe), auch bei dir selbst anwendbar.');

-- ============================================================
-- Magic: Elementarismus, 3 new rank-1 spells (tricks + Feuerball/Windstoß/
-- Pfeiler already exist -- Fire Blast is Rank 2, intentionally excluded)
-- ============================================================

INSERT INTO catalog_spells (name_de, type, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    ('Frost', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')), 'Wort, Geste', 'aktion', '4 m (Kugel)', 'viertel', '2 WP je Kraftstufe', 'Senkt die Temperatur drastisch; natürliche Feuer erlöschen, lebende Wesen verlieren W6 TP und W6 WP; Humanoide erstarren (Befreiung durch STA-Probe). Wasser gefriert zu begehbarem Eis.'),
    ('Zerschmettern', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')), 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Zerbricht ein unbelebtes, nicht-magisches Objekt; 2W10 Schaden, Rüstung wirkungslos, +W10 je weiterer Kraftstufe.');

-- ============================================================
-- Magic: Mentalismus tricks + rank-1 spells
-- ============================================================

INSERT INTO catalog_spells (name_de, type, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    ('Schloss öffnen/schließen', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Mentalismus')), NULL, NULL, NULL, NULL, '1 WP', 'Öffnet oder verschließt per Berührung ein nicht-magisches Schloss.'),
    ('Zauberhocker', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Mentalismus')), NULL, NULL, NULL, NULL, '1 WP', 'Erzeugt eine runde Fläche zum Sitzen oder Stehen, hält bis du gehst.'),
    ('Sanft fallen', 'trick', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Mentalismus')), NULL, NULL, NULL, NULL, '1 WP', 'Verlangsamt deinen Fall, du landest federleicht, egal aus welcher Höhe.'),
    ('Schweben', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Mentalismus')), 'Wort, Geste', 'aktion', '6 m', 'sofort', '2 WP je Kraftstufe', 'Lässt dich oder ein Ziel menschengroß schweben (6 m in jede Richtung); je weiterer Kraftstufe +2 m oder ein weiteres Ziel. Unwillige Kreaturen erhalten einen Nachteil.'),
    ('Fernsicht', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Mentalismus')), 'Wort, Geste', 'aktion', '1 km', 'konzentration', '2 WP je Kraftstufe', 'Sieh und höre einen bekannten oder besuchten Ort bis 1 km entfernt; je weiterer Kraftstufe verzehnfacht sich die Reichweite.'),
    ('Langer Schritt', 'spell', (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Mentalismus')), 'Wort, Geste', 'aktion', 'Berührung', 'viertel', '2 WP je Kraftstufe', 'Verdoppelt die Bewegungsrate des Ziels; auch bei dir selbst anwendbar. Je weiterer Kraftstufe ein zusätzliches Ziel.');
