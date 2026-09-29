SET NAMES utf8mb4;

-- Ergänzt die allgemeinen Heroischen Talente aus Kapitel 3 ("Heroic
-- Abilities", S. 35-39) des vollständigen (englischen) Dragonbane-
-- Kernregelwerks, die in seed_character_creation_catalog.sql /
-- seed_wizard_expansion.sql bisher fehlten -- screenshot-transcribed aus
-- docs/bilder/ (Aufnahmen vom 2026-09-27, 09:16-09:22 Uhr).
--
-- Von den insgesamt 44 dort aufgeführten Talenten waren 15 bereits über
-- kin-/berufsgebundene Vergabe erfasst (Anpassungsfähig, Beschützer,
-- Doppelschuss, Fokussiert, Gefährte, Goldnase, Hinterhältig, Innerer
-- Frieden, Intuition, Jagdinstinkt, Meister-Gerber, Meister-Schmied,
-- Meister-Zimmermann, Musiker, Nachtragend, Robust, Schwer zu fassen,
-- Schwimmhäute, Seebeine, Übellaunig, Veteran -- s. seed_character_creation_
-- catalog.sql / seed_wizard_expansion.sql). Diese Datei fügt die restlichen
-- hinzu, allgemein (kein Eintrag in catalog_kin_heroic_abilities /
-- catalog_profession_heroic_abilities), analog zu "Robust"/"Fokussiert" --
-- jeder Charakter kann sie bei Erfüllung der Voraussetzung im Spielverlauf
-- erlernen (S. 29), keine Startvergabe.
-- "Assassine" (S. 35, Voraussetzung Messer 12, WP 3) war im gescannten
-- Ausschnitt am Seitenumbruch abgeschnitten -- Text vom Nutzer nachgereicht
-- und unten ergänzt.

INSERT INTO catalog_heroic_abilities (name_de, requirement_de, wp_note_de, description_de, repeatable) VALUES
    ('Assassine', 'Messer 12', '3', 'Dein Schleichangriff verursacht zusätzlich W8 Schaden. Dieses Talent kann mit dem Talent Hinterhältig kombiniert werden. Du aktivierst es, nachdem du auf Treffer gewürfelt hast, aber bevor du den Schaden würfelst.', 0),
    ('Schlachtruf', NULL, '3', 'Du kannst im Kampf einen Schlachtruf ausstoßen, der deine Freunde anspornt. Alle anderen Spielercharaktere in Hörweite heilen sofort einen Zustand ihrer Wahl. Dieses Talent kann nur im Kampf eingesetzt werden.', 0),
    ('Berserker', 'Beliebige Nahkampfwaffenfertigkeit 12', '3', 'Du erhältst den Zustand Wütend und greifst sofort den nächsten Gegner im Nahkampf an. Bist du bereits wütend, erhältst du stattdessen einen weiteren Zustand deiner Wahl. Anschließend musst du weiterkämpfen, bis alle Gegner in Sichtweite besiegt sind oder du 0 TP erreichst. Du erhältst einen Vorteil auf Nahkampfangriffe, kannst aber weder parieren noch ausweichen. Nach dem Kampf bist du erschöpft.', 0),
    ('Katzengleich', 'Akrobatik 12', 'unterschiedlich', 'Die Anzahl der W6, die bei Sturzschaden gewürfelt werden, sinkt für jeden dafür eingesetzten WP um eins. Du kannst zunächst eine Akrobatik-Probe ablegen und danach dieses Talent aktivieren.', 0),
    ('Schlangenmensch', 'Ausweichen 12', '1', 'Du befreist dich aus Fesseln oder zwängst dich durch einen engen Spalt, ohne dafür eine Fertigkeitsprobe abzulegen.', 0),
    ('Defensiv', 'Beliebige Nahkampfwaffenfertigkeit 12', '3', 'Du kannst versuchen, einen Angriff zu parieren, ohne dafür deine Aktion in dieser Runde zu verbrauchen. Diese Bonus-Parade kann jederzeit während der Runde eingesetzt werden, aber nur einmal gegen denselben Angriff, und du kannst nicht gleichzeitig gegen denselben Angriff ausweichen und parieren. Dieses Talent kann mehrfach pro Runde eingesetzt werden, solange du genug WP hast.', 0),
    ('Pfeilabwehr', 'Beliebige Nahkampfwaffenfertigkeit 12', '1', 'Du kannst einen Fernkampfangriff mit einer Nahkampfwaffe parieren, anstatt dafür einen Schild zu benutzen.', 0),
    ('Verkleidung', 'Täuschen 12', '2', 'Du bist ein Meister der Verkleidung und kannst mühelos das Aussehen anderer annehmen. Nach einer Weile Vorbereitung kannst du Aussehen, Stimme und Auftreten einer anderen Person annehmen. Die Person muss demselben Volk wie du angehören. Wer die Person kennt und dich aus bis zu 10 Metern Entfernung sieht, kann eine Wahrnehmungsprobe ablegen, um die Verkleidung zu durchschauen.', 0),
    ('Doppelhieb', 'Äxte oder Schwerter 12', '2', 'Mit einer Hiebwaffe kannst du zwei Gegner innerhalb von 2 Metern mit einem einzigen Schlag angreifen. Du würfelst nur einmal auf Treffer -- gelingt der Wurf, werden beide Gegner getroffen. Deine Gegner können dem Angriff jeweils einzeln ausweichen oder ihn parieren. Der Schaden wird separat gewürfelt. Dieses Talent kann mit Zweiwaffenkampf kombiniert werden.', 0),
    ('Drachentöter', 'Beliebige Waffenfertigkeit 12', '3', 'Ein Angriff gegen ein Monster (kein gewöhnlicher NSC) verursacht zusätzlich W8 Schaden. Du aktivierst dieses Talent, nachdem du auf Treffer gewürfelt hast, aber bevor du den Schaden würfelst. Mehr zu Monstern in Kapitel 7.', 0),
    ('Zweiwaffenkampf', 'Beliebige Nahkampfwaffenfertigkeit 12', '3', 'Dieses Talent kann nur eingesetzt werden, wenn du in jeder Hand eine einhändige Waffe führst. Die STÄ-Voraussetzung der Waffe in deiner Nebenhand erhöht sich um 3 (du entscheidest, ob rechts oder links). Du aktivierst dieses Talent in deinem Zug im Kampf und kannst dann einen zusätzlichen Angriff mit deiner zweiten Waffe ausführen. Du entscheidest, in welcher Reihenfolge du deine Waffen einsetzt. Schließe den ersten Angriff samt Schaden ab, bevor du den zweiten würfelst. Dieses Talent kann mit Doppelhieb kombiniert werden.', 0),
    ('Adlerauge', 'Wahrnehmung 12', '2', 'Du kannst eine Person oder ein Objekt bis zu 200 Meter entfernt in allen Details erkennen, als stündest du direkt daneben. Im Kampf kannst du damit auch ein Ziel jenseits der effektiven Reichweite deiner Waffe angreifen, indem du einen Nachteil auf deinen Wurf nimmst. Dieses Talent muss für jedes neue Ziel erneut aktiviert werden.', 0),
    ('Schnelle Füße', 'Ausweichen 12', '3', 'Du kannst versuchen, einem Angriff auszuweichen, ohne dafür deine Aktion in dieser Runde zu verbrauchen. Dieses Bonus-Ausweichen kann jederzeit während der Runde eingesetzt werden, aber nur einmal gegen denselben Angriff, und du kannst nicht gleichzeitig gegen denselben Angriff ausweichen und parieren. Dieses Talent kann mehrfach pro Runde eingesetzt werden, solange du genug WP hast.', 0),
    ('Schnelle Heilung', NULL, '2', 'Du heilst während einer kurzen Rast einen zusätzlichen W6 TP. Dieses Talent wirkt sich nicht auf WP oder Zustände aus.', 0),
    ('Menschenkenntnis', 'Überzeugen 12', '2', 'Wenn du eine Weile mit jemandem sprichst, kannst du eine Wahrnehmungsprobe ablegen, um herauszufinden, ob die Person die Wahrheit sagt. Du erfährst dabei nicht, worüber genau gelogen wird.', 0),
    ('Eiserne Faust', 'Prügelei 12', '1', 'Der Schaden eines unbewaffneten Angriffs erhöht sich um einen W6. Du kannst dieses Talent als freie Aktion aktivieren, nachdem du den Angriff gewürfelt hast.', 0),
    ('Eiserner Griff', 'Prügelei 12', '1', 'Du erhältst einen Vorteil auf deine Prügelei-Probe, wenn du versuchst, eine Person festzuhalten oder zu verhindern, dass sich ein Gegner befreit.', 0),
    ('Blitzschnell', 'Ausweichen 12', '2', 'Wenn zu Beginn einer Kampfrunde Initiativekarten gezogen werden, darfst du zwei Karten ziehen und dich für eine davon entscheiden. Du kannst dieses Talent nur einmal pro Runde aktivieren.', 0),
    ('Einzelgänger', 'Wildnisleben 12', NULL, 'Du kannst in der Wildnis eine kurze Rast einlegen, ohne zuvor eine Wildnisleben-Probe für das Lagermachen abzulegen. Der Effekt gilt nur für dich, selbst wenn du ein Zelt hast.', 0),
    ('Magisches Talent', NULL, NULL, 'Du hast eine Begabung für Magie und kannst eine neue Zauberschule erlernen (unabhängig davon, ob du bereits eine beherrschst). Zaubersprüche müssen separat erlernt werden. Dieses Talent kann mehrfach gewählt werden -- einmal für jede neue Schule, die du erlernen willst.', 1),
    ('Wuchtschlag', 'Beliebige STÄ-basierte Nahkampfwaffenfertigkeit 12', '3', 'Ein Schlag mit einer zweihändigen Nahkampfwaffe verursacht zusätzlich W8 Schaden, aber du kannst dich in derselben Runde nicht bewegen. Du kannst dieses Talent nach dem Wurf auf Treffer aktivieren, jedoch nicht, wenn du dich bewegt hast.', 0),
    ('Meisterkoch', NULL, '1', 'Dir gelingt das Kochen von Essen automatisch, ohne eine Wildnisleben-Probe abzulegen.', 0),
    ('Meister-Zauberer', 'Beliebige Zauberschule 12', '3', 'Wenn du dieses Talent in deinem Zug im Kampf aktivierst, kannst du zwei verschiedene Zaubersprüche als eine einzige Aktion wirken. Es müssen zwei unterschiedliche Zauber sein. Wirf zuerst für den ersten Zauber und aktiviere dann dieses Talent.', 0),
    ('Monsterjäger', 'Bestienkunde 12', '3', 'An einer Weggabelung kannst du dieses Talent aktivieren, um die Richtung der gefährlichsten Feinde in Erfahrung zu bringen.', 0),
    ('Pfadfinder', 'Wildnisleben 12', '1', 'Du erhältst einen Vorteil auf deine Wildnisleben-Probe, wenn du versuchst, in der Wildnis die richtige Richtung zu finden.', 0),
    ('Quartiermeister', 'Wildnisleben 12', '1', 'Du bist gut darin, geeignete Lagerplätze zu finden. Das Lagermachen auf Reisen gelingt dir automatisch.', 0),
    ('Schildblock', 'Beliebige STÄ-basierte Nahkampfwaffenfertigkeit 12', '2', 'Du kannst dieses Talent aktivieren, wenn du mit einem Schild parierst, um mit einem Vorteil zu würfeln. Damit kannst du auch körperliche Monsterangriffe (keine Flächenangriffe) parieren, die normalerweise nicht pariert werden können; dafür benötigst du einen Schild und erhältst einen Vorteil auf den Wurf. Dieses Talent kann mit Defensiv kombiniert werden.', 0),
    ('Wurfarm', 'Beliebige Nahkampfwaffenfertigkeit 12', '2', 'Du kannst eine Nahkampfwaffe mit enormer Wucht auf einen Gegner in einer Entfernung von bis zu deinem STÄ-Wert in Metern werfen. Es muss eine einhändige Waffe sein. Würfle den Angriff wie gewohnt. Der Gegner kann dem Angriff wie üblich ausweichen oder ihn parieren. Die Waffe landet dem Gegner vor die Füße.', 0),
    ('Wiesel', 'Ausweichen 12', '3', 'Wirst du angegriffen und befindet sich ein anderer Spielercharakter innerhalb von 2 Metern, kannst du dieses Talent aktivieren, damit der Angriff stattdessen diesen Charakter trifft. Dieses Talent wirkt nicht gegen Flächenangriffe, und du musst es aktivieren, bevor du versuchst auszuweichen oder zu parieren. Das neue Ziel darf ganz normal versuchen auszuweichen oder zu parieren.', 0);
