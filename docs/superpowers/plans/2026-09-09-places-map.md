# Orte & interaktive Karte Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Orte im Wiki werden hierarchisch (Welt → Stadt → Gebäude) mit optionalem Bild abgebildet; das Bild eines Orts fungiert als interaktive Karte mit anklickbaren Pins zu seinen Kind-Orten.

**Architecture:** Eigene Tabelle `places` mit `parent_id`-Selbstreferenz, eigenes `PlacesRepository` (nicht das generische `WikiRepository`, wegen Hierarchie-Queries), eigene Templates unter `backend/templates/places/`. Echter Datei-Upload über PSR-7 `UploadedFileInterface`, validiert und gespeichert durch eine kleine `PlaceImageStorage`-Klasse. Pin-Position wird per Klick auf das Eltern-Bild via Vanilla-JS gesetzt (Prozent-Koordinaten in zwei Hidden-Inputs).

**Tech Stack:** PHP 8.3, Slim 4, Twig, PDO/SQLite, PSR-7 File-Uploads (bereits über `slim/psr7` verfügbar, kein neues Composer-Paket). Vanilla JS für den Pin-Picker.

**Spec:** `docs/superpowers/specs/2026-09-09-places-map-design.md`

## Global Constraints

- Keine `git commit`-Schritte (kein Git-Repository vorhanden; Nutzer-Regel: Commits nur auf explizite Anforderung, gilt projektübergreifend).
- Kein neues Test-Framework — Verifikation über `curl` gegen den laufenden Container (Port 8090), wie in den bisherigen Plänen dieses Projekts.
- Mehrzeilige SQL-Strings als Heredoc (`<<<SQL ... SQL;`).
- MIME-Prüfung des Uploads über den tatsächlichen Dateiinhalt (`finfo`), niemals über den vom Client gesendeten `Content-Type`-Header.
- Prozent-Koordinaten (0–100) für `pin_x`/`pin_y`, relativ zum **Eltern**-Bild.
- Parent-Zuordnung eines Orts ist nach dem Anlegen nicht änderbar (Spec verlangt das nicht explizit — bewusste Vereinfachung, um Re-Parenting-Logik/Konsistenzfragen aus dem Scope zu halten).
- Bezeichner/Code auf Englisch, UI-Text auf Deutsch (bestehende Konvention).

---

### Task 1: Tab-Navigation um "Orte" erweitern

**Files:**
- Modify: `backend/src/WikiCategories.php`
- Modify: `backend/public/index.php` (alle bestehenden Wiki-Render-Aufrufe)

**Interfaces:**
- Produces: `WikiCategories::tabs(): array` — gibt `['<slug>' => ['label' => string], ...]` zurück, für alle 5 bestehenden Kategorien plus `'places' => ['label' => 'Orte']`. `wiki/_tabs.twig` braucht keine Änderung (erwartet bereits `tab_slug`/`tab_config.label`).

- [ ] **Step 1: `tabs()`-Methode ergänzen** (in `WikiCategories.php`, nach `find()`)

```php
    public static function tabs(): array
    {
        $tabs = [];

        foreach (self::CATEGORIES as $slug => $config) {
            $tabs[$slug] = ['label' => $config['label']];
        }

        $tabs['places'] = ['label' => 'Orte'];

        return $tabs;
    }
```

- [ ] **Step 2: Bestehende Render-Aufrufe in `index.php` umstellen**

In `backend/public/index.php` kommt `'categories' => WikiCategories::CATEGORIES,` fünfmal vor (Liste, Neu-Formular, Insert-Fehler, Bearbeiten-Formular, Update-Fehler). Alle fünf Vorkommen ersetzen durch:

```php
'categories' => WikiCategories::tabs(),
```

- [ ] **Step 3: Syntax-Check**

Run: `docker compose exec php-fpm php -l public/index.php`
Expected: `No syntax errors detected`

- [ ] **Step 4: Verifikation**

Run: `curl -s http://localhost:8090/dm/wiki/bestiary | grep -o 'Orte'`
Expected: `Orte` (Tab-Link erscheint jetzt in der Navigation, auch wenn `/dm/wiki/places` noch nicht existiert — das ist für diesen Task erwartet)

---

### Task 2: `PlacesRepository` + Schema

