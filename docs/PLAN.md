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
- **F. Priorisierung:** Reihenfolge aus Abschnitt 9 passt grundsätzlich. Zuerst ein klickbares Mockup zur Bewertung:
  `docs/mockups/dm-cockpit.html` (Datei im Browser öffnen, kein Server nötig).

Noch offen: Reaktion auf das Mockup (Layout des Cockpits, Statusleiste, Kampfmenü, Generator-Ablauf).

## 11. Umsetzungsstand

Stand 2026-10-09: Der erste Umbau (Statusleiste, Kampfmenü, NSC-, Gerüchte- und Gasthaus-Tab, Item-Geben,
Planungs-Extras, Export/Import) wurde verworfen und zurückgesetzt, weil er die Bedienung insgesamt verschlechtert
hat (doppelte NSC-Liste, zu viele Tabs beim Spielen, Gerüchte gehören in den Kampagnentext).

- **Bereiche (2026-10-09):** Navigation Kampagnen, Katalog, Regeln, Lore. Die Gruppe gehört zur Kampagne (dritter
  Schalter neben Planen und Spielen, `/dm/party` bleibt die Adresse).
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
Kampfmenü, Export/Import, Rückblick, Kapitel-Haken, "Verknüpft") gibt es nach dem Reset nicht mehr. Zum Streichen, Zusammenlegen und Ergänzen.

### DM: Allgemein
- [ ] DM-Login (ein Passwort)
- [ ] Logout
- [ ] DM-Navigation
- [ ] Top bar
- [ ] Schnellsuche (Drawer, Kürzel `/`)
- [ ] Dialog "Item geben"
- [ ] Styleguide-Seite

### DM: Nachschlagen
- [ ] Suche über Kampagne
- [ ] Suche über Katalog
- [ ] Suche über SL-Regeln
- [ ] Suche über Lore
- [ ] Lookup-Seite
- [ ] SL-Regeln lesen
- [ ] DM-Lore lesen
- [ ] Kapitelliste Regeln
- [ ] Kapitelliste Lore

### DM: Kampagnen
- [ ] Kampagnenliste
- [ ] Kampagne anlegen
- [ ] Kampagne bearbeiten (Name, Teaser, Hintergrund)
- [ ] Kampagne löschen
- [ ] Standardkampagne
- [ ] Kampagne neu starten
- [ ] Export (JSON)
- [ ] Import (JSON)
- [ ] Zähler in der Übersicht
- [ ] "Was als Nächstes?"
- [ ] Rückblick (Recap)
- [ ] Rückblick als Text kopieren
- [ ] Umschalter Planen/Spielen

### DM: Planen
- [ ] Gliederung (Baum)
- [ ] Kapitel anlegen
- [ ] Kapitel bearbeiten
- [ ] Kapitel verschieben
- [ ] Kapitel "Bereit für die Sitzung"
- [ ] Vorbereitungs-Checkliste
- [ ] "In diesem Kapitel"
- [ ] Ort anlegen
- [ ] Ort bearbeiten
- [ ] Ort: Unterorte
- [ ] Ort: Nummer
- [ ] Ort: DM-Text
- [ ] Ort: Bild
- [ ] Ort: Zufallsbegegnungs-Tabelle
- [ ] NSC anlegen
- [ ] NSC bearbeiten
- [ ] NSC: Porträt
- [ ] NSC: Kampfwerte verknüpfen
- [ ] NSC: Spielnotizen
- [ ] Item anlegen
- [ ] Item bearbeiten
- [ ] Item: Bild
- [ ] Item: Fundort
- [ ] Monster der Kampagne
- [ ] Monster: Notizen
- [ ] Kasten "Verknüpft"

### DM: Spielen
- [ ] Lesen-Tab
- [ ] Aktuelles Kapitel
- [ ] Orte als Lesekarten
- [ ] Weitere Orte
- [ ] Karten (Monster, NSC, Ort, Item)
- [ ] Chronik
- [ ] Chronik: Schnelleingabe
- [ ] Chronik: Tage
- [ ] Chronik: Eintrag bearbeiten/löschen
- [ ] Tab Tabellen
- [ ] Zufallsbegegnungen
- [ ] Zufall ziehen (Begegnung)
- [ ] Zufallsereignisse
- [ ] Reise-Missgeschicke
- [ ] Abenteuerort verlassen
- [ ] Jagd
- [ ] Improvisierte Waffen (Gasthaus, Höhle, Wald)
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
- [ ] Kampf: Gegnerliste
- [ ] Kampf: Gegner-TP-Zähler
- [ ] Kampf: Initiative-Feld
- [ ] "In den Kampf" (Monster, auch mehrere)
- [ ] Item geben (aus Karte)

### DM: Gruppe
- [ ] Gruppenmenü
- [ ] Charakter hinzufügen
- [ ] Charakter entfernen
- [ ] Gruppe leeren
- [ ] Gruppenkarten (TP, WP, Zustände)
- [ ] "Sitzung beendet" (Mementos zurück)
- [ ] Item ins Inventar legen

### DM: Katalog
- [ ] Katalog-Items
- [ ] Item bearbeiten/anlegen
- [ ] Katalog-Bestiary
- [ ] Monster bearbeiten/anlegen
- [ ] Monster: Bild
- [ ] Begegnungstabellen (Ansicht)

### Spieler: Allgemein
- [ ] Startseite
- [ ] Regeln lesen
- [ ] Lore lesen
- [ ] Weiterleitungen (/campaign, /world)

### Spieler: Charakter
- [ ] Charakterliste
- [ ] Charakter erstellen (Wizard)
- [ ] Charakterbogen
- [ ] Charakter löschen
- [ ] Porträt
- [ ] TP ändern
- [ ] WP ändern
- [ ] Rast
- [ ] Todeswürfe
- [ ] Verletzungen
- [ ] Zustände (Toggle)
- [ ] Memento
- [ ] Währung
- [ ] Fertigkeiten markieren
- [ ] Fertigkeiten steigern
- [ ] Zauber
- [ ] Heldenfähigkeiten
- [ ] Level-up
- [ ] Rüstung je Slot
- [ ] Inventar

### Daten und Technik
- [ ] campaigns
- [ ] campaign_chapters (is_ready)
- [ ] campaign_places
- [ ] campaign_npcs
- [ ] campaign_items
- [ ] campaign_monsters
- [ ] campaign_chronicle
- [ ] campaign_rumors
- [ ] catalog_roll_tables
- [ ] catalog_encounter_tables
- [ ] catalog_generator_entries
- [ ] Migrationen
- [ ] Tests (PHPUnit, JS)

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
