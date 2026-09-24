# Eigenes TTRPG-System — Übersicht

## Warum

Dragonbane wurde als Regelwerk für die Kampagne gewählt (siehe `docs/ruleset-comparison/`), aber der Wunsch ist jetzt ein **komplett eigenes System** — eine Mischung aus vielen Systemen, kein reines Hausregel-Reskin von Dragonbane.

## Stand

Alle 10 Kategorien haben einen ersten inhaltlichen Durchgang, die 6 Kataloge (11–16) sind inhaltlich ausgearbeitet, und der **Zahlenwerte-/Balancing-Pass ist durch**: Kampf-Trefferauflösung (AC-System, siehe [03](03-kampf.md)), Attribut-Modifikatoren ([02](02-kernmechanik.md)), PC-HP/AC-Formeln, Startgeld und Flaw-Liste ([01](01-charakter.md)), Waffen-Schaden und Rüstungs-AC-Boni ([15](15-katalog-items.md)), Monster-AC/Angriffsbonus pro Tier ([09](09-bestiary-und-npcs.md)), Kin-Trait-Zahlenwerte ([11](11-katalog-kins.md)), Erschöpfungs-Mali ([06](06-erholung.md)), Langzeitfolgen-Tabellen ([04](04-tod-und-konsequenzen.md)) und Loot-Tabellen-Format ([08](08-loot-und-belohnung.md)) sind jetzt konkret. Die Balance-Vorgabe (1 PC vs. 2 Standard-Gegner verliert ~60%) wurde per Simulation gegen die gewählten Werte verifiziert (siehe [03](03-kampf.md)).

Alle 50 Bestiarium-Statblöcke haben inzwischen AC/Angriffsbonus, und der **Stärke-Index (SI) wird jetzt aus HP/AC/Angriff/Schaden berechnet statt umgekehrt** (Formel in [09](09-bestiary-und-npcs.md)) — 22 der 50 Kreaturen bekamen dadurch einen leicht angepassten SI. Auch der restliche Katalog-Fragenkatalog ist durchgegangen und final entschieden: Kin-Liste (9, final), Profession/Kin frei kombinierbar, Skill-Impact bleibt bewusst Prosa/GM-Adjudikation statt Zahlen (Ausnahme: Waffenkunde/Rüstungskunde, s. u.), Magie-Kategorien (7, final) + Mana-Pool-Formel (4 + höherer INT-/WIS-Mod), Waffen-Sonderboni, kein hartes Trainingserfordernis für schwere Rüstung, Währung final auf 10er-Schritten.

**Neu seit dem letzten Durchgang** — Waffen-/Rüstungstraining final: ohne **Waffenkunde** für die geführte Waffe Bane auf den Angriffswurf (Schaden bei Treffer unverändert), ohne **Rüstungskunde** bei Mittlerer/Schwerer Rüstung kein AC-Bonus (nur 10+DEX-Mod) — beides in [13](13-katalog-skills.md)/[03](03-kampf.md). Cantrips sind final reine Utility-Magie, kein Schadens-Cantrip — ist das Mana leer, greift ein Zauberwirker zur Nahwaffe statt zu einem Schadens-Cantrip ([14](14-katalog-zauber.md)). Skills und Zauber lassen sich jetzt auch **während der laufenden Kampagne** dazulernen, auf zwei Wegen (Praxis: 10 überlebte Kämpfe mit der Waffe/Rüstung; Lehrer/Meister: 1–2 Ingame-Tage gezielte Übung) — beide bewusst ohne Kostentabelle, aber narrativ selbstbremsend (echte Kampf-Sessions bzw. ein von der Story bereitgestellter Lehrer).

