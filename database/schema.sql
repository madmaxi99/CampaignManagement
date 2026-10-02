SET NAMES utf8mb4;

-- Catalogs (Dragonbane rules reference data, see docs/bilder/ screenshots of
-- the core rulebook). All catalog_* tables are shared reference data, never
-- campaign- or character-specific.

CREATE TABLE catalog_attributes (
    code CHAR(3) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_conditions (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    attribute_code CHAR(3) NOT NULL,
    FOREIGN KEY (attribute_code) REFERENCES catalog_attributes(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL UNIQUE,
    attribute_code CHAR(3) NOT NULL,
    category ENUM('regular', 'combat', 'secondary') NOT NULL,
    description_de TEXT NULL,
    FOREIGN KEY (attribute_code) REFERENCES catalog_attributes(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Magic schools are mechanically secondary skills (catalog_skills.category =
-- 'secondary') -- catalog_schools is the school as its own first-class entity
-- (referenced by catalog_spells.school_id below), with skill_id only as the
-- link to the underlying skill mechanic (which skill you roll to cast).
-- "Allgemein" (general magic, tricks/spells usable regardless of your trained
-- school) is a real row here too, with skill_id NULL -- it has a name but no
-- skill to roll, since general tricks/spells don't require training.
CREATE TABLE catalog_schools (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL UNIQUE,
    skill_id INT NULL UNIQUE,
    lore_de TEXT NULL,
    display_order INT NOT NULL DEFAULT 0,
    FOREIGN KEY (skill_id) REFERENCES catalog_skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- "Die Zeit messen": the three units of time the game measures duration in.
CREATE TABLE catalog_time_units (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    duration_de VARCHAR(50) NOT NULL,
    usage_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- The 5 canonical spell duration categories (Chapter 5 - Magic, "Duration").
-- 3 of the 5 are measured in a catalog_time_units unit; Sofort/Konzentration
-- are special cases (no elapsed time / open-ended), hence time_unit_code NULL.
CREATE TABLE catalog_spell_durations (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    time_unit_code VARCHAR(20) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (time_unit_code) REFERENCES catalog_time_units(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- The casting-time categories (Chapter 5 - Magic, "Casting Time"): normally
-- Aktion, sometimes Reaktion, or -- for rituals -- a full catalog_time_units unit.
CREATE TABLE catalog_casting_times (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    time_unit_code VARCHAR(20) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (time_unit_code) REFERENCES catalog_time_units(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_spells (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL,
    type ENUM('trick', 'spell') NOT NULL,
    -- NULL for tricks (no rank); spells are rank 1-5. Character creation only
    -- offers rank 1 spells, per the rules ("choose three rank I spells").
    rank TINYINT UNSIGNED NULL,
    school_id INT NOT NULL,
    components_de VARCHAR(255) NULL,
    casting_time_code VARCHAR(20) NULL,
    range_de VARCHAR(100) NULL,
    duration_code VARCHAR(20) NULL,
    wp_note_de VARCHAR(100) NULL,
    effect_de TEXT NOT NULL,
    FOREIGN KEY (school_id) REFERENCES catalog_schools(id),
    FOREIGN KEY (casting_time_code) REFERENCES catalog_casting_times(code),
    FOREIGN KEY (duration_code) REFERENCES catalog_spell_durations(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Item catalog (for loot drops / shops, populated incrementally)
--
-- Price is stored as gold/silver/copper (matching how the rulebook itself
-- prices things, and how characters.coins_gold/coins_silver/coins_copper
-- already tracks a purse) instead of one flattened total-copper integer --
-- readable as "12 Gold" instead of computing "1200 Kupfer" in your head.

CREATE TABLE catalog_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    description_de TEXT NOT NULL,
    rarity ENUM('gewöhnlich', 'ungewöhnlich', 'selten', 'episch', 'legendär', 'einzigartig') NOT NULL DEFAULT 'gewöhnlich',
    price_gold INT NOT NULL DEFAULT 0,
    price_silver INT NOT NULL DEFAULT 0,
    price_copper INT NOT NULL DEFAULT 0,
    kind ENUM('weapon', 'armor', 'misc') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_item_weapons (
    item_id INT PRIMARY KEY,
    grip_de VARCHAR(50) NOT NULL,
    -- STR requirement to wield without a bane; NULL = none ("--" in the book).
    str_requirement INT NULL,
    -- Usually meters, but 'STR'/'STR×2' for thrown weapons whose throwing
    -- range is a formula off the wielder's STR score, per the book.
    range_de VARCHAR(50) NOT NULL,
    damage_de VARCHAR(50) NOT NULL,
    -- NULL = "--" in the book (e.g. Flail, Sling: no tracked durability).
    durability INT NULL,
    traits_de VARCHAR(150) NULL,
    FOREIGN KEY (item_id) REFERENCES catalog_items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- penalty_* are fixed narrative flags matching the physical Dragonbane sheet
-- (body: Heimlichkeit/Ausweichen/Akrobatik; head: Wahrnehmung/Fernkampf --
-- "Fernkampf" has no single matching catalog_skills row, it's a fixed flag).
-- A row only ever uses the 3 (body) or 2 (head) flags that apply to its slot.
CREATE TABLE catalog_item_armor (
    item_id INT PRIMARY KEY,
    slot ENUM('body', 'head') NOT NULL,
    armor_value INT NOT NULL,
    penalty_stealth BOOLEAN NOT NULL DEFAULT 0,
    penalty_evasion BOOLEAN NOT NULL DEFAULT 0,
    penalty_acrobatics BOOLEAN NOT NULL DEFAULT 0,
    penalty_perception BOOLEAN NOT NULL DEFAULT 0,
    penalty_ranged BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (item_id) REFERENCES catalog_items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- No catalog_item_misc table: a "misc" item (kind='misc') has no extra
-- columns beyond catalog_items itself, so a subtype table would be empty
-- boilerplate. catalog_items.kind already fully identifies it.

-- Characters

-- kin_code/age_id/profession_code/flaw_id reference catalog_kins/catalog_age/
-- catalog_professions/catalog_flaws below (further down in this file) -- the
-- FK constraints for them are added via ALTER TABLE right after catalog_flaws
-- is created, since MySQL needs the referenced table to exist first.
CREATE TABLE characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    is_default BOOLEAN NOT NULL DEFAULT 0,
    name_de VARCHAR(100) NOT NULL,
    kin_code VARCHAR(20) NOT NULL,
    age_id INT NOT NULL,
    profession_code VARCHAR(30) NOT NULL,
    flaw_id INT NOT NULL,
    appearance_de TEXT NOT NULL,
    memento_de TEXT NOT NULL,
    -- Web-relative path (from the public/ root, no leading slash), e.g.
    -- 'images/characters/erzmeister_aodhan.jpg'. NULL = no portrait yet.
    -- Once set (default roster seed data, or a player upload via the sheet),
    -- it is permanent -- the UI never offers to replace it.
    portrait_path VARCHAR(255) NULL,
    hp_max INT NOT NULL,
    hp_current INT NOT NULL,
    wp_max INT NOT NULL,
    wp_current INT NOT NULL,
    coins_gold INT NOT NULL DEFAULT 0,
    coins_silver INT NOT NULL DEFAULT 0,
    coins_copper INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_attributes (
    character_id INT NOT NULL,
    attribute_code CHAR(3) NOT NULL,
    value INT NOT NULL,
    PRIMARY KEY (character_id, attribute_code),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_code) REFERENCES catalog_attributes(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_conditions (
    character_id INT NOT NULL,
    condition_code VARCHAR(20) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (character_id, condition_code),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (condition_code) REFERENCES catalog_conditions(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_skills (
    character_id INT NOT NULL,
    skill_id INT NOT NULL,
    value INT NOT NULL,
    marked_for_advancement BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (character_id, skill_id),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES catalog_skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_talents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    name_de VARCHAR(100) NOT NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_spells (
    character_id INT NOT NULL,
    spell_id INT NOT NULL,
    PRIMARY KEY (character_id, spell_id),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (spell_id) REFERENCES catalog_spells(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Waffen/Rüstung/Inventar sind Freitext: bei der Charaktererstellung werden
-- Katalog-Items (catalog_items/catalog_item_weapons/catalog_item_armor) einmalig als Text
-- übernommen, danach ist alles frei editierbar ohne weiteren Katalog-Bezug.
CREATE TABLE character_weapons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    position INT NOT NULL DEFAULT 1,
    name_de VARCHAR(150) NOT NULL,
    grip_de VARCHAR(50) NULL,
    range_de VARCHAR(50) NULL,
    damage_de VARCHAR(50) NULL,
    traits_de VARCHAR(255) NULL,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Genau zwei feste Zeilen pro Charakter (Kopf/Körper), immer vorhanden statt
-- add/remove -- leer, wenn der Slot unbesetzt ist.
-- Freetext, hand-typed copy (no FK to catalog_items -- a player can wear any
-- gear, not just catalog items). penalty_* mirror catalog_item_armor's flags
-- but are independently editable here, same "no ongoing catalog link" rule
-- as name_de/armor_value.
CREATE TABLE character_armor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    slot ENUM('head', 'body') NOT NULL,
    name_de VARCHAR(150) NULL,
    armor_value INT NULL,
    -- body-slot penalties (Rüstung)
    penalty_stealth BOOLEAN NOT NULL DEFAULT 0,
    penalty_evasion BOOLEAN NOT NULL DEFAULT 0,
    penalty_acrobatics BOOLEAN NOT NULL DEFAULT 0,
    -- head-slot penalties (Helm)
    penalty_perception BOOLEAN NOT NULL DEFAULT 0,
    penalty_ranged BOOLEAN NOT NULL DEFAULT 0,
    UNIQUE KEY uniq_character_slot (character_id, slot),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Keine Unterscheidung mehr zwischen normalem Kram und "Kleinkram" -- ein
-- einziges Freitext-Inventar.
CREATE TABLE character_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    position INT NOT NULL,
    name_de VARCHAR(150) NOT NULL,
    description_de VARCHAR(255) NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- The catalog holds only the ruleset (items, skills, bestiary, encounter
-- tables, ...) and is static; campaigns own their places, items and NPCs
-- (see docs/CONCEPT.md and docs/SCHEMA.md). catalog_* rows exist exactly once.

-- Bestiary = stat blocks, never individual creatures ("Wolf", "Goblin", or the
-- stat block of one unique being like Krakul). Named beings are
-- campaign_npcs pointing at their stat block here.
-- is_unique: one-off boss stat block that only exists for a single story.
-- traits_de: special rules that are neither resistance nor immunity.
-- kit_de: profile of variants without their own attack table (skills,
-- typical armor/weapon, damage bonus, abilities, spells).
CREATE TABLE catalog_bestiary (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    category_de VARCHAR(50) NULL,
    is_unique BOOLEAN NOT NULL DEFAULT 0,
    hp INT NOT NULL,
    grimmigkeit_de VARCHAR(20) NOT NULL,
    size_de VARCHAR(50) NOT NULL,
    movement INT NOT NULL,
    armor_de VARCHAR(50) NOT NULL DEFAULT '—',
    resistances_de TEXT NULL,
    immunities_de TEXT NULL,
    traits_de TEXT NULL,
    kit_de TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_bestiary_attacks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bestiary_id INT NOT NULL,
    roll_de VARCHAR(10) NOT NULL,
    title_de VARCHAR(100) NOT NULL,
    effect_de TEXT NOT NULL,
    FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Random encounter tables by environment ("Wald", "Straße", "Ruine"). Campaign
-- places pick one; the entries point at bestiary stat blocks with a count.
CREATE TABLE catalog_encounter_tables (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- max_roll NULL = open ended from min_roll upwards. bestiary_id NULL = nothing
-- happens / no creature (description in text_de).
CREATE TABLE catalog_encounter_table_entries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_id INT NOT NULL,
    min_roll INT NOT NULL,
    max_roll INT NULL,
    bestiary_id INT NULL,
    quantity_de VARCHAR(20) NULL,
    text_de VARCHAR(255) NULL,
    FOREIGN KEY (table_id) REFERENCES catalog_encounter_tables(id) ON DELETE CASCADE,
    FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Campaigns (DM screens). Addressed as /campaign/:id; images live in
-- public/images/campaigns/<campaign id>/.

CREATE TABLE campaigns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    teaser_de VARCHAR(255) NOT NULL,
    background_de TEXT NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- label is what is displayed ("1", "1.5"), position only sorts, in steps of
-- 10 so a chapter 1.5 can be inserted at 15 without renumbering.
CREATE TABLE campaign_chapters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    label VARCHAR(10) NOT NULL,
    position INT NOT NULL,
    title_de VARCHAR(150) NOT NULL,
    notes_de TEXT NULL,
    UNIQUE KEY uq_chapter_position (campaign_id, position),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Places belong to their campaign and nest (land > village > tavern, tower >
-- floor). description_de can be read aloud, dm_text_de is the short DM-only
-- description. number_label/position order and number rooms on a map ("#5").
-- encounter_table_id: random encounter table of the catalog used here.
CREATE TABLE campaign_places (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    parent_id INT NULL,
    chapter_id INT NULL,
    position INT NOT NULL DEFAULT 0,
    number_label VARCHAR(10) NULL,
    name_de VARCHAR(150) NOT NULL,
    description_de TEXT NULL,
    dm_text_de TEXT NULL,
    -- Web-relative path from the public/ root, no leading slash.
    image_path VARCHAR(255) NULL,
    encounter_table_id INT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES campaign_places(id) ON DELETE SET NULL,
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (encounter_table_id) REFERENCES catalog_encounter_tables(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Story items of one campaign: books, letters, quest items, the odd bottle of
-- wine. Rule items (swords, potions) stay in catalog_items. text_de is the
-- text of a book/letter. Found at place_id and/or found_hint_de.
CREATE TABLE campaign_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    chapter_id INT NULL,
    place_id INT NULL,
    found_hint_de VARCHAR(255) NULL,
    name_de VARCHAR(150) NOT NULL,
    description_de TEXT NULL,
    dm_text_de TEXT NULL,
    text_de TEXT NULL,
    -- Web-relative path from the public/ root, no leading slash.
    image_path VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (place_id) REFERENCES campaign_places(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- NPCs belong to their campaign; deleting the campaign deletes them.
-- Players see name and portrait only; description_de can be read aloud,
-- dm_text_de is DM only. notes_de = play notes ("alive", "liked Aodhan"),
-- cleared by the restart. place_id/found_hint_de: where a quest NPC is found.
CREATE TABLE campaign_npcs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    chapter_id INT NULL,
    place_id INT NULL,
    found_hint_de VARCHAR(255) NULL,
    name_de VARCHAR(150) NOT NULL,
    description_de TEXT NULL,
    dm_text_de TEXT NULL,
    notes_de TEXT NULL,
    bestiary_id INT NULL,
    -- Web-relative path from the public/ root, no leading slash.
    portrait_path VARCHAR(255) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL,
    FOREIGN KEY (place_id) REFERENCES campaign_places(id) ON DELETE SET NULL,
    FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_bestiary (
    campaign_id INT NOT NULL,
    bestiary_id INT NOT NULL,
    chapter_id INT NULL,
    notes_de TEXT NULL,
    PRIMARY KEY (campaign_id, bestiary_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id),
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Chronicle of one campaign: everything that happens. Cleared by the restart.
CREATE TABLE campaign_chronicle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    title_de VARCHAR(100) NULL,
    text_de TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Character creation wizard catalog (Dragonbane rules reference data)
-- See docs/superpowers/specs/2026-09-27-character-creation-wizard-design.md

CREATE TABLE catalog_kins (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    d12_min INT NOT NULL,
    d12_max INT NOT NULL,
    movement_base INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Effects of Age (Chapter 2 - Your Player Character, "Age"): purely a display/
-- reference catalog, e.g. for the character sheet -- the actual attribute
-- modifiers and trained-skill totals used during character creation stay in
-- CharacterCreationRepository::AGE_TABLE (id column here matches that array's
-- hardcoded ids 1/2/3, since this table's rows never change).
CREATE TABLE catalog_age (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO catalog_age (id, name_de, description_de) VALUES
    (1, 'Jung', 'GEW und KON +1'),
    (2, 'Erwachsen', '—'),
    (3, 'Alt', 'STA, GEW und KON -2, INT und WIL +1');

CREATE TABLE catalog_professions (
    code VARCHAR(30) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    key_attribute_code CHAR(3) NOT NULL,
    kin_restriction VARCHAR(20) NULL,
    -- 1 = kein Start-Talent, stattdessen Magie (nur Magier; RAW-Text bestätigt).
    grants_magic BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (key_attribute_code) REFERENCES catalog_attributes(code),
    FOREIGN KEY (kin_restriction) REFERENCES catalog_kins(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_profession_key_skills (
    profession_code VARCHAR(30) NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (profession_code, skill_id),
    FOREIGN KEY (profession_code) REFERENCES catalog_professions(code),
    FOREIGN KEY (skill_id) REFERENCES catalog_skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pure heroic-ability catalog: just what the ability IS (name, requirement,
-- WP cost, description) plus whether it can be taken more than once (Robust/
-- Fokussiert). WHO grants it (a kin, a profession, or nobody -- i.e. "general",
-- freely choosable) is a separate link, not a property of the ability itself:
-- see catalog_kin_heroic_abilities / catalog_profession_heroic_abilities below.
-- An ability with no rows in either link table is a general ability. This
-- also means an ability shared by two professions (e.g. "Veteran") is stored
-- once, not duplicated per owner.
CREATE TABLE catalog_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL UNIQUE,
    requirement_de VARCHAR(100) NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    -- Kann beliebig oft gewählt werden (bisher nur Robust/Fokussiert). Alle
    -- anderen Talente sind Einmal-Talente.
    repeatable BOOLEAN NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Kin abilities are always automatic (no choice, no "granted_at_creation"
-- flag needed) -- a kin can grant more than one (e.g. Ente: 2 abilities).
CREATE TABLE catalog_kin_heroic_abilities (
    kin_code VARCHAR(20) NOT NULL,
    heroic_ability_id INT NOT NULL,
    PRIMARY KEY (kin_code, heroic_ability_id),
    FOREIGN KEY (kin_code) REFERENCES catalog_kins(code),
    FOREIGN KEY (heroic_ability_id) REFERENCES catalog_heroic_abilities(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_profession_heroic_abilities (
    profession_code VARCHAR(30) NOT NULL,
    heroic_ability_id INT NOT NULL,
    -- 1 = wird bei der Charaktererstellung automatisch vergeben (RAW: genau eine
    -- pro Beruf). 0 = zusätzliche, im Regelwerk nicht als Start-Talent gelistete
    -- Fähigkeit, die in den Pregens auftaucht (spätere Wahl beim Aufleveln).
    granted_at_creation BOOLEAN NOT NULL DEFAULT 1,
    -- NULL = einzelnes festes Talent (Standardfall). Ein gemeinsamer Wert =
    -- Wahl-Gruppe: der Spieler wählt genau eine Zeile aus allen Zeilen mit
    -- demselben choice_group (bisher nur Handwerker: Meister-Schmied/
    -- -Zimmermann/-Gerber).
    choice_group VARCHAR(50) NULL,
    PRIMARY KEY (profession_code, heroic_ability_id),
    FOREIGN KEY (profession_code) REFERENCES catalog_professions(code),
    FOREIGN KEY (heroic_ability_id) REFERENCES catalog_heroic_abilities(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_profession_gear_options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    profession_code VARCHAR(30) NOT NULL,
    option_label VARCHAR(10) NOT NULL,
    -- Freetext für Verbrauchsgüter dieser Option (Fackel, Tagesrationen etc.),
    -- die keine eigenen Katalog-Items brauchen. Das Start-Silber ist NICHT mehr
    -- Teil dieses Texts, siehe starting_silver_dice.
    extra_de VARCHAR(255) NULL,
    -- Würfel für das Start-Silber dieser Option, z.B. 'W6'/'W8'/'W10'/'W12'.
    -- Der Spieler würfelt am Tisch und trägt das Ergebnis im Wizard ein.
    starting_silver_dice VARCHAR(5) NULL,
    FOREIGN KEY (profession_code) REFERENCES catalog_professions(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_profession_gear_option_items (
    gear_option_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (gear_option_id) REFERENCES catalog_profession_gear_options(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES catalog_items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_flaws (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    name_de VARCHAR(50) NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE characters
    ADD CONSTRAINT fk_characters_kin FOREIGN KEY (kin_code) REFERENCES catalog_kins(code),
    ADD CONSTRAINT fk_characters_age FOREIGN KEY (age_id) REFERENCES catalog_age(id),
    ADD CONSTRAINT fk_characters_profession FOREIGN KEY (profession_code) REFERENCES catalog_professions(code),
    ADD CONSTRAINT fk_characters_flaw FOREIGN KEY (flaw_id) REFERENCES catalog_flaws(id);

-- D20 tables offered as inspiration during character creation (memento_de /
-- appearance_de themselves stay free text on `characters` -- these are just
-- the roll-a-die example catalogs, same shape as catalog_flaws).
CREATE TABLE catalog_mementos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_appearances (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Severe Injuries (D20): rolled on a failed CON roll after being reduced to
-- zero HP but surviving. Healing time is halved with a shift/day of medical
-- care from someone making a HEALING roll; NULL healing_de = permanent.
CREATE TABLE catalog_injuries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    name_de VARCHAR(50) NOT NULL,
    effect_de TEXT NOT NULL,
    healing_de VARCHAR(50) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- "Rolling a Demon" (natural 20) on an attack roll (D6, separate table per
-- melee/ranged). Distinct from catalog_magical_mishaps below, which is the
-- same "Demon" mechanic but for casting a spell, not attacking.
CREATE TABLE catalog_combat_mishaps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    context ENUM('melee', 'ranged') NOT NULL,
    roll INT NOT NULL,
    effect_de TEXT NOT NULL,
    UNIQUE KEY uniq_context_roll (context, roll)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- "Rolling a Demon" (natural 20) while casting a spell (D20).
CREATE TABLE catalog_magical_mishaps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll INT NOT NULL UNIQUE,
    effect_de TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Furchttabelle (W8): rolled when a WIL roll to resist a fear attack fails.
CREATE TABLE catalog_fear_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll INT NOT NULL UNIQUE,
    name_de VARCHAR(50) NOT NULL,
    effect_de TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- The three rest types (Verschnaufen/Kurze Rast/Lange Rast). Reference data,
-- not per-character state.
CREATE TABLE catalog_rest_types (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    duration_de VARCHAR(50) NOT NULL,
    effect_de TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- "Weitere Gefahren" (Further Dangers): Gift/Furcht/Dunkelheit/Kälte/
-- Sturzschaden/Schwimmen & Ertrinken. Prose rules reference, one row per topic.
CREATE TABLE catalog_hazards (
    code VARCHAR(30) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    description_de TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
