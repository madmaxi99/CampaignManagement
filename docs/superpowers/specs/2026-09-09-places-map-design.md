# Orte & interaktive Karte — Design

## Context

Der Nutzer möchte Orte im Wiki nicht nur als Lore-Text, sondern als klickbare, hierarchische Karte abbilden (Weltebene → Städte-Ebene → einzelne Gebäude, Tiefe ist beliebig). NPCs sollen später einem Ort zugeordnet werden können (bewusst zurückgestellt, kein Teil dieser Spec).

Diese Runde wurde bewusst aus dem generischen "Tabelle-pro-Kategorie"-CRUD-Muster (siehe `2026-09-09-dm-wiki-design.md`) herausgelöst, weil Orte drei Dinge brauchen, die die bisherigen 5 Kategorien nicht hatten: Datei-Upload, eine Eltern-Kind-Hierarchie und eine interaktive, klickbare Darstellung. Erkenntnis aus dem Brainstorming: **Karte und Orte-Lore-Eintrag sind dasselbe Ding** — ein Ort hat optional ein Bild (= seine "Karte") und optional einen Eltern-Ort; die "Karte" einer Stadt ist einfach die Detailansicht dieses Orts mit seinem Bild und Pins für alle Orte, die ihn als Eltern haben.

Es gibt in diesem Projekt noch keinen Datei-Upload — dieser wird hier erstmalig eingeführt.

## Datenmodell

Eine Tabelle `places`:

| Spalte | Typ | Beschreibung |
|---|---|---|
| `id` | `INTEGER PRIMARY KEY AUTOINCREMENT` | |
| `name` | `TEXT NOT NULL` | Pflichtfeld |
| `description` | `TEXT` | Lore-Text |
| `parent_id` | `INTEGER` (nullable) | Verweist auf `places.id`. `NULL` = Wurzel-Ort (z. B. eine Weltkarte). Es kann mehrere Wurzel-Orte geben. |
| `image_path` | `TEXT` (nullable) | Relativer Pfad unter `public/uploads/places/`, z. B. `a1b2c3d4.png` |
| `pin_x` | `REAL` (nullable) | Prozent-Position (0–100) auf dem Bild des **Eltern**-Orts, horizontal |
| `pin_y` | `REAL` (nullable) | Prozent-Position (0–100) auf dem Bild des **Eltern**-Orts, vertikal |
| `created_at` / `updated_at` | `TEXT NOT NULL` | wie in den bestehenden Wiki-Tabellen |

Prozent-Koordinaten statt Pixel, damit die Pin-Position unabhängig von der tatsächlich ausgelieferten Bildgröße/Skalierung im Browser korrekt bleibt.

`pin_x`/`pin_y` sind nur sinnvoll befüllt, wenn `parent_id` gesetzt ist UND der Eltern-Ort ein Bild hat. Ein Kind-Ort ohne diese Werte (weil der Eltern-Ort z. B. noch kein Bild hat) ist trotzdem gültig — er erscheint dann nur in der Fallback-Liste, nicht als Pin.

Diese Tabelle wird **nicht** über `WikiCategories`/`WikiRepository` verwaltet — eigene, dedizierte Klasse (`PlacesRepository`), da Hierarchie-Queries (Kinder eines Orts, Root-Orte) und Bild-Handling über das generische Schema hinausgehen.

## Bild-Upload

- Formular nutzt `enctype="multipart/form-data"`, PHP-Seite liest die Datei über `$request->getUploadedFiles()['image']` (PSR-7 `UploadedFileInterface`, von Slim bereitgestellt — kein zusätzliches Composer-Paket nötig).
- Validierung: MIME-Typ muss `image/png`, `image/jpeg` oder `image/webp` sein (geprüft über `finfo` auf den tatsächlichen Dateiinhalt, nicht nur den vom Client gesendeten Content-Type-Header); Dateigröße max. 8 MB. Bei Verstoß: zurück zum Formular mit Fehlermeldung, kein Speichern.
- Speicherort: `backend/public/uploads/places/` (wird bei Bedarf per `mkdir` angelegt, wie schon `var/data/` beim SQLite-Smoketest). Dateiname: `bin2hex(random_bytes(8))` + Original-Dateiendung — verhindert Kollisionen, kein Bezug zum Original-Dateinamen nötig.
- Ausgeliefert wird das Bild direkt von nginx als statische Datei unter `/uploads/places/{filename}` (liegt im ohnehin `:ro` gemounteten `backend`-Verzeichnis, keine neue nginx-Konfiguration nötig, da `root /var/www/html/public` bereits alles unter `public/` bedient).
- Bild ist beim Anlegen/Bearbeiten optional. Beim Bearbeiten ohne neue Datei bleibt das bestehende `image_path` unverändert (kein versehentliches Löschen).
- Liste und Formular zeigen eine Thumbnail-Vorschau des aktuell hinterlegten Bilds (`<img>`, per CSS auf z. B. 120px Breite begrenzt), damit erkennbar ist, welches Bild an welchem Ort hängt.

