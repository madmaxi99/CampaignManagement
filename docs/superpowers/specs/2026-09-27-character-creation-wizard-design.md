# Charaktererstellungs-Wizard (Dragonbane)

Status: Entwurf zur Durchsicht. Alle Regeln sind entweder wörtlich von dir
vorgegeben, gegen die 7 vorhandenen Pregens (`database/seed_pregens.sql`)
gegengeprüft, oder direkt aus Screenshots des vollständigen (englischen)
Kernregelwerks übernommen (Kapitel 2 "Your Player Character" und Kapitel 3
"Skills", inkl. Heroic Abilities). Die Katalog-Referenzdaten (Kins, Professionen,
Fertigkeiten-Pools, Talente, ausgewählte Startausrüstung) sind bereits als
Schema-Erweiterung + Seed geschrieben und in die laufende Dev-DB geladen, siehe
"Offene Punkte" für Korrekturen/Vereinfachungen, die du gegenlesen solltest.

## Ziel

Auf `/characters` einen Button "Charakter erstellen", der zu `/character/create`
führt: ein geführter Wizard durch die Standard-Dragonbane-Erstellung, der am Ende
einen vollständigen Charakter in der bestehenden DB anlegt und auf
`/character/{slug}` weiterleitet.

## Nicht-Ziele (bewusst weggelassen)

- Kein virtueller Würfel irgendwo (weder Attribute noch Alter) — Werte werden von
  echten Würfeln am Tisch abgetippt.
- Keine Magier/Barde/Gelehrter/Handwerker-Inhalte — nur die 7 Berufe, die bereits als
  Pregens existieren (Jäger, Ritter, Dieb, Kämpfer, Händler, Seefahrerin,
  Zwergenkämpfer). Zaubersprüche/Schulen bleiben außen vor.
- Kein Entwurfs-/Draft-Datensatz in der DB während des Ausfüllens. Bei Reload ist der
  Fortschritt weg — für eine Tisch-Sitzung akzeptabel.
- Kein Portrait-Upload (bestehendes `onerror`-Verhalten im Template reicht weiterhin).
- Keine Kampagnen-Verknüpfung (Characters haben aktuell keine FK zu campaigns).

## Architektur

Eine Route `GET /character/create` liefert eine Seite mit Vanilla-JS aus (passt zum
bestehenden Muster: der Charakterbogen macht seine Live-Interaktion schon per
`fetch` gegen JSON-Endpunkte, siehe `public/js/`). Der Wizard hält seinen Zustand
komplett clientseitig in einem JS-Objekt, holt Katalogdaten über kleine GET-Endpunkte
und schreibt erst im letzten Schritt per `POST /characters` alles auf einmal.

Neue Endpunkte in `backend/public/index.php`:

- `GET /character/create` — Wizard-Shell (Twig)
- `GET /api/character-creation/catalog` — liefert Kins, Professionen (inkl.
  Schlüsselfertigkeiten, Ausrüstungsoptionen, wählbare Heroische Talente), die
  30 Fertigkeiten mit `attribute_code`, die Ausrüstungskataloge (schon vorhanden:
  `weaponCatalog`/`armorCatalog`/`miscCatalog`-Methoden lassen sich wiederverwenden)
- `POST /characters` — nimmt das fertige Wizard-Ergebnis entgegen, legt Character +
  alle Unterzeilen an (analog zu dem, was `seed_pregens.sql` heute per SQL macht),
  antwortet mit `{"slug": "..."}`

Neue Datei `backend/src/CharacterCreationRepository.php` (neue Klasse statt die
bestehende `CharacterRepository` aufzublähen — klare Trennung: lesend für die
bestehende Bogen-Ansicht vs. schreibend für die Neuanlage).

## Neue Datenbank-Tabellen

Reine Referenzdaten für den Wizard — beim Anlegen werden nur die Ergebnisse (Text,
Werte) in `characters`/`character_skills`/`character_talents`/... kopiert, genau wie
es `seed_pregens.sql` heute schon per Hand vormacht. Keine FK von `characters`
zurück auf diese Tabellen.

