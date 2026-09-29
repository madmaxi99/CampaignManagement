SET NAMES utf8mb4;

-- Attributes

INSERT INTO catalog_attributes (code, name_de) VALUES
    ('STA', 'Stärke'),
    ('KON', 'Konstitution'),
    ('GEW', 'Gewandtheit'),
    ('INT', 'Intelligenz'),
    ('WIL', 'Willenskraft'),
    ('CHA', 'Charisma');

-- Conditions

INSERT INTO catalog_conditions (code, name_de, attribute_code) VALUES
    ('exhausted', 'Erschöpft', 'STA'),
    ('sickly', 'Kränkelnd', 'KON'),
    ('dazed', 'Benommen', 'GEW'),
    ('angry', 'Wütend', 'INT'),
    ('scared', 'Verängstigt', 'WIL'),
    ('disheartened', 'Verzagt', 'CHA');

-- Skills (20 regular + 10 combat + 1 secondary)

INSERT INTO catalog_skills (name_de, attribute_code, category) VALUES
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

INSERT INTO catalog_schools (name_de, skill_id, display_order)
SELECT 'Elementarismus', id, 1 FROM catalog_skills WHERE name_de = 'Elementarismus';

-- Time units + spell duration/casting-time lookups (needed before any
-- catalog_spells row, since those reference them by FK).

INSERT INTO catalog_time_units (code, name_de, duration_de, usage_de) VALUES
    ('runde', 'Runde', '10 Sek.', 'eine Aktion im Kampf, Verschnaufen'),
    ('viertel', 'Viertel', '15 Minuten', 'einen Raum erkunden, eine kurze Rast'),
    ('tagesabschnitt', 'Tagesabschnitt', '6 Stunden', 'ein Marsch von 15 km, eine lange Rast');

INSERT INTO catalog_spell_durations (code, name_de, time_unit_code, description_de) VALUES
    ('sofort', 'Sofort', NULL, 'Der Effekt tritt sofort ein und hält nicht an.'),
    ('runde', 'Runde', 'runde', 'Der Effekt hält an, bis du in der nächsten Runde am Zug bist.'),
    ('viertel', 'Viertel', 'viertel', 'Der Effekt hält für ein Viertel an.'),
    ('tagesabschnitt', 'Tagesabschnitt', 'tagesabschnitt', 'Der Effekt hält bis zum Ende des aktuellen Tagesabschnitts an.'),
    ('konzentration', 'Konzentration', NULL, 'Der Effekt endet, wenn du eine andere Handlung durchführst, Schaden erleidest oder eine WIL-Probe gegen eine plötzliche Störung (z. B. ein Geräusch) nicht schaffst, um die Konzentration aufrechtzuerhalten (keine Aktion).');

INSERT INTO catalog_casting_times (code, name_de, time_unit_code, description_de) VALUES
    ('aktion', 'Aktion', NULL, 'Das Wirken des Zaubers zählt im Kampf als Aktion, sofern nicht anders angegeben.'),
    ('reaktion', 'Reaktion', NULL, 'Der Zauber wird außerhalb deines eigenen Zuges gewirkt, wie beim Parieren oder Ausweichen.'),
    ('viertel', 'Viertel', 'viertel', 'Das Wirken erfordert ein Viertel Vorbereitung (Ritual).'),
    ('tagesabschnitt', 'Tagesabschnitt', 'tagesabschnitt', 'Das Wirken erfordert einen ganzen Tagesabschnitt Vorbereitung (Ritual).');

-- Spells (3 Zaubertricks + 3 Zauber, all Elementarismus)

INSERT INTO catalog_spells (name_de, type, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    ('Aufwärmen/Abkühlen', 'trick',
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        NULL, NULL, NULL, NULL, '1 WP',
        'Wärmt oder kühlt einen Radius von 10 m und schützt einmal gegen die Auswirkungen einer Kälteschicht.'),
    ('Entzünden', 'trick',
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        NULL, NULL, NULL, NULL, '1 WP',
        'Entzündet oder löscht eine Kerze, Fackel oder Laterne im Umkreis von 10 m.'),
    ('Rauchwolke', 'trick',
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        NULL, NULL, NULL, NULL, '1 WP',
        'Erzeugt eine beeindruckende Rauchwolke, die einen situativen Vorteil auf Heimlichkeit geben kann.'),
    ('Feuerball', 'spell',
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste', 'aktion', '20 m', 'sofort', '2 WP je Kraftstufe',
        '2W6 Schaden, entzündet brennbare Objekte. +1W6 Schaden oder ein zusätzliches Ziel pro weiterer Kraftstufe.'),
    ('Windstoß', 'spell',
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste', 'aktion', '10 m Kegel', 'sofort', '2 WP je Kraftstufe',
        'Schleudert Kreaturen/Objekte 2W4 m zurück, gleich hoher Wuchtschaden. +1 Würfel pro weiterer Kraftstufe.'),
    ('Pfeiler', 'spell',
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste', 'aktion', '10 m', 'tagesabschnitt', '2 WP je Kraftstufe',
        'Hebt eine 3 m hohe Säule an; Akrobatik-Probe oder Sturz mit Sturzschaden. +3 m Höhe pro weiterer Kraftstufe.');

-- Item catalog (seeded incrementally — placeholder prices where the quickstart gives none)

INSERT INTO catalog_items (name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    ('Stab', 'Ein einfacher Holzstab, wie ihn Elementaristen zum Fokussieren ihrer Magie nutzen.', 'gewöhnlich', 1, 0, 0, 'weapon'),
    ('Zauberbuch', 'Ein abgegriffenes Buch voller handschriftlicher Notizen zu Zaubersprüchen.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    ('Fackel', 'Eine Fackel, die ca. eine Stunde lang brennt.', 'gewöhnlich', 0, 0, 5, 'misc'),
    ('Wein', 'Eine Flasche einfacher Rotwein.', 'gewöhnlich', 0, 3, 0, 'misc'),
    ('Buch', 'Ein gebundenes Buch mit unbekanntem Inhalt.', 'gewöhnlich', 0, 5, 0, 'misc'),
    ('Amulett der Klarheit', 'Ein altes Amulett, das Gedanken zu ordnen scheint. Angeblich selten und begehrt.', 'selten', 5, 0, 0, 'misc'),
    ('Lederrüstung', 'Einfache, flexible Rüstung aus gegerbtem Leder.', 'gewöhnlich', 1, 5, 0, 'armor');

INSERT INTO catalog_item_weapons (item_id, grip_de, range_de, damage_de, durability, traits_de)
SELECT id, '2-händig', '2', 'W8', 9, 'Wucht' FROM catalog_items WHERE name_de = 'Stab';

INSERT INTO catalog_item_armor (item_id, slot, armor_value, penalty_stealth, penalty_evasion, penalty_acrobatics)
SELECT id, 'body', 2, 1, 1, 1 FROM catalog_items WHERE name_de = 'Lederrüstung';

-- The "Character: Erzmeister Aodhan" section used to live here, but it needs
-- catalog_kins/catalog_professions/catalog_flaws (seed_character_creation_catalog.sql,
-- seed_wizard_expansion.sql) and catalog_items rows from seed_items_completion.sql
-- (e.g. 'Feuerstein & Zunder'), all of which load after this file -- see
-- seed_aodhan_character.sql, mounted later in provisioning/docker-compose.yml.
