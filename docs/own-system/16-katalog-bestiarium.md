# Katalog: Bestiarium & NPCs

Voll ausgearbeiteter Entwurf nach dem Statblock-Format aus [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md): 1 Move (Fodder), 2 Moves (Standard), 3 Moves (Boss/Elite). 50 Kreaturen in 12 Familien, mit HP/AC/Angriffsbonus, individuellem Schaden pro Move und einer Kurzflavor-Zeile pro Eintrag.

## Statblock-Mechanik

- **HP, AC, Angriffsbonus und Schaden werden zuerst individuell pro Kreatur festgelegt** (nach Move-Tier-Richtwerten, siehe [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md)) — **SI ist danach eine abgeleitete Kennzahl**, berechnet aus genau diesen Werten (Formel siehe 09-bestiary-und-npcs.md), nicht umgekehrt. Deshalb können zwei Kreaturen mit identischer HP unterschiedliche SI haben (z. B. Zombie niedriger als Skelett-Krieger trotz gleicher HP, weil schwächer im Treffen/Zuschlagen).
- **Schaden pro Move ist individuell**, nicht pauschal nach Move-Tier gewürfelt — ein Goblin-Dolchstich soll sich nicht wie ein Oger-Keulenschlag anfühlen, auch wenn beide "nur" ein Fodder- bzw. Standard-Move sind. Move-Tier gibt nur eine **grobe Range** vor, die tatsächliche Waffe/Physis der Kreatur entscheidet den konkreten Wert innerhalb dieser Range:
  - Fodder-Moves: **1W4–1W6** (kleine Waffe/schwacher Biss vs. bereits kräftiger Nahkampftreffer)
  - Standard-Moves: **1W6–1W10** (je nachdem ob Präzision oder rohe Wucht)
  - Boss-Moves: **1W8–1W12**
  - Ultimate-Moves: **2W8–4W10**, je nach Wucht/Reichweite des Effekts
- **Reine Utility-Moves** (Buffs, Debuffs, Beschwörung, Fluchtmanöver o. Ä.) haben keinen Schadenswert.
- **Ultimate-Moves sind 1×/Kampf** nutzbar. Alle anderen Moves sind frei pro Zug wählbar, keine Abklingzeit.

## Goblinoide

- **Goblin-Plünderer** (1 Move, SI 1, 3 HP, AC 10, Angriff +2) — *Feige Einzelgänger, aber gefährlich im Rudel.* Move: *Dolchstich* (1W4)
- **Goblin-Bogenschütze** (1 Move, SI 1, 3 HP, AC 10, Angriff +2) — *Schießt aus der Deckung, flieht bei Sichtkontakt.* Move: *Pfeilhagel* (1W6, Fernangriff)
- **Goblin-Schamane** (2 Moves, SI 3, 12 HP, AC 12, Angriff +4) — *Hält sich hinten, lenkt den Trupp mit kleiner Magie.* Move 1: *Stabschlag* (1W4); Move 2: *Rankengriff* (Utility — verlangsamt/hält fest, siehe [14-katalog-zauber.md](14-katalog-zauber.md))
- **Hobgoblin-Kriegshauptmann** (2 Moves, SI 6, 18 HP, AC 13, Angriff +5) — *Diszipliniert im Gegensatz zum wilden Goblin-Mob, führt tatsächlich Formationen.* Move 1: *Klingenhieb* (1W8); Move 2: *Kommandoruf* (Utility — Vorteil für nahe Goblinoide für eine Runde)
- **Goblin-König** (3 Moves, SI 8, 27 HP, AC 14, Angriff +6) — *Feige, aber gerissen — kämpft nur, wenn er gewinnen kann.* Move 1: *Zepterschlag* (1W8 — kein Kraftprotz, eher gerissen als stark); Move 2: *Leibwächter rufen* (Utility — beschwört 2 Goblin-Plünderer); Move 3: *Feiger Rückzug* (Utility — teleportiert sich kurz weg)

## Orks