```sql
CREATE TABLE kins (
    code VARCHAR(20) PRIMARY KEY,        -- 'mensch', 'halbling', 'zwerg', 'elf', 'ente', 'wolfsmensch'
    name_de VARCHAR(50) NOT NULL,
    d12_min INT NOT NULL,
    d12_max INT NOT NULL,
    movement_base INT NOT NULL
);

CREATE TABLE kin_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kin_code VARCHAR(20) NOT NULL,
    name_de VARCHAR(100) NOT NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (kin_code) REFERENCES kins(code)
);

CREATE TABLE professions (
    code VARCHAR(30) PRIMARY KEY,        -- 'jaeger', 'ritter', 'dieb', 'kaempfer', 'haendler', 'seefahrerin', 'zwergenkaempfer'
    name_de VARCHAR(50) NOT NULL,
    kin_restriction VARCHAR(20) NULL,     -- z.B. 'zwerg' für Zwergenkämpfer, sonst NULL
    FOREIGN KEY (kin_restriction) REFERENCES kins(code)
);

CREATE TABLE profession_key_skills (
    profession_code VARCHAR(30) NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (profession_code, skill_id),
    FOREIGN KEY (profession_code) REFERENCES professions(code),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

CREATE TABLE profession_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    profession_code VARCHAR(30) NOT NULL,
    name_de VARCHAR(100) NOT NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL,
    FOREIGN KEY (profession_code) REFERENCES professions(code)
);

-- Allgemeine Heroische Talente, die jeder Beruf zusätzlich zur Auswahl anbieten kann
CREATE TABLE general_heroic_abilities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_de VARCHAR(100) NOT NULL,
    wp_note_de VARCHAR(100) NULL,
    description_de TEXT NOT NULL
);
CREATE TABLE profession_gear_options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    profession_code VARCHAR(30) NOT NULL,
    option_label VARCHAR(10) NOT NULL,     -- 'A', 'B', ...
    FOREIGN KEY (profession_code) REFERENCES professions(code)
);

CREATE TABLE profession_gear_option_items (
    gear_option_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (gear_option_id) REFERENCES profession_gear_options(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id)
);

CREATE TABLE flaws (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_min INT NOT NULL,
    roll_max INT NOT NULL,
    name_de VARCHAR(50) NOT NULL,
    description_de VARCHAR(255) NOT NULL
);
```

Alle mehrzeiligen SQL-Strings in `CharacterCreationRepository.php` als Heredoc
(`<<<SQL`), analog zum bestehenden Stil in `CharacterRepository.php`.

## Ablauf & Regeln pro Schritt

### 1. Volk (Kin)

Auswahl per Klick oder d12-Wurf (Tabelle nur als Info/Hilfstext, kein virtueller
Würfler):

| W12 | Volk |
|---|---|
| 1–4 | Mensch |
| 5–7 | Halbling |
| 8–9 | Zwerg |
| 10 | Elf |
| 11 | Ente |
| 12 | Wolfsmensch |

Angeborene Talente (aus Pregens gegengeprüft, siehe unten):

| Volk | Angeborenes Talent | Quelle |
|---|---|---|
| Elf | Innerer Frieden | bestätigt (Orla) |
| Ente | Übellaunig **und** Schwimmhäute (Enten haben laut Schnellstarter S.5 als einziges Volk zwei) | bestätigt (Makander) |
| Zwerg | Nachtragend | aus Daten abgeleitet — taucht bei beiden Zwerg-Pregens (Alberich, Urd) auf, sonst bei niemandem |
| Mensch | Anpassungsfähig | vom Nutzer bestätigt — deckt sich wortgleich mit Beatrix' Talent in `seed_pregens.sql` |
| Halbling | Schwer zu fassen | vom Nutzer bestätigt — deckt sich wortgleich mit Krisannas Talent in `seed_pregens.sql` |
| Wolfsmensch | Jagdinstinkt | vom Nutzer bestätigt (ausführlichere Fassung als in `seed_pregens.sql`, s.u.) |

