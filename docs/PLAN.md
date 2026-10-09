# Plan: DM-Bereich als Sitzungs-Cockpit

Stand: 2026-10-08. Konzeptebene, bewusst ohne Technik-Details. Ergänzt `docs/UX-KONZEPT.md` (Rollen, Seiten, Design)
und `docs/CONCEPT.md` (Katalog, Charakter, Kampagne). Es wird noch kein Code geändert, dies ist die Sammlung dessen,
was der DM-Bereich können soll. Priorisierung und offene Fragen stehen am Ende.

## 1. Ziel und Leitgedanke

- Der DM-Bereich ist ein **Sitzungs-Cockpit**: alles, was während des Spiels gebraucht wird, ist in 1 bis 2 Klicks
  erreichbar, ohne Seitenwechsel und ohne den Faden zu verlieren.
- Heute sind Kampagnen, Gruppe, Katalog, Lore und SL-Regeln getrennte Nachschlageseiten. Gewünscht ist: dieselben
  Ressourcen, aber **interaktiv** und im Kontext der laufenden Kampagne.
- **Desktop-first**, auf dem Tablet benutzbar. Das Handy ist für den DM kein Ziel.
- Vorbereiten (Planen) und Spielen bleiben getrennte Ansichten, arbeiten aber auf denselben Daten.
- Alles, was der DM eintippt oder übernimmt, bleibt gespeichert (Notizen, Chronik, generierte NSC).
- **Grundsatz:** Die App würfelt keine Proben. Zufallsvorschläge aus Tabellen (Generatoren) sind erlaubt, siehe Entscheidung A.

## 2. Ist-Aufnahme

| Bereich    | Was es heute kann                                                                 | Schwäche für die Sitzung                                      |
|------------|-----------------------------------------------------------------------------------|---------------------------------------------------------------|
| Kampagnen  | Kapitel, Orte als Baum, NSC, Items, Monster, Planen- und Spielen-Seite, Chronik   | Spielen-Seite kennt weder Gruppe noch Regeln noch Katalog     |
| Gruppe     | Merkliste der heutigen Charaktere, TP/WP, Zustände, Rüstung, Münzen im Überblick  | Nur Anzeige, keine Aktionen, keine Verbindung zur Kampagne    |
| Katalog    | Editoren für Items, Bestiary, Begegnungstabellen                                  | Eigene Seite, Ergebnisse lassen sich nicht in die Kampagne übernehmen |
| Lore       | Weltgeschichte, Personen, Häuser und Gilden, Karte                                | Keine Verknüpfung mit Kampagnen-NSC                           |
| SL-Regeln  | Sechs Kapitel (Spielleitung, Kampf, Monster, Reise, NSC, Beispiele)               | Kein Suchen über Kapitel hinweg, nicht im Spielfluss erreichbar |

Offen laut `docs/UX-KONZEPT.md`: Item ins Inventar übernehmen, NPC-Generator, Schnell-Encounter. Die Tabellen für
NSC erschaffen, Reise-Missgeschicke, Abenteuerort verlassen und improvisierte Waffen liegen schon in der Datenbank und
werden bisher nur gelesen.

## 3. Neue Struktur (Vorschlag)

- **Navigation neu:** `Sitzung` (Cockpit, Startseite) · `Kampagnen` (Planen) · `Gruppe` · `Nachschlagen` (Katalog,
  Lore, SL-Regeln) · `Werkzeuge` (Generatoren).
- **Globale Schnellsuche** (Tastenkürzel, z. B. `/`): ein Feld findet NSC, Orte, Monster, Items, Zauber, Regeln und
  Lore. Treffer öffnen als **Drawer** (Seitenpanel), nicht als Seitenwechsel.
- **Am Tisch anpinnen:** Karten (Monster, NSC, Regel, Item) lassen sich an eine Leiste "Am Tisch" heften und bleiben
  im Cockpit sichtbar, bis der DM sie löst.
- **Aktive Kampagne:** wird einmal gewählt, Cockpit und Werkzeuge beziehen sich darauf.
- Das Band "Nur für den DM" bleibt überall sichtbar.

