SET NAMES utf8mb4;

-- Campaign: Ridderhöhe (Dragonbane Schnellstarter, S. 26–34)

INSERT INTO campaigns (is_default, name_de, teaser_de, background_de) VALUES (
    1,
    'Ridderhöhe',
    'Ein von Goblins geplünderter Grabhügel im Nebeltal, ein rachsüchtiger untoter Ritter und eine sagenumwobene Krone – ein kurzer Dungeon-Einstieg für 3–5 Charaktere.',
    'Tief in den ausgedehnten Wäldern des Nebeltals liegt ein Grabhügel namens Ridderhöhe. In der Umgebung ist dieser Ort gefürchtet, da hier der Geist eines mächtigen Ritters im Dienste des Drachenkaisers sein Unwesen treibt – doch heißt es auch, dass dieser Gruftschrecken im Hügel über verborgene Schätze wacht. Das Abenteuer ist als kurzer, einfacher Einstieg in Dragonbane gedacht, für drei bis fünf Spielende plus Spielleitung.

Die Charaktere sind Abenteurerinnen und Abenteurer, die auf der Suche nach Ruhm und Reichtum ins Nebeltal gekommen sind. Sie haben Gerüchte über eine uralte, wertvolle Krone gehört, die sich innerhalb der Ridderhöhe verbergen soll, und haben einen mehrtägigen, strapaziösen Marsch hinter sich. Bei Spielbeginn befinden sie sich am Punkt #1 des Bodenplans.

Wenn die Charaktere am Grabhügel ankommen, wurde er bereits von einer Gruppe Goblins geöffnet, die von der Ork-Stammesführerin Maladûk geschickt wurde. Diese Grabräuber haben sich jedoch bereits den Zorn des Gruftschreckens und einiger niederer Untoter eingehandelt, die dieses düstere Reich der Schatten bewohnen. Bei Ankunft der Charaktere wurden bereits alle Goblins getötet oder in die Flucht geschlagen – mit Ausnahme des armen Grub in Raum #5.

Der Gruftschrecken ist immer noch auf der Jagd nach den Grabräubern. Er bewegt sich langsam, aber beharrlich durch den Grabhügel, voller Zorn über die Dreistigkeit der Eindringlinge. Er kann durch geschlossene Fallgitter und Türen hindurchgehen und so überall plötzlich auftauchen.

DM-Tipp: Versuche während des Abenteuers eine spannende Atmosphäre zu schaffen und den Spielenden das Gefühl zu geben, wie in einem Horrorfilm durch die Gänge im Grabhügel gejagt zu werden. Setze dazu den Gruftschrecken ein, um die Charaktere zu verunsichern, während sie im Dunkeln des Hügels herumschleichen – sie können seine schweren, schleppenden Schritte hören, das grässliche Rasseln des Kettenhemdes und die dumpfen Geräusche seines Morgensterns, der gegen die Wände schlägt.'
);
SET @campaign_id = LAST_INSERT_ID();

-- Kapitel 1 (Einzelabenteuer) und der Ort in der Welt

INSERT INTO campaign_chapters (campaign_id, label, position, title_de) VALUES (@campaign_id, '1', 10, 'Ridderhöhe');
SET @chapter_id = LAST_INSERT_ID();

INSERT INTO campaign_places (campaign_id, chapter_id, name_de) VALUES (@campaign_id, @chapter_id, 'Ridderhöhe');
SET @world_location_id = LAST_INSERT_ID();

-- Orte (Bereiche des Abenteuers, alle im Ort Ridderhöhe)

