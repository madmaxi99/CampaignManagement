# Ideen: Schmuck und Edelsteine

Ideenliste für künftige Projekte, **nicht in der Datenbank**: Items und Dienste entstehen spontan am Tisch, diese Liste ist Vorrat und Anregung. Nur für die Spielleitung. Währung: **Heller, Krone, Dukat** (10 Heller = 1 Krone, 10 Kronen = 1 Dukat, also 1 Dukat = 100 Heller), siehe `docs/geld-und-werte.md`. Herkunft und Namen folgen der Lore aus der App (`/dm/lore`): Weidenmark, Karth, Dornmark, Eisenkamm, Haldertal, Rohrlande, Weidenhanse und Gilden. Die alte `docs/lore/` ist veraltet (siehe `docs/TODO.md`).

## Festlegungen

- **Währungsnamen:** Heller, Krone, Dukat gelten überall (App, Katalog, Doku). Die Spalten in der Datenbank behalten ihre Namen, nur die Texte ändern sich.
- **Standardsachen haben einen Festpreis**, **besondere Sachen einen Wurfpreis**. Der Wurfpreis ist eine Würfelformel (Schatztabelle, Standes- und antiker Schmuck, später Relikte). Der **Katalogpreis ist der Mittelwert dieser Formel**, damit beides zusammenpasst: Wer einen Gegenstand verkauft oder kauft, nimmt den Katalogpreis, wer ihn findet, würfelt den Wert aus. Die App würfelt nicht, die Formel steht nur als Text da und das Ergebnis wird am Tisch eingetragen.
- **Gewicht:** erstmal egal, wird später gesetzt.
- **Edelsteinstufen:** bleiben so (Glas bis Diamant mit den Zwischenstufen).
- **Fremde Münzen:** haben in Weidenmark keinen Wert und sind kein Zahlungsmittel, wandern aber als Gegenstand ins Inventar (nicht in die Börse). Karth hat keine eigene Währung (Tauschhandel). Siehe `docs/geld-und-werte.md`.

## Entschieden

- **Spitznamen:** Heller heißt Krümel, der Dukat heißt Hadrik (nach dem ersten König), die Krone hat keinen. Siehe `docs/geld-und-werte.md`.
- **Fremde Münzen:** Dornmärker Groschen und Gulden sowie antike Münzen stehen in Block 2.

## Offene Fragen

Keine mehr.

## Schmuck

Spalten: `Preis` ist der Katalogpreis, `Heller` die Rechenprobe (1 Dukat = 100 Heller), `Wurfpreis` die Formel, deren Mittelwert der Katalogpreis ist (leer = Festpreis). Art ist überall *Sonstiges* (`misc`).

### Alltag und Volksschmuck (Festpreis)

| Name | Seltenheit | Preis | Heller | Beschreibung |
| --- | --- | --- | --- | --- |
| Bronzering | gewöhnlich | 1 Krone | 10 | Schlichter Ring aus Bronze, wie ihn Handwerker und Bauern tragen. |
| Kupferarmreif | gewöhnlich | 2 Kronen | 20 | Offener Reif aus gehämmertem Kupfer, leicht angelaufen. |
| Zunftzeichen (Zinn) | gewöhnlich | 3 Kronen | 30 | Anhänger mit dem Zeichen einer Zunft (Schmiede, Steinmetze, Zimmerleute). Ein Stück ohne Zunftzeichen gilt als Pfusch, ein Meister ohne Zeichen als verdächtig. |
| Herdgeist-Talisman | gewöhnlich | 5 Kronen | 50 | Handgemachter Talisman der Halblinge aus dem Haldertal, aus Ton, Holz und rotem Faden. Wer ihn trägt, wünscht dem Gegenüber "Herdwarm". |
| Wasser-Talisman der Mallard | gewöhnlich | 5 Kronen | 50 | Muschel, Schilf und Fischgräte an einer Schnur, in den Rohrlanden getragen. "Plau", Wasser trägt dich. |
| Wolfkin-Zahnkette | ungewöhnlich | 8 Kronen | 80 | Kette aus Raubtierzähnen aus dem Grenzforst, jeder Zahn steht für eine Jagd. Als Handelsware unter Wolfkin heikel. |

