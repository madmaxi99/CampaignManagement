---
name: campaign-server
description: Use when a campaign (chapters, places, NPCs, items) should be created or edited in the running app, locally or on the production server, without a migration. Triggers on "Kampagne auf den Server", "Kampagne anlegen", "NPC/Ort/Gegenstand ändern", "Kapitel bearbeiten".
---

# Campaigns on the server

Campaign content is written through the DM JSON endpoints of the app (the same ones the editor UI uses), never through a migration. `campaign.py` does that from a data file; `run.sh` wraps it for production.

## Files

- `docs/solo/der-teure-tote.json`: source data of the campaign "Der teure Tote" (`campaign`, `chapter`, `places`, `npcs`, `items`). Default of `CAMPAIGN_DATA`; set it to another file for another campaign.
- `docs/solo/der-teure-tote.state.<host>.json`: key to id mapping of one target, written by `import`. Without it `sync`, `edit` and `check` do not work for that target. Local file, not for the repo.
- `.claude/skills/campaign-server/campaign.py`: the client (login, CSRF, create, update, export).
- `.claude/skills/campaign-server/run.sh`: production wrapper (SSH tunnel to `amt-solo-vps`, password from the server's `.env`, never printed).

## Data format

Texts are German. Every entry has a unique `key`. Places reference `parent` (key or `null`), NPCs and items reference `place` (key or `null`); the chapter is set automatically.

| Entry | Fields |
|---|---|
| `campaign` | `name_de`, `teaser_de` (max 255), `background_de` |
| `chapter` | `title_de`, `notes_de` |
| `places[]` | `key`, `parent`, `name_de`, `description_de`, `dm_text_de` (DM only), optional `number_label` |
| `npcs[]` | `key`, `place`, `name_de`, `description_de`, `dm_text_de`, `found_hint_de` |
| `items[]` | `key`, `place`, `name_de`, `description_de`, `dm_text_de`, `text_de` (letter/book), `found_hint_de` |

## Writing style: short, bullets, room to improvise

The DM improvises a lot at the table. The text gives anchors, not a script. **Bullet points (`✦ `, one per line), never paragraphs.** Cut every sentence the DM does not need at the table.

Where each text shows up in the play view decides what goes into it:

| Field | Role | Size |
|---|---|---|
| `chapter.notes_de` | Shown at the top of the chapter. **Short read-aloud intro** for the players: where they are, what they see and hear, what happens. Running prose, no bullets, no spoilers. | 3-6 sentences |
| `campaign.background_de` | Collapsed "Hintergrund", DM only. The truth behind the story and the time plan, as bullets. Nothing from here is repeated in places or NPCs. | max ~10 bullets |
| `places[].description_de` | What the players notice on arrival. | 2-3 bullets |
| `places[].dm_text_de` | What is here, what can be found, what it leads to. End with `Offen:` for what the DM invents on the spot. | 2-4 bullets |
| `npcs[].description_de` | Looks and manner. | 1-2 bullets |
| `npcs[].dm_text_de` | Want, secret, how they react. | 2-3 bullets |
| `items[]` | Same as NPCs; `text_de` only for text that is handed over verbatim (letter, book). | 1-2 bullets |
| `found_hint_de` | One short phrase. | a few words |

Rules:
- **No double storage.** A clue lives in exactly one place (where it is found), not also in the background and the chapter text.
- **No full dialogues, no step-by-step flows.** Name the situation and the goal, not the lines.
- **Leave gaps on purpose.** Not every detail is decided; `Offen:` marks what is free to improvise.
- **Time plan:** one line per day or phase in `background_de`, it may slip.

Parents must come before their children in the file. Use typographic quotes („ “) inside texts.

## Commands

```bash
# production (needs SSH access to amt-solo-vps)
.claude/skills/campaign-server/run.sh import --dry-run   # list what would be created, sends nothing
.claude/skills/campaign-server/run.sh import             # create campaign, chapter, places, NPCs, items
.claude/skills/campaign-server/run.sh check              # compare counts with the server
.claude/skills/campaign-server/run.sh diff               # list text fields that differ between server and data file (run before sync)
.claude/skills/campaign-server/run.sh sync               # send every entry of the data file as update; entries without an id are created
.claude/skills/campaign-server/run.sh image place karte Story/startdorf/karte.png   # upload an image for a place or item (jpg/png/webp, no svg)
.claude/skills/campaign-server/run.sh edit npc wendel description_de='neuer Text'

# local dev app: same commands with BASE_URL (password comes from the project's .env)
BASE_URL=http://127.0.0.1:8070 .claude/skills/campaign-server/run.sh check
```

`edit <type> <key> field=value ...`: types `campaign`, `chapter`, `place`, `npc`, `item`. Values: text (`\n` = line break), `@path` (file content), for `place_id` / `parent_id` a place key. The command reads the entry from `GET /dm/campaign/{id}/export`, changes only the named fields, sends the complete entry back and updates the data file.

## Rules

- **Why the whole entry is sent:** every update endpoint replaces all fields; omitted fields become empty. Never POST a partial entry by hand. `sync` keeps `notes_de` of NPCs (the DM's play notes); `edit` keeps every field it does not name.
- **Images** (`image_path`, `portrait_path`) are not touched by updates. Upload them with `image`; the app rejects SVG, so render an SVG to PNG first (headless Chrome: `google-chrome --headless --screenshot=out.png file://page.html`).
- **Maps:** a map is a place with the image (e.g. `karte`). Give places the numbers of the map as `number_label`, the index shows them next to the names.
- **Before `sync` on production** run `diff`: `sync` overwrites every text of the data file, also edits made in the app.
- **Production writes** happen only on explicit request, after a dry run or a stated list of changes. The first `import` per target creates the state file; a second `import` is refused (no duplicate campaign).
- **Deleting** a campaign (`DELETE /dm/campaign/{id}`, cascades) or an entry only when the user asks for it.
- The edit endpoints must exist on the server: `GET /dm/campaign/{id}/export` came with PR #5. After code changes to the routes, check that the deploy (GitHub Actions on push to `main`) has run: `ssh amt-solo-vps 'cd /opt/campaignManagement && git log --oneline -1'`.
- Local first: run a new data file against `BASE_URL=http://127.0.0.1:8070`, look at `/dm/campaign/{id}` and `/play`, then production.