## 4. Sitzungs-Cockpit (Spielen, interaktiv)

- **Gruppenleiste:** TP/WP, Zustände und Rüstung der anwesenden Charaktere (aus der Gruppe), nur Anzeige (die Spieler pflegen ihre Werte selbst), aktualisiert sich automatisch.
- **Aktueller Ort:** Kurzbeschreibung, Begegnungstabelle, Ausgänge, Ortswechsel in einem Klick. Ein Ortswechsel
  schreibt optional in die Chronik.
- **Statusleiste unten** (immer sichtbar) mit TP/WP und Zuständen der Gruppe, klappt zum **Kampfmenü** auf.
- **Aktuelles Kapitel** lesbar, dazu NSC, Monster und Items des Ortes als Schnellkarten.
- **Chronik-Schnelleingabe:** ein Feld, Enter speichert. Dazu Sitzungsnotizen.
- **Erinnerungen** als Checkliste (Rast, Hunger, Kälte, Dunkelheit): nur Hinweise, keine Zähler.
- **Kampf-Hilfe:** Reihenfolge der Initiative-Karten abtippen (kein Tracker, siehe `docs/REGELN-LUECKEN.md`),
  TP-Zähler und Zustände an Monstern.
- **Regel-Drawer:** SL-Regeln und Spielerregeln per Suche ohne das Cockpit zu verlassen.

## 5. Werkzeuge (Generatoren und Helfer)

Muster für jeden Generator: **Button, Vorschlag, bearbeiten, "Übernehmen" oder "Verwerfen"**. Übernommenes landet in
der Kampagne und ist danach normal editierbar.

1. **NSC-Generator:** Ein Button erzeugt einen NSC aus den vorhandenen NSC-Tabellen (Aussehen, Eigenschaft,
   Motivation, Geheimnis, Beruf, Volk). Optional Filter (Volk, Beruf, Rolle). "Speichern" legt ihn in die
   **NSC-Liste der Kampagne**: eine einfache, durchsuchbare Liste mit allem, was man sich notiert hat (Name,
   Beschreibung, Fundort, Notizen).
2. **Namensgenerator** nach Volk und Region (Weidenmark-Namen aus `docs/lore`).
3. **Schnell-Encounter:** Begegnung für den aktuellen Ort oder die Region, Monster direkt als Karten, "Zum Kampf
   übernehmen".
4. **Zufallsereignisse und Reise-Missgeschick** (Tabellen existieren), Ergebnis in die Chronik übernehmbar.
5. **Beute-Vorschlag:** einfacher Vorschlag, niedrige Priorität (Entscheidung D).
6. **Gasthaus- und Ort-Generator** für Stegreif-Szenen: Name, Wirt, Gerücht, Gericht, Preis.
7. **Gerüchte und Aufhänger:** Liste pro Kampagne, mit "ausgespielt"-Markierung.
8. **Item ins Inventar übernehmen:** Beute direkt einem Charakter der Gruppe geben.
9. **Improvisierte Waffen** nach Ort (Gasthaus, Höhle, Wald) als Schnellkarte.
10. **Wetter und Tageszeit** als reine Anzeige (optional).

Bewusst nicht: Handouts, Soundboard (Entscheidung E).

## 6. Nachschlagen (Katalog, Lore, SL-Regeln zusammenführen)

- Eine Seite mit Kategorien links, Liste in der Mitte, Detail rechts, Suche über alles.
- Katalog-Editoren (Items, Bestiary, Begegnungen) bleiben, bekommen aber "Zur Kampagne hinzufügen" und "Anpinnen".
- SL-Regeln (`/dm/rules`) werden durchsuchbar, Treffer öffnen als Drawer im Cockpit.
- DM-Lore: Personen und Häuser lassen sich mit Kampagnen-NSC verknüpfen.

## 7. Kampagnenplanung (Bestehendes erweitern)

