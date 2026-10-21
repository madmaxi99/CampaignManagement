# Ideen: Dienstleistungen

Ideenliste für künftige Projekte, **nicht in der Datenbank**: Items und Dienste entstehen spontan am Tisch, diese Liste ist Vorrat und Anregung. Nur für die Spielleitung. Währung: Heller, Krone, Dukat (1 Dukat = 10 Kronen = 100 Heller). Preise folgen `docs/geld-und-werte.md`, Orte und Gilden der Lore aus der App (`/dm/lore`). Festpreis für Standarddienste, **Wurfpreis** (Mittelwert = Katalogpreis) für besondere Dienste, wie in Block 1. Die Einheit ist frei (pro Tag, pro Wagen, pro Kilometer, pro Person ...), meist pro Tag oder pro Wagen.

Schon im Katalog (`catalog_services`) und daher hier nicht neu: Bad im Gasthaus, Leibwächter, Schüssel Eintopf, Kleiderreparatur, Bote, Festmahl, Becher Wein, Haarschnitt, Heilung, die drei Unterkünfte im Gasthaus, Mahlzeit im Gasthaus, Wegzoll, Postkutsche, Humpen Met, Lehrer.

**Wirkung:** Die neuen Dienste haben hier nur eine Beschreibung ohne Regelwirkung. Wo die Regeln etwas hergeben (Rast, Heilkunde), gilt der bestehende Dienst.

## Entschieden

- **Sichtbarkeit:** Alles unter `docs/loot/` ist **nur für die Spielleitung** sichtbar, auch die illegalen Dienste und die Droge.
- **Illegale Dienste und Nebelkraut:** bleiben, Nebelkraut gefällt.
- **Reparatur:** immer derselbe Anteil.

## Offene Fragen

- **Anteile statt Preise:** Reparatur und Hehlerei sind ein Anteil vom Vollpreis bzw. vom Warenwert. Das Preisfeld der Dienste kennt nur feste Münzbeträge. Vorschlag für die Datenbank: Preis 0 und der Anteil im Wirkungstext, später vielleicht ein eigenes Feld (Phase 2).

## Reise und Verkehr

| Name | Seltenheit | Preis | Heller | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Fähre über die Weide | gewöhnlich | 3 Heller | 3 | pro Person | Überfahrt an einer der Flussquerungen. |
| Brückenzoll (Bruckau) | gewöhnlich | 5 Heller | 5 | pro Wagen | Zoll an der Brücke der Flussstadt. |
| Karawanenzoll (Haus Lorn) | gewöhnlich | 3 Kronen | 30 | pro Wagen | Zoll für Fuhrwerke auf den Königsstraßen, eingetrieben im Namen von Haus Lorn. |
| Mitreise in der Karawane | gewöhnlich | 5 Kronen | 50 | pro Person und Tag | Platz in einer Karawane der Karawanengilde, mit Schutz durch gildeneigene Wachen. |
| Schiffspassage ab Salzbruck | gewöhnlich | 8 Kronen | 80 | pro Person und Fahrt | Küstenfahrt auf einem Schiff aus Salzbruck. |
| Pferd mieten | gewöhnlich | 5 Kronen | 50 | pro Tag | Ein Reitpferd vom Mietstall, gegen Pfand. |
| Stallplatz | gewöhnlich | 2 Kronen | 20 | pro Nacht | Platz im Stall für ein Pferd. |
| Pferdefutter | gewöhnlich | 5 Heller | 5 | pro Tag | Hafer und Heu für ein Pferd. |
| Wegführer | gewöhnlich | 5 Kronen | 50 | pro Tag | Ortskundiger für Wege abseits der Königsstraßen, zum Beispiel ein Wolfkin-Späher im Grenzforst. |
| Lastenträger | gewöhnlich | 1 Krone | 10 | pro Tag | Trägt Gepäck, fragt nicht nach dem Inhalt. |

## Handwerk und Alltag

| Name | Seltenheit | Preis | Heller | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Hufeisen beschlagen | gewöhnlich | 3 Heller | 3 | pro Hufeisen | Vom Schmied, mit Zunftzeichen. |
| Wäsche waschen | gewöhnlich | 2 Heller | 2 | pro Ladung | Kleidung und Decken. |
| Scheune als Nachtlager | gewöhnlich | 3 Heller | 3 | pro Nacht | Heu und ein Dach, ohne Bad, ohne Frühstück. |
| Kammer mieten | gewöhnlich | 3 Dukaten | 300 | pro Monat | Eine kleine Stube in einer Stadt. |
| Bestattung (einfach) | gewöhnlich | 5 Kronen | 50 | je Bestattung | Grab und Totengräber. |
| Bestattung mit Zeremonie | ungewöhnlich | 3 Dukaten | 300 | je Bestattung | Trauerzug, Redner und Grabstein. |
| Musikant spielt auf | gewöhnlich | 5 Kronen | 50 | pro Abend | Ein Spielmann in der Schankstube. |
| Wundversorgung | gewöhnlich | 5 Kronen | 50 | pro Behandlung | Eine Kräuterkundige verbindet und reinigt Wunden. Regelwirkung wie bei Heilkunde-Proben, nicht wie der Dienst "Heilung". |

