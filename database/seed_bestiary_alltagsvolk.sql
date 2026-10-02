SET NAMES utf8mb4;

-- Alltagsvolk: drei volksneutrale Stufen nach Kampfkraft, nicht nach Beruf
-- (siehe docs/CONCEPT.md, Abschnitt Bestiary). Der Beruf (Bäckerin, Stadtwache,
-- Räuber ...) und das Volk (Mensch, Elf, Zwerg, Ente ...) stehen beim NPC,
-- diese Vorlagen liefern nur die Kampfwerte. Bewegung 10 gilt für Menschen und
-- Elfen, Zwerge/Halblinge/Enten haben 8, Wolfsmenschen 12.
--
-- Die TP orientieren sich an den Spielercharakteren (vorgefertigte SC haben
-- 11-17 TP): Zivilist wie ein Händler, Zauberkundiger wie ein Magier, Kämpfer
-- wie ein Kämpfer-SC. Angriffswerte stammen aus einer Simulation gegen die
-- vorgefertigten Charaktere (Trupp aus 3 gegen 3 SC): Kämpfer sind für
-- Nicht-Kämpfer leicht fordernd. Nicht eingerechnet sind Talente der Spieler.
-- Es gibt keine eigene Wache: Stadtwache, Leibwächter und Söldner sind Kämpfer.

SET @alltag_traits = 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.';

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Zivilist', 'Alltagsvolk', 12, '—', 'Normal', 10, '—', NULL, NULL,
     CONCAT(@alltag_traits, '
Ein Kampf mit Zivilisten ist eine Schlägerei und endet meist nach 3 Runden.'),
     'Typische Waffe: Knüppel oder Messer (Fertigkeitswert 8, Schaden W6)'),
    ('Kämpfer', 'Alltagsvolk', 15, '—', 'Normal', 10, 'Lederrüstung (1)', NULL, NULL,
     CONCAT(@alltag_traits, '
Auch für Stadtwache, Leibwächter und Söldner: Für einen Wachtrupp nimm drei Kämpfer.
Trupp: Drei Kämpfer sind für drei Spielercharaktere leicht fordernd, für Nicht-Kämpfer spürbar (meist geht jemand zu Boden). Jeder weitere Kämpfer macht den Kampf deutlich härter.'),
     'Typische Waffe: Kurzschwert, Keule oder Kurzbogen (Fertigkeitswert 10, Schaden W8)'),
    ('Zauberkundiger', 'Alltagsvolk', 11, '—', 'Normal', 10, '—', NULL, NULL,
     CONCAT(@alltag_traits, '
Im Trupp zählt ein Zauberkundiger ungefähr wie ein Kämpfer. Allein ist er harmlos.'),
     'Fertigkeiten: Zauberschule 12 · WP: 8
Zauber: Feuerball oder Blitzschlag (je 2 WP, 2W6 Schaden), danach Stab
Typische Waffe: Stab (Fertigkeitswert 8, Schaden W6)');