- **Ork-Grunzer** (1 Move, SI 3, 6 HP, AC 11, Angriff +3) — *Unerfahren, aber körperlich schon beeindruckend.* Move: *Keulenschlag* (1W6)
- **Ork-Krieger** (2 Moves, SI 4, 12 HP, AC 12, Angriff +4) — *Rückgrat jeder Kriegerbande.* Move 1: *Axthieb* (1W8); Move 2: *Wutschrei* (Utility — Vorteil für Ork und nahe Verbündete für eine Runde)
- **Ork-Bogenschütze** (2 Moves, SI 3, 12 HP, AC 12, Angriff +4) — *Selten, aber gefürchtet — Orks bevorzugen den Nahkampf.* Move 1: *Pfeilschuss* (1W6, Fernkampf ist nicht ihre Stärke); Move 2: *Beinschuss* (Utility — verlangsamt das Ziel)
- **Ork-Berserker** (2 Moves, SI 5, 15 HP, AC 11, Angriff +5) — *Kämpft, bis er umfällt, buchstäblich — wirft jede Deckung über Bord für rohe Wucht.* Move 1: *Wilder Hieb* (1W10, riskant und roh); Move 2: *Schmerzresistenz* (Utility — ignoriert einen Teil des nächsten Schadens)
- **Ork-Hordenführer** (3 Moves, SI 10, 30 HP, AC 14, Angriff +7) — *Hat sich an die Spitze durchgeprügelt und hält sie mit Furcht.* Move 1: *Axthieb* (1W10); Move 2: *Kriegsschrei* (Utility — Wutschrei-Effekt für alle Orks in der Nähe); Move 3: *Blutrausch* (2W10 — zwei Angriffe in einer Runde)

## Untote

- **Skelett-Krieger** (1 Move, SI 3, 6 HP, AC 11, Angriff +3) — *Kein Schmerzempfinden, keine Taktik, nur Befehl.* Move: *Knochenklinge* (1W6)
- **Zombie** (1 Move, SI 2, 6 HP, AC 10, Angriff +2) — *Langsam und schwach im Einzeltreffer, aber ignoriert Verletzungs-Mali, die einen Lebenden längst gebremst hätten — die Zahl macht's, nicht der einzelne Biss.* Move: *Griff* (1W4)
- **Geist/Wiedergänger** (2 Moves, SI 5, 15 HP, AC 13, Angriff +4) — *Halb hier, halb dort — schwer zu fassen, aber auch kein Kraftpaket.* Move 1: *Kalter Griff* (1W6); Move 2: *Durchscheinen* (Utility — kurzzeitig immun gegen physischen Schaden)
- **Nekromant** (3 Moves, SI 8, 27 HP, AC 13, Angriff +6) — *Sammelt Diener, kämpft selbst nur ungern in vorderster Reihe.* Move 1: *Schattengriff* (1W6, Zauberer, kein Kämpfer); Move 2: *Diener erheben* (Utility — beschwört 1–2 Skelett-Krieger); Move 3: *Furchtwelle* (Utility — mehrere Gegner werden Frightened)
- **Lich** (3 Moves, SI 14, 39 HP, AC 16, Angriff +8) — *Uralt, geduldig, hat den Tod längst hinter sich gelassen.* Move 1: *Schattengriff* (1W8, deutlich mächtiger als der Nekromant); Move 2: *Todesfluch* (Utility — Fluch der Schwäche, großflächig); Move 3: *Seelenbindung* (Utility — bindet die Seele eines besiegten Gegners, Konsequenz nach GM-Ermessen)

## Wildtiere

