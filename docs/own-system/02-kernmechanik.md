# Kernmechanik

Die grundlegende Auflösungsmechanik, auf der alles andere aufbaut.

## Würfelsystem

Volles Polyeder-Set von **d4 bis d20** im Einsatz (für unterschiedliche Zwecke wie Schaden, Tabellen etc.), aber die meisten **Skill-Checks laufen über den d20**.

## Hoch würfeln vs. roll-under

**Hoch würfeln**, D&D-Style: d20 + Modifikator gegen einen Zielwert/DC, höher ist besser.

## Erfolgsgrade

Binär **Success/Fail**, zusätzlich mit einer **Crit**-Variante auf beiden Seiten (kritischer Erfolg / kritischer Patzer). Keine abgestuften Teilerfolge (kein PbtA-Stil).

**Auslöser: Nat 20 = kritischer Erfolg, Nat 1 = kritischer Patzer** — gilt für jeden d20-Wurf (Skill-Proben, Angriffswürfe). Bei einem Angriffswurf bedeutet Nat 20 automatischen Treffer + doppelten Schaden, Nat 1 automatischen Fehlschlag unabhängig vom Modifikator (siehe [03-kampf.md](03-kampf.md)).

## Attribut-Modifikatoren

Attribute laufen auf einer klassischen **3–18-Skala** (Ergebnis der 4d6-drop-lowest-Generierung, siehe [01-charakter.md](01-charakter.md)). Modifikator = `floor((Wert − 10) / 2)`:

| Attribut | Modifikator |
|---|---|
| 3 | −4 |
| 4–5 | −3 |
| 6–7 | −2 |
| 8–9 | −1 |
| 10–11 | +0 |
| 12–13 | +1 |
| 14–15 | +2 |
| 16–17 | +3 |
| 18 | +4 |

Dieser Modifikator ist die Basis für Skill-Proben, Angriffsboni, AC-Beitrag (DEX) und die HP-Formel (CON) — siehe die jeweiligen Kapitel.

## Advantage/Vorteil-Mechanik

**Bane & Boon** (analog D&D Advantage/Disadvantage): bei Vor-/Nachteil werden **2 Würfel** geworfen — bei Boon zählt der bessere, bei Bane der schlechtere. Kein Stapeln von mehreren Vor-/Nachteilen vorgesehen (bleibt bei maximal 2 Würfeln).

## Glücks-/Reroll-Ressource

**Keine** — bewusst kein Fate-Point-/Inspiration-/Reroll-System, um unnötige Komplexität zu vermeiden.
