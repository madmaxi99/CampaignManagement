SET NAMES utf8mb4;

-- Rules reference data transcribed from docs/DB_DE_Schnellstarter_2-0_web-2njzid.pdf
-- (German quickstart, Chapter 2 "Kampf & Schaden") and docs/bilder/ (English
-- core rulebook, Chapter 4 "Combat & Damage" -- catalog_injuries and
-- catalog_magical_mishaps aren't in the German quickstart, only the full
-- rulebook, so those two are translated from the English screenshots
-- instead). Assumes schema.sql has already been applied.

-- catalog_time_units is seeded in seed_aodhan.sql (needed there before any
-- catalog_spells row references catalog_spell_durations/catalog_casting_times).

-- ============================================================
-- catalog_rest_types ("Heilung & Rast")
-- ============================================================

INSERT INTO catalog_rest_types (code, name_de, duration_de, effect_de) VALUES
    ('verschnaufen', 'Verschnaufen', '1 Runde',
        'Dauert lediglich eine Runde im Kampf. Du erhältst nur W6 WP zurück, aber keine TP. Du kannst nur einmal pro Tagesabschnitt verschnaufen.'),
    ('kurze_rast', 'Kurze Rast', '1 Viertel',
        'Dauert ein Viertel. Heilt W6 TP, beziehungsweise 2W6 TP, falls dich jemand pflegt und dabei eine gelungene Heilkunde-Probe ablegt (die Pflegenden können währenddessen selbst nicht rasten und nur eine Person gleichzeitig heilen). Während des Viertels erhältst du außerdem W6 WP zurück und erholst dich von einem Zustand deiner Wahl. Nur einmal pro Tagesabschnitt möglich.'),
    ('lange_rast', 'Lange Rast', '1 Tagesabschnitt',
        'Dauert einen ganzen Tagesabschnitt und kann nur an einem sicheren Ort eingelegt werden, an dem sich keine Feinde in der Nähe aufhalten. Heilt alle verlorenen TP und WP zurück und entfernt sämtliche Zustände. Wird die Rast unterbrochen, ist sie wirkungslos.');

-- ============================================================
-- catalog_hazards ("Weitere Gefahren")
-- ============================================================