- Kapitel- und Orte-Baum bleibt. Verknüpfungen zwischen NSC, Ort, Kapitel und Monster werden klickbar.
- **Vorbereitungs-Checkliste** je Kapitel ("bereit für die Sitzung").
- **Sitzungs-Rückblick** aus der Chronik.
- **Export und Import** einer Kampagne (JSON) zum Sichern.

## 8. Querschnitt

- **Tablet:** große Touch-Flächen im Cockpit, kein Fokus auf Handy.
- **Suche:** ohne Seitenneuladen, Ergebnisse sofort.
- **Daten:** Änderungen kommen als Migration in `database/migrations/`, die Datenbank wird nie neu aufgesetzt. Neue
  Tabellen voraussichtlich für Sitzungsnotizen, Gerüchte, Uhren und Anpinnen. Generierte NSC nutzen die vorhandene
  NSC-Tabelle der Kampagne.
- **Tests:** `AppRoutesTest` und JS-Tests in `backend/tests-js` je neuem Werkzeug.
- **Design:** bestehender Baukasten (Märchenbuch, siehe `docs/UX-KONZEPT.md`), keine neuen Stilrichtungen.

## 9. Reihenfolge (Teilprojekte, jeweils einzeln lieferbar)

1. Navigation, aktive Kampagne, globale Schnellsuche mit Drawer.
2. Sitzungs-Cockpit (Gruppenleiste, aktueller Ort, Chronik).
3. NSC-Generator mit NSC-Liste, Namensgenerator.
4. Schnell-Encounter, Zufallsereignisse, Item ins Inventar.
5. Nachschlagen zusammenführen (Katalog, Lore, SL-Regeln).
6. Gerüchte, Gasthaus-Generator, Beute-Vorschlag.
7. Planung: Verknüpfungen, Checklisten, Export.

## 10. Entscheidungen

Entschieden am 2026-10-08:

- **A. Zufall:** erlaubt. Generatoren schlagen zufällig aus Tabellen vor, der DM nimmt an oder verwirft. Proben würfelt
  die App weiterhin nie. Der Satz "App würfelt nie" ist in CLAUDE.md, `docs/UX-KONZEPT.md` und
  `docs/REGELN-LUECKEN.md` entsprechend präzisiert (keine Proben, Zufallsvorschläge aus Tabellen sind ok).
- **B. Nachschlagen:** alles auf **einer Seite** (Katalog, Lore, SL-Regeln), erreichbar auch per Suche und Drawer.
- **C. Cockpit:** mit **Statusleiste unten** (immer sichtbar: TP/WP und Zustände der Gruppe) und einem **Kampfmenü**,
  das sich daraus aufklappt (Gruppe mit TP-Steppern, Gegner mit TP-Zählern, Initiative-Reihenfolge abtippen).
  Offen bleibt nur, ob das Cockpit die heutige Spielen-Seite ersetzt (Annahme: ja).
- **D. Beute:** "ganz nett, aber nicht wichtig": niedrige Priorität, nur ein einfacher Vorschlag, ganz am Schluss.
- **E. Handouts und Soundboard:** unerwünscht, gestrichen.
- **F. Priorisierung:** Reihenfolge aus Abschnitt 9 passt grundsätzlich. Das Mockup dazu (`docs/mockups/dm-cockpit.html`)
  ist mit dem verworfenen Entwurf gelöscht.

Das Cockpit-Layout (Statusleiste, Kampfmenü, Generator-Ablauf) wurde verworfen, siehe Abschnitt 11 und 13.

## 11. Umsetzungsstand

Stand 2026-10-09: Der erste Umbau (Statusleiste, Kampfmenü, NSC-, Gerüchte- und Gasthaus-Tab, Item-Geben,
Planungs-Extras, Export/Import) wurde verworfen und zurückgesetzt, weil er die Bedienung insgesamt verschlechtert
hat (doppelte NSC-Liste, zu viele Tabs beim Spielen, Gerüchte gehören in den Kampagnentext).

