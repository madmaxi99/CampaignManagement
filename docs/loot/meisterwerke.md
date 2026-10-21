# Meisterwerke (MP)

Regeln für Meisterwerke. **Nur für die Spielleitung sichtbar**, wie alles unter `docs/loot/`. Währung: Heller, Krone, Dukat
(1 Dukat = 10 Kronen = 100 Heller). Preise folgen `docs/geld-und-werte.md`.

## So funktioniert ein Meisterwerk

Ein Meisterwerk (**MP**) ist **kein eigenes Item**, sondern ein **Zusatz im Textfeld** eines normalen Katalog-Items. Es
gibt also kein "Meisterwerk-Langschwert" als eigene Zeile. Im Beschreibungstext des Stücks steht zum Beispiel:

> *MP: STÄ-Anforderung −3, Haltbarkeit +3, Durchdringung 1 (die Rüstung des Ziels zählt 1 niedriger).*

Ein Meisterwerk hat zwei Bestandteile:

1. **Grundregel für Waffen:** benötigte STÄ −3 und Haltbarkeit +3. Rüstungen, Helme und Schilde haben keine Grundwerte (sie haben im Katalog weder STÄ-Anforderung noch Haltbarkeit).
2. **Fester Bonus je Typ:** **jedes Meisterwerk eines Typs bekommt immer denselben Bonus**. Ein MP-Dolch hat immer Durchdringung 1, jede MP-Streitaxt hat Durchschlag, und so weiter. Die Tabellen stehen unten.

Ein Meisterwerk ist **nicht magisch**. Magische Eigenschaften (Fertigkeitsboni, Zaubertricks und mehr) stehen in
`docs/loot/magische-gegenstaende.md`.

**Zwergenarbeit** ist kein eigener Typ, sondern ein Meisterwerk mit einem Vermerk wie "Zwergenarbeit, Hallenzeichen" im
Text. Eine "gute Qualität" ohne Meisterwerk-Wirkung gibt es nicht.

**Notation:** **Durchdringung N** heißt, die Rüstung des Ziels zählt um N niedriger.

## Fester Bonus je Waffentyp

Alle Boni sind **Vorschläge** und halten sich an die Sprache der vorhandenen Items (Vorteil, Rüstungswert, Merkmale).
Keine Boni auf Haltbarkeit (das steckt schon in der Grundregel).

### Nahkampf

| Waffe                | Fester MP-Bonus                                                                        |
|----------------------|----------------------------------------------------------------------------------------|
| Dolch                | Durchdringung 1                                                                        |
| Messer               | Vorteil auf Angriffe aus der Verborgenheit                                             |
| Parierdolch          | Vorteil beim Parieren                                                                  |
| Kurzschwert          | Vorteil auf den ersten Angriff in einem Kampf                                          |
| Breitschwert         | Gnadenstoß: kritische Treffer machen +W6 Schaden                                       |
| Langschwert          | +W4 Schaden                                                                            |
| Zweihandschwert      | Durchdringung 2                                                                        |
| Krummsäbel           | Vorteil auf Entwaffnen und Niederwerfen                                                |
| Beil                 | Vorteil beim Werfen                                                                    |
| Streitaxt            | Durchschlag: ein Treffer fügt einem weiteren Ziel im Umkreis von 1 Meter W4 Schaden zu |
| Zweihandaxt          | Durchdringung 1                                                                        |
| Streitkolben         | Durchdringung 1                                                                        |
| Morgenstern          | Wuchtig: +W4 Schaden gegen Ziele ohne Rüstung                                          |
| Dreschflegel         | Kann zum Parieren verwendet werden (der Nachteil entfällt)                             |
| Kriegshammer, klein  | Stoßkraft: das Ziel wird 1 Meter zurückgestoßen                                        |
| Kriegshammer, schwer | Stoßkraft: das Ziel wird 2 Meter zurückgestoßen                                        |
| Hellebarde           | Durchschlag                                                                            |
| Langspeer            | Reichweite +1                                                                          |
| Kurzspeer            | Wurfreichweite verdoppelt                                                              |
| Dreizack             | Vorteil auf Entwaffnen und Niederwerfen                                                |
| Lanze                | Durchdringung 1 beim Reiterangriff                                                     |
| Stab                 | Vorteil beim Parieren                                                                  |

