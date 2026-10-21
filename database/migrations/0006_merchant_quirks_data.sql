-- skip-if: SELECT COUNT(*) FROM catalog_merchant_quirks
SET NAMES utf8mb4;

-- Macken der Ladenbesitzer (W20), nur für die Spielleitung.
INSERT INTO catalog_merchant_quirks (roll, text_de) VALUES
    (1, 'Jammert ununterbrochen über sein Wetterleiden. Jede Ware ist "gut gegen Gliederreißen".'),
    (2, 'Spricht mit einem ausgestopften Tier im Regal wie mit einem Geschäftspartner ("Mein Teilhaber findet das zu billig").'),
    (3, 'Kann sich keine Namen merken und nennt alle Kunden "Meister", auch die Frauen.'),
    (4, 'Feilscht aus Leidenschaft und ist beleidigt, wenn niemand handelt. Am Ende gilt trotzdem der Preis aus der Liste.'),
    (5, 'Übertreibt jede Ware maßlos ("Mit dieser Klinge wurden schon drei Könige gerettet, und vier ermordet").'),
    (6, 'Flüstert alles, als wäre es verboten, auch den Preis für Brot.'),
    (7, 'Streng gläubig: segnet jede Ware vor dem Verkauf und verkauft am Ruhetag gar nichts.'),
    (8, 'Zeigt jedem seinen Meisterbrief der Zunft und erwartet Bewunderung.'),
    (9, 'Früherer Söldner mit Kriegsgeschichten für jede Gelegenheit. Veteranen bekommen einen Becher Wein aufs Haus.'),
    (10, 'Misstraut Fremden und will erst wissen, wer sie schickt und was sie vorhaben.'),
    (11, 'Viel zu freundlich: lädt die Helden zum Tee ein und hört nicht mehr auf zu reden.'),
    (12, 'Spricht nur in Sprichwörtern und Reimen, die nicht immer passen.'),
    (13, 'Zählt jede Münze dreimal, beißt hinein und hält sie gegen das Licht.'),
    (14, 'Alles im Laden riecht stark nach etwas (Räucherwerk, Pökelfisch, nasser Hund).'),
    (15, 'Der Laden ist winzig und vollgestopft, bei jeder Bewegung fällt etwas herunter.'),
    (16, 'Schwerhörig: Alles muss dreimal gesagt werden, und er versteht gern etwas anderes.'),
    (17, 'Starker Akzent aus Dornmark oder Karth, flucht in der eigenen Sprache, wenn er sich ärgert.'),
    (18, 'Ein Papagei (oder Rabe) plaudert aus, was er im Laden gehört hat.'),
    (19, 'Weiß nie genau, was er auf Lager hat, und muss jedes Mal minutenlang suchen.'),
    (20, 'Ordnungsfanatiker: alles beschriftet und sortiert, und er verträgt keine Unordnung.');