Wortlaut — jetzt für alle 6 direkt aus den Kernregelwerk-Screenshots (Kapitel 2,
S. 10–13) übernommen bzw. gegengeprüft:

- **Anpassungsfähig** (Mensch, WP 3): "Bei einer Fertigkeitsprobe kannst du dich
  entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen. Du
  musst allerdings erklären können, wie die gewählte Fertigkeit die ursprüngliche
  ersetzen kann. Die Spielleitung hat dabei das letzte Wort, sollte aber
  großzügig sein."
- **Schwer zu fassen** (Halbling, WP 3): "Du kannst dieses Talent aktivieren, wenn
  du einem Angriff ausweichst, um einen Vorteil auf deine Ausweichen-Probe zu
  erhalten."
- **Nachtragend** (Zwerg, WP 3, bestätigt als "Unforgiving"): "Du kannst dieses
  Talent aktivieren, wenn du jemanden angreifst, der dir in der Vergangenheit
  geschadet hat (mindestens 1 Schadenspunkt), und erhältst einen Vorteil auf den
  Wurf. Es spielt keine Rolle, wann der Schaden zugefügt wurde. Es kann klug
  sein, sich die Namen aller zu notieren, die einem geschadet haben, um sie
  nicht zu vergessen."
- **Innerer Frieden** (Elf, WP —, keine Kosten): "Als Elf kannst du während einer
  kurzen Rast meditieren. Du heilst einen zusätzlichen W6 TP sowie einen
  weiteren W6 WP, außerdem kannst du dich von einem zusätzlichen Zustand
  erholen. Während der Meditation bist du völlig regungslos und kannst nicht
  aufgeweckt werden."
- **Übellaunig** (Ente, WP 3): "Enten neigen zu einem cholerischen Temperament.
  Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine
  Fertigkeitsprobe ablegst, und erhältst einen Vorteil auf den Wurf. Zusätzlich
  wirst du wütend, falls du es nicht bereits bist. Dieses Talent kann nicht für
  Proben auf INT oder INT-basierte Fertigkeiten verwendet werden." **plus**
  **Schwimmhäute** (Ente, WP —, keine Kosten — Enten sind laut Regelwerk das
  einzige Volk mit zwei angeborenen Talenten): "Als Ente erhältst du außerdem
  einen Vorteil auf alle Schwimmen-Proben. Du bewegst dich an der
  Wasseroberfläche oder unter Wasser stets mit voller Geschwindigkeit."
- **Jagdinstinkt** (Wolfsmensch, WP 3): "Du kannst dieses Talent aktivieren, um
  eine Kreatur in Sichtweite oder deren Geruch du wahrnehmen kannst, als deine
  Beute zu markieren. Dies zählt im Kampf als eine Aktion. Du kannst der Fährte
  deiner Beute einen ganzen Tag lang folgen und zusätzlich 1 WP ausgeben (keine
  Aktion), um einen Vorteil auf einen Angriff gegen deine Beute zu erhalten."

### 2. Beruf (Profession)

Die 7 vorhandenen: Jäger, Ritter, Dieb, Kämpfer, Händler, Seefahrerin,
Zwergenkämpfer (nur für Zwerge wählbar — kin-exklusiver Kämpfer-Beruf).

### 2.5 Name & Alter

Name: Freitext. Alter: manuell würfeln (W6) oder direkt auswählen, kein virtueller
Würfler.

| W6 | Alter | Fertigkeitspunkte gesamt | Attribut-Modifikatoren |
|---|---|---|---|
| 1–3 | Jung | 6 (Beruf) + 2 frei = 8 | GEW +1, KON +1 |
| 4–5 | Erwachsen | 6 (Beruf) + 4 frei = 10 | keine |
| 6 | Alt | 6 (Beruf) + 6 frei = 12 | STA −2, GEW −2, KON −2, INT +1, WIL +1 (nie über 18) |

Gegengeprüft: alle 7 Pregens landen exakt bei 8/10/12 gelernten Fertigkeiten passend
zu ihrem Alter.

### 3. Attribute