- **Wolf** (2 Moves, SI 2, 9 HP, AC 12, Angriff +4, meist im Rudel) — *Jagt nie allein, wenn er es vermeiden kann.* Move 1: *Biss* (1W6); Move 2: *Rudel-Hetzen* (Utility — Vorteil für weitere Wölfe gegen ein bereits gebissenes Ziel)
- **Hund (Begleittier)** (1 Move, SI 1, 6 HP, AC 11, Angriff +3) — *Kein Kampfmonster, ein treuer Gefährte — schwächer als sein wilder Vetter, dem Wolf.* Move: *Biss* (1W4). Der Standard-Statblock für einen zahmen, käuflichen Begleiter (siehe [07-ausruestung-und-oekonomie.md](07-ausruestung-und-oekonomie.md)) — für andere kleine Begleittiere (Katze, Frettchen, Falke o. Ä.) einfach umbenennen, Werte bleiben gleich. Rein mundan, keine Magie nötig.
- **Riesenspinne** (2 Moves, SI 4, 15 HP, AC 12, Angriff +4) — *Lauert in Netzen, meidet offenen Kampf — das Gift ist die eigentliche Gefahr, nicht der Biss selbst.* Move 1: *Biss* (1W6, vergiftet); Move 2: *Netz* (Utility — Restrained)
- **Bär** (2 Moves, SI 6, 18 HP, AC 12, Angriff +5) — *Territorial, nicht grundsätzlich aggressiv — aber wehe, man kommt zu nah, dann trifft die Tatze richtig hart.* Move 1: *Tatzenhieb* (1W10); Move 2: *Umklammern* (Utility — Grapple-Effekt)
- **Riesenschlange** (2 Moves, SI 4, 15 HP, AC 12, Angriff +4) — *Geduldig, fast unsichtbar bis zum Angriff — auch hier ist die Umklammerung das eigentliche Problem, nicht der Biss.* Move 1: *Biss* (1W6, vergiftet); Move 2: *Umschlingen* (Utility — Restrained)
- **Alpha-Raubtier** (3 Moves, SI 7, 24 HP, AC 13, Angriff +6) — *Führt ein Rudel, das ohne es viel schwächer wäre.* Move 1: *Biss* (1W8); Move 2: *Rudel-Hetzen (verstärkt)* (Utility); Move 3: *Todesstoß* (2W8 — Bonus gegen bereits verwundete Ziele)

## Riesen & Oger-Verwandte

- **Oger** (2 Moves, SI 7, 21 HP, AC 11, Angriff +5) — *Dumm, brutal stark, leicht abzulenken — auch als "Standard-Gegner" schlägt er deutlich härter zu als ein Mensch.* Move 1: *Keulenschlag* (1W10); Move 2: *Wurf* (1W8 — packt und schleudert ein Ziel, weniger präzise als der direkte Schlag)
- **Oger-Champion** (3 Moves, SI 9, 27 HP, AC 14, Angriff +6) — *Der Oger, der die anderen anführt, weil er zufällig noch dümmer und stärker ist.* Move 1: *Keulenschlag* (1W10); Move 2: *Wurf* (1W10); Move 3: *Wutrausch* (2W12 — zwei brachiale Angriffe in einer Runde)
- **Höhlentroll** (3 Moves, SI 11, 33 HP, AC 14, Angriff +7) — *Regeneriert fast alles — außer Feuer und Säure.* Move 1: *Schlag* (1W10); Move 2: *Regeneration* (Utility — heilt sich selbst deutlich, außer bei Feuer-/Säureschaden); Move 3: *Felsbrocken werfen* (2W8, Fernangriff)
- **Frostriese** (3 Moves, SI 13, 36 HP, AC 15, Angriff +7) — *Kalt, langsam, erbarmungslos, wenn er einen erst erwischt hat — der größte reine Kraftprotz der Riesenfamilie.* Move 1: *Eisfaust* (1W12); Move 2: *Frostatem* (1W8 + Verlangsamung); Move 3: *Lawinenwurf* (2W12, großer Flächenschaden)

## Drachen

- **Drachenwelpe** (1 Move, SI 4, 9 HP, AC 11, Angriff +3) — *Noch kein Atem, aber schon zäh und schnell.* Move: *Bisshieb* (1W6)
- **Junger Drache** (3 Moves, SI 10, 30 HP, AC 14, Angriff +7) — *Selbstbewusst, aber noch nicht in seiner vollen Kraft.* Move 1: *Klauen & Biss* (1W10); Move 2: *Schwanzschlag* (1W8 — wirft mehrere Ziele im Nahbereich zu Boden, mehr Wucht als reiner Schaden); Move 3: *Atemwaffe* (3W10, großer Flächenschaden, 1×/Kampf)
- **Ausgewachsener Drache** (3 Moves, SI 17, 48 HP, AC 18, Angriff +9) — *Legendär aus gutem Grund — ein einzelner sollte eine ganze Gruppe fordern.* Move 1: *Klauen & Biss* (1W12); Move 2: *Flügelsturm* (1W10 — wirft mehrere Ziele um); Move 3: *Großer Atem* (4W10, sehr großer Flächenschaden, größere Reichweite, 1×/Kampf)

## Banditen & finstere Kulte