- **Bereiche (2026-10-09):** Navigation Kampagnen, Katalog, Regeln, Lore. Die Gruppe gehört zur Kampagne (Reiter
  im Spielen, neben Lesen und Chronik; `/dm/party` gibt es nur noch für die Schreibzugriffe).
  - **Regeln** (`/dm/rules`): SL-Kapitel mit Kapitelliste links, Tabellen stehen in ihren Kapiteln (improvisierte
    Waffen unter "NSC im Kampf", Reise-Tabellen unter "Reise", NSC-Tabellen unter "NSC erschaffen"), die
    Zufallsbegegnungen sind ein eigenes Kapitel. Das Kapitel "Beispiele" entfällt.
  - **Lore** (`/dm/lore`): DM-Lore, Kapitelliste links.
  - **Katalog:** Items, Bestiary und Begegnungen mit **einem** Menü (Baum links: Monster nach Kategorie, Items nach
    Art, Begegnungen; die Zahl rechts ist die Anzahl). Daneben die Liste der gewählten Kategorie mit Filterfeld, rechts
    der Editor. Der Arbeitsbereich füllt genau die Bildschirmhöhe, jede Spalte scrollt für sich (Seite nicht).
    Geöffnete Einträge wählen ihre eigene Kategorie. Schmal (bis 1100 px) stapeln sich die Spalten.
- **Suche zurückgestellt:** Die Suchoberfläche (Drawer, Seite "Nachschlagen") ist entfernt. Geblieben sind
  `SearchRepository` und `/dm/search` (Kampagne und Katalog) als Grundlage. Die Suche soll später je Bereich kommen
  und nur dort suchen. Nachschlagen von Monstern im Spiel gehört in die Kampfansicht (reine Lesekarte).
- **Zurückgesetzt:** Migrationen `0006` bis `0008` (Gerüchte, Gasthaus-Generator, `is_ready`), auch in der lokalen
  Dev-DB. Produktion hat sie nie bekommen.
- **Neu zu planen:** Ansichten und Kampfansicht, siehe Abschnitt 13.

## 12. Feature-Inventar (Stand 2026-10-09, vor dem Reset)

Alles, was die App konnte, als Stichwortliste. Einträge zu verworfenen Teilen (Generatoren, Gerüchte, Statusleiste,
Kampfmenü, Export/Import, Rückblick, Kapitel-Haken, "Verknüpft") gibt es nach dem Reset nicht mehr. `[x]` = gibt es jetzt (Stand nach dem Reset und dem Reiter Gruppe), `[ ]` = fehlt, wurde verworfen oder ist nur im Backend vorhanden (Suche).

### DM: Allgemein
- [x] DM-Login (ein Passwort)
- [x] Logout
- [x] DM-Navigation
- [ ] Top bar
- [ ] Schnellsuche (Drawer, Kürzel `/`)
- [ ] Dialog "Item geben"
- [x] Styleguide-Seite

### DM: Nachschlagen
- [ ] Suche über Kampagne
- [ ] Suche über Katalog
- [ ] Suche über SL-Regeln
- [ ] Suche über Lore
- [ ] Lookup-Seite
- [x] SL-Regeln lesen
- [x] DM-Lore lesen
- [x] Kapitelliste Regeln
- [x] Kapitelliste Lore

### DM: Kampagnen
- [x] Kampagnenliste
- [x] Kampagne anlegen
- [x] Kampagne bearbeiten (Name, Teaser, Hintergrund)
- [x] Kampagne löschen
- [x] Standardkampagne
- [x] Kampagne neu starten
- [ ] Export (JSON)
- [ ] Import (JSON)
- [x] Zähler in der Übersicht
- [x] "Was als Nächstes?"
- [ ] Rückblick (Recap)
- [ ] Rückblick als Text kopieren
- [x] Umschalter Planen/Spielen