INSERT INTO catalog_hazards (code, name_de, description_de) VALUES
    ('gift', 'Gift',
        'Gifte werden nach ihrer Wirkstärke bemessen. Ein schwaches Gift hat Wirkstärke 9, ein mittelstarkes Gift Wirkstärke 12, ein starkes Gift Wirkstärke 15 oder höher. Immer wenn du ein Gift einnimmst, legt die Spielleitung eine offene vergleichende Probe zwischen der Wirkstärke und deiner KON ab. Gewinnt das Gift, erleidest du die volle Wirkung. Verlierst du, erleidest du nur die eingeschränkte Wirkung. Gifte haben keine Auswirkung auf Monster.\n\nLähmungsgift – Volle Wirkung: Du bist Erschöpft und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, kannst du dich in dieser Runde weder bewegen noch eine Aktion durchführen (nicht einmal Freie Aktionen). Die Wirkung lässt nach einem Viertel oder der Einnahme eines Gegengifts nach. Eingeschränkte Wirkung: Du bist Erschöpft.\n\nTödliches Gift – Volle Wirkung: In deinem Zug erleidest du in jeder Runde W6 Schaden, bis deine TP auf null sinken. Nimmst du rechtzeitig ein Gegengift ein, wird die Wirkung unterbrochen. Eingeschränkte Wirkung: Bei deinem nächsten Zug erleidest du W6 Schaden.\n\nSchlafgift – Volle Wirkung: Du bist Benommen und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, schläfst du ein und wachst erst nach einer ganzen Schicht wieder auf. Sobald du ein Gegengift erhältst oder wenigstens einen Schadenspunkt erleidest, wachst du auf. Eingeschränkte Wirkung: Du bist Benommen.'),
    ('furcht', 'Furcht',
        'In den Ruinen und Wäldern von Dragonbane hausen viele grässliche Bestien. Diese Geschöpfe können sogenannte Furchtangriffe durchführen, die auch durch Magie und andere erschreckende Erfahrungen ausgelöst werden können.\n\nWenn du einen Furchtangriff erleidest, musst du sofort eine Probe auf WIL ablegen. Du kannst den Wurf strapazieren (optionale Regel), und er gilt nicht als Aktion. Durch besonders grauenhafte Ereignisse erleidest du einen Nachteil auf den Wurf. Falls die WIL-Probe scheitert, musst du auf der Furchttabelle würfeln.'),
    ('dunkelheit', 'Dunkelheit',
        'In völliger Dunkelheit kannst du weder sprinten noch mit Fernkampfangriffen treffen. Um im Nahkampf einen Feind anzugreifen, musst du eine erfolgreiche Wahrnehmung-Probe ablegen (keine Aktion).\n\nFackeln: Eine Fackel erleuchtet einen Umkreis von bis zu 10 Metern (5 Feldern) in alle Richtungen. Das Entzünden zählt als Aktion, sofern Feuerstein und Zunder oder ein Feuer notwendig ist, alternativ der Zaubertrick Entzünden. Eine Fackel wird in einer Hand gehalten, sodass gleichzeitig keine zweite Einhandwaffe geführt werden kann. Eine Fackel kann als Waffe eingesetzt werden und gilt als kleiner Holzknüppel, der Feuerschaden verursacht. Immer wenn du jemanden damit triffst, musst du sofort würfeln, um festzustellen, ob die Flamme ausgeht.\n\nFackeln oder Laternen können einen Tagesabschnitt lang brennen, sind aber unzuverlässig. Nach jedem Viertel oder wenn die Spielleitung die Spannung steigern will, musst du einen W6 würfeln. Eine 1 bedeutet, dass die Flamme ausgeht.'),
    ('kaelte', 'Kälte',
        'Sobald es bitterkalt wird und dir (nach Ermessen der Spielleitung) die passende Unterkunft fehlt, musst du immer wieder Wildnisleben-Proben ablegen. Für gewöhnlich würfelst du in jeder Schicht einmal, aber in extremer Kälte musst du in jedem Viertel oder sogar in jeder Runde würfeln. Falls du keine Decke besitzt, bekommst du einen Nachteil auf deine Probe, wohingegen ein Fell einen Vorteil verleiht.\n\nBei einem Fehlschlag verlierst du W6 TP und W6 WP und kannst dich von diesen und anderen Zuständen nicht erholen, außer durch Magie. Danach musst du weiterhin würfeln, wobei sich die gleiche Wirkung einstellt, falls du scheiterst. Sollten deine TP aufgrund von Kälte auf null sinken, stirbst du, sobald du den nächsten Wurf ablegen müsstest. Erst wenn dir warm wird, und sei es an einem Lagerfeuer, musst du nicht mehr würfeln und kannst dich wie üblich erholen.'),
    ('sturzschaden', 'Sturzschaden',
        'Ein Sturz auf eine harte Oberfläche verursacht Wuchtschaden in Höhe einer Anzahl von W6 gleich der halben, abgerundeten Sturzhöhe in Metern. Ein Sturz aus weniger als 2 Metern verursacht keinen Schaden. Eine gelungene Akrobatik-Probe senkt die Anzahl der W6 um die Hälfte (aufgerundet). Rüstungen schützen nicht gegen Sturzschaden.'),
    ('schwimmen_ertrinken', 'Schwimmen & Ertrinken',
        'Alle Spielercharaktere können einigermaßen gut schwimmen. Im Wasser ist dein Bewegungswert halb so groß wie an Land. Im Wasser können keine Fernkampfangriffe durchgeführt werden, und Nahkampfangriffe erfolgen mit Nachteil. Schwierigere Unterwasser-Bewegungen – wie das Tauchen nach etwas – erfordern eine Schwimmen-Probe. Du erleidest einen Nachteil, wenn du dabei ein Kettenhemd oder einen Plattenpanzer trägst.\n\nAußerdem musst du im Wasser nach jedem Viertel eine Schwimmen-Probe ablegen, um an der Oberfläche zu bleiben. Falls du ein Kettenhemd oder einen Plattenpanzer trägst, musst du in jeder Runde würfeln. Unter Wasser muss dir in jeder Runde eine KON-Probe gelingen, um den Atem anzuhalten (keine Aktion). Scheitert der Wurf, ertrinkst du und erleidest in jeder Runde W6 Schaden, bis dich jemand rettet. Sollten deine TP beim Ertrinken auf null sinken, legst du wie üblich Todeswürfe ab, allerdings zählen nur die gescheiterten Würfe.');

-- ============================================================
-- catalog_injuries ("Severe Injuries" / Schwere Verletzungen, D20 --
-- not in the German quickstart, translated from the English core rulebook
-- screenshot). Rolled on a failed CON roll after being reduced to 0 HP but
-- surviving; healing time is halved with a shift/day of care from someone
-- making a HEALING roll.
-- ============================================================

