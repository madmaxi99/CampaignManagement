SET NAMES utf8mb4;

-- "Aktueller Stand" (Spieler-Seite pro Kampagne, siehe docs/CONCEPT.md).
-- Alles hier gehört zu genau einer Kampagne und wird mit "Spielstand
-- zurücksetzen" geleert.

-- 1. Was die Gruppe kennt: NPCs über eine Spalte, Orte über eine eigene Tabelle.
ALTER TABLE campaign_npcs ADD COLUMN known_at DATETIME NULL;

CREATE TABLE campaign_known_places (
    campaign_id INT NOT NULL,
    location_id INT NOT NULL,
    known_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (campaign_id, location_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES catalog_locations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Chronik: drei bis fünf Sätze pro Session, neuester Eintrag oben.
CREATE TABLE campaign_chronicle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    title_de VARCHAR(100) NULL,
    text_de TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Offene Fäden: ungelöste Fragen der Gruppe.
CREATE TABLE campaign_threads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    text_de VARCHAR(255) NOT NULL,
    resolved_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