Kein virtueller Würfler. UI erklärt nur die Methode und nimmt 6 Eingaben entgegen:

> Würfle 4W6, entferne den niedrigsten Wurf, macht das sechsmal (STA, KON, GEW,
> INT, WIL, CHA in dieser Reihenfolge). Danach darfst du zwei der sechs Werte genau
> einmal miteinander tauschen.

Die Alters-Modifikatoren aus Schritt 2.5 werden danach auf die eingetragenen Werte
addiert (Cap 18).

### 4. Abgeleitete Werte (automatisch berechnet, direkt angezeigt)

**Bewegung** = Basiswert nach Volk + Modifikator nach GEW:

| Volk | Basis |
|---|---|
| Mensch, Elf | 10 |
| Halbling, Zwerg, Ente | 8 |
| Wolfsmensch | 12 |

| GEW | Modifikator |
|---|---|
| 1–6 | −4 |
| 7–9 | −2 |
| 10–12 | ±0 |
| 13–15 | +2 |
| 16–18 | +4 |

Gegengeprüft gegen alle 7 Pregens — jede berechnete Bewegung stimmt exakt mit der
gespeicherten überein (Ausnahme Urd: Movement dort ist `0` in den Seeds — das ist ein
bestehender Datenfehler in `seed_pregens.sql`, unabhängig von diesem Feature, fasse
ich hier nicht an).

**Schadensbonus** (getrennt für STA und GEW, gleiche Tabelle für beide):

| Wert | Bonus |
|---|---|
| ≤ 12 | — |
| 13–16 | W4 |
| 17–18 | W6 |

Gegengeprüft, passt exakt.

**TP (max)** = KON-Wert, + 2 falls das allgemeine Heroische Talent "Robust" gewählt
wurde (keine Voraussetzung, keine WP-Kosten, beliebig oft wählbar — s. Schritt 6).
Für die Erstanlage im Wizard reicht "einmal wählbar"; erneutes Wählen ist ein
Downtime-/Levelup-Mechanismus außerhalb dieses Wizards.

**WP (max)** = WIL-Wert, + 2 falls "Fokussiert" gewählt wurde. Gleiche Regeln wie
Robust.

Beide Formeln (ohne Talent-Bonus) exakt gegen alle 7 Pregens gegengeprüft; die
+2-Boni sind jetzt auch durch den Regelwerk-Screenshot direkt bestätigt (s.
Schritt 6 für die Korrektur zu den WP-Kosten).

**Traglast** = aufgerundet(STA / 2). Nicht im Schnellstarter explizit als Formel
benannt, aber exakt gegen alle 7 Pregens gegengeprüft (STA 8→4, 10→5, 13→7,
14→7, 16→8, 18→9 — passt in jedem Fall).

### 5. Fertigkeiten

Basiswert nach Attribut (jetzt direkt aus dem Kernregelwerk-Screenshot der
Skills-Seite (Kapitel 3, S. 25) übernommen, deckt sich exakt mit dem, was vorher
aus den Pregens zurückgerechnet war):

| Attributwert | Basiswert |
|---|---|
| 1–5 | 3 |
| 6–8 | 4 |
| 9–12 | 5 |
| 13–15 | 6 |
| 16–18 | 7 |

Wird eine Fertigkeit "gelernt", wird ihr Basiswert verdoppelt.

**Korrektur gegenüber der Vorversion dieser Spec:** Der Beruf gibt keine 6
*festen* Schlüsselfertigkeiten vor, sondern einen **Pool von 8 Fertigkeiten**, aus
dem genau 6 gewählt werden müssen ("Six of your trained skills must be selected
from those listed by your profession", S. 25). Die restlichen (2/4/6 je nach
Alter, s. Schritt 2.5) sind komplett frei aus allen 30 Fertigkeiten wählbar. Der
Wizard muss also pro Beruf einen 8er-Pool anzeigen und den Spieler daraus genau 6
auswählen lassen, statt 6 automatisch vorzugeben.

