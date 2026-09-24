# GM-Tools

## NPC-Generator

Kein reiner Namensgenerator — jeder erzeugte NPC bekommt den vollen mechanischen Unterbau, exakt nach denselben Formeln wie ein PC ([01-charakter.md](01-charakter.md)), damit er sofort spielbar ist:

1. **Kin** — 1 von 9, gleichverteilt gewürfelt (siehe [11-katalog-kins.md](11-katalog-kins.md)).
2. **Profession** — 1 von 33, gleichverteilt gewürfelt oder vom GM gezielt gewählt (siehe [12-katalog-professionen.md](12-katalog-professionen.md)) → liefert das feste 5-Skill-Paket + Startgeld-Tendenz.
3. **Alter** — 1W10, jung-lastig (1–5 Jung / 6–8 Erwachsen / 9–10 Alt) → 2/4/6 frei wählbare Extra-Skills + Attribut-Trade-off (Jung +1 STR/−1 WIS, Alt +1 WIS/−1 STR).
4. **Attribute** — 4W6, niedrigsten Wurf verwerfen, sechsmal wiederholen, absteigend sortiert. Höchster Wurf → Primärstat der Profession, zweithöchster → CON, Rest frei/zufällig auf DEX/INT/WIS/CHA verteilt. Danach den Alters-Modifikator anwenden (geklemmt auf 3–18).
5. **Modifikatoren** — `floor((Wert − 10) / 2)` pro Attribut (siehe [02-kernmechanik.md](02-kernmechanik.md)).
6. **HP** = `10 + CON-Mod × 3`.
7. **Rüstungsbonus** — Kategorie-Würfel (Leicht 1W2 / Mittel 1W3 / Schwer 1W4) + Rarity-Flatbonus (Common +0 / Uncommon +1 / Rare +2 / Legendary +4); zählt nur, wenn Rüstungskunde vorhanden ist oder die Rüstung Leicht ist, sonst 0 (siehe [13-katalog-skills.md](13-katalog-skills.md)).
8. **AC** = `10 + DEX-Mod + Rüstungsbonus (falls anwendbar)`.
9. **Angriffsbonus** = `Primär-Mod + (2, falls Waffenkunde für die Waffe vorhanden) + Waffen-Verzauberungsbonus`.
10. **Schaden** = Waffenwürfel + `Primär-Mod (+ Verzauberungsbonus)`.
11. **Startgeld** — nach Wealth-Tier: Arm `1W6×5`, Durchschnittlich `2W6×5`, Wohlhabend `3W6×10`.
12. **SI** (nur falls der NPC kampfrelevant werden soll) — abgeleitet aus HP/AC/Angriff/Schaden gegen die Tier-Mittelwerte aus [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md).
13. **Flaw** — 1W14 aus der Liste in [01-charakter.md](01-charakter.md), optional ein 2. Flaw gegen einen zusätzlichen frei wählbaren Skill.
14. **Name** — pro Kin ein Namens-Baukasten (Vorname-Pool + Nachname/Beiname-Pool, WoW/D&D-Vibe passend zur Kin, siehe [11-katalog-kins.md](11-katalog-kins.md)), zufällig kombiniert.

## Waren-Generator

Würfelt das Warenangebot eines Ladens/Markts aus den Item-Katalogen ([15-katalog-items.md](15-katalog-items.md)), Festpreis-Logik (kein Verhandeln, siehe [07-ausruestung-und-oekonomie.md](07-ausruestung-und-oekonomie.md)) — Preise werden nie neu berechnet, nur der bereits fixierte Katalogpreis übernommen.

- **Angebotsgröße (Ausgangswert, tunbar):** `1W6+4` Common-Items, `1W4` Uncommon-Items, zusätzlich ein `1W20`-Check pro möglichem Rare-Slot (nur bei ≥18 erscheint ein Rare-Item). Legendary nie zufällig — nur bewusste GM-Platzierung.
- **Ortsgröße skaliert die Slots** (z. B. Dorf: halbe Common-Menge, kein Rare-Check; Großstadt: 1,5× Common, 2 Rare-Checks statt 1) — genaue Multiplikatoren offen, Feinjustierung folgt aus der Praxis.
- Optional: Laden bekommt einen Besitzer-NPC über den NPC-Generator oben.

## Loot-Table-Generator

Gewünscht — würfelt Loot direkt aus den Loot-Tabellen aus (siehe [08-loot-und-belohnung.md](08-loot-und-belohnung.md)).

## Cheat Sheet

Schnellreferenz für den GM, damit am Tisch nicht groß nachgeschlagen werden muss (z. B. Skills-Übersicht, Conditions, Kernmechanik-Werte). Dazu explizit die **Langzeitfolgen-Tabelle** aus [04-tod-und-konsequenzen.md](04-tod-und-konsequenzen.md) (8 positive + 8 negative Einträge, 1W100/1W8) als reine Anzeige-Tabelle ohne eigene Würfellogik im Tool — **die Spieler würfeln selbst** (eigene Würfel), das Tool zeigt nur nach, was welches Ergebnis bedeutet.

## Fraktions-/Reputations-Tracker

Kein Würfel-Mechanismus, ein reiner Zustands-Tracker pro NPC (nicht global/pro Fraktion):

- Pro NPC ein Reputationswert auf einer schmalen Skala: **−2 (Feindselig) / −1 (Misstrauisch) / 0 (Neutral) / +1 (Wohlgesonnen) / +2 (Verbündet)**.
- Der GM verschiebt den Wert manuell nach Ereignissen — kein automatisches Auf-/Abrechnen, keine verdeckte Formel dahinter. Bewusst konsistent mit der "Skill-Impact bleibt Prosa/GM-Adjudikation"-Philosophie ([13-katalog-skills.md](13-katalog-skills.md)).
- Hängt natürlich mit den Flaws **Verfeindet**/**Berüchtigt** aus [01-charakter.md](01-charakter.md) zusammen — ein NPC bei −2 gegenüber einem PC ist im Zweifel genau dessen Flaw-Ziel.
- Optional ein kurzes Freitext-Notizfeld pro Eintrag ("warum steht der NPC so zu dieser Party") als reine GM-Gedächtnisstütze.

## Improvisationshilfen

Gewünscht — schnelle Namen, Orte, Plot-Hooks für den Tisch.

## Pacing-Tools

Gewünscht, aber unsicher ob's in der Praxis am Tisch gut funktioniert — trotzdem aufnehmen und ausprobieren (z. B. Clocks/Countdown-Mechaniken zur Spannungssteuerung).

## Zufallstabellen (allgemein)

**Gewünscht** — generell als gutes Werkzeug befunden, über Encounter/Loot hinaus (Wetter, Gerüchte, Komplikationen o. ä.). Konkrete Themen folgen später.

## Schwierigkeitsskalierung

Siehe Stärke-Index in [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md) — deckt das bereits weitgehend ab.

## Safety-Tools

**Gewünscht, aber bewusst kurz gehalten** — kein aufwändiges Kapitel, nur das Nötigste.

- **Stop-Button**: ein Button in der App, für Spieler sichtbar/klickbar, der ohne Erklärung eine Benachrichtigung an den GM schickt ("hier gerade anhalten/ändern"). Keine Kategorisierung, kein Pflichtfeld, kein sichtbares Signal an die anderen Spieler — die Hürde soll null sein.
- Kein Ritual, keine Session-Zero-Pflicht, keine X-Card-Zeremonie — sollte im Idealfall nie gebraucht werden (leichtes System, alle sollen Spaß haben), ist aber als Netz da.