**Files:**
- Create: `backend/src/PlacesRepository.php`
- Modify: `backend/public/index.php` (require + Instanziierung + `ensureTable()`-Aufruf)

**Interfaces:**
- Consumes: bestehende `$db` (PDO-Instanz).
- Produces: `PlacesRepository::__construct(PDO $db)`, `ensureTable(): void`, `roots(): array`, `children(int $placeId): array`, `find(int $id): ?array`, `insert(array $data): int` (gibt neue ID zurück), `update(int $id, array $data): void`, `breadcrumb(int $id): array` (Array von Orten, Wurzel zuerst, `$id`-Ort zuletzt). `$data` für `insert`/`update` erwartet die Keys `name`, `description`, `parent_id`, `image_path`, `pin_x`, `pin_y`.

- [ ] **Step 1: Datei erstellen**

```php
<?php

declare(strict_types=1);

final class PlacesRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function ensureTable(): void
    {
        $this->db->exec(<<<SQL
            CREATE TABLE IF NOT EXISTS places (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT,
                parent_id INTEGER,
                image_path TEXT,
                pin_x REAL,
                pin_y REAL,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            )
            SQL);
    }

    public function roots(): array
    {
        $stmt = $this->db->query('SELECT * FROM places WHERE parent_id IS NULL ORDER BY id DESC');

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function children(int $placeId): array
    {
        $stmt = $this->db->prepare('SELECT * FROM places WHERE parent_id = :parent_id ORDER BY id DESC');
        $stmt->execute(['parent_id' => $placeId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function find(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM places WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        return $row === false ? null : $row;
    }

    public function insert(array $data): int
    {
        $now = (new DateTimeImmutable())->format('Y-m-d H:i:s');

        $stmt = $this->db->prepare(<<<SQL
            INSERT INTO places (name, description, parent_id, image_path, pin_x, pin_y, created_at, updated_at)
            VALUES (:name, :description, :parent_id, :image_path, :pin_x, :pin_y, :created_at, :updated_at)
            SQL);

        $stmt->execute([
            'name' => $data['name'],
            'description' => $data['description'],
            'parent_id' => $data['parent_id'],
            'image_path' => $data['image_path'],
            'pin_x' => $data['pin_x'],
            'pin_y' => $data['pin_y'],
            'created_at' => $now,
            'updated_at' => $now,
        ]);

        return (int) $this->db->lastInsertId();
    }

    public function update(int $id, array $data): void
    {
        $stmt = $this->db->prepare(<<<SQL
            UPDATE places
            SET name = :name, description = :description, parent_id = :parent_id,
                image_path = :image_path, pin_x = :pin_x, pin_y = :pin_y, updated_at = :updated_at
            WHERE id = :id
            SQL);

        $stmt->execute([
            'name' => $data['name'],
            'description' => $data['description'],
            'parent_id' => $data['parent_id'],
            'image_path' => $data['image_path'],
            'pin_x' => $data['pin_x'],
            'pin_y' => $data['pin_y'],
            'updated_at' => (new DateTimeImmutable())->format('Y-m-d H:i:s'),
            'id' => $id,
        ]);
    }

    public function breadcrumb(int $id): array
    {
        $chain = [];
        $current = $this->find($id);

        while ($current !== null) {
            array_unshift($chain, $current);
            $current = $current['parent_id'] !== null ? $this->find((int) $current['parent_id']) : null;
        }

        return $chain;
    }
}
```

- [ ] **Step 2: In `index.php` einbinden** (direkt nach dem bestehenden `foreach (WikiCategories::CATEGORIES ...)`-Block)

```php
require __DIR__ . '/../src/PlacesRepository.php';

$placesRepository = new PlacesRepository($db);
$placesRepository->ensureTable();
```

- [ ] **Step 3: Syntax-Check + Tabellen-Check**

Run: `docker compose exec php-fpm php -l src/PlacesRepository.php`
Expected: `No syntax errors detected`

Run: `docker compose restart php-fpm && sleep 1 && curl -s -o /dev/null http://localhost:8090/ && docker compose exec php-fpm php -r '$db = new PDO("sqlite:var/data/app.sqlite"); foreach ($db->query("SELECT name FROM sqlite_master WHERE type = \"table\"") as $row) { echo $row["name"] . PHP_EOL; }' | grep places`
Expected: `places`

