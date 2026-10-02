SET NAMES utf8mb4;

-- 1. NPCs bekommen ein Volk (kin) und ein eigenes Portrait. Das Volk gehört
--    zum NPC, nicht zur Bestiary-Vorlage: "Bürger" gilt für jedes Volk, ob
--    Mensch, Elf, Zwerg oder Ente. Einträge bleiben leer, bis der DM sie setzt.

ALTER TABLE catalog_npcs
    ADD COLUMN kin_code VARCHAR(20) NULL AFTER status_de,
    ADD COLUMN portrait_path VARCHAR(255) NULL,
    ADD CONSTRAINT fk_npcs_kin FOREIGN KEY (kin_code) REFERENCES catalog_kins(code) ON DELETE SET NULL;

-- 2. Die Dame des Hügels ist ein normaler Geist: Sie verweist auf die
--    allgemeine Geist-Vorlage. Ihr bisheriger eigener Werteblock entfällt, ihr
--    Portrait (images/creatures/<alte Bestiary-Id>.jpg) hängt danach am NPC.
--    Dieselben Anweisungen stehen am Ende von seed_bestiary.sql für frische
--    Installationen.

SET @dame_bestiary_id = (SELECT id FROM catalog_bestiary WHERE name_de = 'Die Dame des Hügels');
SET @geist_id = (SELECT id FROM catalog_bestiary WHERE name_de = 'Geist');

UPDATE catalog_npcs
SET bestiary_id = @geist_id,
    portrait_path = CONCAT('images/creatures/', @dame_bestiary_id, '.jpg')
WHERE name_de = 'Die Dame des Hügels';

DELETE FROM catalog_bestiary WHERE id = @dame_bestiary_id;