### Handelsschmuck (Wurfpreis wie in den Schatztabellen)

| Name | Seltenheit | Preis | Heller | Wurfpreis | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Silberring | gewöhnlich | 7 Kronen | 70 | 2W6 Kronen | Einfacher Ring aus Silber. |
| Silberbrosche | gewöhnlich | 3 Dukaten 5 Kronen | 350 | 2W6 × 5 Kronen | Brosche zum Verschließen eines Umhangs. |
| Silberkette | gewöhnlich | 3 Dukaten 5 Kronen | 350 | 2W6 × 5 Kronen | Feine Gliederkette aus Silber. |
| Silberarmband | ungewöhnlich | 7 Dukaten | 700 | 2W6 × 10 Kronen | Breites Armband mit eingravierten Mustern. |
| Goldkette | ungewöhnlich | 7 Dukaten | 700 | 2W6 Dukaten | Schwere Halskette aus Gold. |
| Goldring | ungewöhnlich | 14 Dukaten | 1400 | 4W6 Dukaten | Massiver Ring aus Gold. |
| Goldamulett | ungewöhnlich | 35 Dukaten | 3500 | 2W6 × 5 Dukaten | Amulett aus Gold, oft mit Gravur oder kleinem Stein. |
| Kelch (silbervergoldet) | ungewöhnlich | 35 Dukaten | 3500 | 2W6 × 5 Dukaten | Zeremonieller Trinkkelch, außen vergoldet. |
| Goldarmband | selten | 70 Dukaten | 7000 | 2W6 × 10 Dukaten | Schweres Armband aus massivem Gold. |

### Standes- und Amtsschmuck (Wurfpreis)

| Name | Seltenheit | Preis | Heller | Wurfpreis | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Ohrringe (Paar, Silber) | gewöhnlich | 3 Dukaten 5 Kronen | 350 | W6 Dukaten | Ein Paar schlichter Silberringe. |
| Siegelring (Silber) | ungewöhnlich | 5 Dukaten | 500 | 2W4 Dukaten | Ring mit dem Wappen eines Adelshauses (Schwert- oder Briefadel), zum Siegeln von Briefen. Das Wappen macht ihn für Fälscher wie Ermittler interessant. |
| Zwergenring aus dem Eisenkamm | ungewöhnlich | 10 Dukaten 5 Kronen | 1050 | 3W6 Dukaten | Zwergenarbeit aus Kupfer und Silber, trägt das Zeichen einer Halle (Tharnhall, Orrindum oder Kelrok). Kommt über die Erzgilde in Steinbach ins Land. |
| Ratskette der Weidenhanse | ungewöhnlich | 12 Dukaten | 1200 | 2W6 + 5 Dukaten | Silbervergoldete Kette, die Patrizier der Weidenhanse in Rotenmark tragen. Der Adel erkennt sie nicht als Amtszeichen an. |
| Perlenkette (Süßwasser) | ungewöhnlich | 24 Dukaten 5 Kronen | 2450 | W6 × 7 Dukaten | Kette aus Flussperlen, gern von Mallard-Händlern aus den Rohrlanden verkauft. |
| Elfenbrosche (Blattform) | selten | 28 Dukaten | 2800 | 2W6 × 4 Dukaten | Zarte Silberbrosche, elfische Arbeit. Elfen leben vereinzelt unter den Menschen, ihre Stücke sind alt und selten. |
| Diadem (Silber, vergoldet) | selten | 63 Dukaten | 6300 | 3W6 × 6 Dukaten | Stirnreif mit eingelegten Steinen, Zeichen von Adel oder Hof. |

### Antiker Schmuck, Korvanis-Erbe (Wurfpreis)

