SET NAMES utf8mb4;

-- Attributes

INSERT INTO attributes (code, name_de) VALUES
    ('STA', 'Stärke'),
    ('KON', 'Konstitution'),
    ('GEW', 'Gewandtheit'),
    ('INT', 'Intelligenz'),
    ('WIL', 'Willenskraft'),
    ('CHA', 'Charisma');

-- Conditions

INSERT INTO conditions (code, name_de, attribute_code) VALUES
    ('exhausted', 'Erschöpft', 'STA'),
    ('sickly', 'Kränkelnd', 'KON'),
    ('dazed', 'Benommen', 'GEW'),
    ('angry', 'Wütend', 'INT'),
    ('scared', 'Verängstigt', 'WIL'),
    ('disheartened', 'Verzagt', 'CHA');

-- Skills (20 regular + 10 combat + 1 secondary)

INSERT INTO skills (name_de, attribute_code, category) VALUES
    ('Akrobatik', 'GEW', 'regular'),
    ('Ausweichen', 'GEW', 'regular'),
    ('Bestienkunde', 'INT', 'regular'),
    ('Darbietung', 'CHA', 'regular'),
    ('Entdecken', 'INT', 'regular'),
    ('Feilschen', 'CHA', 'regular'),
    ('Fingerfertigkeit', 'GEW', 'regular'),
    ('Fremdsprachen', 'INT', 'regular'),
    ('Handwerk', 'STA', 'regular'),
    ('Heilkunde', 'INT', 'regular'),
    ('Heimlichkeit', 'GEW', 'regular'),
    ('Jagen & Fischen', 'GEW', 'regular'),
    ('Mythen & Legenden', 'INT', 'regular'),
    ('Reiten', 'GEW', 'regular'),
    ('Schwimmen', 'GEW', 'regular'),
    ('Seefahrt', 'GEW', 'regular'),
    ('Täuschen', 'CHA', 'regular'),
    ('Überzeugen', 'CHA', 'regular'),
    ('Wahrnehmung', 'INT', 'regular'),
    ('Wildnisleben', 'INT', 'regular'),
    ('Armbrüste', 'GEW', 'combat'),
    ('Äxte', 'STA', 'combat'),
    ('Bögen', 'GEW', 'combat'),
    ('Hämmer', 'STA', 'combat'),
    ('Messer', 'GEW', 'combat'),
    ('Prügelei', 'STA', 'combat'),
    ('Schleudern', 'GEW', 'combat'),
    ('Schwerter', 'STA', 'combat'),
    ('Speere', 'STA', 'combat'),
    ('Stäbe', 'GEW', 'combat'),
    ('Elementarismus', 'INT', 'secondary');

-- Spells (3 Zaubertricks + 3 Zauber, all Elementarismus)

INSERT INTO spells (name_de, type, school_skill_id, components_de, casting_time_de, range_de, duration_de, wp_note_de, effect_de) VALUES
    ('Aufwärmen/Abkühlen', 'trick', NULL, NULL, NULL, NULL, NULL, '1 WP',
        'Wärmt oder kühlt einen Radius von 10 m und schützt einmal gegen die Auswirkungen einer Kälteschicht.'),
    ('Entzünden', 'trick', NULL, NULL, NULL, NULL, NULL, '1 WP',
        'Entzündet oder löscht eine Kerze, Fackel oder Laterne im Umkreis von 10 m.'),
    ('Rauchwolke', 'trick', NULL, NULL, NULL, NULL, NULL, '1 WP',
        'Erzeugt eine beeindruckende Rauchwolke, die einen situativen Vorteil auf Heimlichkeit geben kann.'),
    ('Feuerball', 'spell',
        (SELECT id FROM skills WHERE name_de = 'Elementarismus'),
        'Wort, Geste', 'Aktion', '20 m', 'Sofort', '2 WP je Kraftstufe',
        '2W6 Schaden, entzündet brennbare Objekte. +1W6 Schaden oder ein zusätzliches Ziel pro weiterer Kraftstufe.'),
    ('Windstoß', 'spell',
        (SELECT id FROM skills WHERE name_de = 'Elementarismus'),
        'Wort, Geste', 'Aktion', '10 m Kegel', 'Sofort', '2 WP je Kraftstufe',
        'Schleudert Kreaturen/Objekte 2W4 m zurück, gleich hoher Wuchtschaden. +1 Würfel pro weiterer Kraftstufe.'),
    ('Pfeiler', 'spell',
        (SELECT id FROM skills WHERE name_de = 'Elementarismus'),
        'Wort, Geste', 'Aktion', '10 m', 'Tagesabschnitt', '2 WP je Kraftstufe',
        'Hebt eine 3 m hohe Säule an; Akrobatik-Probe oder Sturz mit Sturzschaden. +3 m Höhe pro weiterer Kraftstufe.');

-- Item catalog (seeded incrementally — placeholder prices where the quickstart gives none)

INSERT INTO items (name_de, description_de, rarity, price_copper, kind) VALUES
    ('Stab', 'Ein einfacher Holzstab, wie ihn Elementaristen zum Fokussieren ihrer Magie nutzen.', 'gewöhnlich', 100, 'weapon'),
    ('Zauberbuch', 'Ein abgegriffenes Buch voller handschriftlicher Notizen zu Zaubersprüchen.', 'ungewöhnlich', 200, 'misc'),
    ('Fackel', 'Eine Fackel, die ca. eine Stunde lang brennt.', 'gewöhnlich', 5, 'misc'),
    ('Wein', 'Eine Flasche einfacher Rotwein.', 'gewöhnlich', 30, 'misc'),
    ('Buch', 'Ein gebundenes Buch mit unbekanntem Inhalt.', 'gewöhnlich', 50, 'misc'),
    ('Amulett der Klarheit', 'Ein altes Amulett, das Gedanken zu ordnen scheint. Angeblich selten und begehrt.', 'selten', 500, 'misc'),
    ('Lederrüstung', 'Einfache, flexible Rüstung aus gegerbtem Leder.', 'gewöhnlich', 150, 'armor');