INSERT INTO catalog_injuries (roll_min, roll_max, name_de, effect_de, healing_de) VALUES
    (1, 2, 'Gebrochene Nase', 'Nachteil auf alle Wahrnehmung-Proben.', 'W6 Tage'),
    (3, 4, 'Vernarbtes Gesicht', 'Nachteil auf alle Darbietung- und Überzeugen-Proben.', '2W6 Tage'),
    (5, 6, 'Zähne ausgeschlagen', 'Deine Fertigkeitswerte in Darbietung und Überzeugen werden dauerhaft um 2 gesenkt (mindestens 3).', NULL),
    (7, 8, 'Gebrochene Rippen', 'Nachteil auf alle Fertigkeiten, die auf STÄ oder GEW basieren.', 'W6 Tage'),
    (9, 10, 'Gehirnerschütterung', 'Nachteil auf alle Fertigkeiten, die auf INT basieren.', 'W6 Tage'),
    (11, 12, 'Tiefe Wunden', 'Nachteil auf alle Fertigkeiten, die auf STÄ oder GEW basieren, und jeder Einsatz einer solchen Fertigkeit verursacht zusätzlich W6 Schaden.', '2W6 Tage'),
    (13, 13, 'Gebrochenes Bein', 'Deine Bewegungsrate wird halbiert.', '3W6 Tage'),
    (14, 14, 'Gebrochener Arm', 'Du kannst weder eine zweihändige Waffe führen noch zwei Waffen gleichzeitig einsetzen, und erhältst einen Nachteil auf alle anderen Handlungen, die normalerweise beide Arme erfordern, etwa Klettern.', '3W6 Tage'),
    (15, 15, 'Abgetrennter Zeh', 'Deine Bewegungsrate wird dauerhaft um 2 gesenkt (mindestens 4).', NULL),
    (16, 16, 'Abgetrennter Finger', 'Deine Fertigkeitswerte in allen Waffenfertigkeiten werden dauerhaft um 1 gesenkt (mindestens 3).', NULL),
    (17, 17, 'Ausgestochenes Auge', 'Dein Fertigkeitswert in Entdecken wird dauerhaft um 2 gesenkt (mindestens 3).', NULL),
    (18, 18, 'Albträume', 'Wirf bei jeder geschlafenen Schicht eine Probe, um Furcht zu widerstehen. Scheitert die Probe, zählt die Schicht nicht als geschlafen.', '2W6 Tage'),
    (19, 19, 'Veränderte Persönlichkeit', 'Würfle zufällig eine neue Schwäche aus (optionale Regel).', NULL),
    (20, 20, 'Amnesie', 'Du kannst dich nicht mehr daran erinnern, wer du oder die anderen Spielercharaktere sind. Der Effekt muss ausgespielt werden.', 'W6 Tage');

-- ============================================================
-- catalog_combat_mishaps ("Einen Dämon würfeln" beim Angriff, D6, je Nah-/
-- Fernkampf getrennt)
-- ============================================================

INSERT INTO catalog_combat_mishaps (context, roll, effect_de) VALUES
    ('melee', 1, 'Du lässt deine Waffe zu Boden fallen. Sie aufzuheben ist eine Aktion.'),
    ('melee', 2, 'Du gibst dir für einen Moment eine Blöße; dein Gegner erhält einen kostenlosen Angriff gegen dich, dem weder ausgewichen noch der pariert werden kann.'),
    ('melee', 3, 'Deine Waffe bohrt sich so tief in ein Objekt, dass sie steckenbleibt. Sie zu befreien erfordert eine STÄ-Probe (Aktion).'),
    ('melee', 4, 'Du schleuderst deine Waffe versehentlich W3+3 Meter weit fort. Sie aufzuheben erfordert eine Aktion.'),
    ('melee', 5, 'Du schlägst mit deiner Waffe gegen etwas Hartes und beschädigst sie; jede weitere Verwendung der Waffe erhält einen Nachteil, bis sie von einem Handwerker repariert wurde.'),
    ('melee', 6, 'Du triffst dich selbst aus Versehen; würfle den Schaden wie gewohnt, jedoch ohne Schadensbonus.'),
    ('ranged', 1, 'Du lässt deine Waffe zu Boden fallen. Sie aufzuheben ist eine Aktion.'),
    ('ranged', 2, 'Dir gehen die Pfeile aus, und du musst dir neue besorgen, bevor du die Waffe wieder benutzen kannst; bei Schleudern oder Wurfwaffen würfle stattdessen erneut.'),
    ('ranged', 3, 'Du triffst einen wertvollen oder wichtigen Gegenstand in der Nähe; die Spielleitung entscheidet, um welchen es sich handelt.'),
    ('ranged', 4, 'Du zerbrichst deine Waffe; jede weitere Verwendung der Waffe erhält einen Nachteil, bis sie von einem Handwerker repariert wurde.'),
    ('ranged', 5, 'Du triffst versehentlich einen zufälligen Spielercharakter oder freundlichen NSC in der Nähe; würfle den Schaden wie gewohnt, einschließlich Schadensbonus.'),
    ('ranged', 6, 'Du triffst dich selbst aus Versehen; würfle den Schaden wie gewohnt, jedoch ohne Schadensbonus.');

