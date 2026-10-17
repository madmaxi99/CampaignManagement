# Ausrüstungslisten im Buch vs. Katalog

Quelle: Dragonbane Schnellstarter, Ausrüstungskapitel (Screenshots in `docs/bilder/`). Verglichen mit `database/02_catalog.sql` (`catalog_items`, `catalog_item_weapons`, `catalog_item_armor`, `catalog_services`).

Verglichen wurden Name, Preis, Supply (= `rarity`), Gewicht und bei Waffen/Rüstungen die Werte (Grip, STR, Range, Damage, Durability, Features bzw. Rüstungswert und Bane). **Nicht** verglichen: die Effekt-Texte.

Spalte „Zeilen" = Anzahl der Zeilen der Buch-Tabelle (zum Gegenzählen). Supply: C = Common, U = Uncommon, R = Rare.

---

## Armor (6 Zeilen)

| Buch | Rating | Preis | Supply | Katalog | Status |
|---|---|---|---|---|---|
| Leather | 1 | 2 g | C | Lederrüstung | ok |
| Studded Leather | 2 | 10 g | U | Beschlagenes Leder | ok |
| Chainmail | 4 | 50 g | U | Kettenpanzer | ok |
| Plate Armor | 6 | 500 g | R | Plattenpanzer | ok |
| Open Helmet | +1 | 12 g | U | Offener Helm | Supply: Katalog C |
| Great Helm | +2 | 100 g | R | Großhelm | Supply: Katalog C |

Banes der Rüstungen stimmen alle.

## Melee Weapons (29 Waffen-Zeilen, plus die Modifikator-Zeile „Mastercrafted"; „Unarmed" ist ein Regelwert und kein Item)

