SET NAMES utf8mb4;

-- Die TP der Alltagsvolk-Vorlagen orientieren sich jetzt an den
-- Spielercharakteren (vorgefertigte SC haben 11-17 TP), damit Schleichangriffe
-- und Zauber sie nicht in einem Schlag ausschalten. Die Angriffswerte sind neu
-- gegen die vorgefertigten Charaktere nachgerechnet (Trupp aus 3).

UPDATE catalog_bestiary SET hp = 12 WHERE name_de = 'Zivilist' AND category_de = 'Alltagsvolk';
UPDATE catalog_bestiary SET hp = 15,
    traits_de = REPLACE(traits_de, ' Jeder weitere Kämpfer macht den Kampf deutlich härter, vier bis fünf sind für Nicht-Kämpfer tödlich.', ' Jeder weitere Kämpfer macht den Kampf deutlich härter.')
WHERE name_de = 'Kämpfer' AND category_de = 'Alltagsvolk';
UPDATE catalog_bestiary SET hp = 18,
    kit_de = 'Typische Waffe: Schwert oder Speer (Fertigkeitswert 12, Schaden W8)'
WHERE name_de = 'Wache' AND category_de = 'Alltagsvolk';
UPDATE catalog_bestiary SET hp = 11 WHERE name_de = 'Zauberkundiger' AND category_de = 'Alltagsvolk';
UPDATE catalog_bestiary SET traits_de = REPLACE(traits_de, 'endet meist nach 2-3 Runden.', 'endet meist nach 3 Runden.')
WHERE name_de = 'Zivilist' AND category_de = 'Alltagsvolk';