| Name | Seltenheit | Preis | Heller | Wurfpreis | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Korvanis-Fibel | ungewöhnlich | 8 Dukaten | 800 | 2W6 + 1 Dukaten | Bronzene Gewandspange aus der Republik Korvanis, die vor 273 Jahren fiel. Sammler und Gelehrte zahlen mehr als der Materialwert. |
| Korvanis-Ratskette (Gold) | selten | 94 Dukaten 5 Kronen | 9450 | 3W6 × 9 Dukaten | Goldene Amtskette eines gewählten Rates der Republik, über 270 Jahre alt. Haus Thalheim (Archive), Gelehrte und Patrizier fragen nach solchen Stücken. |

## Edelsteine (Festpreis)

Die sechs **fett** gedruckten Steine sind die feste Würfeltabelle aus Schatztabelle 2 (Wurf 6, dann W6) und bleiben unverändert. Alle anderen sind Ergänzungen dazwischen. Art ist *Sonstiges*.

| Name | Seltenheit | Preis | Heller | Beschreibung |
| --- | --- | --- | --- | --- |
| **Glas** | gewöhnlich | 2 Heller | 2 | Geschliffenes Glas, das auf den ersten Blick wie ein Stein wirkt. Taugt als Betrugsware. |
| Achat | gewöhnlich | 5 Kronen | 50 | Gebänderter Halbedelstein, überall zu finden. |
| Gagat | gewöhnlich | 8 Kronen | 80 | Tiefschwarzes Fossilharz, in Trauerschmuck beliebt. |
| **Kristall** | ungewöhnlich | 10 Kronen | 100 | Klarer Bergkristall. |
| Bernstein | ungewöhnlich | 2 Dukaten | 200 | Goldgelbes Harz, oft mit eingeschlossenem Insekt. |
| Süßwasserperle | ungewöhnlich | 4 Dukaten | 400 | Einzelne Perle aus dem Flussnetz. |
| Türkis | ungewöhnlich | 5 Dukaten | 500 | Blaugrüner Stein, aus dem Eisenkamm, über die Erzgilde in Steinbach. |
| Amethyst | ungewöhnlich | 6 Dukaten | 600 | Violetter Quarz in Schmuckqualität. |
| **Smaragd** | selten | 10 Dukaten | 1000 | Tiefgrüner, klarer Stein. |
| **Saphir** | selten | 15 Dukaten | 1500 | Kornblumenblauer Stein. |
| Opal | selten | 20 Dukaten | 2000 | Milchiger Stein mit wanderndem Farbenspiel, gilt als launisch. |
| **Rubin** | selten | 25 Dukaten | 2500 | Blutroter Stein, Statussymbol der Reichen. |
| Schwarzperle | selten | 40 Dukaten | 4000 | Dunkle Meeresperle, über Salzbruck eingeführt (Seefracht der Salzgilde). |
| **Diamant** | selten | 100 Dukaten | 10000 | Härtester aller Steine, klar und schwer zu verkaufen, weil nur wenige Käufer den Preis zahlen. |

Faustregel für ungeschliffene Steine: Rohstein ≈ **halber** Preis, schlecht geschliffen ≈ ¾ (siehe Modifikator-Tabelle in `docs/geld-und-werte.md`).

## Kandidaten zum Streichen

Alles optional. Die Liste ist bewusst eher zu lang als zu kurz:

- Ohrringe (Paar, Silber), Siegelring, Diadem: Standesschmuck, den die Schatztabellen nicht liefern.
- Wolfkin-Zahnkette, Herdgeist-Talisman, Wasser-Talisman der Mallard, Zunftzeichen: reiner Flavor, kaum Handelswert.
- Gagat, Amethyst, Opal, Türkis: Zwischenstufen der Edelsteine.
- Korvanis-Fibel und Korvanis-Ratskette: nur sinnvoll, wenn Funde aus der Republik vorkommen.
