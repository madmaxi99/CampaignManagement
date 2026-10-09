-- skip-if: SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'campaigns' AND column_name = 'current_chapter_id'
-- Aktuelles Kapitel und Ort der Gruppe einer Kampagne (Spielen-Ansicht).
ALTER TABLE campaigns
    ADD COLUMN current_chapter_id INT NULL,
    ADD COLUMN current_place_id INT NULL,
    ADD CONSTRAINT fk_campaign_current_chapter FOREIGN KEY (current_chapter_id) REFERENCES campaign_chapters(id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_campaign_current_place FOREIGN KEY (current_place_id) REFERENCES campaign_places(id) ON DELETE SET NULL;