---

### Task 3: `PlaceImageStorage` (Upload-Validierung + Speicherung)

**Files:**
- Create: `backend/src/PlaceImageStorage.php`

**Interfaces:**
- Consumes: `Psr\Http\Message\UploadedFileInterface` (von Slim/PSR-7 bereitgestellt, `slim/psr7` ist bereits Composer-Dependency).
- Produces: `PlaceImageStorage::store(?UploadedFileInterface $file): ?string` — gibt `null` zurück, wenn keine Datei hochgeladen wurde; gibt den generierten Dateinamen zurück bei Erfolg; wirft `InvalidArgumentException` mit einer für Endnutzer verständlichen deutschen Fehlermeldung bei ungültigem Upload.

- [ ] **Step 1: Datei erstellen**

```php
<?php

declare(strict_types=1);

use Psr\Http\Message\UploadedFileInterface;

final class PlaceImageStorage
{
    private const ALLOWED_MIME_TYPES = [
        'image/png' => 'png',
        'image/jpeg' => 'jpg',
        'image/webp' => 'webp',
    ];

    private const MAX_BYTES = 8 * 1024 * 1024;

    public static function store(?UploadedFileInterface $file): ?string
    {
        if ($file === null || $file->getError() === UPLOAD_ERR_NO_FILE) {
            return null;
        }

        if ($file->getError() !== UPLOAD_ERR_OK) {
            throw new InvalidArgumentException('Der Datei-Upload ist fehlgeschlagen.');
        }

        if ($file->getSize() === null || $file->getSize() > self::MAX_BYTES) {
            throw new InvalidArgumentException('Die Datei ist zu groß (max. 8 MB).');
        }

        $stream = $file->getStream();
        $stream->rewind();
        $contents = $stream->getContents();

        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = (string) finfo_buffer($finfo, $contents);
        finfo_close($finfo);

        if (!array_key_exists($mimeType, self::ALLOWED_MIME_TYPES)) {
            throw new InvalidArgumentException('Nur PNG-, JPEG- oder WebP-Bilder sind erlaubt.');
        }

        $uploadDir = __DIR__ . '/../public/uploads/places';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0775, true);
        }

        $filename = bin2hex(random_bytes(8)) . '.' . self::ALLOWED_MIME_TYPES[$mimeType];
        $file->moveTo($uploadDir . '/' . $filename);

        return $filename;
    }
}
```

- [ ] **Step 2: Syntax-Check**

Run: `docker compose exec php-fpm php -l src/PlaceImageStorage.php`
Expected: `No syntax errors detected`

- [ ] **Step 3: In `index.php` einbinden** (nach dem `PlacesRepository`-Require aus Task 2)

```php
require __DIR__ . '/../src/PlaceImageStorage.php';
```

Run: `docker compose exec php-fpm php -l public/index.php`
Expected: `No syntax errors detected`

---

### Task 4: Orte-Liste (Route + Template)

**Files:**
- Create: `backend/templates/places/list.twig`
- Modify: `backend/public/index.php` (neue Route)
- Modify: `backend/public/css/style.css` (Thumbnail-Style)

**Interfaces:**
- Consumes: `$placesRepository->roots(): array` (Task 2).
- Produces: Route `GET /dm/wiki/places` — rendert `places/list.twig` mit `slug = 'places'`, `categories`, `places`.

- [ ] **Step 1: Template erstellen**

```twig
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Orte — Wiki</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <main class="page">
        <h1>Orte</h1>
        {% include 'wiki/_tabs.twig' %}

        <p class="wiki-actions"><a href="/dm/wiki/places/new" class="wiki-new-link">+ Neu anlegen</a></p>

        <ul class="wiki-entries">
            {% for place in places %}
                <li>
                    <a href="/dm/wiki/places/{{ place.id }}">
                        {% if place.image_path %}
                            <img src="/uploads/places/{{ place.image_path }}" alt="" class="place-thumb">
                        {% endif %}
                        {{ place.name }}
                    </a>
                </li>
            {% else %}
                <li class="entry-empty">Noch keine Orte.</li>
            {% endfor %}
        </ul>
    </main>
</body>
</html>
```

- [ ] **Step 2: Route in `index.php` ergänzen** (vor `$app->run();`)

