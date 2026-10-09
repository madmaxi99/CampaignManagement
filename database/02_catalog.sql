SET NAMES utf8mb4;

-- Katalog: Regelwerk-Referenzdaten (alle catalog_*-Tabellen), Endstand.
-- Pro Tabelle genau ein INSERT, in Abhängigkeitsreihenfolge. Die Ids sind fest
-- vergeben, weil Verweise (und Portrait-Dateien unter images/creatures/<id>.jpg)
-- an ihnen hängen; Lücken in den Ids sind Absicht (z. B. catalog_bestiary 3).
-- Wird nach 01_schema.sql geladen, vor 03_examples.sql.

-- ============================================================
-- Grundlagen: Attribute, Zustände, Altersstufen, Zeit, Zauberdauer und Wirkzeiten
-- ============================================================

-- catalog_attributes
INSERT INTO catalog_attributes (code, name_de) VALUES
    ('CHA', 'Charisma'),
    ('GEW', 'Gewandtheit'),
    ('INT', 'Intelligenz'),
    ('KON', 'Konstitution'),
    ('STA', 'Stärke'),
    ('WIL', 'Willenskraft');

-- catalog_conditions
INSERT INTO catalog_conditions (code, name_de, attribute_code) VALUES
    ('angry', 'Wütend', 'INT'),
    ('dazed', 'Benommen', 'GEW'),
    ('disheartened', 'Verzagt', 'CHA'),
    ('exhausted', 'Erschöpft', 'STA'),
    ('scared', 'Verängstigt', 'WIL'),
    ('sickly', 'Kränkelnd', 'KON');

-- catalog_age
INSERT INTO catalog_age (id, name_de, description_de) VALUES
    (1, 'Jung', 'GEW und KON +1'),
    (2, 'Erwachsen', '—'),
    (3, 'Alt', 'STA, GEW und KON -2, INT und WIL +1');

-- catalog_time_units
INSERT INTO catalog_time_units (code, name_de, duration_de, usage_de) VALUES
    ('runde', 'Runde', '10 Sek.', 'eine Aktion im Kampf, Verschnaufen'),
    ('tagesabschnitt', 'Tagesabschnitt', '6 Stunden', 'ein Marsch von 15 km, eine lange Rast'),
    ('viertel', 'Viertel', '15 Minuten', 'einen Raum erkunden, eine kurze Rast');

-- catalog_spell_durations
INSERT INTO catalog_spell_durations (code, name_de, time_unit_code, description_de) VALUES
    ('konzentration', 'Konzentration', NULL, 'Der Effekt endet, wenn du eine andere Handlung durchführst, Schaden erleidest oder eine WIL-Probe gegen eine plötzliche Störung (z. B. ein Geräusch) nicht schaffst, um die Konzentration aufrechtzuerhalten (keine Aktion).'),
    ('permanent', 'Dauerhaft', NULL, 'Der Effekt hält dauerhaft an.'),
    ('runde', 'Runde', 'runde', 'Der Effekt hält an, bis du in der nächsten Runde am Zug bist.'),
    ('sofort', 'Sofort', NULL, 'Der Effekt tritt sofort ein und hält nicht an.'),
    ('tagesabschnitt', 'Tagesabschnitt', 'tagesabschnitt', 'Der Effekt hält bis zum Ende des aktuellen Tagesabschnitts an.'),
    ('viertel', 'Viertel', 'viertel', 'Der Effekt hält für ein Viertel an.');

-- catalog_casting_times
INSERT INTO catalog_casting_times (code, name_de, time_unit_code, description_de) VALUES
    ('aktion', 'Aktion', NULL, 'Das Wirken des Zaubers zählt im Kampf als Aktion, sofern nicht anders angegeben.'),
    ('reaktion', 'Reaktion', NULL, 'Der Zauber wird außerhalb deines eigenen Zuges gewirkt, wie beim Parieren oder Ausweichen.'),
    ('tagesabschnitt', 'Tagesabschnitt', 'tagesabschnitt', 'Das Wirken erfordert einen ganzen Tagesabschnitt Vorbereitung (Ritual).'),
    ('viertel', 'Viertel', 'viertel', 'Das Wirken erfordert ein Viertel Vorbereitung (Ritual).');

-- ============================================================
-- Fertigkeiten, Schulen der Magie und Zauber
-- ============================================================

-- catalog_skills
INSERT INTO catalog_skills (id, name_de, attribute_code, category, description_de) VALUES
    (1, 'Akrobatik', 'GEW', 'regular', 'Für Springen, Klettern, Balancieren oder ähnliche körperliche Aktionen.'),
    (2, 'Ausweichen', 'GEW', 'regular', 'Um einem Angriff im Kampf auszuweichen.'),
    (3, 'Bestienkunde', 'INT', 'regular', 'Um Tiere oder Monster zu identifizieren oder ihre Gewohnheiten, Fähigkeiten und Schwächen zu kennen.'),
    (4, 'Darbietung', 'CHA', 'regular', 'Um mit Gesang, Gedichten, Witzen oder Ähnlichem eine Menge zu unterhalten.'),
    (5, 'Entdecken', 'INT', 'regular', 'Um Verstecktes zu finden; jeder Versuch dauert etwa eine Weile, nur ein Versuch pro Ort.'),
    (6, 'Feilschen', 'CHA', 'regular', 'Beim Handeln über den Preis einer Ware — bei Erfolg ±20 %, bei einem Drachen halbiert oder verdoppelt.'),
    (7, 'Fingerfertigkeit', 'GEW', 'regular', 'Um unbemerkt etwas zu stehlen, ein Schloss zu knacken oder andere feinmotorische Aktionen auszuführen.'),
    (8, 'Fremdsprachen', 'INT', 'regular', 'Um fremde oder alte Sprachen und Texte zu verstehen (die Gemeinsprache und die eigene Kin-Sprache beherrscht jeder automatisch).'),
    (9, 'Handwerk', 'STA', 'regular', 'Um ausgerüstetes Werkzeug zu reparieren; braucht in der Regel eine Rastdauer.'),
    (10, 'Heilkunde', 'INT', 'regular', 'Um gefallene Gefährten wieder auf die Beine zu bringen oder vor dem Tod zu bewahren.'),
    (11, 'Heimlichkeit', 'GEW', 'regular', 'Um Kampf oder Konfrontation zu vermeiden oder sich anzuschleichen; nur gegen eine aktiv suchende Wahrnehmung eine Gegenprobe.'),
    (12, 'Jagen & Fischen', 'GEW', 'regular', 'Um in der Wildnis eigene Nahrung zu finden.'),
    (13, 'Mythen & Legenden', 'INT', 'regular', 'Um sich an alte Geschichten oder Sagen aus fernen Landen zu erinnern.'),
    (14, 'Reiten', 'GEW', 'regular', 'Zum Aufsteigen und gemächlichen Reiten ohne Probe; anspruchsvollere Manöver erfordern eine Reiten-Probe.'),
    (15, 'Schwimmen', 'GEW', 'regular', 'Um sich kurz über Wasser zu halten; bei anspruchsvolleren Situationen ist eine Probe nötig.'),
    (16, 'Seefahrt', 'GEW', 'regular', 'Um ein Boot oder Kanu zu rudern oder zu paddeln; bei schwierigeren Situationen oder zum Steuern eines Schiffs braucht es eine Probe.'),
    (17, 'Täuschen', 'CHA', 'regular', 'Um überzeugend zu lügen; bei einer unglaubwürdigen Lüge Nachteil auf den Wurf.'),
    (18, 'Überzeugen', 'CHA', 'regular', 'Um jemanden durch Charme, Drohungen oder vernünftige Argumente von etwas zu überzeugen.'),
    (19, 'Wahrnehmung', 'INT', 'regular', 'Um stets wachsam zu sein und drohende Gefahren rechtzeitig zu bemerken (passive Probe möglich).'),
    (20, 'Wildnisleben', 'INT', 'regular', 'Um sicher durch die Wildnis zu führen, ein Lager aufzuschlagen, zu kochen oder in der Kälte zu überleben.'),
    (21, 'Armbrüste', 'GEW', 'combat', 'Für Angriffe mit allen Arten von Armbrüsten.'),
    (22, 'Äxte', 'STA', 'combat', 'Für den Kampf mit allen Arten von Äxten, auch als Wurfwaffe.'),
    (23, 'Bögen', 'GEW', 'combat', 'Für Angriffe mit allen Arten von Bögen (außer Armbrust).'),
    (24, 'Hämmer', 'STA', 'combat', 'Für den Kampf mit Kriegshämmern und anderen Wuchtwaffen wie Keulen.'),
    (25, 'Messer', 'GEW', 'combat', 'Für den Kampf mit Messern und Dolchen, auch als Wurfwaffe.'),
    (26, 'Prügelei', 'STA', 'combat', 'Für unbewaffneten Kampf mit Fäusten, Füßen und Zähnen.'),
    (27, 'Schleudern', 'GEW', 'combat', 'Für Angriffe mit der Schleuder.'),
    (28, 'Schwerter', 'STA', 'combat', 'Für den Kampf mit allen Arten von Schwertern.'),
    (29, 'Speere', 'STA', 'combat', 'Für Nahkampf mit Speeren, Dreizacken (auch als Wurfwaffe) sowie Lanzen.'),
    (30, 'Stäbe', 'GEW', 'combat', 'Für den Kampf mit dem Stab.'),
    (31, 'Elementarismus', 'INT', 'secondary', NULL),
    (32, 'Animismus', 'INT', 'secondary', NULL),
    (33, 'Mentalismus', 'INT', 'secondary', NULL);

-- catalog_schools
INSERT INTO catalog_schools (id, name_de, skill_id, lore_de, display_order) VALUES
    (1, 'Elementarismus', 31, NULL, 1),
    (2, 'Animismus', 32, NULL, 2),
    (3, 'Mentalismus', 33, NULL, 3),
    (5, 'Allgemein', NULL, NULL, 0);

