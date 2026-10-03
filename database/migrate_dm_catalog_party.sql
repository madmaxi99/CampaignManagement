-- Teilprojekte 2 und 4: Gedächtnis, Bestiary-Bild, DM-Gruppe. Idempotent.
ALTER TABLE characters ADD COLUMN IF NOT EXISTS memory_de TEXT NULL;
ALTER TABLE catalog_bestiary ADD COLUMN IF NOT EXISTS image_path VARCHAR(255) NULL;

CREATE TABLE IF NOT EXISTS dm_party (
    character_id INT PRIMARY KEY,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