Die 30 Fertigkeiten samt Attribut-Zuordnung stehen schon vollständig in der DB
(`database/seed_aodhan.sql`, `INSERT INTO skills`) — keine neue Quelle nötig, nur
Auslesen. "Sekundäre Fertigkeiten" = Magieschulen (aktuell nur Elementarismus) —
für die 7 Berufe hier irrelevant, wie du sagtest.

Fertigkeiten-Pool pro Beruf — jetzt **wortwörtlich aus dem Kernregelwerk**
(Kapitel 2, S. 16–18, 20–21, 23) übernommen, nicht mehr rekonstruiert:

| Beruf | 8er-Fertigkeiten-Pool (6 davon wählen) | Schlüsselattribut |
|---|---|---|
| Kämpfer / Zwergenkämpfer | Äxte, Bögen, Prügelei, Armbrüste, Ausweichen, Hämmer, Speere, Schwerter | STA |
| Jäger | Akrobatik, Wahrnehmung, Bögen, Wildnisleben, Jagen & Fischen, Messer, Schleudern, Heimlichkeit | GEW |
| Ritter | Bestienkunde, Hämmer, Mythen & Legenden, Darbietung, Überzeugen, Reiten, Speere, Schwerter | STA |
| Seefahrerin | Akrobatik, Wahrnehmung, Jagen & Fischen, Messer, Fremdsprachen, Seefahrt, Schwimmen, Schwerter | GEW |
| Händler | Wahrnehmung, Feilschen, Täuschen, Ausweichen, Messer, Überzeugen, Fingerfertigkeit, Entdecken | CHA |
| Dieb | Akrobatik, Wahrnehmung, Täuschen, Ausweichen, Messer, Fingerfertigkeit, Heimlichkeit, Entdecken | GEW |

**Wichtige Korrektur zu "Zwergenkämpfer":** Im vollständigen Regelwerk gibt es
gar keinen eigenen Beruf "Zwergenkämpfer" — die 10 offiziellen Berufe sind
Handwerker, Barde, Kämpfer, Jäger, Ritter, Magier, Seefahrer(in), Händler,
Gelehrte(r), Dieb. Urds "Zwergenkämpfer" in `seed_pregens.sql` ist mechanisch
einfach ein ganz normaler **Kämpfer** mit einem zwergisch klingenden Flavour-Namen.
Der Wizard bildet das nach: `zwergenkaempfer` in der `professions`-Tabelle nutzt
exakt dieselben Fertigkeiten/Ausrüstung/Talent-Zeilen wie `kaempfer`, nur mit
anderem `name_de` und `kin_restriction = 'zwerg'`.

### 6. Heroisches Talent

**Korrektur gegenüber der Vorversion:** Es ist keine Auswahlliste — jeder Beruf
gewährt zu Beginn genau **ein** festes Heroisches Talent (Ausnahme Magier: keins,
dafür Magie). Quelle: die Berufs-Übersichtsseiten (Kapitel 2) nennen je Beruf genau
einen Eintrag "Heroic Ability: ...", und Kapitel 3 (S. 36–39) liefert die vollen
Beschreibungen samt Voraussetzung/WP-Kosten. Die abweichenden Zusatz-Talente in
den bestehenden Pregens (z. B. Orlas "Doppelschuss" statt "Gefährte") sind
offenbar Freiheiten der Schnellstarter-Autoren und keine RAW-Startausstattung —
der Wizard folgt der Regelwerk-Version, nicht den Pregens.

| Beruf | Heroisches Talent | Voraussetzung | WP-Kosten |
|---|---|---|---|
| Kämpfer / Zwergenkämpfer | Veteran | Beliebige Waffenfertigkeit 12 | 1 |
| Jäger | Gefährte | Jagen & Fischen 12 | 3 |
| Ritter | Beschützer | Äxte, Hämmer oder Schwerter 12 | 2 |
| Seefahrerin | Seebeine | Schwimmen 12 | 1 |
| Händler | Goldnase | Feilschen 12 | 3 |
| Dieb | Hinterhältig | Messer 12 | 3 |

Wortlaut (aus dem Regelwerk übersetzt, Beschützer/Seebeine/Goldnase/Hinterhältig/
Veteran decken sich inhaltlich mit den schon in `seed_pregens.sql` vorhandenen
Texten):