```php
$app->get('/dm/wiki/places', function ($request, $response) use ($twig, $placesRepository) {
    return $twig->render($response, 'places/list.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'places' => $placesRepository->roots(),
    ]);
});
```

- [ ] **Step 3: CSS ergänzen** (ans Ende von `style.css` anhängen)

```css
.place-thumb {
    max-width: 120px;
    max-height: 120px;
    display: block;
    border-radius: 3px;
    margin-bottom: 0.3rem;
}
```

- [ ] **Step 4: Verifikation**

Run: `curl -s http://localhost:8090/dm/wiki/places | grep -o 'Noch keine Orte'`
Expected: `Noch keine Orte`

Run: `curl -s http://localhost:8090/dm/wiki/bestiary | grep -oE 'href="/dm/wiki/places"'`
Expected: `href="/dm/wiki/places"` (Tab-Link führt jetzt zu einer echten Seite)

---

### Task 5: Ort anlegen (Formular + Pin-Picker + POST)

**Files:**
- Create: `backend/templates/places/form.twig`
- Create: `backend/public/js/pin-picker.js`
- Modify: `backend/public/index.php` (zwei neue Routen)
- Modify: `backend/public/css/style.css` (Formular-/Pin-Picker-Style)

**Interfaces:**
- Consumes: `$placesRepository->find(int $id): ?array`, `insert(array $data): int` (Task 2), `PlaceImageStorage::store(?UploadedFileInterface $file): ?string` (Task 3).
- Produces: Route `GET /dm/wiki/places/new` (Query-Param `parent_id` optional), `POST /dm/wiki/places`.

- [ ] **Step 1: Formular-Template erstellen**

```twig
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Orte — {{ mode == 'edit' ? 'Bearbeiten' : 'Neu anlegen' }}</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <main class="page">
        <h1>Ort: {{ mode == 'edit' ? 'Bearbeiten' : 'Neu anlegen' }}</h1>
        {% include 'wiki/_tabs.twig' %}

        {% if error %}
            <p class="wiki-error">{{ error }}</p>
        {% endif %}

        <form method="post" action="{{ mode == 'edit' ? '/dm/wiki/places/' ~ place.id : '/dm/wiki/places' }}" enctype="multipart/form-data" class="wiki-form">
            <input type="hidden" name="parent_id" value="{{ parent_id }}">

            <label class="wiki-field">
                <span>Name</span>
                <input type="text" name="name" value="{{ place.name }}">
            </label>

            <label class="wiki-field">
                <span>Beschreibung</span>
                <textarea name="description" rows="4">{{ place.description }}</textarea>
            </label>

            <label class="wiki-field">
                <span>Bild</span>
                {% if place.image_path %}
                    <img src="/uploads/places/{{ place.image_path }}" alt="" class="place-thumb">
                {% endif %}
                <input type="file" name="image" accept="image/png,image/jpeg,image/webp">
            </label>

            {% if parent_image_path %}
                <label class="wiki-field">
                    <span>Position auf der Karte von "{{ parent_name }}" (anklicken)</span>
                    <div class="place-pin-picker" id="pin-picker">
                        <img src="/uploads/places/{{ parent_image_path }}" alt="" class="place-map-image" id="pin-picker-image">
                        <span class="place-pin" id="pin-picker-marker"{% if place.pin_x is not defined or place.pin_x is null %} hidden{% else %} style="left: {{ place.pin_x }}%; top: {{ place.pin_y }}%;"{% endif %}></span>
                    </div>
                    <input type="hidden" name="pin_x" id="pin-x" value="{{ place.pin_x }}">
                    <input type="hidden" name="pin_y" id="pin-y" value="{{ place.pin_y }}">
                </label>
            {% endif %}

            <button type="submit">Speichern</button>
        </form>
    </main>

    <script src="/js/pin-picker.js"></script>
</body>
</html>
```

- [ ] **Step 2: Pin-Picker-JS erstellen**