### DM: Planen
- [x] Gliederung (Baum)
- [x] Kapitel anlegen
- [x] Kapitel bearbeiten
- [x] Kapitel verschieben
- [ ] Kapitel "Bereit für die Sitzung"
- [ ] Vorbereitungs-Checkliste
- [x] "In diesem Kapitel"
- [x] Ort anlegen
- [x] Ort bearbeiten
- [x] Ort: Unterorte
- [x] Ort: Nummer
- [x] Ort: DM-Text
- [x] Ort: Bild
- [x] Ort: Zufallsbegegnungs-Tabelle
- [x] NSC anlegen
- [x] NSC bearbeiten
- [x] NSC: Porträt
- [x] NSC: Kampfwerte verknüpfen
- [x] NSC: Spielnotizen
- [x] Item anlegen
- [x] Item bearbeiten
- [x] Item: Bild
- [x] Item: Fundort
- [x] Monster der Kampagne
- [x] Monster: Notizen
- [ ] Kasten "Verknüpft"

### DM: Spielen
- [x] Lesen-Tab
- [ ] Aktuelles Kapitel
- [x] Orte als Lesekarten
- [x] Weitere Orte
- [x] Karten (Monster, NSC, Ort, Item)
- [x] Chronik
- [x] Chronik: Schnelleingabe
- [ ] Chronik: Tage
- [x] Chronik: Eintrag bearbeiten/löschen
- [ ] Tab Tabellen
- [x] Zufallsbegegnungen (unter Regeln)
- [ ] Zufall ziehen (Begegnung)
- [x] Zufallsereignisse (unter Regeln)
- [x] Reise-Missgeschicke (unter Regeln)
- [x] Abenteuerort verlassen (unter Regeln)
- [x] Jagd (unter Regeln)
- [x] Improvisierte Waffen (Gasthaus, Höhle, Wald) (unter Regeln)
- [ ] NSC-Tab
- [ ] NSC-Generator
- [ ] NSC-Generator: einzelne Felder neu ziehen
- [ ] NSC-Generator: speichern
- [ ] NSC-Liste (durchsuchbar)
- [ ] Gerüchte-Tab
- [ ] Gerücht anlegen/bearbeiten/löschen
- [ ] Gerücht: Quelle
- [ ] Gerücht: Wahrheitsgehalt
- [ ] Gerücht: erzählt
- [ ] Zufallsgerücht
- [ ] Gasthaus-Tab
- [ ] Gasthaus-Generator
- [ ] Gasthaus: Wirt
- [ ] Gasthaus: Gericht und Preis
- [ ] Gasthaus: Gast
- [ ] Gasthaus: als Ort speichern
- [ ] Gasthaus: Gerücht merken
- [ ] Gasthaus: Katalogpreise
- [ ] Statusleiste (Gruppe)
- [ ] Statusleiste: Polling
- [ ] Kampfmenü
- [x] Kampf: Gegnerliste (im Reiter Gruppe)
- [x] Kampf: Gegner-TP-Zähler (im Reiter Gruppe, per −1/+1)
- [ ] Kampf: Initiative-Feld
- [ ] "In den Kampf" (Monster, auch mehrere)
- [ ] Item geben (aus Karte)

### DM: Gruppe
- [ ] Gruppenmenü
- [x] Charakter hinzufügen (im Reiter Gruppe)
- [x] Charakter entfernen (im Reiter Gruppe)
- [x] Gruppe leeren (im Reiter Gruppe)
- [x] Gruppenkarten (TP, WP, Zustände) (im Reiter Gruppe)
- [x] "Sitzung beendet" (Mementos zurück) (im Reiter Gruppe)
- [ ] Item ins Inventar legen

### DM: Katalog
- [x] Katalog-Items
- [x] Item bearbeiten/anlegen
- [x] Katalog-Bestiary
- [x] Monster bearbeiten/anlegen
- [x] Monster: Bild
- [x] Begegnungstabellen (Ansicht)

### Spieler: Allgemein
- [x] Startseite
- [x] Regeln lesen
- [x] Lore lesen
- [x] Weiterleitungen (/campaign, /world)

