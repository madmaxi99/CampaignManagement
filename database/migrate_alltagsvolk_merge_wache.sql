SET NAMES utf8mb4;

-- Die Wache entfällt: Wachen, Leibwächter und Söldner sind Kämpfer.

UPDATE catalog_bestiary
SET traits_de = 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Auch für Stadtwache, Leibwächter und Söldner: Für einen Wachtrupp nimm drei Kämpfer.
Trupp: Drei Kämpfer sind für drei Spielercharaktere leicht fordernd, für Nicht-Kämpfer spürbar (meist geht jemand zu Boden). Jeder weitere Kämpfer macht den Kampf deutlich härter.'
WHERE name_de = 'Kämpfer' AND category_de = 'Alltagsvolk';

DELETE FROM catalog_bestiary WHERE name_de = 'Wache' AND category_de = 'Alltagsvolk';