## Navigation / Ansichten

Eigene Templates unter `backend/templates/places/` (nicht die generischen `wiki/list.twig`/`wiki/form.twig`, da Hierarchie + Bild + Pins strukturell anders sind):

- **`GET /dm/wiki/places`** — Liste der Wurzel-Orte (`parent_id IS NULL`), reiht sich in die bestehende Tab-Navigation (`wiki/_tabs.twig`) ein wie die anderen 5 Kategorien. Je Eintrag: Thumbnail (falls vorhanden) + Name, Link zur Detailansicht. "+ Neu anlegen" legt einen Wurzel-Ort an.
- **`GET /dm/wiki/places/{id}`** — Detailansicht:
  - Breadcrumb (Welt → Stadt → …, aus der `parent_id`-Kette aufgebaut)
  - Name, Beschreibung
  - Falls `image_path` gesetzt: Bild, darüber als CSS-`position: absolute`-Overlay ein Pin pro Kind-Ort, der `pin_x`/`pin_y` gesetzt hat; Klick auf einen Pin navigiert zur Detailansicht des Kind-Orts
  - Kind-Orte **ohne** Pin-Position (weil kein Eltern-Bild vorhanden war, als sie angelegt wurden) erscheinen zusätzlich als einfache Text-Liste darunter
  - "+ Neuen Kind-Ort anlegen"-Link (→ `places/new?parent_id={id}`), "Bearbeiten"-Link
- **`GET /dm/wiki/places/new`** (optional `?parent_id={id}`) — Anlegen-Formular: Name, Beschreibung, Bild-Upload. Falls `parent_id` gesetzt UND der Eltern-Ort ein Bild hat: das Eltern-Bild wird angezeigt, ein Klick darauf setzt per kleinem Vanilla-JS die (versteckten) Felder `pin_x`/`pin_y` auf die Klick-Position in Prozent. Ohne Eltern-Bild (oder ohne `parent_id`, also Wurzel-Ort) entfällt der Pin-Picker einfach.
- **`POST /dm/wiki/places`** — Insert; Pflichtfeld-Validierung wie bei den anderen Kategorien (leerer `name` → zurück zum Formular mit Fehler); ungültiges `parent_id` (existiert nicht) → 404.
- **`GET /dm/wiki/places/{id}/edit`** — Bearbeiten-Formular, vorbefüllt, inkl. Bild-Vorschau; optional neues Bild hochladen (ersetzt altes); falls der Ort einen Eltern-Ort mit Bild hat, ist auch hier der Pin-Picker verfügbar, vorbefüllt mit der aktuellen Pin-Position.
- **`POST /dm/wiki/places/{id}`** — Update, gleiche Validierung.

Unbekannte `{id}` in jeder dieser Routen → 404.

## Frontend (Pin-Picker)

Kleines Vanilla-JS-Snippet (kein Alpine/Framework nötig für diesen einen Anwendungsfall): Klick-Handler auf dem Eltern-Bild berechnet `(clickX / bildBreite) * 100` und `(clickY / bildHöhe) * 100`, schreibt die Werte in zwei `<input type="hidden">`-Felder (`pin_x`, `pin_y`) und zeigt zusätzlich einen visuellen Marker an der geklickten Stelle zur sofortigen Bestätigung.

## Fehlerbehandlung

- `name` leer → Formular mit Fehlermeldung (Muster wie bestehende Kategorien).
- Hochgeladene Datei ist kein gültiges Bild oder zu groß → Formular mit Fehlermeldung, nichts wird gespeichert.
- `parent_id` verweist auf nicht-existierenden Ort → 404.
- Unbekannte `{id}` bei Detail/Bearbeiten → 404.
- Kein Upload-Ordner vorhanden → wird beim ersten Bedarf automatisch angelegt (wie `var/data/` im bestehenden Code).

## Testing / Verifikation

- `docker compose up` (bestehende Provisioning, kein neuer Service).
- Wurzel-Ort ohne Bild anlegen ("Kontinent Aschgard") → erscheint in `/dm/wiki/places`.
- Zweiten Ort mit Bild anlegen, `parent_id` = erster Ort, aber erster Ort hat noch kein Bild → Kind-Ort wird trotzdem gespeichert (ohne Pin), erscheint in der Fallback-Liste der Eltern-Detailansicht.
- Danach ein Bild zum ersten Ort nachträglich hinzufügen (Bearbeiten) → Bild erscheint in der Detailansicht.
- Dritten Ort anlegen mit `parent_id` = erster Ort (jetzt mit Bild) → Pin-Picker erscheint im Formular, Klick setzt `pin_x`/`pin_y`, nach dem Speichern erscheint der Pin auf der Eltern-Karte an der geklickten Stelle.
- Ungültige Datei (z. B. eine `.txt`-Datei) hochladen → Formular zeigt Fehler, kein Datensatz wird angelegt.
- Unbekannte `place`-ID in der URL → 404.
- Breadcrumb-Navigation über mindestens 3 Ebenen (Welt → Stadt → Gebäude) manuell durchklicken.