-- ============================================================
-- catalog_magical_mishaps ("Einen Dämon würfeln" beim Zaubern, D20 -- not in
-- the German quickstart, translated from the English core rulebook
-- screenshot)
-- ============================================================

INSERT INTO catalog_magical_mishaps (roll, effect_de) VALUES
    (1, 'Die magischen Kräfte lassen dich Benommen zurück.'),
    (2, 'Das Zaubern macht dich plötzlich Erschöpft.'),
    (3, 'Die Energien fordern ihren Tribut von deinem Körper; du wirst Kränkelnd.'),
    (4, 'Du verlierst die Kontrolle über den Zauber, was dich sehr Wütend macht.'),
    (5, 'Der Zauber unterwirft dich dämonischen Visionen, die dich Verängstigt zurücklassen.'),
    (6, 'Du siehst die Welt jenseits des Schleiers und erkennst deine eigene Bedeutungslosigkeit. Du fühlst dich Verzagt.'),
    (7, 'Die Magie verwüstet deinen Körper und verursacht W6 Schaden pro Kraftstufe.'),
    (8, 'Der Zauber entzieht dir deine Willenskraft; du verlierst W6 WP pro Kraftstufe.'),
    (9, 'Der Zauber lässt eine magische Krankheit mit Wirkstärke 3W6 entstehen. Du und jeder, mit dem du im nächsten Tagesabschnitt in Kontakt kommst, werden der Krankheit ausgesetzt.'),
    (10, 'Stattdessen wird ein zufälliger anderer Zauber aus deinem Repertoire mit demselben Ziel und derselben Kraftstufe ausgelöst.'),
    (11, 'Du erbrichst einen Frosch, sobald du lügst. Würfle jeden Morgen W4; bei einer 1 endet der Effekt. Er kann auch mit Aufheben beendet werden.'),
    (12, 'Gold oder Silber, das du berührst, zerfällt zu Staub. Würfle jeden Morgen W4; bei einer 1 endet der Effekt. Er kann auch mit Aufheben beendet werden.'),
    (13, 'Der Zauber blendet dich; du handelst, als befändest du dich in völliger Dunkelheit. Würfle jeden Morgen W4; bei einer 1 erholst du dich. Der Effekt kann auch mit Aufheben beendet werden.'),
    (14, 'Du wirst von Amnesie befallen und vergisst, wer du und die anderen Spielercharaktere seid. Der Effekt muss ausgespielt werden. Würfle jeden Morgen W4; bei einer 1 kehrt deine Erinnerung zurück.'),
    (15, 'Der Zauber betrifft zusätzlich einen Freund oder ein anderes unbeabsichtigtes Opfer. Ein heilender oder helfender Zauber betrifft stattdessen einen Feind.'),
    (16, 'Der Zauber schlägt fehl. Ein offensiver Zauber trifft stattdessen dich selbst. Ein schützender oder heilender Zauber verursacht stattdessen Schaden.'),
    (17, 'Du verwandelst dich in ein Tier. Würfle W6: 1 Katze, 2 Fuchs, 3 Ziege, 4 Wolf, 5 Hirsch, 6 Bär. Du erhältst die entsprechenden Werte und kannst nicht sprechen, behältst aber deinen Verstand. Würfle jeden Morgen W4; bei einer 1 nimmst du deine ursprüngliche Gestalt wieder an.'),
    (18, 'Du wirst eine Alterskategorie jünger, zum Beispiel von Erwachsen zu Jung. Deine Attribute und abgeleiteten Werte ändern sich entsprechend, deine Fertigkeitswerte jedoch nicht. Warst du bereits Jung, wirst du zu einem Kind mit -2 auf STÄ und KON (mindestens 3). Der Effekt ist dauerhaft, und du alterst normal weiter.'),
    (19, 'Du wirst eine Alterskategorie älter, zum Beispiel von Erwachsen zu Alt. Deine Attribute und abgeleiteten Werte ändern sich entsprechend, deine Fertigkeitswerte jedoch nicht. Warst du bereits Alt, wirst du sehr gebrechlich und erhältst -2 auf STÄ und KON. Der Effekt ist dauerhaft, und du alterst normal weiter.'),
    (20, 'Deine Magie zieht einen Dämon aus einer anderen Dimension an. Er erscheint im Laufe des nächsten Tagesabschnitts und greift an oder sorgt auf andere Weise für Ärger. Die Details bestimmt die Spielleitung.');

