#!/usr/bin/env python3
"""Creates and edits a campaign (data file: CAMPAIGN_DATA) through the DM endpoints of the app.

Usage (BASE_URL defaults to http://127.0.0.1:8070, the password comes from DM_PASSWORD;
for localhost it falls back to DM_PASSWORD in the project's .env):

  campaign.py import [--dry-run]
  campaign.py sync                       # send every entry of the data file (NPC notes are kept);
                                         # entries that have no id yet are created
  campaign.py image <place|item> <key> <file>   # upload a jpg/png/webp as image of an entry
  campaign.py edit <type> <key> field=value [field=value ...]
        type: campaign | chapter | place | npc | item
        value: text (\\n = line break), @path (file content), or for place_id/parent_id/chapter_id a key
  campaign.py check                      # compare counts with the server
  campaign.py diff                       # list text fields that differ between server and data file

The state (key -> id) of each target lives next to this file as story_state_<host>.json.
"""
import http.cookiejar
import json
import os
import pathlib
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

HERE = pathlib.Path(__file__).resolve().parent
DATA_FILE = pathlib.Path(os.environ.get("CAMPAIGN_DATA", str(pathlib.Path(__file__).resolve().parents[3] / "docs/solo/der-teure-tote.json"))).resolve()
BASE_URL = os.environ.get("BASE_URL", "http://127.0.0.1:8070").rstrip("/")
HOST = urllib.parse.urlparse(BASE_URL).netloc.replace(":", "_")
STATE_FILE = DATA_FILE.with_name(f"{DATA_FILE.stem}.state.{HOST}.json")
PROJECT_ENV = pathlib.Path("/home/m-zierdt/projects/private/trpg-management-system/.env")

FIELDS = {
    "campaign": ["name_de", "teaser_de", "background_de"],
    "chapter": ["title_de", "notes_de"],
    "place": ["name_de", "parent_id", "chapter_id", "number_label", "description_de", "dm_text_de", "encounter_table_id"],
    "npc": ["name_de", "description_de", "dm_text_de", "notes_de", "found_hint_de", "chapter_id", "place_id", "bestiary_id"],
    "item": ["name_de", "description_de", "dm_text_de", "text_de", "found_hint_de", "chapter_id", "place_id"],
}
COLLECTION = {"place": "places", "npc": "npcs", "item": "items"}
PLURAL_PATH = {"place": "places", "npc": "npcs", "item": "items"}


def fail(message):
    print(f"ERROR: {message}", file=sys.stderr)
    sys.exit(1)


def password():
    value = os.environ.get("DM_PASSWORD")
    if value:
        return value
    if urllib.parse.urlparse(BASE_URL).hostname in ("127.0.0.1", "localhost") and PROJECT_ENV.exists():
        for line in PROJECT_ENV.read_text(encoding="utf-8").splitlines():
            if line.startswith("DM_PASSWORD="):
                return line.split("=", 1)[1].strip().strip("\"'")
    fail("DM_PASSWORD is not set")


