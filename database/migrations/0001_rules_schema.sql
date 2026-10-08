-- skip-if: SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'catalog_roll_tables'
-- Schema: Gewicht für die Traglast, allgemeine Wurftabellen, Dienste.

ALTER TABLE catalog_items
    ADD COLUMN weight DECIMAL(4,2) NOT NULL DEFAULT 1 AFTER kind;

-- Allgemeine Wurftabellen des Regelwerks (Reise-Missgeschicke, Jagd, improvisierte
-- Waffen, Schätze, NSC erschaffen ...). Die App würfelt nie: die Tabellen werden
-- nur angezeigt, gewürfelt wird am Tisch. group_de gruppiert in /rules, die
-- Spaltenköpfe stehen in headers_de ("Name|Wirkung|Wert", Trenner "|").
CREATE TABLE IF NOT EXISTS catalog_roll_tables (
    code VARCHAR(40) PRIMARY KEY,
    group_de VARCHAR(50) NOT NULL,
    title_de VARCHAR(100) NOT NULL,
    die_de VARCHAR(10) NOT NULL,
    headers_de VARCHAR(150) NOT NULL,
    intro_de TEXT NULL,
    display_order INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS catalog_roll_table_rows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_code VARCHAR(40) NOT NULL,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    name_de VARCHAR(100) NOT NULL,
    effect_de TEXT NULL,
    extra_de VARCHAR(100) NULL,
    FOREIGN KEY (table_code) REFERENCES catalog_roll_tables(code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dienstleistungen (Bad, Unterkunft, Leibwächter ...). Eigene Tabelle, weil es
-- keine Gegenstände sind. unit_de: Einheit des Preises ("pro Tag", "pro Kilometer").
CREATE TABLE IF NOT EXISTS catalog_services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL UNIQUE,
    rarity ENUM('gewöhnlich', 'ungewöhnlich', 'selten', 'episch', 'legendär', 'einzigartig') NOT NULL DEFAULT 'gewöhnlich',
    price_gold INT NOT NULL DEFAULT 0,
    price_silver INT NOT NULL DEFAULT 0,
    price_copper INT NOT NULL DEFAULT 0,
    unit_de VARCHAR(50) NULL,
    effect_de TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

