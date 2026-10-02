SET NAMES utf8mb4;

-- Einzigartige Wesen sind NPCs (docs/CONCEPT.md, Abschnitt Bestiary). Ihre
-- Kampfwerte bleiben als Werteblock im Bestiary (Portrait, Angriffstabelle
-- und Abenteuer-Anpassungen hängen daran), der NPC verweist darauf.
-- Betrifft: Die Dame des Hügels, Der Gruftschrecken von Ridderhöhe, Krakul.
-- Einmalig auszuführen, nach migrate_world_model.sql.

INSERT INTO catalog_npcs (name_de, is_important, status_de, bestiary_id)
SELECT name_de, 1, 'untot', id
FROM catalog_bestiary
WHERE name_de IN ('Die Dame des Hügels', 'Der Gruftschrecken von Ridderhöhe');

INSERT INTO catalog_npcs (name_de, is_important, status_de, role_de, secret_de, bestiary_id)
SELECT name_de, 1, 'lebt', 'Lindwurm', 'In Menschengestalt tritt Krakul als „Der Einäugige“ auf.', id
FROM catalog_bestiary
WHERE name_de = 'Krakul';

-- In der Kampagne tauchen sie jetzt unter den NPCs auf, nicht mehr im Bestiary.
INSERT INTO campaign_npcs (campaign_id, npc_id)
SELECT cb.campaign_id, n.id
FROM campaign_bestiary cb
JOIN catalog_npcs n ON n.bestiary_id = cb.bestiary_id
WHERE n.name_de IN ('Die Dame des Hügels', 'Der Gruftschrecken von Ridderhöhe', 'Krakul');

DELETE FROM campaign_bestiary
WHERE bestiary_id IN (
    SELECT bestiary_id FROM catalog_npcs
    WHERE name_de IN ('Die Dame des Hügels', 'Der Gruftschrecken von Ridderhöhe', 'Krakul')
);