INSERT INTO item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de)
SELECT id, '2-händig', '2', 'W8', 9, 'Wucht' FROM items WHERE name_de = 'Stab';

INSERT INTO item_armor (item_id, slot, armor_value, penalty_skills_de)
SELECT id, 'body', 2, 'Heimlichkeit, Ausweichen, Akrobatik' FROM items WHERE name_de = 'Lederrüstung';

INSERT INTO item_misc (item_id)
SELECT id FROM items WHERE name_de IN ('Zauberbuch', 'Fackel', 'Wein', 'Buch', 'Amulett der Klarheit');

-- Character: Erzmeister Aodhan

INSERT INTO characters (
    slug, name_de, kin_de, age_de, profession_de, flaw_de, appearance_de, memento_de, misc_items_de,
    movement, damage_bonus_sta_de, damage_bonus_gew_de, carrying_capacity,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'erzmeister_aodhan', 'Erzmeister Aodhan', 'Mensch', 'Alt', 'Magier – Elementarist',
    'Feige. Du hältst dich stets im Rücken der Anderen.',
    'Groß und drahtig. Langer weißer Bart und buschige Augenbrauen. Wissbegieriger Blick.',
    'Abgegriffenes Tagebuch mit deinen Erfahrungen und Erkenntnissen.',
    'Feuerstein & Zunder',
    8, '—', '—', 4,
    11, 11, 18, 18, 0, 7, 0
);

SET @aodhan_id = (SELECT id FROM characters WHERE slug = 'erzmeister_aodhan');

-- Attribute values

INSERT INTO character_attributes (character_id, attribute_code, value)
SELECT @aodhan_id, code, value FROM (
    SELECT 'STA' AS code, 8 AS value
    UNION ALL SELECT 'KON', 11
    UNION ALL SELECT 'GEW', 9
    UNION ALL SELECT 'INT', 16
    UNION ALL SELECT 'WIL', 18
    UNION ALL SELECT 'CHA', 14
) v;

-- Conditions (all inactive on the printed sheet)

INSERT INTO character_conditions (character_id, condition_code, active)
SELECT @aodhan_id, code, 0 FROM conditions;

-- Skill values

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @aodhan_id, s.id, v.value
FROM skills s
JOIN (
    SELECT 'Akrobatik' AS name_de, 5 AS value
    UNION ALL SELECT 'Ausweichen', 10
    UNION ALL SELECT 'Bestienkunde', 14
    UNION ALL SELECT 'Darbietung', 6
    UNION ALL SELECT 'Entdecken', 14
    UNION ALL SELECT 'Feilschen', 6
    UNION ALL SELECT 'Fingerfertigkeit', 5
    UNION ALL SELECT 'Fremdsprachen', 14
    UNION ALL SELECT 'Handwerk', 4
    UNION ALL SELECT 'Heilkunde', 14
    UNION ALL SELECT 'Heimlichkeit', 10
    UNION ALL SELECT 'Jagen & Fischen', 5
    UNION ALL SELECT 'Mythen & Legenden', 14
    UNION ALL SELECT 'Reiten', 5
    UNION ALL SELECT 'Schwimmen', 7
    UNION ALL SELECT 'Seefahrt', 7
    UNION ALL SELECT 'Täuschen', 6
    UNION ALL SELECT 'Überzeugen', 12
    UNION ALL SELECT 'Wahrnehmung', 14
    UNION ALL SELECT 'Wildnisleben', 14
    UNION ALL SELECT 'Armbrüste', 5
    UNION ALL SELECT 'Äxte', 4
    UNION ALL SELECT 'Bögen', 5
    UNION ALL SELECT 'Hämmer', 5
    UNION ALL SELECT 'Messer', 5
    UNION ALL SELECT 'Prügelei', 4
    UNION ALL SELECT 'Schleudern', 5
    UNION ALL SELECT 'Schwerter', 4
    UNION ALL SELECT 'Speere', 4
    UNION ALL SELECT 'Stäbe', 10
    UNION ALL SELECT 'Elementarismus', 14
) v ON v.name_de = s.name_de;

-- Talents

INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES
    (@aodhan_id, 'Anpassungsfähig', NULL,
        'Bei einer Fertigkeitsprobe kannst du dich entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen.'),
    (@aodhan_id, 'Magie', 'unterschiedlich',
        'Als Zauberer kannst du Magie benutzen.');

-- Known spells/tricks

INSERT INTO character_spells (character_id, spell_id)
SELECT @aodhan_id, id FROM spells;

-- Weapon

INSERT INTO character_weapons (character_id, item_id, quantity)
SELECT @aodhan_id, id, 1 FROM items WHERE name_de = 'Stab';

-- Inventory

INSERT INTO character_inventory (character_id, position, item_id, quantity)
SELECT @aodhan_id, 1, id, 1 FROM items WHERE name_de = 'Zauberbuch'
UNION ALL
SELECT @aodhan_id, 2, id, 2 FROM items WHERE name_de = 'Fackel';
