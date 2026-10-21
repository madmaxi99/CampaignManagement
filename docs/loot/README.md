# Loot (docs/loot)

Regeln und Richtwerte für Beute, Magie, Belohnungen und Händler. **Alles hier ist nur für die Spielleitung.** Hintergrund und Währung: `docs/geld-und-werte.md`.

**Grundsatz:** Items, Waren und Dienste über den Katalog hinaus entstehen **spontan am Tisch**. Sie werden nicht vorab in die Datenbank gebaut. Die Ideen dazu liegen als Listen in `ideen/`.

## Wo liegt was

| Was | Wo |
| --- | --- |
| Macken der Ladenbesitzer (W20) | **Datenbank**: `catalog_merchant_quirks` (Migrationen `0005` und `0006`), nur auf den SL-Seiten |
| Händler-Übersicht (Macken und Preislisten der vorhandenen Items und Dienste) | **App**: Werkzeuge im Spielbildschirm, Katalog, Händler |
| `meisterwerke.md` | Regeln für Meisterwerke (MP) mit festem Bonus je Typ |
| `magische-gegenstaende.md` | Baukasten für magische Gegenstände |
| `auftragsbelohnungen.md` | Richtwerte für Auftragslohn und Tempo |
| `haendler.md` | Händler-Typen, Preisregeln, Ablauf am Tisch, die Macken als Liste |
| `ideen/` | Ideenlisten für künftige Projekte, **nicht in der Datenbank**: `schmuck-und-edelsteine.md`, `handelswaren-und-alltag.md`, `dienste.md`, `magische-fertigstuecke.md` |

## Festgelegt

- **Währung:** Heller, Krone, Dukat (10 Heller = 1 Krone, 10 Kronen = 1 Dukat). Spitznamen: Heller = Krümel, Dukat = Hadrik, die Krone hat keinen.
- **Preise:** Standardsachen haben einen **Festpreis**, besondere Sachen einen **Wurfpreis** (der Katalogpreis ist der Mittelwert). Die App würfelt nie.
- **Meisterwerk (MP):** Zusatz im Textfeld eines normalen Items, Preis das Zehnfache, Waffen STÄ −3 und Haltbarkeit +3, dazu ein fester Bonus je Typ. Ein Meisterwerk ist nicht magisch.
- **Magisch:** Baukasten in `magische-gegenstaende.md`, höchstens +2 auf eine Fertigkeit.
- **Reparatur:** immer ein Zehntel vom Neupreis.
- **Fremde Münzen:** haben in Weidenmark keinen Wert und liegen als Gegenstand im Inventar.
- **Seltenheit:** fünf Stufen (gewöhnlich, ungewöhnlich, selten, episch, legendär), nur die Häufigkeit, unabhängig vom Preis. Ein Name macht ein Stück zum Einzelstück.
- **Händler:** Verkauf zum Katalogpreis, Ankauf zum halben Preis. Keine Regeln für Vorrat, Seltenheit oder Chancen im Laden, die SL entscheidet spontan. Die Übersicht zeigt nur Macken und Preislisten (Name, Preis, Effekt).
- **Legt jemand später Items aus den Ideenlisten im Katalog an:** Waffen und Rüstungen als Art *Waffe* bzw. *Rüstung* mit Waffen- bzw. Rüstungswerten, nie als *Sonstiges*.
- **Gewicht:** erstmal egal.

## Noch offen

- **Preis-Anteile** (Reparatur, Hehler) als eigenes Feld statt Text, falls sie je in den Katalog kommen.