- **Veteran**: "Wenn du dieses Talent zu Beginn einer Kampfrunde aktivierst,
  kannst du deine Initiativekarte aus der letzten Runde behalten, anstatt eine
  neue zu ziehen. Das zählt nicht als Aktion."
- **Gefährte** (neu übersetzt, keine Vorlage in `seed_pregens.sql`): "Du kannst
  dieses Talent aktivieren, um ein Tier (kein Monster) zu deinem Gefährten zu
  machen. Das dauert eine Weile, und du kannst immer nur einen Tiergefährten
  gleichzeitig haben. Die Spielleitung entscheidet, welche Tiere in der Nähe
  sind. Das Tier folgt dir, solange du dich in seiner natürlichen Umgebung
  aufhältst, und kann für dich ohne zusätzliche WP-Kosten aufklären. Für 3
  weitere WP kannst du dem Tier befehlen, einen Feind anzugreifen (das kostet
  dich keine Aktion)."
- **Beschützer**: wortgleich mit dem bereits vorhandenen Text in `seed_pregens.sql`.
- **Seebeine**: wortgleich mit dem bereits vorhandenen Text.
- **Goldnase**: wortgleich mit dem bereits vorhandenen Text.
- **Hinterhältig**: wortgleich mit dem bereits vorhandenen Text.

`profession_heroic_abilities` hat inzwischen eine Spalte `granted_at_creation`
(1 = automatisch vergeben, 0 = nicht Teil der Start-Vergabe). Die Pregen-Talente,
die vom RAW-Start-Talent abweichen (Orlas "Doppelschuss", Urds "Furchtlos" —
vermutlich später dazugewonnene Talente, nicht Start-Ausstattung), sind mit
`granted_at_creation = 0` mit-katalogisiert, damit sie für ein späteres
Aufleveln-Feature schon vorliegen. Der Wizard filtert beim Anlegen nach
`granted_at_creation = 1`.

Zusätzlich immer wählbar, unabhängig vom Beruf (in `general_heroic_abilities`):

| Name | Voraussetzung | WP-Kosten | Effekt |
|---|---|---|---|
| Robust | — | **—** | Maximale TP dauerhaft +2, beliebig oft wählbar |
| Fokussiert | — | **—** | Maximale WP dauerhaft +2, beliebig oft wählbar |

**Korrektur:** Der Screenshot der Regelwerk-Seite (Kap. 3, S. 37) zeigt für
beide Talente explizit "Willpower Points: —", also **keine** Aktivierungskosten
— es ist ein passiver, permanenter Bonus. Das widerspricht deiner vorherigen
Angabe von "WP 2". Ich vertraue hier dem direkten Foto der Regelseite als
Primärquelle und übernehme "keine Kosten"; sag Bescheid, falls du das anders
willst (z. B. falls ihr am Tisch bewusst eine Hausregel mit WP-Kosten spielt).

### 7. Schwäche

20 Einträge, W20. Übersetzung an den bestehenden deutschen Formulierungen in
`seed_pregens.sql` ausgerichtet, wo vorhanden (7 der 20 Einträge kommen dort
bereits wortgleich vor — starkes Indiz für die korrekte offizielle Übersetzung):