-- ============================================================
-- catalog_fear_events ("Furchttabelle", W8)
-- ============================================================

INSERT INTO catalog_fear_events (roll, name_de, effect_de) VALUES
    (1, 'Entkräftet', 'Die Angst raubt dir die Kraft und Entschlossenheit. Du verlierst 2W6 WP (bis zu einem Minimum von null) und bist Verzagt.'),
    (2, 'Erschüttert', 'Du erleidest den Zustand Verängstigt.'),
    (3, 'Keuchend', 'Die heftige Angst nimmt dir den Atem, sodass du Erschöpft bist.'),
    (4, 'Fahlbleich', 'Du und alle Spielercharaktere im Umkreis von 10 m seid Verängstigt.'),
    (5, 'Schreien', 'Du schreist vor Grauen, was dazu führt, dass alle Spielercharaktere, die den Schrei hören, ebenfalls einen Furchtangriff erleiden. Jede Person muss eine WIL-Probe gelingen, um demselben Furchtangriff zu widerstehen.'),
    (6, 'Rasend', 'Deine Angst verwandelt sich in Zorn, und du bist in deinem nächsten Zug gezwungen, ihre Quelle anzugreifen – im Nahkampf, wenn möglich. Außerdem bist du Wütend.'),
    (7, 'Erstarrt', 'Du bist starr vor Schreck und kannst dich nicht bewegen. In deinem nächsten Zug kannst du weder eine Aktion noch eine Bewegung durchführen. Lege in jedem folgenden Zug eine weitere WIL-Probe ab (keine Aktion), um die Erstarrung zu lösen.'),
    (8, 'Völlig panisch', 'In einem Anfall unkontrollierter Panik flüchtest du so schnell du kannst vom Ort des Geschehens. In deinem nächsten Zug musst du mit einem Sprint vor der Quelle deiner Angst fliehen. Lege in jedem folgenden Zug eine weitere WIL-Probe ab (keine Aktion), um die Flucht zu beenden und wieder wie üblich zu handeln.');

-- ============================================================
-- Enrich the 3 poison items (seeded in migrate_catalog_extras.sql with only
-- a "see page X" placeholder) with the real full/limited-effect text now
-- transcribed above.
-- ============================================================

UPDATE catalog_items SET description_de =
    'Volle Wirkung: In deinem Zug erleidest du in jeder Runde W6 Schaden, bis deine TP auf null sinken. Nimmst du rechtzeitig ein Gegengift ein, wird die Wirkung unterbrochen. Eingeschränkte Wirkung: Bei deinem nächsten Zug erleidest du W6 Schaden.'
    WHERE name_de = 'Gift, tödlich (Dosis)';

UPDATE catalog_items SET description_de =
    'Volle Wirkung: Du bist Erschöpft und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, kannst du dich in dieser Runde weder bewegen noch eine Aktion durchführen (nicht einmal Freie Aktionen). Die Wirkung lässt nach einem Viertel oder der Einnahme eines Gegengifts nach. Eingeschränkte Wirkung: Du bist Erschöpft.'
    WHERE name_de = 'Gift, lähmend (Dosis)';

UPDATE catalog_items SET description_de =
    'Volle Wirkung: Du bist Benommen und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, schläfst du ein und wachst erst nach einer ganzen Schicht wieder auf. Sobald du ein Gegengift erhältst oder wenigstens einen Schadenspunkt erleidest, wachst du auf. Eingeschränkte Wirkung: Du bist Benommen.'
    WHERE name_de = 'Gift, einschläfernd (Dosis)';
