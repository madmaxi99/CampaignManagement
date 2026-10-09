-- skip-if: SELECT COUNT(*) FROM catalog_bestiary WHERE id = 52 AND name_de = 'Jaldo'
-- abort-if: SELECT COUNT(*) FROM catalog_bestiary WHERE id BETWEEN 41 AND 55
-- abort-if: SELECT COUNT(*) FROM catalog_bestiary_attacks WHERE id BETWEEN 111 AND 116
-- abort-if: SELECT COUNT(*) FROM catalog_encounter_tables WHERE id = 4
-- abort-if: SELECT COUNT(*) FROM catalog_encounter_table_entries WHERE id BETWEEN 17 AND 22

-- Typische NSC und die Figuren der Burg des Raubritters
INSERT INTO catalog_bestiary (id, name_de, category_de, is_unique, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de, image_path) VALUES
    (41, 'Wache', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, 'Beschlagenes Leder (2)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 10, Schwerter 12 · Schadensbonus STÄ +W4', 'Breitschwert, beschlagenes Leder', NULL),
    (42, 'Kultist', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Ausweichen 14, Messer 14 · Schadensbonus GEW +W4', 'Dolch', NULL),
    (43, 'Dieb', 'Alltagsvolk', 0, 10, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Ausweichen 12, Messer 12 · Schadensbonus GEW +W4', 'Messer', NULL),
    (44, 'Dorfbewohner', 'Alltagsvolk', 0, 8, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Prügelei 8', 'Holzknüppel', NULL),
    (45, 'Jäger', 'Alltagsvolk', 0, 13, '—', 'Normal', 10, 'Lederrüstung (1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 12, Bögen 13 · Schadensbonus GEW +W4', 'Langbogen, Lederrüstung', NULL),
    (46, 'Bandit', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Bögen 12, Ausweichen 10, Schwerter 12', 'Kurzschwert, Kurzbogen', NULL),
    (47, 'Abenteurer', 'Alltagsvolk', 0, 13, '—', 'Normal', 10, 'Beschlagenes Leder (2)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 10, Schwerter 12 · Schadensbonus STÄ +W4', 'Breitschwert, beschlagenes Leder', NULL),
    (48, 'Gelehrter', 'Alltagsvolk', 0, 7, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Fremdsprachen 13, Mythen & Legenden 13, Stäbe 8', 'Ein gutes Buch', NULL),
    (49, 'Banditenanführer', 'Alltagsvolk', 0, 30, '—', 'Normal', 10, 'Kettenpanzer, offener Helm', NULL, NULL, 'Boss: zieht eine eigene Initiativkarte und hat WP sowie Heldentalente.
Fertigkeiten: Wahrnehmung 12, Prügelei 15, Hämmer 15 · WP: 16 · Schadensbonus STÄ +W6
Heldentalente: Berserker, Robust ×6, Veteran', 'Schwerer Kriegshammer, Kettenpanzer, offener Helm', NULL),
    (50, 'Ritter-Champion', 'Alltagsvolk', 0, 28, '—', 'Normal', 10, 'Plattenpanzer, Großhelm', NULL, NULL, 'Boss: zieht eine eigene Initiativkarte und hat WP sowie Heldentalente.
Fertigkeiten: Prügelei 14, Schwerter 16 · WP: 26 · Schadensbonus STÄ +W6
Heldentalente: Defensiv, Doppelhieb, Fokussiert ×6, Robust ×6', 'Langschwert, großer Schild, Plattenpanzer, Großhelm, kampfgeschultes Pferd', NULL),
    (51, 'Erzmagier', 'Alltagsvolk', 0, 22, '—', 'Normal', 10, '—', NULL, NULL, 'Boss: zieht eine eigene Initiativkarte und hat WP sowie Heldentalente.
Fertigkeiten: Zauberschule 15, Stäbe 13 · WP: 30
Heldentalente: Fokussiert ×6, Meister-Zauberer, Robust ×4', 'Stab, Grimoire', NULL),
    (52, 'Jaldo', 'Humanoid', 1, 10, '—', 'Klein', 10, 'Beschlagenes Leder (2), offener Helm (+1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 12, Ausweichen 10, Heimlichkeit 12 · Schadensbonus —', 'Krummsäbel (Fertigkeitswert 12, Schaden 2W6)', NULL),
    (53, 'Grunta', 'Humanoid', 1, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 14, Ausweichen 10 · Schadensbonus STÄ +W4', 'Kleine Holzkeule (Fertigkeitswert 12, Schaden W8)', NULL),
    (54, 'Goblin – Burgplünderer', 'Humanoid', 0, 9, '—', 'Klein', 10, 'Lederrüstung (1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12 · Schadensbonus —', 'Kurzbogen (Fertigkeitswert 12, Schaden W10), Kurzschwert (Fertigkeitswert 10, Schaden W10)', NULL),
    (55, 'Der Raubritter', 'Untot', 1, 38, 'Zahl der SC − 1', 'Normal', 10, '8', 'Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden.', NULL, 'Ein Wiedergänger, der wie ein Monster behandelt wird. Er steht nach etwa einem Tagesabschnitt (rund sechs Stunden) wieder auf, wenn er im Kampf besiegt wird.', 'Morgenstern (Wuchtschaden 2W8)', NULL);


-- Angriffstabelle des Raubritters
INSERT INTO catalog_bestiary_attacks (id, bestiary_id, roll_de, title_de, effect_de) VALUES
    (111, 55, '1', 'Unheiliges Gebrüll!', 'Ein grauenhafter Schrei dringt aus dem kopflosen Hals des Wiedergängers und schneidet wie eine rostige Klinge durch die Seelen der Charaktere. Alle innerhalb von 10 Metern erleiden einen Furchtangriff.'),
    (112, 55, '2', 'Grauenvolle Drohungen!', 'Der Wiedergänger wendet sich einem unglücklichen Charakter innerhalb von 10 Metern zu und flüstert grässliche Drohungen aus seiner Kehle. Das Opfer wird Verängstigt, erleidet einen Furchtangriff und hat einen Nachteil auf seine WIL-Probe.'),
    (113, 55, '3', 'Hand der Toten!', 'Der Wiedergänger hebt die Hand und deutet auf einen Charakter innerhalb von 10 Metern. Dieser wird 2W4 Meter weit geschleudert und landet am Boden. Der Angriff verursacht Wuchtschaden in Höhe der Zahl der geschleuderten Meter und kann nicht ausgewichen werden.'),
    (114, 55, '4', 'Fegender Angriff!', 'Mit überraschender Geschwindigkeit führt der Wiedergänger seinen Morgenstern in einem tödlichen Hieb. Alle Charaktere innerhalb von 2 Metern erleiden 2W8 Wuchtschaden. Der Angriff kann pariert werden.'),
    (115, 55, '5', 'Lähmende Kälte!', 'Der Wiedergänger packt einen unglücklichen Charakter, der die Kälte des Todes durch seinen Körper strömen spürt. Das Opfer erleidet W6 Schaden (Rüstung hat keine Wirkung) und muss in seinem nächsten Zug eine Ausweichen-Probe ablegen (keine Aktion), um überhaupt handeln zu können. Misslingt sie, darf im nächsten Zug ein neuer Versuch unternommen werden. Das Opfer ist außerdem unterkühlt und kann bis zum Aufwärmen weder TP noch WP heilen.'),
    (116, 55, '6', 'Mächtiger Angriff!', 'Mit knarrenden Gelenken schwingt der Wiedergänger den Morgenstern in einem kraftvollen Angriff gegen einen Charakter. Das Opfer erleidet 4W8 Wuchtschaden und wird zu Boden geworfen. Der Angriff kann pariert werden.');


-- Zufällige Ereignisse der Burg des Raubritters (W6, pro Viertel in der Burg)
INSERT INTO catalog_encounter_tables (id, name_de) VALUES
    (4, 'Zufällige Ereignisse: Burg des Raubritters');

INSERT INTO catalog_encounter_table_entries (id, table_id, min_roll, max_roll, bestiary_id, quantity_de, text_de) VALUES
    (17, 4, 1, 1, 54, '2', 'Goblins. Zwei Goblins tauchen auf, ziehen nach kurzer Verwirrung ihre Kurzschwerter und greifen mit einem Kreischen an.'),
    (18, 4, 2, 2, NULL, NULL, 'Wühlendes Schwein. Merle grunzt zufrieden in einer Ecke. Bemerkt sie die Charaktere, erstarrt sie, quiekt und flüchtet. Wer sie verletzt, macht sich die Orkin Grunta zur Feindin.'),
    (19, 4, 3, 3, NULL, NULL, 'Böse Geister. Die Luft vibriert, ein kalter Wirbelwind kreist, die Umrisse dreier toter Krieger greifen nach den Charakteren. Alle: WIL-Probe gegen Furcht, dann verschwinden die Geister.'),
    (20, 4, 4, 4, NULL, NULL, 'Sturm. Dunkle Wolken ziehen auf, es regnet in Strömen und donnert. Für den Rest des Abenteuers erhalten alle Fernkampfangriffe im Freien einen Nachteil.'),
    (21, 4, 5, 5, NULL, NULL, 'Raben. Ein Schwarm bricht aus einer Spalte hervor und stürzt auf die Charaktere zu. Alle: Ausweichen-Probe; wer scheitert, erleidet W3 Stichschaden. Dann fliegt der Schwarm zum Turm.'),
    (22, 4, 6, 6, NULL, NULL, 'Falle! Die Goblins haben einen aufgehängten Kriegshammer aufgestellt, der auslöst, wenn der Charakter mit der niedrigsten GEW auf einen losen Stein tritt. Ausweichen-Probe, sonst 2W6 Wuchtschaden.');
