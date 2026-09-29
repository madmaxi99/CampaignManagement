SET NAMES utf8mb4;

-- Character: Erzmeister Aodhan
--
-- Split out of seed_aodhan.sql: this needs catalog_kins/catalog_professions
-- (seed_character_creation_catalog.sql, seed_wizard_expansion.sql),
-- catalog_flaws (seed_character_creation_catalog.sql) and the
-- 'Feuerstein & Zunder' catalog item (seed_items_completion.sql), all of
-- which load after seed_aodhan.sql -- see provisioning/docker-compose.yml
-- for the mount order this file depends on.
--
-- Aodhan's original flaw text ("Feige. Du hältst dich stets im Rücken der
-- Anderen.") isn't one of the 20 catalog_flaws rows verbatim; it matches
-- roll 5, 'Ängstlich' ("Ich halte mich immer im Hintergrund der Gruppe.")
-- in meaning, so that's what flaw_id now points at.

INSERT INTO characters (
    slug, name_de, kin_code, age_id, profession_code, flaw_id, appearance_de, memento_de, portrait_path,
    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
) VALUES (
    'erzmeister_aodhan', 'Erzmeister Aodhan', 'mensch',
    (SELECT id FROM catalog_age WHERE name_de = 'Alt'),
    'magier',
    (SELECT id FROM catalog_flaws WHERE name_de = 'Ängstlich'),
    'Groß und drahtig. Langer weißer Bart und buschige Augenbrauen. Wissbegieriger Blick.',
    'Abgegriffenes Tagebuch mit deinen Erfahrungen und Erkenntnissen.',
    'images/characters/erzmeister_aodhan.jpg',
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
SELECT @aodhan_id, code, 0 FROM catalog_conditions;

-- Skill values

INSERT INTO character_skills (character_id, skill_id, value)
SELECT @aodhan_id, s.id, v.value
FROM catalog_skills s
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
SELECT @aodhan_id, id FROM catalog_spells;

-- Weapon (freetext -- read once from the catalog, then no further catalog
-- reference, see the schema.sql comment on character_weapons)

INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT @aodhan_id, 1, i.name_de, w.grip_de, w.range_de, w.damage_de, w.traits_de
FROM catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id
WHERE i.name_de = 'Stab';

-- Armor (always both fixed slots; head stays empty)

INSERT INTO character_armor (character_id, slot) VALUES (@aodhan_id, 'head');

INSERT INTO character_armor (character_id, slot, name_de, armor_value, penalty_de)
SELECT @aodhan_id, 'body', i.name_de, a.armor_value, a.penalty_skills_de
FROM catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id
WHERE i.name_de = 'Lederrüstung';

-- Inventory (freetext; 'Feuerstein & Zunder' was the old misc_items_de text)

INSERT INTO character_inventory (character_id, position, name_de, description_de, quantity)
SELECT @aodhan_id, 1, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Zauberbuch'
UNION ALL
SELECT @aodhan_id, 2, name_de, description_de, 2 FROM catalog_items WHERE name_de = 'Fackel'
UNION ALL
SELECT @aodhan_id, 3, name_de, description_de, 1 FROM catalog_items WHERE name_de = 'Feuerstein & Zunder';
