-- Gegner des aktuellen Kampfes einer Kampagne (Übersicht im Reiter Gruppe).
CREATE TABLE IF NOT EXISTS campaign_foes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_id INT NOT NULL,
    bestiary_id INT NOT NULL,
    hp_current INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (bestiary_id) REFERENCES catalog_bestiary(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
