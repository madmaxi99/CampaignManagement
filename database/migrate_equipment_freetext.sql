-- One-off migration bringing the already-provisioned dev DB in line with the
-- new schema.sql. Intended to run exactly once, top to bottom, against this
-- dev DB (statement order matters -- later statements rely on columns/rows
-- earlier statements just added).

-- ============================================================
-- Teil A: Magier's skill pool no longer hardcodes Animismus -- the chosen
-- school is appended client-side instead (see character-creation-wizard.js).
-- ============================================================
DELETE pks FROM profession_key_skills pks
JOIN skills sk ON sk.id = pks.skill_id
WHERE pks.profession_code = 'magier' AND sk.name_de = 'Animismus';

-- ============================================================
-- Teil C: starting silver becomes a real rolled value instead of text buried
-- in extra_de ("W8 Silber" was never parsed, coins_silver stayed 0).
-- ============================================================
ALTER TABLE profession_gear_options ADD COLUMN starting_silver_dice VARCHAR(5) NULL AFTER extra_de;

UPDATE profession_gear_options
SET starting_silver_dice = REGEXP_REPLACE(extra_de, '^.*, (W[0-9]+) Silber$', '\\1'),
    extra_de = REGEXP_REPLACE(extra_de, ', W[0-9]+ Silber$', '')
WHERE extra_de REGEXP ', W[0-9]+ Silber$';
-- (jaeger/B has no trailing "W# Silber" at all -- correctly left untouched,
-- starting_silver_dice stays NULL for that one option.)

-- ============================================================
-- Teil D: character_weapons/character_armor/character_inventory move from
-- catalog references (item_id) to frozen freetext snapshots.
-- ============================================================

-- --- Waffen ---
ALTER TABLE character_weapons
    ADD COLUMN position INT NOT NULL DEFAULT 1 AFTER character_id,
    ADD COLUMN name_de VARCHAR(150) NOT NULL DEFAULT '' AFTER position,
    ADD COLUMN grip_de VARCHAR(50) NULL AFTER name_de,
    ADD COLUMN range_de VARCHAR(50) NULL AFTER grip_de,
    ADD COLUMN damage_de VARCHAR(50) NULL AFTER range_de,
    ADD COLUMN traits_de VARCHAR(255) NULL AFTER damage_de;

UPDATE character_weapons cw
JOIN items i ON i.id = cw.item_id
JOIN item_weapons iw ON iw.item_id = i.id
SET cw.name_de = i.name_de, cw.grip_de = iw.grip_de, cw.range_de = iw.range_de,
    cw.damage_de = iw.damage_de, cw.traits_de = iw.traits_de;

-- Expand quantity > 1 into repeated rows (only Krisanna's 2nd Messer today) --
-- exactly the "just add it twice" behaviour the freetext UI now expects.
INSERT INTO character_weapons (character_id, item_id, position, name_de, grip_de, range_de, damage_de, traits_de)
SELECT character_id, item_id, position + 1, name_de, grip_de, range_de, damage_de, traits_de
FROM character_weapons WHERE quantity > 1;

ALTER TABLE character_weapons
    DROP FOREIGN KEY character_weapons_ibfk_2,
    DROP COLUMN item_id,
    DROP COLUMN quantity;

-- --- Rüstung ---
ALTER TABLE character_armor
    ADD COLUMN slot ENUM('head', 'body') NULL AFTER character_id,
    ADD COLUMN name_de VARCHAR(150) NULL AFTER slot,
    ADD COLUMN armor_value INT NULL AFTER name_de,
    ADD COLUMN penalty_de VARCHAR(255) NULL AFTER armor_value;

UPDATE character_armor ca
JOIN items i ON i.id = ca.item_id
JOIN item_armor ia ON ia.item_id = i.id
SET ca.slot = ia.slot, ca.name_de = i.name_de, ca.armor_value = ia.armor_value, ca.penalty_de = ia.penalty_skills_de;

-- Drop the old catalog columns before inserting the placeholder slot rows
-- below (item_id is NOT NULL with no default, so those INSERTs -- which
-- don't set item_id -- must run after it's gone).
ALTER TABLE character_armor
    DROP FOREIGN KEY character_armor_ibfk_2,
    DROP COLUMN item_id,
    DROP COLUMN quantity,
    ADD UNIQUE KEY uniq_character_slot (character_id, slot),
    MODIFY COLUMN slot ENUM('head', 'body') NOT NULL;

-- Ensure every character has both slot rows (most only had the one they
-- actually own so far).
INSERT INTO character_armor (character_id, slot)
SELECT c.id, 'head' FROM characters c
WHERE NOT EXISTS (SELECT 1 FROM character_armor ca WHERE ca.character_id = c.id AND ca.slot = 'head');

INSERT INTO character_armor (character_id, slot)
SELECT c.id, 'body' FROM characters c
WHERE NOT EXISTS (SELECT 1 FROM character_armor ca WHERE ca.character_id = c.id AND ca.slot = 'body');

-- --- Inventar (Kleinkram-Merge) ---
-- character_inventory currently has no rows at all (every "Kleinkram" so far
-- lived only in characters.misc_items_de as one flavor string per character).
ALTER TABLE character_inventory
    ADD COLUMN name_de VARCHAR(150) NOT NULL DEFAULT '' AFTER position,
    ADD COLUMN description_de VARCHAR(255) NULL AFTER name_de;

ALTER TABLE character_inventory
    DROP FOREIGN KEY character_inventory_ibfk_2,
    DROP COLUMN item_id;

-- Split each character's misc_items_de ("Fackel, Feuerstein & Zunder, ...")
-- into one character_inventory row per comma-separated piece. Pure-SQL
-- split via SUBSTRING_INDEX (no external script needed) -- the joined
-- number sequence covers up to 8 pieces, comfortably above the current max
-- of 6 (asd/margret).
INSERT INTO character_inventory (character_id, position, name_de, quantity)
SELECT c.id, n.n,
       TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(c.misc_items_de, ', ', n.n), ', ', -1)),
       1
FROM characters c
JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8) n
    ON n.n <= (CHAR_LENGTH(c.misc_items_de) - CHAR_LENGTH(REPLACE(c.misc_items_de, ', ', ''))) / 2 + 1
WHERE c.misc_items_de IS NOT NULL AND c.misc_items_de != '';

ALTER TABLE characters DROP COLUMN misc_items_de;
