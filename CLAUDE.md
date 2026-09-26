# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Cairn-homebrew TRPG (tabletop RPG) management system for a Dungeon Master and players, LAN-only, no auth.

**Current state: no application code exists in the working tree.** The previous PHP/Slim/Twig/MariaDB app (`backend/`, `provisioning/`) has been deleted (see `git status` — shown as pending `D` deletions, not yet committed). The repo right now holds only planning/reference docs (`docs/`), in-world narrative content (`Story/`), and a stray `.env` left over from the old Docker setup. Do not assume any file, class, route, or template from an older conversation still exists — verify with `ls`/`git status` first. The next build is planned as a Campaign Management System per `docs/superpowers/specs/2026-09-24-campaign-management-roadmap.md` and its follow-up specs; treat those specs as the design intent for what to build, not as a description of code that currently exists.

## Repository contents

- **`docs/own-system/`** — the custom homebrew ruleset, the authoritative source of truth for all game rules: `00-overview.md` (status/changelog) plus 10 core-mechanic files (`01-charakter.md` … `10-gm-tools.md`) and 7 catalogs (`11-katalog-kins.md` … `17-katalog-sprachen.md`, e.g. kins/professions/skills/spells/items/bestiary/languages). This system replaced an earlier plan to just use Dragonbane outright — it's a from-scratch mix of many systems' ideas, not a Dragonbane reskin.
- **`docs/own-system/tools/*.py`** — standalone, stdlib-only Python simulators (`balance_simulator.py`, `campaign_simulator.py`, `encounter_calibration.py`, `party_gauntlet.py`, `profession_fairness_check.py`) that numerically verify combat/profession balance against the ruleset above. Run directly, e.g. `python3 docs/own-system/tools/balance_simulator.py` — no dependencies beyond the standard library (`random`, `statistics`, `collections`, `dataclasses`). Each script imports from `campaign_simulator.py`/`balance_simulator.py`, so run them from inside `docs/own-system/tools/` or keep that layout intact. These are throwaway analysis tools, not part of any application, kept only for re-verifying numbers if the ruleset changes.
- **`docs/ruleset-comparison/`** — OOC research comparing off-the-shelf rulesets (Dragonbane, Forbidden Lands, Shadowdark, 13th Age, Daggerheart, etc.) against a fixed criteria list; historical record of why the project ended up building its own system in `docs/own-system/` instead of adopting one of these.
- **`docs/superpowers/specs/`** and **`docs/superpowers/plans/`** — design specs/plans. The `2026-09-24-campaign-management-roadmap.md` (use-case map + sub-project breakdown) and `2026-09-25-*` specs (full DB schema, campaign-visibility design, character-system design, DM-tools design) describe the *next* build: a DM/player-visibility-split campaign manager on top of the `docs/own-system/` ruleset. The `2026-09-09-dm-wiki-design.md`/`2026-09-09-places-map-design.md` specs predate that roadmap and describe pieces of the now-deleted earlier app — historical reference only. Note the 2026-09-25 data-model spec targets a SQLite schema, whereas the deleted app used MariaDB — confirm which DB is actually intended before implementing against it.
- **`docs/lore/`** and **`Story/`** — in-world campaign content (world doc, NPCs, locations, timeline, per-chapter narrative prose). Not rules, not application code.
- **`docs/DB_DE_Schnellstarter_2-0_web-*.pdf`** — reference material (German quickstart PDF), supporting research.

## Working here right now

- There's nothing to build, lint, or test — no application exists yet. If asked to implement the next app, read the roadmap/spec docs above first and check with the user on open questions they flag (e.g. the SQLite-vs-MariaDB discrepancy) rather than assuming.
- The Python balance tools are the one thing that actually runs: `python3 <script>.py` from `docs/own-system/tools/`.
- UI copy and in-world content in this repo is German; when code eventually exists, code identifiers/comments should be English (this was the convention in the deleted app and is likely to continue).