```javascript
(function () {
    var picker = document.getElementById('pin-picker');
    if (!picker) {
        return;
    }

    var image = document.getElementById('pin-picker-image');
    var marker = document.getElementById('pin-picker-marker');
    var pinX = document.getElementById('pin-x');
    var pinY = document.getElementById('pin-y');

    image.addEventListener('click', function (event) {
        var rect = image.getBoundingClientRect();
        var x = ((event.clientX - rect.left) / rect.width) * 100;
        var y = ((event.clientY - rect.top) / rect.height) * 100;

        pinX.value = x.toFixed(2);
        pinY.value = y.toFixed(2);

        marker.style.left = x + '%';
        marker.style.top = y + '%';
        marker.hidden = false;
    });
})();
```

- [ ] **Step 3: Routen in `index.php` ergänzen**

```php
$app->get('/dm/wiki/places/new', function ($request, $response) use ($twig, $placesRepository) {
    $queryParams = $request->getQueryParams();
    $parentId = isset($queryParams['parent_id']) && $queryParams['parent_id'] !== ''
        ? (int) $queryParams['parent_id']
        : null;
    $parent = null;

    if ($parentId !== null) {
        $parent = $placesRepository->find($parentId);
        if ($parent === null) {
            return $response->withStatus(404);
        }
    }

    return $twig->render($response, 'places/form.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'place' => ['id' => null, 'name' => '', 'description' => '', 'image_path' => null, 'pin_x' => null, 'pin_y' => null],
        'parent_id' => $parentId,
        'parent_image_path' => $parent['image_path'] ?? null,
        'parent_name' => $parent['name'] ?? null,
        'error' => null,
        'mode' => 'new',
    ]);
});

$app->post('/dm/wiki/places', function ($request, $response) use ($twig, $placesRepository) {
    $data = (array) $request->getParsedBody();
    $uploadedFiles = $request->getUploadedFiles();
    $parentId = trim((string) ($data['parent_id'] ?? '')) !== '' ? (int) $data['parent_id'] : null;

    $parent = null;
    if ($parentId !== null) {
        $parent = $placesRepository->find($parentId);
        if ($parent === null) {
            return $response->withStatus(404);
        }
    }

    $name = trim((string) ($data['name'] ?? ''));

    $renderError = function (string $message) use ($twig, $response, $data, $parentId, $parent) {
        return $twig->render($response->withStatus(422), 'places/form.twig', [
            'slug' => 'places',
            'categories' => WikiCategories::tabs(),
            'place' => $data,
            'parent_id' => $parentId,
            'parent_image_path' => $parent['image_path'] ?? null,
            'parent_name' => $parent['name'] ?? null,
            'error' => $message,
            'mode' => 'new',
        ]);
    };

    if ($name === '') {
        return $renderError('Name ist ein Pflichtfeld.');
    }

    try {
        $imagePath = PlaceImageStorage::store($uploadedFiles['image'] ?? null);
    } catch (InvalidArgumentException $exception) {
        return $renderError($exception->getMessage());
    }

    $placesRepository->insert([
        'name' => $name,
        'description' => trim((string) ($data['description'] ?? '')),
        'parent_id' => $parentId,
        'image_path' => $imagePath,
        'pin_x' => trim((string) ($data['pin_x'] ?? '')) !== '' ? (float) $data['pin_x'] : null,
        'pin_y' => trim((string) ($data['pin_y'] ?? '')) !== '' ? (float) $data['pin_y'] : null,
    ]);

    $redirectTo = $parentId !== null ? '/dm/wiki/places/' . $parentId : '/dm/wiki/places';

    return $response->withHeader('Location', $redirectTo)->withStatus(302);
});
```

- [ ] **Step 4: CSS ergänzen**

```css
.place-pin-picker,
.place-map {
    position: relative;
    display: inline-block;
    margin-bottom: 0.5rem;
}

.place-map-image {
    max-width: 100%;
    display: block;
    border: 1px solid #3a2f26;
    border-radius: 3px;
}

.place-pin {
    position: absolute;
    width: 14px;
    height: 14px;
    margin-left: -7px;
    margin-top: -7px;
    background: #d4af7a;
    border: 2px solid #1a1512;
    border-radius: 50%;
    cursor: pointer;
}
```

- [ ] **Step 5: Verifikation — Wurzel-Ort ohne Bild anlegen**

Run:
```bash
curl -s -o /dev/null -w '%{http_code}\n' -X POST http://localhost:8090/dm/wiki/places \
    -F 'name=Kontinent Aschgard' -F 'description=Ein von Asche bedeckter Kontinent.' -F 'parent_id='
```
Expected: `302`

