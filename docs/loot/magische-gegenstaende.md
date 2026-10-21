# Magische Gegenstände und Relikte

Der **Baukasten** für magische Gegenstände. **Nur für die Spielleitung sichtbar**, wie alles unter `docs/loot/`. Währung:
Heller, Krone, Dukat (1 Dukat = 10 Kronen = 100 Heller). Die **fertigen Stücke** stehen in `docs/loot/ideen/`.

## Entschieden

- **Sichtbarkeit:** Nur Spielleitung, siehe `docs/loot/README.md`.
- **Nicht nur Kampf:** Magische Gegenstände dürfen alles sein, auch Zaubertricks und Zauber.
- **Maximum +2 auf Fertigkeiten:** Ein Fertigkeitsbonus ist +1 oder +2, nie mehr.
- **Erkennen:** Magische Gegenstände müssen irgendwann erkannt werden. Das ist ein Platzhalter für später, **erstmal nur
  Listen**.

## Noch offen

- **Aufschläge:** 35 Dukaten für +1 und 140 Dukaten für +2. Zu hoch oder zu niedrig?
- **Waffen:** Sollen magische Waffen auch +N auf die Waffenfertigkeit bekommen (zum Beispiel +2 auf Schwerter)?
- **Namen:** "Beifall", "Hadrik" und "Plau" sind Anspielungen auf die Lore. Zu viele?

## Der Baukasten

### Aufbau

Ein **magischer Gegenstand** besteht aus einem **Basisgegenstand** (aus dem Katalog: Ring, Umhang, Lederrüstung,
Dolch ...) plus **magischen Eigenschaften** aus den Listen unten, optional einem **Nachteil**. Damit lassen sich
Hunderte Stücke zusammensetzen oder auswürfeln, ohne dass jedes eine eigene Geschichte braucht. Die fertigen Stücke
weiter unten sind Beispiele davon.

Die Eigenschaft **magisch** gibt es in drei Arten:

1. **Verbesserte Fähigkeit:** **+1 oder +2 auf eine Fertigkeit** (Maximum +2).
2. **Zauber:** ein **Zaubertrick** oder **Zauber** aus dem Katalog, **einmalig** oder **täglich**.
3. **Einzigartiger Effekt:** etwas Neues, das es sonst nicht gibt.

**+N auf eine Fertigkeit** heißt: Der Fertigkeitswert steigt bei Proben auf diese Fertigkeit um N. Das ist **kein
Vorteil**, sondern ein fester Zuschlag. Rüstungen, Helme, Schilde, Ringe, Umhänge und alles andere dürfen das haben,
nicht nur Waffen. Auch **Meisterwerke** (`docs/loot/meisterwerke.md`) können magisch sein, dann stehen beide Zusätze
im Text.

### Preis

**Gesamtpreis = Katalogpreis des Basisgegenstands + Aufschlag der Eigenschaft (en).** Mit **Nachteil** kostet der
Gegenstand **drei Viertel** davon. Der Aufschlag ist eine **besondere Sache** und hat einen **Wurfpreis**, dessen
Mittelwert der Aufschlag ist. Die App würfelt nicht, die Formel steht nur als Text.

**Seltenheit** ist **nur die Häufigkeit** und hängt nicht am Preis. Die Spielleitung legt sie pro Stück fest. Die
Spalte "Seltenheit" in den Tabellen ist ein **Richtwert** (+1 selten, +2 und kleiner bis mittlerer Effekt episch, großer
Effekt legendär). Ein **Name** macht ein Stück zum **Einzelstück**: Es gibt es nur einmal im Spiel, dafür braucht es kein
Kennzeichen. Läden würfeln die Seltenheit nicht, die SL entscheidet spontan (siehe `docs/loot/haendler.md`).

### Fähigkeit: +1 oder +2 auf eine Fertigkeit

| Eigenschaft            | Aufschlag   | Heller | Wurfpreis        | Seltenheit |
|------------------------|-------------|--------|------------------|------------|
| +1 auf eine Fertigkeit | 35 Dukaten  | 3500   | 2W6 × 5 Dukaten  | selten     |
| +2 auf eine Fertigkeit | 140 Dukaten | 14000  | 2W6 × 20 Dukaten | episch     |