-- catalog_spells
INSERT INTO catalog_spells (id, name_de, type, rank, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    (1, 'Aufwärmen/Abkühlen', 'trick', NULL, 1, NULL, NULL, NULL, NULL, '1 WP', 'Wärmt oder kühlt einen Radius von 10 m und schützt einmal gegen die Auswirkungen einer Kälteschicht.'),
    (2, 'Entzünden', 'trick', NULL, 1, NULL, NULL, NULL, NULL, '1 WP', 'Entzündet oder löscht eine Kerze, Fackel oder Laterne im Umkreis von 10 m.'),
    (3, 'Rauchwolke', 'trick', NULL, 1, NULL, NULL, NULL, NULL, '1 WP', 'Erzeugt eine beeindruckende Rauchwolke, die einen situativen Vorteil auf Heimlichkeit geben kann.'),
    (4, 'Feuerball', 'spell', 1, 1, 'Wort, Geste', 'aktion', '20 m', 'sofort', '2 WP je Kraftstufe', '2W6 Schaden, entzündet brennbare Objekte. +1W6 Schaden oder ein zusätzliches Ziel pro weiterer Kraftstufe.'),
    (5, 'Windstoß', 'spell', 1, 1, 'Wort, Geste', 'aktion', '10 m Kegel', 'sofort', '2 WP je Kraftstufe', 'Schleudert Kreaturen/Objekte 2W4 m zurück, gleich hoher Wuchtschaden. +1 Würfel pro weiterer Kraftstufe.'),
    (6, 'Pfeiler', 'spell', 1, 1, 'Wort, Geste', 'aktion', '10 m', 'tagesabschnitt', '2 WP je Kraftstufe', 'Hebt eine 3 m hohe Säule an; Akrobatik-Probe oder Sturz mit Sturzschaden. +3 m Höhe pro weiterer Kraftstufe.'),
    (7, 'Herbeirufen', 'trick', NULL, 5, NULL, NULL, NULL, NULL, '1 WP', 'Ein loser Gegenstand (Gewicht höchstens 1) in 10 Metern Entfernung schwebt zu dir.'),
    (8, 'Antippen', 'trick', NULL, 5, NULL, NULL, NULL, NULL, '1 WP', 'Du versetzt einem Objekt oder einer Kreatur in 10 Metern Entfernung einen magischen Stups. Der „Angriff" verursacht 1 Schadenspunkt und kann z. B. Glas zerbrechen.'),
    (9, 'Licht', 'trick', NULL, 5, NULL, NULL, NULL, NULL, '1 WP', 'Du erzeugst helles Licht, das von einem Fokus deiner Wahl ausgeht. Es erhellt einen Radius von 10 Metern um den Fokus und hält eine Weile an. Das Licht erlischt, wenn du 0 TP erreichst.'),
    (10, 'Öffnen/Schließen', 'trick', NULL, 5, NULL, NULL, NULL, NULL, '1 WP', 'Du öffnest oder schließt eine unverschlossene Tür in 10 Metern Sichtweite.'),
    (11, 'Kleidung reparieren', 'trick', NULL, 5, NULL, NULL, NULL, NULL, '1 WP', 'Kleidung, die dir oder jemandem in 10 Metern Entfernung gehört, wird sofort repariert und gereinigt.'),
    (12, 'Aufheben', 'spell', 1, 5, 'Wort, Geste', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', 'Du hebst einen bestehenden Zauber mit gleicher oder niedrigerer Kraftstufe auf. Aufheben kann auch verwendet werden, um andere magische Effekte zu beenden, falls das Abenteuer oder die Spielleitung es erlaubt.'),
    (13, 'Beschützer', 'spell', 1, 5, 'Geste, Zutat (etwas zum Zeichnen)', 'aktion', 'Berührung', 'tagesabschnitt', '2 WP je Kraftstufe', 'Schützt eine Person oder einen Ort (nicht größer als ein Mensch) vor Magie; kann auch auf dich selbst gewirkt werden. Die Kraftstufe aller gegen das Ziel gewirkten Zauber wird um die Kraftstufe von Beschützer reduziert. Kann auch gegen magische Monsterangriffe schützen (dann -1 Schadenswürfel je Kraftstufe).'),
    (14, 'Vogelgesang', 'trick', NULL, 2, NULL, NULL, NULL, NULL, '1 WP', 'Umgibt dich für eine Weile mit Vogelgesang; die Vögel geben einen Vorteil auf Wahrnehmung. Funktioniert nur im Freien.'),
    (15, 'Saubermachen', 'trick', NULL, 2, NULL, NULL, NULL, NULL, '1 WP', 'Der Raum, in dem du dich befindest, wird gereinigt, Staub und Schmutz verschwinden.'),
    (16, 'Essen kochen', 'trick', NULL, 2, NULL, NULL, NULL, NULL, '1 WP', 'Automatischer Erfolg beim Kochen ohne Wildnisleben-Probe, sofort (eine Aktion).'),
    (17, 'Blütenspur', 'trick', NULL, 2, NULL, NULL, NULL, NULL, '1 WP', 'Hübsche Blumen sprießen für eine Weile, wo du entlangläufst, und welken danach.'),
    (18, 'Frisur', 'trick', NULL, 2, NULL, NULL, NULL, NULL, '1 WP', 'Ändert Farbe, Länge und Stil deiner Haare nach Belieben; kann in manchen Situationen einen Vorteil auf Täuschen/Überzeugen geben.'),
    (19, 'Tiersprache', 'spell', 1, 2, 'Wort', 'viertel', '2 m', 'sofort', '2 WP je Kraftstufe', 'Sprich mit einem Vogel oder Säugetier, stelle so viele Fragen wie deine Kraftstufe. Tiere lügen nie, ihre Antworten sind aber schwer zu deuten.'),
    (20, 'Verbannen', 'spell', 1, 2, 'Wort, Geste, Fokus (heiliges Symbol)', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', '2W8 Schaden gegen Dämonen/Untote (+W8 je weiterer Kraftstufe), Rüstung wirkungslos, kann nicht ausgewichen oder pariert werden.'),
    (21, 'Wurzelgriff', 'spell', 1, 2, 'Geste, Zutat (Äste/Wurzeln)', 'aktion', '10 m', 'tagesabschnitt', '2 WP je Kraftstufe', 'Dornen und Wurzeln fesseln alle (außer dir) im Wirkungsbereich, sodass sie sich nicht bewegen können. Befreien erfordert eine Ausweichen-Probe – mit Vorteil bei Kraftstufe 1, normal bei Kraftstufe 2 und mit Nachteil bei Kraftstufe 3. Jeder Versuch zählt im Kampf als Aktion, pro Runde ist nur ein Versuch erlaubt; andere können helfen. Wirkt nicht auf Monster.'),
    (22, 'Blitzschlag', 'spell', 1, 2, 'Geste', 'aktion', '30 m', 'sofort', '2 WP je Kraftstufe', '2W6 Schaden; der Blitz springt zu einem weiteren zufälligen Ziel im Umkreis von 2 m (2W4 Schaden). Jede Kraftstufe über der ersten erhöht die Anzahl der Schadenswürfel um eins (z. B. 3W6 und 3W4 bei Kraftstufe 2). Metallrüstung wirkungslos; der Zauber kann wie ein Fernangriff ausgewichen oder pariert werden, dann wird kein weiteres Ziel getroffen. In Gebäuden verdoppeln sich die WP-Kosten.'),
    (23, 'Wunden heilen', 'spell', 1, 2, 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Heilt 2W6 TP (+W6 je weiterer Kraftstufe), auch bei dir selbst anwendbar.'),
    (24, 'Frost', 'spell', 1, 1, 'Wort, Geste', 'aktion', '4 m (Kugel)', 'viertel', '2 WP je Kraftstufe', 'Senkt die Temperatur drastisch; natürliche Feuer erlöschen, lebende Wesen verlieren W6 TP und W6 WP; Humanoide erstarren (Befreiung durch STA-Probe). Wasser gefriert zu begehbarem Eis.'),
    (25, 'Zerschmettern', 'spell', 1, 1, 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Zerbricht ein unbelebtes, nicht-magisches Objekt; 2W10 Schaden, Rüstung wirkungslos, +W10 je weiterer Kraftstufe.'),
    (26, 'Schloss öffnen/schließen', 'trick', NULL, 3, NULL, NULL, NULL, NULL, '1 WP', 'Öffnet oder verschließt per Berührung ein nicht-magisches Schloss.'),
    (27, 'Zauberhocker', 'trick', NULL, 3, NULL, NULL, NULL, NULL, '1 WP', 'Erzeugt eine runde Fläche zum Sitzen oder Stehen, hält bis du gehst.'),
    (28, 'Sanft fallen', 'trick', NULL, 3, NULL, NULL, NULL, NULL, '1 WP', 'Verlangsamt deinen Fall, du landest federleicht, egal aus welcher Höhe.'),
    (29, 'Schweben', 'spell', 1, 3, 'Wort, Geste', 'aktion', '6 m', 'sofort', '2 WP je Kraftstufe', 'Lässt dich oder ein Ziel menschengroß schweben (6 m in jede Richtung); je weiterer Kraftstufe +2 m oder ein weiteres Ziel. Unwillige Kreaturen erhalten einen Nachteil.'),
    (30, 'Fernsicht', 'spell', 1, 3, 'Wort, Geste', 'aktion', '1 km', 'konzentration', '2 WP je Kraftstufe', 'Sieh und höre einen bekannten oder besuchten Ort bis 1 km entfernt; je weiterer Kraftstufe verzehnfacht sich die Reichweite.'),
    (31, 'Langer Schritt', 'spell', 1, 3, 'Wort, Geste', 'aktion', 'Berührung', 'viertel', '2 WP je Kraftstufe', 'Verdoppelt die Bewegungsrate des Ziels; auch bei dir selbst anwendbar. Je weiterer Kraftstufe ein zusätzliches Ziel.'),
    (32, 'Gnom', 'spell', 3, 1, 'Wort, Geste, Zutat (Stein oder Erde)', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe', 'Voraussetzung: Steinwall. Du beschwörst einen Erdelementar. Der Gnom nimmt die Gestalt eines Humanoiden aus grau-braunem Sand und Lehm an und gilt im Kampf als Monster. Er folgt den Befehlen seines Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.

Bewegung: 8, TP: 5 pro Kraftstufe, Rüstung: 4.
Waffe – Steinfäuste: Trifft automatisch im Nahkampf (kann pariert oder ausgewichen werden) und verursacht 1W6 Wuchtschaden pro Kraftstufe.
Pfeiler: Der Gnom kann Pfeiler mit derselben Kraftstufe wirken, mit der er beschworen wurde, unter Verwendung der WP des Magiers.'),
    (33, 'Salamander', 'spell', 3, 1, 'Wort, Geste, Zutat (offenes Feuer)', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe', 'Voraussetzung: Feuerstoß. Du beschwörst einen Feuerelementar. Der Salamander nimmt die Gestalt einer feurigen Echse an und gilt im Kampf als Monster. Er folgt den Befehlen seines Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.

Bewegung: 12, TP: 5 pro Kraftstufe, Rüstung: —.
Waffe – Feuriger Griff: Trifft automatisch im Nahkampf (kann pariert oder ausgewichen werden) und verursacht 1W6 Schaden pro Kraftstufe; Rüstung hat keine Wirkung.
Feuerkugel: Der Salamander kann Feuerstoß mit derselben Kraftstufe wirken, mit der er beschworen wurde, unter Verwendung der WP des Magiers.
Resistenz: Stichschaden wird halbiert.
Immunität: Der Salamander ist immun gegen Feuerschaden, auch magisches.'),
    (34, 'Sylphe', 'spell', 3, 1, 'Wort, Geste', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe', 'Voraussetzung: Wirbelwind. Du beschwörst einen Luftelementar. Die Sylphe erscheint als sturmwolkenartiges Wesen in Vogelgestalt und gilt im Kampf als Monster. Sie folgt den Befehlen ihres Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.

Bewegung: 24, TP: 5 pro Kraftstufe, Rüstung: —.
Waffe – Heulende Winde: Trifft automatisch im Nahkampf (kann nur ausgewichen, nicht pariert werden), schleudert das Ziel 1W4 m pro Kraftstufe zurück und verursacht denselben Wuchtschaden.
Windstoß: Die Sylphe kann Windstoß mit derselben Kraftstufe wirken, mit der sie beschworen wurde, unter Verwendung der WP des Magiers.
Resistenz: Stichschaden wird halbiert.'),
    (35, 'Undine', 'spell', 3, 1, 'Wort, Geste, Zutat (Wasser)', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe', 'Voraussetzung: Flutwelle. Du beschwörst einen Wasserelementar. Die Undine erscheint wie eine Gezeitenwelle in Gestalt einer Frau, vollständig aus Wasser bestehend, und gilt im Kampf als Monster. Sie folgt den Befehlen ihres Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.

Bewegung: 12, TP: 5 pro Kraftstufe, Rüstung: —.
Waffe – Nasse Umarmung: Trifft automatisch im Nahkampf (kann nur ausgewichen, nicht pariert werden) und verursacht 1W6 Schaden pro Kraftstufe; Rüstung hat keine Wirkung.
Flutwelle: Die Undine kann Flutwelle mit derselben Kraftstufe wirken, mit der sie beschworen wurde, unter Verwendung der WP des Magiers.
Resistenz: Stichschaden wird halbiert.'),
    (36, 'Magie spüren', 'trick', NULL, 5, NULL, NULL, NULL, NULL, '1 WP', 'Du spürst, ob der Ort, an dem du dich befindest, oder ein Gegenstand, den du hältst, von Magie beeinflusst wird – und wenn ja, von welcher Art.'),
    (37, 'Magieschild', 'spell', 2, 5, 'Geste', 'reaktion', '10 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Beschützer oder Aufheben. Du greifst in den Zauber eines anderen Magiers ein. Der Zauber ist eine Reaktion und unterbricht die Initiativreihenfolge, ersetzt aber nicht deine Aktion in der Runde. Du wirkst ihn, nachdem der Gegner seinen Wurf zum Gelingen abgelegt hat, aber bevor Schaden oder ein anderer Effekt gewürfelt wird. Gelingt er, sinkt die Kraftstufe des gegnerischen Zaubers um die Kraftstufe von Magieschild; bei null oder weniger hat der gegnerische Zauber keine Wirkung. Du kannst ihn auch einsetzen, um magische Monsterangriffe zu stoppen – dann verringert jede Kraftstufe die Anzahl der Schadenswürfel um 1.'),
    (38, 'Übertragen', 'spell', 3, 5, 'Geste', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Magieschild. Du kannst WP von einem anderen humanoiden Wesen stehlen oder eigene WP auf jemanden übertragen. Du kannst bis zum Doppelten der Zauberkosten nehmen oder geben – also vier WP bei Kraftstufe 1, acht bei Kraftstufe 2 und zwölf bei Kraftstufe 3. Die zum Wirken verbrauchten WP gehen bei der Übertragung verloren. Weder du noch dein Ziel könnt dabei über das WP-Maximum steigen oder unter null fallen. Lehnt das Ziel die Übertragung ab, erhältst du einen Nachteil auf deinen Wurf.'),
    (39, 'Magiesiegel', 'spell', 4, 5, 'Wort, Geste', 'tagesabschnitt', 'Berührung', 'permanent', '2 WP je Kraftstufe', 'Voraussetzung: Übertragen. Du bindest einen Zauber an einen unbelebten Gegenstand deiner Wahl. Die Kraftstufe von Magiesiegel bestimmt die Kraftstufe des gebundenen Zaubers; einen Zaubertrick zu binden erfordert Kraftstufe 1. Beim Wirken legst du auch fest, wie der gebundene Zauber ausgelöst wird. Dann verbraucht der Zauber die WP der Person, die ihn auslöst; kann oder will sie keine WP aufwenden, wird er nicht ausgelöst. Magiesiegel lässt sich mit Aufladen kombinieren, damit der Gegenstand eigene WP besitzt – beide Rituale müssen dann nacheinander durchgeführt werden. Das Auslösen eines gebundenen Zaubers löst das Siegel auf, es sei denn, Magiesiegel wird mit Dauerhaftigkeit kombiniert.'),
    (40, 'Aufladen', 'spell', 4, 5, 'Wort, Geste', 'viertel', 'Berührung', 'tagesabschnitt', '2 WP je Kraftstufe', 'Voraussetzung: Übertragen. Du überträgst eigene WP auf einen unbelebten Gegenstand deiner Wahl, der wie eine Batterie wirkt. Jede Kraftstufe erlaubt dir, bis zu 10 WP zu übertragen. Wer den Gegenstand berührt, kann dessen WP statt der eigenen einsetzen. Nach einem Tagesabschnitt verflüchtigen sich die gespeicherten WP, es sei denn, Aufladen wird mit Dauerhaftigkeit kombiniert. Aufladen lässt sich auch mit Magiesiegel kombinieren (siehe dort).'),
    (41, 'Dauerhaftigkeit', 'spell', 5, 5, 'Wort, Geste', 'tagesabschnitt', 'Berührung', 'permanent', '2 WP je Kraftstufe', 'Voraussetzung: Magiesiegel. Dieses Ritual wird mit einem anderen Zauber kombiniert und macht ihn dauerhaft. Es kostet den Magier dauerhaft einen Punkt WIL (und senkt das WP-Maximum um eins). Die Kraftstufe von Dauerhaftigkeit muss der des dauerhaft zu machenden Zaubers entsprechen. Auf Zauber mit sofortiger Wirkung lässt sich Dauerhaftigkeit nicht anwenden. Wird sie mit Magiesiegel kombiniert, wird das Siegel dauerhaft und der gebundene Zauber kann beliebig oft ausgelöst werden.'),
    (42, 'Blitzstrahl', 'spell', 2, 2, 'Geste', 'aktion', '40 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Blitzschlag. Du rufst einen gewaltigen Blitz auf ein Ziel herab, das 2W8 Schaden erleidet. Der Blitz springt zu einem weiteren zufälligen Ziel im Umkreis von 2 m (2W6 Schaden) und dann zu einem dritten (2W4 Schaden). Jede Kraftstufe über der ersten erhöht die Anzahl der Schadenswürfel um eins. Metallrüstung wirkungslos; der Zauber kann wie ein Fernangriff ausgewichen oder pariert werden, dann wird kein weiteres Ziel getroffen. In Gebäuden verdoppeln sich die WP-Kosten.'),
    (43, 'Wunden kurieren', 'spell', 2, 2, 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Wunden heilen. Du heilst ein lebendes Wesen um 2W8 TP und von einer nicht-dauerhaften schweren Verletzung. Du kannst den Zauber auf dich selbst anwenden. Jede Kraftstufe über der ersten heilt zusätzlich W8 TP.'),
    (44, 'Läutern', 'spell', 2, 2, 'Wort, Geste, Fokus (heiliges Symbol)', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Verbannen. Du exorzierst einen Dämon oder Untoten und verursachst 2W10 Schaden an dem widernatürlichen Wesen. Jede Kraftstufe über der ersten erhöht den Schaden um W10. Rüstung und natürliche Rüstung haben keine Wirkung, der Zauber kann nicht ausgewichen oder pariert werden.'),
    (45, 'Verschlingender Wald', 'spell', 2, 2, 'Geste, Zutat (Äste oder Wurzeln in der Nähe)', 'aktion', '10 m (Kugel)', 'tagesabschnitt', '2 WP je Kraftstufe', 'Voraussetzung: Wurzelgriff. Du rufst die Geister des Waldes, die rasch Dickichte aus Dornen und Wurzeln aus dem Boden schießen lassen. Das Gebiet zählt als unwegsames Gelände, und jeder außer dir (keine Monster) im Wirkungsbereich wird von Wurzeln und Zweigen festgehalten und kann sich nicht bewegen. Befreien erfordert eine Ausweichen-Probe – mit Vorteil bei Kraftstufe 1, normal bei Kraftstufe 2 und mit Nachteil bei Kraftstufe 3. Jeder Versuch zählt im Kampf als Aktion, pro Runde ist nur ein Versuch erlaubt. Andere, die nicht festgehalten werden, können helfen.'),
    (46, 'Schlaf', 'spell', 2, 2, 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Wunden heilen. Das Ziel muss eine WIL-Probe bestehen, sonst fällt es für ein Viertel in tiefen Schlaf. SC würfeln dabei normal; NSC würfeln gegen ihr WP-Maximum (falls angegeben, um 2 verringert je Stufe der heroischen Fähigkeit Konzentriert), sonst gegen 10. Gelingt der Wurf, ist das Opfer trotzdem Benommen. Das Opfer würfelt bei Kraftstufe 1 mit Vorteil, bei Kraftstufe 2 normal und bei Kraftstufe 3 mit Nachteil. Ein Schlafender ist sehr schwer zu wecken, wacht aber bei Schaden auf. Der Zauber wirkt nur auf Lebende und nicht auf Monster.'),
    (47, 'Wiederherstellung', 'spell', 3, 2, 'Wort', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Wunden kurieren. Du heilst ein lebendes Wesen um 2W10 TP und von einer beliebigen schweren Verletzung. Du kannst den Zauber auf dich selbst anwenden. Jede Kraftstufe über der ersten heilt zusätzlich W10 TP.'),
    (48, 'Wiedererweckung', 'spell', 3, 2, 'Wort, Geste, Zutat (Leichnam)', 'tagesabschnitt', 'Berührung', 'permanent', '2 WP je Kraftstufe', 'Voraussetzung: Wunden kurieren. Du lenkst die Kräfte der Natur, um einen Toten wieder zum Leben zu erwecken – nicht als Untoten, sondern wahrhaft lebendig. Das kostet den Magier dauerhaft einen Punkt WIL (und senkt das WP-Maximum um eins). Je mehr Zeit seit dem Tod des Ziels vergangen ist, desto schwieriger ist es: Im selben Tagesabschnitt genügt Kraftstufe 1, innerhalb eines Tages ist Kraftstufe 2 nötig, innerhalb einer Woche Kraftstufe 3. Ist mehr als eine Woche vergangen, ist der Körper zu stark verwest, um ihn wiederzuerwecken. Es ist nur ein Versuch möglich – misslingt er, ist das Opfer endgültig tot. Eine wiedererweckte Person verliert W3 Fertigkeitsstufen in allen CHA-basierten Fertigkeiten (bis zu einem Minimum von 3).'),
    (49, 'Donnerkeil', 'spell', 3, 2, 'Geste', 'aktion', '50 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Blitzstrahl. Du rufst einen mächtigen Donnerkeil auf ein Ziel herab, das 2W10 Schaden erleidet. Er springt weiter zu bis zu drei zufälligen Zielen, die höchstens 2 m voneinander entfernt sind. Der Schaden beträgt 2W8 für das zweite, 2W6 für das dritte und 2W4 für das vierte Ziel. Jede Kraftstufe über der ersten erhöht die Anzahl der Schadenswürfel um eins. Metallrüstung wirkungslos; der Zauber kann wie ein Fernangriff ausgewichen oder pariert werden, dann wird kein weiteres Ziel getroffen. In Gebäuden verdoppeln sich die WP-Kosten.'),
    (50, 'Feuerstoß', 'spell', 2, 1, 'Wort, Geste', 'aktion', '30 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Feuerball. Der Zauber schleudert einen großen Feuerstoß aus deiner Hand oder deinem Fokus auf das Ziel. Er kann wie ein Fernangriff ausgewichen oder pariert werden. Bei einem Treffer verursacht er 2W8 Schaden und setzt brennbare Objekte in Brand. Jede Kraftstufe über der ersten erhöht den Schaden um W8 oder erzeugt einen weiteren Feuerstoß, der ein weiteres Ziel in Reichweite trifft.'),
    (51, 'Steinschild', 'spell', 2, 1, 'Geste, Zutat (Kieselsteine)', 'reaktion', 'Persönlich', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Pfeiler. Du beschwörst augenblicklich einen Schild aus Stein, der den Schaden eines eingehenden Angriffs um 2W6 verringert. Jede weitere Kraftstufe verringert den Schaden um zusätzlich W6. Du kannst den Zauber nach dem Treffer-Wurf, aber vor dem Schadenswurf wirken. Der Zauber lässt sich mit Rüstung kombinieren.'),
    (52, 'Steinwall', 'spell', 2, 1, 'Wort, Geste', 'aktion', '10 m', 'tagesabschnitt', '2 WP je Kraftstufe', 'Voraussetzung: Pfeiler. Der Zauber lässt aus dem Boden oder einem Steinboden eine Mauer wachsen – einen Meter dick, zwei Meter hoch und drei Meter breit. Jede weitere Kraftstufe erzeugt einen weiteren Abschnitt gleicher Größe. Steht jemand an dieser Stelle, muss das Opfer eine Akrobatik-Probe (keine Aktion) bestehen, um nicht herunterzufallen. Entsteht die Mauer unter einer niedrigen Decke und misslingt der Wurf, erleidet das Opfer stattdessen 2W6 Wuchtschaden.'),
    (53, 'Flutwelle', 'spell', 2, 1, 'Wort, Geste, Zutat (Wasserquelle)', 'aktion', '20 m Kegel', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Frost. Du beschwörst eine gewaltige Welle aus einer Wasserquelle in Reichweite. Der Wirkungsbereich beginnt an der Quelle, nicht bei dir. Alle nicht befestigten Objekte und Kreaturen im Wirkungsbereich werden 2W6 m von der Wasserquelle weggeschleudert und erleiden gleich hohen Wuchtschaden. Jede weitere Kraftstufe erhöht die Anzahl der Würfel um eins.'),
    (54, 'Wirbelwind', 'spell', 2, 1, 'Wort, Geste', 'aktion', '4 m (Kugel)', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Windstoß. Der Zauber erzeugt einen mächtigen Wirbelwind um den Magier. Alle nicht befestigten Objekte und Kreaturen bis Menschengröße im Wirkungsbereich werden 2W4 m weggeschleudert, erleiden gleich hohen Wuchtschaden und landen auf dem Boden. Jede weitere Kraftstufe erhöht die Reichweite um 4 m und verursacht weitere W4 Schaden. Mit einem Nachteil auf den Wurf kannst du eine Person in Reichweite an eine andere Stelle deiner Wahl innerhalb der Reichweite schleudern; du entscheidest, ob sie Schaden erleidet und ob sie zu Boden geht.'),
    (55, 'Feuervogel', 'spell', 3, 1, 'Wort, Geste', 'aktion', '40 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Feuerstoß. Der Zauber schleudert einen furchterregenden Feuervogel aus deiner Hand oder deinem Fokus auf das Ziel. Er kann wie ein Fernangriff ausgewichen oder pariert werden. Bei einem Treffer verursacht er 2W10 Schaden und setzt brennbare Objekte in Brand. Jede Kraftstufe über der ersten erhöht den Schaden um W10 oder erzeugt einen weiteren Feuervogel, der ein weiteres Ziel in Reichweite trifft.'),
    (56, 'Feuersturm', 'spell', 3, 1, 'Wort, Geste', 'aktion', '4 m (Kugel)', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Feuerstoß und Wirbelwind. Der Zauber erzeugt einen wirbelnden Feuersturm um dich. Alle Ziele in Reichweite erleiden 2W6 Schaden. Jede weitere Kraftstufe erhöht die Reichweite um 4 m und verursacht weitere W6 Schaden.'),
    (57, 'Kraftfaust', 'spell', 1, 3, 'Wort, Geste', 'aktion', 'Persönlich', 'viertel', '2 WP je Kraftstufe', 'Der Schaden deiner unbewaffneten Angriffe erhöht sich um W6 pro Kraftstufe.'),
    (58, 'Steinhaut', 'spell', 1, 3, 'Wort, Geste, Zutat (Stein)', 'aktion', 'Berührung', 'viertel', '2 WP je Kraftstufe', 'Die Haut des Ziels wird hart und grau und erhält Rüstungswert 4. Jede weitere Kraftstufe erhöht den Rüstungswert um zusätzlich 2. Trägst du eine Rüstung, zählt nur der höchste Rüstungswert.'),
    (59, 'Wahrsagen', 'spell', 2, 3, 'Wort, Geste', 'aktion', '100 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Fernsicht. Benenne einen Gegenstand („Waffe“, „Schwert“), einen Stoff („Gold“, „Luft“, „Wasser“), ein Wesen oder eine Art von Wesen („Zot der Magier“, „Untote“, „Orks“) oder ein Phänomen („Magie“). Der Zauber zeigt dir die Richtung zum nächsten Ziel der genannten Art innerhalb der Reichweite. Jede weitere Kraftstufe verdoppelt die Reichweite – auf 200 m bzw. 400 m.'),
    (60, 'Waffe verzaubern', 'spell', 2, 3, 'Wort, Geste', 'aktion', 'Berührung', 'viertel', '2 WP je Kraftstufe', 'Voraussetzung: Kraftfaust. Der Zauber verzaubert eine Waffe, sodass ein Ergebnis von 1–2 beim Angreifen und Parieren mit ihr als Drachenwurf zählt. Die Waffe gilt außerdem als magisch. Jede weitere Kraftstufe erhöht die Chance auf einen Drachen um 1, also 1–3 bei Kraftstufe 2 und 1–4 bei Kraftstufe 3.'),
    (61, 'Geistesschlag', 'spell', 2, 3, 'Wort, Geste', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Kraftfaust. Du projizierst deine geistige Kraft als mächtigen körperlichen Schlag. Der Angriff schleudert das Opfer 2W6 m von dir weg und verursacht gleich hohen Schaden. Jede weitere Kraftstufe erhöht den Wurf um W6. Der Zauber kann wie ein Fernangriff ausgewichen oder pariert werden.'),
    (62, 'Rückschau', 'spell', 2, 3, 'Geste', 'aktion', '10 m', 'konzentration', '2 WP je Kraftstufe', 'Voraussetzung: Fernsicht. Du erfährst von vergangenen Ereignissen an dem Ort, an dem du dich befindest, auch wenn sich niemand mehr daran erinnert. Du blickst bei Kraftstufe 1 bis zu einen Tag in der Zeit zurück, bei Kraftstufe 2 ein Jahr, bei Kraftstufe 3 Jahrhunderte. Die Visionen sind oft rätselhaft und bruchstückhaft – die Spielleitung entscheidet, was genau du siehst.'),
    (63, 'Telepathie', 'spell', 2, 3, 'Wort, Geste', 'aktion', '10 m', 'konzentration', '2 WP je Kraftstufe', 'Voraussetzung: Fernsicht. Du kannst die oberflächlichen Gedanken einer anderen Person lesen. Für tiefere Erinnerungen ist Kraftstufe 2 oder mehr nötig, je nachdem, wie frisch die Erinnerung ist; die Spielleitung hat das letzte Wort. Du kannst den Zauber auch nutzen, um eigene Gedanken an eine andere Person zu senden.'),
    (64, 'Beherrschen', 'spell', 3, 3, 'Wort, Geste', 'aktion', '10 m', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Telepathie. Du kannst die Handlungen einer anderen Person vollständig kontrollieren. Zum Wirken würfelst du einen vergleichenden Wurf gegen die WIL des Opfers. NSC würfeln gegen ihr WP-Maximum (falls angegeben, um 2 verringert je Stufe der heroischen Fähigkeit Konzentriert), sonst gegen 10. Bei Kraftstufe 1 erhältst du einen Nachteil, bei Kraftstufe 2 würfelst du normal und bei Kraftstufe 3 hast du einen Vorteil. Gewinnst du, muss das Opfer sofort eine Bewegung und eine Aktion deiner Wahl ausführen, außer Aktionen, die den Einsatz von WP erfordern. Das Opfer verliert zudem seinen nächsten Zug. Der Zauber wirkt nicht auf Monster.'),
    (65, 'Flug', 'spell', 3, 3, 'Geste', 'aktion', 'Berührung', 'viertel', '2 WP je Kraftstufe', 'Voraussetzung: Schweben. Du gibst dir selbst oder einem anderen Wesen bis Menschengröße die Fähigkeit, frei mit Bewegungsrate 6 zu fliegen. Bei Kraftstufe 2 verdoppelt sich die Bewegungsrate auf 12, bei Kraftstufe 3 auf 24. Das fliegende Wesen kann alle Hindernisse ignorieren und wird nicht durch Gelände beeinträchtigt.'),
    (66, 'Teleportieren', 'spell', 3, 3, 'Wort, Geste', 'aktion', 'Berührung', 'sofort', '2 WP je Kraftstufe', 'Voraussetzung: Fernsicht. Mit diesem Zauber teleportierst du dich bis zu 100 m weit. Du musst das Ziel sehen können oder es zuvor besucht haben. Für jede Kraftstufe über der ersten kannst du eine weitere menschengroße Kreatur, die du berührst, mitnehmen oder die Reichweite verdoppeln. Der Zauber kann nicht für Reisen zwischen Dimensionen genutzt werden.');

-- ============================================================
-- Gegenstände, Waffen und Rüstungen
-- ============================================================

-- catalog_items
INSERT INTO catalog_items (id, name_de, description_de, rarity, price_gold, price_silver, price_copper, kind) VALUES
    (1, 'Stab', 'Ein einfacher Holzstab, wie ihn Elementaristen zum Fokussieren ihrer Magie nutzen.', 'gewöhnlich', 0, 2, 0, 'weapon'),
    (2, 'Zauberbuch', 'Ein abgegriffenes Buch voller handschriftlicher Notizen zu Zaubersprüchen.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (3, 'Fackel', 'Eine Fackel, die eine Weile lang brennt, bevor sie erlischt.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (4, 'Wein', 'Eine Flasche einfacher Rotwein.', 'gewöhnlich', 0, 3, 0, 'misc'),
    (5, 'Buch', 'Ein gebundenes Buch mit unbekanntem Inhalt.', 'gewöhnlich', 25, 0, 0, 'misc'),
    (6, 'Amulett der Klarheit', 'Ein altes Amulett, das Gedanken zu ordnen scheint. Angeblich selten und begehrt.', 'selten', 5, 0, 0, 'misc'),
    (7, 'Lederrüstung', 'Einfache, flexible Rüstung aus gegerbtem Leder.', 'gewöhnlich', 2, 0, 0, 'armor'),
    (8, 'Kurzbogen', 'Ein kompakter Bogen, leichter zu handhaben als ein Langbogen.', 'gewöhnlich', 25, 0, 0, 'weapon'),
    (9, 'Langschwert', 'Ein robustes, vielseitiges Schwert.', 'gewöhnlich', 25, 0, 0, 'weapon'),
    (10, 'Schleuder', 'Eine einfache Schleuder für Wurfgeschosse.', 'gewöhnlich', 0, 1, 0, 'weapon'),
    (11, 'Breitschwert', 'Ein breites, kräftiges Schwert.', 'gewöhnlich', 12, 0, 0, 'weapon'),
    (12, 'Dreschflegel', 'Ein Kriegsflegel, ursprünglich ein Dreschwerkzeug.', 'gewöhnlich', 16, 0, 0, 'weapon'),
    (13, 'Lanze', 'Eine lange Reiterlanze für den berittenen Kampf.', 'gewöhnlich', 12, 0, 0, 'weapon'),
    (14, 'Leichte Armbrust', 'Eine kompakte Armbrust, schneller nachzuladen als schwere Modelle.', 'gewöhnlich', 75, 0, 0, 'weapon'),
    (15, 'Dreizack', 'Eine dreizackige Stichwaffe, beliebt bei Seefahrern.', 'gewöhnlich', 5, 0, 0, 'weapon'),
    (16, 'Offener Helm', 'Ein einfacher Helm, der das Gesicht frei lässt.', 'gewöhnlich', 12, 0, 0, 'armor'),
    (17, 'Großhelm', 'Ein massiver, geschlossener Helm.', 'gewöhnlich', 100, 0, 0, 'armor'),
    (18, 'Kampfpferd', 'Ein für den Kampf abgerichtetes Pferd.', 'selten', 400, 0, 0, 'misc'),
    (19, 'Esel', 'Ein robustes Lasttier.', 'gewöhnlich', 12, 0, 0, 'misc'),
    (20, 'Karren', 'Ein Karren, gezogen von einem Pferd oder Esel. Bietet Platz für zwei Personen und 50 Gewichtseinheiten.', 'gewöhnlich', 15, 0, 0, 'misc'),
    (21, 'Kriegshammer, klein', 'Ein kompakter Kriegshammer.', 'gewöhnlich', 10, 0, 0, 'weapon'),
    (22, 'Schmiedewerkzeug', 'Werkzeug eines Schmieds: Hammer, Zange und Feile.', 'gewöhnlich', 20, 0, 0, 'misc'),
    (23, 'Zimmermannswerkzeug', 'Werkzeug eines Zimmermanns: Säge, Beil und Maßband.', 'gewöhnlich', 8, 0, 0, 'misc'),
    (24, 'Gerberwerkzeug', 'Werkzeug eines Gerbers zur Lederverarbeitung.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (25, 'Notizbuch', 'Ein leeres Notizbuch für Beobachtungen und Skizzen.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (26, 'Feder', 'Eine Schreibfeder samt kleinem Tintenfass.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (27, 'Bandagen', 'Sauberer Verbandsstoff für Wundversorgung.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (28, 'Orbuculum', 'Ein magisches Hilfsmittel, mit dem ein Magier neue Zauber studiert.', 'ungewöhnlich', 18, 0, 0, 'misc'),
    (29, 'Zauberstab', 'Ein schlanker Stab, der als magischer Fokus dient.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (30, 'Amulett', 'Ein einfaches Amulett, das als magischer Fokus dient.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (31, 'Grimoire', 'Ein Zauberbuch, in dem ein Magier seine bekannten Zauber festhält. Neu erschaffene Magier erhalten automatisch eines.', 'einzigartig', 50, 0, 0, 'misc'),
    (32, 'Leier', 'Ein kleines Saiteninstrument. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1.', 'gewöhnlich', 20, 0, 0, 'misc'),
    (33, 'Flöte', 'Eine einfache Holzflöte. Senkt die WP-Kosten der Musiker-Fähigkeit auf 2.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (34, 'Horn', 'Ein Blashorn für Signale und Musik. Erhöht die Reichweite der Musiker-Fähigkeit auf 100 Meter.', 'gewöhnlich', 6, 0, 0, 'misc'),
    (35, 'Parierdolch', 'Ein schmaler Dolch, eigens zum Parieren geformt.', 'ungewöhnlich', 2, 0, 0, 'weapon'),
    (36, 'Morgenstern', 'Ein Streitkolben mit metallenem, dornenbesetztem Kopf.', 'ungewöhnlich', 14, 0, 0, 'weapon'),
    (37, 'Kriegshammer, schwer', 'Ein wuchtiger, beidhändig geführter Kriegshammer.', 'ungewöhnlich', 20, 0, 0, 'weapon'),
    (38, 'Hellebarde', 'Eine lange Stangenwaffe mit Axtklinge und Spitze.', 'selten', 20, 0, 0, 'weapon'),
    (39, 'Schild, groß', 'Ein großer, schwerer Schild.', 'ungewöhnlich', 12, 0, 0, 'weapon'),
    (40, 'Keule', 'Ein einfacher, wuchtiger Streitkolben.', 'gewöhnlich', 8, 0, 0, 'weapon'),
    (41, 'Schwere Armbrust', 'Eine mächtige Armbrust mit großer Durchschlagskraft, aber langsam nachzuladen.', 'selten', 200, 0, 0, 'weapon'),
    (42, 'Handarmbrust', 'Eine kompakte, einhändig zu bedienende Armbrust.', 'selten', 90, 0, 0, 'weapon'),
    (43, 'Stiefel', 'Robuste Stiefel, die vor manchem Missgeschick auf Reisen schützen.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (44, 'Umhang', 'Ein wetterfester Umhang.', 'ungewöhnlich', 0, 8, 0, 'misc'),
    (45, 'Feine Gewänder', 'Edle Kleidung für gehobene Anlässe.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (46, 'Pelzumhang', 'Ein warmer Umhang aus Tierfell.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    (47, 'Lumpen', 'Zerschlissene, ärmliche Kleidung.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (48, 'Einfache Kleidung', 'Schlichte, alltagstaugliche Kleidung.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (49, 'Dudelsack', 'Ein Sackpfeifeninstrument mit durchdringendem Klang. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1 und erhöht die Reichweite auf 50 Meter.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    (50, 'Trommel', 'Eine einfache Handtrommel. Erhöht die Reichweite der Musiker-Fähigkeit auf 20 Meter.', 'gewöhnlich', 4, 0, 0, 'misc'),
    (51, 'Harfe', 'Ein aufwendig gebautes Saiteninstrument. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1.', 'ungewöhnlich', 8, 0, 0, 'misc'),
    (52, 'Abakus', 'Ein Rechenbrett mit Kugeln zum Zählen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (53, 'Wolldecke', 'Eine dicke Wolldecke gegen die Kälte.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (54, 'Schachspiel', 'Ein geschnitztes Schachspiel.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (55, 'Würfel', 'Ein Satz Spielwürfel.', 'gewöhnlich', 0, 1, 0, 'misc'),
    (56, 'Feldküche', 'Tragbares Kochgeschirr für unterwegs.', 'gewöhnlich', 4, 0, 0, 'misc'),
    (57, 'Tagesration', 'Getrocknete Vorräte für einen Tag.', 'gewöhnlich', 0, 1, 0, 'misc'),
    (58, 'Feines Diebeswerkzeug', 'Hochwertige Dietriche für heikle Schlösser.', 'selten', 20, 0, 0, 'misc'),
    (59, 'Lupe', 'Eine Lupe zur genauen Untersuchung kleiner Details.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    (60, 'Karte', 'Eine gezeichnete Karte einer Region.', 'ungewöhnlich', 0, 5, 0, 'misc'),
    (61, 'Murmeln', 'Ein Beutel bunter Glasmurmeln.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (62, 'Vorhängeschloss', 'Ein solides Schloss für Türen oder Truhen. Verschließt eine Tür oder Truhe; kann bis zu 20 Schadenspunkte einstecken, Rüstungswert 5.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (63, 'Parfüm (10 Dosen)', 'Ein Fläschchen mit angenehmem Duft.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (64, 'Spielkarten', 'Ein Satz bebilderter Spielkarten.', 'ungewöhnlich', 0, 5, 0, 'misc'),
    (65, 'Seil (Seide), 10m', 'Zehn Meter feines, leichtes Seidenseil.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (66, 'Sattel', 'Ein Reitsattel für Pferde.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (67, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen zu entzünden.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (68, 'Öllampe', 'Eine einfache Öllampe.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (69, 'Talgkerze', 'Eine einfache Kerze aus Talg.', 'gewöhnlich', 0, 0, 1, 'misc'),
    (70, 'Brecheisen', 'Ein stabiles Brecheisen zum Aufbrechen von Türen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (71, 'Hammer', 'Ein gewöhnlicher Handwerkshammer.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (72, 'Nadel & Faden', 'Zum Ausbessern von Kleidung.', 'gewöhnlich', 0, 3, 0, 'misc'),
    (73, 'Spitzhacke', 'Ein Werkzeug zum Graben und Abbauen von Gestein.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (74, 'Säge', 'Eine Säge zum Durchtrennen von Holz oder Metall.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (75, 'Schaufel', 'Eine robuste Schaufel.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (76, 'Vorschlaghammer', 'Ein schwerer Hammer für grobe Arbeiten.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (77, 'Rucksack', 'Ein geräumiger Rucksack für Ausrüstung.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (78, 'Fass', 'Ein hölzernes Fass.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (79, 'Korb', 'Ein geflochtener Weidenkorb.', 'gewöhnlich', 0, 4, 0, 'misc'),
    (80, 'Flasche', 'Eine Flasche für Flüssigkeiten.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (81, 'Eimer', 'Ein einfacher Eimer.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (82, 'Truhe', 'Eine verschließbare Holztruhe.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (83, 'Tonkrug', 'Ein Krug aus gebranntem Ton.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (84, 'Satteltasche', 'Eine Tasche zur Befestigung am Sattel.', 'gewöhnlich', 6, 0, 0, 'misc'),
    (85, 'Kreide', 'Ein Stück Kreide zum Zeichnen magischer Symbole.', 'gewöhnlich', 0, 0, 1, 'misc'),
    (86, 'Sanduhr', 'Eine Sanduhr zur präzisen Zeitmessung.', 'selten', 25, 0, 0, 'misc'),
    (87, 'Papier (Blatt)', 'Ein Blatt hochwertiges Papier.', 'ungewöhnlich', 0, 2, 0, 'misc'),
    (88, 'Pergament (Blatt)', 'Ein Blatt Pergament.', 'gewöhnlich', 0, 1, 0, 'misc'),
    (89, 'Reliquiar', 'Ein kleiner Schrein für ein geweihtes Andenken.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (90, 'Falle/Schlinge, groß', 'Eine kräftige Falle für größeres Wild.', 'ungewöhnlich', 3, 0, 0, 'misc'),
    (91, 'Angel', 'Eine einfache Angelrute.', 'gewöhnlich', 0, 8, 0, 'misc'),
    (92, 'Fischernetz', 'Ein Netz zum Fischfang.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (93, 'Schlinge', 'Eine einfache Drahtschlinge, nur einmal verwendbar.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (94, 'Kanu', 'Ein schmales, wendiges Kanu.', 'gewöhnlich', 6, 0, 0, 'misc'),
    (95, 'Ruderboot', 'Ein einfaches Ruderboot.', 'gewöhnlich', 15, 0, 0, 'misc'),
    (96, 'Segelboot', 'Ein kleines Segelboot für Küstenfahrten.', 'ungewöhnlich', 40, 0, 0, 'misc'),
    (97, 'Planwagen', 'Ein von zwei Zugtieren gezogener Wagen.', 'gewöhnlich', 30, 0, 0, 'misc'),
    (98, 'Huhn', 'Liefert eine Ration Fleisch, wenn geschlachtet.', 'gewöhnlich', 0, 4, 0, 'misc'),
    (99, 'Kuh', 'Liefert täglich Milch und viel Fleisch, wenn geschlachtet.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (100, 'Wachhund', 'Ein treuer Wächter für Haus und Hof.', 'gewöhnlich', 15, 0, 0, 'misc'),
    (101, 'Brieftaube (im Käfig)', 'Fliegt zu ihrem Schlag zurück, egal woher sie freigelassen wird.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (102, 'Schwein', 'Liefert reichlich Fleisch, wenn geschlachtet.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (103, 'Reitpferd', 'Ein gut abgerichtetes Reitpferd.', 'ungewöhnlich', 60, 0, 0, 'misc'),
    (104, 'Schaf', 'Liefert Fleisch und Wolle.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (105, 'Gift, tödlich (Dosis)', 'Volle Wirkung: In deinem Zug erleidest du in jeder Runde W6 Schaden, bis deine TP auf null sinken. Nimmst du rechtzeitig ein Gegengift ein, wird die Wirkung unterbrochen. Eingeschränkte Wirkung: Bei deinem nächsten Zug erleidest du W6 Schaden.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (106, 'Gift, lähmend (Dosis)', 'Volle Wirkung: Du bist Erschöpft und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, kannst du dich in dieser Runde weder bewegen noch eine Aktion durchführen (nicht einmal Freie Aktionen). Die Wirkung lässt nach einem Viertel oder der Einnahme eines Gegengifts nach. Eingeschränkte Wirkung: Du bist Erschöpft.', 'ungewöhnlich', 1, 2, 0, 'misc'),
    (107, 'Gift, einschläfernd (Dosis)', 'Volle Wirkung: Du bist Benommen und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, schläfst du ein und wachst erst nach einer ganzen Schicht wieder auf. Sobald du ein Gegengift erhältst oder wenigstens einen Schadenspunkt erleidest, wachst du auf. Eingeschränkte Wirkung: Du bist Benommen.', 'ungewöhnlich', 0, 6, 0, 'misc'),
    (108, 'Kräutersud (Dosis)', 'Ein Sud aus Heilkräutern gegen Krankheiten.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    (109, 'Heiltrank (Dosis)', 'Ein magischer Trank, der Wunden augenblicklich heilt.', 'selten', 50, 0, 0, 'misc'),
    (110, 'Chirurgenbesteck', 'Feines Werkzeug für schwierige Heilkunde-Proben.', 'ungewöhnlich', 15, 0, 0, 'misc'),
    (111, 'Langbogen', 'Ein großer Bogen für weite Distanzen.', 'gewöhnlich', 50, 0, 0, 'weapon'),
    (112, 'Messer', 'Ein handliches Messer, das auch geworfen werden kann.', 'gewöhnlich', 0, 5, 0, 'weapon'),
    (113, 'Kurzschwert', 'Ein leichtes, einhändig geführtes Schwert.', 'gewöhnlich', 8, 0, 0, 'weapon'),
    (114, 'Schild, klein', 'Ein kleiner, leichter Schild.', 'gewöhnlich', 4, 0, 0, 'weapon'),
    (115, 'Streitaxt', 'Eine schwere einhändige Axt.', 'gewöhnlich', 10, 0, 0, 'weapon'),
    (116, 'Dolch', 'Eine kurze Klinge, unauffällig zu tragen.', 'gewöhnlich', 1, 0, 0, 'weapon'),
    (117, 'Langspeer', 'Ein langer Speer für die erste Kampflinie.', 'gewöhnlich', 1, 0, 0, 'weapon'),
    (118, 'Kurzspeer', 'Ein kurzer, wurfbarer Speer.', 'gewöhnlich', 0, 5, 0, 'weapon'),
    (119, 'Krummsäbel', 'Ein gebogenes, einhändiges Schwert.', 'gewöhnlich', 10, 0, 0, 'weapon'),
    (120, 'Beil', 'Eine kompakte Axt.', 'gewöhnlich', 2, 0, 0, 'weapon'),
    (121, 'Zweihandaxt', 'Eine gewaltige, beidhändig geführte Axt.', 'ungewöhnlich', 25, 0, 0, 'weapon'),
    (122, 'Plattenpanzer', 'Schwere Rüstung aus Metallplatten.', 'selten', 500, 0, 0, 'armor'),
    (123, 'Beschlagenes Leder', 'Lederrüstung mit metallenen Verstärkungen.', 'ungewöhnlich', 10, 0, 0, 'armor'),
    (124, 'Kettenpanzer', 'Rüstung aus verwobenen Metallringen.', 'ungewöhnlich', 50, 0, 0, 'armor'),
    (125, 'Köcher', 'Ein Köcher für Pfeile.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (126, 'Seil (Hanf), 10m', 'Zehn Meter robustes Hanfseil.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (127, 'Laterne', 'Eine Öllaterne.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (128, 'Lampenöl', 'Ein Fläschchen Öl für Laternen.', 'gewöhnlich', 0, 3, 0, 'misc'),
    (129, 'Dietriche', 'Ein Satz Dietriche zum Schlösserknacken.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    (130, 'Wurfhaken', 'Ein Enterhaken mit Seil. Kann verwendet werden, um ein Seil zu sichern; wird mit einer Akrobatik-Probe bis zu STÄ Meter weit geworfen (STÄ×2 mit einem Nachteil).', 'gewöhnlich', 3, 0, 0, 'misc'),
    (131, 'Fernrohr', 'Ein Fernrohr für die weite Sicht. Bonus auf Wildnisleben-Proben, um während einer Reise den Weg zu weisen.', 'selten', 50, 0, 0, 'misc'),
    (132, 'Schlafpelz', 'Ein Fell zum Schlafen. Erforderlich, um einen Nachteil auf Wildnisleben-Proben beim Wegführen während einer Reise zu vermeiden.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (133, 'Zelt, klein', 'Bietet Platz für bis zu zwei Personen. Gewährt einen Vorteil auf Wildnisleben-Proben beim Lagern; nur eine Person würfelt, andere können helfen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (134, 'Zelt, groß', 'Bietet Platz für bis zu sechs Personen. Gewährt einen Vorteil auf Wildnisleben-Proben beim Lagern; nur eine Person würfelt, andere können helfen.', 'gewöhnlich', 4, 0, 0, 'misc'),
    (135, 'Pfeife (Signalpfeife)', 'Kann aus bis zu 100 Metern Entfernung gehört werden.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (136, 'Brosche', 'Kann als magischer Fokus für Zauber verwendet werden.', 'ungewöhnlich', 5, 0, 0, 'misc');

-- catalog_item_weapons
INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de) VALUES
    (1, '2-händig', 7, '2', 'W8', 9, 'Wucht, Niederwerfend'),
    (8, '2-händig', 7, '30', 'W10', 3, 'Stich, benötigt Köcher'),
    (9, '1-händig', 13, '2', '2W8', 15, 'Stich, Hieb'),
    (10, '1-händig', NULL, '20', 'W8', NULL, 'Wucht, kleiner Gegenstand'),
    (11, '1-händig', 10, '2', '2W6', 12, 'Stich, Hieb'),
    (12, '1-händig', 13, '2', '2W8', NULL, 'Wucht, Niederwerfend, kann nicht zum Parieren verwendet werden'),
    (13, '1-händig', 13, '4', '2W10', 12, 'Lang, Stich, nur beritten'),
    (14, '2-händig', 7, '40', '2W6', 6, 'Stich, benötigt Köcher, kein Schadensbonus'),
    (15, '1-händig', 10, 'STR', '2W6', 9, 'Niederwerfend, Stich, kann geworfen werden'),
    (21, '1-händig', 10, '2', '2W6', 12, 'Wucht, Niederwerfend'),
    (35, '1-händig', NULL, '2', 'W6', 15, 'Unauffällig, Stich, Hieb'),
    (36, '1-händig', 13, '2', '2W8', 12, 'Wucht'),
    (37, '2-händig', 16, '2', '2W10', 12, 'Wucht, Niederwerfend'),
    (38, '2-händig', 13, '4', '2W8', 12, 'Lang, Niederwerfend, Stich, Hieb'),
    (39, '1-händig', 13, '2', 'W8', 18, 'Wucht'),
    (40, '1-händig', 7, '2', '2W4', 12, 'Wucht'),
    (41, '2-händig', 13, '60', '2W8', 9, 'Stich, benötigt Köcher, kein Schadensbonus'),
    (42, '1-händig', 7, '30', '2W6', 6, 'Stich, benötigt Köcher, kein Schadensbonus'),
    (111, '2-händig', 13, '100', 'W12', 6, 'Stich, benötigt Köcher, kein Schadensbonus'),
    (112, '1-händig', NULL, 'STR', 'W8', 6, 'Unauffällig, Stich, kann geworfen werden'),
    (113, '1-händig', 7, '2', 'W10', 12, 'Hieb, Stich'),
    (114, '1-händig', 7, '2', 'W8', 15, 'Wucht'),
    (115, '1-händig', 13, '2', '2W8', 9, 'Niederwerfend, Hieb'),
    (116, '1-händig', NULL, 'STR', 'W8', 9, 'Unauffällig, Stich, Hieb, kann geworfen werden'),
    (117, '2-händig', 10, '4', '2W8', 9, 'Lang, Stich'),
    (118, '1-händig', 7, 'STR×2', 'W10', 9, 'Stich, kann geworfen werden'),
    (119, '1-händig', 10, '2', '2W6', 12, 'Niederwerfend, Hieb'),
    (120, '1-händig', 7, 'STR', '2W6', 9, 'Niederwerfend, Hieb, kann geworfen werden'),
    (121, '2-händig', 16, '2', '2W10', 9, 'Hieb, Niederwerfend');

-- catalog_item_armor
INSERT INTO catalog_item_armor (item_id, slot, armor_value, penalty_stealth, penalty_evasion, penalty_acrobatics, penalty_perception, penalty_ranged) VALUES
    (7, 'body', 1, 0, 0, 0, 0, 0),
    (16, 'head', 1, 0, 0, 0, 1, 0),
    (17, 'head', 2, 0, 0, 0, 1, 1),
    (122, 'body', 6, 1, 1, 1, 0, 0),
    (123, 'body', 2, 1, 0, 0, 0, 0),
    (124, 'body', 4, 1, 1, 0, 0, 0);

-- ============================================================
-- Charaktererschaffung: Völker, heroische Talente, Berufe, Schwächen, Erinnerungsstücke, Erscheinungsbild
-- ============================================================

-- catalog_kins
INSERT INTO catalog_kins (code, name_de, d12_min, d12_max, movement_base) VALUES
    ('elf', 'Elf', 10, 10, 10),
    ('ente', 'Ente', 11, 11, 8),
    ('halbling', 'Halbling', 5, 7, 8),
    ('halbelf', 'Halb-Elf', 3, 3, 10),
    ('halbork', 'Halb-Ork', 4, 4, 10),
    ('mensch', 'Mensch', 1, 2, 10),
    ('wolfsmensch', 'Wolfsmensch', 12, 12, 12),
    ('zwerg', 'Zwerg', 8, 9, 8);

-- catalog_heroic_abilities
INSERT INTO catalog_heroic_abilities (id, name_de, requirement_de, wp_note_de, description_de, repeatable) VALUES
    (1, 'Anpassungsfähig', NULL, '3', 'Bei einer Fertigkeitsprobe kannst du dich entscheiden, für den Wurf eine andere Fertigkeit deiner Wahl zu benutzen. Du musst allerdings erklären können, wie die gewählte Fertigkeit die ursprüngliche ersetzen kann. Die Spielleitung hat dabei das letzte Wort, sollte aber großzügig sein.', 0),
    (2, 'Schwer zu fassen', NULL, '3', 'Du kannst dieses Talent aktivieren, wenn du einem Angriff ausweichst, um einen Vorteil auf deine Ausweichen-Probe zu erhalten.', 0),
    (3, 'Nachtragend', NULL, '3', 'Du kannst dieses Talent aktivieren, wenn du jemanden angreifst, der dir in der Vergangenheit geschadet hat (mindestens 1 Schadenspunkt), und erhältst einen Vorteil auf den Wurf. Es spielt keine Rolle, wann der Schaden zugefügt wurde. Es kann klug sein, sich die Namen aller zu notieren, die einem geschadet haben, um sie nicht zu vergessen.', 0),
    (4, 'Innerer Frieden', NULL, NULL, 'Als Elf kannst du während einer kurzen Rast meditieren. Du heilst einen zusätzlichen W6 TP sowie einen weiteren W6 WP, außerdem kannst du dich von einem zusätzlichen Zustand erholen. Während der Meditation bist du völlig regungslos und kannst nicht aufgeweckt werden.', 0),
    (5, 'Übellaunig', NULL, '3', 'Enten neigen zu einem cholerischen Temperament. Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine Fertigkeitsprobe ablegst, und erhältst einen Vorteil auf den Wurf. Zusätzlich wirst du wütend, falls du es nicht bereits bist. Dieses Talent kann nicht für Proben auf INT oder INT-basierte Fertigkeiten verwendet werden.', 0),
    (6, 'Schwimmhäute', NULL, NULL, 'Als Ente erhältst du außerdem einen Vorteil auf alle Schwimmen-Proben. Du bewegst dich an der Wasseroberfläche oder unter Wasser stets mit voller Geschwindigkeit.', 0),
    (7, 'Jagdinstinkt', NULL, '3', 'Du kannst dieses Talent aktivieren, um eine Kreatur in Sichtweite oder deren Geruch du wahrnehmen kannst, als deine Beute zu markieren. Dies zählt im Kampf als eine Aktion. Du kannst der Fährte deiner Beute einen ganzen Tag lang folgen und zusätzlich 1 WP ausgeben (keine Aktion), um einen Vorteil auf einen Angriff gegen deine Beute zu erhalten.', 0),
    (8, 'Veteran', 'Beliebige Waffenfertigkeit 12', '1', 'Wenn du dieses Talent zu Beginn einer Kampfrunde aktivierst, kannst du deine Initiativekarte aus der letzten Runde behalten, anstatt eine neue zu ziehen. Das zählt nicht als Aktion.', 0),
    (9, 'Gefährte', 'Jagen & Fischen 12', '3', 'Du kannst dieses Talent aktivieren, um ein Tier (kein Monster) zu deinem Gefährten zu machen. Das dauert eine Weile, und du kannst immer nur einen Tiergefährten gleichzeitig haben. Die Spielleitung entscheidet, welche Tiere in der Nähe sind. Das Tier folgt dir, solange du dich in seiner natürlichen Umgebung aufhältst, und kann für dich ohne zusätzliche WP-Kosten aufklären. Für 3 weitere WP kannst du dem Tier befehlen, einen Feind anzugreifen (das kostet dich keine Aktion).', 0),
    (10, 'Beschützer', 'Äxte, Hämmer oder Schwerter 12', '2', 'Du zögerst nicht, einen Treffer für deine Freunde einzustecken. Wenn du und ein anderer Spielercharakter innerhalb von zwei Metern zum selben Feind seid und der Feind den anderen Charakter zu treffen versucht, kannst du dieses Talent aktivieren, um den Feind zu zwingen, stattdessen dich zu attackieren.', 0),
    (11, 'Seebeine', 'Schwimmen 12', '1', 'Du kannst dieses Talent aktivieren (keine Aktion), wenn du eine Aktion im Wasser ausführst, selbst wenn es nur hüfttief ist. Daraufhin bist du eine Runde lang gegen alle negativen Effekte geschützt, die üblicherweise im Wasser auftreten, einschließlich der Gefahr, zu ertrinken.', 0),
    (12, 'Goldnase', 'Feilschen 12', '3', 'Du kannst dieses Talent aktivieren, wenn du an einem Scheideweg bist, um herauszufinden, welcher Weg oder welche Entscheidung dich zu den größten Reichtümern führt.', 0),
    (13, 'Hinterhältig', 'Messer 12', '3', 'Du kannst dieses Talent bei einem Nahkampfangriff aktivieren, wenn sich dein Gegner innerhalb von 2 Metern zu einem anderen Spielercharakter befindet. Dein Angriff zählt dann als Schleichangriff, das heißt, er kann nicht ausgewichen oder pariert werden, du erhältst einen Nachteil auf den Wurf, und die Anzahl der Schadenswürfel erhöht sich um eins (2W8 statt W8). Dieses Talent kann nur mit unauffälligen Waffen eingesetzt werden.', 0),
    (14, 'Doppelschuss', 'Bögen 12', '3', 'Wenn du bei einem Angriff mit dem Bogen dieses Talent aktivierst, kannst du zwei Pfeile gleichzeitig abschießen. Du würfelst nur einmal auf Treffer, mit einem Nachteil; der Schaden wird für beide Pfeile separat gewürfelt. Die Pfeile können auf dasselbe oder zwei verschiedene Ziele gerichtet werden.', 0),
    (15, 'Furchtlos', NULL, '2', 'Du widerstehst von vornherein Furchtangriffen, ohne eine WIL-Probe ablegen zu müssen.', 0),
    (16, 'Robust', NULL, NULL, 'Deine maximalen TP werden dauerhaft um 2 erhöht. Dieses Talent kann beliebig oft gewählt werden, ohne Limit.', 1),
    (17, 'Fokussiert', NULL, NULL, 'Deine maximalen WP werden dauerhaft um 2 erhöht. Dieses Talent kann beliebig oft gewählt werden, ohne Limit.', 1),
    (18, 'Meister-Schmied', 'Handwerk 12', 'unterschiedlich', 'Erfordert Schmiedewerkzeug. Innerhalb einer Rast kannst du für 3 WP eine geschärfte oder spitze Waffe schärfen: Gegen eine geschärfte Waffe zählt die Rüstung eines Ziels einen Schritt niedriger. Der Effekt hält bis zum Ende des nächsten Kampfes an, in dem die Waffe benutzt wurde. In einer Schicht kannst du eine Metallwaffe oder Metallrüstung deiner Wahl anfertigen; dafür benötigst du eine Schmiede, einen Amboss und Eisen (Gewicht 1). Die WP-Kosten entsprechen dem aufgerundeten Goldpreis des Gegenstands; die Arbeit kann auf mehrere Schichten verteilt werden, falls nicht genug WP vorhanden sind.', 0),
    (19, 'Meister-Zimmermann', 'Handwerk 12', 'unterschiedlich', 'Erfordert Zimmermannswerkzeug. Als Aktion kannst du pro eingesetztem WP W12 Schaden an einer Tür, Wand oder einem anderen unbelebten Objekt verursachen, ohne dessen Rüstung zu berücksichtigen. In einer Schicht kannst du einen hölzernen Gegenstand deiner Wahl anfertigen (z. B. Keule, Stab oder Schild); dafür benötigst du Holz (Gewicht 1 oder nach Ansage der Spielleitung). Die WP-Kosten entsprechen dem aufgerundeten Goldpreis des Gegenstands, bei unaufgelisteten Gegenständen legt die Spielleitung die Kosten fest.', 0),
    (20, 'Meister-Gerber', 'Handwerk 12', 'unterschiedlich', 'Erfordert Gerberwerkzeug. Du kannst aus der Haut eines Tieres oder Monsters einen Satz Lederrüstung anfertigen. Die Rüstung erhält die Hälfte (aufgerundet) des Rüstungswerts der Kreatur, mindestens aber 1. Die Arbeit dauert eine Schicht, die WP-Kosten entsprechen dem Rüstungswert der fertigen Rüstung.', 0),
    (21, 'Intuition', 'Mythen & Legenden 12', '3', 'Wenn du vor einer schwierigen Entscheidung stehst, kannst du dieses Talent aktivieren, um der Spielleitung direkt eine Frage zu stellen und eine hilfreiche Antwort zu erhalten. Die Antwort spiegelt dein umfangreiches Allgemeinwissen wider und soll dir nur bei der Entscheidung helfen, nicht alles verraten.', 0),
    (22, 'Musiker', 'Darbietung 12', '3', 'Deine wunderbare Stimme flößt deinen Freunden Mut ein oder deinen Feinden Furcht. Aktivierst du dieses Talent (eine Aktion im Kampf), erhalten entweder alle Verbündeten in 10 Metern einen Vorteil auf alle Würfe oder alle Feinde in derselben Reichweite einen Nachteil — du wählst eins von beidem. Der Effekt hält bis zu deinem Zug in der nächsten Runde an. Mit Instrumenten lässt sich die Reichweite erhöhen oder die WP-Kosten senken.', 0),
    (23, 'Assassine', 'Messer 12', '3', 'Dein Schleichangriff verursacht zusätzlich W8 Schaden. Dieses Talent kann mit dem Talent Hinterhältig kombiniert werden. Du aktivierst es, nachdem du auf Treffer gewürfelt hast, aber bevor du den Schaden würfelst.', 0),
    (24, 'Schlachtruf', NULL, '3', 'Du kannst im Kampf einen Schlachtruf ausstoßen, der deine Freunde anspornt. Alle anderen Spielercharaktere in Hörweite heilen sofort einen Zustand ihrer Wahl. Dieses Talent kann nur im Kampf eingesetzt werden.', 0),
    (25, 'Berserker', 'Beliebige Nahkampfwaffenfertigkeit 12', '3', 'Du erhältst den Zustand Wütend und greifst sofort den nächsten Gegner im Nahkampf an. Bist du bereits wütend, erhältst du stattdessen einen weiteren Zustand deiner Wahl. Anschließend musst du weiterkämpfen, bis alle Gegner in Sichtweite besiegt sind oder du 0 TP erreichst. Du erhältst einen Vorteil auf Nahkampfangriffe, kannst aber weder parieren noch ausweichen. Nach dem Kampf bist du erschöpft.', 0),
    (26, 'Katzengleich', 'Akrobatik 12', 'unterschiedlich', 'Die Anzahl der W6, die bei Sturzschaden gewürfelt werden, sinkt für jeden dafür eingesetzten WP um eins. Du kannst zunächst eine Akrobatik-Probe ablegen und danach dieses Talent aktivieren.', 0),
    (27, 'Schlangenmensch', 'Ausweichen 12', '1', 'Du befreist dich aus Fesseln oder zwängst dich durch einen engen Spalt, ohne dafür eine Fertigkeitsprobe abzulegen.', 0),
    (28, 'Defensiv', 'Beliebige Nahkampfwaffenfertigkeit 12', '3', 'Du kannst versuchen, einen Angriff zu parieren, ohne dafür deine Aktion in dieser Runde zu verbrauchen. Diese Bonus-Parade kann jederzeit während der Runde eingesetzt werden, aber nur einmal gegen denselben Angriff, und du kannst nicht gleichzeitig gegen denselben Angriff ausweichen und parieren. Dieses Talent kann mehrfach pro Runde eingesetzt werden, solange du genug WP hast.', 0),
    (29, 'Pfeilabwehr', 'Beliebige Nahkampfwaffenfertigkeit 12', '1', 'Du kannst einen Fernkampfangriff mit einer Nahkampfwaffe parieren, anstatt dafür einen Schild zu benutzen.', 0),
    (30, 'Verkleidung', 'Täuschen 12', '2', 'Du bist ein Meister der Verkleidung und kannst mühelos das Aussehen anderer annehmen. Nach einer Weile Vorbereitung kannst du Aussehen, Stimme und Auftreten einer anderen Person annehmen. Die Person muss demselben Volk wie du angehören. Wer die Person kennt und dich aus bis zu 10 Metern Entfernung sieht, kann eine Wahrnehmungsprobe ablegen, um die Verkleidung zu durchschauen.', 0),
    (31, 'Doppelhieb', 'Äxte oder Schwerter 12', '2', 'Mit einer Hiebwaffe kannst du zwei Gegner innerhalb von 2 Metern mit einem einzigen Schlag angreifen. Du würfelst nur einmal auf Treffer -- gelingt der Wurf, werden beide Gegner getroffen. Deine Gegner können dem Angriff jeweils einzeln ausweichen oder ihn parieren. Der Schaden wird separat gewürfelt. Dieses Talent kann mit Zweiwaffenkampf kombiniert werden.', 0),
    (32, 'Drachentöter', 'Beliebige Waffenfertigkeit 12', '3', 'Ein Angriff gegen ein Monster (kein gewöhnlicher NSC) verursacht zusätzlich W8 Schaden. Du aktivierst dieses Talent, nachdem du auf Treffer gewürfelt hast, aber bevor du den Schaden würfelst. Mehr zu Monstern in Kapitel 7.', 0),
    (33, 'Zweiwaffenkampf', 'Beliebige Nahkampfwaffenfertigkeit 12', '3', 'Dieses Talent kann nur eingesetzt werden, wenn du in jeder Hand eine einhändige Waffe führst. Die STÄ-Voraussetzung der Waffe in deiner Nebenhand erhöht sich um 3 (du entscheidest, ob rechts oder links). Du aktivierst dieses Talent in deinem Zug im Kampf und kannst dann einen zusätzlichen Angriff mit deiner zweiten Waffe ausführen. Du entscheidest, in welcher Reihenfolge du deine Waffen einsetzt. Schließe den ersten Angriff samt Schaden ab, bevor du den zweiten würfelst. Dieses Talent kann mit Doppelhieb kombiniert werden.', 0),
    (34, 'Adlerauge', 'Wahrnehmung 12', '2', 'Du kannst eine Person oder ein Objekt bis zu 200 Meter entfernt in allen Details erkennen, als stündest du direkt daneben. Im Kampf kannst du damit auch ein Ziel jenseits der effektiven Reichweite deiner Waffe angreifen, indem du einen Nachteil auf deinen Wurf nimmst. Dieses Talent muss für jedes neue Ziel erneut aktiviert werden.', 0),
    (35, 'Schnelle Füße', 'Ausweichen 12', '3', 'Du kannst versuchen, einem Angriff auszuweichen, ohne dafür deine Aktion in dieser Runde zu verbrauchen. Dieses Bonus-Ausweichen kann jederzeit während der Runde eingesetzt werden, aber nur einmal gegen denselben Angriff, und du kannst nicht gleichzeitig gegen denselben Angriff ausweichen und parieren. Dieses Talent kann mehrfach pro Runde eingesetzt werden, solange du genug WP hast.', 0),
    (36, 'Schnelle Heilung', NULL, '2', 'Du heilst während einer kurzen Rast einen zusätzlichen W6 TP. Dieses Talent wirkt sich nicht auf WP oder Zustände aus.', 0),
    (37, 'Menschenkenntnis', 'Überzeugen 12', '2', 'Wenn du eine Weile mit jemandem sprichst, kannst du eine Wahrnehmungsprobe ablegen, um herauszufinden, ob die Person die Wahrheit sagt. Du erfährst dabei nicht, worüber genau gelogen wird.', 0),
    (38, 'Eiserne Faust', 'Prügelei 12', '1', 'Der Schaden eines unbewaffneten Angriffs erhöht sich um einen W6. Du kannst dieses Talent als freie Aktion aktivieren, nachdem du den Angriff gewürfelt hast.', 0),
    (39, 'Eiserner Griff', 'Prügelei 12', '1', 'Du erhältst einen Vorteil auf deine Prügelei-Probe, wenn du versuchst, eine Person festzuhalten oder zu verhindern, dass sich ein Gegner befreit.', 0),
    (40, 'Blitzschnell', 'Ausweichen 12', '2', 'Wenn zu Beginn einer Kampfrunde Initiativekarten gezogen werden, darfst du zwei Karten ziehen und dich für eine davon entscheiden. Du kannst dieses Talent nur einmal pro Runde aktivieren.', 0),
    (41, 'Einzelgänger', 'Wildnisleben 12', NULL, 'Du kannst in der Wildnis eine kurze Rast einlegen, ohne zuvor eine Wildnisleben-Probe für das Lagermachen abzulegen. Der Effekt gilt nur für dich, selbst wenn du ein Zelt hast.', 0),
    (42, 'Magisches Talent', NULL, NULL, 'Du hast eine Begabung für Magie und kannst eine neue Zauberschule erlernen (unabhängig davon, ob du bereits eine beherrschst). Zaubersprüche müssen separat erlernt werden. Dieses Talent kann mehrfach gewählt werden -- einmal für jede neue Schule, die du erlernen willst.', 1),
    (43, 'Wuchtschlag', 'Beliebige STÄ-basierte Nahkampfwaffenfertigkeit 12', '3', 'Ein Schlag mit einer zweihändigen Nahkampfwaffe verursacht zusätzlich W8 Schaden, aber du kannst dich in derselben Runde nicht bewegen. Du kannst dieses Talent nach dem Wurf auf Treffer aktivieren, jedoch nicht, wenn du dich bewegt hast.', 0),
    (44, 'Meisterkoch', NULL, '1', 'Dir gelingt das Kochen von Essen automatisch, ohne eine Wildnisleben-Probe abzulegen.', 0),
    (45, 'Meister-Zauberer', 'Beliebige Zauberschule 12', '3', 'Wenn du dieses Talent in deinem Zug im Kampf aktivierst, kannst du zwei verschiedene Zaubersprüche als eine einzige Aktion wirken. Es müssen zwei unterschiedliche Zauber sein. Wirf zuerst für den ersten Zauber und aktiviere dann dieses Talent.', 0),
    (46, 'Monsterjäger', 'Bestienkunde 12', '3', 'An einer Weggabelung kannst du dieses Talent aktivieren, um die Richtung der gefährlichsten Feinde in Erfahrung zu bringen.', 0),
    (47, 'Pfadfinder', 'Wildnisleben 12', '1', 'Du erhältst einen Vorteil auf deine Wildnisleben-Probe, wenn du versuchst, in der Wildnis die richtige Richtung zu finden.', 0),
    (48, 'Quartiermeister', 'Wildnisleben 12', '1', 'Du bist gut darin, geeignete Lagerplätze zu finden. Das Lagermachen auf Reisen gelingt dir automatisch.', 0),
    (49, 'Schildblock', 'Beliebige STÄ-basierte Nahkampfwaffenfertigkeit 12', '2', 'Du kannst dieses Talent aktivieren, wenn du mit einem Schild parierst, um mit einem Vorteil zu würfeln. Damit kannst du auch körperliche Monsterangriffe (keine Flächenangriffe) parieren, die normalerweise nicht pariert werden können; dafür benötigst du einen Schild und erhältst einen Vorteil auf den Wurf. Dieses Talent kann mit Defensiv kombiniert werden.', 0),
    (50, 'Wurfarm', 'Beliebige Nahkampfwaffenfertigkeit 12', '2', 'Du kannst eine Nahkampfwaffe mit enormer Wucht auf einen Gegner in einer Entfernung von bis zu deinem STÄ-Wert in Metern werfen. Es muss eine einhändige Waffe sein. Würfle den Angriff wie gewohnt. Der Gegner kann dem Angriff wie üblich ausweichen oder ihn parieren. Die Waffe landet dem Gegner vor die Füße.', 0),
    (51, 'Wiesel', 'Ausweichen 12', '3', 'Wirst du angegriffen und befindet sich ein anderer Spielercharakter innerhalb von 2 Metern, kannst du dieses Talent aktivieren, damit der Angriff stattdessen diesen Charakter trifft. Dieses Talent wirkt nicht gegen Flächenangriffe, und du musst es aktivieren, bevor du versuchst auszuweichen oder zu parieren. Das neue Ziel darf ganz normal versuchen auszuweichen oder zu parieren.', 0),
    (52, 'Letzte Reserve', NULL, '3', 'Wenn du auf 0 TP fallen würdest, kannst du dieses Talent aktivieren (keine Aktion). Du bleibst stattdessen mit 1 TP stehen und kannst in dieser Runde ganz normal handeln. Einmal pro Rast.', 0),
    (53, 'Zwei Welten', NULL, '3', 'Du kannst dieses Talent aktivieren, um einen Vorteil auf eine Probe zum Überzeugen oder Entdecken zu erhalten, oder auf eine WIL-Probe gegen Verzauberung.', 0);

-- catalog_kin_heroic_abilities
INSERT INTO catalog_kin_heroic_abilities (kin_code, heroic_ability_id) VALUES
    ('elf', 4),
    ('halbelf', 53),
    ('halbork', 52),
    ('ente', 5),
    ('ente', 6),
    ('halbling', 2),
    ('mensch', 1),
    ('wolfsmensch', 7),
    ('zwerg', 3);

-- catalog_professions
INSERT INTO catalog_professions (code, name_de, key_attribute_code, kin_restriction, grants_magic) VALUES
    ('barde', 'Barde', 'CHA', NULL, 0),
    ('dieb', 'Dieb', 'GEW', NULL, 0),
    ('gelehrter', 'Gelehrter', 'INT', NULL, 0),
    ('haendler', 'Händler', 'CHA', NULL, 0),
    ('handwerker', 'Handwerker', 'STA', NULL, 0),
    ('jaeger', 'Jäger', 'GEW', NULL, 0),
    ('kaempfer', 'Kämpfer', 'STA', NULL, 0),
    ('magier', 'Magier', 'WIL', NULL, 1),
    ('ritter', 'Ritter', 'STA', NULL, 0),
    ('seefahrerin', 'Seefahrerin', 'GEW', NULL, 0);

-- catalog_profession_key_skills
INSERT INTO catalog_profession_key_skills (profession_code, skill_id) VALUES
    ('barde', 1),
    ('barde', 2),
    ('barde', 4),
    ('barde', 8),
    ('barde', 13),
    ('barde', 17),
    ('barde', 18),
    ('barde', 25),
    ('dieb', 1),
    ('dieb', 2),
    ('dieb', 5),
    ('dieb', 7),
    ('dieb', 11),
    ('dieb', 17),
    ('dieb', 19),
    ('dieb', 25),
    ('gelehrter', 2),
    ('gelehrter', 3),
    ('gelehrter', 5),
    ('gelehrter', 8),
    ('gelehrter', 10),
    ('gelehrter', 13),
    ('gelehrter', 19),
    ('gelehrter', 20),
    ('haendler', 2),
    ('haendler', 5),
    ('haendler', 6),
    ('haendler', 7),
    ('haendler', 17),
    ('haendler', 18),
    ('haendler', 19),
    ('haendler', 25),
    ('handwerker', 5),
    ('handwerker', 7),
    ('handwerker', 9),
    ('handwerker', 22),
    ('handwerker', 24),
    ('handwerker', 25),
    ('handwerker', 26),
    ('handwerker', 28),
    ('jaeger', 1),
    ('jaeger', 11),
    ('jaeger', 12),
    ('jaeger', 19),
    ('jaeger', 20),
    ('jaeger', 23),
    ('jaeger', 25),
    ('jaeger', 27),
    ('kaempfer', 2),
    ('kaempfer', 21),
    ('kaempfer', 22),
    ('kaempfer', 23),
    ('kaempfer', 24),
    ('kaempfer', 26),
    ('kaempfer', 28),
    ('kaempfer', 29),
    ('magier', 2),
    ('magier', 3),
    ('magier', 10),
    ('magier', 11),
    ('magier', 12),
    ('magier', 20),
    ('magier', 30),
    ('ritter', 3),
    ('ritter', 4),
    ('ritter', 13),
    ('ritter', 14),
    ('ritter', 18),
    ('ritter', 24),
    ('ritter', 28),
    ('ritter', 29),
    ('seefahrerin', 1),
    ('seefahrerin', 8),
    ('seefahrerin', 12),
    ('seefahrerin', 15),
    ('seefahrerin', 16),
    ('seefahrerin', 19),
    ('seefahrerin', 25),
    ('seefahrerin', 28);

-- catalog_profession_heroic_abilities
INSERT INTO catalog_profession_heroic_abilities (profession_code, heroic_ability_id, granted_at_creation, choice_group) VALUES
    ('barde', 22, 1, NULL),
    ('dieb', 13, 1, NULL),
    ('gelehrter', 21, 1, NULL),
    ('haendler', 12, 1, NULL),
    ('handwerker', 18, 1, 'handwerker_meister'),
    ('handwerker', 19, 1, 'handwerker_meister'),
    ('handwerker', 20, 1, 'handwerker_meister'),
    ('jaeger', 9, 1, NULL),
    ('jaeger', 14, 0, NULL),
    ('kaempfer', 8, 1, NULL),
    ('kaempfer', 15, 0, NULL),
    ('ritter', 10, 1, NULL),
    ('seefahrerin', 11, 1, NULL);

-- catalog_profession_gear_options
INSERT INTO catalog_profession_gear_options (id, profession_code, option_label, extra_de, starting_silver_dice) VALUES
    (1, 'kaempfer', 'A', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    (2, 'kaempfer', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    (3, 'kaempfer', 'C', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W6'),
    (4, 'jaeger', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, Falle/Schlinge, W8 Tagesrationen', 'W6'),
    (5, 'jaeger', 'B', 'Schlafpelz, Seil (Hanf), Angel, W6 Tagesrationen', NULL),
    (6, 'jaeger', 'C', 'Schlafpelz, Falle/Schlinge, Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W6'),
    (7, 'ritter', 'A', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W12'),
    (8, 'ritter', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W12'),
    (9, 'ritter', 'C', 'W6 Tagesrationen', 'W12'),
    (10, 'seefahrerin', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    (11, 'seefahrerin', 'B', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    (12, 'seefahrerin', 'C', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    (13, 'haendler', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W12'),
    (14, 'haendler', 'B', 'Schlafpelz, Feldküche, Lampenöl, Feuerstein & Zunder', 'W12'),
    (15, 'haendler', 'C', 'Schlafpelz, großes Zelt, Öllampe, Lampenöl, Feuerstein & Zunder, Rucksack, W6 Tagesrationen', 'W12'),
    (16, 'dieb', 'A', 'Fackel, Feuerstein & Zunder, W10 Tagesrationen', 'W10'),
    (17, 'dieb', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W10'),
    (18, 'dieb', 'C', 'Murmeln, Fackel, Feuerstein & Zunder, W10 Tagesrationen', 'W10'),
    (19, 'handwerker', 'A', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    (20, 'handwerker', 'B', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    (21, 'handwerker', 'C', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    (22, 'gelehrter', 'A', 'Schlafpelz, Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    (23, 'gelehrter', 'B', 'Schlafpelz, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    (24, 'gelehrter', 'C', 'Schlafpelz, Feuerstein & Zunder, W8 Tagesrationen', 'W10'),
    (25, 'magier', 'A', 'Fackel, Feuerstein & Zunder, W8 Tagesrationen', 'W8'),
    (26, 'magier', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    (27, 'magier', 'C', 'Schlafpelz, Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    (28, 'barde', 'A', 'Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    (29, 'barde', 'B', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8'),
    (30, 'barde', 'C', 'Fackel, Feuerstein & Zunder, W6 Tagesrationen', 'W8');

-- catalog_profession_gear_option_items
INSERT INTO catalog_profession_gear_option_items (gear_option_id, item_id, quantity) VALUES
    (2, 7, 1),
    (2, 14, 1),
    (3, 16, 1),
    (4, 7, 1),
    (4, 8, 1),
    (5, 7, 1),
    (6, 7, 1),
    (6, 10, 1),
    (7, 11, 1),
    (7, 17, 1),
    (8, 12, 1),
    (8, 16, 1),
    (9, 13, 1),
    (9, 16, 1),
    (9, 18, 1),
    (10, 8, 1),
    (11, 7, 1),
    (12, 15, 1),
    (14, 19, 1),
    (14, 20, 1),
    (16, 10, 1),
    (19, 7, 1),
    (19, 21, 1),
    (19, 22, 1),
    (20, 7, 1),
    (20, 23, 1),
    (21, 7, 1),
    (21, 24, 1),
    (22, 1, 1),
    (22, 25, 1),
    (22, 26, 1),
    (23, 5, 1),
    (24, 27, 1),
    (25, 1, 1),
    (25, 28, 1),
    (25, 31, 1),
    (26, 29, 1),
    (26, 31, 1),
    (27, 30, 1),
    (27, 31, 1),
    (28, 32, 1),
    (29, 33, 1),
    (30, 34, 1);

-- catalog_flaws
INSERT INTO catalog_flaws (id, roll_min, roll_max, name_de, description_de) VALUES
    (1, 1, 1, 'Leichtgläubig', 'Ich glaube alles, was andere mir erzählen.'),
    (2, 2, 2, 'Gierig', 'Ich will immer einen größeren Anteil an jedem Schatz.'),
    (3, 3, 3, 'Dünnhäutig', 'Ich ertrage keine Provokation.'),
    (4, 4, 4, 'Tollkühn', 'Ich stürze mich stets als erster in Gefahr.'),
    (5, 5, 5, 'Ängstlich', 'Ich halte mich immer im Hintergrund der Gruppe.'),
    (6, 6, 6, 'Monsterjäger', 'Alle Monster sind böse und müssen getötet werden.'),
    (7, 7, 7, 'Voreingenommen', 'Nachtvolk wie Orks und Goblins ist böse und muss bekämpft werden.'),
    (8, 8, 8, 'Faul', 'Ich nutze jede Gelegenheit, um mich auszuruhen.'),
    (9, 9, 9, 'Verfressen', 'Ich nutze jede Gelegenheit, um etwas Schmackhaftes zu essen.'),
    (10, 10, 10, 'Kleptomanisch', 'Ich kann nicht anders, als Wertgegenstände zu stehlen.'),
    (11, 11, 11, 'Eitel', 'Ich helfe jedem, der mich lobt oder mir Komplimente macht.'),
    (12, 12, 12, 'Unbesonnen', 'Ich gehe immer große Risiken ein, ohne über die Konsequenzen nachzudenken.'),
    (13, 13, 13, 'Magiefeindlich', 'Magie ist eine böse Macht, Magiern kann nicht vertraut werden.'),
    (14, 14, 14, 'Wissbegierig', 'Die Jagd nach Wissen ist mir wichtiger als meine Freunde.'),
    (15, 15, 15, 'Kind der Wildnis', 'Ich schlafe niemals in Innenräumen.'),
    (16, 16, 16, 'Prahlerisch', 'Ich übertreibe stets meine Heldentaten.'),
    (17, 17, 17, 'Gewalttätig', 'Ich greife bei jedem Hindernis zur Gewalt.'),
    (18, 18, 18, 'Anmaßend', 'Ich sage anderen ständig, was sie tun sollen.'),
    (19, 19, 19, 'Pessimistisch', 'Ich glaube immer, dass sich die Dinge zum Schlechteren wenden.'),
    (20, 20, 20, 'Hochnäsig', 'Ich schaue auf jeden herab, den ich treffe.');

-- catalog_mementos
INSERT INTO catalog_mementos (id, roll_min, roll_max, description_de) VALUES
    (1, 1, 1, 'Deine treuen alten Schuhe'),
    (2, 2, 2, 'Ein schlichtes silbernes Medaillon'),
    (3, 3, 3, 'Ein Brief eines alten Freundes oder Verwandten'),
    (4, 4, 4, 'Ein zerfleddertes altes Tagebuch'),
    (5, 5, 5, 'Ein Armband, das in deiner Familie weitergegeben wird'),
    (6, 6, 6, 'Eine hölzerne Figur aus deiner Kindheit'),
    (7, 7, 7, 'Ein seltsam geformter Stein'),
    (8, 8, 8, 'Eine Kupfermünze aus einem Schatz, den deine Mutter oder dein Vater gesucht hat'),
    (9, 9, 9, 'Ein alter Zinnkrug'),
    (10, 10, 10, 'Ein Horn, das du als Trophäe von einem Monster erbeutet hast'),
    (11, 11, 11, 'Ein Fang, den du als Trophäe von einer Bestie erbeutet hast'),
    (12, 12, 12, 'Ein paar einfache Würfel aus Knochen'),
    (13, 13, 13, 'Ein Medaillon mit einer Haarlocke'),
    (14, 14, 14, 'Ein verzierter Schlüssel'),
    (15, 15, 15, 'Eine handgezeichnete Karte, die du geerbt hast'),
    (16, 16, 16, 'Ein Ring mit einer Inschrift'),
    (17, 17, 17, 'Ein Pfeifchen aus Knochen'),
    (18, 18, 18, 'Der zerschlissene alte Hut deiner Mutter oder deines Vaters'),
    (19, 19, 19, 'Eine Greifenfeder'),
    (20, 20, 20, 'Eine wunderschön geschnitzte Tabakspfeife');

-- catalog_appearances
INSERT INTO catalog_appearances (id, roll_min, roll_max, description_de) VALUES
    (1, 1, 1, 'Hässliche Narbe quer über die Wange'),
    (2, 2, 2, 'Seltsame Kopfbedeckung'),
    (3, 3, 3, 'Ungewöhnlich blass und käsig'),
    (4, 4, 4, 'Ein ständiges Lächeln auf den Lippen'),
    (5, 5, 5, 'Eisiger, durchdringender Blick'),
    (6, 6, 6, 'Etwas Übergewicht um die Körpermitte'),
    (7, 7, 7, 'Dünn und drahtig'),
    (8, 8, 8, 'Ungewöhnlich viel Körperbehaarung (je nach Volk)'),
    (9, 9, 9, 'Beginnende Glatze (je nach Volk)'),
    (10, 10, 10, 'Auffälliges Tattoo'),
    (11, 11, 11, 'Übler Körpergeruch'),
    (12, 12, 12, 'Prächtige Frisur'),
    (13, 13, 13, 'Hinkender Gang'),
    (14, 14, 14, 'Verdreckt'),
    (15, 15, 15, 'Ehrliche blaue Augen'),
    (16, 16, 16, 'Silberzahn'),
    (17, 17, 17, 'Stark parfümiert'),
    (18, 18, 18, 'Verschiedenfarbige Augen'),
    (19, 19, 19, 'Zischende Stimme'),
    (20, 20, 20, 'Wettergegerbtes Gesicht');

-- ============================================================
-- Regel-Referenz: Verletzungen, Patzer, Furcht, Rast und Gefahren
-- ============================================================

-- catalog_injuries
INSERT INTO catalog_injuries (id, roll_min, roll_max, name_de, effect_de, healing_de) VALUES
    (1, 1, 2, 'Gebrochene Nase', 'Nachteil auf alle Wahrnehmung-Proben.', 'W6 Tage'),
    (2, 3, 4, 'Vernarbtes Gesicht', 'Nachteil auf alle Darbietung- und Überzeugen-Proben.', '2W6 Tage'),
    (3, 5, 6, 'Zähne ausgeschlagen', 'Deine Fertigkeitswerte in Darbietung und Überzeugen werden dauerhaft um 2 gesenkt (mindestens 3).', NULL),
    (4, 7, 8, 'Gebrochene Rippen', 'Nachteil auf alle Fertigkeiten, die auf STÄ oder GEW basieren.', 'W6 Tage'),
    (5, 9, 10, 'Gehirnerschütterung', 'Nachteil auf alle Fertigkeiten, die auf INT basieren.', 'W6 Tage'),
    (6, 11, 12, 'Tiefe Wunden', 'Nachteil auf alle Fertigkeiten, die auf STÄ oder GEW basieren, und jeder Einsatz einer solchen Fertigkeit verursacht zusätzlich W6 Schaden.', '2W6 Tage'),
    (7, 13, 13, 'Gebrochenes Bein', 'Deine Bewegungsrate wird halbiert.', '3W6 Tage'),
    (8, 14, 14, 'Gebrochener Arm', 'Du kannst weder eine zweihändige Waffe führen noch zwei Waffen gleichzeitig einsetzen, und erhältst einen Nachteil auf alle anderen Handlungen, die normalerweise beide Arme erfordern, etwa Klettern.', '3W6 Tage'),
    (9, 15, 15, 'Abgetrennter Zeh', 'Deine Bewegungsrate wird dauerhaft um 2 gesenkt (mindestens 4).', NULL),
    (10, 16, 16, 'Abgetrennter Finger', 'Deine Fertigkeitswerte in allen Waffenfertigkeiten werden dauerhaft um 1 gesenkt (mindestens 3).', NULL),
    (11, 17, 17, 'Ausgestochenes Auge', 'Dein Fertigkeitswert in Entdecken wird dauerhaft um 2 gesenkt (mindestens 3).', NULL),
    (12, 18, 18, 'Albträume', 'Wirf bei jeder geschlafenen Schicht eine Probe, um Furcht zu widerstehen. Scheitert die Probe, zählt die Schicht nicht als geschlafen.', '2W6 Tage'),
    (13, 19, 19, 'Veränderte Persönlichkeit', 'Würfle zufällig eine neue Schwäche aus (optionale Regel).', NULL),
    (14, 20, 20, 'Amnesie', 'Du kannst dich nicht mehr daran erinnern, wer du oder die anderen Spielercharaktere sind. Der Effekt muss ausgespielt werden.', 'W6 Tage');

-- catalog_combat_mishaps
INSERT INTO catalog_combat_mishaps (id, context, roll, effect_de) VALUES
    (1, 'melee', 1, 'Du lässt deine Waffe zu Boden fallen. Sie aufzuheben ist eine Aktion.'),
    (2, 'melee', 2, 'Du gibst dir für einen Moment eine Blöße; dein Gegner erhält einen kostenlosen Angriff gegen dich, dem weder ausgewichen noch der pariert werden kann.'),
    (3, 'melee', 3, 'Deine Waffe bohrt sich so tief in ein Objekt, dass sie steckenbleibt. Sie zu befreien erfordert eine STÄ-Probe (Aktion).'),
    (4, 'melee', 4, 'Du schleuderst deine Waffe versehentlich W3+3 Meter weit fort. Sie aufzuheben erfordert eine Aktion.'),
    (5, 'melee', 5, 'Du schlägst mit deiner Waffe gegen etwas Hartes und beschädigst sie; jede weitere Verwendung der Waffe erhält einen Nachteil, bis sie von einem Handwerker repariert wurde.'),
    (6, 'melee', 6, 'Du triffst dich selbst aus Versehen; würfle den Schaden wie gewohnt, jedoch ohne Schadensbonus.'),
    (7, 'ranged', 1, 'Du lässt deine Waffe zu Boden fallen. Sie aufzuheben ist eine Aktion.'),
    (8, 'ranged', 2, 'Dir gehen die Pfeile aus, und du musst dir neue besorgen, bevor du die Waffe wieder benutzen kannst; bei Schleudern oder Wurfwaffen würfle stattdessen erneut.'),
    (9, 'ranged', 3, 'Du triffst einen wertvollen oder wichtigen Gegenstand in der Nähe; die Spielleitung entscheidet, um welchen es sich handelt.'),
    (10, 'ranged', 4, 'Du zerbrichst deine Waffe; jede weitere Verwendung der Waffe erhält einen Nachteil, bis sie von einem Handwerker repariert wurde.'),
    (11, 'ranged', 5, 'Du triffst versehentlich einen zufälligen Spielercharakter oder freundlichen NSC in der Nähe; würfle den Schaden wie gewohnt, einschließlich Schadensbonus.'),
    (12, 'ranged', 6, 'Du triffst dich selbst aus Versehen; würfle den Schaden wie gewohnt, jedoch ohne Schadensbonus.');

-- catalog_magical_mishaps
INSERT INTO catalog_magical_mishaps (id, roll, effect_de) VALUES
    (1, 1, 'Die magischen Kräfte lassen dich Benommen zurück.'),
    (2, 2, 'Das Zaubern macht dich plötzlich Erschöpft.'),
    (3, 3, 'Die Energien fordern ihren Tribut von deinem Körper; du wirst Kränkelnd.'),
    (4, 4, 'Du verlierst die Kontrolle über den Zauber, was dich sehr Wütend macht.'),
    (5, 5, 'Der Zauber unterwirft dich dämonischen Visionen, die dich Verängstigt zurücklassen.'),
    (6, 6, 'Du siehst die Welt jenseits des Schleiers und erkennst deine eigene Bedeutungslosigkeit. Du fühlst dich Verzagt.'),
    (7, 7, 'Die Magie verwüstet deinen Körper und verursacht W6 Schaden pro Kraftstufe.'),
    (8, 8, 'Der Zauber entzieht dir deine Willenskraft; du verlierst W6 WP pro Kraftstufe.'),
    (9, 9, 'Der Zauber lässt eine magische Krankheit mit Wirkstärke 3W6 entstehen. Du und jeder, mit dem du im nächsten Tagesabschnitt in Kontakt kommst, werden der Krankheit ausgesetzt.'),
    (10, 10, 'Stattdessen wird ein zufälliger anderer Zauber aus deinem Repertoire mit demselben Ziel und derselben Kraftstufe ausgelöst.'),
    (11, 11, 'Du erbrichst einen Frosch, sobald du lügst. Würfle jeden Morgen W4; bei einer 1 endet der Effekt. Er kann auch mit Aufheben beendet werden.'),
    (12, 12, 'Gold oder Silber, das du berührst, zerfällt zu Staub. Würfle jeden Morgen W4; bei einer 1 endet der Effekt. Er kann auch mit Aufheben beendet werden.'),
    (13, 13, 'Der Zauber blendet dich; du handelst, als befändest du dich in völliger Dunkelheit. Würfle jeden Morgen W4; bei einer 1 erholst du dich. Der Effekt kann auch mit Aufheben beendet werden.'),
    (14, 14, 'Du wirst von Amnesie befallen und vergisst, wer du und die anderen Spielercharaktere seid. Der Effekt muss ausgespielt werden. Würfle jeden Morgen W4; bei einer 1 kehrt deine Erinnerung zurück.'),
    (15, 15, 'Der Zauber betrifft zusätzlich einen Freund oder ein anderes unbeabsichtigtes Opfer. Ein heilender oder helfender Zauber betrifft stattdessen einen Feind.'),
    (16, 16, 'Der Zauber schlägt fehl. Ein offensiver Zauber trifft stattdessen dich selbst. Ein schützender oder heilender Zauber verursacht stattdessen Schaden.'),
    (17, 17, 'Du verwandelst dich in ein Tier. Würfle W6: 1 Katze, 2 Fuchs, 3 Ziege, 4 Wolf, 5 Hirsch, 6 Bär. Du erhältst die entsprechenden Werte und kannst nicht sprechen, behältst aber deinen Verstand. Würfle jeden Morgen W4; bei einer 1 nimmst du deine ursprüngliche Gestalt wieder an.'),
    (18, 18, 'Du wirst eine Alterskategorie jünger, zum Beispiel von Erwachsen zu Jung. Deine Attribute und abgeleiteten Werte ändern sich entsprechend, deine Fertigkeitswerte jedoch nicht. Warst du bereits Jung, wirst du zu einem Kind mit -2 auf STÄ und KON (mindestens 3). Der Effekt ist dauerhaft, und du alterst normal weiter.'),
    (19, 19, 'Du wirst eine Alterskategorie älter, zum Beispiel von Erwachsen zu Alt. Deine Attribute und abgeleiteten Werte ändern sich entsprechend, deine Fertigkeitswerte jedoch nicht. Warst du bereits Alt, wirst du sehr gebrechlich und erhältst -2 auf STÄ und KON. Der Effekt ist dauerhaft, und du alterst normal weiter.'),
    (20, 20, 'Deine Magie zieht einen Dämon aus einer anderen Dimension an. Er erscheint im Laufe des nächsten Tagesabschnitts und greift an oder sorgt auf andere Weise für Ärger. Die Details bestimmt die Spielleitung.');

-- catalog_fear_events
INSERT INTO catalog_fear_events (id, roll, name_de, effect_de) VALUES
    (1, 1, 'Entkräftet', 'Die Angst raubt dir die Kraft und Entschlossenheit. Du verlierst 2W6 WP (bis zu einem Minimum von null) und bist Verzagt.'),
    (2, 2, 'Erschüttert', 'Du erleidest den Zustand Verängstigt.'),
    (3, 3, 'Keuchend', 'Die heftige Angst nimmt dir den Atem, sodass du Erschöpft bist.'),
    (4, 4, 'Fahlbleich', 'Du und alle Spielercharaktere im Umkreis von 10 m seid Verängstigt.'),
    (5, 5, 'Schreien', 'Du schreist vor Grauen, was dazu führt, dass alle Spielercharaktere, die den Schrei hören, ebenfalls einen Furchtangriff erleiden. Jede Person muss eine WIL-Probe gelingen, um demselben Furchtangriff zu widerstehen.'),
    (6, 6, 'Rasend', 'Deine Angst verwandelt sich in Zorn, und du bist in deinem nächsten Zug gezwungen, ihre Quelle anzugreifen – im Nahkampf, wenn möglich. Außerdem bist du Wütend.'),
    (7, 7, 'Erstarrt', 'Du bist starr vor Schreck und kannst dich nicht bewegen. In deinem nächsten Zug kannst du weder eine Aktion noch eine Bewegung durchführen. Lege in jedem folgenden Zug eine weitere WIL-Probe ab (keine Aktion), um die Erstarrung zu lösen.'),
    (8, 8, 'Völlig panisch', 'In einem Anfall unkontrollierter Panik flüchtest du so schnell du kannst vom Ort des Geschehens. In deinem nächsten Zug musst du mit einem Sprint vor der Quelle deiner Angst fliehen. Lege in jedem folgenden Zug eine weitere WIL-Probe ab (keine Aktion), um die Flucht zu beenden und wieder wie üblich zu handeln.');

-- catalog_rest_types
INSERT INTO catalog_rest_types (code, name_de, duration_de, effect_de) VALUES
    ('kurze_rast', 'Kurze Rast', '1 Viertel', 'Dauert ein Viertel. Heilt W6 TP, beziehungsweise 2W6 TP, falls dich jemand pflegt und dabei eine gelungene Heilkunde-Probe ablegt (die Pflegenden können währenddessen selbst nicht rasten und nur eine Person gleichzeitig heilen). Während des Viertels erhältst du außerdem W6 WP zurück und erholst dich von einem Zustand deiner Wahl. Nur einmal pro Tagesabschnitt möglich.'),
    ('lange_rast', 'Lange Rast', '1 Tagesabschnitt', 'Dauert einen ganzen Tagesabschnitt und kann nur an einem sicheren Ort eingelegt werden, an dem sich keine Feinde in der Nähe aufhalten. Heilt alle verlorenen TP und WP zurück und entfernt sämtliche Zustände. Wird die Rast unterbrochen, ist sie wirkungslos.'),
    ('verschnaufen', 'Verschnaufen', '1 Runde', 'Dauert lediglich eine Runde im Kampf. Du erhältst nur W6 WP zurück, aber keine TP. Du kannst nur einmal pro Tagesabschnitt verschnaufen.');

-- catalog_hazards
INSERT INTO catalog_hazards (code, name_de, description_de) VALUES
    ('dunkelheit', 'Dunkelheit', 'In völliger Dunkelheit kannst du weder sprinten noch mit Fernkampfangriffen treffen. Um im Nahkampf einen Feind anzugreifen, musst du eine erfolgreiche Wahrnehmung-Probe ablegen (keine Aktion).

Fackeln: Eine Fackel erleuchtet einen Umkreis von bis zu 10 Metern (5 Feldern) in alle Richtungen. Das Entzünden zählt als Aktion, sofern Feuerstein und Zunder oder ein Feuer notwendig ist, alternativ der Zaubertrick Entzünden. Eine Fackel wird in einer Hand gehalten, sodass gleichzeitig keine zweite Einhandwaffe geführt werden kann. Eine Fackel kann als Waffe eingesetzt werden und gilt als kleiner Holzknüppel, der Feuerschaden verursacht. Immer wenn du jemanden damit triffst, musst du sofort würfeln, um festzustellen, ob die Flamme ausgeht.

Fackeln oder Laternen können einen Tagesabschnitt lang brennen, sind aber unzuverlässig. Nach jedem Viertel oder wenn die Spielleitung die Spannung steigern will, musst du einen W6 würfeln. Eine 1 bedeutet, dass die Flamme ausgeht.'),
    ('furcht', 'Furcht', 'In den Ruinen und Wäldern von Dragonbane hausen viele grässliche Bestien. Diese Geschöpfe können sogenannte Furchtangriffe durchführen, die auch durch Magie und andere erschreckende Erfahrungen ausgelöst werden können.

Wenn du einen Furchtangriff erleidest, musst du sofort eine Probe auf WIL ablegen. Du kannst den Wurf strapazieren (optionale Regel), und er gilt nicht als Aktion. Durch besonders grauenhafte Ereignisse erleidest du einen Nachteil auf den Wurf. Falls die WIL-Probe scheitert, musst du auf der Furchttabelle würfeln.'),
    ('gift', 'Gift', 'Gifte werden nach ihrer Wirkstärke bemessen. Ein schwaches Gift hat Wirkstärke 9, ein mittelstarkes Gift Wirkstärke 12, ein starkes Gift Wirkstärke 15 oder höher. Immer wenn du ein Gift einnimmst, legt die Spielleitung eine offene vergleichende Probe zwischen der Wirkstärke und deiner KON ab. Gewinnt das Gift, erleidest du die volle Wirkung. Verlierst du, erleidest du nur die eingeschränkte Wirkung. Gifte haben keine Auswirkung auf Monster.

Lähmungsgift – Volle Wirkung: Du bist Erschöpft und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, kannst du dich in dieser Runde weder bewegen noch eine Aktion durchführen (nicht einmal Freie Aktionen). Die Wirkung lässt nach einem Viertel oder der Einnahme eines Gegengifts nach. Eingeschränkte Wirkung: Du bist Erschöpft.

Tödliches Gift – Volle Wirkung: In deinem Zug erleidest du in jeder Runde W6 Schaden, bis deine TP auf null sinken. Nimmst du rechtzeitig ein Gegengift ein, wird die Wirkung unterbrochen. Eingeschränkte Wirkung: Bei deinem nächsten Zug erleidest du W6 Schaden.

Schlafgift – Volle Wirkung: Du bist Benommen und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, schläfst du ein und wachst erst nach einer ganzen Schicht wieder auf. Sobald du ein Gegengift erhältst oder wenigstens einen Schadenspunkt erleidest, wachst du auf. Eingeschränkte Wirkung: Du bist Benommen.'),
    ('kaelte', 'Kälte', 'Sobald es bitterkalt wird und dir (nach Ermessen der Spielleitung) die passende Unterkunft fehlt, musst du immer wieder Wildnisleben-Proben ablegen. Für gewöhnlich würfelst du in jeder Schicht einmal, aber in extremer Kälte musst du in jedem Viertel oder sogar in jeder Runde würfeln. Falls du keine Decke besitzt, bekommst du einen Nachteil auf deine Probe, wohingegen ein Fell einen Vorteil verleiht.

Bei einem Fehlschlag verlierst du W6 TP und W6 WP und kannst dich von diesen und anderen Zuständen nicht erholen, außer durch Magie. Danach musst du weiterhin würfeln, wobei sich die gleiche Wirkung einstellt, falls du scheiterst. Sollten deine TP aufgrund von Kälte auf null sinken, stirbst du, sobald du den nächsten Wurf ablegen müsstest. Erst wenn dir warm wird, und sei es an einem Lagerfeuer, musst du nicht mehr würfeln und kannst dich wie üblich erholen.'),
    ('schwimmen_ertrinken', 'Schwimmen & Ertrinken', 'Alle Spielercharaktere können einigermaßen gut schwimmen. Im Wasser ist dein Bewegungswert halb so groß wie an Land. Im Wasser können keine Fernkampfangriffe durchgeführt werden, und Nahkampfangriffe erfolgen mit Nachteil. Schwierigere Unterwasser-Bewegungen – wie das Tauchen nach etwas – erfordern eine Schwimmen-Probe. Du erleidest einen Nachteil, wenn du dabei ein Kettenhemd oder einen Plattenpanzer trägst.

Außerdem musst du im Wasser nach jedem Viertel eine Schwimmen-Probe ablegen, um an der Oberfläche zu bleiben. Falls du ein Kettenhemd oder einen Plattenpanzer trägst, musst du in jeder Runde würfeln. Unter Wasser muss dir in jeder Runde eine KON-Probe gelingen, um den Atem anzuhalten (keine Aktion). Scheitert der Wurf, ertrinkst du und erleidest in jeder Runde W6 Schaden, bis dich jemand rettet. Sollten deine TP beim Ertrinken auf null sinken, legst du wie üblich Todeswürfe ab, allerdings zählen nur die gescheiterten Würfe.'),
    ('sturzschaden', 'Sturzschaden', 'Ein Sturz auf eine harte Oberfläche verursacht Wuchtschaden in Höhe einer Anzahl von W6 gleich der halben, abgerundeten Sturzhöhe in Metern. Ein Sturz aus weniger als 2 Metern verursacht keinen Schaden. Eine gelungene Akrobatik-Probe senkt die Anzahl der W6 um die Hälfte (aufgerundet). Rüstungen schützen nicht gegen Sturzschaden.');

-- ============================================================
-- Wurftabellen, Dienste und Gewichte (Grundregelwerk)
-- ============================================================

-- catalog_roll_tables
INSERT INTO catalog_roll_tables (code, group_de, title_de, die_de, headers_de, intro_de, display_order) VALUES
    ('reise_missgeschicke', 'Reise & Wildnis', 'Reise-Missgeschicke', 'W12', 'Missgeschick|Wirkung', 'Würfle am Tisch, wenn dem Wegführer einer Gruppe auf Reisen die Wildnisleben-Probe misslingt.', 10),
    ('jagd', 'Reise & Wildnis', 'Jagd', 'W6', 'Tier|Voraussetzung|Rationen', 'Erst gelingt die Jagen-&-Fischen-Probe, dann wird gewürfelt, welches Tier es ist. Das Töten erfordert einen zweiten Wurf (Waffe oder Jagen & Fischen bei einer Falle). * Wildschweine greifen an, wenn der Jagdwurf misslingt.', 20),
    ('abenteuerort_verlassen', 'Reise & Wildnis', 'Den Abenteuerort verlassen', 'W6', 'Folge|Wirkung', 'Einen gefährlichen Ort voller Feinde (etwa eine Höhle) zu verlassen, um zu lagern oder eine Rast einzulegen, kann riskant sein. Würfle am Tisch, wenn die Charaktere den Ort für mindestens einen Tagesabschnitt verlassen. Ignoriere das Ergebnis, wenn es offensichtlich keinen Sinn ergibt.', 30),
    ('improvisiert_gasthaus', 'Improvisierte Waffen', 'Improvisierte Waffen: Gasthaus', 'W6', 'Waffe|Wirkung', 'Zu Kampfbeginn kann die Spielleitung W3 improvisierte Waffen auswürfeln oder festlegen. Jede wird nur einmal benutzt und dann verbraucht. Die Nutzung ist eine Aktion und kann mit Bewegung kombiniert werden.', 40),
    ('improvisiert_hoehle', 'Improvisierte Waffen', 'Improvisierte Waffen: Höhle', 'W6', 'Waffe|Wirkung', 'Zu Kampfbeginn kann die Spielleitung W3 improvisierte Waffen auswürfeln oder festlegen. Jede wird nur einmal benutzt und dann verbraucht. Die Nutzung ist eine Aktion und kann mit Bewegung kombiniert werden.', 41),
    ('improvisiert_wald', 'Improvisierte Waffen', 'Improvisierte Waffen: Wald', 'W6', 'Waffe|Wirkung', 'Zu Kampfbeginn kann die Spielleitung W3 improvisierte Waffen auswürfeln oder festlegen. Jede wird nur einmal benutzt und dann verbraucht. Die Nutzung ist eine Aktion und kann mit Bewegung kombiniert werden.', 42),
    ('nsc_haltung', 'NSC erschaffen', 'Haltung', 'W4', 'Ergebnis', 'Würfle je einen Würfel jeder Art am Tisch, um einen zufälligen NSC zu erschaffen. Die Tabellen sind Anregungen, Änderungen sind erlaubt.', 60),
    ('nsc_volk', 'NSC erschaffen', 'Volk', 'W6', 'Ergebnis', NULL, 61),
    ('nsc_motivation', 'NSC erschaffen', 'Motivation', 'W8', 'Ergebnis', NULL, 62),
    ('nsc_beruf', 'NSC erschaffen', 'Beruf', 'W10', 'Ergebnis', NULL, 63),
    ('nsc_eigenart', 'NSC erschaffen', 'Eigenart', 'W12', 'Ergebnis', NULL, 64),
    ('nsc_name', 'NSC erschaffen', 'Name (einen wählen)', 'W20', 'Ergebnis', NULL, 65);

-- catalog_roll_table_rows
INSERT INTO catalog_roll_table_rows (table_code, roll_min, roll_max, name_de, effect_de, extra_de) VALUES
    ('reise_missgeschicke', 1, 1, 'Nebel', 'Die Gruppe wird von dichtem Nebel überrascht. Die in diesem Tagesabschnitt zurückgelegte Strecke wird halbiert.', NULL),
    ('reise_missgeschicke', 2, 2, 'Versperrtes Gelände', 'Felsen, umgestürzte Bäume, dichtes Gestrüpp oder Hochwasser versperren den Weg. Jeder Spielercharakter muss eine Akrobatik-Probe ablegen, um weiterzukommen. Wer besteht, kann den anderen helfen. Wer scheitert, macht in diesem Tagesabschnitt keinen Fortschritt.', NULL),
    ('reise_missgeschicke', 3, 3, 'Zerrissene Kleidung', 'Der Wegführer führt die Gruppe in ein Dornendickicht, eine felsige Schlucht oder einen Sumpf. Die Kleidung eines zufälligen Spielercharakters wird beschädigt und zählt nun als Lumpen.', NULL),
    ('reise_missgeschicke', 4, 4, 'Verirrt', 'Die Charaktere merken, dass sie im Kreis laufen, und kommen in diesem Tagesabschnitt auf der Karte nicht voran. Der Wegführer muss außerdem eine Wildnisleben-Probe ablegen, um den richtigen Weg wiederzufinden. Andere können nicht helfen.', NULL),
    ('reise_missgeschicke', 5, 5, 'Gegenstand verloren', 'Ein zufälliger Spielercharakter lässt einen Gegenstand nach Wahl der Spielleitung fallen oder zerbricht ihn.', NULL),
    ('reise_missgeschicke', 6, 6, 'Mückenschwarm', 'Ein großer Schwarm Mücken oder Gnitzen greift die Gruppe an und macht alle mit Stichen und Gesumm verrückt. Alle Spielercharaktere ohne Umhang werden Wütend.', NULL),
    ('reise_missgeschicke', 7, 7, 'Verstauchter Knöchel', 'Ein zufälliger Spielercharakter stürzt oder tritt fehl und erleidet W6 Schaden. Rüstung hat keine Wirkung, Stiefel verringern den Schaden um zwei.', NULL),
    ('reise_missgeschicke', 8, 8, 'Wolkenbruch', 'Ein gewaltiger Regenguss oder Schneesturm (je nach Jahreszeit) überrascht die Gruppe. Alle Spielercharaktere ohne Umhang müssen eine Probe ablegen, um der Kälte zu widerstehen (siehe Kälte). Sie müssen außerdem Schutz suchen, bis der Sturm vorüber ist, und kommen in diesem Tagesabschnitt auf der Karte nicht voran.', NULL),
    ('reise_missgeschicke', 9, 9, 'Wespen', 'Der Wegführer tritt mitten in ein Wespennest. Ein Schwarm wütender Wespen greift die ganze Gruppe an. Alle Spielercharaktere müssen eine Ausweichen-Probe ablegen. Wer scheitert, erleidet W6 Schaden und einen Zustand nach Wahl.', NULL),
    ('reise_missgeschicke', 10, 10, 'Erdrutsch', 'Die Gruppe geht durch unwegsames Gelände, als plötzlich der Boden unter den Füßen nachgibt. Alle müssen eine Ausweichen-Probe ablegen. Wer scheitert, erleidet W10 Schaden.', NULL),
    ('reise_missgeschicke', 11, 11, 'Wildes Tier', 'Ein Wolf, Bär oder anderes wildes Tier fühlt sich bedroht und greift die Abenteurer an. Wähle ein Tier aus dem Bestiarium (Kategorie Tier).', NULL),
    ('reise_missgeschicke', 12, 12, 'Treibsand', 'Der Boden bricht ein! Jeder Spielercharakter muss eine Wildnisleben-Probe ablegen. Wer scheitert, erleidet einen Zustand und muss erneut würfeln. Ein Charakter, der bereits alle Zustände hat und die Probe nicht schafft, wird vom Treibsand verschluckt und verschwindet für immer. Wer frei ist, kann den Festsitzenden helfen.', NULL),
    ('jagd', 1, 1, 'Eichhörnchen', 'Waffe oder Falle', '1'),
    ('jagd', 2, 2, 'Krähe', 'Waffe', '1'),
    ('jagd', 3, 3, 'Kaninchen', 'Waffe oder Falle', 'W3'),
    ('jagd', 4, 4, 'Fuchs', 'Waffe oder Falle', 'W4'),
    ('jagd', 5, 5, 'Wildschwein *', 'Waffe', '2W6'),
    ('jagd', 6, 6, 'Hirsch', 'Waffe', '2W8'),
    ('abenteuerort_verlassen', 1, 1, 'Verfolger', 'Gegner vom Abenteuerort folgen der Gruppe und greifen im ungünstigsten Moment an.', NULL),
    ('abenteuerort_verlassen', 2, 2, 'Verstärkung', 'Die Gegner am Abenteuerort erhalten Verstärkung. Gefallene Gegner werden doppelt ersetzt.', NULL),
    ('abenteuerort_verlassen', 3, 3, 'Beute weg', 'Jemand anderes erreicht den Abenteuerort und räumt ihn aus, bevor die Charaktere zurückkehren.', NULL),
    ('abenteuerort_verlassen', 4, 6, 'Nichts', 'Nichts passiert.', NULL),
    ('improvisiert_gasthaus', 1, 1, 'Kochender Kessel', 'Schütte das kochende Wasser in einem Kegel, 4 Meter lang und breit. Alle im Kegel erleiden 2W6 Schaden. Der Angriff kann ausgewichen, aber nicht pariert werden. Rüstung hat keine Wirkung.', NULL),
    ('improvisiert_gasthaus', 2, 2, 'Eimer Seifenwasser', 'Schütte das Seifenwasser in einem Kegel, 4 Meter lang und breit. Alle im Kegel stürzen zu Boden. Der Angriff kann ausgewichen, aber nicht pariert werden.', NULL),
    ('improvisiert_gasthaus', 3, 3, 'Brennendes Brennholz', 'Schlage einen Feind innerhalb von 2 Metern mit dem Holzscheit. Erfordert eine freie Hand. Der Angriff trifft automatisch und verursacht 2W6 Feuerschaden plus Schadensbonus. Er kann ausgewichen oder pariert werden. Das Holzscheit kann danach als Fackel dienen.', NULL),
    ('improvisiert_gasthaus', 4, 4, 'Wühlendes Schwein', 'Lege eine Wildnisleben-Probe ab, um das Schwein aufzuscheuchen, damit es einen Feind deiner Wahl innerhalb von 10 Metern angreift. Der Angriff trifft automatisch und verursacht 3W6 Wuchtschaden. Er kann ausgewichen, aber nicht pariert werden. Danach stürmt das Schwein davon.', NULL),
    ('improvisiert_gasthaus', 5, 5, 'Weinflasche', 'Schlage einen Feind innerhalb von 2 Metern mit der Flasche. Erfordert eine freie Hand. Der Angriff trifft automatisch und verursacht 2W6 Wuchtschaden plus Schadensbonus. Er kann ausgewichen oder pariert werden. Dem Feind spritzt Wein in die Augen und brennt so stark, dass er bis zu deinem nächsten Zug einen Nachteil auf alle Aktionen hat.', NULL),
    ('improvisiert_gasthaus', 6, 6, 'Kronleuchter', 'Schwinge dich vom Kronleuchter und führe einen Nahkampfangriff aus. Du kannst eine normale Bewegung ausführen, ohne freie Angriffe auszulösen. Der Nahkampfangriff muss unbewaffnet sein, kann aber weder ausgewichen noch pariert werden. Misslingt der Angriff, stürzt du zu Boden und erleidest W6 Wuchtschaden.', NULL),
    ('improvisiert_hoehle', 1, 1, 'Stalaktit', 'Stoße einen Feind innerhalb von 2 Metern in die scharfen Felsformationen an der Decke. Der Angriff trifft automatisch und verursacht 2W6 Stichschaden plus Schadensbonus. Er kann ausgewichen, aber nicht pariert werden. Rüstung hat keine Wirkung, außer Helmen.', NULL),
    ('improvisiert_hoehle', 2, 2, 'Fackel', 'Nimm eine Fackel von der Wand und schlage einen Feind innerhalb von 2 Metern. Erfordert eine freie Hand. Der Angriff trifft automatisch und verursacht 2W6 Feuerschaden plus Schadensbonus. Er kann ausgewichen oder pariert werden. Du kannst die Fackel danach behalten.', NULL),
    ('improvisiert_hoehle', 3, 3, 'Stalagmit', 'Stoße einen Feind innerhalb von 2 Metern gegen eine hohe Felsformation am Höhlenboden. Der Angriff trifft automatisch und verursacht W6 Wuchtschaden plus Schadensbonus und wirft den Feind zu Boden. Er kann ausgewichen, aber nicht pariert werden.', NULL),
    ('improvisiert_hoehle', 4, 4, 'Pfütze', 'Versuche, den Feind zu Fall zu bringen (siehe Besondere Nahkampfangriffe). Gelingt es, muss der Feind eine Aktion aufwenden und eine Akrobatik-Probe ablegen, um wieder aufzustehen.', NULL),
    ('improvisiert_hoehle', 5, 5, 'Spalte', 'Versuche, den Feind zu Fall zu bringen. Gelingt es, stürzt der Feind in eine 2W6 Meter tiefe Spalte und erleidet Sturzschaden. Das Hinausklettern erfordert eine Akrobatik-Probe.', NULL),
    ('improvisiert_hoehle', 6, 6, 'Fledermäuse', 'Lege eine Wildnisleben-Probe ab, um die Fledermäuse aufzuscheuchen, damit sie einen Feind innerhalb von 10 Metern angreifen. Werte siehe Bestiarium. Die Fledermäuse greifen den Feind W3 Runden lang an. Misslingt die Probe, greifen sie dich an.', NULL),
    ('improvisiert_wald', 1, 1, 'Tiefer Ast', 'Schwinge dich vom Ast und führe einen Nahkampfangriff aus. Du kannst eine normale Bewegung ausführen, ohne freie Angriffe auszulösen. Der Nahkampfangriff muss unbewaffnet sein, kann aber weder ausgewichen noch pariert werden. Misslingt der Angriff, stürzt du zu Boden und erleidest W6 Wuchtschaden.', NULL),
    ('improvisiert_wald', 2, 2, 'Wespennest', 'Lege eine Wildnisleben-Probe ab, um das Wespennest aufzuheben und auf einen Feind innerhalb von 10 Metern zu schleudern. Der Feind wird übel gestochen: 2W6 Schaden und ein Nachteil auf alle Aktionen für einen Tagesabschnitt. Der Angriff kann ausgewichen, aber nicht pariert werden. Rüstung hat keine Wirkung. Misslingt die Probe, stechen dich die Wespen.', NULL),
    ('improvisiert_wald', 3, 3, 'Knorrige Wurzeln', 'Versuche, den Feind zu Fall zu bringen. Gelingt es, muss der Feind eine Aktion aufwenden und eine Akrobatik-Probe ablegen, um wieder aufzustehen.', NULL),
    ('improvisiert_wald', 4, 4, 'Felsbrocken', 'Lege eine Akrobatik-Probe ab, um auf den Felsbrocken zu springen und dich auf einen Feind innerhalb von 2 Metern zu stürzen. Der Angriff verursacht 2W6 Wuchtschaden plus Schadensbonus und kann weder ausgewichen noch pariert werden. Gelingt er, fallen du und der Feind zu Boden. Misslingt die Probe, stürzt nur du und erleidest W6 Schaden.', NULL),
    ('improvisiert_wald', 5, 5, 'Viper', 'Lege eine Wildnisleben-Probe ab, um die Schlange aufzuheben und auf einen Feind innerhalb von 10 Metern zu werfen. Der Feind wird gebissen und erleidet W6 Schaden sowie ein tödliches Gift mit Wirkstärke 12, falls der Biss die Rüstung durchdringt. Der Angriff kann ausgewichen, aber nicht pariert werden. Misslingt die Probe, beißt dich die Schlange.', NULL),
    ('improvisiert_wald', 6, 6, 'Dreckklumpen', 'Wirf Dreck in die Augen eines Feindes innerhalb von 10 Metern. Der Feind erleidet W6 Schaden (Rüstung hat keine Wirkung) und hat für den Rest des Kampfes einen Nachteil auf alle Aktionen. Der Angriff kann ausgewichen, aber nicht pariert werden.', NULL),
    ('nsc_haltung', 1, 1, 'Feindselig', NULL, NULL),
    ('nsc_haltung', 2, 2, 'Ausweichend', NULL, NULL),
    ('nsc_haltung', 3, 3, 'Gleichgültig', NULL, NULL),
    ('nsc_haltung', 4, 4, 'Freundlich', NULL, NULL),
    ('nsc_volk', 1, 1, 'Mensch', NULL, NULL),
    ('nsc_volk', 2, 2, 'Zwerg', NULL, NULL),
    ('nsc_volk', 3, 3, 'Elf', NULL, NULL),
    ('nsc_volk', 4, 4, 'Halbling', NULL, NULL),
    ('nsc_volk', 5, 5, 'Wolfsmensch', NULL, NULL),
    ('nsc_volk', 6, 6, 'Ente', NULL, NULL),
    ('nsc_motivation', 1, 1, 'Süßes, glitzerndes Gold', NULL, NULL),
    ('nsc_motivation', 2, 2, 'Wissen über die Welt', NULL, NULL),
    ('nsc_motivation', 3, 3, 'Tiefe, ewige Liebe', NULL, NULL),
    ('nsc_motivation', 4, 4, 'Ein lebenslanger Eid', NULL, NULL),
    ('nsc_motivation', 5, 5, 'Ein Unrecht, das Vergeltung verlangt', NULL, NULL),
    ('nsc_motivation', 6, 6, 'Ein Leben voller Freude und Gesang', NULL, NULL),
    ('nsc_motivation', 7, 7, 'Blutsbande, die nie gelöst werden können', NULL, NULL),
    ('nsc_motivation', 8, 8, 'Flucht vor einer dunklen Vergangenheit', NULL, NULL),
    ('nsc_beruf', 1, 1, 'Barde', NULL, NULL),
    ('nsc_beruf', 2, 2, 'Handwerker', NULL, NULL),
    ('nsc_beruf', 3, 3, 'Jäger', NULL, NULL),
    ('nsc_beruf', 4, 4, 'Kämpfer', NULL, NULL),
    ('nsc_beruf', 5, 5, 'Gelehrter', NULL, NULL),
    ('nsc_beruf', 6, 6, 'Magier', NULL, NULL),
    ('nsc_beruf', 7, 7, 'Händler', NULL, NULL),
    ('nsc_beruf', 8, 8, 'Ritter', NULL, NULL),
    ('nsc_beruf', 9, 9, 'Seefahrerin', NULL, NULL),
    ('nsc_beruf', 10, 10, 'Dieb', NULL, NULL),
    ('nsc_eigenart', 1, 1, 'Redet zu viel', NULL, NULL),
    ('nsc_eigenart', 2, 2, 'Seltsame Kleidung', NULL, NULL),
    ('nsc_eigenart', 3, 3, 'Wilder Blick', NULL, NULL),
    ('nsc_eigenart', 4, 4, 'Riecht schlecht', NULL, NULL),
    ('nsc_eigenart', 5, 5, 'Scherzbold', NULL, NULL),
    ('nsc_eigenart', 6, 6, 'Kultist', NULL, NULL),
    ('nsc_eigenart', 7, 7, 'Ein bisschen kindisch', NULL, NULL),
    ('nsc_eigenart', 8, 8, 'Ruhig und schwierig', NULL, NULL),
    ('nsc_eigenart', 9, 9, 'Dämonenanbeter', NULL, NULL),
    ('nsc_eigenart', 10, 10, 'Starrsinnig', NULL, NULL),
    ('nsc_eigenart', 11, 11, 'Sehr empfindlich', NULL, NULL),
    ('nsc_eigenart', 12, 12, 'Äußerst romantisch', NULL, NULL),
    ('nsc_name', 1, 1, 'Agnar, Jorid, Dareios', NULL, NULL),
    ('nsc_name', 2, 2, 'Ragnfast, Ask, Euanthe', NULL, NULL),
    ('nsc_name', 3, 3, 'Arnulf, Tyra, Xanthos', NULL, NULL),
    ('nsc_name', 4, 4, 'Atle, Liv, Athalia', NULL, NULL),
    ('nsc_name', 5, 5, 'Guthorm, Embla, Kleitos', NULL, NULL),
    ('nsc_name', 6, 6, 'Botvid, Ragna, Astara', NULL, NULL),
    ('nsc_name', 7, 7, 'Kale, Turid, Priamus', NULL, NULL),
    ('nsc_name', 8, 8, 'Egil, Jorunn, Galyna', NULL, NULL),
    ('nsc_name', 9, 9, 'Ingemund, Borghild, Taras', NULL, NULL),
    ('nsc_name', 10, 10, 'Gudmund, Gylla, Zenais', NULL, NULL),
    ('nsc_name', 11, 11, 'Grim, Tora, Hesiod', NULL, NULL),
    ('nsc_name', 12, 12, 'Brand, Edda, Liene', NULL, NULL),
    ('nsc_name', 13, 13, 'Folkvid, Sigrun, Eupraxia', NULL, NULL),
    ('nsc_name', 14, 14, 'Germund, Dagrun, Taras', NULL, NULL),
    ('nsc_name', 15, 15, 'Algot, Bolla, Lysandra', NULL, NULL),
    ('nsc_name', 16, 16, 'Tolir, Yrsa, Kallias', NULL, NULL),
    ('nsc_name', 17, 17, 'Hjorvald, Estrid, Isidora', NULL, NULL),
    ('nsc_name', 18, 18, 'Ambjörn, Signe, Athos', NULL, NULL),
    ('nsc_name', 19, 19, 'Grunn, Tilde, Larysa', NULL, NULL),
    ('nsc_name', 20, 20, 'Olgrid, Idun, Nikias', NULL, NULL);

-- catalog_services
INSERT INTO catalog_services (name_de, rarity, price_gold, price_silver, price_copper, unit_de, effect_de) VALUES
    ('Bad im Gasthaus', 'gewöhnlich', 0, 0, 6, NULL, 'Heilt einen Zustand deiner Wahl in einem Viertel. Nur ein Bad pro Tag hat diese Wirkung.'),
    ('Leibwächter', 'ungewöhnlich', 2, 0, 0, 'pro Tag', 'Werte wie die Wache unter Typische NSC im Bestiarium.'),
    ('Schüssel Eintopf', 'gewöhnlich', 0, 0, 5, NULL, 'Deckt den täglichen Nahrungsbedarf.'),
    ('Kleiderreparatur', 'gewöhnlich', 0, 5, 0, NULL, 'Hebt die Wirkung zerrissener Kleidung auf (siehe Reise-Missgeschicke).'),
    ('Bote', 'gewöhnlich', 0, 1, 0, 'pro Kilometer', 'Überbringt eine Nachricht an den Empfänger.'),
    ('Festmahl', 'ungewöhnlich', 2, 0, 0, NULL, 'Deckt den täglichen Nahrungsbedarf.'),
    ('Becher Wein', 'ungewöhnlich', 0, 2, 0, NULL, 'Nach zwei Bechern in einem Tagesabschnitt verursacht jeder weitere einen Zustand deiner Wahl.'),
    ('Haarschnitt', 'gewöhnlich', 0, 2, 0, NULL, 'Heilt einen gewählten Zustand in einem Viertel. Nur einmal pro Woche möglich.'),
    ('Heilung', 'ungewöhnlich', 5, 0, 0, NULL, 'Heilkunde-Proben gelingen automatisch.'),
    ('Unterkunft im Gasthaus, Einzelzimmer', 'gewöhnlich', 0, 5, 0, NULL, 'Eine Rast über einen Tagesabschnitt ist ohne Wildnisleben-Probe möglich.'),
    ('Unterkunft im Gasthaus, Schlafsaal', 'gewöhnlich', 0, 1, 0, NULL, 'Eine Rast über einen Tagesabschnitt ist ohne Wildnisleben-Probe möglich, aber würfle in jedem Tagesabschnitt einen W4. Bei einer 1 hindert jemandes Schnarchen alle anderen im Raum am Schlafen.'),
    ('Unterkunft im Gasthaus, Luxussuite', 'ungewöhnlich', 2, 0, 0, NULL, 'Eine Rast über einen Tagesabschnitt ist ohne Wildnisleben-Probe möglich.'),
    ('Mahlzeit im Gasthaus', 'gewöhnlich', 0, 3, 0, NULL, 'Deckt den täglichen Nahrungsbedarf.'),
    ('Wegzoll', 'gewöhnlich', 0, 0, 2, NULL, 'Erlaubt die Durchreise.'),
    ('Postkutsche', 'gewöhnlich', 0, 0, 3, 'pro Kilometer', 'Beförderung zu einem bestimmten Ziel.'),
    ('Humpen Met', 'gewöhnlich', 0, 0, 4, NULL, 'Nach drei Humpen in einem Tagesabschnitt verursacht jeder weitere einen Zustand deiner Wahl.'),
    ('Lehrer', 'ungewöhnlich', 5, 0, 0, 'pro Tagesabschnitt, oder mehr', 'Ein Tagesabschnitt Unterricht gewährt einen zusätzlichen Steigerungswurf (siehe Erfahrung).');

-- Gewichte (Traglast): Standard ist 1; Kleinkram 0; schwere Gegenstände 2 bis 4
UPDATE catalog_items SET weight = 0 WHERE name_de IN ('Feuerstein & Zunder', 'Talgkerze', 'Rucksack', 'Nadel & Faden', 'Würfel', 'Karte', 'Vorhängeschloss', 'Spielkarten', 'Seil (Seide), 10m', 'Satteltasche', 'Pfeife (Signalpfeife)', 'Amulett', 'Brosche', 'Kreide', 'Papier (Blatt)', 'Pergament (Blatt)');
UPDATE catalog_items SET weight = 0.25 WHERE name_de = 'Tagesration';
UPDATE catalog_items SET weight = 2 WHERE name_de IN ('Fass', 'Feldküche', 'Vorschlaghammer', 'Zelt, klein', 'Fischernetz');
UPDATE catalog_items SET weight = 3 WHERE name_de = 'Truhe';
UPDATE catalog_items SET weight = 4 WHERE name_de = 'Zelt, groß';


-- ============================================================
-- Bestiary und Begegnungstabellen
-- ============================================================

-- catalog_bestiary
INSERT INTO catalog_bestiary (id, name_de, category_de, is_unique, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de, image_path) VALUES
    (1, 'Riesenspinne', 'Tier', 0, 36, '2', 'Normal', 24, '—', NULL, NULL, NULL, NULL, NULL),
    (2, 'Vampirfledermaus', 'Tier', 0, 18, '2', 'Schwarm', 24, '—', 'Die Fledermäuse greifen als Schwarm an und zählen als eine Kreatur. Jeder Schaden durch physische Waffen, selbst magische, wird halbiert (aufgerundet). Feuer verursacht jedoch normalen Schaden.', NULL, NULL, NULL, NULL),
    (4, 'Der Gruftschrecken von Ridderhöhe', 'Untot', 1, 38, '2', 'Normal', 10, '8', 'Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden. Wird er innerhalb der Eichentür zum Vestibül (#3) besiegt, erhebt er sich im Laufe eines Tagesabschnitts wieder in Raum #9. Schwingt einen Morgenstern (2W8 Wuchtschaden).', NULL, NULL, NULL, NULL),
    (5, 'Monster-Aal', 'Tier', 0, 28, '2', 'Groß', 14, '3', NULL, NULL, NULL, NULL, NULL),
    (6, 'Geist des Bibliothekars', 'Untot', 0, 30, '2', 'Normal', 12, '—', NULL, 'Immun gegen jeden Schaden außer durch Magie und Feuer.', NULL, NULL, NULL),
    (7, 'Verzauberte Galionsfigur', 'Konstrukt', 0, 24, '1', 'Normal', 10, 'Hartes Holz (3)', 'Verwundbarkeit: Für jeden geöffneten Vorhang in der Kammer des Zauberers wird eine Galionsfigur wieder zu unbelebter Materie. Außerdem erleiden sie durch Feuer doppelten Schaden.', NULL, NULL, NULL, NULL),
    (8, 'Krakul', 'Drache', 1, 64, '2', 'Groß', 4, '6', 'Gier nach dem Smaragd: Wenn der Lindwurm jemanden sieht, der den Smaragd trägt oder versucht, ihn zu nehmen, greift er diese Person sofort an.', NULL, NULL, NULL, NULL),
    (9, 'Gruftschrecken', 'Untot', 0, 38, '2', 'Normal', 10, 'Wie Rüstung', 'Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden.', NULL, NULL, 'Typische Ausrüstung: Morgenstern, Kettenhemd', NULL),
    (10, 'Geist', 'Untot', 0, 27, '2', 'Normal', 12, '—', NULL, 'Geister sind körperlose Wesen und immun gegen jeglichen Schaden außer durch Magie und Feuer. Ein besiegter Geist wird nur für einen Tagesabschnitt gebannt; danach kehrt er zurück. Die einzige Möglichkeit, ihn dauerhaft zu bannen, ist der Zauber Verbannen oder die Lösung des Problems, das ihn an die Welt der Lebenden bindet.', 'Überredbar: Anders als andere Monster kann ein Geist für gewöhnlich überredet werden, wenn auch mit einem Nachteil auf den Wurf.', NULL, NULL),
    (11, 'Skelett – Krieger', 'Untot', 0, 8, '—', '—', 8, 'Beschlagenes Leder (2)', 'Erleidet halben Stichschaden (aufgerundet).', 'Skelette sind immun gegen Furcht und Überreden.', 'Kein Monster: Skelette zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.', 'Schadensbonus: —
Fertigkeiten: Wahrnehmung 8, Ausweichen 6
Typische Waffe: Kurzschwert (Fertigkeitswert 12, Schaden W10)', NULL),
    (12, 'Skelett – Bogenschütze', 'Untot', 0, 8, '—', '—', 8, 'Lederrüstung (1)', 'Erleidet halben Stichschaden (aufgerundet).', 'Skelette sind immun gegen Furcht und Überreden.', 'Kein Monster: Skelette zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.', 'Schadensbonus: —
Fertigkeiten: Wahrnehmung 8, Ausweichen 6
Typische Waffen: Dolch (Fertigkeitswert 10, Schaden W8), Armbrust (Fertigkeitswert 12, Schaden 2W6)', NULL),
    (13, 'Skelett – Champion', 'Untot', 0, 24, '—', '—', 10, 'Kettenhemd (4)', 'Erleidet halben Stichschaden (aufgerundet).', 'Skelette sind immun gegen Furcht und Überreden.', 'Kein Monster: Skelette zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.', 'Schadensbonus: STÄ +W6 · WP: 15
Fertigkeiten: Wahrnehmung 12, Ausweichen 8
Fähigkeiten: Veteran, Defensiv, Doppelhieb, Robust ×4
Typische Waffe: Langschwert (Fertigkeitswert 16, Schaden 2W8), großer Schild', NULL),
    (14, 'Troll', 'Monster', 0, 38, '2', 'Groß', 10, '—', NULL, NULL, 'Regeneration: Ein Troll heilt in jedem seiner Züge automatisch W6 TP.
Empfindlich gegen Sonnenlicht: In direktem Sonnenlicht erleidet ein Troll W6 Schaden pro Runde und kann sich nicht regenerieren. Erreicht er dadurch 0 TP, wird er zu Stein. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.
Überredbar: Anders als andere Monster kann ein Troll für gewöhnlich überredet werden, wenn auch mit einem Nachteil auf den Wurf.', NULL, NULL),
    (15, 'Minotaurus', 'Monster', 0, 32, '2', 'Groß', 16, '—', NULL, NULL, NULL, 'Typische Ausrüstung: Zweihandaxt', NULL),
    (16, 'Ork – Krieger', 'Humanoid', 0, 12, '—', '—', 10, 'Beschlagenes Leder (2)', NULL, NULL, 'Kein Monster: Orks zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Orks einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.', 'Schadensbonus: STÄ +W4
Fertigkeiten: Wahrnehmung 10, Ausweichen 8
Typische Waffe: Krummsäbel (Fertigkeitswert 12, Schaden 2W6)', NULL),
    (17, 'Ork – Schamane', 'Humanoid', 0, 10, '—', '—', 10, '—', NULL, NULL, 'Kein Monster: Orks zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Orks einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.', 'Schadensbonus: — · WP: 10
Fertigkeiten: Animismus 14, Wahrnehmung 12, Ausweichen 8
Zauber: Wurzelgriff, Blitzschlag, Wunden heilen
Typische Waffe: Stab (Fertigkeitswert 10, Schaden W8)', NULL),
    (18, 'Ork – Häuptling', 'Humanoid', 0, 24, '—', '—', 10, 'Kettenhemd (4)', NULL, NULL, 'Kein Monster: Orks zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Orks einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.', 'Schadensbonus: STÄ +W6 · WP: 15
Fertigkeiten: Wahrnehmung 14, Ausweichen 12
Fähigkeiten: Veteran, Defensiv, Zweiwaffenkampf, Robust ×4
Typische Waffe: zwei Krummsäbel (Fertigkeitswert 16, Schaden 2W6)', NULL),
    (19, 'Harpyie', 'Monster', 0, 12, '1/Harpyie', 'Normal', 24, '—', NULL, NULL, 'TP: 12 pro Harpyie.
Schwarm: Harpyien kämpfen gemeinsam, und ihre Monsterangriffe werden von mehreren Harpyien als Gruppe ausgeführt. Diese Angriffe verbrauchen dennoch nur den Zug einer Harpyie pro Runde. Sobald die Hälfte des Schwarms getötet wurde, flieht der Rest und kehrt später zurück, wenn sich eine günstige Gelegenheit bietet.
Flügel: Harpyien greifen aus der Luft an und können nur mit Fernkampfwaffen oder langen Nahkampfwaffen bekämpft werden.', NULL, NULL),
    (20, 'Mantikor', 'Monster', 0, 44, '2', 'Groß', 16, '—', NULL, NULL, NULL, NULL, NULL),
    (21, 'Goblin – Späher', 'Humanoid', 0, 9, '—', '—', 10, 'Lederrüstung (1)', NULL, NULL, 'Kein Monster: Goblins zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Goblins einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.', 'Schadensbonus: —
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12
Typische Waffen: Kurzbogen (Fertigkeitswert 12, Schaden W10), Kurzschwert (Fertigkeitswert 10, Schaden W10)', NULL),
    (22, 'Goblin – Krieger', 'Humanoid', 0, 10, '—', '—', 10, 'Beschlagenes Leder (2)', NULL, NULL, 'Kein Monster: Goblins zählen im Kampf nicht als Monster, sondern als gewöhnliche NPCs.
Nachtaktiv: In direktem Sonnenlicht erhalten Goblins einen Nachteil auf alle Würfe und erleiden W6 Schaden pro Viertel. Eine dicke Wolkendecke oder Kleidung, die den ganzen Körper bedeckt, reicht aus, um den Effekt zu vermeiden.', 'Schadensbonus: —
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12
Typische Waffe: Langspeer (Fertigkeitswert 12, Schaden 2W8)', NULL),
    (23, 'Greif', 'Tier', 0, 38, '2', 'Groß', 30, '—', NULL, NULL, 'Flügel: Die mächtigen Flügel des Greifs erlauben es ihm, sich frei durch die Luft zu bewegen.', NULL, NULL),
    (24, 'Riese', 'Riese', 0, 74, '1', 'Riesig', 18, '—', NULL, NULL, 'Waffen: Riesen tragen oft eine große Waffe. Verliert der Riese seine Waffe, werden die Monsterangriffe Nr. 1 und Nr. 4 neu gewürfelt.
Schwachstelle: Angriffe gegen die Schwachstelle am Scheitel des Riesenkopfes verursachen doppelten Schaden. Den Scheitel zu treffen erfordert entweder einen Fernangriff mit einem Nachteil aus erhöhter Position oder dass der Angreifer zuerst auf den Riesen klettert. Letzteres erfordert eine Akrobatik-Probe mit Nachteil. Wer oben angekommen ist, muss in jedem Zug eine weitere Akrobatik-Probe ablegen (zählt nicht als Aktion), um nicht abgeschüttelt zu werden und 2W6 Sturzschaden zu erleiden.', NULL, NULL),
    (25, 'Drache', 'Drache', 0, 84, '3', 'Riesig', 24, '6', NULL, NULL, 'Flügel: Die mächtigen Flügel des Drachen erlauben es ihm, sich frei durch die Luft zu bewegen.', NULL, NULL),
    (26, 'Dämon', 'Dämon', 0, 64, '2', 'Groß', 16, '4', NULL, NULL, 'Beispielwerte: Dämonen erscheinen in allen Formen und Größen, ihr Aussehen ist jedoch stets furchteinflößend. Die Werte hier sind nur ein Beispiel.', NULL, NULL),
    (27, 'Katze', 'Tier', 0, 4, '—', '—', 12, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 14, Heimlichkeit 16', NULL),
    (28, 'Hund', 'Tier', 0, 8, '—', '—', 14, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 14, Ausweichen 10, Heimlichkeit 12', NULL),
    (29, 'Ziege', 'Tier', 0, 6, '—', '—', 10, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 12', NULL),
    (30, 'Esel', 'Tier', 0, 12, '—', '—', 14, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 6', NULL),
    (31, 'Pferd', 'Tier', 0, 16, '—', '—', 20, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 8', NULL),
    (32, 'Wildschwein', 'Tier', 0, 14, '—', '—', 12, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 8', NULL),
    (33, 'Hirsch', 'Tier', 0, 12, '—', '—', 18, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 12', NULL),
    (34, 'Elch', 'Tier', 0, 18, '—', '—', 16, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 8', NULL),
    (35, 'Fuchs', 'Tier', 0, 6, '—', '—', 10, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 12, Ausweichen 10, Heimlichkeit 14', NULL),
    (36, 'Wolf', 'Tier', 0, 10, '—', '—', 16, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 14, Ausweichen 12, Heimlichkeit 14', NULL),
    (37, 'Bär', 'Tier', 0, 20, '—', '—', 12, '—', NULL, NULL, NULL, 'Fertigkeiten: Wahrnehmung 10, Ausweichen 8', NULL),
    (38, 'Zivilist', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Ein Kampf mit Zivilisten ist eine Schlägerei und endet meist nach 3 Runden.', 'Typische Waffe: Knüppel oder Messer (Fertigkeitswert 8, Schaden W6)', NULL),
    (39, 'Kämpfer', 'Alltagsvolk', 0, 15, '—', 'Normal', 10, 'Lederrüstung (1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Auch für Stadtwache, Leibwächter und Söldner: Für einen Wachtrupp nimm drei Kämpfer.
Trupp: Drei Kämpfer sind für drei Spielercharaktere leicht fordernd, für Nicht-Kämpfer spürbar (meist geht jemand zu Boden). Jeder weitere Kämpfer macht den Kampf deutlich härter.', 'Typische Waffe: Kurzschwert, Keule oder Kurzbogen (Fertigkeitswert 10, Schaden W8)', NULL),
    (40, 'Zauberkundiger', 'Alltagsvolk', 0, 11, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Im Trupp zählt ein Zauberkundiger ungefähr wie ein Kämpfer. Allein ist er harmlos.', 'Fertigkeiten: Zauberschule 12 · WP: 8
Zauber: Feuerball oder Blitzschlag (je 2 WP, 2W6 Schaden), danach Stab
Typische Waffe: Stab (Fertigkeitswert 8, Schaden W6)', NULL);

-- Typische NSC und die Figuren der Burg des Raubritters
INSERT INTO catalog_bestiary (id, name_de, category_de, is_unique, hp, grimmigkeit_de, size_de, movement, armor_de, resistances_de, immunities_de, traits_de, kit_de, image_path) VALUES
    (41, 'Wache', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, 'Beschlagenes Leder (2)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 10, Schwerter 12 · Schadensbonus STÄ +W4', 'Breitschwert, beschlagenes Leder', NULL),
    (42, 'Kultist', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Ausweichen 14, Messer 14 · Schadensbonus GEW +W4', 'Dolch', NULL),
    (43, 'Dieb', 'Alltagsvolk', 0, 10, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Ausweichen 12, Messer 12 · Schadensbonus GEW +W4', 'Messer', NULL),
    (44, 'Dorfbewohner', 'Alltagsvolk', 0, 8, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Prügelei 8', 'Holzknüppel', NULL),
    (45, 'Jäger', 'Alltagsvolk', 0, 13, '—', 'Normal', 10, 'Lederrüstung (1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 12, Bögen 13 · Schadensbonus GEW +W4', 'Langbogen, Lederrüstung', NULL),
    (46, 'Bandit', 'Alltagsvolk', 0, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Bögen 12, Ausweichen 10, Schwerter 12', 'Kurzschwert, Kurzbogen', NULL),
    (47, 'Abenteurer', 'Alltagsvolk', 0, 13, '—', 'Normal', 10, 'Beschlagenes Leder (2)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 10, Schwerter 12 · Schadensbonus STÄ +W4', 'Breitschwert, beschlagenes Leder', NULL),
    (48, 'Gelehrter', 'Alltagsvolk', 0, 7, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Fremdsprachen 13, Mythen & Legenden 13, Stäbe 8', 'Ein gutes Buch', NULL),
    (49, 'Banditenanführer', 'Alltagsvolk', 0, 30, '—', 'Normal', 10, 'Kettenpanzer, offener Helm', NULL, NULL, 'Boss: zieht eine eigene Initiativkarte und hat WP sowie Heldentalente.
Fertigkeiten: Wahrnehmung 12, Prügelei 15, Hämmer 15 · WP: 16 · Schadensbonus STÄ +W6
Heldentalente: Berserker, Robust ×6, Veteran', 'Schwerer Kriegshammer, Kettenpanzer, offener Helm', NULL),
    (50, 'Ritter-Champion', 'Alltagsvolk', 0, 28, '—', 'Normal', 10, 'Plattenpanzer, Großhelm', NULL, NULL, 'Boss: zieht eine eigene Initiativkarte und hat WP sowie Heldentalente.
Fertigkeiten: Prügelei 14, Schwerter 16 · WP: 26 · Schadensbonus STÄ +W6
Heldentalente: Defensiv, Doppelhieb, Fokussiert ×6, Robust ×6', 'Langschwert, großer Schild, Plattenpanzer, Großhelm, kampfgeschultes Pferd', NULL),
    (51, 'Erzmagier', 'Alltagsvolk', 0, 22, '—', 'Normal', 10, '—', NULL, NULL, 'Boss: zieht eine eigene Initiativkarte und hat WP sowie Heldentalente.
Fertigkeiten: Zauberschule 15, Stäbe 13 · WP: 30
Heldentalente: Fokussiert ×6, Meister-Zauberer, Robust ×4', 'Stab, Grimoire', NULL),
    (52, 'Jaldo', 'Humanoid', 1, 10, '—', 'Klein', 10, 'Beschlagenes Leder (2), offener Helm (+1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 12, Ausweichen 10, Heimlichkeit 12 · Schadensbonus —', 'Krummsäbel (Fertigkeitswert 12, Schaden 2W6)', NULL),
    (53, 'Grunta', 'Humanoid', 1, 12, '—', 'Normal', 10, '—', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 14, Ausweichen 10 · Schadensbonus STÄ +W4', 'Kleine Holzkeule (Fertigkeitswert 12, Schaden W8)', NULL),
    (54, 'Goblin – Burgplünderer', 'Humanoid', 0, 9, '—', 'Klein', 10, 'Lederrüstung (1)', NULL, NULL, 'Kein Monster: zählt im Kampf als gewöhnlicher NSC.
Fertigkeiten: Wahrnehmung 10, Ausweichen 10, Heimlichkeit 12 · Schadensbonus —', 'Kurzbogen (Fertigkeitswert 12, Schaden W10), Kurzschwert (Fertigkeitswert 10, Schaden W10)', NULL),
    (55, 'Der Raubritter', 'Untot', 1, 38, 'Zahl der SC − 1', 'Normal', 10, '8', 'Erleidet halben Schaden durch nicht-magische Waffen; Feuer verursacht jedoch normalen Schaden.', NULL, 'Ein Wiedergänger, der wie ein Monster behandelt wird. Er steht nach etwa einem Tagesabschnitt (rund sechs Stunden) wieder auf, wenn er im Kampf besiegt wird.', 'Morgenstern (Wuchtschaden 2W8)', NULL);

-- catalog_bestiary_attacks
INSERT INTO catalog_bestiary_attacks (id, bestiary_id, roll_de, title_de, effect_de) VALUES
    (1, 1, '1', 'Mandibeln!', 'Die zackigen Mundwerkzeuge der Spinne sausen durch die Luft wie Krummsäbel. Der Angriff verursacht 2W8 Hiebschaden.'),
    (2, 1, '2', 'Reißangriff!', 'Die hungrige Spinne wirft sich auf die Charaktere und greift verzweifelt mit ihren acht haarigen, mit Widerhaken versehenen Beinen an. Alle Charaktere innerhalb von 2 m erleiden jeweils W8 Stichschaden.'),
    (3, 1, '3', 'Hypnotisierende Augen!', 'Der monströse Arachnid starrt die Charaktere mit seinen zahlreichen Augen an. Allen Opfern innerhalb von 10 m muss eine WIL-Probe gelingen, um dem Furchtangriff (siehe Seite 18) zu widerstehen.'),
    (4, 1, '4', 'Giftstachel!', 'Der achtbeinige Schrecken erhebt sein Hinterteil und greift einen Charakter mit einem Giftstachel an. Der Angriff verursacht W10 Stichschaden; ein Gegner, der mindestens 1 Punkt Schaden erlitten hat, erhält zusätzlich ein Lähmungsgift der Wirkstärke 16 injiziert. Der Angriff kann pariert werden.'),
    (5, 1, '5', 'Netzangriff!', 'Die Spinne fixiert den Charakter mit der höchsten STÄ und schießt ein klebriges Spinnennetz auf ihn. Er muss eine Ausweichen-Probe ablegen (zählt nicht als Aktion). Bei Misserfolg ist das Opfer gefangen und kann sich nicht mehr bewegen; nur eine erfolgreiche STÄ-Probe mit Nachteil (zählt als Aktion) befreit es, andere Charaktere können dabei helfen.'),
    (6, 1, '6', 'Rammangriff!', 'Mit einem gewaltigen Sprung hämmert die Spinne ihren Körper gegen einen Charakter. Der Angriff verursacht 2W6 Wuchtschaden und schleudert das Opfer zu Boden.'),
    (7, 2, '1-2', 'Wirbelnder Schrecken!', 'Die Fledermäuse schwirren in aberwitziger Geschwindigkeit um ihre Opfer. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff (siehe Seite 18).'),
    (8, 2, '3-4', 'Kollektiver Angriff!', 'Die Fledermäuse werfen sich gemeinsam gegen den Charakter mit der höchsten KON. Der Angriff verursacht 2W6 Hiebschaden, und der Schwarm heilt sich um denselben Wert, da er das Blut seines Opfers trinkt.'),
    (9, 2, '5-6', 'Massenangriff!', 'Die Fledermäuse teilen sich auf und greifen alle Charaktere innerhalb von 10 m an. Jedes Opfer erleidet W8 Hiebschaden, und der Schwarm heilt sich durch das getrunkene Blut um denselben Wert.'),
    (10, 4, '1', 'Unheiliges Gebrüll!', 'Der zerfallene Schädel des Gruftschreckens verzieht sich zu einem grausigen Schrei. Alle innerhalb von 10 m werden mit einem Furchtangriff attackiert (siehe Seite 18).'),
    (11, 4, '2', 'Schauderhafter Blick!', 'Ein Charakter blickt direkt in die seelenlosen Augen der Kreatur. Das Opfer wird Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (12, 4, '3', 'Hand der Toten!', 'Der Gruftschrecken gestikuliert in Richtung eines Charakters innerhalb von 10 m. Dieser wird 2W4 m weit geschleudert, erleidet Schaden in gleicher Höhe und landet auf dem Rücken. Diesem Angriff kann nicht ausgewichen werden.'),
    (13, 4, '4', 'Rundumschlag!', 'Der Gruftschrecken schwingt seine Waffe mit übernatürlicher Geschwindigkeit. Alle Charaktere innerhalb von 2 m erleiden den Waffenschaden. Der Angriff kann pariert werden.'),
    (14, 4, '5', 'Lähmende Kälte!', 'Der Gruftschrecken ergreift ein Opfer, das die Kälte des Todes durch seinen Körper spürt. Das Opfer erhält W6 Schaden (Rüstung schützt nicht) und muss bei seinem nächsten Zug eine Ausweichen-Probe ablegen (zählt nicht als Aktion); bei Misslingen wiederholbar. Es ist nun kalt (siehe Seite 19) und kann keine TP/WP heilen, bis es sich wieder aufgewärmt hat.'),
    (15, 4, '6', 'Mächtiger Angriff!', 'Der Gruftschrecken schwingt seine mächtige Waffe gegen einen Charakter. Die reguläre Anzahl an Schadenswürfeln wird verdoppelt (4W8), und das Opfer wird zu Boden geschleudert. Der Angriff kann pariert werden.'),
    (16, 5, '1', 'Bedrohlicher Ausfall!', 'Der Monster-Aal schwimmt schnell um sein Opfer herum, fletscht seine scharfen Zähne und stößt bedrohlich nach vorne. Das Opfer muss eine WIL-Probe ablegen, um der Furcht zu widerstehen.'),
    (17, 5, '2', 'Rammen!', 'Die Bestie rammt einen Spielercharakter mit ihrem massiven Körper und verursacht W10 Wuchtschaden. Erleidet das Opfer Schaden, erhält es zusätzlich den Zustand Benommen.'),
    (18, 5, '3', 'Schwanzhieb!', 'Der Aal schlägt mit seinem langen Schwanz nach einem Spielercharakter innerhalb von 4 m. Der Angriff verursacht 2W6 Wuchtschaden und macht das Opfer Benommen.'),
    (19, 5, '4', 'Wütender Biss!', 'Der Monster-Aal bohrt seine Reißzähne in einen Spielercharakter und verursacht 2W8 Hiebschaden.'),
    (20, 5, '5', 'Rundumschlag!', 'Der Monster-Aal wirbelt herum und schlägt mit seinem schweren Körper nach allen innerhalb von 6 m. Der Angriff verursacht W8 Wuchtschaden.'),
    (21, 5, '6', 'Tödliche Umklammerung!', 'Die Bestie wickelt sich blitzschnell um einen Spielercharakter. Der Angriff verursacht 2W4 Wuchtschaden, sowie jedes Mal zusätzlich 2W4 Schaden, wenn das Opfer am Zug ist. Das Opfer kann sich nicht bewegen und keine Aktionen ausführen, die Bewegung erfordern, außer dem Versuch, sich zu befreien – dafür ist eine erfolgreiche STÄ-Probe nötig. Andere Spielercharaktere können dabei helfen.'),
    (22, 6, '1', 'Umstürzendes Bücherregal!', 'Mit einem lauten Krachen stürzt ein Bücherregal auf einen Spielercharakter. Der Angriff verursacht 2W8 Wuchtschaden und wirft den Charakter zu Boden. Das Opfer ist eingeklemmt und kann sich nicht bewegen oder Aktionen ausführen, die Bewegung erfordern – außer dem Versuch, sich zu befreien, wofür eine STÄ-Probe nötig ist. Andere Charaktere können helfen.'),
    (23, 6, '2', 'Hand der Toten!', 'Der Geist stößt seine durchscheinende Hand in die Brust eines unglücklichen Spielercharakters und quetscht dessen Herz. Der Charakter erleidet 2W10 Schaden und wird Verängstigt. Rüstung hat keinerlei Wirkung.'),
    (24, 6, '3', 'Wucht des Folianten!', 'Ein altes Buch schießt aus einem Regal und schlägt den lautesten Spielercharakter mit dem Einband. Der Angriff verursacht 2W6 Wuchtschaden und macht das Opfer Wütend. Rüstung hat keinen Effekt, Helme hingegen schon.'),
    (25, 6, '4', 'Blick der Toten!', 'Der Geist schwebt über einem Spielercharakter und starrt ihm mit toten Augen in die Seele. Das Opfer wird Verängstigt, erleidet einen Furchtangriff (siehe Seite 18) und muss die WIL-Probe mit Nachteil ablegen.'),
    (26, 6, '5', 'Zerschmetternder Wurf!', 'Der Geist hebt einen Spielercharakter mit unsichtbarer Kraft an und schleudert ihn direkt gegen die steinerne Decke. Der Angriff verursacht 2W10 Wuchtschaden. Dann lässt der Geist los, das Opfer erleidet beim Aufprall zusätzliche W8 Wuchtschaden und landet am Boden.'),
    (27, 6, '6', 'Büchersturm!', 'Ein Wirbelsturm aus schimmligen Büchern schießt aus den Bücherregalen und trifft jeden Spielercharakter im Raum immer und immer wieder. Alle erleiden 2W6 Wuchtschaden.'),
    (28, 7, '1', 'Schreckliches Brüllen!', 'Die Galionsfigur stößt ein Brüllen aus, das den ganzen Raum erschüttert. Alle Spielercharaktere erleiden einen Furchtangriff (siehe Seite 18).'),
    (29, 7, '2', 'Knarrender Biss!', 'Die hölzerne Bestie beißt einen Spielercharakter und verursacht 2W8 Hiebschaden.'),
    (30, 7, '3', 'Hartholz-Kopfstoß!', 'Mit einem unnatürlichen Knarren rammt die Bestie ihr Opfer mit dem Kopf und verursacht 2W6 Wuchtschaden. Rüstung hat keinen Effekt, Helme hingegen schon. Das Opfer wird zu Boden geworfen, wenn es Schaden erleidet.'),
    (31, 7, '4', 'Meereswasser-Kaskade!', 'Die Galionsfigur reißt ihre Kiefer weit auf und speit eine Kaskade aus dunklem Meerwasser auf alle Opfer in einem 10-Meter-Kegel. Die Opfer werden W8 m zurückgeschleudert, erleiden denselben Wert als Wuchtschaden und landen am Boden.'),
    (32, 7, '5', 'Eisiger Wind!', 'Die Bestie wirft ihren grässlichen Kopf zurück und lässt einen eisigen Wind durch den ganzen Raum wehen. Alle Spielercharaktere müssen eine Wildnisleben-Probe bestehen, um nicht auszukühlen (Seite 19).'),
    (33, 7, '6', 'Umwerfender Wurf!', 'Die Bestie packt den nächstgelegenen Spielercharakter und benutzt ihn wie eine Waffe, indem sie das Opfer mit aller Kraft auf einen anderen Charakter innerhalb von 6 m schleudert. Beide erleiden 2W6 Wuchtschaden und werden zu Boden geworfen.'),
    (34, 8, '1', 'Zischendes Brüllen!', 'Der Lindwurm lässt ein furchterregendes, zischendes Brüllen los. Alle innerhalb von 10 m erleiden einen Furchtangriff.'),
    (35, 8, '2', 'Klauenangriff!', 'Mit seinen Klauen trifft die Bestie zwei Gegner, die maximal 2 m voneinander entfernt stehen. Jedes Opfer erleidet 2W8 Hiebschaden.'),
    (36, 8, '3', 'Rückendornen!', 'Die Kreatur wälzt sich über alle Gegner innerhalb von 6 m hinweg. Die Opfer erleiden 2W4 Hiebschaden von den Dornen auf dem Rücken des Monsters und werden zu Boden geworfen.'),
    (37, 8, '4', 'Tödliche Umklammerung!', 'Die Bestie windet sich um einen Gegner und versucht, ihm das Leben aus dem Körper zu pressen. Der Angriff verursacht 2W8 Wuchtschaden, und in jeder Runde, in der das Opfer am Zug ist, noch einmal denselben Betrag. Das Opfer kann sich nicht bewegen oder Aktionen ausführen, die Bewegung erfordern – außer dem Versuch, sich zu befreien, was eine STÄ-Probe mit Nachteil erfordert. Andere Charaktere können dabei helfen.'),
    (38, 8, '5', 'Gieriger Biss!', 'Der Lindwurm reißt sein Maul auf und schnellt nach vorn, um einen großen Biss zu nehmen. Der Angriff verursacht 3W8 Hiebschaden, kann aber pariert werden.'),
    (39, 8, '6', 'Verschlingender Angriff!', 'Die Bestie verschluckt einen Gegner vollständig, was 2W6 Wuchtschaden verursacht. Das Opfer kann den Lindwurm von innen weiter angreifen, wo das Monster keinen Rüstungswert hat. Doch für jede Runde, die der Charakter im Bauch der Bestie verbringt, erleidet er W6 Schaden (wobei Rüstung keine Wirkung hat). Das Opfer kommt erst frei, wenn der Lindwurm tot ist.'),
    (40, 9, '1', 'Unheiliges Gebrüll!', 'Der zerfallene Schädel des Gruftschreckens verzieht sich zu einem grausigen Schrei, der wie eine rostige Klinge durch die Seelen der Charaktere schneidet. Alle innerhalb von 10 m erleiden einen Furchtangriff.'),
    (41, 9, '2', 'Schauderhafter Blick!', 'Ein unglücklicher Charakter starrt direkt in die schrecklichen Augen der Kreatur, und ein pfeifendes Geräusch dringt aus ihrer Kehle. Das Opfer wird Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (42, 9, '3', 'Hand der Toten!', 'Der Gruftschrecken hebt die Hand und gestikuliert in Richtung eines Charakters innerhalb von 10 m. Dieser wird 2W4 m weit weggeschleudert und landet auf dem Rücken. Der Angriff verursacht denselben Wert als Schaden, und ihm kann nicht ausgewichen werden.'),
    (43, 9, '4', 'Rundumschlag!', 'Mit überraschender Schnelligkeit schwingt der Gruftschrecken seine Waffe in einem tödlichen Angriff. Alle Charaktere innerhalb von 2 m erleiden Waffenschaden. Der Angriff kann pariert werden.'),
    (44, 9, '5', 'Lähmende Kälte!', 'Der Gruftschrecken packt einen unglücklichen Charakter, der die Kälte des Todes durch seinen Körper kriechen spürt. Das Opfer erleidet W6 Schaden (Rüstung schützt nicht) und muss in seinem nächsten Zug eine Ausweichen-Probe ablegen (zählt nicht als Aktion), um überhaupt handeln zu können. Misslingt sie, ist im folgenden Zug ein neuer Versuch möglich. Außerdem ist das Opfer nun kalt und kann keine TP oder WP heilen, bis es sich wieder aufgewärmt hat.'),
    (45, 9, '6', 'Mächtiger Angriff!', 'Mit knarrenden Gelenken schwingt der Gruftschrecken seine Waffe in einem kraftvollen Angriff gegen einen Charakter. Der Schaden wird mit der doppelten Anzahl der normalen Würfel der Waffe gewürfelt, und das Opfer wird zu Boden geworfen. Der Angriff kann pariert werden.'),
    (46, 10, '1', 'Geisterschlag!', 'Der Geist stürzt sich auf einen Charakter innerhalb von 10 m und trifft ihn mit großer Kraft. Das Opfer wird 2W6 m zurückgeschleudert, erleidet denselben Wert an Wuchtschaden und landet auf dem Rücken.'),
    (47, 10, '2', 'Berührung des Todes!', 'Der Geist stößt seine durchscheinende Hand in die Brust eines unglücklichen Charakters und umklammert dessen Herz. Das Opfer erleidet 2W10 Schaden und wird Verängstigt. Die Rüstung schützt nicht.'),
    (48, 10, '3', 'Geisterschrei!', 'Das Gesicht des Untoten verzerrt sich zu einer grässlichen Fratze, und er stößt einen Schrei aus, der die Seelen aller innerhalb von 10 m erstarren lässt. Alle erleiden einen Furchtangriff.'),
    (49, 10, '4', 'Todesblick!', 'Der Geist ragt über einem Charakter auf und starrt ihm direkt in die Seele. Das Opfer sieht sein Leben vor seinem inneren Auge vorbeiziehen und wird von grotesken Visionen all seiner toten Freunde und Feinde gequält. Es wird Verängstigt, erleidet einen Furchtangriff und erhält einen Nachteil auf seine WIL-Probe.'),
    (50, 10, '5', 'Geisterhafte Umarmung!', 'Mit einem unheimlichen Keuchen erscheint der Geist plötzlich direkt vor einem Abenteurer innerhalb von 10 m und schlingt sich in einer tödlichen Umarmung um ihn, um den Funken seines Lebens zu ersticken. Der Angriff verursacht 3W6 Wuchtschaden und lässt das Opfer Benommen zurück.'),
    (51, 10, '6', 'Kälteangriff!', 'Der Geist packt einen Charakter und lässt die eisige Kälte des Todes durch dessen Körper strömen. Das Opfer erleidet 2W8 Schaden und kann keine TP oder WP heilen, bevor es einen Tagesabschnitt an einem warmen Ort verbracht hat. Die Rüstung schützt nicht.'),
    (52, 14, '1', 'Trollgekotze!', 'Der Troll räuspert sich mit donnerndem Grollen, hustet tief aus der Lunge und erbricht eine Kaskade aus Galle und stinkendem Sumpfwasser. Alle Abenteurer innerhalb von 6 m erleiden einen Zustand ihrer Wahl.'),
    (53, 14, '2', 'Zerfleischender Angriff!', 'Der Troll zerreißt den Körper eines Charakters mit seinen schmutzigen, grünschwarzen Klauen. Der Angriff verursacht W10 Hiebschaden und kann pariert werden. Ein Opfer, das Schaden erleidet, infiziert sich mit einer Krankheit der Virulenz 10.'),
    (54, 14, '3', 'Widerlicher Biss!', 'Der Troll öffnet sein übelriechendes Maul und beißt einen Charakter mit einem Gebiss aus Reißzähnen, Kies und alten Knochensplittern. Der Angriff verursacht 2W8 Stichschaden. Der Charakter steckt im Maul des Trolls fest und muss in jeder Runde eine STÄ-Probe ablegen (zählt als Aktion), um sich zu befreien. Bei Misserfolg erleidet das Opfer zusätzlich 2W8 Schaden.'),
    (55, 14, '4', 'Trollwurf!', 'Der Troll hebt einen Charakter über den Kopf und wirft ihn wie eine Stoffpuppe 2W6 m weit in eine zufällige Richtung. Das Opfer erleidet ebenso viel Wuchtschaden und landet auf dem Rücken.'),
    (56, 14, '5', 'Fegender Schlag!', 'Der Troll fegt mit seinen langen, knorrigen Armen umher und trifft alle Charaktere innerhalb von 2 m. Der Angriff verursacht bei jedem Opfer 2W6 Wuchtschaden.'),
    (57, 14, '6', 'Zermalmender Schlag!', 'Der Troll packt den nächststehenden Charakter und benutzt ihn als Waffe, indem er ihn gegen einen anderen Charakter schmettert. Beide erleiden 2W8 Wuchtschaden und werden zu Boden geworfen.'),
    (58, 15, '1', 'Bullenfaust!', 'Eine pelzige Faust trifft einen Charakter mit voller Wucht. Der Angriff verursacht 2W6 Wuchtschaden und lässt das Opfer Benommen zurück, selbst wenn die Rüstung den Schaden verhindert.'),
    (59, 15, '2', 'Hufttritt!', 'Mit seinen kräftigen Beinen tritt der Minotaurus das Opfer mit den Hufen. Die Wucht schleudert es 2W6 m weit weg und verursacht denselben Wert an Wuchtschaden. Das Opfer landet auf dem Rücken.'),
    (60, 15, '3', 'Hornansturm!', 'Der Minotaurus senkt den Kopf und stürmt auf zwei Abenteurer zu, die höchstens 2 m voneinander entfernt stehen, um sie mit seinen spitzen Hörnern aufzuspießen. Beide erleiden 2W8 Stichschaden und werden zu Boden geworfen.'),
    (61, 15, '4', 'Spaltender Hieb!', 'Das Biest schwingt seine Waffe über den Kopf und lässt sie mit voller Kraft niedersausen. Der Angriff verursacht Waffenschaden plus zusätzlich W10 und kann pariert werden.'),
    (62, 15, '5', 'Fegender Angriff!', 'Der Minotaurus brüllt und schwingt seine Waffe in einem weiten Bogen, sodass alle innerhalb von 2 m getroffen werden. Der Angriff verursacht Waffenschaden.'),
    (63, 15, '6', 'Stampfangriff!', 'Der Minotaurus springt hoch in die Luft und kracht auf einen Abenteurer herab, der 2W10 Wuchtschaden erleidet und zu Boden geworfen wird.'),
    (64, 19, '1', 'Bedrohliches Gekreische!', 'Die Harpyien überschütten die Abenteurer mit schrecklichen Beschreibungen dessen, was sie mit ihnen vorhaben. Alle innerhalb von 10 m müssen eine WIL-Probe bestehen, um der Furcht zu widerstehen.'),
    (65, 19, '2', 'Koordinierter Angriff!', 'Die Harpyien scharen sich zusammen und greifen den Charakter an, der das meiste Metall trägt. Der Angriff verursacht 2W6 Hiebschaden. Bei einem Treffer wird das Opfer außerdem in die Luft gehoben und aus W3+3 m Höhe fallen gelassen.'),
    (66, 19, '3', 'Tod von oben!', 'Die Harpyien werfen Steine und anderen Unrat aus der Ferne. Alle innerhalb von 10 m erleiden W6 Wuchtschaden.'),
    (67, 19, '4', 'Augenkratzen!', 'Die Kreaturen haben es auf die Augen eines unglücklichen Charakters abgesehen und wollen sie mit ihren scharfen Klauen ausstechen. Der Angriff verursacht 2W6 Stichschaden, und das Opfer ist geblendet und handelt, als wäre es in völliger Dunkelheit, bis zum Ende des Viertels.'),
    (68, 19, '5', 'Massenangriff!', 'Die Harpyien teilen sich auf und greifen so viele Charaktere innerhalb von 10 m an, wie einzelne Harpyien vorhanden sind. Jeder Angriff verursacht W8 Hiebschaden.'),
    (69, 19, '6', 'Exkrementangriff!', 'Die Harpyien öffnen ihre Kloaken und Mäuler und lassen einen Regen aus Erbrochenem und Exkrementen auf die Charaktere niedergehen. Alle innerhalb von 10 m erleiden einen Zustand ihrer Wahl. Der Angriff kann mit einem Schild pariert werden.'),
    (70, 20, '1', 'Schwanzstoß!', 'Der Mantikor zielt mit den Stacheln seines Schwanzes auf einen Charakter innerhalb von 20 m. Der Angriff verursacht 2W12 Stichschaden, und das Opfer wird mit einem Lähmungsgift der Wirkstärke 12 infiziert. Der Angriff kann mit einem Schild pariert werden.'),
    (71, 20, '2', 'Messerscharfer Biss!', 'Der Mantikor beißt einen Charakter mit seinen zahlreichen Fangzähnen und verursacht 3W8 Hiebschaden.'),
    (72, 20, '3', 'Klauenangriff!', 'Die Bestie rennt auf einen Charakter zu, wirft ihn um und zerfetzt ihn mit ihren scharfen Klauen. Der Angriff verursacht 2W8 Hiebschaden, plus W6, da das Opfer am Boden liegt.'),
    (73, 20, '4', 'Fegender Angriff!', 'Der Mantikor peitscht mit dem Schwanz nach zwei Charakteren. Beide Opfer erleiden 2W6 Hiebschaden und werden zu Boden geworfen.'),
    (74, 20, '5', 'Vernichtender Ansturm!', 'Mit voller Kraft stürmt die Bestie auf den Charakter mit der höchsten STÄ innerhalb von 10 m zu. Der Angriff verursacht 3W6 Wuchtschaden, und das Opfer wird zu Boden geworfen.'),
    (75, 20, '6', 'Stachelregen!', 'Der Mantikor schleudert mit seinem Schwanz einen Regen tödlicher Stacheln. Alle Abenteurer innerhalb von 10 m erleiden W10 Stichschaden und werden mit einem Lähmungsgift der Wirkstärke 12 infiziert.'),
    (76, 23, '1', 'Schnappender Schnabel!', 'Die Bestie reißt mit ihrem rasiermesserscharfen Schnabel an einem Charakter und verursacht 2W8 Stichschaden.'),
    (77, 23, '2', 'Aufbäumender Schlag!', 'Der Greif bäumt sich vor einem Charakter auf und versucht, ihn mit W6 schnellen Hieben in Stücke zu reißen. Jeder Hieb verursacht W8 Hiebschaden. Dem Angriff kann ausgewichen werden, oder er kann pariert werden, jedoch nur jeweils ein Hieb.'),
    (78, 23, '3', 'Fegende Klauen!', 'Der Greif fegt mit seinen Vorderklauen in einem weiten Bogen und greift alle Charaktere innerhalb von 2 m an. Jedes Opfer erleidet W8 Hiebschaden und wird zu Boden geworfen.'),
    (79, 23, '4', 'Greifenwurf!', 'Die Bestie packt einen Charakter mit dem Schnabel und schleudert ihn mit einem Ruck des Kopfes weg. Der Angriff verursacht 2W6 Stichschaden. Das Opfer wird ebenso viele Meter weit geschleudert und landet auf dem Rücken.'),
    (80, 23, '5', 'Wirbelwind!', 'Der Greif erzeugt mit seinen kräftigen Flügeln einen Wirbelwind, der alle Charaktere innerhalb von 10 m wegbläst. Die Opfer landen W6 m entfernt und erleiden denselben Wert an Wuchtschaden.'),
    (81, 23, '6', 'Tiefer Fall!', 'Der Greif packt einen Charakter mit seinen Klauen und trägt ihn in den Himmel. Sofern das Opfer dem Angriff nicht ausweicht, ergreift der Greif es und fliegt 2W6+6 m hoch in die Luft. In seinem nächsten Zug lässt der Greif das Opfer fallen (statt eines neuen Monsterangriffs), und es erleidet Sturzschaden.'),
    (82, 24, '1', 'Vernichtender Schlag!', 'Der Riese schwingt seine Waffe über den Kopf und drischt mit aller Kraft auf einen Charakter ein. Der Angriff verursacht 4W10 Wuchtschaden, und das Opfer wird zu Boden geworfen.'),
    (83, 24, '2', 'Gebrüll!', 'Der Riese stößt ein dröhnendes Brüllen aus, das den Abenteurern die Haare zu Berge stehen lässt. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff.'),
    (84, 24, '3', 'Stampfangriff!', 'Der Riese nimmt zwei Charaktere ins Visier, die höchstens 4 m voneinander entfernt stehen, und versucht, sie zu zertrampeln. Jeder Getroffene erleidet 4W6 Wuchtschaden und wird zu Boden geworfen.'),
    (85, 24, '4', 'Fegender Schlag!', 'Der Riese schwingt seine Waffe gegen alle Abenteurer innerhalb von 10 m. Jeder Getroffene erleidet 2W10 Wuchtschaden.'),
    (86, 24, '5', 'Kraftvoller Wurf!', 'Der Riese hat genug von einem Charakter, packt ihn und versucht, ihn zu werfen. Der Angriff verursacht 4W8 Wuchtschaden, und das Opfer wird ebenso viele Meter in eine zufällige Richtung geschleudert und landet auf dem Rücken.'),
    (87, 24, '6', 'Zerschmetternder Angriff!', 'Vor Wut außer sich zerschmettert der Riese den Charakter mit seinen Füßen, Fäusten und seiner Waffe in einem Rausch schneller Schläge. Alle innerhalb von 2 m erleiden 3W6 Wuchtschaden und werden zu Boden geworfen.'),
    (88, 25, '1', 'Drachengebrüll!', 'Der Drache öffnet sein Maul und stößt ein eisiges Brüllen aus. Alle Charaktere innerhalb von 20 m erleiden einen Furchtangriff, mit einem Nachteil auf die WIL-Probe.'),
    (89, 25, '2', 'Klauenangriff!', 'Der Drache fegt mit seinen Klauen nach zwei Charakteren, die jeweils 2W10 Hiebschaden erleiden.'),
    (90, 25, '3', 'Drachenwind!', 'Der Drache schlägt mit seinen großen Flügeln und erzeugt eine gewaltige Windböe, die alle Abenteurer innerhalb von 10 m trifft. Lose Gegenstände und Kreaturen bis zu menschlicher Größe im Wirbelwind werden 2W6 m weit geschleudert, erleiden denselben Wert an Wuchtschaden und landen auf dem Rücken.'),
    (91, 25, '4', 'Schwanzschlag!', 'Der Drache fegt mit seinem stacheligen Schwanz über seine Opfer. Alle Charaktere innerhalb von 6 m erleiden 2W8 Wuchtschaden und werden zu Boden geworfen.'),
    (92, 25, '5', 'Drachenbiss!', 'Das Biest öffnet seinen gewaltigen Kiefer und verschlingt ein Opfer mit erschreckender Geschwindigkeit. Der Angriff verursacht 4W10 Hiebschaden.'),
    (93, 25, '6', 'Feueratem!', 'Der Drache ragt in seiner ganzen Pracht über den Charakteren auf und entfesselt einen verheerenden Feuersturm aus seinem Maul. Das Feuer bildet einen Kegel von 10 m Länge, dessen Breite an jeder Stelle der Entfernung zum Maul des Drachen entspricht. Jeder Charakter, der von den Flammen getroffen wird, erleidet 3W10 Schaden. Die Rüstung schützt nicht.'),
    (94, 26, '1', 'Dämonische Furcht!', 'Der Dämon zischt schreckliche Drohungen in einer uralten, furchtbaren Sprache. Alle Charaktere innerhalb von 10 m erleiden einen Furchtangriff.'),
    (95, 26, '2', 'Klauenangriff!', 'Der Dämon lächelt und schlitzt einen Charakter mit seinen scharfen Klauen auf. Der Angriff verursacht 2W10 Hiebschaden und kann pariert werden.'),
    (96, 26, '3', 'Fluch!', 'Der Dämon zeigt auf einen unglücklichen Charakter innerhalb von 10 m und singt einen uralten Fluch. Dem Angriff kann nicht ausgewichen werden, und alle Flüche außer Nr. 6 können mit dem Zauber Magie bannen (Kraftstufe 1) aufgehoben werden. Würfle W6:
1: Das Opfer erbricht einen Frosch, sobald es lügt. Würfle jeden Morgen W4. Bei einer 1 endet die Wirkung.
2: Alles Gold oder Silber, das das Opfer berührt, zerfällt zu Staub. Würfle jeden Morgen W4. Bei einer 1 endet die Wirkung.
3: Das Opfer ist geblendet und handelt, als wäre es in völliger Dunkelheit. Würfle jeden Tagesabschnitt W4. Bei einer 1 endet die Wirkung.
4: Das Opfer wird von Amnesie geschlagen und vergisst seinen eigenen Namen und wer die anderen Spielercharaktere sind. Die Wirkung muss ausgespielt werden. Würfle jeden Morgen W4. Bei einer 1 kehrt die Erinnerung zurück.
5: Das Opfer verwandelt sich in ein Tier. Würfle W6: 1: Katze, 2: Fuchs, 3: Ziege, 4: Wolf, 5: Hirsch, 6: Bär. Das Opfer erhält die Werte des Tieres (siehe Gemeine Tiere) und kann nicht sprechen. Würfle jeden Tagesabschnitt W4. Bei einer 1 endet die Wirkung.
6: Das Opfer wird eine Alterskategorie älter, zum Beispiel von Erwachsen zu Alt. Seine Attribute und abgeleiteten Werte ändern sich gemäß der Tabelle im Regelwerk, die Fertigkeitswerte jedoch nicht. Der Effekt ist dauerhaft. Wer bereits alt ist, wird gebrechlich und erhält −2 auf STÄ und KON.'),
    (97, 26, '4', 'Ungezügelte Wildheit!', 'Der Dämon streckt die Hand nach einem Opfer innerhalb von 10 m aus. Das Opfer wird mit ungeheurer Wucht 2W8 m rückwärts geschleudert, erleidet denselben Wert an Wuchtschaden und landet auf dem Rücken.'),
    (98, 26, '5', 'Skorpionstich!', 'Das Biest hebt seinen skorpionartigen Schwanz und versetzt seinem Opfer einen schnellen Stich. Der Angriff verursacht W12 Stichschaden, und ein Opfer, das mindestens 1 Punkt Schaden erleidet, wird zusätzlich mit einem Lähmungsgift der Wirkstärke 16 infiziert. Der Angriff kann pariert werden.'),
    (99, 26, '6', 'Besessen!', 'Der Dämon starrt einen Charakter innerhalb von 10 m an und übernimmt die volle Kontrolle über dessen Körper. Das Opfer muss eine WIL-Probe mit Nachteil ablegen (zählt nicht als Aktion). Misslingt sie, muss es sofort eine Bewegung und eine Aktion nach Wahl des Dämons ausführen, außer Aktionen, die WP kosten. Außerdem verliert das Opfer seinen nächsten Zug.'),
    (100, 27, '—', 'Biss', 'Fertigkeitswert 8, Schaden W3'),
    (101, 28, '—', 'Biss', 'Fertigkeitswert 12, Schaden W8'),
    (102, 29, '—', 'Hörner', 'Fertigkeitswert 10, Schaden W6'),
    (103, 30, '—', 'Tritt', 'Fertigkeitswert 10, Schaden W10'),
    (104, 31, '—', 'Tritt', 'Fertigkeitswert 10, Schaden 2W4'),
    (105, 32, '—', 'Hauer', 'Fertigkeitswert 12, Schaden 2W6'),
    (106, 33, '—', 'Hörner', 'Fertigkeitswert 10, Schaden W8'),
    (107, 34, '—', 'Hörner', 'Fertigkeitswert 10, Schaden 2W6'),
    (108, 35, '—', 'Biss', 'Fertigkeitswert 12, Schaden W6'),
    (109, 36, '—', 'Biss', 'Fertigkeitswert 14, Schaden 2W6'),
    (110, 37, '—', 'Biss', 'Fertigkeitswert 12, Schaden 2W8');

-- Angriffstabelle des Raubritters
INSERT INTO catalog_bestiary_attacks (id, bestiary_id, roll_de, title_de, effect_de) VALUES
    (111, 55, '1', 'Unheiliges Gebrüll!', 'Ein grauenhafter Schrei dringt aus dem kopflosen Hals des Wiedergängers und schneidet wie eine rostige Klinge durch die Seelen der Charaktere. Alle innerhalb von 10 Metern erleiden einen Furchtangriff.'),
    (112, 55, '2', 'Grauenvolle Drohungen!', 'Der Wiedergänger wendet sich einem unglücklichen Charakter innerhalb von 10 Metern zu und flüstert grässliche Drohungen aus seiner Kehle. Das Opfer wird Verängstigt, erleidet einen Furchtangriff und hat einen Nachteil auf seine WIL-Probe.'),
    (113, 55, '3', 'Hand der Toten!', 'Der Wiedergänger hebt die Hand und deutet auf einen Charakter innerhalb von 10 Metern. Dieser wird 2W4 Meter weit geschleudert und landet am Boden. Der Angriff verursacht Wuchtschaden in Höhe der Zahl der geschleuderten Meter und kann nicht ausgewichen werden.'),
    (114, 55, '4', 'Fegender Angriff!', 'Mit überraschender Geschwindigkeit führt der Wiedergänger seinen Morgenstern in einem tödlichen Hieb. Alle Charaktere innerhalb von 2 Metern erleiden 2W8 Wuchtschaden. Der Angriff kann pariert werden.'),
    (115, 55, '5', 'Lähmende Kälte!', 'Der Wiedergänger packt einen unglücklichen Charakter, der die Kälte des Todes durch seinen Körper strömen spürt. Das Opfer erleidet W6 Schaden (Rüstung hat keine Wirkung) und muss in seinem nächsten Zug eine Ausweichen-Probe ablegen (keine Aktion), um überhaupt handeln zu können. Misslingt sie, darf im nächsten Zug ein neuer Versuch unternommen werden. Das Opfer ist außerdem unterkühlt und kann bis zum Aufwärmen weder TP noch WP heilen.'),
    (116, 55, '6', 'Mächtiger Angriff!', 'Mit knarrenden Gelenken schwingt der Wiedergänger den Morgenstern in einem kraftvollen Angriff gegen einen Charakter. Das Opfer erleidet 4W8 Wuchtschaden und wird zu Boden geworfen. Der Angriff kann pariert werden.');

-- catalog_encounter_tables
INSERT INTO catalog_encounter_tables (id, name_de) VALUES
    (1, 'Wald'),
    (2, 'Straße'),
    (3, 'Ruine');

-- catalog_encounter_table_entries
INSERT INTO catalog_encounter_table_entries (id, table_id, min_roll, max_roll, bestiary_id, quantity_de, text_de) VALUES
    (1, 1, 1, 2, NULL, NULL, 'Nichts begegnet der Gruppe.'),
    (2, 1, 3, 3, 36, 'W3', NULL),
    (3, 1, 4, 4, 32, '1', NULL),
    (4, 1, 5, 5, 37, '1', NULL),
    (5, 1, 6, NULL, 21, 'W3', NULL),
    (6, 2, 1, 2, NULL, NULL, 'Nichts begegnet der Gruppe.'),
    (7, 2, 3, 3, 38, 'W3', 'Reisende oder Händler.'),
    (8, 2, 4, 4, 39, '3', 'Ein Wachtrupp.'),
    (9, 2, 5, 5, 22, 'W3', 'Wegelagerer.'),
    (10, 2, 6, NULL, 16, 'W3', 'Ein Trupp auf Beutezug.'),
    (11, 3, 1, 1, NULL, NULL, 'Nichts regt sich.'),
    (12, 3, 2, 2, 11, 'W3', NULL),
    (13, 3, 3, 3, 12, 'W3', NULL),
    (14, 3, 4, 4, 10, '1', NULL),
    (15, 3, 5, 5, 21, 'W6', 'Plünderer.'),
    (16, 3, 6, NULL, 9, '1', NULL);

-- Zufällige Ereignisse der Burg des Raubritters (W6, pro Viertel in der Burg)
INSERT INTO catalog_encounter_tables (id, name_de) VALUES
    (4, 'Zufällige Ereignisse: Burg des Raubritters');

INSERT INTO catalog_encounter_table_entries (id, table_id, min_roll, max_roll, bestiary_id, quantity_de, text_de) VALUES
    (17, 4, 1, 1, 54, '2', 'Goblins. Zwei Goblins tauchen auf, ziehen nach kurzer Verwirrung ihre Kurzschwerter und greifen mit einem Kreischen an.'),
    (18, 4, 2, 2, NULL, NULL, 'Wühlendes Schwein. Merle grunzt zufrieden in einer Ecke. Bemerkt sie die Charaktere, erstarrt sie, quiekt und flüchtet. Wer sie verletzt, macht sich die Orkin Grunta zur Feindin.'),
    (19, 4, 3, 3, NULL, NULL, 'Böse Geister. Die Luft vibriert, ein kalter Wirbelwind kreist, die Umrisse dreier toter Krieger greifen nach den Charakteren. Alle: WIL-Probe gegen Furcht, dann verschwinden die Geister.'),
    (20, 4, 4, 4, NULL, NULL, 'Sturm. Dunkle Wolken ziehen auf, es regnet in Strömen und donnert. Für den Rest des Abenteuers erhalten alle Fernkampfangriffe im Freien einen Nachteil.'),
    (21, 4, 5, 5, NULL, NULL, 'Raben. Ein Schwarm bricht aus einer Spalte hervor und stürzt auf die Charaktere zu. Alle: Ausweichen-Probe; wer scheitert, erleidet W3 Stichschaden. Dann fliegt der Schwarm zum Turm.'),
    (22, 4, 6, 6, NULL, NULL, 'Falle! Die Goblins haben einen aufgehängten Kriegshammer aufgestellt, der auslöst, wenn der Charakter mit der niedrigsten GEW auf einen losen Stein tritt. Ausweichen-Probe, sonst 2W6 Wuchtschaden.');
