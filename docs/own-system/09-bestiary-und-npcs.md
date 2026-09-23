# Bestiary & NPCs

## Statblock-Format

Monster bekommen einen Statblock mit **bis zu 3 Moves** (Aktionen/Fähigkeiten). Humanoide NPCs werden **strukturell genauso** gebaut wie Monster.

Nicht jedes Monster/NPC braucht alle 3 Moves — die Anzahl skaliert mit der Bedrohungsstufe:

- **1 Move** — Fodder/Mook (z. B. kleiner Goblin, Ratte, Wachrekrut): reiner Standardangriff (Biss, Kralle, Schwertstreich).
- **2 Moves** — Standard-Gegner (z. B. Soldat, ausgewachsener Wolf, Ork-Krieger): Move 1 = Standardangriff, Move 2 = etwas Stärkeres oder Utility (ein einfacher Zauber bei Schamanen, ein krasserer Treffer, eine Kontrolle/Debuff-Fähigkeit).
- **3 Moves** — Bosse/Elite (z. B. Drache, Anführer, mächtiger Nekromant): zusätzlich Move 3 = eine Ultimate-artige Fähigkeit, die das Monster von normalen Gegnern desselben Typs abhebt.

Der vollständige Katalog konkreter Kreaturen/NPCs mit ihren Moves liegt in [16-katalog-bestiarium.md](16-katalog-bestiarium.md).

## AC & Angriffsbonus pro Move-Tier

Nach demselben Prinzip wie der individualisierte Move-Schaden im Bestiarium: **Richtwerte pro Tier, keine feste Formel** — einzelne Kreaturen dürfen bewusst davon abweichen (ein besonders behäbiger Boss darf niedrigere AC haben, eine besonders akkurate Fodder-Kreatur höheren Angriffsbonus):

| Tier | AC (Richtwert) | Angriffsbonus (Richtwert) |
|---|---|---|
| Fodder (1 Move) | 10–11 | +2 bis +3 |
| Standard (2 Moves) | 12–13 | +4 bis +5 |
| Boss/Elite (3 Moves) | 14–15 | +6 bis +7 |
| Ultimate-Move-Träger (z. B. Drachen) | 16–18 | +8 bis +9 |

Referenz-Simulation (siehe [03-kampf.md](03-kampf.md)): ein Standard-Soldat mit AC 12 / Angriffsbonus +4 / HP 12 / Schaden 1W6+2 erzeugt zusammen mit einem zweiten identischen Gegner das gewünschte "1 PC vs. 2 Standard-Gegner verliert ~60%"-Verhältnis gegen einen Referenz-PC. Diese Werte sind der Startpunkt für alle Statblöcke in [16-katalog-bestiarium.md](16-katalog-bestiarium.md) — die dortigen HP-Werte (SI × 3) bleiben unverändert, AC/Angriffsbonus kommen als zusätzliche Statblock-Felder nach diesem Tier-Schema dazu.

## Skalierung nach Schwierigkeit — Stärke-Index

Ein **Stärke-Index (SI)** pro Encounter/Monster, verglichen mit der **gemeinsamen Stärke der PCs**, um die Schwierigkeit auf einen Blick einzuschätzen.

**Wichtig: SI wird aus den tatsächlichen Statblock-Werten berechnet, nicht umgekehrt.** Zuerst werden HP, AC, Angriffsbonus und Schaden einer Kreatur individuell nach Flavor festgelegt (siehe [16-katalog-bestiarium.md](16-katalog-bestiarium.md)) — SI ist danach eine reine **abgeleitete Kennzahl**, die diese Werte zu einer einzigen Vergleichsgröße verdichtet. Zwei Kreaturen mit identischer HP können also unterschiedliche SI haben, wenn eine davon spürbar schwerer zu treffen ist oder härter zuschlägt als die andere (z. B. Skelett-Krieger vs. Zombie — gleiche HP, aber der Zombie ist schwächer im Einzeltreffer und leichter zu treffen, also niedrigerer SI).

**Formel:**

1. **Basis** = HP ÷ 3
2. **Abweichung** = `[(AC − Tier-AC-Mitte) + (Angriffsbonus − Tier-Angriff-Mitte) + (Ø-Schaden Hauptangriff − Tier-Schaden-Mitte)] ÷ 3`
3. **SI** = `runde(Basis + Abweichung)`, minimal 1

"Tier-Mitte" sind die Mittelwerte der Richtwert-Spannen aus der Tabelle oben (z. B. Fodder: AC-Mitte 10,5 / Angriff-Mitte 2,5 / Schaden-Mitte 3,0 — aus der Range 1W4–1W6). Der "Hauptangriff" ist die erste nicht-Utility-Move eines Statblocks (nicht die Ultimate-Fähigkeit). Hat eine Kreatur keinen Schadens-Move (reine Utility-Kreatur), zählt der Schadens-Term als 0.

Beispiel-Richtwerte für Encounter-Skalierung (Ausgangspunkt, nicht final): PC-Gruppe hat zusammen Stärke 10 → Gegner(gruppen) bis 5 = leicht, bis 10 = normal, darüber = stark.

## Monster-Baukasten

Kein separates Baukasten-Regelwerk — Monster werden **direkt mit den normalen Spielregeln gebaut**. Learnings aus dem Prozess werden aufgeschrieben, um zukünftig konsistenter/schneller neue Kreaturen zu erstellen.

## Verhalten/Taktik-Hinweise

Kein mechanisches System — Verhalten/Taktik wird über **Erzählung** durch den GM gehandhabt, nicht im Statblock vorgeschrieben.

## NPC-Generator

**Gewünscht** — schnelle NPCs für unerwartete Begegnungen am Tisch.

## Fraktionen/Beziehungen

**Rein über Erzählung**, keine Mechanik — mit einer Ausnahme: bei **wichtigen NPCs** wird notiert, was sie von der Gruppe halten (z. B. relevant für Rabatte oder Hilfsbereitschaft).