| W20 | Name | Beschreibung |
|---|---|---|
| 1 | Leichtgläubig | Ich glaube alles, was andere mir erzählen. |
| 2 | Gierig | Ich will immer einen größeren Anteil an jedem Schatz. |
| 3 | Dünnhäutig | Ich ertrage keine Provokation. |
| 4 | Tollkühn | Ich stürze mich stets als erster in Gefahr. |
| 5 | Ängstlich | Ich halte mich immer im Hintergrund der Gruppe. |
| 6 | Monsterjäger | Alle Monster sind böse und müssen getötet werden. |
| 7 | Voreingenommen | Nachtvolk wie Orks und Goblins ist böse und muss bekämpft werden. |
| 8 | Faul | Ich nutze jede Gelegenheit, um mich auszuruhen. |
| 9 | Verfressen | Ich nutze jede Gelegenheit, um etwas Schmackhaftes zu essen. |
| 10 | Kleptomanisch | Ich kann nicht anders, als Wertgegenstände zu stehlen. |
| 11 | Eitel | Ich helfe jedem, der mich lobt oder mir Komplimente macht. |
| 12 | Unbesonnen | Ich gehe immer große Risiken ein, ohne über die Konsequenzen nachzudenken. |
| 13 | Magiefeindlich | Magie ist eine böse Macht, Magiern kann nicht vertraut werden. |
| 14 | Wissbegierig | Die Jagd nach Wissen ist mir wichtiger als meine Freunde. |
| 15 | Kind der Wildnis | Ich schlafe niemals in Innenräumen. |
| 16 | Prahlerisch | Ich übertreibe stets meine Heldentaten. |
| 17 | Gewalttätig | Ich greife bei jedem Hindernis zur Gewalt. |
| 18 | Anmaßend | Ich sage anderen ständig, was sie tun sollen. |
| 19 | Pessimistisch | Ich glaube immer, dass sich die Dinge zum Schlechteren wenden. |
| 20 | Hochnäsig | Ich schaue auf jeden herab, den ich treffe. |

### 8. Ausrüstung

Das Regelwerk gibt pro Beruf tatsächlich **2–3 W6-Ausrüstungs-Optionen** vor
(Kapitel 2, S. 14–23), inkl. Naturalien wie Fackel/Feuerstein & Zunder/
Tagesrationen/Seil, die im Bestand dieses Projekts bisher nicht als
Katalog-Items geführt werden (nur als `misc_items_de`-Freitext).

**Bewusste Vereinfachung:** Ich habe pro Beruf nur **eine** (die erste,
"1–2"-Zeile im Buch) der 2–3 offiziellen Optionen ins Seed übernommen, und dabei
nur Waffen/Rüstung als echte Katalog-Items abgebildet (das ist auch das
Einzige, was der bestehende Charakterbogen strukturiert darstellt);
Verbrauchsgüter wie Rationen/Seil bleiben Freitext wie bisher. Grund: die
übrigen Optionen sind fürs MVP nicht kriegsentscheidend, der Charakter kann
seine Ausrüstung im bestehenden Bogen jederzeit frei anpassen. Bei Bedarf
später einfach die restlichen Optionen ergänzen.

Neue Katalog-Items, die dafür nötig waren (Preise grob an die bestehende
Preisskala des Projekts angepasst, nicht 1:1 die Gold-Preise aus dem
Regelwerk übernommen, da diese bestehende Preisskala schon deutlich niedriger
liegt als RAW):

| Item | Typ | Werte | Kupfer | Für Beruf |
|---|---|---|---|---|
| Kurzbogen | Waffe | 2-händig, Reichweite 30, W10, Haltbarkeit 3 | 90 | Jäger, Seefahrerin |
| Langschwert | Waffe | 1-händig, Reichweite 2, 2W6, Haltbarkeit 12 | 160 | Ritter |
| Schleuder | Waffe | 1-händig, Reichweite 20, W8 | 15 | Dieb |

Gewählte Ausrüstung pro Beruf (nur Waffen/Rüstung, Rest bleibt Freitext):

| Beruf | Ausrüstung |
|---|---|
| Kämpfer / Zwergenkämpfer | Streitaxt, Schild klein, Kettenpanzer |
| Jäger | Dolch, Kurzbogen, Köcher, Lederrüstung |
| Ritter | Langschwert, Schild klein, Plattenpanzer |
| Seefahrerin | Dolch, Kurzbogen, Köcher, Wurfhaken, Seil (Hanf) |
| Händler | Dolch, Seil (Hanf) |
| Dieb | Dolch, Schleuder, Seil (Hanf), Wurfhaken |

Währung: 100 Kupfer = 10 Silber = 1 Gold (wie bisher im Sheet/Seed-Daten).

### 9. Memento