## Reparatur (immer ein Anteil vom Vollpreis)

Eine Waffe oder Rüstung ist **kaputt oder heil**, mehr Stufen gibt es nicht. Reparatur ist deshalb **immer derselbe Anteil** am Neupreis des Stücks. Der Preis ist kein fester Betrag, im Katalog steht Preis 0 und der Anteil im Text. Bei einem Meisterwerk ergibt sich der höhere Preis von selbst, weil der Neupreis das Zehnfache ist.

| Name | Seltenheit | Anteil vom Neupreis | Beschreibung |
| --- | --- | --- | --- |
| Reparatur | gewöhnlich | ein Zehntel (10 Prozent), mindestens 5 Heller | Der Schmied bringt ein kaputtes Stück wieder in Ordnung, vom verbogenen Schwert bis zum gerissenen Kettenhemd. |

## Wissen und Schrift

| Name | Seltenheit | Preis | Heller | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Brief schreiben | gewöhnlich | 2 Kronen | 20 | pro Brief | Ein Schreiber setzt den Brief auf und versiegelt ihn. |
| Urkunde beglaubigen | ungewöhnlich | 1 Dukat | 100 | pro Urkunde | In der Kanzlei von Haus Thalheim in Hohenfurt. Dauert Tage, nicht Stunden. |
| Bibliothekszugang | ungewöhnlich | 5 Kronen | 50 | pro Tag | Zugang zu den Archiven in Hohenfurt, unter Aufsicht. |
| Gelehrten befragen | ungewöhnlich | 1 Dukat | 100 | pro Gespräch | Ein Gelehrter nimmt sich Zeit für eine Frage. |

## Besondere Dienste (legal)

| Name | Seltenheit | Preis | Heller | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Söldner anheuern | ungewöhnlich | 1 Dukat | 100 | pro Tag | Ein Söldner, oft aus den Grenzlanden (Halb-Orks, Wolfkin). Billiger als ein Leibwächter, weniger vertrauenswürdig. |

## Illegale Dienste und Drogen (Wurfpreis)

Alles in der Unterwelt, unter der Hand und nie mit Quittung. Der Preis ist der Mittelwert der Formel, die Spielleitung würfelt den tatsächlichen Preis nach Risiko und Auftraggeber aus. Die meisten Dienste kosten **einmalig** und pro Auftrag, nicht pro Tag. Wer auffliegt, hat ein Problem mit der Stadtwache, Haus Lorn (Zölle) oder Haus Eberwein.

### Kleine Gefälligkeiten

| Name | Seltenheit | Preis | Heller | Wurfpreis | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- | --- |
| Gerücht kaufen | ungewöhnlich | 3 Dukaten 5 Kronen | 350 | W6 Dukaten | pro Gerücht | Ein Informant erzählt, was er weiß. Je heikler das Thema, desto höher der Wurf. |
| Wache bestechen | ungewöhnlich | 7 Kronen | 70 | 2W6 Kronen | pro Wache und Anlass | Ein Torwächter schaut weg, ein Wärter vergisst den Schlüssel. |
| Zöllner bestechen | ungewöhnlich | 3 Dukaten 5 Kronen | 350 | 2W6 × 5 Kronen | pro Fuhre | Der Zöllner winkt durch und trägt nichts ein. |
| Taschendieb beauftragen | ungewöhnlich | 3 Dukaten 5 Kronen | 350 | W6 Dukaten | pro Stück | Ein Dieb besorgt einen bestimmten Gegenstand von einer bestimmten Person. |
| Schläger anheuern | ungewöhnlich | 5 Dukaten | 500 | 2W4 Dukaten | pro Auftrag | Einschüchterung oder eine Tracht Prügel, keine Toten. |

### Schmuggel, Fälschung und Hehlerei

