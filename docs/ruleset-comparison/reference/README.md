# 13th Age SRD — aufgeteilte Textversion (Markdown)

Quelle: [13th Age Archmage Engine v4.0](https://www.pelgranepress.com/srv/htdocs/wp-content/uploads/2013/10/13th-Age-Archmage-Engine-v4.0.pdf)
(Pelgrane Press, © 2013–2023 Fire Opal Media, lizenziert unter der Open Game License). Ursprünglich per `pdftotext`
aus dem offiziellen PDF extrahiert, anschließend in lesbares Markdown überführt (Tabellen rekonstruiert, Kapitel-
Rauschen entfernt) — kein eigener Text, keine Umformulierung der eigentlichen Regeln.

## Dateien

| Datei | Inhalt | Umfang |
|---|---|---|
| `01-character-rules.md` | Grundlegende Charakterregeln (Attribute, Hintergründe, One Unique Thing, Ausrüstungspreise) | 14 Seiten |
| `02-races-kin.md` | Alle Rassen (Kin) mit ihren Rassen-Talenten | 6 Seiten |
| `03-classes-01-barbarian-bard-chaosmage.md` | Klassen: Barbarian, Bard, Chaos Mage | ~65 Seiten |
| `03-classes-02-cleric-commander-druid.md` | Klassen: Cleric, Commander, Druid | ~90 Seiten |
| `03-classes-03-fighter-monk-necromancer-occultist.md` | Klassen: Fighter, Monk, Necromancer, Occultist | ~90 Seiten |
| `03-classes-04-paladin-ranger-rogue-sorcerer-wizard.md` | Klassen: Paladin, Ranger, Rogue, Sorcerer, Wizard | ~85 Seiten |
| `04-combat-rules.md` | Kampfregeln, Escalation Die, Aktionen, Zustände | 15 Seiten |
| `05-icons.md` | Kurzverweis auf die Icons-Mechanik (Details stehen in Running the Game) | 2 Seiten |
| `06-magic-items.md` | Alle magischen Gegenstände/Items | 35 Seiten |
| `07-monsters-teil1-seiten1-107.md` | Bestiarium, Teil 1 von 4 | ~107 Seiten |
| `07-monsters-teil2-seiten108-214.md` | Bestiarium, Teil 2 von 4 | ~107 Seiten |
| `07-monsters-teil3-seiten215-320.md` | Bestiarium, Teil 3 von 4 | ~106 Seiten |
| `07-monsters-teil4-seiten321-426.md` | Bestiarium, Teil 4 von 4 (inkl. Monster-Creation-Anhang) | ~106 Seiten |
| `08-multiclassing.md` | Multiklassen-Regeln (inkl. vollständiger Key-Ability-Modifier-Matrix) | 10 Seiten |
| `09-running-the-game.md` | GM-Anleitung, Icons im Detail, Kampagnenaufbau, Loot-Tabellen | 8 Seiten |
| `10-legal-ogl.md` | Open Game License, Product Identity, Revision History | 13 Seiten |
| `13th-age-srd.txt` | **Gesamtes Dokument als eine Roh-Textdatei** (791 Seiten, unformatiert) — bewusst als reiner Text belassen für schnelle, token-effiziente `grep`-Volltextsuche über alles hinweg | 791 Seiten |

**Warum die Klassen und das Bestiarium jeweils in 4 Teile gesplittet sind:** Beide Kapitel sind mit Abstand am
längsten (275 bzw. 426 Seiten). Die Klassen sind nach Klassen-Gruppen getrennt (jede Datei enthält 3–5 komplette
Klassen inkl. aller ihrer Talente/Zauber/Level-Tabellen). Das Bestiarium ist dagegen **nach Seitenbereich** getrennt,
nicht nach Kreatur-Typ/-Familie — der extrahierte Text enthielt keine zuverlässig maschinenlesbaren
Kategorie-Marker (keine sauberen "Drachen"/"Untote"/…-Überschriften im Klartext), ein automatischer Themen-Split
wäre also geraten statt verlässlich gewesen. Falls eine bestimmte Kreatur gesucht wird: entweder gezielt in den 4
Teilen `grep`-en oder gleich `13th-age-srd.txt` durchsuchen.

## Wichtiger Hinweis zu "Zaubern"

Es gibt **keine eigene Zauber-Datei**. Grund: 13th Age hat keinen einheitlichen "Spells"-Abschnitt über alle
Klassen hinweg — der Wizard hat eine klassische Zauberliste ("Spells"), der Cleric arbeitet stattdessen mit
"Domains", andere Klassen (Chaos Mage, Necromancer, Occultist, Bard...) nennen ihre Zauber-äquivalenten Fähigkeiten
wieder anders. Zauber/Domains/Rituale stehen deshalb dort, wo sie hingehören: in der jeweiligen `03-classes-*.md`,
im Abschnitt der zugehörigen Klasse.

## Qualität der Tabellen-Rekonstruktion

Die Original-PDF-Extraktion (`pdftotext`) reißt Tabellen oft auseinander: eine Spalte wird komplett ausgegeben,
dann erst die nächste, statt Zeile für Zeile. Beim Umbau in Markdown wurden solche Tabellen dort rekonstruiert, wo
die Zuordnung eindeutig war (z. B. Level-Fortschritts-Tabellen, Preislisten, die komplette 15×15-Key-Ability-
Modifier-Matrix in `08-multiclassing.md`). Wo eine Tabelle aus mehrspaltigem Fließtext bestand, dessen Zuordnung
sich aus dem linearen Text nicht mehr zweifelsfrei rekonstruieren ließ (z. B. die "Icon Relationships Master Chart"
in `01-character-rules.md`, oder vereinzelte Monster-Sonderfälle im Bestiarium), wurde das **nicht geraten**,
sondern der Inhalt in Original-Lesereihenfolge belassen und mit einem Hinweis versehen, der zur PDF-Seite verweist.
Diese Hinweise stehen jeweils direkt an der betroffenen Stelle in den Dateien.

Eine echte, im Original-PDF selbst vorhandene Inkonsistenz (nicht durch die Extraktion verursacht) wurde in der
Key-Ability-Modifier-Matrix gefunden und dort mit `*` markiert, statt sie stillschweigend in eine Richtung
aufzulösen.

## Nutzung

Für gezielte Fragen (z. B. "was macht Fireball genau") lohnt sich z. B. `grep -A 15 "^Fireball" 03-classes-04-paladin-ranger-rogue-sorcerer-wizard.md` —
oder, falls unklar ist, in welcher Datei ein Begriff steht, `grep -rn "Fireball" .` über den ganzen Ordner, oder
einfach `grep -A 15 "^Fireball" 13th-age-srd.txt` in der rohen Gesamtdatei.