- **Banditen-Lakai** (1 Move, SI 2, 6 HP, AC 11, Angriff +2) — *Dabei fürs Geld, nicht für die Sache.* Move: *Klingenhieb* (1W6)
- **Banditenanführer** (2 Moves, SI 5, 15 HP, AC 12, Angriff +4) — *Charismatisch genug, um eine Bande zusammenzuhalten.* Move 1: *Klingenhieb* (1W8); Move 2: *Fieser Trick* (Utility — Nachteil auf die nächste Probe/den nächsten Angriff des Ziels)
- **Assassine** (2 Moves, SI 6, 18 HP, AC 13, Angriff +5) — *Tötet lieber leise, bevor jemand überhaupt merkt, dass der Kampf begonnen hat.* Move 1: *Heimtückischer Stich* (1W8, bei Überraschung 2W8); Move 2: *Rauchflucht* (Utility)
- **Kultist** (2 Moves, SI 4, 15 HP, AC 12, Angriff +4) — *Überzeugter Fanatiker, kein Söldner.* Move 1: *Ritualdolch* (1W6); Move 2: *Dunkles Gebet* (Utility — Furchtwelle-artiger Effekt)
- **Kult-Hohepriester** (3 Moves, SI 8, 27 HP, AC 13, Angriff +6) — *Bereit, seine eigenen Leute zu opfern, wenn es seinem Ziel dient.* Move 1: *Schattengriff* (1W8); Move 2: *Diener beschwören* (Utility — kleiner Dämon/Geist); Move 3: *Blutopfer* (Utility — heilt sich massiv auf Kosten eines eigenen Kultisten)

## Wachen & Militär

- **Wachrekrut** (1 Move, SI 2, 6 HP, AC 10, Angriff +3) — *Frisch ausgebildet, uneinheitlich mutig.* Move: *Schwerthieb* (1W6)
- **Wachoffizier/Soldat** (2 Moves, SI 4, 12 HP, AC 12, Angriff +4) — *Rückgrat der Stadtwache/des Heeres.* Move 1: *Schwerthieb* (1W8); Move 2: *Schildwall* (Utility — reduziert eingehenden Schaden für sich und Verbündete für eine Runde)
- **Elitegardist** (2 Moves, SI 7, 18 HP, AC 13, Angriff +5) — *Handverlesen, spürbar besser trainiert als die Standardwache — Präzision statt roher Kraft.* Move 1: *Präziser Hieb* (1W6+2); Move 2: *Parade* (Utility — blockt den nächsten Angriff komplett)
- **Kriegshauptmann** (3 Moves, SI 9, 27 HP, AC 14, Angriff +7) — *Führt aus der ersten Reihe, nicht vom Hügel aus.* Move 1: *Klingenhieb* (1W10); Move 2: *Kommandoruf* (Utility); Move 3: *Duellant* (1W10, gegen das herausgeforderte Ziel zusätzlich +1W6)

## Kleinkreaturen

- **Riesenratte** (1 Move, SI 1, 3 HP, AC 10, Angriff +2) — *Einzeln harmlos, im Schwarm ein Problem.* Move: *Biss* (1W4)
- **Riesenspinnling** (1 Move, SI 1, 3 HP, AC 10, Angriff +2) — *Klein, schnell, nervig statt gefährlich.* Move: *Biss* (1W4, schwaches Gift)
- **Aasgeier-Schwarm** (1 Move, SI 2, 3 HP, AC 11, Angriff +2) — *Kommt erst, wenn schon jemand blutet, dafür mehrere kleine Treffer statt einem großen — schwer zu treffen im wirbelnden Schwarm.* Move: *Hackangriff* (2W4)
- **Wegelagerer-Kobold** (1 Move, SI 1, 3 HP, AC 10, Angriff +1) — *Zu schwach zum Kämpfen, dafür gerissen genug für eine Falle.* Move: *Fallenauslösung* (Utility — kein direkter Angriff)

## Elementare

- **Kleiner Feuer-Elementar** (2 Moves, SI 5, 15 HP, AC 12, Angriff +4) — *Instabil — wer ihn tötet, sollte Abstand halten.* Move 1: *Flammenberührung* (1W8); Move 2: *Selbstentzündung* (1W6, Flächenschaden beim eigenen Tod)
- **Kleiner Erd-Elementar** (2 Moves, SI 6, 18 HP, AC 13, Angriff +4) — *Langsam, fast unbeeindruckbar — trifft dafür wie ein Fels, und der Steinkörper hält selbst einiges aus.* Move 1: *Steinfaust* (1W10); Move 2: *Erstarrung* (Utility — nahezu unverwundbar, aber handlungsunfähig für eine Runde)
- **Großer Sturm-Elementar** (3 Moves, SI 11, 33 HP, AC 14, Angriff +7) — *Selten beschworen, extrem zerstörerisch, wenn es passiert.* Move 1: *Windschlag* (1W8); Move 2: *Blitzschlag* (1W10); Move 3: *Wirbelsturm* (2W10, großer Flächenschaden + wirft Ziele um)