| Name | Seltenheit | Preis | Heller | Wurfpreis | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- | --- |
| Schmuggler anheuern | ungewöhnlich | 7 Dukaten | 700 | 2W6 Dukaten | pro Fuhre | Bringt Ware am Zoll vorbei. Haus Lorn sieht das nicht gern. |
| Urkunde oder Siegel fälschen | selten | 17 Dukaten 5 Kronen | 1750 | W6 × 5 Dukaten | pro Stück | Ein Fälscher in einer Hinterstube. Wer auffliegt, hat ein ernstes Problem mit Haus Thalheim. |
| Beamten bestechen | selten | 14 Dukaten | 1400 | 4W6 Dukaten | pro Anlass | Ein Beamter eines Hauses oder einer Gilde sieht weg oder stempelt ab. |

| Name | Seltenheit | Anteil | Beschreibung |
| --- | --- | --- | --- |
| Hehler (Beute verkaufen) | ungewöhnlich | Auszahlung ein Drittel des Werts | Ein Hehler kauft ohne Fragen, aber nur zu einem Drittel des Preises. Im Katalog Preis 0, der Anteil steht im Text. |
| Falschgeld kaufen | selten | ein Fünftel des Nennwerts | Falsche Münzen, die auf den ersten Blick echt wirken. Wer sie ausgibt, riskiert einen Galgen. |

### Einbruch, Raub und Gewalt

| Name | Seltenheit | Preis | Heller | Wurfpreis | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- | --- |
| Einbruch (Bürgerhaus) | ungewöhnlich | 10 Dukaten 5 Kronen | 1050 | 3W6 Dukaten | pro Auftrag | Ein Dieb steigt bei einem Bürger ein und nimmt, was bestellt wurde. |
| Einbruch (Adelshaus oder Gildenhaus) | selten | 70 Dukaten | 7000 | 2W6 × 10 Dukaten | pro Auftrag | Wachen, Schlösser und Hunde. Wenig Dieb nehmen so etwas an. |
| Ausrauben (Überfall anheuern) | selten | 15 Dukaten | 1500 | 2W6 + 8 Dukaten | pro Auftrag | Wegelagerer überfallen eine Karawane oder einen Reisenden. Dazu kommt die Hälfte der Beute. |
| Erpressung | selten | 21 Dukaten | 2100 | W6 × 6 Dukaten | pro Auftrag | Jemand besorgt Druckmittel und liefert den Brief an den Erpressten. |
| Brandstiftung | selten | 35 Dukaten | 3500 | 2W6 × 5 Dukaten | pro Auftrag | Ein Speicher, eine Scheune oder ein Haus brennt, ohne dass es nach Absicht aussieht. |
| Entführung | selten | 70 Dukaten | 7000 | 2W6 × 10 Dukaten | pro Auftrag | Eine Person verschwindet und wird an einem verabredeten Ort wieder abgeliefert. |
| Gefangenen befreien | selten | 63 Dukaten | 6300 | 3W6 × 6 Dukaten | pro Auftrag | Jemand wird aus der Haft geholt oder auf dem Weg dorthin abgefangen. |

### Auftragsmord

| Name | Seltenheit | Preis | Heller | Wurfpreis | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- | --- |
| Auftragsmord (einfaches Ziel) | selten | 42 Dukaten | 4200 | 3W6 × 4 Dukaten | pro Auftrag | Ein Bürger, ein Bauer, ein Söldner. Jemand, den man nicht vermissen wird. |
| Auftragsmord (angesehene Person) | episch | 350 Dukaten | 35000 | 4W6 × 25 Dukaten | pro Auftrag | Ein Zunftmeister, ein Hauptmann, ein reicher Händler. Nur über Mittelsmänner. |
| Auftragsmord (Adel oder Gildenhaupt) | episch | 1050 Dukaten | 105000 | 2W6 × 150 Dukaten | pro Auftrag | Ein Haupt eines Hauses oder einer Gilde. Kaum jemand nimmt so etwas an und lebt lange. |

### Droge

Eine Droge reicht für den Anfang. Sie gehört in die Unterwelt, nicht in die Regelwerksliste, und lässt sich bei Bedarf in der Spielleitung erweitern.

| Name | Seltenheit | Preis | Heller | Einheit | Beschreibung |
| --- | --- | --- | --- | --- | --- |
| Nebelkraut | ungewöhnlich | 5 Kronen | 50 | pro Dosis | Ein getrocknetes Kraut aus der Nebelmark, das man raucht. Es dämpft Schmerz und Angst, macht müde und gleichgültig. Regelwirkung nach Ermessen der Spielleitung. |

## Kandidaten zum Streichen

- Kammer mieten, Bestattungen, Wäsche waschen: Weltbau, kaum Spielrelevanz.
- Illegale Dienste: nur sinnvoll, wenn Intrige und Unterwelt gespielt werden. Auftragsmord (angesehene Person) und (Adel oder Gildenhaupt) sind bewusst so teuer, dass sie fast nie bezahlbar sind.
- Söldner anheuern: überschneidet sich mit Leibwächter.