### Spieler: Charakter
- [x] Charakterliste
- [x] Charakter erstellen (Wizard)
- [x] Charakterbogen
- [x] Charakter löschen
- [x] Porträt
- [x] TP ändern
- [x] WP ändern
- [x] Rast
- [x] Todeswürfe
- [x] Verletzungen
- [x] Zustände (Toggle)
- [x] Memento
- [x] Währung
- [x] Fertigkeiten markieren
- [x] Fertigkeiten steigern
- [x] Zauber
- [x] Heldenfähigkeiten
- [x] Level-up
- [x] Rüstung je Slot
- [x] Inventar

### Daten und Technik
- [x] campaigns
- [ ] campaign_chapters (is_ready)
- [x] campaign_places
- [x] campaign_npcs
- [x] campaign_items
- [ ] campaign_monsters
- [x] campaign_chronicle
- [ ] campaign_rumors
- [x] catalog_roll_tables
- [x] catalog_encounter_tables
- [ ] catalog_generator_entries
- [x] Migrationen
- [x] Tests (PHPUnit, JS)

### Fehlt / aufgefallen
- [ ] Beute-Generator (Loot)
- [ ] Ort wechseln beim Spielen
- [ ] Ungeplantes anlegen beim Spielen (Ort, NSC)
- [ ] Generatoren auf fünf Tabs verteilt

## 13. Neuer Ansatz (Entwurf, offen)

Ansichten:
1. **Kampagnenliste** (`/dm`): wählen, anlegen, löschen.
2. **Kampagne bearbeiten** (Vorbereiten): Kapitel, Orte, NSC, Items, Monster, Gasthäuser; NSC- und Gasthaus-Generator
   hier, Ergebnis landet direkt in der Liste. Gerüchte und Händler stehen im Kampagnentext.
3. **Kampagne spielen:** schlank: Chronik eintragen, aktuelles Kapitel/Ort lesen, Kampfansicht, Status der Gruppe.
4. **Nachschlagen (DM):** nur lesen: Suche, SL-Regeln, Lore, Tabellen (improvisierte Waffen, Reise-Missgeschicke,
   Zufallsereignisse, Jagd).
5. **Katalog bearbeiten:** Items, Monster, Begegnungstabellen, später Gasthäuser und Händler.
6. **Gruppe.**

Kampfansicht (Idee): Gegner gruppiert (Name, Anzahl, TP je Gegner, Rüstung, Angriffe als Text, Zustände), daneben die
Gruppe, dazu eine Reihenfolge-Leiste "dran/fertig" mit abgetippten Initiative-Karten. Kein Regelwurf in der App.

Offen: Händler als Katalogtyp oder Textfeld am NSC; Reihenfolge der Umsetzung.

Spielen-Ansicht (2026-10-09): Das Mockup `docs/mockups/spielen.html` ist in der App umgesetzt (`/dm/campaign/:id/play/chapter/:chapter`).
Orte sind in der Spielen-Ansicht kapitelunabhängig (jede Kapitelseite zeigt alle Orte), die App merkt sich weder Ort noch Kapitel der Gruppe. Kopfleiste: Chronik, Gegner, Werkzeuge (Dropdown), Planen/Spielen; alles öffnet als Dialog in der Mitte. Werkzeuge zeigen die Tabellen (Reise, Jagd, improvisierte Waffen, Zufallsbegegnungen) unverändert und einen NSC-Vorschlag. Eine
Kampagne, Kapitel als Unterseiten (`/play/chapter/N`), links Index mit Suche (Orte, NSC, Monster, Items), Mitte
Lesetext des Kapitels, rechts Gruppenübersicht, dazu Gegnerliste (TP-Zähler, Fertigkeiten und Angriffe als Text; Initiative und Spickzettel entfallen),
Kampagnen mit nur einem Kapitel zeigen dieselbe Struktur) und Werkzeuge-Drawer (Chronik, Zufallsvorschläge, NSC-Vorschlag, Erinnerungen).

## 14. Lücken gegenüber den Abschnitten 3 bis 9 (Stand 2026-10-09)

Vergleich dessen, was oben geplant ist, mit dem, was die App jetzt kann. "Teilweise" heißt: eine einfache Form ist da.