Run: `curl -s http://localhost:8090/dm/wiki/places | grep -o 'Kontinent Aschgard'`
Expected: `Kontinent Aschgard`

- [ ] **Step 6: Verifikation — leerer Name**

Run: `curl -s -X POST http://localhost:8090/dm/wiki/places -F 'name=' -F 'parent_id=' | grep -o 'ist ein Pflichtfeld'`
Expected: `ist ein Pflichtfeld`

- [ ] **Step 7: Verifikation — ungültige Datei wird abgelehnt**

Run:
```bash
echo "kein bild" > /tmp/not-an-image.txt
curl -s -X POST http://localhost:8090/dm/wiki/places \
    -F 'name=Testort' -F 'parent_id=' -F 'image=@/tmp/not-an-image.txt' | grep -o 'PNG-, JPEG- oder WebP-Bilder sind erlaubt'
```
Expected: `PNG-, JPEG- oder WebP-Bilder sind erlaubt`

---

### Task 6: Ort-Detailansicht (Breadcrumb, Karte mit Pins, Fallback-Liste)

**Files:**
- Create: `backend/templates/places/detail.twig`
- Modify: `backend/public/index.php` (neue Route)
- Modify: `backend/public/css/style.css` (Breadcrumb-Style)

**Interfaces:**
- Consumes: `$placesRepository->find()`, `children()`, `breadcrumb()` (Task 2).
- Produces: Route `GET /dm/wiki/places/{id}` — rendert `places/detail.twig` mit `place`, `breadcrumb`, `pinned_children`, `unpinned_children`.

- [ ] **Step 1: Template erstellen**

```twig
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>{{ place.name }} — Orte</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <main class="page">
        <nav class="place-breadcrumb">
            {% for crumb in breadcrumb %}
                <a href="/dm/wiki/places/{{ crumb.id }}">{{ crumb.name }}</a>{% if not loop.last %} &raquo; {% endif %}
            {% endfor %}
        </nav>

        <h1>{{ place.name }}</h1>
        {% if place.description %}<p class="place-description">{{ place.description }}</p>{% endif %}

        <p class="wiki-actions">
            <a href="/dm/wiki/places/new?parent_id={{ place.id }}">+ Neuen Kind-Ort anlegen</a>
            &middot;
            <a href="/dm/wiki/places/{{ place.id }}/edit">Bearbeiten</a>
        </p>

        {% if place.image_path %}
            <div class="place-map">
                <img src="/uploads/places/{{ place.image_path }}" alt="{{ place.name }}" class="place-map-image">
                {% for child in pinned_children %}
                    <a href="/dm/wiki/places/{{ child.id }}" class="place-pin" style="left: {{ child.pin_x }}%; top: {{ child.pin_y }}%;" title="{{ child.name }}"></a>
                {% endfor %}
            </div>
        {% endif %}

        {% if unpinned_children|length > 0 %}
            <ul class="wiki-entries">
                {% for child in unpinned_children %}
                    <li><a href="/dm/wiki/places/{{ child.id }}">{{ child.name }}</a></li>
                {% endfor %}
            </ul>
        {% endif %}
    </main>
</body>
</html>
```

- [ ] **Step 2: Route in `index.php` ergänzen**

```php
$app->get('/dm/wiki/places/{id}', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $children = $placesRepository->children((int) $place['id']);
    $pinnedChildren = array_values(array_filter(
        $children,
        static fn (array $c): bool => $c['pin_x'] !== null && $c['pin_y'] !== null
    ));
    $unpinnedChildren = array_values(array_filter(
        $children,
        static fn (array $c): bool => $c['pin_x'] === null || $c['pin_y'] === null
    ));

    return $twig->render($response, 'places/detail.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'place' => $place,
        'breadcrumb' => $placesRepository->breadcrumb((int) $place['id']),
        'pinned_children' => $pinnedChildren,
        'unpinned_children' => $unpinnedChildren,
    ]);
});
```

- [ ] **Step 3: CSS ergänzen**

```css
.place-breadcrumb {
    margin-bottom: 1rem;
    color: #8a7d68;
}

.place-breadcrumb a {
    color: #8a7d68;
    text-decoration: none;
}

.place-description {
    margin-bottom: 1.5rem;
}
```

