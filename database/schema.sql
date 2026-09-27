SET NAMES utf8mb4;

-- Catalogs

CREATE TABLE attributes (
    code CHAR(3) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE conditions (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    attribute_code CHAR(3) NOT NULL,
    FOREIGN KEY (attribute_code) REFERENCES attributes(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL UNIQUE,
    attribute_code CHAR(3) NOT NULL,
    category ENUM('regular', 'combat', 'secondary') NOT NULL,
    description_de TEXT NULL,
    FOREIGN KEY (attribute_code) REFERENCES attributes(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE spells (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL,
    type ENUM('trick', 'spell') NOT NULL,
    school_skill_id INT NULL,
    components_de VARCHAR(255) NULL,
    casting_time_de VARCHAR(100) NULL,
    range_de VARCHAR(100) NULL,
    duration_de VARCHAR(100) NULL,
    wp_note_de VARCHAR(100) NULL,
    effect_de TEXT NOT NULL,
    FOREIGN KEY (school_skill_id) REFERENCES skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Item catalog (for loot drops / shops, populated incrementally)

CREATE TABLE items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    description_de TEXT NOT NULL,
    rarity ENUM('gewöhnlich', 'ungewöhnlich', 'selten', 'episch', 'legendär') NOT NULL DEFAULT 'gewöhnlich',
    price_copper INT NOT NULL DEFAULT 0,
    kind ENUM('weapon', 'armor', 'misc') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE item_weapons (
    item_id INT PRIMARY KEY,
    grip_de VARCHAR(50) NOT NULL,
    range_de VARCHAR(50) NOT NULL,
    damage_de VARCHAR(50) NOT NULL,
    durability INT NOT NULL,
    traits_de VARCHAR(100) NULL,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE item_armor (
    item_id INT PRIMARY KEY,
    slot ENUM('body', 'head') NOT NULL,
    armor_value INT NOT NULL,
    penalty_skills_de VARCHAR(255) NULL,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE item_misc (
    item_id INT PRIMARY KEY,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Characters

CREATE TABLE characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(100) NOT NULL UNIQUE,
    is_default BOOLEAN NOT NULL DEFAULT 0,
    name_de VARCHAR(100) NOT NULL,
    kin_de VARCHAR(100) NOT NULL,
    age_de VARCHAR(50) NOT NULL,
    profession_de VARCHAR(100) NOT NULL,
    flaw_de TEXT NOT NULL,
    appearance_de TEXT NOT NULL,
    memento_de TEXT NOT NULL,
    movement INT NOT NULL,
    damage_bonus_sta_de VARCHAR(20) NOT NULL DEFAULT '—',
    damage_bonus_gew_de VARCHAR(20) NOT NULL DEFAULT '—',
    carrying_capacity INT NOT NULL,
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
    FOREIGN KEY (attribute_code) REFERENCES attributes(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_conditions (
    character_id INT NOT NULL,
    condition_code VARCHAR(20) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (character_id, condition_code),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (condition_code) REFERENCES conditions(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_skills (
    character_id INT NOT NULL,
    skill_id INT NOT NULL,
    value INT NOT NULL,
    marked_for_advancement BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (character_id, skill_id),
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id)
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
    FOREIGN KEY (spell_id) REFERENCES spells(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Waffen/Rüstung/Inventar sind Freitext: bei der Charaktererstellung werden
-- Katalog-Items (items/item_weapons/item_armor) einmalig als Text übernommen,
-- danach ist alles frei editierbar ohne weiteren Katalog-Bezug.
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
CREATE TABLE character_armor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    slot ENUM('head', 'body') NOT NULL,
    name_de VARCHAR(150) NULL,
    armor_value INT NULL,
    penalty_de VARCHAR(255) NULL,
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

-- Campaigns (DM screens)

CREATE TABLE campaigns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(100) NOT NULL UNIQUE,
    is_default BOOLEAN NOT NULL DEFAULT 0,
    name_de VARCHAR(150) NOT NULL,
    teaser_de VARCHAR(255) NOT NULL,
    background_de TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_chapters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    position INT NOT NULL,
    title_de VARCHAR(150) NOT NULL,
    notes_de TEXT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    chapter_id INT NULL,
    position INT NOT NULL,
    number_label VARCHAR(10) NOT NULL,
    name_de VARCHAR(150) NOT NULL,
    read_aloud_de TEXT NULL,
    notes_de TEXT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES campaign_chapters(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Bestiary & NPC catalogs (reusable across campaigns, like `items`)

CREATE TABLE creatures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    hp INT NOT NULL,
    grimmigkeit_de VARCHAR(20) NOT NULL,
    size_de VARCHAR(50) NOT NULL,
    movement INT NOT NULL,
    armor_de VARCHAR(20) NOT NULL DEFAULT '—',
    resistances_de TEXT NULL,
    immunities_de TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE creature_attacks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    creature_id INT NOT NULL,
    roll_de VARCHAR(10) NOT NULL,
    title_de VARCHAR(100) NOT NULL,
    effect_de TEXT NOT NULL,
    FOREIGN KEY (creature_id) REFERENCES creatures(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_creature_links (
    campaign_id INT NOT NULL,
    creature_id INT NOT NULL,
    PRIMARY KEY (campaign_id, creature_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (creature_id) REFERENCES creatures(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE npcs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(150) NOT NULL,
    role_de VARCHAR(150) NOT NULL,
    description_de TEXT NOT NULL,
    motivation_de TEXT NULL,
    stats_de TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_npc_links (
    campaign_id INT NOT NULL,
    npc_id INT NOT NULL,
    PRIMARY KEY (campaign_id, npc_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (npc_id) REFERENCES npcs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_event_tables (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    position INT NOT NULL,
    name_de VARCHAR(150) NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE campaign_event_table_entries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_id INT NOT NULL,
    min_roll INT NOT NULL,
    max_roll INT NULL,
    text_de TEXT NOT NULL,
    FOREIGN KEY (table_id) REFERENCES campaign_event_tables(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Character creation wizard catalog (Dragonbane rules reference data)
-- See docs/superpowers/specs/2026-09-27-character-creation-wizard-design.md

CREATE TABLE kins (
    code VARCHAR(20) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    d12_min INT NOT NULL,
    d12_max INT NOT NULL,
    movement_base INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE kin_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kin_code VARCHAR(20) NOT NULL,
    name_de VARCHAR(100) NOT NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (kin_code) REFERENCES kins(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE professions (
    code VARCHAR(30) PRIMARY KEY,
    name_de VARCHAR(50) NOT NULL,
    key_attribute_code CHAR(3) NOT NULL,
    kin_restriction VARCHAR(20) NULL,
    -- 1 = kein Start-Talent, stattdessen Magie (nur Magier; RAW-Text bestätigt).
    grants_magic BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (key_attribute_code) REFERENCES attributes(code),
    FOREIGN KEY (kin_restriction) REFERENCES kins(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE profession_key_skills (
    profession_code VARCHAR(30) NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (profession_code, skill_id),
    FOREIGN KEY (profession_code) REFERENCES professions(code),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE profession_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    profession_code VARCHAR(30) NOT NULL,
    -- 1 = wird bei der Charaktererstellung automatisch vergeben (RAW: genau eine
    -- pro Beruf). 0 = zusätzliche, im Regelwerk nicht als Start-Talent gelistete
    -- Fähigkeit, die in den Pregens auftaucht (spätere Wahl beim Aufleveln).
    granted_at_creation BOOLEAN NOT NULL DEFAULT 1,
    name_de VARCHAR(100) NOT NULL,
    requirement_de VARCHAR(100) NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    -- NULL = einzelnes festes Talent (Standardfall). Ein gemeinsamer Wert =
    -- Wahl-Gruppe: der Spieler wählt genau eine Zeile aus allen Zeilen mit
    -- demselben choice_group (bisher nur Handwerker: Meister-Schmied/
    -- -Zimmermann/-Gerber).
    choice_group VARCHAR(50) NULL,
    FOREIGN KEY (profession_code) REFERENCES professions(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Heroic abilities selectable regardless of profession (e.g. Robust, Fokussiert)
CREATE TABLE general_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL,
    requirement_de VARCHAR(100) NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE profession_gear_options (
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
    FOREIGN KEY (profession_code) REFERENCES professions(code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE profession_gear_option_items (
    gear_option_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (gear_option_id) REFERENCES profession_gear_options(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE flaws (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    name_de VARCHAR(50) NOT NULL,
    description_de VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
