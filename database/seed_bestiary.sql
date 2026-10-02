SET NAMES utf8mb4;

-- Bestiary-Vorlagen aus dem Regelwerk (Kapitel 7, Seiten 85-99), aus den
-- Screenshots in docs/bilder/ ins Deutsche übertragen. Riesenspinne und
-- Vampirfledermaus stehen schon in seed_ridderhohe.sql und fehlen hier.
-- Varianten ohne eigene Angriffstabelle (Skelett, Ork, Goblin) tragen ihr
-- Profil in kit_de. Grimmigkeit und Größe sind '—', wo das Regelwerk sie
-- nicht angibt. Nicht im Regelwerk stehende Alltagsmenschen (Bürger, Wache,
-- Räuber ...) sind hier bewusst nicht erfunden.

-- ============================================================
-- Gruftschrecken
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Gruftschrecken', 'Untot', 38, '2', 'Normal', 10, 'Wie Rüstung',
     'Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden.',
     NULL, NULL,
     'Typische Ausrüstung: Morgenstern, Kettenhemd');
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Unheiliges Gebrüll!', 'Der zerfallene Schädel des Gruftschreckens verzieht sich zu einem grausigen Schrei, der wie eine rostige Klinge durch die Seelen der Charaktere schneidet. Alle innerhalb von 10 m erleiden einen Furchtangriff.'),
    (@id, '2', 'Schauderhafter Blick!', 'Ein unglücklicher Charakter starrt direkt in die schrecklichen Augen der Kreatur, und ein pfeifendes Geräusch dringt aus ihrer Kehle. Das Opfer wird Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (@id, '3', 'Hand der Toten!', 'Der Gruftschrecken hebt die Hand und gestikuliert in Richtung eines Charakters innerhalb von 10 m. Dieser wird 2W4 m weit weggeschleudert und landet auf dem Rücken. Der Angriff verursacht denselben Wert als Schaden, und ihm kann nicht ausgewichen werden.'),
    (@id, '4', 'Rundumschlag!', 'Mit überraschender Schnelligkeit schwingt der Gruftschrecken seine Waffe in einem tödlichen Angriff. Alle Charaktere innerhalb von 2 m erleiden Waffenschaden. Der Angriff kann pariert werden.'),
    (@id, '5', 'Lähmende Kälte!', 'Der Gruftschrecken packt einen unglücklichen Charakter, der die Kälte des Todes durch seinen Körper kriechen spürt. Das Opfer erleidet W6 Schaden (Rüstung schützt nicht) und muss in seinem nächsten Zug eine Ausweichen-Probe ablegen (zählt nicht als Aktion), um überhaupt handeln zu können. Misslingt sie, ist im folgenden Zug ein neuer Versuch möglich. Außerdem ist das Opfer nun kalt und kann keine TP oder WP heilen, bis es sich wieder aufgewärmt hat.'),
    (@id, '6', 'Mächtiger Angriff!', 'Mit knarrenden Gelenken schwingt der Gruftschrecken seine Waffe in einem kraftvollen Angriff gegen einen Charakter. Der Schaden wird mit der doppelten Anzahl der normalen Würfel der Waffe gewürfelt, und das Opfer wird zu Boden geworfen. Der Angriff kann pariert werden.');

-- ============================================================
-- Geist
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Geist', 'Untot', 27, '2', 'Normal', 12, '—',
     NULL,
     'Geister sind körperlose Wesen und immun gegen jeglichen Schaden außer durch Magie und Feuer. Ein besiegter Geist wird nur für einen Tagesabschnitt gebannt; danach kehrt er zurück. Die einzige Möglichkeit, ihn dauerhaft zu bannen, ist der Zauber Verbannen oder die Lösung des Problems, das ihn an die Welt der Lebenden bindet.',
     'Überredbar: Anders als andere Monster kann ein Geist für gewöhnlich überredet werden, wenn auch mit einem Nachteil auf den Wurf.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Geisterschlag!', 'Der Geist stürzt sich auf einen Charakter innerhalb von 10 m und trifft ihn mit großer Kraft. Das Opfer wird 2W6 m zurückgeschleudert, erleidet denselben Wert an Wuchtschaden und landet auf dem Rücken.'),
    (@id, '2', 'Berührung des Todes!', 'Der Geist stößt seine durchscheinende Hand in die Brust eines unglücklichen Charakters und umklammert dessen Herz. Das Opfer erleidet 2W10 Schaden und wird Verängstigt. Die Rüstung schützt nicht.'),
    (@id, '3', 'Geisterschrei!', 'Das Gesicht des Untoten verzerrt sich zu einer grässlichen Fratze, und er stößt einen Schrei aus, der die Seelen aller innerhalb von 10 m erstarren lässt. Alle erleiden einen Furchtangriff.'),
    (@id, '4', 'Todesblick!', 'Der Geist ragt über einem Charakter auf und starrt ihm direkt in die Seele. Das Opfer sieht sein Leben vor seinem inneren Auge vorbeiziehen und wird von grotesken Visionen all seiner toten Freunde und Feinde gequält. Es wird Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (@id, '5', 'Geisterhafte Umarmung!', 'Mit einem unheimlichen Keuchen erscheint der Geist plötzlich direkt vor einem Abenteurer innerhalb von 10 m und schlingt sich in einer tödlichen Umarmung um ihn, um den Funken seines Lebens zu ersticken. Der Angriff verursacht 3W6 Wuchtschaden und lässt das Opfer Benommen zurück.'),
    (@id, '6', 'Kälteangriff!', 'Der Geist packt einen Charakter und lässt die eisige Kälte des Todes durch dessen Körper strömen. Das Opfer erleidet 2W8 Schaden und kann keine TP oder WP heilen, bevor es einen Tagesabschnitt an einem warmen Ort verbracht hat. Die Rüstung schützt nicht.');

-- ============================================================
-- Skelett (Krieger / Bogenschütze / Champion)
-- ============================================================

SET @skelett_resistances = 'Erleidet halben Stichschaden (aufgerundet).';
SET @skelett_immunities = 'Skelette sind immun gegen Furcht und Überreden.';
SET @skelett_traits = 'Kein Monster: Skelette zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.';

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Skelett – Krieger', 'Untot', 8, '—', '—', 8, 'Beschlagenes Leder (2)', @skelett_resistances, @skelett_immunities, @skelett_traits,
     'Schadensbonus: —
Fertigkeiten: Wahrnehmung 8, Ausweichen 6
Typische Waffe: Kurzschwert (Fertigkeitswert 12, Schaden W10)'),
    ('Skelett – Bogenschütze', 'Untot', 8, '—', '—', 8, 'Lederrüstung (1)', @skelett_resistances, @skelett_immunities, @skelett_traits,
     'Schadensbonus: —
Fertigkeiten: Wahrnehmung 8, Ausweichen 6
Typische Waffen: Dolch (Fertigkeitswert 10, Schaden W8), Armbrust (Fertigkeitswert 12, Schaden 2W6)'),
    ('Skelett – Champion', 'Untot', 24, '—', '—', 10, 'Kettenhemd (4)', @skelett_resistances, @skelett_immunities, @skelett_traits,
     'Schadensbonus: STÄ +W6 · WP: 15
Fertigkeiten: Wahrnehmung 12, Ausweichen 8
Fähigkeiten: Veteran, Defensiv, Doppelhieb, Robust ×4
Typische Waffe: Langschwert (Fertigkeitswert 16, Schaden 2W8), großer Schild');

-- ============================================================
-- Troll
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Troll', 'Monster', 38, '2', 'Groß', 10, '—', NULL, NULL,
     'Regeneration: Ein Troll heilt in jedem seiner Züge automatisch W6 TP.
Empfindlich gegen Sonnenlicht: In direktem Sonnenlicht erleidet ein Troll W6 Schaden pro Runde und kann sich nicht regenerieren. Erreicht er dadurch 0 TP, wird er zu Stein. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.
Überredbar: Anders als andere Monster kann ein Troll für gewöhnlich überredet werden, wenn auch mit einem Nachteil auf den Wurf.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Trollgekotze!', 'Der Troll räuspert sich mit donnerndem Grollen, hustet tief aus der Lunge und erbricht eine Kaskade aus Galle und stinkendem Sumpfwasser. Alle Abenteurer innerhalb von 6 m erleiden einen Zustand ihrer Wahl.'),
    (@id, '2', 'Zerfleischender Angriff!', 'Der Troll zerreißt den Körper eines Charakters mit seinen schmutzigen, grünschwarzen Klauen. Der Angriff verursacht W10 Hiebschaden und kann pariert werden. Ein Opfer, das Schaden erleidet, infiziert sich mit einer Krankheit der Virulenz 10.'),
    (@id, '3', 'Widerlicher Biss!', 'Der Troll öffnet sein übelriechendes Maul und beißt einen Charakter mit einem Gebiss aus Reißzähnen, Kies und alten Knochensplittern. Der Angriff verursacht 2W8 Stichschaden. Der Charakter steckt im Maul des Trolls fest und muss in jeder Runde eine STÄ-Probe ablegen (zählt als Aktion), um sich zu befreien. Bei Misserfolg erleidet das Opfer zusätzlich 2W8 Schaden.'),
    (@id, '4', 'Trollwurf!', 'Der Troll hebt einen Charakter über den Kopf und wirft ihn wie eine Stoffpuppe 2W6 m weit in eine zufällige Richtung. Das Opfer erleidet ebenso viel Wuchtschaden und landet auf dem Rücken.'),
    (@id, '5', 'Fegender Schlag!', 'Der Troll fegt mit seinen langen, knorrigen Armen umher und trifft alle Charaktere innerhalb von 2 m. Der Angriff verursacht bei jedem Opfer 2W6 Wuchtschaden.'),
    (@id, '6', 'Zermalmender Schlag!', 'Der Troll packt den nächststehenden Charakter und benutzt ihn als Waffe, indem er ihn gegen einen anderen Charakter schmettert. Beide erleiden 2W8 Wuchtschaden und werden zu Boden geworfen.');

-- ============================================================
-- Minotaurus
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Minotaurus', 'Monster', 32, '2', 'Groß', 16, '—', NULL, NULL, NULL,
     'Typische Ausrüstung: Zweihandaxt');
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Bullenfaust!', 'Eine pelzige Faust trifft einen Charakter mit voller Wucht. Der Angriff verursacht 2W6 Wuchtschaden und lässt das Opfer Benommen zurück, selbst wenn die Rüstung den Schaden verhindert.'),
    (@id, '2', 'Hufttritt!', 'Mit seinen kräftigen Beinen tritt der Minotaurus das Opfer mit den Hufen. Die Wucht schleudert es 2W6 m weit weg und verursacht denselben Wert an Wuchtschaden. Das Opfer landet auf dem Rücken.'),
    (@id, '3', 'Hornansturm!', 'Der Minotaurus senkt den Kopf und stürmt auf zwei Abenteurer zu, die höchstens 2 m voneinander entfernt stehen, um sie mit seinen spitzen Hörnern aufzuspießen. Beide erleiden 2W8 Stichschaden und werden zu Boden geworfen.'),
    (@id, '4', 'Spaltender Hieb!', 'Das Biest schwingt seine Waffe über den Kopf und lässt sie mit voller Kraft niedersausen. Der Angriff verursacht Waffenschaden plus zusätzlich W10 und kann pariert werden.'),
    (@id, '5', 'Fegender Angriff!', 'Der Minotaurus brüllt und schwingt seine Waffe in einem weiten Bogen, sodass alle innerhalb von 2 m getroffen werden. Der Angriff verursacht Waffenschaden.'),
    (@id, '6', 'Stampfangriff!', 'Der Minotaurus springt hoch in die Luft und kracht auf einen Abenteurer herab, der 2W10 Wuchtschaden erleidet und zu Boden geworfen wird.');

-- ============================================================
-- Ork (Krieger / Schamane / Häuptling)
-- ============================================================

SET @ork_traits = 'Kein Monster: Orks zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Orks einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.';

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Ork – Krieger', 'Humanoid', 12, '—', '—', 10, 'Beschlagenes Leder (2)', NULL, NULL, @ork_traits,
     'Schadensbonus: STÄ +W4
Fertigkeiten: Wahrnehmung 10, Ausweichen 8
Typische Waffe: Krummsäbel (Fertigkeitswert 12, Schaden 2W6)'),
    ('Ork – Schamane', 'Humanoid', 10, '—', '—', 10, '—', NULL, NULL, @ork_traits,
     'Schadensbonus: — · WP: 10
Fertigkeiten: Animismus 14, Wahrnehmung 12, Ausweichen 8
Zauber: Wurzelgriff, Blitzschlag, Wunden heilen
Typische Waffe: Stab (Fertigkeitswert 10, Schaden W8)'),
    ('Ork – Häuptling', 'Humanoid', 24, '—', '—', 10, 'Kettenhemd (4)', NULL, NULL, @ork_traits,
     'Schadensbonus: STÄ +W6 · WP: 15
Fertigkeiten: Wahrnehmung 14, Ausweichen 12
Fähigkeiten: Veteran, Defensiv, Zweiwaffenkampf, Robust ×4
Typische Waffe: zwei Krummsäbel (Fertigkeitswert 16, Schaden 2W6)');

-- ============================================================
-- Harpyie
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Harpyie', 'Monster', 12, '1/Harpyie', 'Normal', 24, '—', NULL, NULL,
     'TP: 12 pro Harpyie.
Schwarm: Harpyien kämpfen gemeinsam, und ihre Monsterangriffe werden von mehreren Harpyien als Gruppe ausgeführt. Diese Angriffe verbrauchen dennoch nur den Zug einer Harpyie pro Runde. Sobald die Hälfte des Schwarms getötet wurde, flieht der Rest und kehrt später zurück, wenn sich eine günstige Gelegenheit bietet.
Flügel: Harpyien greifen aus der Luft an und können nur mit Fernkampfwaffen oder langen Nahkampfwaffen bekämpft werden.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Bedrohliches Gekreische!', 'Die Harpyien überschütten die Abenteurer mit schrecklichen Beschreibungen dessen, was sie mit ihnen vorhaben. Alle innerhalb von 10 m müssen eine WIL-Probe bestehen, um der Furcht zu widerstehen.'),
    (@id, '2', 'Koordinierter Angriff!', 'Die Harpyien scharen sich zusammen und greifen den Charakter an, der das meiste Metall trägt. Der Angriff verursacht 2W6 Hiebschaden. Bei einem Treffer wird das Opfer außerdem in die Luft gehoben und aus W3+3 m Höhe fallen gelassen.'),
    (@id, '3', 'Tod von oben!', 'Die Harpyien werfen Steine und anderen Unrat aus der Ferne. Alle innerhalb von 10 m erleiden W6 Wuchtschaden.'),
    (@id, '4', 'Augenkratzen!', 'Die Kreaturen haben es auf die Augen eines unglücklichen Charakters abgesehen und wollen sie mit ihren scharfen Klauen ausstechen. Der Angriff verursacht 2W6 Stichschaden, und das Opfer ist geblendet und handelt, als wäre es in völliger Dunkelheit, bis zum Ende des Viertels.'),
    (@id, '5', 'Massenangriff!', 'Die Harpyien teilen sich auf und greifen so viele Charaktere innerhalb von 10 m an, wie einzelne Harpyien vorhanden sind. Jeder Angriff verursacht W8 Hiebschaden.'),
    (@id, '6', 'Exkrementangriff!', 'Die Harpyien öffnen ihre Kloaken und Mäuler und lassen einen Regen aus Erbrochenem und Exkrementen auf die Charaktere niedergehen. Alle innerhalb von 10 m erleiden einen Zustand ihrer Wahl. Der Angriff kann mit einem Schild pariert werden.');

-- ============================================================
-- Mantikor
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Mantikor', 'Monster', 44, '2', 'Groß', 16, '—', NULL, NULL, NULL, NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Schwanzstoß!', 'Der Mantikor zielt mit den Stacheln seines Schwanzes auf einen Charakter innerhalb von 20 m. Der Angriff verursacht 2W12 Stichschaden, und das Opfer wird mit einem Lähmungsgift der Wirkstärke 12 infiziert. Der Angriff kann mit einem Schild pariert werden.'),
    (@id, '2', 'Messerscharfer Biss!', 'Der Mantikor beißt einen Charakter mit seinen zahlreichen Fangzähnen und verursacht 3W8 Hiebschaden.'),
    (@id, '3', 'Klauenangriff!', 'Die Bestie rennt auf einen Charakter zu, wirft ihn um und zerfetzt ihn mit ihren scharfen Klauen. Der Angriff verursacht 2W8 Hiebschaden, plus W6, da das Opfer am Boden liegt.'),
    (@id, '4', 'Fegender Angriff!', 'Der Mantikor peitscht mit dem Schwanz nach zwei Charakteren. Beide Opfer erleiden 2W6 Hiebschaden und werden zu Boden geworfen.'),
    (@id, '5', 'Vernichtender Ansturm!', 'Mit voller Kraft stürmt die Bestie auf den Charakter mit der höchsten STÄ innerhalb von 10 m zu. Der Angriff verursacht 3W6 Wuchtschaden, und das Opfer wird zu Boden geworfen.'),
    (@id, '6', 'Stachelregen!', 'Der Mantikor schleudert mit seinem Schwanz einen Regen tödlicher Stacheln. Alle Abenteurer innerhalb von 10 m erleiden W10 Stichschaden und werden mit einem Lähmungsgift der Wirkstärke 12 infiziert.');

-- ============================================================
-- Goblin (Späher / Krieger)
-- ============================================================

SET @goblin_traits = 'Kein Monster: Goblins zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Goblins einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.';

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Goblin – Späher', 'Humanoid', 9, '—', '—', 10, 'Lederrüstung (1)', NULL, NULL, @goblin_traits,
     'Schadensbonus: —
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12
Typische Waffen: Kurzbogen (Fertigkeitswert 12, Schaden W10), Kurzschwert (Fertigkeitswert 10, Schaden W10)'),
    ('Goblin – Krieger', 'Humanoid', 10, '—', '—', 10, 'Beschlagenes Leder (2)', NULL, NULL, @goblin_traits,
     'Schadensbonus: —
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12
Typische Waffe: Langspeer (Fertigkeitswert 12, Schaden 2W8)');

-- ============================================================
-- Greif
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Greif', 'Tier', 38, '2', 'Groß', 30, '—', NULL, NULL,
     'Flügel: Die mächtigen Flügel des Greifs erlauben es ihm, sich frei durch die Luft zu bewegen.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Schnappender Schnabel!', 'Die Bestie reißt mit ihrem rasiermesserscharfen Schnabel an einem Charakter und verursacht 2W8 Stichschaden.'),
    (@id, '2', 'Aufbäumender Schlag!', 'Der Greif bäumt sich vor einem Charakter auf und versucht, ihn mit W6 schnellen Hieben in Stücke zu reißen. Jeder Hieb verursacht W8 Hiebschaden. Dem Angriff kann ausgewichen werden, oder er kann pariert werden, jedoch nur jeweils ein Hieb.'),
    (@id, '3', 'Fegende Klauen!', 'Der Greif fegt mit seinen Vorderklauen in einem weiten Bogen und greift alle Charaktere innerhalb von 2 m an. Jedes Opfer erleidet W8 Hiebschaden und wird zu Boden geworfen.'),
    (@id, '4', 'Greifenwurf!', 'Die Bestie packt einen Charakter mit dem Schnabel und schleudert ihn mit einem Ruck des Kopfes weg. Der Angriff verursacht 2W6 Stichschaden. Das Opfer wird ebenso viele Meter weit geschleudert und landet auf dem Rücken.'),
    (@id, '5', 'Wirbelwind!', 'Der Greif erzeugt mit seinen kräftigen Flügeln einen Wirbelwind, der alle Charaktere innerhalb von 10 m wegbläst. Die Opfer landen W6 m entfernt und erleiden denselben Wert an Wuchtschaden.'),
    (@id, '6', 'Tiefer Fall!', 'Der Greif packt einen Charakter mit seinen Klauen und trägt ihn in den Himmel. Sofern das Opfer dem Angriff nicht ausweicht, ergreift der Greif es und fliegt 2W6+6 m hoch in die Luft. In seinem nächsten Zug lässt der Greif das Opfer fallen (statt eines neuen Monsterangriffs), und es erleidet Sturzschaden.');

-- ============================================================
-- Riese
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Riese', 'Riese', 74, '1', 'Riesig', 18, '—', NULL, NULL,
     'Waffen: Riesen tragen oft eine große Waffe. Verliert der Riese seine Waffe, werden die Monsterangriffe Nr. 1 und Nr. 4 neu gewürfelt.
Schwachstelle: Angriffe gegen die Schwachstelle am Scheitel des Riesenkopfes verursachen doppelten Schaden. Den Scheitel zu treffen erfordert entweder einen Fernangriff mit einem Nachteil aus erhöhter Position oder dass der Angreifer zuerst auf den Riesen klettert. Letzteres erfordert eine Akrobatik-Probe mit Nachteil. Wer oben angekommen ist, muss in jedem Zug eine weitere Akrobatik-Probe ablegen (zählt nicht als Aktion), um nicht abgeschüttelt zu werden und 2W6 Sturzschaden zu erleiden.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Vernichtender Schlag!', 'Der Riese schwingt seine Waffe über den Kopf und drischt mit aller Kraft auf einen Charakter ein. Der Angriff verursacht 4W10 Wuchtschaden, und das Opfer wird zu Boden geworfen.'),
    (@id, '2', 'Gebrüll!', 'Der Riese stößt ein dröhnendes Brüllen aus, das den Abenteurern die Haare zu Berge stehen lässt. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff.'),
    (@id, '3', 'Stampfangriff!', 'Der Riese nimmt zwei Charaktere ins Visier, die höchstens 4 m voneinander entfernt stehen, und versucht, sie zu zertrampeln. Jeder Getroffene erleidet 4W6 Wuchtschaden und wird zu Boden geworfen.'),
    (@id, '4', 'Fegender Schlag!', 'Der Riese schwingt seine Waffe gegen alle Abenteurer innerhalb von 10 m. Jeder Getroffene erleidet 2W10 Wuchtschaden.'),
    (@id, '5', 'Kraftvoller Wurf!', 'Der Riese hat genug von einem Charakter, packt ihn und versucht, ihn zu werfen. Der Angriff verursacht 4W8 Wuchtschaden, und das Opfer wird ebenso viele Meter in eine zufällige Richtung geschleudert und landet auf dem Rücken.'),
    (@id, '6', 'Zerschmetternder Angriff!', 'Vor Wut außer sich zerschmettert der Riese den Charakter mit seinen Füßen, Fäusten und seiner Waffe in einem Rausch schneller Schläge. Alle innerhalb von 2 m erleiden 3W6 Wuchtschaden und werden zu Boden geworfen.');

-- ============================================================
-- Drache
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Drache', 'Drache', 84, '3', 'Riesig', 24, '6', NULL, NULL,
     'Flügel: Die mächtigen Flügel des Drachen erlauben es ihm, sich frei durch die Luft zu bewegen.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Drachengebrüll!', 'Der Drache öffnet sein Maul und stößt ein eisiges Brüllen aus. Alle Charaktere innerhalb von 20 m erleiden einen Furchtangriff, mit einem Nachteil auf die WIL-Probe.'),
    (@id, '2', 'Klauenangriff!', 'Der Drache fegt mit seinen Klauen nach zwei Charakteren, die jeweils 2W10 Hiebschaden erleiden.'),
    (@id, '3', 'Drachenwind!', 'Der Drache schlägt mit seinen großen Flügeln und erzeugt eine gewaltige Windböe, die alle Abenteurer innerhalb von 10 m trifft. Lose Gegenstände und Kreaturen bis zu menschlicher Größe im Wirbelwind werden 2W6 m weit geschleudert, erleiden denselben Wert an Wuchtschaden und landen auf dem Rücken.'),
    (@id, '4', 'Schwanzschlag!', 'Der Drache fegt mit seinem stacheligen Schwanz über seine Opfer. Alle Charaktere innerhalb von 6 m erleiden 2W8 Wuchtschaden und werden zu Boden geworfen.'),
    (@id, '5', 'Drachenbiss!', 'Das Biest öffnet seinen gewaltigen Kiefer und verschlingt ein Opfer mit erschreckender Geschwindigkeit. Der Angriff verursacht 4W10 Hiebschaden.'),
    (@id, '6', 'Feueratem!', 'Der Drache ragt in seiner ganzen Pracht über den Charakteren auf und entfesselt einen verheerenden Feuersturm aus seinem Maul. Das Feuer bildet einen Kegel von 10 m Länge, dessen Breite an jeder Stelle der Entfernung zum Maul des Drachen entspricht. Jeder Charakter, der von den Flammen getroffen wird, erleidet 3W10 Schaden. Die Rüstung schützt nicht.');

-- ============================================================
-- Dämon
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Dämon', 'Dämon', 64, '2', 'Groß', 16, '4', NULL, NULL,
     'Beispielwerte: Dämonen erscheinen in allen Formen und Größen, ihr Aussehen ist jedoch stets furchteinflößend. Die Werte hier sind nur ein Beispiel.',
     NULL);
SET @id = LAST_INSERT_ID();

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de) VALUES
    (@id, '1', 'Dämonische Furcht!', 'Der Dämon zischt schreckliche Drohungen in einer uralten, furchtbaren Sprache. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff.'),
    (@id, '2', 'Klauenangriff!', 'Der Dämon lächelt und schlitzt einen Charakter mit seinen scharfen Klauen auf. Der Angriff verursacht 2W10 Hiebschaden und kann pariert werden.'),
    (@id, '3', 'Fluch!', 'Der Dämon zeigt auf einen unglücklichen Charakter innerhalb von 10 m und singt einen uralten Fluch. Dem Angriff kann nicht ausgewichen werden, und alle Flüche außer Nr. 6 können mit dem Zauber Magie bannen (Kraftstufe 1) aufgehoben werden. Würfle W6:
1: Das Opfer erbricht einen Frosch, sobald es lügt. Würfle jeden Morgen W4. Bei einer 1 endet die Wirkung.
2: Alles Gold oder Silber, das das Opfer berührt, zerfällt zu Staub. Würfle jeden Morgen W4. Bei einer 1 endet die Wirkung.
3: Das Opfer ist geblendet und handelt, als wäre es in völliger Dunkelheit. Würfle jeden Tagesabschnitt W4. Bei einer 1 endet die Wirkung.
4: Das Opfer wird von Amnesie geschlagen und vergisst seinen eigenen Namen und wer die anderen Spielercharaktere sind. Die Wirkung muss ausgespielt werden. Würfle jeden Morgen W4. Bei einer 1 kehrt die Erinnerung zurück.
5: Das Opfer verwandelt sich in ein Tier. Würfle W6: 1: Katze, 2: Fuchs, 3: Ziege, 4: Wolf, 5: Hirsch, 6: Bär. Das Opfer erhält die Werte des Tieres (siehe Gemeine Tiere) und kann nicht sprechen. Würfle jeden Tagesabschnitt W4. Bei einer 1 endet die Wirkung.
6: Das Opfer wird eine Alterskategorie älter, zum Beispiel von Erwachsen zu Alt. Seine Attribute und abgeleiteten Werte ändern sich gemäß der Tabelle im Regelwerk, die Fertigkeitswerte jedoch nicht. Der Effekt ist dauerhaft. Wer bereits alt ist, wird gebrechlich und erhält −2 auf STÄ und KON.'),
    (@id, '4', 'Ungezügelte Wildheit!', 'Der Dämon streckt die Hand nach einem Opfer innerhalb von 10 m aus. Das Opfer wird mit ungeheurer Wucht 2W8 m rückwärts geschleudert, erleidet denselben Wert an Wuchtschaden und landet auf dem Rücken.'),
    (@id, '5', 'Skorpionstich!', 'Das Biest hebt seinen skorpionartigen Schwanz und versetzt seinem Opfer einen schnellen Stich. Der Angriff verursacht W12 Stichschaden, und ein Opfer, das mindestens 1 Punkt Schaden erleidet, wird zusätzlich mit einem Lähmungsgift der Wirkstärke 16 infiziert. Der Angriff kann pariert werden.'),
    (@id, '6', 'Besessen!', 'Der Dämon starrt einen Charakter innerhalb von 10 m an und übernimmt die volle Kontrolle über dessen Körper. Das Opfer muss eine WIL-Probe mit Nachteil ablegen (zählt nicht als Aktion). Misslingt sie, muss es sofort eine Bewegung und eine Aktion nach Wahl des Dämons ausführen, außer Aktionen, die WP kosten. Außerdem verliert das Opfer seinen nächsten Zug.');

-- ============================================================
-- Gemeine Tiere (Werte direkt aus der Tabelle des Regelwerks)
-- ============================================================

INSERT INTO catalog_bestiary (name_de, category_de, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de) VALUES
    ('Katze', 'Tier', 4, '—', '—', 12, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 14, Heimlichkeit 16'),
    ('Hund', 'Tier', 8, '—', '—', 14, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 14, Ausweichen 10, Heimlichkeit 12'),
    ('Ziege', 'Tier', 6, '—', '—', 10, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 12'),
    ('Esel', 'Tier', 12, '—', '—', 14, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 6'),
    ('Pferd', 'Tier', 16, '—', '—', 20, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 8'),
    ('Wildschwein', 'Tier', 14, '—', '—', 12, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 8'),
    ('Hirsch', 'Tier', 12, '—', '—', 18, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 12'),
    ('Elch', 'Tier', 18, '—', '—', 16, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 8'),
    ('Fuchs', 'Tier', 6, '—', '—', 10, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 10, Heimlichkeit 14'),
    ('Wolf', 'Tier', 10, '—', '—', 16, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 14, Ausweichen 12, Heimlichkeit 14'),
    ('Bär', 'Tier', 20, '—', '—', 12, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 8');

INSERT INTO catalog_bestiary_attacks (bestiary_id, roll_de, title_de, effect_de)
SELECT id, '—', 'Biss', 'Fertigkeitswert 8, Schaden W3' FROM catalog_bestiary WHERE name_de = 'Katze'
UNION ALL SELECT id, '—', 'Biss', 'Fertigkeitswert 12, Schaden W8' FROM catalog_bestiary WHERE name_de = 'Hund'
UNION ALL SELECT id, '—', 'Hörner', 'Fertigkeitswert 10, Schaden W6' FROM catalog_bestiary WHERE name_de = 'Ziege'
UNION ALL SELECT id, '—', 'Tritt', 'Fertigkeitswert 10, Schaden W10' FROM catalog_bestiary WHERE name_de = 'Esel'
UNION ALL SELECT id, '—', 'Tritt', 'Fertigkeitswert 10, Schaden 2W4' FROM catalog_bestiary WHERE name_de = 'Pferd'
UNION ALL SELECT id, '—', 'Hauer', 'Fertigkeitswert 12, Schaden 2W6' FROM catalog_bestiary WHERE name_de = 'Wildschwein'
UNION ALL SELECT id, '—', 'Hörner', 'Fertigkeitswert 10, Schaden W8' FROM catalog_bestiary WHERE name_de = 'Hirsch'
UNION ALL SELECT id, '—', 'Hörner', 'Fertigkeitswert 10, Schaden 2W6' FROM catalog_bestiary WHERE name_de = 'Elch'
UNION ALL SELECT id, '—', 'Biss', 'Fertigkeitswert 12, Schaden W6' FROM catalog_bestiary WHERE name_de = 'Fuchs'
UNION ALL SELECT id, '—', 'Biss', 'Fertigkeitswert 14, Schaden 2W6' FROM catalog_bestiary WHERE name_de = 'Wolf'
UNION ALL SELECT id, '—', 'Biss', 'Fertigkeitswert 12, Schaden 2W8' FROM catalog_bestiary WHERE name_de = 'Bär';

-- ============================================================
-- Die Dame des Hügels basiert auf dem allgemeinen Geist
-- ============================================================
-- (seed_ridderhohe.sql läuft vorher und legt sie mit eigenem Werteblock an;
-- die Ids der Werteblöcke 1-8 bleiben so stabil, weil die Portraits in
-- images/creatures/ nach ihnen benannt sind. Siehe auch
-- migrate_npc_kin_portrait_dame.sql.)

SET @dame_bestiary_id = (SELECT id FROM catalog_bestiary WHERE name_de = 'Die Dame des Hügels');
SET @geist_id = (SELECT id FROM catalog_bestiary WHERE name_de = 'Geist');

UPDATE campaign_npcs
SET bestiary_id = @geist_id,
    portrait_path = CONCAT('images/creatures/', @dame_bestiary_id, '.jpg')
WHERE name_de = 'Die Dame des Hügels';

DELETE FROM catalog_bestiary WHERE id = @dame_bestiary_id;
