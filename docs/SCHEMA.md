# Schema

Stand: 2026-10-02. Setzt `docs/CONCEPT.md` um. Maßgeblich ist `database/migrations/0001_schema.sql`, dieses Dokument erklärt nur die Aufteilung. MariaDB, `_de`-Suffix für deutsche Texte, `utf8mb4`, InnoDB.

## Überblick

```
Katalog (Regelwerk, statisch)           Kampagne (gehört der Kampagne, ON DELETE CASCADE)
─────────────────────────────           ─────────────────────────────────────────────────
catalog_bestiary (+ _attacks)        ◄─ campaign_bestiary ──────────────────┐
   ▲                                    campaign_npcs ──────────────────────┤
   └─ campaign_npcs.bestiary_id         campaign_places (parent_id → sich) ─┼─► campaigns
catalog_encounter_tables (+ _entries) ◄─ campaign_places.encounter_table_id │
catalog_items (Regel-Items)             campaign_items ─────────────────────┤
Skills, Berufe, Kins, Zauber, ...       campaign_chapters ──────────────────┤
                                        campaign_chronicle ─────────────────┘

Charakter: characters, character_* → hängen nur am Katalog, nie an der Kampagne
```

Regel: Der Katalog enthält nur Regelwerk und bleibt statisch. Was zu einer Kampagne gehört, liegt in der Kampagne. Charakter und Kampagne haben keinen Fremdschlüssel zueinander. Wird eine Kampagne gelöscht, sind Orte, NPCs, Items und Chronik mit weg, der Katalog bleibt.

## Katalog

- **`catalog_items`** (mit `catalog_item_weapons`, `catalog_item_armor`): nur Regel-Items. Keine DM-Texte, keine Story-Items.
- **`catalog_bestiary`** und **`catalog_bestiary_attacks`:** Kampfwerte-Vorlagen. `is_unique` markiert einmalige Endbosse (Krakul, der Gruftschrecken von Ridderhöhe).
- **`catalog_encounter_tables`** und **`catalog_encounter_table_entries`:** Zufallsbegegnungen nach Umgebung (Wald, Straße, Ruine). Ein Eintrag hat einen Würfelbereich (`min_roll`, `max_roll`, NULL = offen nach oben), optional `bestiary_id` mit `quantity_de` ("W3") und optional einen Text.
- **`catalog_items.weight`:** Traglast-Gewicht (Standard 1, 0 = Kleinkram, 0,25 = Tagesration, bis 4 für schwere Gegenstände).
- **`catalog_roll_tables`** und **`catalog_roll_table_rows`:** allgemeine Wurftabellen des Regelwerks (Reise-Missgeschicke, Jagd, improvisierte Waffen, Schätze, NSC erschaffen). `group_de` gruppiert auf `/rules`, `headers_de` enthält die Spaltenköpfe (Trenner `|`). Die App würfelt nie, die Tabellen werden nur angezeigt.
- **`characters.death_successes`, `death_failures`, `memento_used`:** Todeswürfe bei 0 TP (zurückgesetzt, sobald TP > 0) und "Memento in dieser Sitzung benutzt" (Reset durch die SL, `POST /dm/party/session-end`). **`character_injuries`:** Verletzungen am Charakter, aus `catalog_injuries` gewählt (nicht gewürfelt), "Geheilt" löscht die Zeile.
- **`catalog_services`:** Dienstleistungen (Bad, Unterkunft, Leibwächter) mit Preis und Einheit. Tiere stehen als Items (Reittiere, Lasttiere) und im Bestiarium (Kategorie Tier).
- Alles Übrige (Skills, Berufe, Kins, Zauber, Wounded table `catalog_injuries` usw.) ist unverändert.
- Entfallen: `catalog_locations` (Orte gehören der Kampagne), `catalog_items.dm_text_de`.

## Kampagne