INSERT INTO campaign_places (campaign_id, chapter_id, parent_id, position, number_label, name_de, description_de, dm_text_de) VALUES
(@campaign_id, @chapter_id, @world_location_id, 1, '1', 'Der Grabhügel',
 'Auf einer Lichtung, mitten im Wald erhebt sich ein Hügel, auf dessen Kuppe massive Steine thronen. Es ist seltsam ruhig hier und ein schwacher, aber unheilvoller Geruch liegt in der Luft – ein modriger Gestank von Fäulnis.',
 '✦ Steinplatte: Eine grob behauene, 2×2 m große Steinplatte ist auf der Hügelkuppe in die Erde eingelassen. Sie wurde leicht aus ihrer ursprünglichen Position verschoben, wodurch ein schmaler Spalt den Hohlraum darunter offenbart. Die Platte ist schwer, aber um sie beiseitezuschieben, ist keine Probe nötig.
✦ Spuren & Abdrücke: Im Gras sind deutliche Fußspuren zu erkennen. Ein Charakter mit einer erfolgreichen Wildnisleben-Probe entdeckt außerdem kleine Häufchen von Wolfskot und Goblin-Exkrementen. Der Geruch kommt von Letzterem.
✦ Den Hügel verlassen: Wenn die Charaktere den Hügel verlassen, um draußen zu rasten oder sich zu heilen, würfle für jeden vergehenden Tagesabschnitt auf der Tabelle „Den Hügel verlassen".'),

(@campaign_id, @chapter_id, @world_location_id, 2, '2', 'Schacht',
 'Unter der Steinplatte befindet sich ein unterirdischer Schacht, dessen Ende nicht zu sehen ist. Aus seiner Tiefe steigt ein muffiger Geruch nach abgestandener Luft und ausgetrockneten Leichen empor.',
 '✦ Tiefer Fall: Bis zum Boden des Schachtes sind es fünf Meter. Jeder Charakter muss eine Akrobatik-Probe ablegen, um sicher hinabzuklettern. Mit einem Seil erhalten sie einen Vorteil. Wer die Probe verpatzt, stürzt und erleidet Sturzschaden (siehe Seite 19).
✦ Gewölbe: Lassen die Charaktere eine Fackel in den Schacht fallen, sehen sie, dass er in einer gewölbeartigen Kammer endet, an deren Nordwand sich eine Tür befindet.
✦ NORD: führt hinab ins Vestibül (#3).'),

(@campaign_id, @chapter_id, @world_location_id, 3, '3', 'Vestibül',
 'Unter dem Schacht liegt eine gewölbeartige Kammer, deren Boden aus verdichteter Erde besteht. Weit oben an der Decke wirkt die Öffnung zur Erdoberfläche wie ein schwach leuchtendes Quadrat. An der Nordwand der Kammer befindet sich eine Doppeltür aus massivem Eichenholz mit Eisenbeschlägen. Ein silbernes Symbol erstreckt sich über beide Türflügel, die von Ritterstatuen in altertümlichen Rüstungen flankiert werden.',
 '✦ Durchbrochene Eichentür: Die Goblins haben die Tür bereits aufgebrochen; sie steht nur noch leicht angelehnt.
✦ Stilisierte Krone: Eine erfolgreiche Mythen & Legenden-Probe identifiziert das Symbol als stilisierte Krone aus der Zeit, als das Nebeltal von einem drachenanbetenden Königreich regiert wurde.
✦ Spuren im Dreck: Viele Fußabdrücke und Schleifspuren im Erdboden.
✦ NORD: Flügeltür zu den Hügeltunneln (#4).'),

(@campaign_id, @chapter_id, @world_location_id, 4, '4', 'Hügeltunnel',
 'Ein dunkler, feuchter Erdtunnel führt vom Vestibül in ein sich verzweigendes Tunnelsystem. Die Luft ist kühl und erfüllt von muffigen Gerüchen. Kriechende Wurzeln, Würmer und Tausendfüßler hängen von der Decke wie Stalaktiten und erschweren das Vorankommen.',
 '✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel, das die Charaktere hier verbringen.
✦ NORD: Zugang zur Wachstube (#7).
✦ OST: Feuchter Erdtunnel zur Familiengruft (#6).
✦ SÜD: Flügeltür zum Vestibül (#3).
✦ WEST: Feuchter Erdtunnel zur Gruft der Dienerschaft (#5).'),

(@campaign_id, @chapter_id, @world_location_id, 5, '5', 'Gruft der Dienerschaft',
 'Die Kammer ist dunkel und feucht. Ausgehöhlte Grabnischen bedecken die Wände vom Boden bis zur Decke, und überall liegen zerfallene Skelette, zerfetzte Lumpen und zerschlagene Tonscherben.',
 '✦ Verwüstet: Die Gruft wurde von Grabräubern heimgesucht – Skelette auf den Boden geschleift, Gefäße zertrümmert, Kleidung aufgeschlitzt.
✦ Verschlossenes Fallgitter: Versperrt den Durchgang zur Halle der Dame (#8). Ein abgebrochener Schlüssel steckt fest, das Fallgitter lässt sich so nicht öffnen. Rüstungswert 10, kann mit 30 Schadenspunkten oder einem Zauber wie Pfeiler überwunden werden – lockt dabei sofort den Gruftschrecken an.
✦ Versteckter Goblin: Hinter Skelettresten in einer niedrigen Grabnische versteckt sich Grub, ein hyperventilierender Goblin. Nur durch gezieltes Absuchen der Nischen oder eine Entdecken-Probe zu finden.
✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Feuchter Erdtunnel zur Halle der Dame (#8), durch ein verschlossenes Fallgitter versperrt.
✦ SÜD: Feuchter Erdtunnel zu den Hügeltunneln (#4).'),

(@campaign_id, @chapter_id, @world_location_id, 6, '6', 'Familiengruft',
 'In der finsteren Kammer sind an den Wänden sieben schlichte Steinsarkophage aufgereiht. Mehrere von ihnen sind geöffnet, und zwei Skelette liegen achtlos auf dem schmutzigen Erdboden.',
 '✦ Verwüstet: Drei der sieben Sarkophage wurden von den Goblins geöffnet und geplündert.
✦ Schätze: Die vier ungeöffneten Sarkophage enthalten einzeln beigesetzte Skelette (teils in Kindergröße) in zerfallenen zeremoniellen Gewändern. Alle tragen vergoldete Stirnbänder (je 5 Goldstück) und juwelenbesetzte Ringe (je 3 Goldstück).
✦ Verschlossenes Fallgitter: Ein eisernes Fallgitter versperrt den Durchgang zur Halle der Dame (#8). Lässt sich mit einem von Grubs unbeschädigten Schlüsseln öffnen (Fingerfertigkeit-Probe nötig; bei Misserfolg bricht der Schlüssel ab). Rüstungswert 10, alternativ 30 Schadenspunkte oder ein Zauber wie Pfeiler – lockt sofort den Gruftschrecken an.
✦ Falle: Vor dem Fallgitter liegt unter einer dünnen Erdschicht eine versteckte Falltür (Entdecken-Probe nötig). Unentdeckt stürzt der erste Charakter, der sich nähert, in eine Grube mit Holzpflöcken (3W6 Stichschaden, bei erfolgreicher Ausweichen-Probe halbiert).
✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Feuchter Erdtunnel zur Halle der Dame (#8), durch ein eisernes Fallgitter versperrt.
✦ SÜD: Feuchter Erdtunnel zu den Hügeltunneln (#4).'),

(@campaign_id, @chapter_id, @world_location_id, 7, '7', 'Wachstube',
 'Die Wachstube ist ein kleiner Raum mit festgetretenem Erdboden. Das flackernde Licht einer Fackel dringt durch ein schwarzes, eisernes Fallgitter an der hinteren Wand, das von zwei mumifizierten Wachen mit verrosteten Kettenhemden und langen Speeren flankiert wird.',
 '✦ Verrostetes Fallgitter: Völlig verrostet, lässt sich selbst mit Grubs Schlüssel nicht öffnen. Rüstungswert 10, alternativ 30 Schadenspunkte oder ein Zauber wie Pfeiler – lockt sofort den Gruftschrecken an.
✦ Waffen & Rüstungen: Die mumifizierten Wachen bleiben regungslos. Ihre rostigen Kettenhemden zerfallen bei Berührung, doch jede Wache hält einen Langspeer, der mitgenommen werden kann.
✦ Zufälliges Ereignis: Würfle einen W12 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Rostiges Fallgitter zur Halle der Dame (#8).
✦ SÜD: Zugang zu den Hügeltunneln (#4).'),

(@campaign_id, @chapter_id, @world_location_id, 8, '8', 'Die Halle der Dame',
 'Der kleine Raum wird von Fackeln an den Wänden beleuchtet. In der Mitte befindet sich ein Eichentisch, an dessen Kopfende eine mumifizierte Frau mit vergoldetem Kettenhemd sitzt. Hinter der Mumie befindet sich eine eisenbeschlagene Eichentür, auf der ein uraltes Symbol aus glänzendem Silber prangt.',
 '✦ Die Dame des Hügels: Die mumifizierte Frau ist die Ehefrau des Drachenritters und bewacht den Eingang zu seiner letzten Ruhestätte. Sie erwacht als Geist, sobald die Charaktere versuchen, die Eichentür zu Raum #9 zu öffnen oder den Streithammer „Dämonenbrecher" zu berühren. Siehe Bestiary-Eintrag „Die Dame des Hügels".
✦ Der Dämonenbrecher: Ein prächtiger, juwelenbesetzter Streithammer (1h, Reichweite 2, 2W6 Wuchtschaden, Haltbarkeit 15) in den Händen der Mumie – magisch, leuchtet rot, wenn sich Dämonen im Umkreis von 10 m befinden.
✦ Kettenhemd: Das vergoldete Kettenhemd ist leicht und flexibel (Rüstungswert 4, Nachteil auf Heimlichkeit-Proben).
✦ Stilisierte Krone: Eine Mythen & Legenden-Probe zeigt, dass das Symbol auf der Eichentür dieselbe stilisierte Krone wie im Vestibül (#3) ist.
✦ Fackeln: Brennen mit magischem Feuer, das automatisch erlischt, sobald sie aus dem Grabhügel entfernt werden.
✦ Zufälliges Ereignis: Würfle einen W6+3 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ NORD: Eiserne Eichentür zur Grabkammer des Drachenritters (#9).
✦ OST: Feuchter Erdtunnel zur Familiengruft (#6), versperrt durch ein eisernes Fallgitter.
✦ SÜD: Eisernes Fallgatter zur Wachstube (#7).
✦ WEST: Feuchter Erdtunnel zur Gruft der Dienerschaft (#5), versperrt durch ein eisernes Fallgitter.'),

(@campaign_id, @chapter_id, @world_location_id, 9, '9', 'Grabkammer des Drachenritters',
 'In der Mitte der mit Fackeln beleuchteten Grabkammer steht ein Podest, auf dem ein kunstvoller, steinerner Sarkophag ruht. Wände, Decke und Boden sind mit Steinziegeln verkleidet, und an der gegenüberliegenden Wand prangt das Bild eines Drachenreiters.',
 '✦ Der geöffnete Sarkophag: Wurde mit enormer Kraft von innen geöffnet; Teile des zerbrochenen Deckels liegen verstreut auf dem Boden.
✦ Dämonenkrone: Eine vergoldete Krone, verzaubert um Schaden durch Dämonenangriffe zu halbieren (aufrunden). Die Wirkung erklären Runen, die mit einer Fremdsprachen-Probe entziffert werden können.
✦ Grabfalle: Eine Entdecken-Probe offenbart, dass die Krone mit einem Fallenmechanismus verbunden ist. Wird sie ohne einen gleichschweren Ersatzgegenstand entfernt, schießen zwanzig Klingen aus dem Sarkophag (Fingerfertigkeit-Probe zum sicheren Austausch; bei Misserfolg Ausweichen-Probe oder 2W6 Stichschaden für jeden Charakter im Umkreis von 2 m).
✦ Der Gruftschrecken: Falls noch nicht besiegt oder wieder auferstanden, greift er die Charaktere hier in seiner Grabkammer an.
✦ Fresko: Der Drachenreiter auf dem Wandgemälde trägt genau dieselbe Rüstung und denselben gehörnten Helm wie der Gruftschrecken.
✦ Inschrift: Uralte Runen neben dem Fresko. Eine Fremdsprachen-Probe verrät etwas über „das Geschenk des Kaisers" und einen „Heiligen Zorn", der alle verzehrt, die es wagen, dieses Geschenk zu entehren.
✦ Zufälliges Ereignis: Würfle einen W4+4 auf „Zufällige Ereignisse" für jedes volle Viertel hier.
✦ SÜD: Eisenbeschlagene Eichentür zur Halle der Dame (#8).');

-- Bestiary (Vorlagen, wiederverwendbar)

INSERT INTO catalog_bestiary (name_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de) VALUES
    ('Riesenspinne', 36, '2', 'Normal', 24, '—', NULL, NULL);
SET @riesenspinne_id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@riesenspinne_id, '1', 'Mandibeln!', 'Die zackigen Mundwerkzeuge der Spinne sausen durch die Luft wie Krummsäbel. Der Angriff verursacht 2W8 Hiebschaden.'),
    (@riesenspinne_id, '2', 'Reißangriff!', 'Die hungrige Spinne wirft sich auf die Charaktere und greift verzweifelt mit ihren acht haarigen, mit Widerhaken versehenen Beinen an. Alle Charaktere innerhalb von 2 m erleiden jeweils W8 Stichschaden.'),
    (@riesenspinne_id, '3', 'Hypnotisierende Augen!', 'Der monströse Arachnid starrt die Charaktere mit seinen zahlreichen Augen an. Allen Opfern innerhalb von 10 m muss eine WIL-Probe gelingen, um dem Furchtangriff (siehe Seite 18) zu widerstehen.'),
    (@riesenspinne_id, '4', 'Giftstachel!', 'Der achtbeinige Schrecken erhebt sein Hinterteil und greift einen Charakter mit einem Giftstachel an. Der Angriff verursacht W10 Stichschaden; ein Gegner, der mindestens 1 Punkt Schaden erlitten hat, erhält zusätzlich ein Lähmungsgift der Wirkstärke 16 injiziert. Der Angriff kann pariert werden.'),
    (@riesenspinne_id, '5', 'Netzangriff!', 'Die Spinne fixiert den Charakter mit der höchsten STÄ und schießt ein klebriges Spinnennetz auf ihn. Er muss eine Ausweichen-Probe ablegen (zählt nicht als Aktion). Bei Misserfolg ist das Opfer gefangen und kann sich nicht mehr bewegen; nur eine erfolgreiche STÄ-Probe mit Nachteil (zählt als Aktion) befreit es, andere Charaktere können dabei helfen.'),
    (@riesenspinne_id, '6', 'Rammangriff!', 'Mit einem gewaltigen Sprung hämmert die Spinne ihren Körper gegen einen Charakter. Der Angriff verursacht 2W6 Wuchtschaden und schleudert das Opfer zu Boden.');

INSERT INTO catalog_bestiary (name_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de) VALUES
    ('Vampirfledermaus', 18, '2', 'Schwarm', 24, '—',
     'Die Fledermäuse greifen als Schwarm an und zählen als eine Kreatur. Jeder Schaden durch physische Waffen, selbst magische, wird halbiert (aufgerundet). Feuer verursacht jedoch normalen Schaden.',
     NULL);
SET @vampirfledermaus_id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@vampirfledermaus_id, '1-2', 'Wirbelnder Schrecken!', 'Die Fledermäuse schwirren in aberwitziger Geschwindigkeit um ihre Opfer. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff (siehe Seite 18).'),
    (@vampirfledermaus_id, '3-4', 'Kollektiver Angriff!', 'Die Fledermäuse werfen sich gemeinsam gegen den Charakter mit der höchsten KON. Der Angriff verursacht 2W6 Hiebschaden, und der Schwarm heilt sich um denselben Wert, da er das Blut seines Opfers trinkt.'),
    (@vampirfledermaus_id, '5-6', 'Massenangriff!', 'Die Fledermäuse teilen sich auf und greifen alle Charaktere innerhalb von 10 m an. Jedes Opfer erleidet W8 Hiebschaden, und der Schwarm heilt sich durch das getrunkene Blut um denselben Wert.');

INSERT INTO catalog_bestiary (name_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de) VALUES
    ('Die Dame des Hügels', 27, '2', 'Normal', 12, '—',
     NULL,
     'Geister sind körperlose Wesen und dadurch immun gegen jeglichen Schaden außer durch Magie und Feuer. Ein besiegter Geist wird nur für einen Tagesabschnitt gebannt; danach kehrt er zurück. Die einzige Methode, ihn permanent zu bannen, besteht darin, das Problem zu lösen, das ihn weiterhin an die Welt der Lebenden bindet. Anders als andere Monster kann sie für gewöhnlich überredet werden, wenn auch mit einem Nachteil auf den Wurf.');
SET @dame_id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@dame_id, '1', 'Geisterschlag!', 'Der Geist wirft sich auf einen Charakter, der nicht weiter als 10 m entfernt ist, und trifft ihn mit voller Wucht. Das Opfer wird 2W6 m zurückgeschleudert, erleidet denselben Wert an Wuchtschaden und landet auf dem Rücken.'),
    (@dame_id, '2', 'Berührung des Todes!', 'Der Geist greift mit seinen durchscheinenden Händen in die Brust des Opfers und ergreift dessen Herz. Es erleidet 2W10 Schadenspunkte und den Zustand Verängstigt. Die Rüstung hat hier keine Auswirkung.'),
    (@dame_id, '3', 'Geisterhafter Schrei!', 'Das Gesicht der Untoten verzerrt sich zu einer grässlichen Fratze, der ein fürchterlicher Schrei entfährt. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff (siehe Seite 18).'),
    (@dame_id, '4', 'Todesblick!', 'Der Geist starrt mit seinen toten Augen direkt in die Seele eines Charakters. Das Opfer ist Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (@dame_id, '5', 'Geisterhafte Umarmung!', 'Der Geist erscheint urplötzlich direkt vor einem Charakter, der nicht weiter als 10 m entfernt ist, und wickelt sich in einer tödlichen Umarmung um ihn. Dieser Angriff verursacht 3W6 Wuchtschaden und lässt das Opfer Benommen zurück.'),
    (@dame_id, '6', 'Kälteangriff!', 'Der Geist sendet einen eisigen Schock durch den Körper eines Opfers. Das verursacht 2W8 Punkte Schaden, und der Charakter kann keine TP oder WP heilen, bevor er nicht einen Tagesabschnitt an einem warmen Ort verbracht hat. Die Rüstung hat hier keine Auswirkung.');

INSERT INTO catalog_bestiary (name_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de) VALUES
    ('Der Gruftschrecken von Ridderhöhe', 38, '2', 'Normal', 10, '8',
     'Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden. Wird er innerhalb der Eichentür zum Vestibül (#3) besiegt, erhebt er sich im Laufe eines Tagesabschnitts wieder in Raum #9. Schwingt einen Morgenstern (2W8 Wuchtschaden).',
     NULL);
SET @gruftschrecken_id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@gruftschrecken_id, '1', 'Unheiliges Gebrüll!', 'Der zerfallene Schädel des Gruftschreckens verzieht sich zu einem grausigen Schrei. Alle innerhalb von 10 m werden mit einem Furchtangriff attackiert (siehe Seite 18).'),
    (@gruftschrecken_id, '2', 'Schauderhafter Blick!', 'Ein Charakter blickt direkt in die seelenlosen Augen der Kreatur. Das Opfer wird Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (@gruftschrecken_id, '3', 'Hand der Toten!', 'Der Gruftschrecken gestikuliert in Richtung eines Charakters innerhalb von 10 m. Dieser wird 2W4 m weit geschleudert, erleidet Schaden in gleicher Höhe und landet auf dem Rücken. Diesem Angriff kann nicht ausgewichen werden.'),
    (@gruftschrecken_id, '4', 'Rundumschlag!', 'Der Gruftschrecken schwingt seine Waffe mit übernatürlicher Geschwindigkeit. Alle Charaktere innerhalb von 2 m erleiden den Waffenschaden. Der Angriff kann pariert werden.'),
    (@gruftschrecken_id, '5', 'Lähmende Kälte!', 'Der Gruftschrecken ergreift ein Opfer, das die Kälte des Todes durch seinen Körper spürt. Das Opfer erhält W6 Schaden (Rüstung schützt nicht) und muss bei seinem nächsten Zug eine Ausweichen-Probe ablegen (zählt nicht als Aktion); bei Misslingen wiederholbar. Es ist nun kalt (siehe Seite 19) und kann keine TP/WP heilen, bis es sich wieder aufgewärmt hat.'),
    (@gruftschrecken_id, '6', 'Mächtiger Angriff!', 'Der Gruftschrecken schwingt seine mächtige Waffe gegen einen Charakter. Die reguläre Anzahl an Schadenswürfeln wird verdoppelt (4W8), und das Opfer wird zu Boden geschleudert. Der Angriff kann pariert werden.');

INSERT INTO campaign_bestiary (campaign_id, bestiary_id) VALUES
    (@campaign_id, @riesenspinne_id),
    (@campaign_id, @vampirfledermaus_id);

UPDATE catalog_bestiary SET category_de = 'Tier' WHERE name_de IN ('Riesenspinne', 'Vampirfledermaus');
UPDATE catalog_bestiary SET category_de = 'Untot' WHERE name_de IN ('Die Dame des Hügels', 'Der Gruftschrecken von Ridderhöhe');
UPDATE catalog_bestiary SET is_unique = 1 WHERE name_de = 'Der Gruftschrecken von Ridderhöhe';

-- NPCs (gehören zur Kampagne)

INSERT INTO campaign_npcs (campaign_id, name_de, description_de, dm_text_de) VALUES (
    @campaign_id,
    'Grub',
    'Grub, der Goblin, ist ein erbärmlicher Anblick: schmutzig, mit aufgerissenen Augen und hysterisch keuchend. Er trägt eine ramponierte und kaputte Lederrüstung und stinkt nach Angst und verschiedenen Goblin-Körperflüssigkeiten. Er versteckt sich hinter skelettierten Überresten in einer niedrigen Grabnische in der Gruft der Dienerschaft (#5) und ist das letzte überlebende Mitglied von Maladûks Expedition.',
    'Rolle: Überlebender Goblin-Grabräuber

Grub ist zu Tode verängstigt und will nur noch lebend aus dem Hügel herauskommen. Lassen die Charaktere ihn in Ruhe, versucht er zu fliehen. Können sie ihn mit einer Überzeugen-Probe beruhigen, hilft er ihnen: Er hat die Bewegungen des Gruftschreckens beobachtet und weiß, dass dieser sich ungehindert durch die Erdwände bewegen kann, aber bislang nicht durch die Eichentür des Vestibüls (#3) gegangen ist. Außerdem trägt er einen rostigen Eisenring mit drei Eisenschlüsseln – zwei unbeschädigt (passend zu den Fallgittern in #6 und #7, wobei nur das Schloss in #6 tatsächlich funktioniert) und einen abgebrochenen (der Rest steckt im Schloss von #5).

TP: 9 · Bewegung: 12 · Schadensbonus: — · Rüstung: Lederrüstung (1)
Fertigkeiten: Ausweichen 12, Heimlichkeit 14, Wahrnehmung 10
Waffen: Kurzschwert (Fertigkeitswert 12, Schaden W10), Kurzbogen (Fertigkeitswert 10, Schaden W10)'
);
SET @grub_id = LAST_INSERT_ID();

-- Einzigartige Wesen: NPCs, deren Kampfwerte als Werteblock im Bestiary stehen

INSERT INTO campaign_npcs (campaign_id, name_de, bestiary_id) VALUES
    (@campaign_id, 'Die Dame des Hügels', @dame_id);

INSERT INTO campaign_npcs (campaign_id, name_de, bestiary_id) VALUES
    (@campaign_id, 'Der Gruftschrecken von Ridderhöhe', @gruftschrecken_id);

-- Die beiden Zufallsereignis-Tabellen des Abenteuers stehen als Text in den
-- DM-Notizen der Orte, an denen gewürfelt wird.

UPDATE campaign_places SET dm_text_de = CONCAT(dm_text_de, '

Tabelle „Den Hügel verlassen" (W6):
1–3: Nichts passiert.
4–5: Eine Goblin-Patrouille taucht auf und greift sofort an. Die Gruppe ist den Charakteren um zwei Goblins überlegen und besitzt die gleichen Werte wie Grub.
6: Der Gruftschrecken taucht im Lager der Charaktere auf und greift sie sofort an, verschwindet jedoch, sobald er Schaden nimmt.')
WHERE campaign_id = @campaign_id AND number_label = '1';

UPDATE campaign_places SET dm_text_de = CONCAT(dm_text_de, '

Tabelle „Zufällige Ereignisse" (W12 pro Viertel):
1: Goblin-Angriff! Eine Goblin-Patrouille kehrt auf Anweisung ihrer orkischen Anführerin zum Grabhügel zurück, um den Schatz zu bergen und (möglicherweise) ihre zurückgelassenen Kameraden zu retten. Die Gruppe ist den Charakteren um zwei Goblins überlegen und greift sofort an, flieht jedoch, sobald die Hälfte von ihnen besiegt ist. Die Goblins haben die gleichen Werte wie Grub.
2: Massakrierter Goblin. Die Charaktere finden die Überreste eines toten Goblins, dessen Körper verstümmelt ist. Bei einer Heilkunde-Probe stellen sie fest, dass dieser noch nicht lange tot ist.
3: Riesige Spinne. Die Charaktere werden von einer riesigen Spinne angegriffen, die in einem Hohlraum hinter einer der Wände haust (siehe Bestiary „Riesenspinne"). Dieses Ereignis kann nur einmal stattfinden.
4: Der Gruftschrecken. Der Gruftschrecken wurde gestört und greift an. Da er keinen materiellen Körper besitzt, kann er durch geschlossene Fallgitter und Türen hindurchgehen (benötigt dafür eine Aktion). Er zieht sich in seine Grabkammer (#9) zurück, wenn er die Hälfte seiner Lebenspunkte verloren hat, und erholt sich dort innerhalb eines Viertels vollständig.
5: Ruhelose Geister. Durchsichtige Gestalten mit verzerrten Gesichtern tauchen aus den Schatten auf und greifen mit kreischendem Geschrei an. Die Charaktere müssen eine WIL-Probe ablegen, um der Angst zu widerstehen. Die Geister dienten einst dem Drachenritter, der durch ihre Schreie nach W3 Runden zur Gruppe gelockt wird (siehe Ereignis „Der Gruftschrecken").
6: Drakonische Vision. Eine diffuse Erinnerung überkommt einen Charakter, der plötzlich eine seltsame Stadt mit zahlreichen Türmchen, Zinnen und hörnerartigen Turmspitzen vor sich sieht – ein riesiger Drache, geritten von einem Ritter in goldenem Kettenhemd und gehörntem Helm, kommt direkt auf ihn zu. Der Charakter muss eine WIL-Probe mit Nachteil ablegen, um dem Furchtangriff zu widerstehen. Dieses Ereignis kann nur einmal stattfinden.
7+: Nichts passiert.')
WHERE campaign_id = @campaign_id AND number_label = '4';
