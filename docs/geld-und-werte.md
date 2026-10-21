# Geld und Wert-Einschätzung

Orientierung für die Spielleitung: Was ist etwas wert, und wie schätze ich Dinge ein, die nicht im Katalog stehen? Alle
Preise stammen aus dem Item-Katalog (`catalog_items`), den Dienstleistungen (`catalog_services`) und den Schatztabellen
(`schatz_1`, `schatz_2`), siehe `database/migrations/0002_catalog.sql`.

Abschnitt 5 und 6 sind **Vorschläge für Hausregeln**, kein Regelwerk. Die App würfelt weiterhin nichts, Werte werden am
Tisch festgelegt und eingetragen.

## 1. Münzen

| Münze    | Wert      | In Heller |
|----------|-----------|-----------|
| 1 Heller | –         | 1         |
| 1 Krone | 10 Heller | 10        |
| 1 Dukat   | 10 Kronen | 100       |

- Geschäfte laufen in der Regel in **Kronen**, Heller sind für Kleinbeträge, Dukaten für große.
- Münzen zählen als Kleinkram, solange es weniger als 100 sind. 100–199 Münzen zählen als ein Gegenstand, 200–299 als
  zwei usw. (Traglast). 300 Münzen belasten also wie drei Gegenstände, egal ob Heller oder Dukaten. Ein Dukat ist daher bei
  gleicher Last viel mehr wert, ein Hellerhaufen ist schnell zu schwer.
- In der App steht jeder Preis als Dukaten/Kronen/Heller getrennt (kein Gesamtwert), ebenso die Börse am Charakterbogen.
- Das Geld des Königs prägt Haus Lorn in Steinbach. **Fremde Münzen** sind in Weidenmark kein Zahlungsmittel, sie haben lokal keinen Wert und gehören nicht in die Börse, sondern als Gegenstand ins Inventar. Dornmark prägt genau zwei Münzen: den **Dornmärker Groschen** (Silber, in Dornmark etwas weniger wert als 1 Krone, rund 9 Heller) und den **Dornmärker Gulden** (Gold, etwas mehr wert als 1 Dukat, rund 12 Kronen). Karth hat keine eigene Währung, die Orks tauschen eher Ware gegen Ware.

## 2. Was kostet das Leben?

| Stufe                                      | Typische Preise                              | Beispiele aus dem Katalog                                                                                   |
|--------------------------------------------|----------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| **Heller** (1–9)                           | Alltag, Wegzehrung                           | Talgkerze 1, Fackel 5, Eimer 5, Schüssel Eintopf 5, Bad im Gasthaus 6, Humpen Met 4, Wegzoll 2              |
| **Wenige Kronen** (1–9 Kronen)                  | Einfache Ausrüstung, Gasthaus                | Tagesration 1 Krone, Wein (Flasche) 3 Kronen, Messer 5 Kronen, Mahlzeit im Gasthaus 3 Kronen, Einzelzimmer 5 Kronen, Schlafsaal 1 Krone |
| **Viele Kronen / wenig Dukaten** (10 Kronen – 9 Dukaten) | Werkzeug, einfache Waffen und Rüstung, Tiere | Beil 2 Dukaten, Lederrüstung 2 Dukaten, Kurzschwert 8 Dukaten, Zelt (groß) 4 Dukaten, Leibwächter 2 Dukaten/Tag, Esel 12 Dukaten                |
| **Zweistellig Dukaten** (10–99 Dukaten)             | Gute Waffen, Rüstung, Reittiere              | Langschwert 25 Dukaten, Kurzbogen 25 Dukaten, Kettenpanzer 50 Dukaten, Langbogen 50 Dukaten, Reitpferd 60 Dukaten, schwere Armbrust 200 Dukaten |
| **Ab 100 Dukaten**                            | Vermögen, Statussymbole                      | Großhelm 100 Dukaten, Kampfpferd 400 Dukaten, Plattenpanzer 500 Dukaten                                                       |

Kurz gesagt: **1 Dukat ≈ eine Woche Alltag** (Schlafsaal 1 Krone plus Eintopf 5 Heller sind etwa 1,5 Kronen pro Tag),
**25 Dukaten ≈ eine gute Waffe**, **100 Dukaten ≈ ein kleines Vermögen**.

