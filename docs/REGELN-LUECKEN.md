# Regel-Lücken: was fehlt, was haben wir, wie setzen wir es um

Abgleich der gesammelten Stichworte gegen die App (Regelwerk-Seiten `/rules` (Spieler) und `/dm/rules` (SL), Katalog in `database/02_catalog.sql`,
Charakterbogen, DM-Bereich). Stand nach den Screenshots des Grundregelwerks in `docs/bilder`.

**Grundsatz:** Die App würfelt nie, auch nicht für den DM. Gewürfelt wird am Tisch, die App zeigt Text und nimmt
Ergebnisse als Eingabe entgegen.

**Quellen:** Schnellstarter 2.0 (`docs/DB_DE_Schnellstarter_2-0_web-2njzid.pdf`) und die Screenshots des englischen
Grundregelwerks. Die deutschen Texte aus dem Grundregelwerk sind eigene Übersetzungen mit den Begriffen des
Schnellstarters.

**Datenbank:** Änderungen kommen als Migration (`database/migrations/`, siehe `docs/SCHEMA.md`), nicht durch
Neuaufsetzen.

Status: ✅ vorhanden · 🟡 teilweise · ❌ fehlt

| #  | Thema                                   | Status | Wo / was fehlt                                                                                                                                               |
|----|-----------------------------------------|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1  | Encumbrance (Traglast)                  | ✅     | Regeln auf `/rules` (Grundregeln, Traglast), Gewichte im Katalog. Kein Zähler am Bogen (bewusst nicht gewünscht).                                                            |
| 2  | Skills, Drache und Dämon                | ✅     | `/rules` Grundregeln, "Würfelproben"; Fertigkeitsliste unter Charakter. Volltexte der einzelnen Fertigkeiten fehlen.                                                                          |
| 3  | Pushing your roll                       | ✅     | `/rules` Grundregeln, "Würfelproben" (Strapazieren).                                                                                                                       |
| 4  | Help from others                        | ✅     | `/rules` Grundregeln, "Würfelproben" (Hilfe).                                                                                                                              |
| 5  | Drawing Initiative                      | ✅     | Regeln da. Initiative läuft mit echten Karten, kein Tracker.                                                                                                 |
| 6  | Action and Movement                     | ✅     |                                                                                                                                                              |
| 7  | Dodge, Parry, Reactions, Kampfaktionen  | ✅     |                                                                                                                                                              |
| 8  | Conditions                              | ✅     | Kein automatischer Nachteil-Hinweis.                                                                                                                         |
| 9  | Heal and Resting                        | ✅     | Rast-Dialog mit eingetippten Würfen und Memento (einmal pro Sitzung, Reset durch die SL auf `/dm/party`). Todeswurf-Dialog bei 0 TP mit Verletzungs-Auswahl. |
| 10 | Other Hazards                           | 🟡     | Text da, keine Werkzeuge.                                                                                                                                    |
| 11 | Hunger                                  | ✅     | Text unter Grundregeln, "Gefahren & Überleben", und "Nahrung in der Wildnis". Kein Zähler (unwichtig).                                                                                                  |
| 12 | Riding                                  | ✅     |                                                                                                                                                              |
| 13 | Improvised weapons                      | ✅     | Regel unter Kampf; Tabellen Gasthaus, Höhle, Wald im SL-Bereich (`/dm/rules`, Beispiele).                                                                                                                              |
| 14 | Magical Mishaps                         | ✅     | `/rules` Magie, "Magie"; Patzer-Tabelle unter Tabellen.                                                                                                                 |
| 15 | Learning Spells                         | ✅     | "Magie lernen", "Magie steigern".                                                                                                                            |
| 16 | Features bei Waffen                     | ✅     | Merkmale pro Waffe im Katalog; Schadensarten, Lang und Niederwerfen sind auf `/rules` erklärt.                                                               |
| 17 | Journey Mishap                          | ✅     | Tabelle W12 im SL-Bereich (`/dm/rules`, Reise & Abenteuerorte). Reise-Grundregeln (S. 100–101) fehlen.                                                                                           |
| 18 | Hunting, Making Camp                    | ✅     | Grundregeln, "Reise & Wildnis"; Jagd-Tabelle unter Tabellen (für Spieler sichtbar).                                                                                                                               |
| 19 | Typical NPCs                            | ✅     | Bestiarium, Kategorie "Alltagsvolk".                                                                                                                         |
| 20 | Creating NPC                            | ✅     | SL-Bereich (`/dm/rules`, Spielleitung & NSC) und sechs NSC-Tabellen (NSC erschaffen).                                                                                                                      |
| 21 | Leaving Adventure Site                  | ✅     | Tabelle W6 und Text im SL-Bereich (`/dm/rules`, Reise & Abenteuerorte).                                                                                                                                         |
| 22 | Default Campaign "Burg des Raubritters" | ✅     | Kampagne 4 mit Karte, Orten, Items, NSC, Zufallsereignissen.                                                                                                 |
| 23 | Dienste (Services)                      | ✅     | `catalog_services`, `/rules` Ausrüstung, "Dienste".                                                                                                               |
| 24 | Tiere (Animals)                         | ✅     | Reit- und Lasttiere als Items, Tiere (S. 99) mit Angriffen im Bestiarium.                                                                                    |
| 25 | Monster-Regeln (S. 83)                  | ✅     | SL-Bereich `/dm/rules`, Kapitel "Monster": Grimmigkeit, Größe, Bewegung, Monsterangriffe.                                                                          |

## Bewusst nicht umgesetzt

Traglast-Zähler, Hunger-Zähler, Initiative-Tracker (echte Karten), Würfel in der App. Schatztabellen, Abenteuererzeugung
und Reise-Grundlagen sind unwichtig (Schatztabelle I und "Abenteuer vorbereiten" wurden entfernt), die
Waffen-/Rüstungstabellen sind schon im Seed.

## Übergabe

Erledigt und gestaged (nicht committet): Wurftabellen, Dienste, Gewichte, Regeltexte auf `/rules` (inkl. Monster),
Kampagne 4, Todeswurf-Dialog mit Verletzungen, Memento, Migrationen `0001`–`0005` mit `bin/migrate.php`, Upload-Rechte
im `deploy.sh`.

Noch zu tun:

- **Production:** DB-Backup, deployen (führt `bin/migrate.php` aus), Bild-Upload testen (Faela Mondschatten). Schlägt
  der Upload weiter fehl: php-fpm-Logs prüfen.
- **Dev-DB:** `rphp bin/migrate.php`, in `.env` `DB_NAME=campaign-management` prüfen.
- **Visuell prüfen:** `/rules` (alle sechs Tabs) und `/dm/rules` (alle Kapitel), Kampagne 4, Todeswurf-Dialog und
  Rast-Dialog bei 390 px Breite.
- **Optional:** Hinweis "512 × 512 px" am Upload-Feld oder automatisches Verkleinern.
