# Konzept: Katalog, Charakter und Kampagne

Stand: 2026-10-02. Grobes Konzept, bewusst ohne Tabellen und Spalten. Das Schema steht in `docs/SCHEMA.md`.

## Leitgedanke

Das System ersetzt die **Zettelwirtschaft** des DMs, nicht das Spiel. Es soll sich anfühlen wie ein Ordner mit losen Blättern: Alberta bekommt ein Blatt, ein Ort bekommt ein Blatt, die Chronik ist ein Blatt. Kein Computerspiel, bei dem jeder am Tisch auf sein Gerät schaut. Alles bleibt einfach, und was nicht einfach geht, wird weggelassen.

## Drei Sparten

1. **Der Katalog** ist das Regelwerk: Items (Waffen, Rüstungen, Ausrüstung), Fertigkeiten, Berufe, Zauber, Bestiary, Zufallsbegegnungen, Wounded table und alles weitere, was das Regelwerk vorgibt. Alles ist statisch und kommt 1:1 aus dem Regelwerk. Der Katalog wächst nicht von allein und enthält keine Kampagneninhalte.
2. **Der Charakter** (Spielercharakter) arbeitet mit dem Katalog: Fertigkeiten, Berufe, Items, Zauber.
3. **Die Kampagne** ist ein Abenteuer, das der DM aus Katalog-Einträgen zusammenbaut. Ihr gehören Kapitel, Orte, NPCs, Items (Bücher, Quest-Items), Chronik und Notizen, es gibt sie nur dort. Keine Dopplung: Ist die Kampagne vorbei oder gelöscht, ist auch das weg.

Charakter und Kampagne kennen sich nicht. Die einzige Verbindung ist indirekt: Findet die Gruppe ein Item, schreibt der Spieler es in sein Inventar, als Text, ohne Verknüpfung.

Jede Kampagne ist **getrennt**. Die Welt (`docs/lore/world.md`) bleibt im Kopf des DMs und in seinen Notizen. Eine Kampagne kennt nur ihren Schauplatz: Spielt sie im Turm oder in der Höhle, ist es egal, wie das Land heißt oder ob Krieg herrscht. Wird etwas davon wichtig, legt der DM einen NPC an, der es weiß.

## Zwei Modi einer Kampagne

- **Planen (Bearbeiten).** Der DM legt Kapitel, Orte, NPCs und Items an und holt Monster-Vorlagen und Zufallsbegegnungen aus dem Katalog. Hier steht auch, wo man etwas findet und was dort zu lesen ist.
- **Spielen.** Mit "Kampagne fertig" wechselt der DM in den Spielmodus. Dort stehen die Dinge, die am Tisch gebraucht werden: Chronik, Schnellzugriff auf wichtige NPCs und Orte, Zufallsbegegnungen, NPC-Generator und weitere DM-Werkzeuge.

Der DM kann jederzeit zurück in den Bearbeiten-Modus, um die Kampagne zu erweitern oder zu ändern.

## Drei Textebenen

Alles, was der DM anlegt, hat bis zu drei Ebenen:

- **Was vorgelesen wird:** die Beschreibung.
- **Was die Spieler sehen:** bei NPCs nur Name und Icon, nicht mehr.
- **Was nur der DM sieht:** DM-Text und Notizen.

## Orte

Orte gehören der Kampagne und liegen ineinander: Land, Dorf, Taverne, oder Turm, Stockwerk, Raum. Ein Ort hat einen Namen, eine vorlesbare Beschreibung, eine kurze DM-Beschreibung (wie sich der DM den Ort vorgestellt hat), optional ein Bild und optional eine Zufallsbegegnungstabelle aus dem Katalog (Wald, Straße, Ruine). Wer einen Ort in einer anderen Kampagne braucht, legt ihn dort neu an.

## NPCs

NPCs gehören der Kampagne. Ein NPC braucht nur einen Namen. Alberta wird in der Kampagne angelegt und bekommt:

- **Beschreibung:** wer sie ist und wie sie aussieht, kann vorgelesen werden.
- **Für den DM:** Theater (Stimme, Macken), Geheimnisse, was der DM wissen muss.
- **Notizen:** was in dieser Kampagne mit ihr passiert: Fand sie einen Spielercharakter sympathisch? Lebt sie, ist sie tot, geflohen? Es gibt keine eigenen Zustände und keine Automatik, nur den Zettel. Wichtige Ereignisse schreibt der DM zusätzlich in die Chronik.
- **Fundort** (bei Quest-NPCs): "bei den Hundekämpfen".

Die Spieler merken sich selbst, wer Alberta ist. Das System verwaltet kein Wissen der Spieler über sie. Kampfwerte sind optional: Der NPC kann auf eine Vorlage im Bestiary verweisen.

## Bestiary