Weitere Dienste: Haarschnitt 2 Kronen, Kleiderreparatur 5 Kronen, Bote 1 Krone pro Kilometer, Postkutsche 3 Heller pro Kilometer,
Festmahl 2 Dukaten, Luxussuite 2 Dukaten, Lehrer 5 Dukaten pro Tagesabschnitt, Heilung 5 Dukaten.

## 3. Preis-Anker nach Kategorie

Zum Danebenlegen, wenn du ein neues Item einordnen willst. Spannen in Dukaten, Kronen und Heller.

| Kategorie               | Spanne      | Typischer Wert | Ankerbeispiele                                                                                  |
|-------------------------|-------------|----------------|-------------------------------------------------------------------------------------------------|
| Kleinkram und Verbrauch | 1 Heller – 5 Kronen   | 1–5 Kronen          | Kreide 1 Heller, Fackel 5 Heller, Nadel & Faden 3 Kronen, Lampenöl 3 Kronen                                         |
| Nahrung und Getränk     | 5 Heller – 3 Kronen   | 3 Kronen            | Tagesration 1 Krone, Wein 3 Kronen, Humpen Met 4 Heller                                                       |
| Kleidung                | 5 Heller – 10 Dukaten  | 1–2 Dukaten          | Lumpen 5 Heller, Stiefel 2 Dukaten, Umhang 8 Kronen, Pelzumhang 1 Dukat, Feine Gewänder 10 Dukaten                        |
| Werkzeug                | 1 Krone – 20 Dukaten  | 2–8 Dukaten          | Hammer 1 Dukat, Schaufel 2 Dukaten, Zimmermannswerkzeug 8 Dukaten, Schmiedewerkzeug 20 Dukaten                        |
| Behälter und Alltag     | 5 Heller – 10 Dukaten  | 1–5 Dukaten          | Eimer 5 Heller, Korb 4 Kronen, Flasche 1 Dukat, Rucksack 3 Dukaten, Truhe 5 Dukaten, Vorhängeschloss 10 Dukaten                 |
| Nahkampfwaffen          | 1 Krone – 50 Dukaten  | 8–25 Dukaten         | Dolch 1 Dukat, Beil 2 Dukaten, Kurzschwert 8 Dukaten, Breitschwert 12 Dukaten, Langschwert 25 Dukaten, Zweihandschwert 50 Dukaten |
| Fernkampf               | 1 Krone – 200 Dukaten | 25–75 Dukaten        | Schleuder 1 Krone, Kurzbogen 25 Dukaten, Langbogen 50 Dukaten, leichte Armbrust 75 Dukaten, schwere Armbrust 200 Dukaten    |
| Rüstung und Schilde     | 2 Dukaten – 500 Dukaten | 4–50 Dukaten         | Lederrüstung 2 Dukaten, kleiner Schild 4 Dukaten, Kettenpanzer 50 Dukaten, Großhelm 100 Dukaten, Plattenpanzer 500 Dukaten    |
| Tiere                   | 4 Kronen – 400 Dukaten | 3–15 Dukaten         | Huhn 4 Kronen, Schaf 3 Dukaten, Kuh 10 Dukaten, Wachhund 15 Dukaten, Reitpferd 60 Dukaten, Kampfpferd 400 Dukaten                  |
| Fahrzeuge               | 6 Dukaten – 40 Dukaten  | 15–30 Dukaten        | Kanu 6 Dukaten, Ruderboot 15 Dukaten, Karren 15 Dukaten, Planwagen 30 Dukaten, Segelboot 40 Dukaten                           |
| Musik und Spiel         | 1 Krone – 30 Dukaten  | 1–20 Dukaten         | Würfel 1 Krone, Spielkarten 5 Kronen, Flöte 2 Dukaten, Harfe 8 Dukaten, Leier 20 Dukaten, Dudelsack 30 Dukaten                   |
| Gifte und Tränke        | 6 Kronen – 50 Dukaten  | 1–12 Dukaten         | einschläfernd 6 Kronen, lähmend 12 Kronen, tödlich 2 Dukaten, Heiltrank 50 Dukaten                                    |
| Bücher und Magie        | 2 Dukaten – 50 Dukaten  | 5–25 Dukaten         | Zauberbuch 2 Dukaten, Amulett 3 Dukaten, Zauberstab 10 Dukaten, Buch 25 Dukaten, Grimoire 50 Dukaten                          |