**Alter ist neu als eigene Charaktererschaffungs-Achse** ([01](01-charakter.md)): Profession liefert jetzt ein festes **5-Skill-Paket** (vorher 3, alle 33 Professionen aktualisiert), Alter (1W10, jung-lastig: Jung/Erwachsen/Alt) kommt additiv mit 2/4/6 frei wählbaren Extra-Skills obendrauf, plus einem thematischen Attribut-Trade-off (Jung: +1 STR/−1 WIS, Alt: +1 WIS/−1 STR, Erwachsen neutral). Ein eigens gebautes Simulations-Tool prüfte alle 33 Professionen inkl. zufälligem Kin/Alter gegen einen Katalog aus Kampf-/Sozial-/Wildnis-/Wissens-/Heimlichkeits-/Handwerks-Challenges plus Startvermögen auf Fairness untereinander (Ziel: nicht "gleich stark", sondern "insgesamt vergleichbar nützlich") — drei Professionen (Söldner/Schmuggler/Händler) wurden dadurch minimal getrimmt, Wildnisläufer leicht gebufft.

Ergänzt außerdem: ein käufliches, rein mundanes **Begleittier** (Hund, 15 Silber, Statblock in [16](16-katalog-bestiarium.md), reflavorbar für andere kleine Tiere) — bewusst kein magisches Familiar-Konzept, das gibt es als eigenständiges System noch nicht (die bestehende Beschwörung-Magiekategorie deckt nur temporäre Kampf-Verbündete ab, keinen dauerhaften Begleiter).

Was noch offen bleibt: reine Feinjustierung durch echten Spieltest (Balance-Werte, AC-Bonus-Tabelle), die konkreten Encounter-Generator-Formeln (Leicht/Mittel/Schwer/Endboss skaliert über Partygröße UND Erfahrungsstufe, bereits per Simulation hergeleitet und stabil, aber noch nicht aus den Tools zurück in [10](10-gm-tools.md) als GM-Anleitung geschrieben), sowie Dinge, die absichtlich nicht System-Ebene sind, sondern Kampagnen-/Lore-Entscheidungen (z. B. ob Zauber an bestimmte Orte/Lehrer gebunden sind — siehe `docs/lore/`).

Ein umfangreiches Python-Simulations-Tooling liegt unter `docs/own-system/tools/` (Balance-/Kampagnen-/Encounter-Kalibrierungs-/Profession-Fairness-Simulatoren) — reine Wegwerf-Analysewerkzeuge zur Zahlen-Verifikation, kein Teil des Systems selbst.

Explizit ausgeklammert (nicht Teil dieses Systems, wird narrativ statt mechanisch gehandhabt):
- Welt/Setting/Lore (liegt in `docs/lore/` und `Story/`)
- Exploration/Reise (wird erzählt, nicht simuliert)

Noch offen: Wie viel der bestehenden Dragonbane-lastigen Mechanik im Code (`PlayerCharacterRepository`, `SkillRepository` u. a. — Attribute, WP-Pool, Conditions, Base-Chance-Tabelle) wiederverwendet oder ersetzt wird. Diese Entscheidung ist bewusst vertagt, bis die Kategorien hier weiter ausgearbeitet sind.

## Kategorien

1. [Charakter](01-charakter.md)
2. [Kernmechanik](02-kernmechanik.md)
3. [Kampf](03-kampf.md)
4. [Tod & Konsequenzen](04-tod-und-konsequenzen.md)
5. [Magie & Übernatürliches](05-magie-und-uebernatuerliches.md)
6. [Erholung](06-erholung.md)
7. [Ausrüstung & Ökonomie](07-ausruestung-und-oekonomie.md)
8. [Loot & Belohnung](08-loot-und-belohnung.md)
9. [Bestiary & NPCs](09-bestiary-und-npcs.md)
10. [GM-Tools](10-gm-tools.md)

## Kataloge (Detail-Pass)

Konkrete Listen/Inhalte zu den Kategorien oben — erster Entwurf, noch nicht final:

11. [Katalog: Kin](11-katalog-kins.md)
12. [Katalog: Professionen](12-katalog-professionen.md)
13. [Katalog: Skills](13-katalog-skills.md)
14. [Katalog: Zauber](14-katalog-zauber.md)
15. [Katalog: Items](15-katalog-items.md)
16. [Katalog: Bestiarium](16-katalog-bestiarium.md)
