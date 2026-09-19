# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Cairn-homebrew TRPG (tabletop RPG) management system: a LAN-only web app for a Dungeon Master and players. Two audiences: a player-facing chronicle page (`/`) and a DM-only toolset (`/dm`, `/dm/wiki/*`) covering a generic wiki (bestiary, items, spellbooks, relics, books) plus a hierarchical places/map system.

## Tech stack

- PHP 8.3, Slim 4 (`slim/slim`) microframework, Twig 3 (`slim/twig-view`) templating.
- SQLite (`backend/var/data/app.sqlite`) via raw PDO — no ORM, no migrations. Schema is created idempotently (`CREATE TABLE IF NOT EXISTS ...`) on every app boot, in `index.php` and each repository's `ensureTable()`.
- No JS framework — vanilla JS (`backend/public/js/pin-picker.js`) for the map pin-picker.
- Docker Compose (nginx + php-fpm) for local dev.

## Running the app

- `cd provisioning && docker compose up` — serves the app at http://localhost:8090 (nginx proxies to php-fpm 8.3; xdebug is enabled on port 9003).
- If working outside Docker, install deps with `cd backend && composer install`.
- No frontend build step — CSS/JS are plain files served directly from `backend/public/`.
- No automated test suite exists. Verify changes manually: start the containers and exercise routes via browser or `curl` against `localhost:8090`.

## Architecture

There is no controller/service layer: **`backend/public/index.php`** is the entire application — it opens the PDO connection, ensures all tables exist, and declares every route inline as a closure. Read this file first to see the whole request-handling surface.

- **`backend/src/WikiCategories.php`** — single source of truth for the 5 generic wiki categories (bestiary, items, spellbooks, relics, books): table name, label, and column definitions (`name`/`label`/`type`) per category. Adding a category means adding an entry here; `WikiRepository` and the `wiki/list.twig` / `wiki/form.twig` templates are fully generic and adapt automatically — no per-category code.
- **`backend/src/WikiRepository.php`** — generic CRUD (`all`, `find`, `insert`, `update`, `ensureTable`) driven entirely by the column config from `WikiCategories`. Category/table names must always be resolved through `WikiCategories::find()` before use in a query — never take the `{category}` route parameter straight into SQL.
- **`backend/src/PlacesRepository.php`** / **`PlaceImageStorage.php`** — a separate, non-generic model for hierarchical places (parent/child locations with breadcrumb navigation and map pin coordinates). It has its own schema and behavior (image upload, parent chaining) because it doesn't fit the generic wiki shape.
- **`backend/templates/`** — Twig views split into `wiki/*` (shared across all 5 wiki categories, including the `_tabs.twig` nav partial) and `places/*` (place-specific: list, detail with map+pins, form with the pin-picker).
- No authentication/authorization layer exists — `/dm/*` routes are unprotected. This is intentional for the current LAN-only deployment; don't add auth infrastructure unless explicitly asked.

## Conventions

- `declare(strict_types=1)` in every PHP file.
- Classes are loaded via plain `require` in `index.php`, not Composer autoload/PSR-4 — a new class needs an explicit `require` before it can be used.
- Multi-line or escape-heavy SQL is written as heredoc (`<<<SQL ... SQL;`), never with escaped quotes in a quoted string — see `index.php` and `WikiRepository.php` for existing examples.
- UI copy and form labels are German; code identifiers and comments are English.
- Dynamic table/column access always goes through `WikiCategories::find()` / its config — never interpolate a route parameter straight into SQL.

## Non-code content

- `docs/superpowers/` — specs and plans for feature work (not application code).
- `docs/lore/` and `Story/` — in-world campaign/lore content, not part of the app.