Seltenheit (`rarity`) und Preis hängen **grob** zusammen: gewöhnlich meist bis etwa 15 Dukaten, ungewöhnlich oft 2–50 Dukaten,
selten ab etwa 5 Dukaten (teils sehr teuer). Es gibt aber Ausnahmen (Kurzbogen ist gewöhnlich und kostet 25 Dukaten, ein Amulett der
Klarheit ist selten und kostet 5 Dukaten). Die Seltenheit ist also ein Hinweis, kein Preisregler.

## 4. Loot und Beute

Die Schatztabellen (W6: 1–3 Tabelle 1, 4–6 Tabelle 2, dann W20) liefern drei Sorten Wert:

- **Münzen** (Tabelle 1, Wurf 1–16): von W6 Heller bis 2W6 × 10 Dukaten. Mittlere Beute: 2W6 × 10 Dukaten im Schnitt 70 Dukaten,
  3W6 × 10 Kronen im Schnitt 10,5 Dukaten, 4W6 × 10 Heller im Schnitt 1,4 Dukaten.
- **Schmuck** (Tabelle 1 Wurf 17–20, Tabelle 2 Wurf 1–5): Kelch 2W6 × 5 Dukaten (im Schnitt 35 Dukaten), Silberarmband 2W6 × 10 Kronen (7 Dukaten), Goldarmband 2W6 × 10 Dukaten (70 Dukaten), Silberkette 2W6 × 5 Kronen (3,5 Dukaten), Goldkette 2W6 Dukaten (7 Dukaten), Silberring 2W6 Kronen (0,7 Dukaten),
  Goldring 4W6 Dukaten (14 Dukaten), Silberbrosche 2W6 × 5 Kronen (3,5 Dukaten), Goldamulett 2W6 × 5 Dukaten (35 Dukaten).
- **Edelsteine** (Tabelle 2 Wurf 6, dann W6): Glas 2 Heller, Kristall 10 Kronen, Smaragd 10 Dukaten, Saphir 15 Dukaten, Rubin 25 Dukaten, Diamant
  100 Dukaten. Im Schnitt etwa 25 Dukaten.
- **Gegenstände** (Tabelle 2 Wurf 7–20): Kleidung, Waffen, Rüstung, Instrumente, Handelswaren usw. Ihr Wert ist meist
  der normale Katalogpreis aus Abschnitt 3, Meisterwerk-Waffen liegen darüber. Giftdolch, Rostiger Nagel und Ratte sind
  Fallen, keine Wertgegenstände.

Grobe Erwartung: ein Wurf auf **Tabelle 1 bringt im Schnitt etwa 14 Dukaten**, ein Wurf auf Tabelle 2 meist einen
Gegenstand im Wert von 1–50 Dukaten oder, mit Glück, einen Edelstein. Ein typischer Fund entspricht also etwa zwei Wochen
Alltag, ein Gegenstandsfund einer guten Waffe. Mehrere Funde pro Abenteuer ergeben schnell dreistellige Summen.

Schmuck und Edelsteine existieren **bisher nur als Tabellenzeilen**, nicht als Katalog-Items. Die Spieler tragen den
gewürfelten Wert selbst ein.

## 5. Faustregeln für unbekannte Dinge (Vorschlag)

Vorgehen in drei Schritten:

1. **Normalen Gegenstand suchen**, der am nächsten liegt (Abschnitt 3). Dessen Preis ist der Basiswert.
2. **Modifikator** wählen, der am besten passt (mehrere dürfen sich multiplizieren, aber im Zweifel nur den größten
   nehmen).
3. **Händlerfaktor** am Tisch entscheiden: ein Händler kauft meist nur zum halben Wert an und verkauft zum vollen.
   Dieser Faktor ist reine Spielleiter-Entscheidung.

