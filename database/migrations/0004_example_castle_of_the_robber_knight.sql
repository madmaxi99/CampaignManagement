-- skip-if: SELECT COUNT(*) FROM campaigns WHERE id = 4 AND name_de = 'Die Burg des Raubritters'
-- abort-if: SELECT COUNT(*) FROM campaigns WHERE id = 4
-- abort-if: SELECT COUNT(*) FROM campaign_chapters WHERE id = 4
-- abort-if: SELECT COUNT(*) FROM campaign_places WHERE id BETWEEN 25 AND 31
-- abort-if: SELECT COUNT(*) FROM campaign_items WHERE id BETWEEN 4 AND 8
-- abort-if: SELECT COUNT(*) FROM campaign_npcs WHERE id BETWEEN 12 AND 16
-- Beispielkampagne "Die Burg des Raubritters" (Karte: backend/public/images/campaigns/4/map.jpg).


-- ============================================================
-- Kampagne 4: Die Burg des Raubritters (Grundregelwerk, Kapitel 8)
-- ============================================================

INSERT INTO campaigns (id, name_de, teaser_de, background_de, is_default) VALUES
    (4, 'Die Burg des Raubritters', 'Eine Burgruine, ein kopfloser Raubritter und eine Bande listiger Goblins: ein einfacher Einstieg in Dragonbane für 3–5 Charaktere.', 'Dieses Abenteuer ist eine einfache Einführung in Dragonbane. Wie alle Abenteuer hat es keine vorgegebene Handlung, die Spielenden erkunden einen interessanten Ort. Es gibt also kein festgelegtes Ende für Die Burg des Raubritters.

Zeige den Spielenden die Karte der Burg und lies ihnen den Text darüber vor. Zeichne den Umriss der Burg anhand der Karte und fülle ihn aus, während die Charaktere die verschiedenen Räume erkunden. Viel Glück!

Die Lage

Vor langer Zeit verwüstete ein brutaler Raubritter die Gegend, in der dieses Abenteuer spielt. Sein Name war Rothgar Wolfsbane, und er bekämpfte alle, die ihm in den Weg kamen: Menschen, Zwerge, Elfen und Orks. Der Klang seines gefürchteten Kriegshorns ließ das Blut seiner Feinde gefrieren.

So verhasst war Wolfsbane, dass die Alten Völker, die seit Ewigkeiten verfeindet gewesen waren, ihre Fehden beiseitelegten und sich gegen ihren gemeinsamen Feind vereinten. Schließlich belagerte eine Horde Orks die Burg, in der sich Wolfsbane verschanzt hatte. Die Schlacht um die Burg war blutig, und viele Orks fielen unter der Klinge des Raubritters, doch am Ende überwältigten sie ihn: Rothgar Wolfsbane wurde von einem Ork-Krummsäbel der Kopf abgeschlagen, während seine Burg in Flammen stand. Die Schreckensherrschaft des Raubritters war vorbei.

Viele Jahre später ist der Lärm der Schlacht verhallt, aber die Ruinen der Burg stehen noch. In mondhellen Nächten haben vorbeiziehende Reisende den Klang von Wolfsbanes Kriegshorn gehört und den kopflosen Raubritter als Geistererscheinung gesehen. Gerüchte erzählen von verschwundenen Karawanen und Abenteurern in der Nähe der Ruine, und heutzutage machen die meisten Leute einen Bogen um den Hügel.

Es stimmt, dass der Raubritter wieder umgeht. Aber niemand weiß, dass eine Bande Goblin-Banditen unter der Führung des gerissenen Jaldo den kopflosen Wiedergänger beschwört, um Leute zu verscheuchen. Sie haben die Burg zu ihrem Zuhause gemacht, und von dort aus rauben sie die Umgebung aus.

DM-Tipp – Zufällige Ereignisse: Für jedes volle Viertel, das die Charaktere in der Burg verbringen, etwa beim Durchsuchen eines Raums oder bei einer kurzen Rast, kannst du am Tisch einen W6 auf der Tabelle „Zufällige Ereignisse: Burg des Raubritters“ würfeln (Tabelle im Tab „Tabellen“). Wollen die Charaktere die Burg für mindestens einen Tagesabschnitt verlassen, würfle auf der Tabelle „Den Abenteuerort verlassen“ (siehe Regelwerk, Abenteuer).

Schatz: Wo „Schatz“ steht, legst du den Fund selbst fest: Münzen, Schmuck oder ein Gegenstand, der zur Gegend passt.', 1);

INSERT INTO campaign_chapters (id, campaign_id, label, position, title_de, notes_de) VALUES
    (4, 4, '1', 10, 'Die Burg des Raubritters', NULL);

INSERT INTO campaign_places (id, campaign_id, parent_id, chapter_id, position, number_label, name_de, description_de, dm_text_de, image_path, encounter_table_id) VALUES
    (25, 4, NULL, 4, 0, NULL, 'Die Burg des Raubritters', NULL, NULL, 'images/campaigns/4/map.jpg', NULL),
    (26, 4, 25, 4, 1, '1', 'Alte Straße', 'Kaum erkennbar unter Gestrüpp und Unkraut windet sich eine alte Pflasterstraße den Hügel hinauf. An ihrem Ende ragt eine dunkle, verfallene Burgruine auf. Irgendwo in der Nähe krächzt ein Rabe.', '✦ Das Gestrüpp: Die Straße ist teilweise zugewachsen und seit langem nicht benutzt. Die Goblins bevorzugen einen schmalen Pfad, der parallel zur Straße verläuft. Die Charaktere entdecken ihn, wenn sie die Gegend untersuchen.
✦ Der Helm: Auf halbem Weg den Hügel hinauf liegt ein alter Helm aus verkohltem Metall, halb im Unterholz verborgen. Trotz seines Alters ist er voll funktionsfähig (Rüstungswert +1), gibt aber einen Nachteil auf Wahrnehmung-Proben. Der Helm sieht mit seinen scharfen Stacheln an den Seiten bedrohlich aus. Lass die Charaktere eine Mythen & Legenden-Probe ablegen: Bei Erfolg erkennen sie, dass er von Orks geschmiedet wurde. Wer ihn trägt, bekommt Ärger, wenn die Gruppe später dem Wiedergänger des Raubritters begegnet.', NULL, NULL),
    (27, 4, 25, 4, 2, '2', 'Torhaus', 'Am Ende der Straße erhebt sich eine alte Burg, die einmal ein beeindruckender Anblick gewesen sein muss. Jetzt ist sie eine heruntergekommene Ruine mit teils eingestürzten Mauern, die sich grau vor dem Himmel abzeichnen. Vor euch liegt ein verfallenes Tor aus verkohltem, morschem Holz. Der Wind heult leise, während er in den Burghof weht.', '✦ Das Tor: Das doppelte Tor aus verkohltem Holz hängt offen am Eingang zum Burghof.
✦ Die Stolperschnur: Sagen die Spielenden, dass sie das Tor untersuchen, können sie eine Entdecken-Probe ablegen. Bei Erfolg finden sie eine dünne, in Kniehöhe über den Eingang gespannte Schnur, die mit Glocken auf der Innenseite des Tores verbunden ist. Bemerken die Charaktere die Falle nicht, löst sie aus, sobald sie das Tor passieren, und die Goblins locken sie im Burghof (#3) in einen Hinterhalt vom Baum aus.
✦ Das Loch: Direkt hinter dem Eingang klafft ein dunkles Loch. Der Boden ist in den alten Keller eingestürzt, vier Meter tief auf kalten, harten Stein. Die Charaktere müssen eine Akrobatik-Probe bestehen, um zum Burghof hinüberzukommen. Auf der anderen Seite des Lochs liegt ein langes Brett als behelfsmäßige Brücke: Wer es benutzt, erhält einen Vorteil auf die Probe. Misslingt sie, stürzt der Charakter in den Keller (#5) und erleidet 2W6 Wuchtschaden. Jeder Charakter kann den Sturz mit einer weiteren Akrobatik-Probe abfedern und den Schaden auf W6 senken.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (28, 4, 25, 4, 3, '3', 'Burghof', 'Die zerbrochenen Mauern der Burg ragen um euch auf und umrahmen einen mit Steinen und Schutt übersäten Hof. Mitten im Hof streckt eine knorrige alte Eiche ihre Äste in den Himmel. In der Nordostecke führt eine Steintreppe hinauf zu einem baufälligen alten Turm. Im Westen klafft eine offene Tür in ein Steingebäude an der Westmauer. Im Osten liegt eine hölzerne Luke im Boden.', '✦ Die Eiche: Der längst abgestorbene Baum dient den Goblins als Aussichtsturm und als Ort für Hinterhalte gegen eindringende Abenteurer. Seine Äste erlauben es den Goblins, sich mühelos zwischen den Burgmauern und anderen Orten zu bewegen, ohne den Boden zu betreten.
✦ Die versteckten Goblins: Haben die Charaktere die Falle im Torhaus (#2) ausgelöst, haben die Goblins einen Hinterhalt vorbereitet. Sie warten, bis die Charaktere einen Ort in der Burg erkundet haben und wieder in den Burghof zurückkommen. Dann stürzen sie sich von den Ästen. Jeder Charakter darf eine Wahrnehmung-Probe ablegen: Wer scheitert, gilt als überrascht und handelt in der ersten Kampfrunde zuletzt. Die Goblins sind den Charakteren um einen überlegen. Sie handeln alle im selben Zug und teilen sich eine Initiativkarte.
✦ Schatz: Klettern die Charaktere auf die Eiche, bemerken sie etwas Glitzerndes in einem Loch im Stamm. Die Goblins haben hier Beute für unerwartete Ausgaben versteckt. Würfle am Tisch einmal auf den Schatztabellen.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (29, 4, 25, 4, 4, '4', 'Große Halle', 'Was einst die große Halle der Burg gewesen sein muss, ist heute ein trauriges Durcheinander aus halb verrotteten Dachbalken, zerbrochenem Geschirr und herabgefallenem Mörtel. Die Raummitte beherrscht ein langer Eichentisch, an der Nordwand hängt ein großes Gemälde schief. Aus einem Schrank in der Ecke hört ihr ein leises Gluckern.', '✦ Der Eichentisch: Hier aßen der Raubritter und seine Adjutanten. Jetzt ist der Tisch mit Trümmern bedeckt: Tonscherben, alte Zinnbecher, zerbrochene Weinflaschen und schimmelige Essensreste. Letztere zeigen, dass hier vor kurzem jemand gegessen hat. Eine Handwerk-Probe verrät, dass die Tonscherben und Weinflaschen aus heutiger Zeit stammen und halblingischen Ursprungs sind.
✦ Das Porträt: Ein großes Gemälde hängt schief an der Nordwand. Es zeigt einen strengen Mann mit bösen grauen Augen, wüstem Grinsen und rabenschwarzem Haar. Er trägt eine volle Rüstung und hält einen gehörnten Großhelm unter dem Arm.
✦ Die Rückseite des Gemäldes: Untersuchen Charaktere das Gemälde genau oder sehen sich im Raum um und bestehen eine Entdecken-Probe, finden sie eine Notiz auf der Rückseite der Leinwand. Sie lautet: „Der Schuft Rothgar Wolfsbane hat mich gezwungen, ihn zu malen. Wenn ich es nicht lebend hier heraus schaffe, verfluche ich seinen Namen für alle Ewigkeit! – Embarius“
✦ Der schlafende Goblin: Der Goblin-Häuptling Jaldo hat sich zwischen den verrottenden Tischdecken und zerbrochenem Geschirr im Eckschrank eine kleine Höhle gebaut. Er schläft fest nach den nächtlichen Feierlichkeiten, mit einer leeren Weinflasche und einem alten, ungewöhnlich großen Trinkhorn in den Armen (eine Handwerk-Probe zeigt, dass es in Wahrheit ein Kriegshorn ist). Das Horn kann später im Abenteuer wichtig werden, denn mit ihm lässt sich der untote Raubritter beschwören. Machen die Charaktere zu viel Lärm, wacht Jaldo auf und schleicht durch ein Loch in den Burghof, um seine Handlanger zu warnen, die einen Hinterhalt in der Eiche vorbereiten.
✦ Jaldos Jammergeschichte: Überraschen die Charaktere Jaldo und wecken ihn, erkennt er, dass er in der Unterzahl ist, und tut so, als wäre er ein armer, einsamer Goblin, der sich verirrt und in der Burg Schutz gesucht hat. Schnell erfindet er eine weitschweifige, schlecht ausgedachte Geschichte über einen brutalen Orkclan, der die Burg übernommen und ihn in den Schrank gezwungen habe. Jaldo bietet an, ihnen zu zeigen, wo sich die Orks verstecken. Er will sie in den Keller führen, wo die nicht ganz so gewalttätige Orkin Grunta gefangen ist, und sie dort einsperren.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (30, 4, 25, 4, 5, '5', 'Keller', 'Unter der Luke führt eine steile Steintreppe in den Untergrund. Es ist feucht und riecht nach Erde. Die Treppe endet in einem großen Raum mit gestapelten Fässern an der Ostwand. Im südlichen Teil des Raumes liegen mehrere Nischen, die das Licht der Fackel nicht erreicht. In einer Ecke sitzt eine große Orkin, die sich überrascht umdreht.', '✦ Die Luke: Die hölzerne Luke zum Keller ist nicht verschlossen, wenn die Charaktere eintreffen, aber von außen verriegelt. Sie hat Rüstungswert 8 und lässt sich mit 20 Schadenspunkten aufbrechen.
✦ Grunta: Im Dunkel des Kellers lebt die Orkin Grunta, die aus ihrem Clan verstoßen und von Jaldo und seinen Goblin-Banditen benutzt wird. Ihre einzige Aufgabe ist es, auf Jaldos Befehl in das Horn des Raubritters zu blasen und seinen Wiedergänger zu beschwören (die Lungen der Goblins sind zu schwach, mehr als ein jämmerliches Quieken bringen sie nicht hervor). Grunta ist zutiefst unglücklich und will die Burg verlassen, wagt es aber aus Angst vor Jaldo nicht. Ihr einziger Lebensinhalt ist ihr Schwein Merle (siehe NSC „Grunta“).
✦ Das Skelett: Untersuchen die Charaktere den Raum und bestehen eine Entdecken-Probe, finden sie unter dem Schutt ein versteckt liegendes Skelett. Rostige Ketten zeigen, dass der Tote an eine Wand gekettet war. Beim Durchsuchen der Knochen finden sie ein zusammengerolltes Pergament mit der Skizze eines jungen Mannes, betitelt „Der Künstler Embarius in seiner Jugend“.
✦ Das Goblin-Nest: Die Nischen an der Südwand sind mit einfachen Matratzen aus Stroh und Stöcken ausgestattet. Falls kein Alarm ausgelöst wurde, ruhen hier Goblins (einer mehr als Spielercharaktere).
✦ Schätze: In einer der Nischen horten die Goblins gestohlene Dinge von geringem Wert. Spielercharaktere, die ein wenig herumstöbern und eine Entdecken-Probe bestehen, finden etwas Wertvolles. Würfle am Tisch einmal auf den Schatztabellen.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4),
    (31, 4, 25, 4, 6, '6', 'Turm', 'Was einst ein mächtiger Steinturm war, ist heute nur noch eine hohle Hülle. Die oberen Stockwerke sind eingestürzt, das Dach ist längst fort. Übrig sind heruntergefallene Steine, moosbewachsene Mauern und eine Steintreppe, die sich nach unten windet, teils unter Schutt und Trümmern begraben.', '✦ Die Raben: Ein Schwarm Raben hat hoch oben im Turm genistet. Wo einst das dritte Stockwerk war, ragt nur noch ein kleiner Steinsims aus der Wand. Ein Charakter, der eine Akrobatik-Probe besteht, kann zum Rabennest hinaufklettern. Würfle am Tisch einmal auf den Schatztabellen, um zu sehen, was dort liegt.
✦ Die Treppe: Der Weg nach unten ist fast vollständig von Steinen der eingestürzten Stockwerke versperrt, aber man kann sich vorsichtig geduckt am Schutt vorbeiquetschen.
✦ Hufspuren: Eine erfolgreiche Entdecken-Probe zeigt die schlammigen Hufspuren eines Schweins, die die Treppe hinabführen.
✦ Herabstürzender Felsbrocken: Sind die Charaktere auf halbem Weg die Treppe hinunter, löst sich weiter oben ein großer Stein und poltert auf sie zu. Alle müssen eine Ausweichen-Probe ablegen. Wer scheitert, wird nach vorn gestoßen und landet am Ende der Treppe im Wasser, wobei er W8 Wuchtschaden erleidet.
✦ Das Schwein: Die Treppe verschwindet im schwarzen Wasser auf der untersten Ebene des Turms. Jahrzehntelanger Regen hat aus dem einstigen Weinkeller einen tiefen Brunnen gemacht. Auf einem Sims am Wasser hat sich das Schwein Merle ein Nest gebaut. Sind die Charaktere ihr noch nicht begegnet (siehe Zufälliges Ereignis 2), ruht sie im Nest und begrüßt die Abenteurer mit einem überraschten Grunzen.
✦ Der Helm: Blicken die Charaktere in die Tiefe, sehen sie etwas im schwarzen Wasser schimmern. Der Brunnen ist vier Meter tief, und es braucht eine erfolgreiche Schwimmen-Probe, um den Grund zu erreichen und den Schatz zu finden. Würfle am Tisch zweimal auf den Schatztabellen. Dort liegt auch ein grinsender Totenschädel in einem rostigen, gehörnten Helm: der Schädel von Rothgar Wolfsbane, mit dem sich der Wiedergänger bannen lässt. Haben die Charaktere das Porträt in der Großen Halle (#4) gesehen, erkennen sie den Helm sofort, den der Raubritter unter dem Arm trug. Der Helm hat Rüstungswert +2, gibt aber einen Nachteil auf Wahrnehmung-Proben und Fernkampfangriffe.
✦ Zufälliges Ereignis: Würfle am Tisch einen W6 auf „Zufällige Ereignisse“ für jedes volle Viertel in der Burg.', NULL, 4);

INSERT INTO campaign_items (id, campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, text_de, image_path) VALUES
    (4, 4, 4, 26, 'Auf halbem Weg den Hügel hinauf, im Unterholz', 'Orkhelm', 'Ein alter, halb im Unterholz verborgener Helm aus verkohltem Metall mit scharfen Stacheln an den Seiten. Trotz seines Alters voll funktionsfähig.', 'Rüstungswert +1, Nachteil auf Wahrnehmung-Proben. Mythen & Legenden-Probe: von Orks geschmiedet. Wer ihn trägt, bekommt Ärger, wenn er dem Wiedergänger des Raubritters begegnet: Orks und Träger des Orkhelms greift er zuerst an.', NULL, NULL),
    (5, 4, 4, 29, 'In Jaldos Armen, im Eckschrank', 'Jaldos Kriegshorn', 'Ein alter, ungewöhnlich großes Trinkhorn.', 'Eine Handwerk-Probe zeigt, dass es ein Kriegshorn ist: Rothgar Wolfsbanes Kriegshorn. Wer es mit kräftigen Lungen bläst (STÄ 14 oder höher), beschwört den Wiedergänger des Raubritters.', NULL, NULL),
    (6, 4, 4, 29, 'An der Nordwand der Großen Halle', 'Das Porträt', 'Ein großes Gemälde: ein strenger Mann mit bösen grauen Augen, wüstem Grinsen und rabenschwarzem Haar in voller Rüstung, einen gehörnten Großhelm unter dem Arm.', 'Zeigt Rothgar Wolfsbane. Auf der Rückseite steht eine Notiz (Entdecken-Probe).', '„Der Schuft Rothgar Wolfsbane hat mich gezwungen, ihn zu malen. Wenn ich es nicht lebend hier heraus schaffe, verfluche ich seinen Namen für alle Ewigkeit! – Embarius“', NULL),
    (7, 4, 4, 30, 'Unter dem Schutt, bei dem angeketteten Skelett (Entdecken-Probe)', 'Selbstporträt des Embarius', 'Ein zusammengerolltes Pergament mit der Skizze eines jungen Mannes, betitelt „Der Künstler Embarius in seiner Jugend“.', 'Das Skelett im Keller ist der Maler Embarius, der das Porträt in der Großen Halle malen musste.', NULL, NULL),
    (8, 4, 4, 31, 'Auf dem Grund des Brunnens im Turm (Schwimmen-Probe)', 'Der gehörnte Helm mit Schädel', 'Ein rostiger gehörnter Helm mit einem grinsenden Totenschädel darin. Der Helm hat Rüstungswert +2.', 'Der Schädel von Rothgar Wolfsbane, mit dem sich der Wiedergänger bannen lässt (siehe NSC Der Raubritter). Nachteil auf Wahrnehmung-Proben und Fernkampfangriffe.', NULL, NULL);

INSERT INTO campaign_npcs (id, campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, notes_de, bestiary_id, portrait_path) VALUES
    (12, 4, 4, 29, NULL, 'Jaldo', 'Klein, verschlagen und sehr einfallsreich. Jaldo hat die Gabe des Redens und hat ein Dutzend Goblin-Anhänger mit Versprechen von Wein, Silber und einem eigenen Zuhause um sich geschart. Versprechen, die er zu seiner eigenen Überraschung halten konnte, indem er die Burg fand und schnell begriff, dass er die Legende vom Raubritter zu seinem Vorteil nutzen konnte.', 'Rolle: Goblin-Häuptling

Siehe auch die Jammergeschichte in der Großen Halle (#4). Jaldo schläft zu Spielbeginn im Eckschrank der Großen Halle.

TP: 10 · Bewegung: 10 · Schadensbonus: — · Rüstung: Beschlagenes Leder (2), offener Helm (+1)
Fertigkeiten: Wahrnehmung 12, Ausweichen 10, Heimlichkeit 12
Waffe: Krummsäbel (Fertigkeitswert 12, Schaden 2W6)', NULL, 52, NULL),
    (13, 4, 4, 30, NULL, 'Grunta', 'Grunta ist eine Orkin ohne Heim und ohne Ziel. Aus ihrem Clan verstoßen, wanderte sie auf der Suche nach einem neuen durch die Lande. Ihre ständige Begleiterin ist das Schwein Merle, das sie vor einem hungrigen Wolfsmenschen gerettet hat. Die beiden sind seither unzertrennlich.', 'Rolle: Gefangene der Goblins

Als sie Jaldo und seinen Goblins begegnete, wurde Grunta vom Versprechen neuer Freunde geblendet und fiel auf seine Lügen herein. Nun steckt sie im Keller fest, weil sie zu viel Angst hat, wegzugehen: Angst vor Jaldo, vor dem Wiedergänger des Raubritters und davor, dass die Goblins ihr geliebtes Schwein fressen könnten. Gäbe es eine Chance, mit Merle zu entkommen, würde sie sie ergreifen.

TP: 12 · Bewegung: 10 · Schadensbonus STÄ: +W4
Fertigkeiten: Wahrnehmung 14, Ausweichen 10
Waffe: Kleine Holzkeule (Fertigkeitswert 12, Schaden W8)', NULL, 53, NULL),
    (14, 4, 4, 31, NULL, 'Merle (Schwein)', 'Ein rosiges Hausschwein, das gern in den Ecken der Burg wühlt und grunzt.', 'Rolle: Grunts Gefährtin

Merle ist Gruntas ganzer Stolz. Wer sie verletzt, macht sich Grunta zur Feindin fürs Leben. Wurde Merle durch das Zufällige Ereignis 2 noch nicht getroffen, ruht sie im Nest am Brunnen im Turm (#6).', NULL, NULL, NULL),
    (15, 4, 4, 28, NULL, 'Die Goblins', 'Etwa zehn Goblins leben in der Burg. Ein paar Späher halten hoch oben im alten Eichenbaum Wache. Eine Gruppe ruht meist in den Nischen im Keller, die übrigen huschen auf verschiedenen Besorgungen durch die Burg.', 'Rolle: Banditen

Die Goblins können die Charaktere aus dem Hinterhalt angreifen, im Keller (#5) angetroffen werden oder als Zufälliges Ereignis auftauchen. Als SL kannst du sie die Charaktere treffen lassen, wann immer es passt.

TP: 9 · Bewegung: 10 · Schadensbonus: — · Rüstung: Lederrüstung (1)
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12
Waffen: Kurzbogen (Fertigkeitswert 12, Schaden W10), Kurzschwert (Fertigkeitswert 10, Schaden W10)', NULL, 54, NULL),
    (16, 4, 4, NULL, NULL, 'Der Raubritter (Wiedergänger)', NULL, 'Rolle: Untoter Raubritter Rothgar Wolfsbane

Der Raubritter ist ein Wiedergänger und wird wie ein Monster behandelt. Er trägt einen Morgenstern (Wuchtschaden 2W8).

Die ewige Wache des Rothgar Wolfsbane: Als Rothgar Wolfsbane bei der Belagerung der Burg durch die Orks vor vielen Jahrhunderten fiel, starb nur seine körperliche Hülle. Obwohl er seinen Kopf verloren hatte, war Wolfsbane so erfüllt von Hass und so verflucht, dass er zu ewigem Untod verdammt wurde. Seitdem patrouilliert er als kopfloser Wiedergänger durch die Burg und sucht ewig nach seinen sterblichen Feinden: den Orks.

Der Raubritter kann nach Ermessen der SL erscheinen, der Wiedergänger kann aber auch von jemandem mit starken Lungen (STÄ 14 oder höher) beschworen werden, der Jaldos Kriegshorn (#4) bläst. Der Wiedergänger greift alle Lebenden an, außer der Person mit dem Horn. Orks und Träger des Orkhelms (#1) greift er zuerst an.

Mit etwas List können die Charaktere den untoten Raubritter überzeugen, dass die Goblins in Wahrheit winzige Orks sind (der Wiedergänger ist so geblendet von seinem Hass auf Orks, dass er mit einer gelungenen Überzeugen-Probe überredet werden kann). Gelingt das, können sie sich zurücklehnen und ihre brillante Idee genießen, während der Wiedergänger kurzen Prozess mit den Goblins macht.

Es gibt drei Wege, den Raubritter zu überwinden:
✦ Ihn im Kampf besiegen. Er steht jedoch nach einem Tagesabschnitt (etwa sechs Stunden) wieder auf und spukt weiter in der Burg.
✦ Den Schädel des Raubritters am Grund des Turmes (#6) zerschmettern. Dann wird der Wiedergänger für zwei Runden rasend (seine Grimmigkeit steigt auf 3), bevor er in einem Haufen Knochen zusammenfällt. Dann beginnt die ganze Burg einzustürzen. Alle Spielercharaktere müssen jede Runde, die sie in den Burgmauern bleiben, eine Ausweichen-Probe ablegen (keine Aktion). Beim ersten Misslingen erleiden sie W6 Wuchtschaden, beim zweiten 2W6, und so weiter.
✦ Den Schädel dem kopflosen Wiedergänger bringen. Dann bleibt er stehen und setzt seinen Kopf auf. Er stößt einen langen Seufzer aus und fällt zusammen wie oben beschrieben. Die Burg stürzt ebenfalls ein.

Werte: TP 38, Grimmigkeit: Zahl der SC − 1, Größe: Normal, Bewegung 10, Rüstung 8. Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden.', NULL, 55, NULL);

INSERT INTO campaign_bestiary (campaign_id, bestiary_id, chapter_id, notes_de) VALUES
    (4, 52, NULL, NULL),
    (4, 53, NULL, NULL),
    (4, 54, NULL, NULL),
    (4, 55, NULL, NULL);