- [ ] **Step 4: Verifikation — Kind-Ort ohne Bild landet in Fallback-Liste**

Run:
```bash
ROOT_ID=$(curl -s http://localhost:8090/dm/wiki/places | grep -oE 'href="/dm/wiki/places/[0-9]+"' | head -n1 | grep -oE '[0-9]+')
curl -s -o /dev/null -w '%{http_code}\n' -X POST http://localhost:8090/dm/wiki/places \
    -F "name=Stadt Grabenfurt" -F 'description=Eine befestigte Stadt.' -F "parent_id=$ROOT_ID"
curl -s "http://localhost:8090/dm/wiki/places/$ROOT_ID" | grep -o 'Stadt Grabenfurt'
```
Expected: `302`, dann `Stadt Grabenfurt` (Fallback-Liste, da `Kontinent Aschgard` noch kein Bild hat)

- [ ] **Step 5: Verifikation — unbekannte ID**

Run: `curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8090/dm/wiki/places/99999`
Expected: `404`

---

### Task 7: Ort bearbeiten (Formular wiederverwenden + POST-Update)

**Files:**
- Modify: `backend/public/index.php` (zwei neue Routen)

**Interfaces:**
- Consumes: `$placesRepository->find()`, `update(int $id, array $data): void` (Task 2), `PlaceImageStorage::store()` (Task 3), `places/form.twig` (Task 5, bereits `mode`-fähig).
- Produces: Route `GET /dm/wiki/places/{id}/edit`, `POST /dm/wiki/places/{id}`.

- [ ] **Step 1: Routen in `index.php` ergänzen**

```php
$app->get('/dm/wiki/places/{id}/edit', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $parent = $place['parent_id'] !== null ? $placesRepository->find((int) $place['parent_id']) : null;

    return $twig->render($response, 'places/form.twig', [
        'slug' => 'places',
        'categories' => WikiCategories::tabs(),
        'place' => $place,
        'parent_id' => $place['parent_id'],
        'parent_image_path' => $parent['image_path'] ?? null,
        'parent_name' => $parent['name'] ?? null,
        'error' => null,
        'mode' => 'edit',
    ]);
});

$app->post('/dm/wiki/places/{id}', function ($request, $response, array $args) use ($twig, $placesRepository) {
    $place = $placesRepository->find((int) $args['id']);
    if ($place === null) {
        return $response->withStatus(404);
    }

    $data = (array) $request->getParsedBody();
    $uploadedFiles = $request->getUploadedFiles();
    $parentId = $place['parent_id'] !== null ? (int) $place['parent_id'] : null;
    $parent = $parentId !== null ? $placesRepository->find($parentId) : null;

    $name = trim((string) ($data['name'] ?? ''));

    $renderError = function (string $message) use ($twig, $response, $data, $place, $parentId, $parent) {
        $formPlace = $data;
        $formPlace['id'] = $place['id'];
        $formPlace['image_path'] = $place['image_path'];

        return $twig->render($response->withStatus(422), 'places/form.twig', [
            'slug' => 'places',
            'categories' => WikiCategories::tabs(),
            'place' => $formPlace,
            'parent_id' => $parentId,
            'parent_image_path' => $parent['image_path'] ?? null,
            'parent_name' => $parent['name'] ?? null,
            'error' => $message,
            'mode' => 'edit',
        ]);
    };

    if ($name === '') {
        return $renderError('Name ist ein Pflichtfeld.');
    }

    try {
        $newImagePath = PlaceImageStorage::store($uploadedFiles['image'] ?? null);
    } catch (InvalidArgumentException $exception) {
        return $renderError($exception->getMessage());
    }

    $placesRepository->update((int) $place['id'], [
        'name' => $name,
        'description' => trim((string) ($data['description'] ?? '')),
        'parent_id' => $parentId,
        'image_path' => $newImagePath ?? $place['image_path'],
        'pin_x' => trim((string) ($data['pin_x'] ?? '')) !== '' ? (float) $data['pin_x'] : null,
        'pin_y' => trim((string) ($data['pin_y'] ?? '')) !== '' ? (float) $data['pin_y'] : null,
    ]);

    $redirectTo = $parentId !== null ? '/dm/wiki/places/' . $parentId : '/dm/wiki/places';

    return $response->withHeader('Location', $redirectTo)->withStatus(302);
});
```

