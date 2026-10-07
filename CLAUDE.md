# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Dragonbane-based TRPG (tabletop RPG) management system for a Dungeon Master and players, LAN-only. Players need no login; the DM area is locked by a single DM password (`DM_PASSWORD_HASH`, see `docs/UX-KONZEPT.md`). The app is live (PHP 8.3 / Slim 4 / Twig / MariaDB, Docker). The concept is in `docs/CONCEPT.md` (catalog, character, campaign), the DB schema in `docs/SCHEMA.md`.

## Repository layout

- **`backend/`** — the app. `public/index.php` (entry point, wiring, player routes), `routes/dm_*.php` (DM route groups), `src/` (PSR-4 namespace `Flyka\CampaignManagement`, sorted by layer: `Auth/` DM login, gate and session, `Database/` connection and config, `Http/` input and route helpers, `Repository/` all SQL, `Service/` pure rules; `Application` wires everything), `templates/` (Twig), `public/{css,js,fonts,icons,images}` (static assets). `tests/` (PHPUnit; unit tests plus DB-backed tests and `AppRoutesTest`, which drives the whole app as DM against the test DB).
- **`database/`** — `01_schema.sql`, `02_catalog.sql`, `03_examples.sql`; mounted into the MariaDB container as init scripts (only run on an empty volume, so schema changes need `dcv` to recreate it).
- **`provisioning/`** — `docker-compose.yml` (nginx, php-fpm, mariadb, phpmyadmin) plus `backend/` (Dockerfile, nginx.conf, php.ini).
- **`alias.sh`**, **`deploy.sh`** — local Docker aliases (`dc`, `dcud`, `dcv`, `rcomposer`, `rphp`; source `alias.sh` under zsh) and the VPS deploy script.
- **`docs/lore/`**, **`Story/`** — in-world campaign content (world, NPCs, locations, per-chapter prose). Not rules, not code.
- **`docs/ruleset-comparison/`** — research on off-the-shelf rulesets; reasoning for choosing Dragonbane (the rules source is `docs/DB_DE_Schnellstarter_2-0_web-2njzid.pdf`).

## Working here

- Run the app: `source alias.sh && dcud`, served at `http://127.0.0.1:8070` (phpMyAdmin on 8071). Config comes from `.env` (copy `.env.example`); the DB is named `campaign-management`. phpMyAdmin requires a login with the DB credentials.
- UI copy and in-world content are German; code identifiers and comments are English.
- QA (run in the php-fpm container): `rcomposer qa` = ECS (`ecs`, fix with `ecs:fix`), Rector (`rector`, apply with `rector:fix`), PHPStan level 8 without baseline (`stan`), PHPUnit (`test`). DB tests rebuild `campaign-management_test` from `database/01_schema.sql` + `02_catalog.sql` using the root credentials from `.env`; without a configured server they are skipped (CI sets `TEST_DB_HOST`/`TEST_DB_PASSWORD`).
- Frontend QA (in `backend/`, needs Node): `npm run lint` = ESLint (`lint:js`), Stylelint (`lint:css`), Prettier check (`format:check`); apply formatting with `npm run format`. JS tests (`npm test`, node:test + jsdom) live in `backend/tests-js/`; they load the page scripts from `public/js` into a jsdom page with a fake `fetch`. CI (`.github/workflows/ci.yml`) runs everything on pushes to `develop` and on every pull request.
- Multi-line raw SQL in PHP is written as heredoc.

## Remember me to checkout Obsidian for Atlas