Das Bestiary im Katalog enthält **Vorlagen** für Kampfwerte: Wolf, Goblin, Drache, und das Alltagsvolk in drei Stufen nach Kampfkraft: Zivilist, Kämpfer, Zauberkundiger. Der Beruf steht beim NPC als Text, das Volk ebenfalls. Ein Wachtrupp sind drei Kämpfer. Einzelne Tiere gibt es nicht als Einträge, die Kampagne sagt nur "4 Wölfe".

**Einmalige Endbosse** (Krakul) liegen mit einer Markierung "einzigartig" im Bestiary, damit klar ist, dass es einmalige Wesen für eine Geschichte sind. In der Kampagne sind sie NPCs, die auf ihren Werteblock verweisen.

## Zufallsbegegnungen

Der Katalog enthält Begegnungstabellen nach Umgebung (Wald, Straße, Ruine). Ein Eintrag verweist auf eine Bestiary-Vorlage mit Anzahl ("W3 Wölfe"). Die Kampagne wählt nur aus, welche Tabelle an welchem Ort gilt. Eigene Zufallsereignisse pro Kampagne gibt es nicht: Was besonders ist, steht in der DM-Beschreibung des Ortes.

## Items

Der Katalog enthält nur Regel-Items (Waffen, Rüstungen, Ausrüstung, Tränke). Alles Geschichtliche gehört der Kampagne: Bücher, Briefe, Quest-Items, die Flasche Wein, die ein Trinker sucht. Ein Kampagnen-Item hat einen Namen, eine vorlesbare Beschreibung, einen DM-Text und optional ein Bild und einen **Text** (bei Büchern und Briefen). Sein Fundort ist ein Ort der Kampagne, ein Hinweis in Worten, oder beides ("in der verlassenen Bibliothek, nach etwas Suchen in der Ecke").

Bücher sind wie in Computerspielen à la The Witcher 3: kurz, selten mehr als zwei Seiten. Ein Buch kann eine Schwachstelle eines Zombies, eine Geschichte oder eine Intrige verraten. Der DM entscheidet am Tisch, ob und wie die Gruppe es findet, und liest den Text vor oder gibt ihn weiter. Es gibt keine Vorräte, Gewichtungen oder automatische Vorschläge.

## Chronik

Die Chronik ist das Herzstück im Spielmodus. Alles, was passiert, kommt dort hinein: Alberta hat geholfen, Krakul ist gefallen, der Wein wurde gefunden. Sie ist Freitext mit Titel, neuester Eintrag oben, und der DM schreibt sie so, wie er sonst auf Papier mitschreibt. Es gibt keine automatischen Zustände. Der Zustand eines NPCs oder Ortes steht nur in seinen Notizen der Kampagne.

## Gedächtnis der Spielercharaktere

Jeder Spielercharakter bekommt einen Button **Gedächtnis**. Dort schreibt der Spieler in Freitext auf, was er sich merken will, damit nichts vergessen wird. Der Text gehört dem Charakter, nicht der Kampagne, und ist rein privat und optional.

## Kampagnen

- Eine Kampagne hat einen Namen und ein Erstellungsdatum. Kampagnen haben keine Reihenfolge und kein Weltdatum.
- Kapitel sind sinnvolle Abschnitte, die der DM spielen will. Jedes Kapitel wird über eine oder mehrere Sessions gespielt. Kapitel haben einen Titel und eine Reihenfolge und lassen sich dazwischenschieben.
- Eine Kampagne wird immer nur von einer Gruppe gleichzeitig gespielt. Es gibt keine Kopien und keine Durchläufe.
- Standard-Abenteuer (Ridderhöhe, Versinkender Turm) sind Kampagnen, die wiederholbar sein sollen: Eine neue Gruppe soll den Turm ohne viel Vorbereitung spielen können.
- **Neustart:** Eine Kampagne wird neu gestartet, indem die Chronik zurückgesetzt wird. Der Inhalt der Planung und der Katalog bleiben unberührt. Die Notizen bei den NPCs gehören zum Spielstand und werden beim Neustart ebenfalls geleert, damit Krakul wieder lebt.

## Reihenfolge

**Gebaut**
- Kampagnen, Kapitel, Orte (geschachtelt, mit Bild), NPCs, Kampagnen-Items, Chronik und Neustart
- Katalog mit Regelwerk, Bestiary und Zufallsbegegnungstabellen

**Nächste Schritte**
- Kampagnen-Items anlegen und bearbeiten (heute nur anzeigen), Fundort bei NPCs und Items wählen
- Modi Planen und Spielen mit "Kampagne fertig"
- Item ins Inventar eines Charakters übernehmen (Text kopieren)
- Gedächtnis pro Spielercharakter
- DM-Werkzeuge im Spielmodus: Schnell-Encounter, NPC-Generator

**Später**
- Namenslisten nach Volk
- Planung der nächsten Session für eigene Kampagnen
- Bedrohungsuhren, Wünsche und Beziehungen bei NPCs
- Handouts mit Bildern
