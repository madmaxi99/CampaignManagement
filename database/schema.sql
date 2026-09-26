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
    misc_items_de VARCHAR(255) NOT NULL,
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

CREATE TABLE character_weapons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_armor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE character_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    position INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id)
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
