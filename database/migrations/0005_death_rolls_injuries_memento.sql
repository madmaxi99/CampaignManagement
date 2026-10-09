-- skip-if: SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'characters' AND column_name = 'memento_used'
-- Todeswürfe, Verletzungen am Charakter und "Memento benutzt".

ALTER TABLE characters
    ADD COLUMN death_successes TINYINT NOT NULL DEFAULT 0 AFTER wp_current,
    ADD COLUMN death_failures TINYINT NOT NULL DEFAULT 0 AFTER death_successes,
    ADD COLUMN memento_used BOOLEAN NOT NULL DEFAULT 0 AFTER death_failures;

CREATE TABLE IF NOT EXISTS character_injuries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id INT NOT NULL,
    injury_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES characters(id) ON DELETE CASCADE,
    FOREIGN KEY (injury_id) REFERENCES catalog_injuries(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
