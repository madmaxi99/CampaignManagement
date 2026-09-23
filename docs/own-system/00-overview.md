# Eigenes TTRPG-System — Übersicht

## Warum

Dragonbane wurde als Regelwerk für die Kampagne gewählt (siehe `docs/ruleset-comparison/`), aber der Wunsch ist jetzt ein **komplett eigenes System** — eine Mischung aus vielen Systemen, kein reines Hausregel-Reskin von Dragonbane.

## Stand

Alle 10 Kategorien haben einen ersten inhaltlichen Durchgang, die 6 Kataloge (11–16) sind inhaltlich ausgearbeitet, und der **Zahlenwerte-/Balancing-Pass ist durch**: Kampf-Trefferauflösung (AC-System, siehe [03](03-kampf.md)), Attribut-Modifikatoren ([02](02-kernmechanik.md)), PC-HP/AC-Formeln, Startgeld und Flaw-Liste ([01](01-charakter.md)), Waffen-Schaden und Rüstungs-AC-Boni ([15](15-katalog-items.md)), Monster-AC/Angriffsbonus pro Tier ([09](09-bestiary-und-npcs.md)), Kin-Trait-Zahlenwerte ([11](11-katalog-kins.md)), Erschöpfungs-Mali ([06](06-erholung.md)), Langzeitfolgen-Tabellen ([04](04-tod-und-konsequenzen.md)) und Loot-Tabellen-Format ([08](08-loot-und-belohnung.md)) sind jetzt konkret. Die Balance-Vorgabe (1 PC vs. 2 Standard-Gegner verliert ~60%) wurde per Simulation gegen die gewählten Werte verifiziert (siehe [03](03-kampf.md)).

Alle 50 Bestiarium-Statblöcke haben inzwischen AC/Angriffsbonus, und der **Stärke-Index (SI) wird jetzt aus HP/AC/Angriff/Schaden berechnet statt umgekehrt** (Formel in [09](09-bestiary-und-npcs.md)) — 22 der 50 Kreaturen bekamen dadurch einen leicht angepassten SI. Auch der restliche Katalog-Fragenkatalog ist durchgegangen und final entschieden: Kin-Liste (9, final), Profession/Kin frei kombinierbar, 33 Professionen final, Skill-Impact bleibt bewusst Prosa/GM-Adjudikation statt Zahlen, Magie-Kategorien (7, final) + Mana-Pool-Formel (4 + höherer INT-/WIS-Mod), Waffen-Sonderboni, kein Trainingserfordernis für schwere Rüstung, Währung final auf 10er-Schritten.

Was noch offen bleibt: reine Feinjustierung durch echten Spieltest (Balance-Werte, AC-Bonus-Tabelle) sowie Dinge, die absichtlich nicht System-Ebene sind, sondern Kampagnen-/Lore-Entscheidungen (z. B. ob Zauber an bestimmte Orte/Lehrer gebunden sind — siehe `docs/lore/`).

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
