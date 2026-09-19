# DM-Bereich + Wiki (Kompendium) — Design

## Context

Die App braucht einen Einstiegspunkt für den DM (Dungeon Master), von dem aus er später Kampagnen verwalten und jetzt zuerst ein Lore-Wiki/Kompendium pflegen kann (Bestiarium, Items, Zauberbücher, Relikte, Bücher — basierend auf Cairn 2e mit ein paar Homebrew-Anpassungen). Ziel dieser Runde: DM-Einstieg (Button + Zwischenseite) und das Wiki für eine erste Auswahl an Kategorien, End-to-End (Liste anzeigen, Eintrag anlegen, Eintrag bearbeiten).

Kampagnen-Verwaltung selbst ist explizit **nicht** Teil dieser Runde — nur ein Platzhalter-Kachel dafür. Weitere Lore-Kategorien (Orte, Fraktionen, NPCs, einzelne Zauber) sind ebenfalls nicht Teil dieser Runde, aber die Architektur ist so angelegt, dass sie danach nach demselben Muster ergänzt werden können.

Der Wiki-Inhalt ist **global**, nicht pro Kampagne (Entscheidung des Nutzers) — kein `campaign_id`-Bezug nötig.

## Architektur

**Eine echte Datenbanktabelle pro Kategorie** (kein generisches JSON-Catch-all-Schema) — der Nutzer möchte pro Kategorie strukturell passende Spalten (z. B. Bestiarium mit HP/Armor/Attack/Morale, Bücher mit Sprache). Um trotz vieler künftiger Kategorien nicht bei jeder neuen Kategorie kompletten CRUD-Code zu duplizieren, gibt es eine schlanke gemeinsame Schicht:

- **Kategorie-Konfiguration** (PHP-Array, `backend/src/WikiCategories.php` o. ä.): pro Kategorie Tabellenname, Slug (URL-Segment), Label, Spaltenliste mit `{name, label, type}` (`type` ∈ `text`, `textarea`, `number`).
- **Generisches Repository** (`WikiRepository`, PDO-basiert): `listAll(table)`, `find(table, id)`, `insert(table, columns, data)`, `update(table, columns, id, data)` — parametrisiert über die Spaltenliste aus der Konfiguration, kein kategorie-spezifischer DB-Code.
- **Generische Twig-Templates**: eine Listen-Ansicht (Tabelle mit den konfigurierten Spalten) und eine Formular-Ansicht (Eingabefeld pro Spalte, `textarea` für Lore-Text, `number` für HP/Armor/Attack), beide gesteuert durch dieselbe Kategorie-Konfiguration.
- **Ein generischer Controller/Router-Block** in `index.php` (oder eigene Datei `wiki.php`, per `require` eingebunden) behandelt `/dm/wiki/{category}` (Liste), `/dm/wiki/{category}/new` (Formular + POST-Insert), `/dm/wiki/{category}/{id}/edit` (Formular + POST-Update) generisch anhand der Kategorie aus der URL — kein eigener Satz Routen pro Kategorie.

Diese Struktur hält die Datenbank "ehrlich" pro Kategorie, vermeidet aber n-fachen CRUD-Code für n Kategorien.

## Datenmodell (erste Runde)

Alle Tabellen zusätzlich mit `id INTEGER PRIMARY KEY AUTOINCREMENT`, `created_at`, `updated_at` (Self-Init via `CREATE TABLE IF NOT EXISTS`, wie beim bestehenden Smoketest).

| Tabelle | Slug | Spalten (zusätzlich zu id/timestamps) |
|---|---|---|
| `bestiary` | `bestiary` | `name` (text), `hp` (number), `armor` (number), `attack` (text — Schaden/Waffe als Kurztext), `morale` (number), `moves` (textarea — Fähigkeiten, mehrzeilig), `description` (textarea) |
| `items` | `items` | `name` (text), `description` (textarea), `effect` (textarea) |
| `spellbooks` | `spellbooks` | `name` (text), `description` (textarea — enthaltene Zaubersprüche als Text) |
| `relics` | `relics` | `name` (text), `description` (textarea), `effect` (textarea) |
| `books` | `books` | `title` (text), `language` (text), `content` (textarea) |

Kein `image`-Feld in dieser ersten Runde (YAGNI — Bild-Upload/-Speicherung ist ein eigenes Thema, kein Blocker für den Wiki-Smoketest).

`language` an `books` wird jetzt schon gespeichert; die "Kauderwelsch, wenn Charakter die Sprache nicht kennt"-Logik ist bewusst zurückgestellt, bis es ein Charakterbogen-Feature gibt, das Sprachen pro Charakter trackt.

## Navigation / Routen

- `GET /` (Homepage, bestehende `hello.twig` wird zur echten Homepage oder durch eine neue `home.twig` ersetzt) — neuer Button **"DungeonMaster"** → `/dm`
- `GET /dm` — Zwischenseite mit zwei Kacheln: "Kampagne verwalten" (visuell erkennbar deaktiviert/Platzhalter, kein Link-Ziel) und **"Wiki"** → `/dm/wiki`
- `GET /dm/wiki` — Übersicht mit Reitern für die 5 Kategorien, Default-Reiter z. B. Bestiarium
- `GET /dm/wiki/{category}` — Liste der Einträge dieser Kategorie + Link "Neu anlegen"
- `GET /dm/wiki/{category}/new`, `POST /dm/wiki/{category}` — Formular / Anlegen
- `GET /dm/wiki/{category}/{id}/edit`, `POST /dm/wiki/{category}/{id}` — Formular / Bearbeiten
- Unbekannte `{category}` → 404

## Fehlerbehandlung

- Ungültiges/unbekanntes `category`-Segment in der URL → 404-Antwort statt Fatal Error.
- Pflichtfeld `name`/`title` leer beim Insert/Update → zurück zum Formular mit Fehlermeldung (kein stiller Datenverlust), analog zum bestehenden Post/Redirect/Get-Muster im Smoketest.
- `number`-Felder (hp/armor/morale): leere Eingabe wird als `NULL` gespeichert statt Fehler zu werfen (nicht jedes Bestiarium-Monster braucht zwingend alle Werte ausgefüllt).

## Testing / Verifikation

- `docker compose up` (bestehende Provisioning) — kein neuer Service nötig, nur neue PHP-Dateien/Templates im bestehenden `backend/`-Bind-Mount.
- Für jede der 5 Kategorien: Liste anzeigen (leer) → "Neu anlegen" → Formular absenden → Eintrag erscheint in der Liste → "Bearbeiten" → Änderung speichern → aktualisierter Wert erscheint in der Liste.
- Bestiarium: `number`-Felder leer lassen beim Anlegen → kein Fehler, Eintrag wird trotzdem gespeichert.
- Unbekannte Kategorie in der URL (`/dm/wiki/does-not-exist`) → 404 statt Fatal Error.
- Homepage → "DungeonMaster"-Button → `/dm` → "Wiki"-Kachel → `/dm/wiki` klickbar durchspielen.