Freitext, ein Gegenstand ohne praktischen Nutzen. 1×/Sitzung nutzbar, um einen
Zustand während einer langen Rast zu heilen. Bei Verlust wählt man am Ende einer
Sitzung einfach ein neues Memento.

**Bug-Fix nebenbei:** `character.memento_de` existiert in der DB und wird für alle
Pregens befüllt, taucht aber in `backend/templates/character/sheet.twig` nirgends
auf — das Feld fehlt im Sheet komplett. Wird im Rahmen dieser Arbeit ergänzt
(kleine Sektion oder Zeile im Header, analog zu Schwäche/Aussehen).

### 10. Aussehen

Freitext (Beispiel aus deiner Nachricht: "Groß und drahtig. Langer weißer Bart und
buschige Augenbrauen. Wissbegieriger Blick.").

### Abschluss

Zusammenfassung aller Schritte → `POST /characters` → Redirect auf
`/character/{slug}`. Slug wird wie bei den Pregens aus dem Namen abgeleitet
(ASCII, snake_case).

## Testplan

- Manuell: alle 7 Berufe × mindestens 2 Völker durchklicken, prüfen dass TP/WP/
  Bewegung/Schadensbonus mit den Formeln übereinstimmen.
- Stichprobe: einen Wizard-Charakter mit identischen Eingaben wie ein bestehendes
  Pregen durchspielen und die Werte 1:1 vergleichen.
- Kein automatisiertes Test-Setup im Projekt vorhanden (kein PHPUnit o.ä.
  eingerichtet) — bleibt bei manueller Prüfung, es sei denn du willst das separat
  aufsetzen.

## Offene Punkte

Keine mehr — alle drei ursprünglich offenen Punkte sind vom Nutzer bestätigt:

1. ~~Volks-Talent für Mensch, Halbling, Wolfsmensch~~ — durch Screenshots aus dem
   Kernregelwerk (Kap. 2, S. 10–13) vollständig bestätigt, siehe Schritt 1.
2. ~~Genauer HP-/WP-Bonus von "Robust"/"Fokussiert"~~ — Screenshot zeigt keine
   WP-Kosten ("—"), nicht "WP 2" wie ursprünglich getippt (Zeilenverrutscher beim
   Nutzer). Vom Nutzer bestätigt: keine Kosten ist korrekt. Siehe Schritt 6.
3. ~~Schlüsselfertigkeiten pro Beruf~~ — durch Screenshots vollständig geklärt,
   **mit Korrektur**: kein fixes 6er-Set, sondern ein 8er-Pool zur Auswahl von 6.
   Siehe Schritt 5.

Spec ist damit freigegeben. Weiter geht's mit der Implementierungsplanung.

Neu aus den Screenshots hinzugekommen (keine offenen Fragen, nur Hinweise):

4. "Zwergenkämpfer" ist kein eigenständiger Beruf im Regelwerk, sondern
   mechanisch identisch mit "Kämpfer" (Flavour-Name für Zwerge). So umgesetzt.
5. Heroisches Talent pro Beruf ist keine Auswahlliste, sondern **ein** fixer
   Eintrag (Ausnahme Magier: keiner). Die bisher in `seed_pregens.sql` gezeigten
   Zusatz-Talente (z. B. Orlas "Doppelschuss") scheinen Freiheiten der
   Schnellstarter-Pregens zu sein, keine RAW-Startausstattung — der Wizard folgt
   dem Regelwerk.
6. Ausrüstungs-Optionen pro Beruf bewusst auf 1 von 2–3 offiziellen Optionen
   reduziert (nur Waffen/Rüstung als echte Items, Rest bleibt Freitext) — siehe
   Schritt 8.
7. Die Screenshots ab ca. S. 60 sind das Magie-Kapitel (Zaubersprüche/Schulen) —
   wie vereinbart nicht ausgewertet, da für die 7 relevanten Berufe irrelevant.

Alles andere in dieser Spec ist entweder wörtlich das, was du vorgegeben hast,
gegen die 7 Pregens exakt gegengeprüft, oder jetzt direkt aus den
Kernregelwerk-Screenshots übernommen.
