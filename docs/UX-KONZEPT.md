# Konzept: Rollen, Seiten und Design

Stand: 2026-10-03. Grobes Konzept, bewusst ohne Technik. Ergänzt `docs/CONCEPT.md` (Katalog, Charakter, Kampagne) um die Frage, wer was sieht und wie es aussieht. Das technische Vorgehen steht im Plan der Teilprojekte weiter unten.

## Leitgedanke

Zwei Rollen, zwei Geräte. **Spieler** sitzen mit dem Handy am Tisch und bedienen einhändig ihren Charakter. Der **DM** sitzt am Rechner und hat alles vor sich: Planung, Spielhilfen, Katalog. Alles sieht aus wie aus einem liebevoll gezeichneten Märchenbuch: hell, warm, freundlich. Die Geschichte ist leichtherzig, das Design soll nie düster wirken.

**Würfeln:** Die App würfelt keine Proben, Rasten oder Regelergebnisse. Das passiert am Tisch, die App zeigt Text und nimmt Ergebnisse als Eingabe. Ausnahme: DM-Generatoren (NSC, Begegnung, Zufallsereignis) wählen einen Vorschlag zufällig aus einer Tabelle, den der DM annimmt oder verwirft.

## Rollen

- **Spieler:** brauchen kein Login. Sie wählen ihren Charakter und spielen.
- **DM:** meldet sich mit **einem Passwort** an. Er kann alles, was Spieler können, und hat zusätzlich den gesperrten Bereich. Ohne Anmeldung ist dieser Bereich nicht nur versteckt, der Server liefert ihn gar nicht aus.
- Es gibt keine Benutzerkonten. Wer am Tisch ist, vertraut einander: Jeder Spieler könnte technisch jeden Charakter öffnen.

## Was Spieler sehen

- **Charaktere:** oben "Meine Charaktere" (der Browser merkt sich, welche zu einem gehören), darunter das Archiv aller anderen mit Suche. Es gibt viele Charaktere, aber nur wenige Spieler, also darf nie eine lange Liste der Einstieg sein.
- **Charaktererstellung** Schritt für Schritt, **Charakterbogen** am Tisch, **Level-up**, **Gedächtnis** (privater Freitext pro Charakter).
- **Regelwerk nachschlagen:** Items, Fertigkeiten, Zauber, Berufe, Völker, Wounded table.
- **Nie:** Bestiary (Monsterwerte), Kampagnen, Notizen des DMs. Es gibt für Spieler keine Kampagnenseite und keinen "für Spieler sichtbar"-Schalter. Der DM zeigt am Tisch alles selbst, und was bleiben soll, steht in der Chronik.

## Was der DM zusätzlich hat

- **Kampagnen:** anlegen, bearbeiten, neu starten, löschen.
- **Planen:** Kapitel, Orte als Baum mit Bild, NPCs, Items und Bücher, Fundorte, Monster aus dem Bestiary, Begegnungstabelle je Ort.
- **Spielen:** Chronik, Schnellzugriff auf NPCs, Orte und Monster, Begegnungen als Zufallsvorschlag aus der Tabelle, Notizen bei NPCs.
- **Katalog erweitern:** nur **Items** und **Bestiary** (mit Angriffen, "einzigartig"-Markierung, Bild). Skills, Berufe, Völker, Zauber, Wounded table und Begegnungstabellen bleiben, wie sie sind.
- **Gruppenübersicht:** Der DM stellt die Gruppe von heute zusammen (Suche, antippen) und sieht pro Charakter auf einen Blick Portrait, Name, Beruf und Volk, TP und WP, Zustände, Rüstung und Münzen. Ein Klick öffnet den ganzen Bogen. Die Gruppe hat keine Verbindung zur Kampagne, sie ist nur eine Merkliste des DMs.

## Seiten

| Bereich | Seite |
|---|---|
| Spieler | Charaktere, Charakter erstellen, Charakterbogen, Level-up, Regelwerk |
| DM | Anmeldung, Kampagnen, Kampagne planen, Kampagne spielen, Katalog (Items, Bestiary), Gruppe |

Planen und Spielen sind zwei getrennte Seiten derselben Kampagne. Der DM kann jederzeit wechseln.

## Design

- **Stimmung:** Märchenbuch. Pergament als Grund, Tinte als Text, Gold und Waldgrün als Akzente, Beerenrot für Gefahr. Runde Formen, weiche Schatten, kleine Verzierungen (Siegel, Banner, Schriftrollen). Kein Dark Mode.
- **Einheitlich:** ein gemeinsamer Baukasten für Karten, Knöpfe, Formulare, Tabs, Dialoge und Balken, damit jede Seite zur anderen passt.
- **Spieler (mobil):** große Touch-Flächen, wenig Text pro Bildschirm, Navigation unten am Daumen, Dialoge als Blatt von unten, Tabellen werden zu Karten.
- **DM (Desktop):** mehrere Spalten (Baum links, Inhalt Mitte, Details rechts), Seitenleiste, viel Übersicht. Auf einem Tablet bleibt es benutzbar.
- **Gesperrter Bereich:** der DM sieht überall ein klares Band "Nur für den DM", damit er nie versehentlich einen Spieler hineinschauen lässt.
- **Ohne Internet:** Schriften und Symbole werden mitgeliefert, das System läuft im LAN und sieht auch dort gut aus.

## Stand

- **Teilprojekt 1 (Fundament)**, **2 (Spielerseiten)** und **3 (DM Kampagne)** sind gebaut. Neu in 3: Kampagnen anlegen, bearbeiten, löschen (Standard-Abenteuer nur neu starten), Kapitel mit Reihenfolge, Planen-Seite mit Gliederung und Editor für Orte (Baum, Bild, Begegnungstabelle), NPCs, Items und Monster, Spielen-Seite mit Schnellzugriff, Kapitel lesen, Chronik, Zufallsvorschlag für Begegnungen, NPC-Notizen und Neustart.
- **Teilprojekt 4 (DM Katalog und Gruppe)** ist gebaut: Item-Editor (Waffe, Rüstung, Sonstiges), Bestiary-Editor (Angriffe, einzigartig, Bild, Löschschutz bei Verwendung), Begegnungstabellen zum Nachschlagen, Gruppenübersicht mit Merkliste (`dm_party`).
- Offen: Item ins Inventar übernehmen, NPC-Generator, Schnell-Encounter.

## Teilprojekte

1. **Fundament:** Design-Baukasten, Seitenrahmen für Spieler und DM, DM-Anmeldung und Sperre, eine Styleguide-Seite zur Abnahme.
2. **Spielerseiten (mobil):** Charakterliste mit Meine Charaktere und Archiv, Bogen, Erstellung, Level-up, Gedächtnis, Regelwerk.
3. **DM Kampagne:** Kampagnen und Kapitel verwalten, Planen-Seite, Spielen-Seite.
4. **DM Katalog und Gruppe:** Item- und Bestiary-Editor, Gruppenübersicht.

Jedes Teilprojekt bekommt ein eigenes Konzept, einen Plan und eine Abnahme. Gebaut wird in dieser Reihenfolge.

## Später

- Bilder und Handouts für die Spieler.
- Namenslisten nach Volk, NPC-Generator.
- Ein Hell/Dunkel-Umschalter, falls er gewünscht wird.