### Fernkampf

| Waffe            | Fester MP-Bonus                              |
|------------------|----------------------------------------------|
| Schleuder        | Vorteil auf den ersten Schuss in einem Kampf |
| Kurzbogen        | Reichweite +10 Meter                         |
| Langbogen        | Durchdringung 1                              |
| Leichte Armbrust | Durchdringung 1                              |
| Schwere Armbrust | Durchdringung 2                              |
| Handarmbrust     | Vorteil auf Angriffe aus der Verborgenheit   |

Keine Meisterwerke gibt es für Holzkeulen und die "Stumpfen Gegenstände" (Improvisation).

## Fester Bonus je Rüstung, Helm und Schild

Fertigkeitsboni (**+N auf eine Fertigkeit**) heißen: der Fertigkeitswert steigt bei Proben auf diese Fertigkeit um N.
Das ist kein Vorteil, sondern ein fester Zuschlag.

| Stück              | Fester MP-Bonus                                                          |
|--------------------|--------------------------------------------------------------------------|
| Lederrüstung       | +2 auf Akrobatik                                                         |
| Beschlagenes Leder | Der Abzug auf Heimlichkeit entfällt                                      |
| Kettenpanzer       | Der Abzug auf Ausweichen entfällt                                        |
| Plattenpanzer      | Der Abzug auf Akrobatik entfällt                                         |
| Offener Helm       | Der Abzug auf Wahrnehmung entfällt                                       |
| Großhelm           | Der Abzug auf Wahrnehmung entfällt, dazu +1 auf Überzeugen bei Drohungen |
| Schild, klein      | Vorteil beim Parieren                                                    |
| Schild, groß       | Rüstungswert +1 gegen Fernkampf                                          |

## Preis

Ein Meisterwerk kostet das **Zehnfache** des Katalogpreises. Als besondere Sache hat es einen **Wurfpreis**, dessen
Mittelwert ungefähr das Zehnfache ergibt, der Katalogpreis ist der Mittelwert der Formel. Ein kaputtes Stück kostet die
Hälfte.

| Basis (Katalogpreis)              | Seltenheit   | MP-Preis    | Heller | Wurfpreis             |
|-----------------------------------|--------------|-------------|--------|-----------------------|
| Dolch (1 Dukat)                   | ungewöhnlich | 10 Dukaten  | 1000   | 2W6 + 3 Dukaten       |
| Kurzschwert (8 Dukaten)           | selten       | 80 Dukaten  | 8000   | 2W6 × 10 + 10 Dukaten |
| Streitaxt (10 Dukaten)            | selten       | 98 Dukaten  | 9800   | 4W6 × 7 Dukaten       |
| Beschlagenes Leder (10 Dukaten)   | selten       | 98 Dukaten  | 9800   | 4W6 × 7 Dukaten       |
| Breitschwert (12 Dukaten)         | selten       | 119 Dukaten | 11900  | 2W6 × 17 Dukaten      |
| Schild, groß (12 Dukaten)         | selten       | 119 Dukaten | 11900  | 2W6 × 17 Dukaten      |
| Kriegshammer, schwer (20 Dukaten) | selten       | 196 Dukaten | 19600  | 4W6 × 14 Dukaten      |
| Langschwert (25 Dukaten)          | episch       | 245 Dukaten | 24500  | 2W6 × 35 Dukaten      |
| Kettenpanzer (50 Dukaten)         | episch       | 490 Dukaten | 49000  | 2W6 × 70 Dukaten      |

Andere Basisstücke nach der Faustregel: Wurfpreis so wählen, dass der Mittelwert **das Zehnfache** des Katalogpreises
ergibt.

## Beispiel

*Eine Streitaxt aus der Beute eines Hauptmanns.* Fester Bonus: Durchschlag. Grundregel: STÄ-Anforderung 10 statt 13, Haltbarkeit 12 statt 9. Text im Katalog-Item: "Streitaxt (MP): STÄ-Anforderung 10 statt 13, Haltbarkeit 12 statt 9, Durchschlag (W4 Schaden auf ein weiteres Ziel)." Preis: Wurf 4W6 × 7, Katalogwert 98 Dukaten.