**Fertigkeiten** (+N gilt für genau eine):

- Allgemein: Akrobatik, Ausweichen, Bestienkunde, Darbietung, Entdecken, Feilschen, Fingerfertigkeit, Fremdsprachen,
  Handwerk, Heilkunde, Heimlichkeit, Jagen & Fischen, Mythen & Legenden, Reiten, Schwimmen, Seefahrt, Täuschen,
  Überzeugen, Wahrnehmung, Wildnisleben.
- Waffenfertigkeiten: Armbrüste, Äxte, Bögen, Hämmer, Messer, Prügelei, Schleudern, Schwerter, Speere, Stäbe.

### Zaubertrick aus dem Katalog

Der Träger wirkt den Trick **ohne WP-Kosten und ohne Probe**, auch ohne Zauberkunde.

| Nutzung    | Aufschlag          | Heller | Wurfpreis   | Seltenheit   |
|------------|--------------------|--------|-------------|--------------|
| Einmalig   | 3 Dukaten 5 Kronen | 350    | W6 Dukaten  | ungewöhnlich |
| 1× täglich | 7 Dukaten          | 700    | 2W6 Dukaten | ungewöhnlich |

**Zaubertricks** (17, aus dem Katalog): Aufwärmen/Abkühlen, Entzünden, Rauchwolke, Herbeirufen, Antippen, Licht,
Öffnen/Schließen, Kleidung reparieren, Vogelgesang, Saubermachen, Essen kochen, Blütenspur, Frisur, Schloss
öffnen/schließen, Zauberhocker, Sanft fallen, Magie spüren.

### Einzigartiger Effekt

Neue Effekte, die es im Katalog nicht gibt. Die Stufe bestimmt den Aufschlag.

| Stufe  | Aufschlag   | Heller | Wurfpreis        | Seltenheit |
|--------|-------------|--------|------------------|------------|
| Klein  | 35 Dukaten  | 3500   | 2W6 × 5 Dukaten  | selten     |
| Mittel | 140 Dukaten | 14000  | 2W6 × 20 Dukaten | episch     |
| Groß   | 840 Dukaten | 84000  | 3W6 × 80 Dukaten | legendär   |

| W20 | Effekt               | Wirkung (Vorschlag)                                                      | Stufe  |
|-----|----------------------|--------------------------------------------------------------------------|--------|
| 1   | Warnleuchte          | Glimmt, wenn Feinde in 30 Metern Umkreis sind.                           | klein  |
| 2   | Rückkehr             | Kehrt einmal pro Tag auf Befehl aus bis zu 100 Metern zum Träger zurück. | mittel |
| 3   | Verborgen            | Nur der Träger sieht und spürt den Gegenstand.                           | klein  |
| 4   | Passgenau            | Passt sich in Größe und Form dem Träger an.                              | klein  |
| 5   | Immer sauber         | Wird nie schmutzig, nass oder rostig.                                    | klein  |
| 6   | Wachsamer Begleiter  | Weckt den Träger, wenn im Schlaf Gefahr naht.                            | klein  |
| 7   | Giftwitterung        | Verfärbt sich bei Gift in Speise und Trank.                              | klein  |
| 8   | Heimweg              | Zeigt auf Wunsch die Richtung nach Hause.                                | klein  |
| 9   | Glückssträhne        | Einmal pro Sitzung darf der Träger eine Probe wiederholen.               | mittel |
| 10  | Zweite Haut          | Rüstungswert +1 ohne Abzug.                                              | mittel |
| 11  | Lebenskraft          | Maximale TP +2.                                                          | mittel |
| 12  | Geistesfokus         | Maximale WP +2.                                                          | mittel |
| 13  | Spiegel der Wahrheit | Leuchtet, wenn in Hörweite gelogen wird.                                 | mittel |
| 14  | Elementenschutz      | Rüstungswert +2 gegen ein Element (Feuer, Kälte oder Blitz).             | mittel |
| 15  | Tierfreund           | Tiere stehen dem Träger freundlich gegenüber.                            | mittel |
| 16  | Wasserlauf           | Der Träger kann ruhiges Wasser überqueren.                               | mittel |
| 17  | Schattenhaut         | Vorteil auf Heimlichkeit in Dunkelheit.                                  | mittel |
| 18  | Sprachgabe           | Der Träger versteht jede gesprochene Sprache.                            | mittel |
| 19  | Schmerzlos           | Einmal pro Tag legt der Träger einen Zustand ab.                         | groß   |
| 20  | Unsichtbarkeit       | Einmal pro Tag eine Minute lang unsichtbar.                              | groß   |