| Eigenschaft                                      | Faktor                | Beispiel                                                        |
|--------------------------------------------------|-----------------------|-----------------------------------------------------------------|
| Beschädigt, rostig, zerrissen                    | × ½                   | Rostiges Beil 1 Dukat                                               |
| Gebraucht, abgenutzt                             | × ¾                   | Alter Rucksack 2 Dukaten                                              |
| Meisterwerk (MP)                                 | × 10                  | Meisterwerk-Dolch 10 Dukaten                                          |
| Edles Material (Silber/Gold, Seide, Pelz)        | × 3–10                | Silberner Becher statt Tonkrug 2–5 Dukaten                            |
| Alt und noch brauchbar (Wein, Käse, Spirituosen) | × 3–10                | siehe Beispiel                                                  |
| Selten, schwer zu bekommen                       | × 2–5                 | Fernrohr, Gift                                                  |
| Einzigartig / Sammlerstück / magisch             | Von der SL festgelegt | Benanntes Einzelstück, z. B. Grimoire 50 Dukaten als Untergrenze |

**Beispiel: staubiger alter Wein.** Basis ist eine Flasche Wein mit 3 Kronen.

- Staubig, aber schlicht (Lagerware, unbekannter Jahrgang): × 3 = **ca. 9 Kronen**.
- Gereift, gut erhalten, trinkbar und gefragt: × 10 = **3 Dukaten**.
- Ein edler Jahrgang eines bekannten Weinguts: × 30–100 = **9 bis 30 Dukaten**, das Preisniveau eines guten Schwerts. Das
  sollte etwas Besonderes sein (Fundort, Etikett, Siegel, Geschichte).
- Verdorben, Essig: × ¼ = ca. 1 Krone (nur noch Kochwein).

Zum Vergleich: Im Gasthaus kostet ein Becher Wein 2 Kronen, im Laden die ganze Flasche 3 Kronen. Gasthauspreise sind
Portionspreise und taugen nicht als Ladenpreis.

Merksatz: **Alter, Material und Meisterschaft** treiben den Preis, **Zustand und Händler** drücken ihn.

## 6. Lücken und mögliche nächste Schritte

Nur Liste, noch nichts umgesetzt:

- **Schmuck, Edelsteine, Handelswaren, Kunst** bleiben bewusst ohne Katalog-Items (Würfelergebnisse reichen, Ideen in `docs/loot/ideen/`).
- **Verkaufs- und Kaufwert trennen**, statt eines einzigen Preises (siehe Händlerfaktor in Abschnitt 5).
- **"Stumpfer Gegenstand, leicht/schwer"** haben keinen Preis (0). Gewollt (Improvisation) oder ergänzen?
- **Seltenheit und Preis** sauber koppeln (Preisstufen pro `rarity`), damit neue Items konsistent bleiben.
- **Qualitätsstufen** (beschädigt, Meisterwerk) als feste Zuschläge in der App, nicht nur im Kopf der SL. Meisterwerke stehen als Zusatz im Text, siehe `docs/loot/meisterwerke.md`.

Die Regeln zu Meisterwerken, Magie, Belohnungen und Händlern liegen in `docs/loot/`. Ideenlisten für Schmuck, Edelsteine, Handelswaren, Kunst, magische Stücke und Dienste stehen in `docs/loot/ideen/`, bewusst nicht in der Datenbank: Solche Items entstehen spontan am Tisch.

## 7. Spitznamen für die Münzen

Volkstümliche Namen, wie man sie am Tisch oder im Wirtshaus sagt.

- **Heller:** **Krümel** (festgelegt), weil er kaum mehr als ein Krümel Brot wert ist.
- **Krone:** kein Spitzname, bleibt einfach Krone.
- **Dukat:** **Hadrik** (festgelegt), nach Hadrik I., dem ersten König nach dem Bürgerkrieg (siehe Lore, Kapitel "Der Beifall"). Der einfache Mann sieht kaum einen Dukaten und gibt ihm den Namen des Mächtigen, dessen Haus bis heute herrscht. Ob Hadrik wirklich auf der Münze geprägt ist, steht nicht in der Lore (Vorschlag: ja, Profil des ersten Königs).

Die Spitznamen sind noch nicht in die Lore (`/dm/lore`) übernommen, das passiert bei der Lore-Überarbeitung (siehe `docs/TODO.md`).