| Buch | Grip / STR / Range / Dmg / Dur | Preis | Supply | Katalog | Status |
|---|---|---|---|---|---|
| Unarmed | – / – / 2 / D6 / – | – | – | – | kein Item (Regelwert) |
| Blunt Object, Light | 1H / – / STR / D8 / 3 | – | – | – | **fehlt** |
| Blunt Object, Heavy | 2H / 16 / 2 / 2D8 / 3 | – | – | – | **fehlt** |
| Knife | 1H / – / STR / D8 / 6 | 5 s | C | Messer | ok |
| Dagger | 1H / – / STR / D8 / 9 | 1 g | C | Dolch | ok |
| Parrying Dagger | 1H / – / 2 / D6 / 15 | 2 g | U | Parierdolch | ok |
| Short Sword | 1H / 7 / 2 / D10 / 12 | 8 g | C | Kurzschwert | ok |
| Broadsword | 1H / 10 / 2 / 2D6 / **15** | 12 g | C | Breitschwert | **Durability: Katalog 12** |
| Longsword | 1H / 13 / 2 / 2D8 / 15 | 25 g | U | Langschwert | Supply: Katalog C |
| Greatsword | 2H / 16 / 2 / 2D10 / 15 | 50 g | R | – | **fehlt** |
| Scimitar | 1H / 10 / 2 / 2D6 / 12 | 10 g | U | Krummsäbel | Supply: Katalog C |
| Handaxe | 1H / 7 / STR / 2D6 / 9 | 2 g | C | **Beil** | ok (Name!) |
| Battleaxe | 1H / 13 / 2 / 2D8 / 9 | 10 g | U | **Streitaxt** | Supply: Katalog C (Name!) |
| Two-Handed Axe | 2H / 16 / 2 / 2D10 / 9 | 25 g | U | Zweihandaxt | ok |
| Mace | 1H / 7 / 2 / 2D4 / 12 | 8 g | C | **Keule** | ok (Name! Beschreibung dort: „Streitkolben") |
| Morningstar | 1H / 13 / 2 / 2D8 / 12 | 14 g | U | Morgenstern | ok |
| Flail | 1H / 13 / 2 / 2D8 / – | 16 g | U | Dreschflegel | Supply: Katalog C |
| Warhammer, Light | 1H / 10 / 2 / 2D6 / 12 | 10 g | U | Kriegshammer, klein | Supply: Katalog C |
| Warhammer, Heavy | 2H / 16 / 2 / 2D10 / 12 | 20 g | U | Kriegshammer, schwer | ok |
| Wooden Club, Small | 1H / 7 / 2 / D8 / 9 | 1 s | C | – | **fehlt** (`Keule` ist die Mace) |
| Wooden Club, Large | 2H / 16 / 2 / 2D8 / 12 | 2 s | C | – | **fehlt** |
| Staff | 2H / 7 / 2 / D8 / 9 | 2 s | C | Stab | ok |
| Short Spear | 1H / 7 / STR×2 / D10 / 9 | 5 s | C | Kurzspeer | ok |
| Long Spear | 2H / 10 / 4 / 2D8 / 9 | 1 g | C | Langspeer | ok |
| Lance | 1H / 13 / 4 / 2D10 / 12 | 12 g | R | Lanze | Supply: Katalog C |
| Halberd | 2H / 13 / 4 / 2D8 / 12 | 20 g | R | Hellebarde | ok |
| Trident | 1H / 10 / STR / 2D6 / 9 | 5 g | U | Dreizack | Supply: Katalog C |
| Shield, Small | 1H / 7 / 2 / D8 / 15 | 4 g | C | Schild, klein | ok |
| Shield, Large | 1H / 13 / 2 / D8 / 18 | 12 g | **C** | Schild, groß | **Supply: Katalog U** |
| Mastercrafted | Modifikator ×10: STR −3, Durability +3 | – | – | – | kein Item (Regel) |

Features (Wucht/Hieb/Stich/…) stimmen bei allen vorhandenen Waffen.

## Ranged Weapons (6 Zeilen)

| Buch | Grip / STR / Range / Dmg / Dur | Preis | Supply | Katalog | Status |
|---|---|---|---|---|---|
| Sling | 1H / – / 20 / D8 / – | 1 s | C | Schleuder | ok |
| Short Bow | 2H / 7 / 30 / D10 / 3 | 25 g | C | Kurzbogen | ok |
| Longbow | 2H / 13 / 100 / D12 / 6 | 50 g | U | Langbogen | Supply: Katalog C |
| Crossbow, Light | 2H / 7 / 40 / 2D6 / 6 | 75 g | U | Leichte Armbrust | Supply: Katalog C |
| Crossbow, Heavy | 2H / 13 / 60 / 2D8 / 9 | 200 g | R | Schwere Armbrust | ok |
| Crossbow, Hand | 1H / 7 / 30 / 2D6 / 6 | 90 g | R | Handarmbrust | ok |

## Clothes (6 Zeilen)

| Buch | Preis | Supply | Katalog | Status |
|---|---|---|---|---|
| Boots | 2 g | U | Stiefel | ok |
| Cloak | 8 s | U | Umhang | ok |
| Fine Garments | 10 g | U | Feine Gewänder | ok |
| Fur | 1 g | U | Pelzumhang | ok |
| Rags | 5 c | C | Lumpen | ok |
| Simple Clothes | 5 s | C | Einfache Kleidung | ok |

## Musical Instruments (6 Zeilen)

| Buch | Preis | Supply | Gewicht | Katalog | Status |
|---|---|---|---|---|---|
| Bagpipe | 30 g | U | 1 | Dudelsack | ok |
| Drum | 4 g | C | 1 | Trommel | ok |
| Flute | 2 g | C | 1 | Flöte | ok |
| Harp | 8 g | U | **2** | Harfe | **Gewicht: Katalog 1** |
| Horn | 6 g | C | 1 | Horn | ok |
| Lyre | 20 g | U | 1 | Leier | Supply: Katalog C |

## Trade Goods (20 + 5 Zeilen)

| Buch | Preis | Supply | Gewicht | Katalog | Status |
|---|---|---|---|---|---|
| Abacus | 2 g | C | 1 | Abakus | ok |
| Blanket | 5 s | C | 1 | Wolldecke | ok |
| Chess Set | 1 g | C | 1 | Schachspiel | ok |
| Dice | 1 s | C | – | Würfel | ok |
| Field Kitchen | 4 g | C | 2 | Feldküche | ok |
| Field Ration | 1 s | C | ¼ | Tagesration | ok |
| Grappling Hook | 3 g | C | 1 | Wurfhaken | ok (Name im Gear-Text: „Enterhaken") |
| Lockpicks, Advanced | 20 g | R | 1 | Feines Diebeswerkzeug | ok |
| Lockpicks, Simple | 1 g | U | 1 | Dietriche | ok |
| Magnifying Glass | 30 g | U | 1 | Lupe | ok |
| Map | **5 g** | U | – | Karte | **Preis: Katalog 5 s** |
| Marbles | 1 g | C | 1 | Murmeln | ok |
| Padlock | 10 g | C | – | Vorhängeschloss | ok |
| Perfume (10 doses) | 5 g | C | 1 | Parfüm (10 Dosen) | ok |
| Playing Cards | 5 s | U | – | Spielkarten | ok |
| Quiver of Arrows, Iron Head | 2 g | C | 1 | – | **fehlt** |
| Quiver of Arrows, Wooden Head | 5 s | C | 1 | Köcher | ok (ist der Holzspitzen-Köcher, Name sagt es nicht) |
| Rope, Hemp (10 m) | 1 g | C | 1 | Seil (Hanf), 10m | ok |
| Rope, Silk (10 m) | 10 g | U | – | Seil (Seide), 10m | ok |
| Saddle | 10 g | C | 1 | Sattel | ok |
| Sleeping Fur | 1 g | C | 1 | Schlafpelz | ok |
| Spyglass | 50 g | R | 1 | Fernrohr | ok |
| Tent, Small | 2 g | C | 2 | Zelt, klein | ok |
| Tent, Large | 4 g | C | 4 | Zelt, groß | ok |
| Whistle | 5 s | C | – | Pfeife (Signalpfeife) | ok |

## Studies & Magic (13 Zeilen)

| Buch | Preis | Supply | Gewicht | Katalog | Status |
|---|---|---|---|---|---|
| Amulet | 3 g | U | – | Amulett | Supply: Katalog C |
| Book | 25 g | U | 1 | Buch | Supply: Katalog C |
| Brooch | 5 g | U | – | Brosche | ok |
| Chalk | 1 c | C | – | Kreide | ok |
| Grimoire | 50 g | Unique | 1 | Grimoire | ok |
| Hourglass | 25 g | R | 1 | Sanduhr | ok |
| Notebook | 5 g | C | 1 | Notizbuch | ok |
| Orbuculum | 18 g | U | 1 | Orbuculum | ok |
| Paper (sheet) | 2 s | U | – | Papier (Blatt) | ok |
| Parchment (sheet) | 1 s | C | – | Pergament (Blatt) | ok |
| Quill & Ink | 10 g | U | 1 | **Feder** | Supply: Katalog C (Name: „Feder" verliert „Tinte") |
| Reliquary | 5 g | U | 1 | Reliquiar | ok |
| Wand | 10 g | U | 1 | Zauberstab | Supply: Katalog C |

## Light Sources (6 Zeilen)

Alle 6 ok: Flint & Tinder (5 s, –) → Feuerstein & Zunder; Lamp Oil (3 s) → Lampenöl; Lantern (10 g) → Laterne; Oil Lamp (1 g) → Öllampe; Tallow Candle (1 c, –) → Talgkerze; Torch (5 c) → Fackel.

## Tools (10 Zeilen)

| Buch | Preis | Supply | Katalog | Status |
|---|---|---|---|---|
| Crowbar | 2 g | C | Brecheisen | ok |
| Hammer | 1 g | C | Hammer | ok |
| Needle & Thread | 3 s | C | Nadel & Faden | ok |
| Pickaxe | 3 g | C | Spitzhacke | ok |
| Saw | 5 g | U | Säge | ok |
| Shovel | 2 g | C | Schaufel | ok |
| Sledgehammer | 3 g | C | Vorschlaghammer | ok |
| Blacksmithing Tools | 20 g | U | Schmiedewerkzeug | Supply: Katalog C |
| Carpentry Tools | 8 g | U | Zimmermannswerkzeug | Supply: Katalog C |
| Tanning Tools | 5 g | U | Gerberwerkzeug | Supply: Katalog C |

## Containers (8 Zeilen)

Alle 8 ok (Preis, Supply, Gewicht): Backpack 3 g → Rucksack; Barrel 2 g → Fass; Basket 4 s → Korb; Bottle 1 g → Flasche; Bucket 5 c → Eimer; Chest 5 g → Truhe; Clay Jug 5 s → Tonkrug; Saddle Bag 6 g → Satteltasche.

## Medicine (7 Zeilen)

| Buch | Preis | Supply | Katalog | Status |
|---|---|---|---|---|
| Poison, Lethal (dose) | 2 g × potency | U | Gift, tödlich (Dosis) | ok (der Faktor „× potency" steht nicht im Katalog) |
| Poison, Paralyzing (dose) | 12 s × potency | U | Gift, lähmend (Dosis) | ok (siehe oben) |
| Poison, Sleeping (dose) | 6 s × potency | U | Gift, einschläfernd (Dosis) | ok (siehe oben) |
| Herbal Concoction (dose) | 1 g | U | Kräutersud (Dosis) | ok |
| Healing Potion (dose) | 50 g | R | Heiltrank (Dosis) | ok |
| Bandages (10) | 5 s | C | Bandagen | ok |
| Surgical Instruments | 15 g | U | Chirurgenbesteck | ok |

## Hunting & Fishing (4 Zeilen)

| Buch | Preis | Supply | Gewicht | Katalog | Status |
|---|---|---|---|---|---|
| Bear Trap | 3 g | U | 1 | **Falle/Schlinge, groß** | ok, aber **Name falsch übersetzt** (Bärenfalle) |
| Fishing Rod | 8 s | C | 1 | Angel | ok |
| Fishing Net | 2 g | C | 2 | Fischernetz | ok |
| Snare | 5 c | C | 1 | Schlinge | ok |

## Means of Travel (5 Zeilen)

Alle 5 ok: Canoe 6 g → Kanu; Cart 15 g → Karren; Rowing Boat 15 g → Ruderboot; Sailing Boat 40 g (U) → Segelboot; Wagon 30 g → Planwagen.

## Animals (9 Zeilen)

Alle 9 ok: Chicken 4 s → Huhn; Combat Trained Horse 400 g (R) → Kampfpferd; Cow 10 g (U) → Kuh; Donkey 12 g → Esel; Guard Dog 15 g → Wachhund; Homing Pigeon in Cage 2 g (U) → Brieftaube (im Käfig); Pig 2 g → Schwein; Riding Horse 60 g (U) → Reitpferd; Sheep 3 g → Schaf.

## Services (17 Zeilen)

Alle 17 stehen in `catalog_services` (nicht in `catalog_items`), Preise, Supply und Einheiten stimmen. Namen: Bath at an Inn → Bad im Gasthaus; Bodyguard → Leibwächter; Bowl of Stew → Schüssel Eintopf; Clothes Repair → Kleiderreparatur; Courier → Bote; Feast → Festmahl; Goblet of Wine → Becher Wein; Haircut → Haarschnitt; Healing → Heilung; Lodging (Separate Room / Dormitory / Luxury Suite) → Unterkunft im Gasthaus (Einzelzimmer / Schlafsaal / Luxussuite); Meal at an Inn → Mahlzeit im Gasthaus; Road Toll → Wegzoll; Stagecoach → Postkutsche; Tankard of Mead → Humpen Met; Teacher → Lehrer.

---

## Zusammenfassung der Unterschiede

### 1. Es fehlt im Katalog
- Blunt Object, Light / Heavy (Waffen)
- Greatsword
- Wooden Club, Small / Large
- Quiver of Arrows, Iron Head

### 2. Falsche oder irreführende Übersetzung
- **Keule** ist im Buch die **Mace** (Preis, Werte und Beschreibung „Streitkolben" passen dazu). Die echte „Wooden Club" fehlt deshalb.
- **Beil** = Handaxe, **Streitaxt** = Battleaxe. Die Gear-Texte der Professionen sagen „Handaxt" und „Schlachtaxt"; die zwei Wörter sind also Synonyme zu den Katalog-Namen und nicht fehlende Items.
- **Falle/Schlinge, groß** = Bear Trap (Bärenfalle). Dazu gibt es außerdem „Schlinge" (Snare); im Gear-Text der Jäger steht „Falle/Schlinge", im Buch aber nur „snare".
- **Feder** = Quill & Ink.
- **Köcher** ist nur der Holzspitzen-Köcher; der Name unterscheidet nicht.
- **Wurfhaken** = Grappling Hook; die Gear-Texte sagen „Enterhaken".

### 3. Falsche Werte
- Broadsword (Breitschwert): Durability im Buch 15, im Katalog 12.
- Map (Karte): 5 gold im Buch, 5 silver im Katalog.
- Harp (Harfe): Gewicht im Buch 2, im Katalog 1.
- Shield, Large (Schild, groß): Supply im Buch Common, im Katalog Uncommon.

### 4. Supply (Seltenheit) im Katalog zu niedrig (Katalog „gewöhnlich", Buch Uncommon oder Rare)
Uncommon im Buch: Langschwert, Krummsäbel, Streitaxt (Battleaxe), Dreschflegel, Kriegshammer klein, Dreizack, Langbogen, Leichte Armbrust, Offener Helm, Leier, Amulett, Buch, Feder, Zauberstab, Schmiedewerkzeug, Zimmermannswerkzeug, Gerberwerkzeug.
Rare im Buch: Lanze, Großhelm.

Auffällig: 16 dieser 19 Items haben eine ID ≤ 34 (die frühen Gear-Items); nur Krummsäbel, Streitaxt und Langbogen kamen später dazu. Vermutlich wurde bei den frühen Items der Default „gewöhnlich" nie mit dem Buch abgeglichen.

### 5. Im Katalog, aber nicht im Buch
- Zauberbuch (2 g), Amulett der Klarheit (5 g, selten), Wein (3 s): kein Gegenstück in den Buch-Tabellen (Wein ist nur als Dienstleistung „Becher Wein" vorhanden). Vermutlich Eigenentwürfe aus den Beispiel-Daten.

### 6. Nicht modelliert
- Gifte: „× potency" im Preis.
- Mastercrafted (Waffen-Modifikator ×10 Preis, STR −3, Durability +3).

---

## Effekt-Texte: Buch vs. `description_de`

Status: **ok** = Regelinhalt steht im Katalog. **fehlt** = Katalog hat nur Flavor-Text, der Regeleffekt aus dem Buch fehlt. **falsch** = Katalog sagt etwas anderes als das Buch. **teils** = Effekt halb vorhanden.

Waffen-Features, Rüstungs-Banes (als Flags in `catalog_item_armor`) und alle 17 Services stimmen. Die Gifte haben im Katalog sogar die Wirkung von S. 52/53 (Buch verweist nur).

### Clothes
| Item | Buch-Effekt | Status |
|---|---|---|
| Boots / Stiefel | schützen vor manchen Reise-Missgeschicken (S. 102) | ok |
| Cloak / Umhang | schützt vor manchen Reise-Missgeschicken (S. 102) | fehlt (nur „wetterfest") |
| Fine Garments / Feine Gewänder | Vorteil auf CHA-Fertigkeiten, wenn die SL es sinnvoll findet | fehlt |
| Fur / Pelzumhang | Vorteil auf Wildnisleben, um Kälte zu widerstehen (S. 54) | fehlt |
| Rags / Lumpen | Nachteil auf CHA-Fertigkeiten, wenn die SL es sinnvoll findet | fehlt |
| Simple Clothes / Einfache Kleidung | nötig, um einen Nachteil auf CHA-Fertigkeiten zu vermeiden | fehlt |

### Musical Instruments
Alle 6 ok (WP-Kosten bzw. Reichweite der Musiker-Fähigkeit stimmen).

### Trade Goods
| Item | Buch-Effekt | Status |
|---|---|---|
| Abacus / Abakus | Vorteil auf INT für mathematische Probleme | fehlt |
| Blanket / Wolldecke | nötig, um Nachteil auf Proben gegen Kälte zu vermeiden (S. 54) | fehlt |
| Chess Set / Schachspiel | Vergleichsprobe INT entscheidet, wer gewinnt | fehlt |
| Dice / Würfel | Zufall entscheidet, wer gewinnt | fehlt |
| Field Kitchen / Feldküche | Vorteil auf Wildnisleben beim Kochen (S. 103) | fehlt |
| Field Ration / Tagesration | pro Tag muss eine Ration gegessen werden, sonst Hungrig (S. 54) | fehlt |
| Grappling Hook / Wurfhaken | Seil sichern, Wurf mit Akrobatik bis STÄ m (×2 mit Nachteil) | ok |
| Lockpicks, Advanced / Feines Diebeswerkzeug | Vorteil auf Fingerfertigkeit beim Schlösserknacken | fehlt |
| Lockpicks, Simple / Dietriche | nötig, um Nachteil auf Fingerfertigkeit beim Schlösserknacken zu vermeiden | fehlt |
| Magnifying Glass / Lupe | Vorteil auf Verborgenes entdecken | fehlt |
| Map / Karte | nötig, um Nachteil auf Wildnisleben beim Wegführen zu vermeiden | fehlt |
| Marbles / Murmeln | als Aktion auf humanoiden Gegner in 10 m werfen, der muss nächste Runde eine Ausweichen-Probe (keine Aktion) bestehen, um sich zu bewegen | fehlt |
| Padlock / Vorhängeschloss | 20 Schadenspunkte, Rüstungswert 5 | ok |
| Perfume / Parfüm | Vorteil auf CHA-Fertigkeiten, wenn die SL es sinnvoll findet | fehlt |
| Playing Cards / Spielkarten | Vergleichsprobe Täuschen entscheidet, wer gewinnt | fehlt |
| Quiver, Iron Head | nötig für Bogen/Armbrust | Item fehlt |
| Quiver, Wooden Head / Köcher | nötig für Bogen/Armbrust; die Wirkung von Rüstung wird verdoppelt | fehlt |
| Rope, Hemp / Seil (Hanf) | Vorteil auf Akrobatik beim Klettern, Seil muss gesichert sein | fehlt |
| Rope, Silk / Seil (Seide) | wie Hanfseil | fehlt |
| Saddle / Sattel | nötig, um Nachteil beim Kämpfen vom Pferd zu vermeiden | fehlt |
| Sleeping Fur / Schlafpelz | nötig, um Nachteil auf Wildnisleben **beim Lagern** zu vermeiden | **falsch** (Katalog: „beim Wegführen", das ist der Text der Karte) |
| Spyglass / Fernrohr | Vorteil auf Wildnisleben beim Wegführen | ok |
| Tent, Small / Zelt klein | 2 Personen, Vorteil auf Wildnisleben beim Lagern | ok |
| Tent, Large / Zelt groß | 6 Personen, wie klein | ok |
| Whistle / Pfeife | auf 100 m hörbar | ok |

### Studies & Magic
| Item | Buch-Effekt | Status |
|---|---|---|
| Amulet / Amulett | Zauber-Fokus | ok |
| Book / Buch | Vorteil auf Fertigkeitsproben zu einem bestimmten Thema; Preis hängt vom Thema ab | fehlt („unbekannter Inhalt") |
| Brooch / Brosche | Zauber-Fokus | ok |
| Chalk / Kreide | Zauber-Fokus | teils („Zeichnen magischer Symbole", Fokus nicht genannt) |
| Grimoire | Preis hängt vom Inhalt ab, kann viel höher sein | teils |
| Hourglass / Sanduhr | Zauber-Fokus | fehlt („präzise Zeitmessung") |
| Notebook / Notizbuch | leer, kann als Grimoire dienen | teils (leer ja, Grimoire-Nutzung fehlt) |
| Orbuculum | Zauber-Fokus | fehlt (Katalog: „zum Studieren neuer Zauber") |
| Paper / Papier | zum Aufschreiben von Zaubern | fehlt |
| Parchment / Pergament | zum Aufschreiben von Zaubern | fehlt |
| Quill & Ink / Feder | zum Aufschreiben von Zaubern | fehlt |
| Reliquary / Reliquiar | Zauber-Fokus | fehlt |
| Wand / Zauberstab | Zauber-Fokus | ok |

### Light Sources
| Item | Buch-Effekt | Status |
|---|---|---|
| Flint & Tinder | nötig, um Fackeln, Kerzen oder Laternen anzuzünden **und ein Feuer zu machen** | teils (Feuer machen fehlt) |
| Lamp Oil / Lampenöl | 10 Dosen, jede hält Lampe/Laterne eine Schicht am Brennen | fehlt |
| Lantern / Laterne | 10 m Radius, brennt bis zu einer Schicht, W8 nach jedem Viertel, bei 1 aus, nachfüllen und neu anzünden (Aktion) | fehlt |
| Oil Lamp / Öllampe | 10 m, wie Laterne aber W6 | fehlt |
| Tallow Candle / Talgkerze | 4 m, W4 nach jedem Viertel oder wenn der Träger angreift/angegriffen wird | fehlt |
| Torch / Fackel | 10 m, W6 nach jedem Viertel oder wenn als Waffe benutzt | fehlt |

### Tools
| Item | Buch-Effekt | Status |
|---|---|---|
| Crowbar / Brecheisen | 2W6 Schaden gegen Tür/Wand, ohne Risiko, selbst beschädigt zu werden, trifft automatisch | fehlt |
| Hammer | 2W4, sonst wie oben | fehlt |
| Needle & Thread | flickt Kleidung mit einer Handwerk-Probe | teils (Probe fehlt) |
| Pickaxe / Spitzhacke | 2W8, sonst wie oben | fehlt |
| Saw / Säge | durchtrennt Metall oder Holz in einem Viertel | teils („in einem Viertel" fehlt) |
| Shovel / Schaufel | halbiert die Grabzeit | fehlt |
| Sledgehammer / Vorschlaghammer | 2W10, sonst wie oben | fehlt |
| Blacksmithing / Carpentry / Tanning Tools | für Handwerk-Proben (S. 34) | fehlt (nur Flavor; Zimmermann: „Säge, Beil, Maßband" ist erfunden) |

### Containers (alle 8 fehlen)
| Item | Buch-Effekt |
|---|---|
| Backpack / Rucksack | Tragkraft +2, nur ein Rucksack pro Person |
| Barrel / Fass | fasst 15 Gewichtseinheiten, hält 10 Schaden aus, Rüstungswert 3 |
| Basket / Korb | fasst 10 GE |
| Bottle / Flasche | 1 Einheit Flüssigkeit |
| Bucket / Eimer | bis zu 5 Einheiten Flüssigkeit |
| Chest / Truhe | fasst 20 GE, hält 25 Schaden aus, Rüstungswert 5 |
| Clay Jug / Tonkrug | 1 Einheit Flüssigkeit |
| Saddle Bag / Satteltasche | Tragkraft eines Tiers +2, höchstens zwei Satteltaschen pro Tier |

### Medicine
| Item | Buch-Effekt | Status |
|---|---|---|
| Poison, Lethal / Paralyzing / Sleeping | siehe S. 52/53 | ok (Katalog hat die Wirkung ausgeschrieben) |
| Herbal Concoction / Kräutersud | Vorteil auf Heilkunde, um Krankheit zu widerstehen (S. 53) | teils („gegen Krankheiten", Vorteil fehlt) |
| Healing Potion / Heiltrank | heilt sofort 2W6 TP; stärkere Tränke heilen mehr und sind teurer | fehlt (2W6 fehlt) |
| Bandages / Bandagen | nötig, um Nachteil auf Heilkunde beim Lebenretten zu vermeiden; jeder Versuch verbraucht eine Bandage; Packung = 10 | fehlt |
| Surgical Instruments / Chirurgenbesteck | Vorteil auf Heilkunde beim Lebenretten | teils („schwierige Heilkunde-Proben") |

### Hunting & Fishing
| Item | Buch-Effekt | Status |
|---|---|---|
| Bear Trap / Falle/Schlinge, groß | für die Jagd (S. 103) | teils (nur Flavor, Name falsch) |
| Fishing Rod / Angel | beim Angeln W4 Rationen (S. 103) | fehlt |
| Fishing Net / Fischernetz | beim Fischen W6 Rationen (S. 103) | fehlt |
| Snare / Schlinge | für die Jagd, nur einmal verwendbar | ok |

### Means of Travel / Animals
Siehe die vorige Tabelle in diesem Abschnitt, unverändert:

| Item | Buch-Effekt | Status |
|---|---|---|
| Canoe / Kanu | 2 Personen, 10 GE | fehlt |
| Cart / Karren | 1 Pferd oder Esel, 2 Personen, 50 GE | ok |
| Rowing Boat / Ruderboot | 4 Personen, 50 GE | fehlt |
| Sailing Boat / Segelboot | 6 Personen, 100 GE | fehlt („Küstenfahrten" erfunden) |
| Wagon / Planwagen | 2 Pferde/Esel, 4 Personen, 100 GE | teils (Zugtiere ja, Kapazität fehlt) |
| Chicken / Huhn | 1 Ration geschlachtet, Fleisch garen (S. 103) | teils |
| Combat Trained Horse / Kampfpferd | 1 Reiter + 10 GE oder 2 Reiter | fehlt |
| Cow / Kuh | W4 Rationen (Milch) pro Tag, 2W10 Rationen geschlachtet | teils (Würfel fehlen) |
| Donkey / Esel | trägt 10 GE, nicht reitbar | fehlt |
| Guard Dog / Wachhund | beschützt Besitzer, Werte S. 99 | fehlt |
| Homing Pigeon / Brieftaube | fliegt zum Schlag zurück | ok |
| Pig / Schwein | 2W6 Rationen geschlachtet | teils |
| Riding Horse / Reitpferd | 1 Reiter + 10 GE oder 2 Reiter | fehlt |
| Sheep / Schaf | 2W4 Rationen geschlachtet | teils („Wolle" erfunden) |

### Zusammenfassung
- **ok:** 6 Instrumente, Grappling Hook, Padlock, Spyglass, 2 Zelte, Whistle, Amulett, Brosche, Zauberstab, Snare, Karren, Brieftaube, Boots, 3 Gifte (+ Services, Waffen-Features, Rüstungs-Banes).
- **falsch:** Schlafpelz (Text der Karte).
- **Rest** hat nur Flavor oder einen Teil des Effekts. Betroffen sind praktisch alle Items außer den ok-Items oben, besonders Light Sources, Tools, Containers, Clothes, Trade Goods und Tiere.
- Die Ursache sieht systematisch aus: wo das Buch einen Regeleffekt hat (Vorteil/Nachteil, Würfel, Kapazität), wurde bei der Übertragung ein freier Flavor-Satz geschrieben. Wo das Buch „Can be used as a focus for spells" schreibt, steht ein freier Satz über den Gegenstand.

### Umsetzung (Effekt-Texte)

84 Items haben jetzt den Effekt-Text wörtlich aus dem Buch (`database/02_catalog.sql` und `database/migrations/0007_item_effect_texts.sql`, per `UPDATE ... WHERE name_de`).

- Begriffe: Boon/Bane = Vorteil/Nachteil, Bushcraft = Wildnisleben, Sleight of Hand = Fingerfertigkeit, Spot Hidden = Entdecken, Crafting = Handwerk, Healing = Heilkunde, Stretch = Viertel, Shift = Tagesabschnitt, weight units = Gewichtseinheiten.
- Seitenverweise des Buchs (S. 34, 54, 102, 103) sind weggelassen, weil die App diese Seiten nicht hat.
- Rüstungen: Banes stehen jetzt auch als Text (zusätzlich zu den Flags in `catalog_item_armor`). Leder (Buch: „—") ist unverändert.
- Grimoire behält den Satz zu neuen Magiern und bekommt den Preis-Satz des Buchs dazu. Bandagen: „Eine Packung enthält 10 Bandagen" (aus „Bandages (10)").
- Wachhund: „Werte: siehe Hund im Bestiarium" statt „Seite 99".
- Unverändert: Instrumente, Wurfhaken, Vorhängeschloss, Fernrohr, Zelte, Pfeife, Amulett, Brosche, Zauberstab, Brieftaube, Gifte, Waffen, Leder, Zauberbuch, Wein, Amulett der Klarheit.
- Noch offen: fehlende Items (Quiver Iron Head, Blunt Objects, Greatsword, Wooden Clubs), falsche Namen, Werte (Broadsword, Karte, Harfe, Schild groß), Supply und die Gear-Verknüpfung.

### Umsetzung (Namen, Werte, fehlende Items)

`database/migrations/0008_item_names_values_missing.sql` und `database/02_catalog.sql` (gleicher Stand, per Dump-Vergleich geprüft).

- **Umbenannt:** Keule → **Streitkolben** (Mace), Feder → **Feder & Tinte**, Falle/Schlinge, groß → **Bärenfalle**, Köcher → **Köcher, Holzspitzen**.
- **Werte:** Breitschwert Durability 15, Karte 5 Gold, Harfe Gewicht 2, Schild, groß Supply gewöhnlich.
- **Supply:** 17 Items auf ungewöhnlich (Langschwert, Krummsäbel, Streitaxt, Dreschflegel, Kriegshammer klein, Dreizack, Langbogen, Leichte Armbrust, Offener Helm, Leier, Amulett, Buch, Feder & Tinte, Zauberstab, Schmiede-/Zimmermanns-/Gerberwerkzeug), 2 auf selten (Lanze, Großhelm).
- **Neu:** Stumpfer Gegenstand (leicht / schwer), Zweihandschwert (Greatsword), Holzkeule (klein / groß), Köcher, Eisenspitzen. Die deutschen Namen sind mein Vorschlag, das Buch liefert sie nicht; „Zweihandschwert" folgt dem vorhandenen „Zweihandaxt".
- **Unverändert:** Wurfhaken (so heißt er auch im deutschen Schnellstarter, die Gear-Texte der Professionen müssen auf „Wurfhaken" statt „Enterhaken" angepasst werden), Handaxe = Beil, Battleaxe = Streitaxt.
- Die neuen Items bekommen in der Migration ihre IDs per AUTO_INCREMENT (die SL kann im Katalog-Editor schon eigene angelegt haben); `abort-if` bricht ab, wenn einer der neuen Namen schon existiert. In `02_catalog.sql` sind es die IDs 137–142.
- Charakter-Inventare und Beispielcharaktere speichern ihre Items als Kopie mit eigenem Namen, die Umbenennung ändert dort nichts.
