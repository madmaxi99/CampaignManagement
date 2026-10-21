-- skip-if: SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'catalog_merchant_quirks'

-- Macken der Ladenbesitzer (W20), nur für die Spielleitung.
CREATE TABLE catalog_merchant_quirks (
    roll TINYINT PRIMARY KEY,
    text_de VARCHAR(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