## Fabelwesen

- **Kobold** (Feenwesen, nicht Goblin) (1 Move, SI 1, 3 HP, AC 11, Angriff +1) — *Boshafter Streich statt echter Gefahr.* Move: *Streich* (Utility — verwirrender Debuff, kein Schaden)
- **Riesenadler** (1 Move, SI 4, 9 HP, AC 11, Angriff +3) — *Stolz, greift nur an, wenn provoziert.* Move: *Sturzflug-Angriff* (1W6)
- **Harpyie** (2 Moves, SI 4, 15 HP, AC 12, Angriff +4) — *Nistet hoch, lockt mit Gesang, tötet aus der Luft.* Move 1: *Krallenhieb* (1W6); Move 2: *Kreischen* (Utility — Frightened in kleinem Radius)
- **Werwolf** (2 Moves, SI 8, 21 HP, AC 13, Angriff +5) — *Tagsüber unauffällig, nachts ein anderes Problem — reißt statt zu kratzen.* Move 1: *Kralle & Biss* (1W10); Move 2: *Regeneration* (Utility — leicht, außer bei Silber)
- **Vampir** (3 Moves, SI 10, 30 HP, AC 15, Angriff +7) — *Charmant, geduldig, tödlich — spielt lieber mit der Beute.* Move 1: *Biss* (1W8, heilt den Vampir um den verursachten Schaden); Move 2: *Nebelform* (Utility — kurzzeitig fast unverwundbar, kein Angriff möglich); Move 3: *Herrschaft* (Utility — versucht ein Ziel mental zu kontrollieren, Willenskraft-Probe zum Widerstehen)

## Konstrukte

- **Wachgolem** (2 Moves, SI 7, 21 HP, AC 13, Angriff +4) — *Kennt keine Angst, weil er nichts empfindet, trifft mit mechanischer Wucht.* Move 1: *Schlag* (1W10); Move 2: *Unbeirrbar* (Utility — immun gegen Frightened/Furcht-Effekte)
- **Großer Kampfgolem** (3 Moves, SI 13, 36 HP, AC 15, Angriff +6) — *Gebaut, um zu halten, nicht um zu gewinnen — hält aber sehr, sehr lange.* Move 1: *Doppelschlag* (2W6); Move 2: *Bodenstampfer* (1W10, Flächenschaden + Umwerfen); Move 3: *Selbstreparatur* (Utility — heilt sich signifikant)

## Offen

- PC-HP-Baseline ist final (HP = 10 + CON-Mod × 3, siehe [01-charakter.md](01-charakter.md)) und per Simulation gegen die HP-Werte hier abgeglichen (siehe [03-kampf.md](03-kampf.md)). Alle 50 Kreaturen haben AC/Angriffsbonus nach den Tier-Richtwerten aus [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md), mit kleinen individuellen Abweichungen nach Flavor.
- **SI ist jetzt aus HP/AC/Angriff/Schaden berechnet, nicht mehr die Quelle von HP** (Formel siehe [09-bestiary-und-npcs.md](09-bestiary-und-npcs.md)) — 22 der 50 Kreaturen haben dadurch einen leicht angepassten SI-Wert bekommen (±1-2), z. B. Nekromant/Kult-Hohepriester niedriger (schwacher Nahkämpfer trotz hoher HP), Zombie niedriger als Skelett-Krieger (gleiche HP, aber schwächer im Treffen/Zuschlagen), Elitegardist/Werwolf/Ausgewachsener Drache höher (überdurchschnittlich für ihre HP). HP-Werte selbst wurden dabei nicht verändert.
- Die Move-Tier-Ranges oben (z. B. "Fodder: 1W4–1W6") sind eine Orientierung für neue Kreaturen, keine feste Formel — Einzelfälle dürfen bewusst darüber/darunter liegen, wenn es zur Kreatur passt
- Weitere Familien/Kreaturen nach Bedarf, sobald die Kampagne sie verlangt
