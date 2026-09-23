# Kampf

## Initiative

Kartenbasiert (ähnlich Savage Worlds): normales Pokerdeck, jeder zieht zu Rundenbeginn eine Karte, Zugreihenfolge nach Kartenwert hoch→niedrig (Ass hoch). Joker = geht zuerst plus kleiner Bonus.

**Umdecken**: statt zu handeln kann man seine Karte verdeckt zurücklegen und neu ziehen, um später (bei einer niedrigeren oder höheren Karte) einzugreifen — z. B. um auf eine gute Gelegenheit zu warten.

Kampf soll insgesamt eher erzählerisch bleiben, kein taktisches Feinschema.

## Aktionsökonomie

**Ein Zug = eine Aktion.** Kein Mehrfach-Schema wie Aktion/Bonusaktion/Reaktion.

## Reichweite/Position

Bewusst **nicht genau bedacht** — kein Grid, keine Zonen. Reichweite wird nur grob notiert (z. B. Schwert ~1–2 m, Bogen ~20 m) als narrative Orientierung, kein exaktes Tracking.

## Trefferauflösung & Schadenssystem

Klassisches, bewusst vereinfachtes D&D-artiges **AC-System** (nach ausführlicher Abwägung gegen reines Auto-Hit/Cairn-Stil und aktive Verteidigungs-Sonderaktionen — beide verworfen, siehe Begründung unten):

- **AC (Armor Class)** = 10 + DEX-Modifikator + Rüstungsbonus. Rüstungsbonus wird **einmalig bei Erhalt des Rüstungsteils gewürfelt** und bleibt danach fest für dieses konkrete Exemplar (zwei "Mittlere Rüstungen" können unterschiedlich gut sein — Flavor: abgenutzt vs. gut erhalten). Konkrete Würfel-Tabelle nach Rarity: siehe [15-katalog-items.md](15-katalog-items.md).
- **Angriffswurf**: d20 + Angriffsbonus (Attribut-Mod + Waffenkunde-Skill o. ä.) gegen die AC des Ziels. Treffer/Fehlschlag binär. Nat 20 = automatischer Treffer + doppelter Schaden, Nat 1 = automatischer Fehlschlag (siehe [02-kernmechanik.md](02-kernmechanik.md)).
- **Schaden**: bei Treffer Waffenwürfel + Attribut-Mod, direkt von HP abgezogen — **keine weitere Reduktion nach dem Treffer**. Die Rüstung hat ihren Effekt schon vorher gehabt (auf die Trefferchance, nicht auf die Schadenshöhe).
- **Kein separater "aktiv verteidigen"-Move.** Wurde diskutiert (Selbstschutz-Variante und "Verbündete decken"-Variante), aber verworfen: Kurzrast heilt HP zwischen Kämpfen ohnehin komplett, wodurch eine verschenkte Kampfrunde fürs Blocken eines einzelnen Treffers sich in der Praxis kaum lohnt. Verteidigung ist stattdessen komplett passiv in die AC eingepreist.

**Warum kein reiner Auto-Hit (Cairn-Stil):** Recherche zu gelobten Kleingruppen-Kämpfen (Dragonbane, Savage Worlds, OSR) zeigt, dass ein echter Trefferwurf zur Spannung beiträgt — nicht nur die Schadenshöhe. Ein AC-Wert ist dafür der einfachste Weg, ohne zusätzliche Buchhaltung: nur 4 Tier-Richtwerte für Monster (siehe [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md)), keine individuelle Abstimmung pro Kreatur nötig.

## Waffentypen

Klassische Fantasy-Kategorien, nichts Exotisches:

- Nahkampf leicht: Dolch, Kurzschwert
- Nahkampf mittel: Langschwert, Axt, Streitkolben
- Nahkampf schwer/zweihändig: Großschwert, Kriegshammer, Hellebarde
- Fernkampf: Kurzbogen, Langbogen, Armbrust, Wurfspeer
- Schild (eigene Kategorie, nicht als Waffe gezählt)

## Conditions/Status-Effekte

Einfach und klassisch gehalten, keine komplexen Sonderregeln pro Zustand:

- Prone (liegend)
- Stunned (betäubt)
- Poisoned (vergiftet)
- Blinded (geblendet)
- Restrained/Grappled (festgehalten)
- Frightened (verängstigt)
- Exhausted (erschöpft, ggf. stufenweise)

## Flucht/Rückzug

Rückzug soll **immer möglich** sein. "Intelligente" Gegner können statt Kampf auch verhandeln (**Parley**).

## Balance-Philosophie

Kampf soll durchgehend gefährlich bleiben: ein Krieger-PC gegen einen Wachtrupp aus 2 Soldaten soll in **~60% der Fälle mit einem Sieg der Soldaten** enden — ein 1-gegen-2 ist ein fairer, kein trivialer Kampf für den PC. Dieses Kräfteverhältnis soll über die **gesamte Kampagne stabil** bleiben.

**Durch Simulation verifiziert** (100.000 durchgerechnete Kämpfe, Referenz-Werte): PC (HP 20, AC 14, Angriffsbonus +5, Langschwert 1W8+2) gegen 2× Standard-Soldat (HP 12, AC 12, Angriffsbonus +4, 1W6+2) ergibt eine **PC-Gewinnrate von 38,5%** — also ~61,5% Verlust, genau im Zielkorridor. Als Sanity-Check: 3 PCs (vergleichbarer Stärke) gegen 3 Fodder-Orks (HP 9, AC 11, Angriffsbonus +3, 1W6+1) gewinnt die Gruppe in 99,5% der Fälle — bestätigt, dass Fodder-Tier wie gewollt trivial ist, während ungünstige Zahlenverhältnisse (1 vs. 2 auf Standard-Niveau) tatsächlich gefährlich bleiben. Diese Werte sind der Ausgangspunkt für alle Statblock-Richtwerte in [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md) und die PC-Formeln in [01-charakter.md](01-charakter.md) — Feinjustierung folgt aus echtem Spieltest.

**Kein Power-Creep** wie in D&D, wo hochstufige Charaktere praktisch Halbgötter werden. Passt zur "kein erzwungenes Advancement"-Entscheidung aus [01-charakter.md](01-charakter.md) — Macht kommt über Gear, nicht über wachsende Rohstärke.