class Client:
    def __init__(self):
        self.opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
        self.csrf = ""

    def _open(self, request):
        try:
            with self.opener.open(request, timeout=30) as response:
                return response.status, response.read().decode("utf-8")
        except urllib.error.HTTPError as error:
            body = error.read().decode("utf-8", "replace")
            try:
                body = json.loads(body).get("error", body)
            except ValueError:
                body = body[:300]
            fail(f"{request.get_method()} {request.full_url} -> {error.code}: {body}")

    def login(self):
        _, html = self._open(urllib.request.Request(BASE_URL + "/dm/login"))
        token = re.search(r'name="_csrf" value="([^"]+)"', html)
        if not token:
            fail("no CSRF token on the login page")
        form = urllib.parse.urlencode({"password": password(), "_csrf": token.group(1), "next": "/dm"}).encode()
        self._open(urllib.request.Request(BASE_URL + "/dm/login", data=form, method="POST"))
        _, html = self._open(urllib.request.Request(BASE_URL + "/dm"))
        meta = re.search(r'<meta name="csrf-token" content="([^"]+)"', html)
        if not meta:
            fail("login failed (no DM session)")
        self.csrf = meta.group(1)
        return html

    def call(self, method, path, payload=None):
        data = json.dumps(payload, ensure_ascii=False).encode("utf-8") if payload is not None else None
        request = urllib.request.Request(BASE_URL + path, data=data, method=method, headers={
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-CSRF-Token": self.csrf,
        })
        _, body = self._open(request)
        return json.loads(body) if body else {}


    def upload(self, path, file_path):
        """multipart/form-data POST with the file as field "image"."""
        file_path = pathlib.Path(file_path)
        kind = {".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".png": "image/png", ".webp": "image/webp"}.get(file_path.suffix.lower())
        if kind is None:
            fail("only jpg, png and webp can be uploaded")
        boundary = "----campaign" + os.urandom(8).hex()
        head = f'--{boundary}\r\nContent-Disposition: form-data; name="image"; filename="{file_path.name}"\r\nContent-Type: {kind}\r\n\r\n'
        body = head.encode() + file_path.read_bytes() + f"\r\n--{boundary}--\r\n".encode()
        request = urllib.request.Request(BASE_URL + path, data=body, method="POST", headers={
            "Content-Type": f"multipart/form-data; boundary={boundary}",
            "Accept": "application/json",
            "X-CSRF-Token": self.csrf,
        })
        _, response = self._open(request)
        return json.loads(response) if response else {}


def load_data():
    return json.loads(DATA_FILE.read_text(encoding="utf-8"))


def save_data(data):
    DATA_FILE.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def load_state():
    return json.loads(STATE_FILE.read_text(encoding="utf-8")) if STATE_FILE.exists() else None


def save_state(state):
    STATE_FILE.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")


def payload_for(kind, entry, state):
    """Request body of an entry of the data file (keys of places/chapter are resolved to ids)."""
    body = {name: entry.get(name) for name in FIELDS[kind] if name in entry}
    if kind in ("place", "npc", "item"):
        body["chapter_id"] = state["chapter"]
    if kind == "place":
        parent = entry.get("parent")
        body["parent_id"] = state["places"][parent] if parent else None
    if kind in ("npc", "item"):
        place = entry.get("place")
        body["place_id"] = state["places"][place] if place else None
    return body


def do_import(dry_run):
    data = load_data()
    print(f"target: {BASE_URL}")
    print(f"campaign: {data['campaign']['name_de']}")
    print(f"chapter: {data['chapter']['title_de']}")
    for kind in ("place", "npc", "item"):
        entries = data[COLLECTION[kind]]
        print(f"{kind}s ({len(entries)}): " + ", ".join(entry["name_de"] for entry in entries))
    if dry_run:
        print("dry run: nothing was sent")
        return
    if load_state() is not None:
        fail(f"{STATE_FILE.name} exists already: the campaign was imported for this target")

    client = Client()
    html = client.login()
    if data["campaign"]["name_de"] in html:
        fail("a campaign with this name already exists on the target")

    state = {"campaign": None, "chapter": None, "places": {}, "npcs": {}, "items": {}}
    state["campaign"] = client.call("POST", "/dm/campaigns", data["campaign"])["id"]
    save_state(state)
    base = f"/dm/campaign/{state['campaign']}"
    state["chapter"] = client.call("POST", base + "/chapters", data["chapter"])["id"]
    for entry in data["places"]:
        if entry["parent"] and entry["parent"] not in state["places"]:
            fail(f"parent {entry['parent']} of {entry['key']} comes later in the file")
        state["places"][entry["key"]] = client.call("POST", base + "/places", payload_for("place", entry, state))["id"]
        save_state(state)
    for kind in ("npc", "item"):
        for entry in data[COLLECTION[kind]]:
            state[COLLECTION[kind]][entry["key"]] = client.call("POST", f"{base}/{PLURAL_PATH[kind]}", payload_for(kind, entry, state))["id"]
            save_state(state)
    print(f"created campaign {state['campaign']}: {BASE_URL}/dm/campaign/{state['campaign']}")


def connect():
    state = load_state()
    if state is None:
        fail(f"{STATE_FILE.name} not found: run import first")
    client = Client()
    client.login()
    return client, state, f"/dm/campaign/{state['campaign']}"


def do_sync():
    data = load_state() and load_data()
    client, state, base = connect()
    export = client.call("GET", base + "/export")
    notes = {entry["id"]: entry.get("notes_de") for entry in export["npcs"]}
    client.call("POST", base, data["campaign"])
    client.call("POST", f"{base}/chapters/{state['chapter']}", data["chapter"])
    for kind in ("place", "npc", "item"):
        for entry in data[COLLECTION[kind]]:
            body = payload_for(kind, entry, state)
            entry_id = state[COLLECTION[kind]].get(entry["key"])
            if entry_id is None:
                state[COLLECTION[kind]][entry["key"]] = client.call("POST", f"{base}/{PLURAL_PATH[kind]}", body)["id"]
                save_state(state)
                print("created", kind, entry["key"])
                continue
            if kind == "npc":
                body["notes_de"] = notes.get(entry_id)
            client.call("POST", f"{base}/{PLURAL_PATH[kind]}/{entry_id}", body)
    print("synced")


def do_image(kind, key, file_path):
    if kind not in ("place", "item"):
        fail("images: place or item")
    client, state, base = connect()
    entry_id = state[COLLECTION[kind]].get(key)
    if entry_id is None:
        fail(f"{kind} {key} is not on the server yet: run sync first")
    result = client.upload(f"{base}/{PLURAL_PATH[kind]}/{entry_id}/image", file_path)
    print(kind, key, "image", result.get("image_path"))


def parse_value(name, raw, state):
    if raw.startswith("@"):
        return pathlib.Path(raw[1:]).read_text(encoding="utf-8").rstrip("\n")
    if name in ("place_id", "parent_id"):
        if raw in ("", "null"):
            return None
        return state["places"].get(raw, int(raw) if raw.isdigit() else fail(f"unknown place key {raw}"))
    if name == "chapter_id":
        return state["chapter"] if raw in ("", "chapter") else int(raw)
    return raw.replace("\\n", "\n")


def do_edit(kind, key, assignments):
    if kind not in FIELDS:
        fail("type must be one of: " + ", ".join(FIELDS))
    client, state, base = connect()
    export = client.call("GET", base + "/export")
    if kind == "campaign":
        entry_id, current, path = state["campaign"], export["campaign"], base
    elif kind == "chapter":
        entry_id, current, path = state["chapter"], next(c for c in export["chapters"] if c["id"] == state["chapter"]), f"{base}/chapters/{state['chapter']}"
    else:
        entry_id = state[COLLECTION[kind]].get(key) or fail(f"unknown {kind} key {key}")
        current = next((e for e in export[COLLECTION[kind]] if e["id"] == entry_id), None) or fail("entry not on the server")
        path = f"{base}/{PLURAL_PATH[kind]}/{entry_id}"

    body = {name: current.get(name) for name in FIELDS[kind]}
    changes = {}
    for assignment in assignments:
        name, _, raw = assignment.partition("=")
        if name not in FIELDS[kind]:
            fail(f"{name} is not a field of {kind}: " + ", ".join(FIELDS[kind]))
        changes[name] = parse_value(name, raw, state)
    body.update(changes)
    client.call("POST", path, body)
    print(f"updated {kind} {key or ''} (id {entry_id}): " + ", ".join(changes))

    data = load_data()
    target = data["campaign"] if kind == "campaign" else data["chapter"] if kind == "chapter" else next((e for e in data[COLLECTION[kind]] if e["key"] == key), None)
    if target is not None:
        for name, value in changes.items():
            if name in ("place_id", "parent_id", "chapter_id"):
                continue
            target[name] = value
        save_data(data)
        print("the data file updated")


def do_check():
    client, state, base = connect()
    export = client.call("GET", base + "/export")
    data = load_data()
    expected = {"places": len(data["places"]), "npcs": len(data["npcs"]), "items": len(data["items"])}
    actual = {name: len(export[name]) for name in expected}
    print("expected", expected)
    print("on server", actual, "chapters", len(export["chapters"]))
    if expected != actual or len(export["chapters"]) != 1:
        fail("counts differ")
    print("ok")


def do_diff():
    client, state, base = connect()
    export = client.call("GET", base + "/export")
    data = load_data()
    differences = 0
    for kind, collection in COLLECTION.items():
        by_id = {entry["id"]: entry for entry in export[collection]}
        for entry in data[collection]:
            entry_id = state[collection].get(entry["key"])
            if entry_id is None:
                print("not on server:", kind, entry["key"])
                continue
            for name in FIELDS[kind]:
                if name in ("parent_id", "chapter_id", "place_id", "encounter_table_id", "bestiary_id", "notes_de") or name not in entry:
                    continue
                if (by_id[entry_id].get(name) or "") != (entry[name] or ""):
                    differences += 1
                    print("differs:", kind, entry["key"], name)
    print("differences:", differences)


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return
    command = argv[1]
    if command == "import":
        do_import("--dry-run" in argv)
    elif command == "sync":
        do_sync()
    elif command == "image" and len(argv) == 5:
        do_image(argv[2], argv[3], argv[4])
    elif command == "edit" and len(argv) >= 5:
        do_edit(argv[2], argv[3], argv[4:])
    elif command == "check":
        do_check()
    elif command == "diff":
        do_diff()
    else:
        print(__doc__)


main(sys.argv)
