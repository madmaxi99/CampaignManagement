SET NAMES utf8mb4;

-- Example campaign "Der Hundekampfring": the campaign owns its places, items
-- and NPCs. Everything is just name / description (read aloud) / DM text.

INSERT INTO campaigns (name_de, teaser_de, background_de, is_default) VALUES
    ('Der Hundekampfring', 'Ein Fremder sucht in Rynda nach einem verschwundenen Hund.',
     'Beispielkampagne in der Nebelmark: Alberta, die Bäckerin von Rynda, leitet im Keller einen Hundekampfring. Die Gruppe soll herausfinden, wer dort kämpfen lässt.', 0);
SET @campaign_id = LAST_INSERT_ID();
INSERT INTO campaign_chapters (campaign_id, label, position, title_de) VALUES (@campaign_id, '1', 10, 'Rynda');
SET @chapter_id = LAST_INSERT_ID();

-- Places (nested)

INSERT INTO campaign_places (campaign_id, position, name_de, description_de, dm_text_de, encounter_table_id) VALUES
    (@campaign_id, 10, 'Die Nebelmark',
     'Ein Landstrich aus Wiesen und Mooren, über dem selbst mittags ein feiner Dunst hängt. Wer hier reist, hört Wasser, aber sieht es selten.',
     'Grenzland ohne Herrscher. Die Dörfer verwalten sich selbst; Banditen und Untote sind das größere Problem als jeder Steuereintreiber.',
     (SELECT id FROM catalog_encounter_tables WHERE name_de = 'Wald'));
SET @nebelmark_id = LAST_INSERT_ID();

INSERT INTO campaign_places (campaign_id, parent_id, chapter_id, position, name_de, description_de, dm_text_de) VALUES
    (@campaign_id, @nebelmark_id, @chapter_id, 10, 'Rynda',
     'Ein kleines Dorf am Fluss. Fachwerkhäuser, ein Brunnen auf dem Platz und überall der Geruch von frischem Brot.',
     'Rund 150 Einwohner. Der Dorfvorsteher ist ein Schwächling, die eigentliche Macht liegt bei Alberta und ihrem Hundekampfring.');
SET @rynda_id = LAST_INSERT_ID();

INSERT INTO campaign_places (campaign_id, parent_id, position, name_de, description_de, dm_text_de, encounter_table_id) VALUES
    (@campaign_id, @nebelmark_id, 20, 'Die verlassene Bibliothek',
     'Ein eingestürzter Seitenflügel, Regale voller feuchter Bücher, durch das Dach fällt Licht. Es riecht nach Moder.',
     'Das Buch „Schwächen der Untoten“ steckt in der Ecke hinter dem umgekippten Regal. Wer 10 Minuten sucht, findet es ohne Probe.',
     (SELECT id FROM catalog_encounter_tables WHERE name_de = 'Ruine'));
SET @bibliothek_id = LAST_INSERT_ID();

INSERT INTO campaign_places (campaign_id, parent_id, chapter_id, position, number_label, name_de, description_de, dm_text_de) VALUES
    (@campaign_id, @rynda_id, @chapter_id, 10, '1', 'Wirtshaus „Zum schiefen Krug“',
     'Niedrige Decke, Rauch, ein Wirt, der jeden Gast mit Namen begrüßt. Auf dem Tresen klebt etwas, das einmal Honig war.',
     'Hier laufen Gerüchte zusammen. Der Wirt verkauft Roten Bahringer unter dem Tisch.');
SET @wirtshaus_id = LAST_INSERT_ID();

INSERT INTO campaign_places (campaign_id, parent_id, chapter_id, position, number_label, name_de, description_de, dm_text_de) VALUES
    (@campaign_id, @rynda_id, @chapter_id, 20, '2', 'Bäckerei Segenreich',
     'Warme Stube, hinter der Theke Regale voller Brote. Neben der Tür hängt ein Hundehalsband an einem Haken.',
     'Der Keller führt zum Hundekampfring (Zugang über eine Falltür hinter dem Mehlsack).');
SET @baeckerei_id = LAST_INSERT_ID();

INSERT INTO campaign_places (campaign_id, parent_id, chapter_id, position, number_label, name_de, description_de, dm_text_de) VALUES
    (@campaign_id, @baeckerei_id, @chapter_id, 10, '3', 'Der Hundekampfring',
     'Ein Kellerraum mit Sand auf dem Boden, Holzbänken an den Wänden und einem Käfig an der Stirnseite.',
     'Kämpfe jeden dritten Abend. Einsatz: 1 Silber. Die Hunde zählen als Wölfe, aber mit 2 TP weniger.');

-- Items of this campaign (rule items stay in the catalog)

INSERT INTO campaign_items (campaign_id, chapter_id, place_id, found_hint_de, name_de, description_de, dm_text_de, text_de) VALUES
    (@campaign_id, @chapter_id, @wirtshaus_id,
     'Unter dem Tisch, wenn der Wirt der Gruppe traut',
     'Roter Bahringer', 'Ein dunkelroter, schwerer Wein mit einem Hauch von Kirsche. Er wärmt von innen.',
     'Orvild, der Wirt und jeder Trinker der Nebelmark würden dafür einiges tun. Ein Schluck verscheucht Kälte.', NULL),
    (@campaign_id, @chapter_id, @bibliothek_id,
     'In der Ecke hinter dem umgekippten Regal, nach etwa 10 Minuten Suchen',
     'Schwächen der Untoten', 'Ein dünnes, in Leder gebundenes Buch mit Randnotizen. Zwei Seiten sind verklebt.',
     'Zeigt, dass der Gruftschrecken Silber fürchtet und dass Geister Salz nicht überqueren können. Zwei Seiten Text, kein Epos.',
     'Silber brennt, wo Stahl nur kratzt: Der Gruftschrecken weicht jeder versilberten Klinge. Geister vermögen keine Linie aus Salz zu überschreiten, ob an Tür, Fenster oder Grabstein.'),
    (@campaign_id, @chapter_id, NULL, NULL,
     'Rostiger Schlüsselring', 'Drei Schlüssel an einem verrosteten Ring. Einer ist abgebrochen.',
     'Passt zu den Fallgittern in einer Gruft. Nur ein Schloss funktioniert wirklich.', NULL);

-- NPCs

INSERT INTO campaign_npcs (campaign_id, chapter_id, place_id, name_de, description_de, dm_text_de) VALUES
    (@campaign_id, @chapter_id, @baeckerei_id, 'Alberta',
     'Eine ältere Frau mit Mehl an den Händen und einem Blick, der durch Wände geht. Sie ist die Bäckerin von Rynda.',
     'Theater: raue Stimme, unterbricht gern, wird bei Hunden weich. Geheimnis: leitet im Keller einen Hundekampfring.'),
    (@campaign_id, @chapter_id, @wirtshaus_id, 'Der Wirt Ottmar',
     'Breit, rotgesichtig und immer eine Schürze um den Bauch. Er kennt jeden Namen.',
     'Theater: leise, verschwörerisch. Verkauft Roten Bahringer unter der Hand und kennt jedes Gerücht der Nebelmark.');