- **`campaigns`**, **`campaign_chapters`**, **`campaign_bestiary`** (welche Vorlagen die Kampagne benutzt): unverändert.
- **`campaign_places`:** Orte der Kampagne. `parent_id` (Ort in Ort), `chapter_id` (optional), `position` und `number_label` (Reihenfolge und Nummer auf der Karte, "#5"; Orte mit Nummer erscheinen im Kapitel), `name_de`, `description_de` (vorlesbar), `dm_text_de` (kurze DM-Beschreibung), `image_path`, `encounter_table_id` (Katalog-Begegnungstabelle).
- **`campaign_items`:** Story-Items. `name_de`, `description_de`, `dm_text_de`, `text_de` (Buch oder Brief), `image_path`. Fundort: `place_id` und/oder `found_hint_de`. Optional `chapter_id`.
- **`campaign_npcs`:** `name_de`, `description_de`, `dm_text_de`, `notes_de` (Spielnotizen), `bestiary_id` (optional, Kampfwerte), `portrait_path`. Fundort für Quest-NPCs: `place_id` und/oder `found_hint_de`.
- **`campaign_chronicle`:** `title_de` (optional), `text_de`, `created_at`.
- Entfallen: `campaign_locations` (die Räume sind jetzt Orte mit `number_label`), `campaign_event_tables` und `campaign_event_table_entries` (ersetzt durch Katalog-Begegnungstabellen).

## Charakter ↔ Kampagne

Keine Verbindung. Ein gefundenes Item wird später als Text (Name, Beschreibung) in `character_inventory` kopiert.

`characters.memory_de` ist das "Gedächtnis": privater Freitext des Spielers pro Charakter (Route `POST /character/{id}/memory`, wird beim Tippen automatisch gespeichert). Die Liste "Meine Charaktere" lebt nur im Browser (`localStorage`), nicht in der DB.

## Neustart

`CampaignRepository::restart` leert `campaign_chronicle` und setzt `campaign_npcs.notes_de` auf NULL (eine Transaktion). Inhalt und Katalog bleiben unberührt.

## Migrationen

Die Datenbank besteht nur aus den Migrationen in `database/migrations/` (kein Init-Script mehr). `bin/migrate.php` (läuft im Deploy und lokal nach `dcud`) wendet offene Dateien in Reihenfolge an und führt sie in `schema_migrations`. Header: `-- skip-if: <SELECT>` (Änderung ist schon da, nur eintragen), `-- abort-if: <SELECT>` (Abbruch, z. B. bei Kollision von Ids). Die Tests bauen ihre Datenbank aus allen Dateien.

Stand 2026-10-17: Die Produktion wurde neu aufgesetzt, die Baseline sind vier Dateien (nie wieder ändern, spätere Änderungen kommen als neue Migration ab `0005`):

- `0001_schema.sql`: alle Tabellen. Bricht ab, wenn die Datenbank schon Tabellen hat.
- `0002_catalog.sql`: Katalog (alle `catalog_*`-Tabellen): Regelwerk, Items, Bestiary inkl. Abenteuer-Monster, Begegnungstabellen, Wurftabellen (auch die Schatztabellen) und die zentralen Regeltexte `catalog_rules`. Id 3 in `catalog_bestiary` bleibt bewusst frei (Portrait `images/creatures/3.jpg` der Dame des Hügels, die den allgemeinen Geist nutzt).
- `0003_default_characters.sql`: Aodhan und die 7 Quickstart-Pregens (Ids 1–8).
- `0004_default_campaigns.sql`: Standard-Kampagnen Ridderhöhe (1), Der Versinkende Turm (2) und Die Burg des Raubritters (4). Ridderhöhe und Der Versinkende Turm: Die Räume sind Orte unter einem Hauptort (Ridderhöhe, Magdalas Turm), die Turm-Stockwerke haben ihr Bild. Die zwei Zufallsereignis-Tabellen von Ridderhöhe stehen als Text in den DM-Beschreibungen der Orte #1 und #4.

### Zentrale Regeltexte

Alle Regeltexte stehen in der Datenbank, nicht in den Templates:

- `catalog_rules`: jede Regel genau einmal (`code`, `title_de`, `badge_de`, `badge_style`, `search_de`, `summary_de`, `body_de`). `body_de` ist HTML, `[[NAME]]` sind Platzhalter, die die Seite füllt (z. B. die Waffenfertigkeiten beim Schadensbonus). `summary_de` ist die Kurzfassung für Hinweise am Bogen.
- `catalog_rule_sections`: Abschnitte mit Überschrift und optionalem Einleitungstext (`/rules`: Tabs Grundregeln, Kampf, Magie, Charakter; SL-Regeln: ein Abschnitt je Kapitel `dm_<kapitel>`, ohne Überschrift).
- `catalog_rule_placements`: welche Regel in welchem Abschnitt an welcher Position steht und wie sie erscheint (`quick` = Regel, `dm` = nur für die SL, `entry` = Eintrag mit eigener Suche). Eine Regel kann an mehreren Stellen stehen, etwa die Sitzungsende-Fragen unter `/rules` und in den SL-Regeln.

Die Templates holen sie mit dem Macro `r.section('<abschnitt>')` (`templates/rules/_macros.twig`, Twig-Funktion `rule_section` in `Application`) oder mit `rule_summary('<code>')` für Kurztexte am Charakterbogen und im Level-up. Was aus anderen Tabellen kommt (Rasten, Gefahren, Zauberliste, Völker, Berufe, Fertigkeiten, Ausrüstung, Wurftabellen), bleibt dynamisch im Template. Eine Regel ändern heißt: die Zeile in `catalog_rules` ändern, alle Seiten folgen. `CentralRulesTest` sorgt dafür, dass kein Regeltext mehr in `rules.twig` oder `dm/chapters/rules.twig` steht und alle Seiten den Text aus der Datenbank zeigen.

## Auswirkungen auf den Code

- `backend/src/Repository/CampaignPlaceRepository.php`: Orte (`places`, `createPlace`, `updatePlace`, `locations` = nummerierte Orte der Kapitel), `items`, `encounterTables`, NPC-CRUD, `restart()`.
- `backend/src/RulesRepository.php` und `backend/templates/rules.twig`: Seite `/rules`, das Regelwerk zum Nachschlagen für Spieler (Items, Fertigkeiten, Zauber, Berufe, Völker, Heldenfähigkeiten, Tabellen). Ohne Bestiary und Begegnungstabellen.
- `backend/src/WorldRepository.php` und `backend/templates/dm/catalog.twig`: Seite `/dm/catalog` (nur DM) mit Bestiary und Zufallsbegegnungen. Der DM-Bereich liegt komplett unter `/dm` und ist per DM-Passwort gesperrt (`DmAuth`, `DmGate`, siehe `docs/UX-KONZEPT.md`); die alten URLs `/campaign` und `/world` leiten dorthin um.
- `backend/routes/dm_campaign.php`: alle DM-Routen der Kampagnen (Liste, Planen, Spielen, Anlegen/Ändern/Löschen von Kampagne, Kapiteln, Orten, NPCs, Items, Monstern und Chronik, Neustart). Alles unter `/dm`, also hinter `DmGate`.
- `backend/templates/campaign/`: `list.twig` (Kampagnen), `plan.twig` mit `edit/*.twig` (Planen: Gliederung links, Editor rechts, `?e=place-12` wählt den Eintrag), `play.twig` (Spielen: Schnellzugriff, Tabs Lesen, Chronik, Würfeln), `_cards.twig` (Karten in den Dialogen), `_mode.twig` (Umschalter Planen/Spielen).
- `backend/public/js/dm-forms.js` (generische Formulare, Löschen, Notizen-Autosave per `data-*`-Attribute) und `campaign-play.js` (Schnellzugriff, Dialog, Würfel, Chronik).

## Offen

- "Item ins Inventar eines Charakters übernehmen" ist noch nicht gebaut.
- NPC-Generator und Schnell-Encounter (Spielen-Modus) stehen noch aus.

## Ergänzungen Teilprojekt 4

- `catalog_bestiary.image_path`: optionales Bild der Vorlage (`images/bestiary/<id>.<ext>`).
- `dm_party(character_id, added_at)`: Merkliste des DMs für die Gruppenübersicht, ohne Verbindung zu Kampagnen; `ON DELETE CASCADE` vom Charakter.