- [ ] **Step 2: Verifikation — Bild nachträglich zum Wurzel-Ort hinzufügen**

Ein 1x1-PNG als Test-Bild erzeugen und hochladen:

```bash
ROOT_ID=$(curl -s http://localhost:8090/dm/wiki/places | grep -oE 'href="/dm/wiki/places/[0-9]+"' | head -n1 | grep -oE '[0-9]+')
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\xf8\xcf\xc0\x00\x00\x03\x01\x01\x00\x18\xdd\x8d\xb0\x00\x00\x00\x00IEND\xaeB`\x82' > /tmp/test-map.png

curl -s -o /dev/null -w '%{http_code}\n' -X POST "http://localhost:8090/dm/wiki/places/$ROOT_ID" \
    -F 'name=Kontinent Aschgard' -F 'description=Ein von Asche bedeckter Kontinent.' -F "image=@/tmp/test-map.png;type=image/png"

curl -s "http://localhost:8090/dm/wiki/places/$ROOT_ID" | grep -o "uploads/places/[a-f0-9]*.png"
```
Expected: `302`, dann eine Zeile wie `uploads/places/<hex>.png`

- [ ] **Step 3: Verifikation — Pin setzen für bestehenden Kind-Ort**

```bash
CHILD_ID=$(curl -s "http://localhost:8090/dm/wiki/places/$ROOT_ID" | grep -oE 'href="/dm/wiki/places/[0-9]+"' | grep -v "/$ROOT_ID\"" | head -n1 | grep -oE '[0-9]+')

curl -s -o /dev/null -w '%{http_code}\n' -X POST "http://localhost:8090/dm/wiki/places/$CHILD_ID" \
    -F 'name=Stadt Grabenfurt' -F 'description=Eine befestigte Stadt.' -F 'pin_x=42.50' -F 'pin_y=17.25'

curl -s "http://localhost:8090/dm/wiki/places/$ROOT_ID" | grep -o 'left: 42.5%; top: 17.25%;'
```
Expected: `302`, dann `left: 42.5%; top: 17.25%;` (Pin erscheint jetzt auf der Karte statt in der Fallback-Liste)

---

### Task 8: End-to-End-Verifikation

**Files:**
- Keine (reine Verifikation).

- [ ] **Step 1: Vollständige Navigation durchklicken (Browser)**

`http://<host>:8090/dm/wiki/places` → "+ Neu anlegen" → Wurzel-Ort mit Bild anlegen → Detailansicht öffnen → "+ Neuen Kind-Ort anlegen" → auf die Karte klicken, um den Pin zu setzen → speichern → Pin erscheint auf der Eltern-Karte → Klick auf den Pin navigiert zum Kind-Ort → Breadcrumb zeigt beide Ebenen → "Bearbeiten" am Kind-Ort → Beschreibung ändern → Änderung erscheint.

- [ ] **Step 2: Dreistufige Hierarchie prüfen**

Run:
```bash
ROOT_ID=$(curl -s http://localhost:8090/dm/wiki/places | grep -oE 'href="/dm/wiki/places/[0-9]+"' | head -n1 | grep -oE '[0-9]+')
CITY_ID=$(curl -s "http://localhost:8090/dm/wiki/places/$ROOT_ID" | grep -oE 'href="/dm/wiki/places/[0-9]+"' | grep -v "/$ROOT_ID\"" | head -n1 | grep -oE '[0-9]+')

curl -s -o /dev/null -w '%{http_code}\n' -X POST http://localhost:8090/dm/wiki/places \
    -F 'name=Gasthaus zur Aschekrähe' -F 'description=Ein warmes Feuer, müde Reisende.' -F "parent_id=$CITY_ID"

curl -s "http://localhost:8090/dm/wiki/places/$CITY_ID" | grep -o 'Gasthaus zur Aschekrähe'
```
Expected: `302`, dann `Gasthaus zur Aschekrähe` (dritte Hierarchie-Ebene funktioniert)

- [ ] **Step 3: Persistenz nach Neustart**

Run: `docker compose restart php-fpm && sleep 1 && curl -s http://localhost:8090/dm/wiki/places | grep -o 'Kontinent Aschgard'`
Expected: `Kontinent Aschgard`