### Nachteile

Ein magischer Gegenstand **kann einen Nachteil haben**. Der Nachteil wird gewürfelt (W10) oder von der Spielleitung
gewählt und senkt den **Gesamtpreis auf drei Viertel**. Ein **einstufiger Nachteil** wie "−1 auf Akrobatik" ist der
einfachste.

| W10 | Nachteil      | Wirkung (Vorschlag)                                                                                           |
|-----|---------------|---------------------------------------------------------------------------------------------------------------|
| 1   | Fertigkeit −1 | Ein Fertigkeitswert sinkt um 1 (einstufig). Die Fertigkeit wird gewürfelt oder von der Spielleitung bestimmt. |
| 2   | Fertigkeit −2 | Ein Fertigkeitswert sinkt um 2 (zweistufig).                                                                  |
| 3   | Laut          | Nachteil auf Heimlichkeit, solange der Gegenstand getragen wird.                                              |
| 4   | Hungrig       | Der Träger braucht doppelte Verpflegung.                                                                      |
| 5   | Albträume     | Nach einer Nacht Nachteil auf die erste WIL-Probe des Tages.                                                  |
| 6   | Kalt          | Der Träger friert, Nachteil bei Kälte.                                                                        |
| 7   | Auffällig     | Jeder erkennt den Gegenstand als magisch.                                                                     |
| 8   | Flüsterer     | Der Gegenstand flüstert, die Spielleitung spricht für ihn.                                                    |
| 9   | Fordernd      | Jede Nutzung kostet den Träger 1 WP.                                                                          |
| 10  | Bindung       | Der Gegenstand lässt sich nur mit einer Probe oder einem Ritual wieder ablegen.                               |

### Beispiele

| Gegenstand                                                 | Zusammensetzung                                                               | Preis                        |
|------------------------------------------------------------|-------------------------------------------------------------------------------|------------------------------|
| Umhang mit +2 Akrobatik                                    | Umhang (8 Kronen) + 140 Dukaten Aufschlag                                     | 140 Dukaten 8 Kronen         |
| Ring der Wärme                                             | Bronzering (1 Krone) + Zaubertrick Aufwärmen/Abkühlen, 1× täglich (7 Dukaten) | 7 Dukaten 1 Krone            |
| Lederrüstung mit +1 Akrobatik und Nachteil −1 Heimlichkeit | Lederrüstung (2 Dukaten) + 35 Dukaten, mal drei Viertel                       | 27 Dukaten 7 Kronen 5 Heller |
| Stab der Heilung                                           | Stab (2 Kronen) + Zauber Wunden heilen, 1× täglich (140 Dukaten)              | 140 Dukaten 2 Kronen         |
| Schriftrolle Feuerball                                     | Pergament (1 Krone) + Zauber Feuerball, einmalig (35 Dukaten)                 | 35 Dukaten 1 Krone           |
| Schild mit +2 auf Schwerter                                | Schild, klein (4 Dukaten) + 140 Dukaten                                       | 144 Dukaten                  |

### Später: Erkennen

Nicht Teil dieser Liste, nur ein Platzhalter: Ein magischer Gegenstand **muss erkannt werden**. Mögliche Stufen:
unbekannt, als magisch erkannt (zum Beispiel mit dem Zaubertrick *Magie spüren*), Eigenschaft erkannt (Gelehrter,
Antiquar, Probe auf Mythen & Legenden). Händler, die den Wert eines Stücks nicht kennen, verkaufen es zum Preis des
Basisgegenstands (siehe `docs/loot/haendler.md`).

## Fertige Stücke

Eine Liste fertiger Stücke (Relikte, Fundstücke, Alltagsmagie) steht in `docs/loot/ideen/magische-fertigstuecke.md`. Sie ist
Vorrat für künftige Projekte und nicht in der Datenbank. Magische Gegenstände entstehen spontan am Tisch, mit dem Baukasten oben.