| Plan (Abschnitt) | Stand | Was fehlt |
|---|---|---|
| Navigation Kampagnen, Katalog, Regeln, Lore (3) | Da | `Sitzung` und `Werkzeuge` als eigene Punkte sind bewusst nicht vorgesehen |
| Aktive Kampagne (3) | Fehlt | Kampagne wählen und überall merken |
| Globale Schnellsuche, Drawer (3, 8) | Fehlt | Nur `SearchRepository` und `/dm/search` im Backend, keine Oberfläche. Soll je Bereich kommen |
| Am Tisch anpinnen (3) | Fehlt | |
| Gruppe im Spielen (4) | Teilweise | Rechte Spalte der Spielen-Ansicht mit TP, WP, Zustände, Rüstung. Keine automatische Aktualisierung, keine Statusleiste |
| Aktueller Ort, Ortswechsel, Chronik-Eintrag dazu (4) | Entfällt | Bewusst statisch: kein Ort der Gruppe, Orte überall sichtbar |
| Aktuelles Kapitel lesbar, Karten zu NSC, Monster, Items (4) | Da | Kapitel-Reiter (ohne Merken), Karten als Dialog |
| Chronik-Schnelleingabe (4) | Teilweise | Eigener Menüpunkt Chronik im Kopf (Dialog). Sitzungsnotizen als eigener Teil fehlen |
| Erinnerungen als Checkliste (4) | Entfällt | Nicht gewünscht |
| Kampf-Hilfe (4) | Da | Gegner-Panel mit editierbaren TP, Fertigkeiten, Angriffen, Suche und "In den Kampf" aus Karten. Initiative und Zustände entfallen bewusst |
| Regel-Drawer mit Suche (4, 6) | Fehlt | Regeln lesen geht auf `/dm/rules`, aber ohne Suche und nicht im Spielfluss |
| NSC-Generator mit NSC-Liste (5.1) | Teilweise | NSC-Vorschlag im Werkzeuge-Menü, "Als NSC speichern" legt ihn in der Kampagne an. Keine Filter |
| Namensgenerator (5.2) | Fehlt | |
| Schnell-Encounter (5.3) | Teilweise | Zufallsbegegnungs-Tabellen der Kampagne im Werkzeuge-Menü, ohne "Zum Kampf übernehmen" |
| Zufallsereignisse und Reise-Missgeschick (5.4) | Da | Tabellen stehen unverändert im Werkzeuge-Menü, gewürfelt wird am Tisch |
| Beute-Vorschlag (5.5) | Fehlt | Niedrige Priorität |
| Gasthaus- und Ort-Generator (5.6) | Fehlt | |
| Gerüchte und Aufhänger (5.7) | Entfällt | Gehören in den Kampagnentext |
| Item ins Inventar geben (5.8) | Fehlt | |
| Improvisierte Waffen (5.9) | Da | Als Tabellen im Werkzeuge-Menü und unter Regeln |
| Wetter und Tageszeit (5.10) | Fehlt | Optional |
| Nachschlagen als eine Seite (6) | Geändert | Drei getrennte Bereiche: Katalog, Regeln, Lore |
| "Zur Kampagne hinzufügen" und "Anpinnen" im Katalog (6) | Fehlt | |
| Lore mit Kampagnen-NSC verknüpfen (6) | Fehlt | |
| Orte-Baum, klickbare Verknüpfungen (7) | Teilweise | Baum da, Namen in Texten sind verlinkt, kein Kasten "Verknüpft" |
| Vorbereitungs-Checkliste je Kapitel (7) | Fehlt | |
| Sitzungs-Rückblick aus der Chronik (7) | Fehlt | |
| Export und Import als JSON (7) | Fehlt | |
| Tablet-Bedienung, große Touch-Flächen (8) | Nicht geprüft | |

Zusätzlich gebaut, aber nicht im Plan: Gegnerliste pro Kampagne (`campaign_foes`) mit Suchfeld, das die Liste beim Tippen kürzt.
