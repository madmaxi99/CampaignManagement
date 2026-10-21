-- Katalog: Regelwerk-Referenzdaten. Setzt 0001_schema.sql voraus.

SET NAMES utf8mb4;

-- Katalog: Regelwerk-Referenzdaten (alle catalog_*-Tabellen), Endstand.
-- Pro Tabelle genau ein INSERT, in Abhängigkeitsreihenfolge. Die Ids sind fest
-- vergeben, weil Verweise (und Portrait-Dateien unter images/creatures/<id>.jpg)
-- an ihnen hängen; Lücken in den Ids sind Absicht (z. B. catalog_bestiary 3).

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
    (3, 'Fackel', 'Beleuchtet einen Radius von 10 Metern. Brennt bis zu einem Tagesabschnitt lang, aber würfle nach jedem Viertel einen W6 oder wenn die Fackel als Waffe benutzt wird. Bei einer 1 geht die Fackel aus.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (4, 'Wein', 'Eine Flasche einfacher Rotwein.', 'gewöhnlich', 0, 3, 0, 'misc'),
    (5, 'Buch', 'Vorteil auf Fertigkeitsproben zu einem bestimmten Thema. Der Preis hängt vom Thema ab.', 'ungewöhnlich', 25, 0, 0, 'misc'),
    (6, 'Amulett der Klarheit', 'Ein altes Amulett, das Gedanken zu ordnen scheint. Angeblich selten und begehrt.', 'selten', 5, 0, 0, 'misc'),
    (7, 'Lederrüstung', 'Einfache, flexible Rüstung aus gegerbtem Leder.', 'gewöhnlich', 2, 0, 0, 'armor'),
    (8, 'Kurzbogen', 'Ein kompakter Bogen, leichter zu handhaben als ein Langbogen.', 'gewöhnlich', 25, 0, 0, 'weapon'),
    (9, 'Langschwert', 'Ein robustes, vielseitiges Schwert.', 'ungewöhnlich', 25, 0, 0, 'weapon'),
    (10, 'Schleuder', 'Eine einfache Schleuder für Wurfgeschosse.', 'gewöhnlich', 0, 1, 0, 'weapon'),
    (11, 'Breitschwert', 'Ein breites, kräftiges Schwert.', 'gewöhnlich', 12, 0, 0, 'weapon'),
    (12, 'Dreschflegel', 'Ein Kriegsflegel, ursprünglich ein Dreschwerkzeug.', 'ungewöhnlich', 16, 0, 0, 'weapon'),
    (13, 'Lanze', 'Eine lange Reiterlanze für den berittenen Kampf.', 'selten', 12, 0, 0, 'weapon'),
    (14, 'Leichte Armbrust', 'Eine kompakte Armbrust, schneller nachzuladen als schwere Modelle.', 'ungewöhnlich', 75, 0, 0, 'weapon'),
    (15, 'Dreizack', 'Eine dreizackige Stichwaffe, beliebt bei Seefahrern.', 'ungewöhnlich', 5, 0, 0, 'weapon'),
    (16, 'Offener Helm', 'Nachteil auf Wahrnehmung-Proben.', 'ungewöhnlich', 12, 0, 0, 'armor'),
    (17, 'Großhelm', 'Nachteil auf Wahrnehmung-Proben und auf alle Fernkampfangriffe.', 'selten', 100, 0, 0, 'armor'),
    (18, 'Kampfpferd', 'Kann einen Reiter und 10 Gewichtseinheiten tragen, oder zwei Reiter.', 'selten', 400, 0, 0, 'misc'),
    (19, 'Esel', 'Kann 10 Gewichtseinheiten tragen. Kann nicht geritten werden.', 'gewöhnlich', 12, 0, 0, 'misc'),
    (20, 'Karren', 'Wird von einem Pferd oder Esel gezogen. Kann zwei Personen und 50 Gewichtseinheiten tragen.', 'gewöhnlich', 15, 0, 0, 'misc'),
    (21, 'Kriegshammer, klein', 'Ein kompakter Kriegshammer.', 'ungewöhnlich', 10, 0, 0, 'weapon'),
    (22, 'Schmiedewerkzeug', 'Wird für Handwerk-Proben verwendet.', 'ungewöhnlich', 20, 0, 0, 'misc'),
    (23, 'Zimmermannswerkzeug', 'Wird für Handwerk-Proben verwendet.', 'ungewöhnlich', 8, 0, 0, 'misc'),
    (24, 'Gerberwerkzeug', 'Wird für Handwerk-Proben verwendet.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (25, 'Notizbuch', 'Leer, kann als Grimoire verwendet werden.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (26, 'Feder & Tinte', 'Kann zum Aufschreiben von Zaubern verwendet werden.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (27, 'Bandagen', 'Eine Packung enthält 10 Bandagen. Nötig, um einen Nachteil auf Heilkunde-Proben zum Lebenretten zu vermeiden. Jeder Versuch verbraucht eine Bandage.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (28, 'Orbuculum', 'Kann als Fokus für Zauber verwendet werden.', 'ungewöhnlich', 18, 0, 0, 'misc'),
    (29, 'Zauberstab', 'Ein schlanker Stab, der als magischer Fokus dient.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (30, 'Amulett', 'Ein einfaches Amulett, das als magischer Fokus dient.', 'ungewöhnlich', 3, 0, 0, 'misc'),
    (31, 'Grimoire', 'Ein Zauberbuch, in dem ein Magier seine bekannten Zauber festhält. Neu erschaffene Magier erhalten automatisch eines. Der Preis hängt vom Inhalt ab und kann deutlich höher sein.', 'einzigartig', 50, 0, 0, 'misc'),
    (32, 'Leier', 'Ein kleines Saiteninstrument. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1.', 'ungewöhnlich', 20, 0, 0, 'misc'),
    (33, 'Flöte', 'Eine einfache Holzflöte. Senkt die WP-Kosten der Musiker-Fähigkeit auf 2.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (34, 'Horn', 'Ein Blashorn für Signale und Musik. Erhöht die Reichweite der Musiker-Fähigkeit auf 100 Meter.', 'gewöhnlich', 6, 0, 0, 'misc'),
    (35, 'Parierdolch', 'Ein schmaler Dolch, eigens zum Parieren geformt.', 'ungewöhnlich', 2, 0, 0, 'weapon'),
    (36, 'Morgenstern', 'Ein Streitkolben mit metallenem, dornenbesetztem Kopf.', 'ungewöhnlich', 14, 0, 0, 'weapon'),
    (37, 'Kriegshammer, schwer', 'Ein wuchtiger, beidhändig geführter Kriegshammer.', 'ungewöhnlich', 20, 0, 0, 'weapon'),
    (38, 'Hellebarde', 'Eine lange Stangenwaffe mit Axtklinge und Spitze.', 'selten', 20, 0, 0, 'weapon'),
    (39, 'Schild, groß', 'Ein großer, schwerer Schild.', 'gewöhnlich', 12, 0, 0, 'weapon'),
    (40, 'Streitkolben', 'Ein einfacher, wuchtiger Streitkolben.', 'gewöhnlich', 8, 0, 0, 'weapon'),
    (41, 'Schwere Armbrust', 'Eine mächtige Armbrust mit großer Durchschlagskraft, aber langsam nachzuladen.', 'selten', 200, 0, 0, 'weapon'),
    (42, 'Handarmbrust', 'Eine kompakte, einhändig zu bedienende Armbrust.', 'selten', 90, 0, 0, 'weapon'),
    (43, 'Stiefel', 'Schützen vor manchen Reise-Missgeschicken.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (44, 'Umhang', 'Schützt vor manchen Reise-Missgeschicken.', 'ungewöhnlich', 0, 8, 0, 'misc'),
    (45, 'Feine Gewänder', 'Vorteil auf CHA-basierte Fertigkeiten, wenn die Spielleitung es für angemessen hält.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (46, 'Pelzumhang', 'Vorteil auf Wildnisleben-Proben, um Kälte zu widerstehen.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    (47, 'Lumpen', 'Nachteil auf CHA-basierte Fertigkeiten, wenn die Spielleitung es für angemessen hält.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (48, 'Einfache Kleidung', 'Nötig, um einen Nachteil auf CHA-basierte Fertigkeiten zu vermeiden.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (49, 'Dudelsack', 'Ein Sackpfeifeninstrument mit durchdringendem Klang. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1 und erhöht die Reichweite auf 50 Meter.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    (50, 'Trommel', 'Eine einfache Handtrommel. Erhöht die Reichweite der Musiker-Fähigkeit auf 20 Meter.', 'gewöhnlich', 4, 0, 0, 'misc'),
    (51, 'Harfe', 'Ein aufwendig gebautes Saiteninstrument. Senkt die WP-Kosten der Musiker-Fähigkeit auf 1.', 'ungewöhnlich', 8, 0, 0, 'misc'),
    (52, 'Abakus', 'Vorteil auf INT-Proben beim Lösen mathematischer Probleme.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (53, 'Wolldecke', 'Nötig, um einen Nachteil auf Proben zu vermeiden, mit denen man den Auswirkungen von Kälte entgeht.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (54, 'Schachspiel', 'Eine Vergleichsprobe auf INT entscheidet, wer gewinnt.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (55, 'Würfel', 'Der Zufall entscheidet, wer gewinnt.', 'gewöhnlich', 0, 1, 0, 'misc'),
    (56, 'Feldküche', 'Vorteil auf Wildnisleben-Proben beim Kochen.', 'gewöhnlich', 4, 0, 0, 'misc'),
    (57, 'Tagesration', 'Pro Tag muss eine Ration verzehrt werden, sonst wirst du Hungrig.', 'gewöhnlich', 0, 1, 0, 'misc'),
    (58, 'Feines Diebeswerkzeug', 'Vorteil auf Fingerfertigkeit-Proben beim Knacken von Schlössern.', 'selten', 20, 0, 0, 'misc'),
    (59, 'Lupe', 'Vorteil auf Entdecken-Proben.', 'ungewöhnlich', 30, 0, 0, 'misc'),
    (60, 'Karte', 'Nötig, um einen Nachteil auf Wildnisleben-Proben zu vermeiden, wenn man während einer Reise den Weg weist.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (61, 'Murmeln', 'Können als Aktion auf einen humanoiden Gegner innerhalb von 10 Metern geworfen werden. In der nächsten Runde muss der Gegner eine Ausweichen-Probe ablegen (keine Aktion), um sich bewegen zu können.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (62, 'Vorhängeschloss', 'Ein solides Schloss für Türen oder Truhen. Verschließt eine Tür oder Truhe; kann bis zu 20 Schadenspunkte einstecken, Rüstungswert 5.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (63, 'Parfüm (10 Dosen)', 'Vorteil auf CHA-basierte Fertigkeitsproben, wenn die Spielleitung es für angemessen hält.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (64, 'Spielkarten', 'Eine Vergleichsprobe auf Täuschen entscheidet, wer gewinnt.', 'ungewöhnlich', 0, 5, 0, 'misc'),
    (65, 'Seil (Seide), 10m', 'Vorteil auf Akrobatik-Proben beim Klettern, aber das Seil muss an etwas befestigt sein.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (66, 'Sattel', 'Nötig, um einen Nachteil beim Kämpfen vom Pferderücken aus zu vermeiden.', 'gewöhnlich', 10, 0, 0, 'misc'),
    (67, 'Feuerstein & Zunder', 'Nötig, um Fackeln, Kerzen oder Laternen anzuzünden und um ein Feuer zu machen.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (68, 'Öllampe', 'Beleuchtet einen Radius von 10 Metern. Brennt bis zu einem Tagesabschnitt lang, aber würfle nach jedem Viertel einen W6. Bei einer 1 geht die Lampe aus und muss nachgefüllt und neu angezündet werden (Aktion).', 'gewöhnlich', 1, 0, 0, 'misc'),
    (69, 'Talgkerze', 'Beleuchtet einen Radius von 4 Metern. Brennt bis zu einem Tagesabschnitt lang, aber würfle nach jedem Viertel einen W4 oder wenn der Träger angreift oder angegriffen wird. Bei einer 1 geht die Kerze aus.', 'gewöhnlich', 0, 0, 1, 'misc'),
    (70, 'Brecheisen', '2W6 Schaden gegen eine Tür oder Wand, ohne Gefahr, beschädigt zu werden. Trifft automatisch.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (71, 'Hammer', '2W4 Schaden gegen eine Tür oder Wand, ohne Gefahr, beschädigt zu werden. Trifft automatisch.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (72, 'Nadel & Faden', 'Flickt Kleidung mit einer Handwerk-Probe.', 'gewöhnlich', 0, 3, 0, 'misc'),
    (73, 'Spitzhacke', '2W8 Schaden gegen eine Tür oder Wand, ohne Gefahr, beschädigt zu werden. Trifft automatisch.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (74, 'Säge', 'Durchtrennt Metall oder Holz in einem Viertel.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (75, 'Schaufel', 'Halbiert die Zeit beim Graben.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (76, 'Vorschlaghammer', '2W10 Schaden gegen eine Tür oder Wand, ohne Gefahr, beschädigt zu werden. Trifft automatisch.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (77, 'Rucksack', 'Erhöht die Tragkraft um 2. Eine Person kann nur einen Rucksack verwenden.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (78, 'Fass', 'Fasst bis zu 15 Gewichtseinheiten. Hält 10 Schadenspunkte aus, Rüstungswert 3.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (79, 'Korb', 'Fasst bis zu 10 Gewichtseinheiten.', 'gewöhnlich', 0, 4, 0, 'misc'),
    (80, 'Flasche', 'Enthält 1 Einheit Flüssigkeit.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (81, 'Eimer', 'Enthält bis zu 5 Einheiten Flüssigkeit.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (82, 'Truhe', 'Fasst bis zu 20 Gewichtseinheiten. Hält 25 Schadenspunkte aus, Rüstungswert 5.', 'gewöhnlich', 5, 0, 0, 'misc'),
    (83, 'Tonkrug', 'Enthält 1 Einheit Flüssigkeit.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (84, 'Satteltasche', 'Erhöht die Tragkraft eines Tieres um 2. Ein Tier kann nicht mehr als zwei Satteltaschen tragen.', 'gewöhnlich', 6, 0, 0, 'misc'),
    (85, 'Kreide', 'Kann als Fokus für Zauber verwendet werden.', 'gewöhnlich', 0, 0, 1, 'misc'),
    (86, 'Sanduhr', 'Kann als Fokus für Zauber verwendet werden.', 'selten', 25, 0, 0, 'misc'),
    (87, 'Papier (Blatt)', 'Kann zum Aufschreiben von Zaubern verwendet werden.', 'ungewöhnlich', 0, 2, 0, 'misc'),
    (88, 'Pergament (Blatt)', 'Kann zum Aufschreiben von Zaubern verwendet werden.', 'gewöhnlich', 0, 1, 0, 'misc'),
    (89, 'Reliquiar', 'Kann als Fokus für Zauber verwendet werden.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (90, 'Bärenfalle', 'Kann zur Jagd verwendet werden.', 'ungewöhnlich', 3, 0, 0, 'misc'),
    (91, 'Angel', 'Liefert W4 Rationen Nahrung beim Angeln.', 'gewöhnlich', 0, 8, 0, 'misc'),
    (92, 'Fischernetz', 'Liefert W6 Rationen Nahrung beim Fischen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (93, 'Schlinge', 'Kann zur Jagd verwendet werden. Nur einmal verwendbar.', 'gewöhnlich', 0, 0, 5, 'misc'),
    (94, 'Kanu', 'Kann zwei Personen und 10 Gewichtseinheiten tragen.', 'gewöhnlich', 6, 0, 0, 'misc'),
    (95, 'Ruderboot', 'Kann vier Personen und 50 Gewichtseinheiten tragen.', 'gewöhnlich', 15, 0, 0, 'misc'),
    (96, 'Segelboot', 'Kann sechs Personen und 100 Gewichtseinheiten tragen.', 'ungewöhnlich', 40, 0, 0, 'misc'),
    (97, 'Planwagen', 'Wird von zwei Pferden oder Eseln gezogen. Kann vier Personen und 100 Gewichtseinheiten tragen.', 'gewöhnlich', 30, 0, 0, 'misc'),
    (98, 'Huhn', 'Liefert eine Ration Nahrung, wenn es geschlachtet wird. Das Fleisch sollte gegart werden.', 'gewöhnlich', 0, 4, 0, 'misc'),
    (99, 'Kuh', 'Liefert W4 Rationen Nahrung (Milch) pro Tag und 2W10 Rationen Nahrung, wenn sie geschlachtet wird. Das Fleisch sollte gegart werden.', 'ungewöhnlich', 10, 0, 0, 'misc'),
    (100, 'Wachhund', 'Beschützt seinen Besitzer. Werte: siehe Hund im Bestiarium.', 'gewöhnlich', 15, 0, 0, 'misc'),
    (101, 'Brieftaube (im Käfig)', 'Fliegt zu ihrem Schlag zurück, egal woher sie freigelassen wird.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (102, 'Schwein', 'Liefert 2W6 Rationen Nahrung, wenn es geschlachtet wird. Das Fleisch sollte gegart werden.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (103, 'Reitpferd', 'Kann einen Reiter und 10 Gewichtseinheiten tragen, oder zwei Reiter.', 'ungewöhnlich', 60, 0, 0, 'misc'),
    (104, 'Schaf', 'Liefert 2W4 Rationen Nahrung, wenn es geschlachtet wird. Das Fleisch sollte gegart werden.', 'gewöhnlich', 3, 0, 0, 'misc'),
    (105, 'Gift, tödlich (Dosis)', 'Volle Wirkung: In deinem Zug erleidest du in jeder Runde W6 Schaden, bis deine TP auf null sinken. Nimmst du rechtzeitig ein Gegengift ein, wird die Wirkung unterbrochen. Eingeschränkte Wirkung: Bei deinem nächsten Zug erleidest du W6 Schaden.', 'ungewöhnlich', 2, 0, 0, 'misc'),
    (106, 'Gift, lähmend (Dosis)', 'Volle Wirkung: Du bist Erschöpft und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, kannst du dich in dieser Runde weder bewegen noch eine Aktion durchführen (nicht einmal Freie Aktionen). Die Wirkung lässt nach einem Viertel oder der Einnahme eines Gegengifts nach. Eingeschränkte Wirkung: Du bist Erschöpft.', 'ungewöhnlich', 1, 2, 0, 'misc'),
    (107, 'Gift, einschläfernd (Dosis)', 'Volle Wirkung: Du bist Benommen und musst in jedem Zug eine KON-Probe ablegen (keine Aktion). Scheitert sie, schläfst du ein und wachst erst nach einer ganzen Schicht wieder auf. Sobald du ein Gegengift erhältst oder wenigstens einen Schadenspunkt erleidest, wachst du auf. Eingeschränkte Wirkung: Du bist Benommen.', 'ungewöhnlich', 0, 6, 0, 'misc'),
    (108, 'Kräutersud (Dosis)', 'Vorteil auf Heilkunde-Proben, um einer Krankheit zu widerstehen.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    (109, 'Heiltrank (Dosis)', 'Heilt sofort 2W6 TP. Stärkere Tränke heilen mehr TP, sind aber teurer.', 'selten', 50, 0, 0, 'misc'),
    (110, 'Chirurgenbesteck', 'Vorteil auf Heilkunde-Proben, um ein Leben zu retten.', 'ungewöhnlich', 15, 0, 0, 'misc'),
    (111, 'Langbogen', 'Ein großer Bogen für weite Distanzen.', 'ungewöhnlich', 50, 0, 0, 'weapon'),
    (112, 'Messer', 'Ein handliches Messer, das auch geworfen werden kann.', 'gewöhnlich', 0, 5, 0, 'weapon'),
    (113, 'Kurzschwert', 'Ein leichtes, einhändig geführtes Schwert.', 'gewöhnlich', 8, 0, 0, 'weapon'),
    (114, 'Schild, klein', 'Ein kleiner, leichter Schild.', 'gewöhnlich', 4, 0, 0, 'weapon'),
    (115, 'Streitaxt', 'Eine schwere einhändige Axt.', 'ungewöhnlich', 10, 0, 0, 'weapon'),
    (116, 'Dolch', 'Eine kurze Klinge, unauffällig zu tragen.', 'gewöhnlich', 1, 0, 0, 'weapon'),
    (117, 'Langspeer', 'Ein langer Speer für die erste Kampflinie.', 'gewöhnlich', 1, 0, 0, 'weapon'),
    (118, 'Kurzspeer', 'Ein kurzer, wurfbarer Speer.', 'gewöhnlich', 0, 5, 0, 'weapon'),
    (119, 'Krummsäbel', 'Ein gebogenes, einhändiges Schwert.', 'ungewöhnlich', 10, 0, 0, 'weapon'),
    (120, 'Beil', 'Eine kompakte Axt.', 'gewöhnlich', 2, 0, 0, 'weapon'),
    (121, 'Zweihandaxt', 'Eine gewaltige, beidhändig geführte Axt.', 'ungewöhnlich', 25, 0, 0, 'weapon'),
    (122, 'Plattenpanzer', 'Nachteil auf Akrobatik-, Ausweichen- und Heimlichkeit-Proben.', 'selten', 500, 0, 0, 'armor'),
    (123, 'Beschlagenes Leder', 'Nachteil auf Heimlichkeit-Proben.', 'ungewöhnlich', 10, 0, 0, 'armor'),
    (124, 'Kettenpanzer', 'Nachteil auf Ausweichen- und Heimlichkeit-Proben.', 'ungewöhnlich', 50, 0, 0, 'armor'),
    (125, 'Köcher, Holzspitzen', 'Nötig, um mit Bögen oder Armbrüsten zu schießen. Die Wirksamkeit von Rüstung wird verdoppelt.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (126, 'Seil (Hanf), 10m', 'Vorteil auf Akrobatik-Proben beim Klettern, aber das Seil muss an etwas befestigt sein.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (127, 'Laterne', 'Beleuchtet einen Radius von 10 Metern. Brennt bis zu einem Tagesabschnitt lang, aber würfle nach jedem Viertel einen W8. Bei einer 1 geht die Laterne aus und muss nachgefüllt und neu angezündet werden (Aktion).', 'gewöhnlich', 10, 0, 0, 'misc'),
    (128, 'Lampenöl', 'Reicht für zehn Dosen. Jede Dose hält eine Öllampe oder Laterne bis zu einem Tagesabschnitt lang am Brennen.', 'gewöhnlich', 0, 3, 0, 'misc'),
    (129, 'Dietriche', 'Nötig, um einen Nachteil auf Fingerfertigkeit-Proben beim Knacken von Schlössern zu vermeiden.', 'ungewöhnlich', 1, 0, 0, 'misc'),
    (130, 'Wurfhaken', 'Ein Enterhaken mit Seil. Kann verwendet werden, um ein Seil zu sichern; wird mit einer Akrobatik-Probe bis zu STÄ Meter weit geworfen (STÄ×2 mit einem Nachteil).', 'gewöhnlich', 3, 0, 0, 'misc'),
    (131, 'Fernrohr', 'Ein Fernrohr für die weite Sicht. Bonus auf Wildnisleben-Proben, um während einer Reise den Weg zu weisen.', 'selten', 50, 0, 0, 'misc'),
    (132, 'Schlafpelz', 'Nötig, um einen Nachteil auf Wildnisleben-Proben beim Lagern zu vermeiden.', 'gewöhnlich', 1, 0, 0, 'misc'),
    (133, 'Zelt, klein', 'Bietet Platz für bis zu zwei Personen. Gewährt einen Vorteil auf Wildnisleben-Proben beim Lagern; nur eine Person würfelt, andere können helfen.', 'gewöhnlich', 2, 0, 0, 'misc'),
    (134, 'Zelt, groß', 'Bietet Platz für bis zu sechs Personen. Gewährt einen Vorteil auf Wildnisleben-Proben beim Lagern; nur eine Person würfelt, andere können helfen.', 'gewöhnlich', 4, 0, 0, 'misc'),
    (135, 'Pfeife (Signalpfeife)', 'Kann aus bis zu 100 Metern Entfernung gehört werden.', 'gewöhnlich', 0, 5, 0, 'misc'),
    (136, 'Brosche', 'Kann als magischer Fokus für Zauber verwendet werden.', 'ungewöhnlich', 5, 0, 0, 'misc'),
    (137, 'Stumpfer Gegenstand, leicht', 'Ein improvisierter Gegenstand, der als Waffe benutzt wird.', 'gewöhnlich', 0, 0, 0, 'weapon'),
    (138, 'Stumpfer Gegenstand, schwer', 'Ein schwerer, improvisierter Gegenstand, der als Waffe benutzt wird.', 'gewöhnlich', 0, 0, 0, 'weapon'),
    (139, 'Zweihandschwert', 'Ein mächtiges Schwert, das mit beiden Händen geführt wird.', 'selten', 50, 0, 0, 'weapon'),
    (140, 'Holzkeule, klein', 'Ein kleiner Knüppel aus Holz.', 'gewöhnlich', 0, 1, 0, 'weapon'),
    (141, 'Holzkeule, groß', 'Eine große, schwere Keule aus Holz.', 'gewöhnlich', 0, 2, 0, 'weapon'),
    (142, 'Köcher, Eisenspitzen', 'Nötig, um mit Bögen oder Armbrüsten zu schießen.', 'gewöhnlich', 2, 0, 0, 'misc');

-- catalog_item_weapons
INSERT INTO catalog_item_weapons (item_id, grip_de, str_requirement, range_de, damage_de, durability, traits_de) VALUES
    (1, '2-händig', 7, '2', 'W8', 9, 'Wucht, Niederwerfend'),
    (8, '2-händig', 7, '30', 'W10', 3, 'Stich, benötigt Köcher'),
    (9, '1-händig', 13, '2', '2W8', 15, 'Stich, Hieb'),
    (10, '1-händig', NULL, '20', 'W8', NULL, 'Wucht, kleiner Gegenstand'),
    (11, '1-händig', 10, '2', '2W6', 15, 'Stich, Hieb'),
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
    (121, '2-händig', 16, '2', '2W10', 9, 'Hieb, Niederwerfend'),
    (137, '1-händig', NULL, 'STR', 'W8', 3, 'Wucht, kann geworfen werden'),
    (138, '2-händig', 16, '2', '2W8', 3, 'Wucht'),
    (139, '2-händig', 16, '2', '2W10', 15, 'Stich, Hieb'),
    (140, '1-händig', 7, '2', 'W8', 9, 'Wucht'),
    (141, '2-händig', 16, '2', '2W8', 12, 'Wucht');

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
    (18, 'Meister-Schmied', 'Handwerk 12', 'unterschiedlich', 'Erfordert Schmiedewerkzeug. Innerhalb einer Rast kannst du für 3 WP eine geschärfte oder spitze Waffe schärfen: Gegen eine geschärfte Waffe zählt die Rüstung eines Ziels einen Schritt niedriger. Der Effekt hält bis zum Ende des nächsten Kampfes an, in dem die Waffe benutzt wurde. In einer Schicht kannst du eine Metallwaffe oder Metallrüstung deiner Wahl anfertigen; dafür benötigst du eine Schmiede, einen Amboss und Eisen (Gewicht 1). Die WP-Kosten entsprechen dem aufgerundeten Dukatenpreis des Gegenstands; die Arbeit kann auf mehrere Schichten verteilt werden, falls nicht genug WP vorhanden sind.', 0),
    (19, 'Meister-Zimmermann', 'Handwerk 12', 'unterschiedlich', 'Erfordert Zimmermannswerkzeug. Als Aktion kannst du pro eingesetztem WP W12 Schaden an einer Tür, Wand oder einem anderen unbelebten Objekt verursachen, ohne dessen Rüstung zu berücksichtigen. In einer Schicht kannst du einen hölzernen Gegenstand deiner Wahl anfertigen (z. B. Keule, Stab oder Schild); dafür benötigst du Holz (Gewicht 1 oder nach Ansage der Spielleitung). Die WP-Kosten entsprechen dem aufgerundeten Dukatenpreis des Gegenstands, bei unaufgelisteten Gegenständen legt die Spielleitung die Kosten fest.', 0),
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
    (1, 'kaempfer', 'A', 'W6 Tagesrationen', 'W6'),
    (2, 'kaempfer', 'B', 'W6 Tagesrationen', 'W6'),
    (3, 'kaempfer', 'C', 'W6 Tagesrationen', 'W6'),
    (4, 'jaeger', 'A', 'W8 Tagesrationen', 'W8'),
    (5, 'jaeger', 'B', 'W8 Tagesrationen', 'W8'),
    (6, 'jaeger', 'C', 'W8 Tagesrationen', 'W8'),
    (7, 'ritter', 'A', 'W6 Tagesrationen', 'W12'),
    (8, 'ritter', 'B', 'W6 Tagesrationen', 'W12'),
    (9, 'ritter', 'C', 'W6 Tagesrationen', 'W12'),
    (10, 'seefahrerin', 'A', 'W8 Tagesrationen', 'W10'),
    (11, 'seefahrerin', 'B', 'W8 Tagesrationen', 'W10'),
    (12, 'seefahrerin', 'C', 'W8 Tagesrationen', 'W10'),
    (13, 'haendler', 'A', 'W6 Tagesrationen', 'W12'),
    (14, 'haendler', 'B', 'W6 Tagesrationen', 'W12'),
    (15, 'haendler', 'C', 'W6 Tagesrationen', 'W12'),
    (16, 'dieb', 'A', 'W6 Tagesrationen', 'W10'),
    (17, 'dieb', 'B', 'W6 Tagesrationen', 'W10'),
    (18, 'dieb', 'C', 'W6 Tagesrationen', 'W10'),
    (19, 'handwerker', 'A', 'W8 Tagesrationen', 'W8'),
    (20, 'handwerker', 'B', 'W8 Tagesrationen', 'W8'),
    (21, 'handwerker', 'C', 'W8 Tagesrationen', 'W8'),
    (22, 'gelehrter', 'A', 'W6 Tagesrationen', 'W10'),
    (23, 'gelehrter', 'B', 'W6 Tagesrationen', 'W10'),
    (24, 'gelehrter', 'C', 'W6 Tagesrationen', 'W10'),
    (25, 'magier', 'A', 'W6 Tagesrationen', 'W8'),
    (26, 'magier', 'B', 'W6 Tagesrationen', 'W8'),
    (27, 'magier', 'C', 'W6 Tagesrationen', 'W8'),
    (28, 'barde', 'A', 'W6 Tagesrationen', 'W8'),
    (29, 'barde', 'B', 'W6 Tagesrationen', 'W8'),
    (30, 'barde', 'C', 'W6 Tagesrationen', 'W8');

-- catalog_profession_gear_option_items
INSERT INTO catalog_profession_gear_option_items (gear_option_id, item_id, quantity, choice_group) VALUES
    (1, 11, 1, 1),
    (1, 115, 1, 1),
    (1, 36, 1, 1),
    (1, 114, 1, NULL),
    (1, 124, 1, NULL),
    (1, 3, 1, NULL),
    (1, 67, 1, NULL),
    (2, 113, 1, 1),
    (2, 120, 1, 1),
    (2, 118, 1, 1),
    (2, 14, 1, NULL),
    (2, 125, 1, NULL),
    (2, 7, 1, NULL),
    (2, 3, 1, NULL),
    (2, 67, 1, NULL),
    (3, 117, 1, NULL),
    (3, 123, 1, NULL),
    (3, 16, 1, NULL),
    (3, 3, 1, NULL),
    (3, 67, 1, NULL),
    (4, 116, 1, NULL),
    (4, 8, 1, NULL),
    (4, 125, 1, NULL),
    (4, 7, 1, NULL),
    (4, 132, 1, NULL),
    (4, 3, 1, NULL),
    (4, 67, 1, NULL),
    (4, 126, 1, NULL),
    (4, 93, 1, NULL),
    (5, 112, 1, NULL),
    (5, 111, 1, NULL),
    (5, 125, 1, NULL),
    (5, 7, 1, NULL),
    (5, 132, 1, NULL),
    (5, 126, 1, NULL),
    (5, 91, 1, NULL),
    (6, 116, 1, NULL),
    (6, 10, 1, NULL),
    (6, 7, 1, NULL),
    (6, 132, 1, NULL),
    (6, 3, 1, NULL),
    (6, 67, 1, NULL),
    (6, 126, 1, NULL),
    (6, 93, 1, NULL),
    (7, 11, 1, 1),
    (7, 36, 1, 1),
    (7, 114, 1, NULL),
    (7, 122, 1, NULL),
    (7, 17, 1, NULL),
    (7, 3, 1, NULL),
    (7, 67, 1, NULL),
    (8, 12, 1, 1),
    (8, 21, 1, 1),
    (8, 114, 1, NULL),
    (8, 124, 1, NULL),
    (8, 16, 1, NULL),
    (8, 3, 1, NULL),
    (8, 67, 1, NULL),
    (9, 113, 1, NULL),
    (9, 13, 1, NULL),
    (9, 114, 1, NULL),
    (9, 124, 1, NULL),
    (9, 16, 1, NULL),
    (9, 18, 1, NULL),
    (10, 116, 1, NULL),
    (10, 8, 1, NULL),
    (10, 125, 1, NULL),
    (10, 126, 1, NULL),
    (10, 130, 1, NULL),
    (10, 132, 1, NULL),
    (10, 3, 1, NULL),
    (10, 67, 1, NULL),
    (11, 119, 1, NULL),
    (11, 7, 1, NULL),
    (11, 126, 1, NULL),
    (11, 130, 1, NULL),
    (11, 3, 1, NULL),
    (11, 67, 1, NULL),
    (12, 15, 1, NULL),
    (12, 131, 1, NULL),
    (12, 126, 1, NULL),
    (12, 130, 1, NULL),
    (12, 3, 1, NULL),
    (12, 67, 1, NULL),
    (13, 116, 1, NULL),
    (13, 132, 1, NULL),
    (13, 3, 1, NULL),
    (13, 67, 1, NULL),
    (13, 126, 1, NULL),
    (13, 19, 1, NULL),
    (14, 112, 1, NULL),
    (14, 132, 1, NULL),
    (14, 127, 1, NULL),
    (14, 128, 1, NULL),
    (14, 67, 1, NULL),
    (14, 56, 1, NULL),
    (14, 19, 1, NULL),
    (14, 20, 1, NULL),
    (15, 116, 1, NULL),
    (15, 132, 1, NULL),
    (15, 134, 1, NULL),
    (15, 68, 1, NULL),
    (15, 128, 1, NULL),
    (15, 67, 1, NULL),
    (15, 77, 1, NULL),
    (16, 116, 1, NULL),
    (16, 10, 1, NULL),
    (16, 126, 1, NULL),
    (16, 130, 1, NULL),
    (16, 3, 1, NULL),
    (16, 67, 1, NULL),
    (17, 112, 1, NULL),
    (17, 129, 1, NULL),
    (17, 3, 1, NULL),
    (17, 67, 1, NULL),
    (18, 116, 2, NULL),
    (18, 61, 1, NULL),
    (18, 126, 1, NULL),
    (18, 3, 1, NULL),
    (18, 67, 1, NULL),
    (19, 21, 1, NULL),
    (19, 7, 1, NULL),
    (19, 22, 1, NULL),
    (19, 3, 1, NULL),
    (19, 67, 1, NULL),
    (20, 120, 1, NULL),
    (20, 7, 1, NULL),
    (20, 23, 1, NULL),
    (20, 3, 1, NULL),
    (20, 126, 1, NULL),
    (20, 67, 1, NULL),
    (21, 112, 1, NULL),
    (21, 7, 1, NULL),
    (21, 24, 1, NULL),
    (21, 127, 1, NULL),
    (21, 128, 1, NULL),
    (21, 67, 1, NULL),
    (22, 1, 1, NULL),
    (22, 25, 1, NULL),
    (22, 26, 1, NULL),
    (22, 132, 1, NULL),
    (22, 3, 1, NULL),
    (22, 67, 1, NULL),
    (23, 112, 1, NULL),
    (23, 5, 1, NULL),
    (23, 132, 1, NULL),
    (23, 68, 1, NULL),
    (23, 128, 1, NULL),
    (23, 67, 1, NULL),
    (24, 113, 1, NULL),
    (24, 27, 1, NULL),
    (24, 107, 1, NULL),
    (24, 132, 1, NULL),
    (24, 127, 1, NULL),
    (24, 128, 1, NULL),
    (24, 67, 1, NULL),
    (25, 1, 1, NULL),
    (25, 28, 1, NULL),
    (25, 31, 1, NULL),
    (25, 3, 1, NULL),
    (25, 67, 1, NULL),
    (26, 112, 1, NULL),
    (26, 29, 1, NULL),
    (26, 31, 1, NULL),
    (26, 3, 1, NULL),
    (26, 67, 1, NULL),
    (27, 30, 1, NULL),
    (27, 31, 1, NULL),
    (27, 132, 1, NULL),
    (27, 3, 1, NULL),
    (27, 67, 1, NULL),
    (28, 32, 1, NULL),
    (28, 112, 1, NULL),
    (28, 68, 1, NULL),
    (28, 128, 1, NULL),
    (28, 67, 1, NULL),
    (29, 33, 1, NULL),
    (29, 116, 1, NULL),
    (29, 126, 1, NULL),
    (29, 3, 1, NULL),
    (29, 67, 1, NULL),
    (30, 34, 1, NULL),
    (30, 112, 1, NULL),
    (30, 3, 1, NULL),
    (30, 67, 1, NULL);

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
    (8, 8, 8, 'Ein Heller aus einem Schatz, den deine Mutter oder dein Vater gesucht hat'),
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
    ('nsc_name', 'NSC erschaffen', 'Name (einen wählen)', 'W20', 'Ergebnis', NULL, 65),
    ('schatz_1', 'Schätze', 'Schatztabelle 1', 'W20', 'Schatz|Wert', 'Würfle W6, um die Tabelle zu bestimmen: 1–3: Schatztabelle 1, 4–6: Schatztabelle 2.', 70),
    ('schatz_2', 'Schätze', 'Schatztabelle 2', 'W20', 'Schatz|Wert, Gegenstand oder Wirkung', 'Würfle W6, um die Tabelle zu bestimmen: 1–3: Schatztabelle 1, 4–6: Schatztabelle 2.', 71);

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
    ('nsc_name', 20, 20, 'Olgrid, Idun, Nikias', NULL, NULL),
    ('schatz_1', 1, 1, 'Heller', 'W6 Heller', NULL),
    ('schatz_1', 2, 2, 'Heller', '2W6 Heller', NULL),
    ('schatz_1', 3, 3, 'Heller', '4W6 Heller', NULL),
    ('schatz_1', 4, 4, 'Heller', '2W6 × 10 Heller', NULL),
    ('schatz_1', 5, 5, 'Heller', '4W6 × 10 Heller', NULL),
    ('schatz_1', 6, 6, 'Kronen', 'W6 Kronen', NULL),
    ('schatz_1', 7, 7, 'Kronen', '3W6 Kronen', NULL),
    ('schatz_1', 8, 8, 'Kronen', 'W6 × 5 Kronen', NULL),
    ('schatz_1', 9, 9, 'Kronen', 'W6 × 10 Kronen', NULL),
    ('schatz_1', 10, 10, 'Kronen', '2W6 × 10 Kronen', NULL),
    ('schatz_1', 11, 11, 'Kronen', '3W6 × 10 Kronen', NULL),
    ('schatz_1', 12, 12, 'Dukaten', 'W6 Dukaten', NULL),
    ('schatz_1', 13, 13, 'Dukaten', '2W6 Dukaten', NULL),
    ('schatz_1', 14, 14, 'Dukaten', '4W6 Dukaten', NULL),
    ('schatz_1', 15, 15, 'Dukaten', 'W6 × 10 Dukaten', NULL),
    ('schatz_1', 16, 16, 'Dukaten', '2W6 × 10 Dukaten', NULL),
    ('schatz_1', 17, 17, 'Kelch', '2W6 × 5 Dukaten', NULL),
    ('schatz_1', 18, 18, 'Silberarmband', '2W6 × 10 Kronen', NULL),
    ('schatz_1', 19, 19, 'Goldarmband', '2W6 × 10 Dukaten', NULL),
    ('schatz_1', 20, 20, 'Silberkette', '2W6 × 5 Kronen', NULL),
    ('schatz_2', 1, 1, 'Goldkette', '2W6 Dukaten', NULL),
    ('schatz_2', 2, 2, 'Silberring', '2W6 Kronen', NULL),
    ('schatz_2', 3, 3, 'Goldring', '4W6 Dukaten', NULL),
    ('schatz_2', 4, 4, 'Silberbrosche', '2W6 × 5 Kronen', NULL),
    ('schatz_2', 5, 5, 'Goldamulett', '2W6 × 5 Dukaten', NULL),
    ('schatz_2', 6, 6, 'Edelstein', 'Würfle W6. 1: Glas (Wert 2 Heller), 2: Kristall (Wert 10 Kronen), 3: Smaragd (Wert 10 Dukaten), 4: Saphir (Wert 15 Dukaten), 5: Rubin (Wert 25 Dukaten), 6: Diamant (Wert 100 Dukaten).', NULL),
    ('schatz_2', 7, 7, 'Kleidung', 'Würfle W3. 1: Stiefel, 2: Umhang, 3: Pelzumhang.', NULL),
    ('schatz_2', 8, 8, 'Nahkampfwaffe', 'Würfle W6. 1: Dolch, 2: Kurzschwert, 3: Kurzspeer, 4: Breitschwert, 5: Langspeer, 6: Langschwert.', NULL),
    ('schatz_2', 9, 9, 'Nahkampfwaffe', 'Würfle W6. 1: Beil, 2: Krummsäbel, 3: Morgenstern, 4: Parierdolch, 5: Kriegshammer, klein, 6: Dreschflegel.', NULL),
    ('schatz_2', 10, 10, 'Fernkampfwaffe', 'Würfle W6. 1: Schleuder, 2: Kurzbogen, 3: Langbogen, 4: Leichte Armbrust, 5: Schwere Armbrust, 6: Handarmbrust.', NULL),
    ('schatz_2', 11, 11, 'Meisterwerk-Waffe', 'Würfle W6. 1: Dolch, 2: Kurzschwert, 3: Streitaxt, 4: Breitschwert, 5: Kriegshammer, schwer, 6: Langschwert.', NULL),
    ('schatz_2', 12, 12, 'Rüstung/Schild', 'Würfle W6. 1: Schild, klein, 2: Schild, groß, 3: Offener Helm, 4: Großhelm, 5: Beschlagenes Leder, 6: Kettenpanzer.', NULL),
    ('schatz_2', 13, 13, 'Giftdolch', 'Würfle auf Ausweichen. Misslingt der Wurf, schneidest du dich und leidest unter einem Gift der Wirkstärke 12. Würfle W3 für die Art. 1: tödlich, 2: lähmend, 3: einschläfernd.', NULL),
    ('schatz_2', 14, 14, 'Rostiger Nagel', 'Würfle auf Ausweichen. Misslingt der Wurf, erleidest du W6 Schaden. Rüstung hat keine Wirkung.', NULL),
    ('schatz_2', 15, 15, 'Grimoire', 'Würfle W4 für die Schule. 1: Animismus, 2: Elementarismus, 3: Mentalismus, 4: allgemeine Magie. Würfle W4−1 für den Zaubergrad (0 bedeutet Zaubertricks) und W4 für die Nummer. Die Spielleitung wählt die genauen Zauber oder würfelt sie aus.', NULL),
    ('schatz_2', 16, 16, 'Flasche', 'Eine Heilkunde-Probe enthüllt den Inhalt. Bei einem Fehlschlag würfelt die Spielleitung im Geheimen. Würfle W6. 1: tödliches Gift (Wirkstärke 12), 2: Schlafgift (Wirkstärke 14), 3: Schnaps, 4: Kräutersud, 5: Heiltrank (2W6 TP), 6: Heiltrank (3W6 TP).', NULL),
    ('schatz_2', 17, 17, 'Buch', 'Würfle W6 für den Titel. 1: Essen oder gegessen werden – Pflanzen des Waldes, 2: Grammatik der Drachensprache, 3: Uralte Helden und Schurken, 4: Handbuch des Meister-Zimmermanns, 5: Bestien der Höhle – Eine Enzyklopädie, 6: Blut, Schleim und Galle – Beherrsche deine Körpersäfte.', NULL),
    ('schatz_2', 18, 18, 'Instrument', 'Würfle W6. 1: Horn, 2: Flöte, 3: Harfe, 4: Leier, 5: Dudelsack, 6: Trommel.', NULL),
    ('schatz_2', 19, 19, 'Handelswaren', 'Würfle W6. 1: Lupe, 2: Fernrohr, 3: Parfüm, 4: Schachspiel, 5: Spielkarten, 6: Murmeln.', NULL),
    ('schatz_2', 20, 20, 'Ratte', 'Würfle auf Ausweichen. Misslingt der Wurf, erleidest du W4 Schaden. Rüstung hat keine Wirkung.', NULL);

-- catalog_rules
INSERT INTO catalog_rules (code, title_de, badge_de, badge_style, search_de, summary_de, body_de) VALUES
    ('fertigkeitsprobe', 'Fertigkeitsprobe', 'W20', NULL, NULL, NULL, '<p>Beschreibe zuerst, was dein Charakter erreichen will, und würfle dann einen W20. Ein Ergebnis kleiner oder gleich deinem Fertigkeitswert ist ein Erfolg. Die SL würfelt nur in herausfordernden Situationen und bewertet nicht, wie schwierig eine Probe ist.</p><p><strong>Fehlschlag:</strong> Ein Wurf über deinem Wert misslingt. Beschreibt gemeinsam mit der SL, was passiert. Die SL kann Fehlschläge mit zusätzlichen Konsequenzen versehen, um die Geschichte spannender zu machen.</p>'),
    ('dragon', 'Drache', 'Wurf 1', NULL, NULL, NULL, '<p>Eine 1 auf dem W20 ist besonders erfolgreich. Im Kampf hat ein Drache bestimmte Auswirkungen, er erhöht zum Beispiel den Schaden eines Angriffs. Außerhalb des Kampfes entscheidet die SL über den Effekt, etwa: Du beeindruckst alle um dich herum, du erreichst mehr als beabsichtigt oder die Aktion wird schneller als gewöhnlich ausgeführt.</p><p>Ein Drache auf einer Fertigkeit gibt dir eine Steigerungsmarke (siehe Heldenfähigkeiten, Erfahrung).</p>'),
    ('demon', 'Dämon', 'Wurf 20', NULL, NULL, NULL, '<p>Eine 20 auf dem W20 schlägt immer fehl, unabhängig von deinem Fertigkeitswert und anderen Umständen. Ein Dämon lässt sich nicht strapazieren. Im Kampf kann er zusätzliche Effekte haben, außerhalb davon kann die SL ihn mit Effekten versehen, etwa: Du schädigst dich selbst, einen anderen oder einen Gegenstand, du machst dich vor allen lächerlich oder du machst eine Menge Lärm.</p><p>Ein Dämon auf einer Fertigkeit gibt dir ebenfalls eine Steigerungsmarke.</p>'),
    ('attributsprobe', 'Attributsprobe', 'Attribut', NULL, NULL, NULL, '<p>Gibt es keine Fertigkeit, die zur Situation passt, kann die SL stattdessen eine Attributsprobe verlangen, zum Beispiel eine STÄ-Probe, um etwas Schweres zu heben. Gibt es eine Fertigkeit, welche die gewünschte Aktion abdeckt, muss die Probe auf dieser basieren. In unklaren Fällen entscheidet die SL.</p>'),
    ('nur_eine_chance', 'Nur eine Chance', 'Regel', NULL, NULL, NULL, '<p>In der Regel hast du nur eine Chance, eine Probe erfolgreich durchzuführen. Wenn du einmal gewürfelt hast, darfst du den Wurf nicht wiederholen, um das gleiche Ziel zu erreichen. Versuche etwas anderes, warte ab, bis sich die Umstände geändert haben, oder lass einen anderen Charakter ran. Diese Regel gilt nicht im Kampf.</p>'),
    ('vorteil_nachteil', 'Vorteil & Nachteil', 'Zwei W20', NULL, NULL, NULL, '<p>Manchmal erleichtern oder erschweren äußere Faktoren eine Probe. Dann erhältst du einen <strong>Vorteil</strong> oder <strong>Nachteil</strong>: Du würfelst zwei W20, aber nur ein Ergebnis zählt. Bei einem Vorteil zählt das bessere (niedrigere), bei einem Nachteil das schlechtere (höhere) Ergebnis. Manche Regeln geben Vorteil oder Nachteil direkt vor, etwa beim Angriff auf einen liegenden Gegner oder beim Schießen auf große Entfernung.</p><p><strong>Mehrere Vor- oder Nachteile:</strong> Würfle für jeden einen zusätzlichen W20 und zähle nur das niedrigste beziehungsweise höchste Ergebnis. Proben mit mehreren Nachteilen haben allerdings nur geringe Erfolgsaussichten, es sei denn, der Fertigkeitswert ist sehr hoch.</p><p><strong>Vorteil und Nachteil zugleich:</strong> Jeder Vorteil hebt einen Nachteil auf und umgekehrt. Bei einem Vorteil und einem Nachteil würfelst du normal (ein W20). Bei zwei Vorteilen und einem Nachteil zählt es als ein Vorteil.</p>'),
    ('hilfe_von_anderen', 'Hilfe von anderen', 'Vorteil', NULL, NULL, NULL, '<p>Ein anderer Spielercharakter oder NSC kann dich bei einem Wurf unterstützen. Das muss <strong>vor deinem Wurf</strong> erklärt werden und in der Geschichte Sinn ergeben: Die helfende Person muss anwesend sein und in der Lage, deine Aktion zu unterstützen. Die SL hat das letzte Wort. Jedes Mal, wenn dich jemand unterstützt, erhältst du einen Vorteil. Im Kampf zählt das Helfen als Aktion, du verlierst also in dieser Runde deine eigene. NSC können sich gegenseitig helfen, aber immer nur ein Charakter pro Probe.</p>'),
    ('den_wurf_strapazieren', 'Den Wurf strapazieren', 'Optional', NULL, NULL, NULL, '<p>Misslingt eine Fertigkeits- oder Attributsprobe, kannst du den Wurf <strong>strapazieren</strong>: Du darfst es noch einmal versuchen, und das neue Ergebnis gilt, egal wie es ausfällt. Hast du Vorteil oder Nachteil, würfelst du alle Würfel neu. Einen Dämon kannst du nie strapazieren.</p><p>Nach dem erneuten Wurf erleidest du sofort einen <strong>Zustand</strong>, der ein Attribut betrifft: Erschöpft (STÄ), Kränkelnd (KON), Benommen (GEW), Wütend (INT), Verängstigt (WIL) oder Verzagt (CHA). Du hast dann einen Nachteil auf alle Proben, die auf diesem Attribut basieren. Du wählst den Zustand selbst, darfst aber keinen wählen, den du schon hast, und musst erklären können, wie er aus der Handlung entsteht (die SL darf unsinnige Erklärungen ablehnen). Hast du alle sechs Zustände, kannst du nicht mehr strapazieren.</p><p>Von Zuständen erholst du dich durch Rasten. <strong>NSC und Monster</strong> können nicht strapazieren.</p>'),
    ('vergleichende_probe', 'Vergleichende Probe', 'Gegner', NULL, NULL, NULL, '<p>Manchmal musst du einen Gegner in einer vergleichenden Probe besiegen: Ihr beide würfelt. Das kommt nur selten vor und nur, wenn sich jemand aktiv gegen dich stellt. Im Kampf zählt sie nur als Aktion für die handelnde Partei.</p><ul><li>Scheitert deine Probe, scheitert auch deine Aktion, egal wie der Gegner würfelt.</li><li>Gelingt deine Probe und dem Gegner nicht, gelingt deine Aktion.</li><li>Gelingt es beiden, gelingt deine Aktion, wenn dein Wurf kleiner oder gleich dem des Gegners ist. Ist das Ergebnis des Gegners niedriger, scheiterst du.</li></ul><p><strong>Strapazieren:</strong> Auch vergleichende Proben lassen sich strapazieren, aber nur von der handelnden Partei und auch nach dem Wurf des Gegners.</p>'),
    ('offene_vergleichende_probe', 'Offene vergleichende Probe', 'Gegner', NULL, NULL, NULL, '<p>Die SL kann auch dann vergleichende Proben nutzen, wenn keine Partei aktiv ist, zum Beispiel STÄ gegen STÄ beim Armdrücken. Offene vergleichende Proben werden wiederholt, wenn beide scheitern oder beide gelingen und dasselbe Ergebnis würfeln. Beide Seiten dürfen ihren Wurf strapazieren.</p>'),
    ('die_sechs_zustaende', 'Die sechs Zustände', 'Zustand', NULL, NULL, NULL, '<p>Jeder Zustand gibt dir einen <strong>Nachteil</strong> auf alle Proben auf ein bestimmtes Attribut und auf Fertigkeiten, die darauf basieren:</p><ul>
            <li><strong>Erschöpft</strong> – STÄ</li>
            <li><strong>Kränkelnd</strong> – KON</li>
            <li><strong>Benommen</strong> – GEW</li>
            <li><strong>Wütend</strong> – INT</li>
            <li><strong>Verängstigt</strong> – WIL</li>
            <li><strong>Verzagt</strong> – CHA</li>
        </ul>'),
    ('zustand_erleiden', 'Zustand erleiden', 'Zustand', NULL, NULL, NULL, '<p>Am häufigsten erleidest du einen Zustand, wenn du einen Wurf strapazierst (optionale Regel). Dann wählst du einen Zustand und beschreibst, wie du ihn bekommst. Auch Monsterangriffe oder Zauber können Zustände verursachen.</p><p><strong>Mehrere Zustände:</strong> Hast du den Zustand schon, musst du einen anderen wählen. Hast du alle sechs, verlierst du stattdessen W6 WP. Bist du bei null WP, verlierst du W6 TP.</p><p><strong>Heilung:</strong> Bei einer Kurzen Rast (Viertel) heilst du einen Zustand deiner Wahl, bei einer Langen Rast (Tagesabschnitt) alle.</p>'),
    ('death_rolls', 'Sterben & Todeswürfe', 'KON', NULL, NULL, NULL, '<p>Sinken deine TP auf null, fällst du zu Boden und riskierst zu sterben. Du kannst dich nicht bewegen und nur versuchen, dich aufzurappeln.</p><p><strong>Todeswurf:</strong> In jeder folgenden Runde musst du in deinem Zug eine Probe auf <strong>KON</strong> ablegen. Sie kann nicht strapaziert werden, auch nicht mit der optionalen Regel. Trage die Ergebnisse auf dem Charakterbogen ein. Nach drei gelungenen Würfen erhältst du W6 TP zurück und musst nicht mehr würfeln. Nach drei Fehlschlägen stirbt dein Charakter. Ein Drache zählt als zwei Erfolge, ein Dämon als zwei Fehlschläge. Nach dem Kampf zählst du weiter die Runden, bis alle Todeswürfe gemacht sind. Gescheiterte Todeswürfe werden zurückgesetzt, wenn du überlebst.</p><p><strong>Weiterer Schaden:</strong> Erleidest du bei null TP zusätzlichen Schaden, zählt das automatisch als gescheiterter Todeswurf.</p>'),
    ('aufrappeln', 'Aufrappeln', 'Überzeugen', NULL, NULL, NULL, '<p>Ein anderer Spielercharakter in bis zu 10 Metern Entfernung und in Hörweite kann dich per <strong>Überzeugen</strong> aufrappeln, damit du trotz null TP weiterkämpfst. Das zählt als Aktion. Gelingt es, kannst du normal handeln, musst aber weiter Todeswürfe machen. Du kannst auch versuchen, dich selbst aufzurappeln, mit einer WIL-Probe mit Nachteil (statt Überzeugen).</p>'),
    ('leben_retten', 'Leben retten', 'Heilkunde', NULL, NULL, NULL, '<p>Hast du null TP, kann dich eine andere Person neben dir mit einer gelungenen <strong>Heilkunde</strong>-Probe retten (Aktion). Ohne Verbände erhält sie einen Nachteil. Mehrere Versuche sind erlaubt. Gelingt der Wurf, musst du keine Todeswürfe mehr machen und erhältst W6 TP zurück. Du kannst dein eigenes Leben so nicht retten, auch wenn du dich aufgerappelt hast. Weitere Heilkunde-Würfe haben keine Wirkung, sobald du nicht mehr auf null TP bist, außer beim Rasten. Auch Magie kann Leben retten.</p>'),
    ('sofortiger_tod', 'Sofortiger Tod', 'Tod', NULL, NULL, NULL, '<p>Negative TP werden nicht notiert. Senkt aber ein einziger Angriff deine TP auf einen negativen Wert in Höhe deiner vollen TP, stirbt dein Charakter sofort.</p>'),
    ('schwere_verletzungen', 'Schwere Verletzungen', 'KON', NULL, NULL, NULL, '<p>Wurdest du auf null TP gebracht und hast überlebt, riskierst du schwere Verletzungen, die lange heilen und dauerhafte Folgen haben können. Lege eine Probe auf <strong>KON</strong> ab. Scheitert sie, erleidest du eine Verletzung: etwa Nachteile auf bestimmte Attribute und Fertigkeiten, halbierte Bewegung oder dauerhaft gesenkte Fertigkeitswerte. Die Heilzeit halbiert sich, wenn du mindestens einen Tagesabschnitt pro Tag rastest und von jemandem versorgt wirst, der eine Heilkunde-Probe schafft. Dauerhaft gesenkte Fertigkeitswerte kannst du neu erlernen.</p>'),
    ('hunger', 'Hunger', 'Gefahr', NULL, NULL, NULL, '<p>Du musst mindestens eine Ration Essen pro Tag zu dir nehmen. Nach einem Tag ohne Essen bist du ausgehungert und kannst dich nur noch durch Magie von TP, WP oder Zuständen erholen. Du erleidest außerdem einen Schadenspunkt pro Tag. Erreichst du ausgehungert null TP, stirbst du nach einem Tag. Hast du eine Ration gegessen, bist du nicht mehr ausgehungert und heilst normal.</p>'),
    ('schlafentzug', 'Schlafentzug', 'Gefahr', NULL, NULL, NULL, '<p>Du brauchst jeden Tag mindestens eine Schicht ungestörten Schlaf. In Rüstung kannst du nicht schlafen. Nach drei Schichten ohne Schlaf kannst du WP und Zustände nicht mehr heilen (TP normal). Außerdem verlierst du W6 WP pro Schicht, die du wach bleibst. Erreichst du bei Schlafentzug null WP, brichst du zusammen und schläfst mindestens eine Schicht, ohne zu erwachen. Nach einer Schicht Schlaf heilst du WP und Zustände wieder normal.</p>'),
    ('krankheit', 'Krankheit', 'Gefahr', NULL, NULL, NULL, '<p>Setzt du dich einer gefährlichen Krankheit aus, wird eine offene vergleichende Probe zwischen der <strong>Virulenz</strong> der Krankheit und deiner KON gewürfelt. Gewinnst du, widerstehst du. Sonst wirst du nach einem Tag krank: Du erhältst den Zustand Kränkelnd und verlierst W6 TP. Solange du krank bist, kannst du TP, WP oder Zustände nicht heilen. Jeden Tag wird neu gewürfelt, und jeder Fehlschlag verursacht W6 Schaden. Erreichst du krank null TP, stirbst du einen Tag später. Sobald du die vergleichende Probe gewinnst, bist du geheilt.</p><p><strong>Pflege:</strong> Wer dich mit Heilkunde pflegt, kann den Wurf gegen die Virulenz an deiner Stelle ablegen. Ein Kräutersud gibt einen Vorteil.</p>'),
    ('lager_machen', 'Lager machen', 'Wildnisleben', NULL, NULL, NULL, '<p>Die Charaktere müssen mindestens einen Tagesabschnitt pro Tag schlafen, um Schlafentzug zu vermeiden. In der Wildnis muss jeder Spielercharakter eine <strong>Wildnisleben</strong>-Probe ablegen, um einen geeigneten Rastplatz zu finden. Wer keinen Schlafpelz hat, würfelt mit Nachteil. Misslingt die Probe, zählt der Tagesabschnitt nicht als Schlaf und kann auch nicht als Rast über einen Tagesabschnitt genutzt werden.</p><p><strong>Zelt:</strong> Ein Zelt gewährt beim Lagermachen einen Vorteil. Bei Erfolg können mehrere Personen im Zelt schlafen, ohne selbst zu würfeln. Ein kleines Zelt bietet Platz für zwei Personen, ein großes für sechs. Würfelt nur eine Person für das Zelt und misslingt es, können andere Charaktere für denselben Tagesabschnitt einzeln würfeln.</p><p><strong>Wache halten:</strong> Zufallsbegegnungen können jederzeit eintreten. Es kann klug sein, in verschiedenen Tagesabschnitten zu schlafen, damit immer jemand wach ist.</p><p><strong>Gefährliche Orte:</strong> An manchen Orten, etwa in einem Verlies voller Feinde, können die Charaktere weder lagern noch eine Rast über einen Tagesabschnitt einlegen. Sie müssen zuerst den Ort verlassen und einen sichereren suchen.</p>'),
    ('nahrung_in_der_wildnis', 'Nahrung in der Wildnis', 'Tagesabschnitt', NULL, NULL, NULL, '<p>In der Wildnis kann ein Spielercharakter einen Tagesabschnitt mit Jagen, Fischen oder dem Sammeln essbarer Pflanzen verbringen. Währenddessen kommt er auf der Karte nicht voran.</p><p><strong>Jagen:</strong> Du brauchst eine Fernkampfwaffe oder eine Jagdfalle. Zuerst legst du eine Probe auf <strong>Jagen &amp; Fischen</strong> ab, um ein Tier aufzuspüren. Gelingt sie, bestimmt die Jagdtabelle (unter Tabellen), um welches Tier es sich handelt. Das Töten erfordert einen zweiten Wurf, mit der Waffe oder mit Jagen &amp; Fischen bei einer Falle. Manche Tiere lassen sich nicht mit einer Falle fangen. Die Tabelle zeigt, wie viele Rationen das Tier liefert.</p><p><strong>Fischen:</strong> Du brauchst Angelzeug und eine Probe auf Jagen &amp; Fischen. Bei Erfolg fängst du W4 Rationen mit der Angel oder W6 Rationen mit einem Fischernetz.</p><p><strong>Sammeln:</strong> Lege eine Wildnisleben-Probe ab, im Winter mit Nachteil, im Herbst mit Vorteil. Bei Erfolg findest du W3 Rationen essbarer Pilze, Wurzeln und anderer Pflanzen.</p><p><strong>Kochen:</strong> Wer rohen Fisch oder rohes Fleisch isst, riskiert Krankheit: Es wird gegen Virulenz 10 gewürfelt. Pflanzen kann man roh essen, aber zwei Rationen roher Pflanzen decken nur den Tagesbedarf von einer Ration. Das Kochen von bis zu zehn Rationen dauert einen Tagesabschnitt und erfordert eine gelungene Wildnisleben-Probe, sonst gilt das Essen als ungekocht. Eine Feldküche gibt einen Vorteil auf die Probe, ebenso eine richtige Küche, in der man beliebig viel kochen kann. Siehe auch die Heldenfähigkeit Meisterkoch.</p>'),
    ('reiten_im_kampf', 'Reiten im Kampf', 'Reiten', NULL, NULL, NULL, '<p>Ein treues Pferd oder ein anderes Reittier ist ein großer Vorteil. Alle Spielercharaktere können aufsteigen und langsam reiten. Anspruchsvollere Manöver erfordern eine <strong>Reiten</strong>-Probe.</p><ul>
            <li><strong>Satteltaschen:</strong> Die Ausrüstungslisten nennen, wie viel das Tier tragen kann.</li>
            <li><strong>Bewegung:</strong> Beritten reist du doppelt so schnell wie zu Fuß, etwa 30 Kilometer pro Schicht.</li>
            <li><strong>Kampf:</strong> Das Reittier muss kampfgeschult sein. Du nutzt seine Bewegungsrate statt deiner. Alle Angriffe und Paraden verwenden den <em>niedrigeren</em> Wert aus Reiten und Waffenfertigkeit. Reiten ersetzt Ausweichen. Ohne Sattel erhalten alle Würfe einen Nachteil. Feinde müssen wählen, ob sie dich oder dein Reittier angreifen. Nahkampfangriffe vom Boden aus gegen dich haben einen Nachteil.</li>
            <li><strong>Schaden:</strong> Reittiere heilen TP wie Spielercharaktere. Bei null TP macht ein Reittier keine Todeswürfe, es stirbt.</li>
        </ul>'),
    ('traglast', 'Traglast', 'STÄ', NULL, NULL, NULL, '<p>Du kannst so viele Gegenstände im Inventar mitführen, wie die Hälfte deiner <strong>STÄ</strong> beträgt (aufgerundet). Nur Gegenstände, die auf deinem Inventarbogen stehen, zählen zur Traglast.</p><ul><li><strong>Griffbereite Waffen:</strong> bis zu drei, auf dem Bogen unter Waffen eingetragen, zählen nicht zur Traglast. Schilde zählen als Waffen.</li><li><strong>Helm &amp; Rüstung:</strong> was du am Körper trägst, hat einen eigenen Abschnitt und zählt nicht.</li><li><strong>Nahrung:</strong> bis zu vier Rationen zählen als ein Gegenstand. Notiere immer, wie viele Rationen du noch hast.</li><li><strong>Fackeln &amp; Laternen:</strong> Fackel, Lampe und Laterne zählen je als ein Gegenstand. Ihr Feuer kann ausgehen, Lampen und Laternen lassen sich mit Lampenöl nachfüllen.</li><li><strong>Pfeile &amp; Schleudersteine:</strong> Du musst nicht jeden Pfeil zählen, jeder Köcher zählt als ein Gegenstand. Solange du den Köcher hast, kannst du deine Waffe benutzen. Schleudersteine musst du gar nicht notieren.</li><li><strong>Rucksack:</strong> erhöht deine Traglast um 2, zählt selbst nicht zur Traglast, und du kannst immer nur einen Rucksack tragen.</li></ul>'),
    ('schwere_gegenstaende', 'Schwere Gegenstände', 'Gewicht', NULL, NULL, NULL, '<p>Wirklich schwere Gegenstände zählen als zwei, drei oder mehr gewöhnliche Gegenstände. Das steht als <strong>Gewicht</strong> beim Gegenstand. Im Inventar belegen sie so viele Zeilen, wie ihr Gewicht beträgt. Ist kein Gewicht angegeben, beträgt es immer 1.</p>'),
    ('kleinkram_muenzen', 'Kleinkram & Münzen', 'Gewicht 0', NULL, NULL, NULL, '<p>Kleine, leichte Gegenstände, die sich in einer geschlossenen Faust verstecken lassen, heißen <strong>Kleinkram</strong>. Sie wirken sich nicht auf deine Traglast aus und stehen im eigenen Abschnitt Kleinkram auf dem Bogen. Das Memento ist immer Kleinkram.</p><p><strong>Münzen:</strong> Einzelne Münzen sind Kleinkram, solange es weniger als 100 sind. 100 bis 199 Münzen zählen als ein Gegenstand, 200 bis 299 als zwei, und so weiter.</p>'),
    ('ueberladen', 'Überladen', 'STÄ', NULL, NULL, NULL, '<p>Du kannst zeitweise mehr tragen als deine Traglast. Dann musst du jedes Mal eine <strong>STÄ</strong>-Probe ablegen, wenn du dich in einer Kampfrunde bewegen oder während einer Reise einen Tagesabschnitt gehen willst. Misslingt sie, musst du Gegenstände ablegen oder bleibst stehen.</p><p><strong>Andere tragen:</strong> Wer eine andere Person trägt, gilt automatisch als überladen und kann nicht kämpfen.</p>'),
    ('reittiere_fahrzeuge', 'Reittiere & Fahrzeuge', 'Tragkraft', NULL, NULL, NULL, '<p>Mit einem Pferd oder anderen Reittier kann das Tier deine Ausrüstung tragen. Wagen und Boote tragen noch schwerere Lasten. Ihre Tragkraft steht unter Ausrüstung bei den Fahrzeugen und Tieren.</p>'),
    ('runden_initiative_ziehen', 'Runden & Initiative ziehen', 'Runde', NULL, NULL, NULL, '<p>Ein Kampf läuft in <strong>Runden</strong> ab, jede dauert etwa zehn Sekunden. Zu Beginn jeder Runde wird die Initiative gezogen: Jeder Beteiligte zieht eine zufällige Karte von 1 bis 10. Die Zahl bestimmt, wann du in der Runde dran bist (1 zuerst, dann 2 usw.). Diese Position heißt dein <strong>Zug</strong>. Haben alle gehandelt, beginnt die Runde neu mit frischer Initiative.</p>'),
    ('ueberraschung', 'Überraschung', 'Runde 1', NULL, NULL, NULL, '<p>Führst du einen überraschenden Angriff aus, darfst du dir in der ersten Kampfrunde eine beliebige Initiativkarte aussuchen. Greifen mehrere Charaktere überraschend an, dürfen alle wählen. Die übrigen Kämpfenden ziehen aus den verbleibenden Karten. Ab der zweiten Runde wird wie üblich gezogen.</p>'),
    ('warten', 'Warten', 'Initiative', NULL, NULL, NULL, '<p>In deinem Zug kannst du <strong>warten</strong>: Du tauschst deine Initiativkarte mit einem anderen Wesen, das nach dir an der Reihe wäre. Das Gegenüber darf den Tausch nicht ablehnen. Du kannst nicht mit jemandem tauschen, der schon dran war oder selbst gewartet hat. Monster warten nie.</p>'),
    ('initiativkarte_umdrehen', 'Initiativkarte umdrehen', 'Reaktion', NULL, NULL, NULL, '<p>Hattest du deinen Zug, drehst du deine Karte um. So ist für alle klar, dass du in dieser Runde keine Reaktion (etwa Parieren oder Ausweichen) mehr ausführen kannst.</p>'),
    ('zug_bewegung_und_aktion', 'Zug: Bewegung und Aktion', 'Zug', NULL, NULL, NULL, '<p>In deinem Zug kannst du dich <strong>bewegen</strong> und <strong>eine Aktion</strong> ausführen. Du schilderst, wie du dich bewegst und was du tun willst; falls nötig wird gewürfelt. Du darfst dich vor oder nach der Aktion bewegen oder die Bewegung aufteilen. Beides muss in deinem Zug geschehen und kann nicht aufgespart werden (außer durch Warten).</p>'),
    ('moegliche_aktionen', 'Mögliche Aktionen', 'Aktion', NULL, NULL, NULL, '<ul>
            <li><strong>Sprinten:</strong> verdoppelt deine Bewegungsrate in dieser Runde.</li>
            <li><strong>Nahkampfangriff:</strong> gegen Feinde innerhalb von 2 Metern (4 Meter bei langen Waffen).</li>
            <li><strong>Fernkampfangriff:</strong> gegen Ziele innerhalb der Waffenreichweite.</li>
            <li><strong>Parieren / Ausweichen:</strong> Reaktionen im Zug des Gegners, die deinen eigenen Zug ersetzen.</li>
            <li><strong>Gegenstand aufheben:</strong> vom Boden innerhalb von 2 Metern oder aus dem Inventar.</li>
            <li><strong>Rüstung / Helm an- oder ablegen:</strong> Rüstungen schützen, schränken aber die Bewegung ein.</li>
            <li><strong>Erste Hilfe:</strong> eine Heilkunde-Probe rettet jemanden, dessen TP auf null gesunken sind.</li>
            <li><strong>Aufrappeln:</strong> einen Mitstreiter mit null TP per Überzeugen zum Weiterkämpfen bewegen.</li>
            <li><strong>Tür aufbrechen:</strong> Türen halten eine bestimmte Menge Schaden aus.</li>
            <li><strong>Schloss knacken:</strong> Fingerfertigkeit; ohne Dietriche mit Nachteil.</li>
            <li><strong>Gegenstand benutzen:</strong> etwa einen Trank oder anderen Gegenstand in 2 Metern Reichweite.</li>
            <li><strong>Fähigkeit aktivieren:</strong> angeborene oder Heldenfähigkeit.</li>
            <li><strong>Zauber wirken:</strong> meist eine Aktion. Manche Zauber sind Reaktionen, andere dauern länger.</li>
            <li><strong>Helfen:</strong> gibt einem anderen in derselben Runde einen Vorteil auf dessen Wurf.</li>
            <li><strong>Verschnaufen:</strong> W6 WP zurückholen, nur einmal pro Tagesabschnitt.</li>
        </ul>'),
    ('freie_aktionen', 'Freie Aktionen', 'gratis', NULL, NULL, NULL, '<p>Kleinigkeiten kosten keine Aktion, aber nur in deinem eigenen Zug und nur <strong>eine pro Art</strong> und Runde (du kannst dich also hinwerfen <em>oder</em> aufstehen, nicht beides):</p><ul>
            <li><strong>Waffe ziehen:</strong> ziehen, tauschen oder wegstecken (eine Waffe in Griffweite).</li>
            <li><strong>Position wechseln:</strong> zu Boden werfen oder aufstehen.</li>
            <li><strong>Gegenstand fallen lassen.</strong></li>
            <li><strong>Rufen:</strong> ein paar Worte sagen.</li>
        </ul>'),
    ('reaktionen', 'Reaktionen', 'Reaktion', NULL, NULL, NULL, '<p>Manche Handlungen geschehen nicht im eigenen, sondern im Zug des Gegners, etwa <strong>Parieren</strong> oder <strong>Ausweichen</strong>. Eine Reaktion verbraucht deinen eigenen Zug der Runde: Du kannst sie nicht ausführen, wenn du schon dran warst. Drehe die Initiativkarte nach der Reaktion sofort um. Mit einer Reaktion verlierst du auch deine Bewegung der Runde. Parieren und Ausweichen geben dir dafür eine kleine Bewegung zurück.</p>'),
    ('bewegung_sonderfaelle', 'Bewegung: Sonderfälle', 'Bewegung', NULL, NULL, NULL, '<p>Normalerweise bewegst du dich so viele Meter wie deine Bewegungsrate. Besonderheiten:</p><ul>
            <li><strong>Sprinten:</strong> doppelte Strecke.</li>
            <li><strong>Hinwerfen / Aufstehen:</strong> freie Aktionen, die deine Bewegung nicht verändern.</li>
            <li><strong>Springen:</strong> waagerecht bis zur halben Bewegungsrate mit gelungener Akrobatik-Probe. Bis zu einem Viertel brauchst du keinen Wurf.</li>
            <li><strong>Tür:</strong> eine geschlossene, aber nicht verschlossene Tür zu passieren kostet die halbe Bewegung. Verschlossene Türen müssen geknackt oder aufgebrochen werden.</li>
            <li><strong>Feinde:</strong> an einem stehenden Feind, der dich aufhalten will, kommst du nicht vorbei. Ein menschengroßes Wesen blockiert etwa 2×2 Meter, Monster mehr. Du musst ihn zu Boden bringen oder seine TP auf null senken. Freunde darfst du passieren.</li>
        </ul>'),
    ('freier_angriff', 'Freier Angriff', 'Ausweichen', NULL, NULL, NULL, '<p>Stehst du innerhalb von 2 Metern eines Feindes und bewegst dich freiwillig von ihm weg, musst du eine <strong>Ausweichen</strong>-Probe ablegen. Sie zählt nicht als Aktion. Scheitert sie, erhält der Feind sofort einen zusätzlichen Nahkampfangriff gegen dich, den <strong>Freien Angriff</strong>. Er kostet ihn keine Aktion und kann weder pariert noch ausgewichen werden. Ein Monster führt dabei einen Monsterangriff aus, der auch andere treffen kann.</p><p>Der Freie Angriff entsteht auch, wenn du aus der Distanz startest, aber an einem Feind vorbeiläufst. Wer sich <em>um</em> einen Feind herum bewegt und innerhalb von 2 Metern bleibt, löst ihn nicht aus. Unfreiwillige Bewegung löst nie einen Freien Angriff aus.</p>'),
    ('heimlicher_angriff', 'Heimlicher Angriff', 'Heimlichkeit', NULL, NULL, NULL, '<p>Schleichst du dich an jemand Ahnungslosen heran und greifst an, ist das ein <strong>heimlicher Angriff</strong>. Er geht mit Nah- und Fernkampfwaffen, aber nie im offenen Kampf (außer mit der Heldenfähigkeit Meuchler).</p><p>Zuerst legst du eine <strong>Heimlichkeit</strong>-Probe ab. Nah genug für den Nahkampf heranzukommen (bei den meisten Waffen innerhalb von 2 Metern) gibt einen Nachteil. Scheitert die Probe, bemerkt dich der Feind und die Initiative wird gezogen. Gelingt sie, gilt dein Angriff als überraschend: Du wählst deine Initiativkarte, erhältst einen <strong>Vorteil</strong> auf den Angriff, und das Ziel kann weder ausweichen noch parieren. Eine <em>unauffällige</em> Waffe verursacht eine Würfelstufe mehr Schaden (z. B. 2W8 statt 2W6). Heimliche Angriffe führt immer ein einzelner Angreifer gegen ein Ziel aus.</p>'),
    ('hinterhalt', 'Hinterhalt', 'Wahrnehmung', NULL, NULL, NULL, '<p>Ein <strong>Hinterhalt</strong> ist ein heimlicher Angriff aus dem Verborgenen auf einen Feind, der vorbeikommt. Jedes Opfer legt eine <strong>Wahrnehmung</strong>-Probe ab, um ihn zu bemerken (mit Nachteil, wenn die Angreifer gut vorbereitet sind). Wer scheitert, bekommt die untersten Karten (ab 10 aufwärts), zufällig gezogen.</p>'),
    ('kampfkarten', 'Kampfkarten', 'Raster', NULL, NULL, NULL, '<p>Mit einem Raster behaltet ihr den Überblick: Jedes Feld ist etwa 2×2 Meter groß. Türen, Wände und Aufstiege werden eingezeichnet. In der Regel steht nur ein Wesen pro Feld, aber du darfst ein Feld mit einem verbündeten Kämpfer durchqueren. Diagonale Bewegung und Angriffe sind erlaubt, nicht aber, wenn beide Felder, zwischen denen du dich bewegst, von Feinden blockiert oder besetzt sind. Wer 5×5-Fuß-Felder gewohnt ist, nutzt sie einfach als 2×2 Meter.</p>'),
    ('gelaende', 'Gelände', 'Gelände', NULL, NULL, NULL, '<ul>
            <li><strong>Beengt:</strong> wenig Platz oder niedrige Decke. Alle Nahkampfwaffen außer Stichwaffen und <em>unauffälligen</em> Waffen erhalten einen Nachteil auf alle Würfe.</li>
            <li><strong>Unwegsam:</strong> schwer begehbar. Bei jeder Bewegung musst du eine Akrobatik-Probe ablegen (keine Aktion). Bei Misserfolg fällst du hin und verlierst den Rest deiner Bewegung.</li>
            <li><strong>Schwach beleuchtet:</strong> Nachteil auf alle Fernkampfangriffe.</li>
        </ul>'),
    ('nahkampfangriff', 'Nahkampfangriff', 'Nahkampf', NULL, NULL, NULL, '<p>Für einen Nahkampfangriff musst du in der Regel innerhalb von 2 Metern des Ziels stehen (auf dem Raster auf einem angrenzenden Feld, auch diagonal). Du würfelst auf die Fertigkeit, die zu deiner Waffe gehört. Bei einem Treffer bestimmt die Waffe den Schadenswürfel. Der Schaden wird durch Schadensbonus und Drachenwurf erhöht und durch Rüstung gesenkt.</p>'),
    ('schadensbonus_welcher_gilt', 'Schadensbonus: welcher gilt?', 'STÄ / GEW', 'berry', 'Schadensbonus STÄ GEW Waffenfertigkeit Fernkampf Wurfwaffen Armbrust', NULL, '<p>Dein Schadensbonus hängt an dem Attribut, auf dem die <strong>Waffenfertigkeit</strong> basiert. Es gibt zwei Boni, einen für STÄ und einen für GEW; beide stehen auf deinem Charakterbogen.</p><p><strong>STÄ-Waffen:</strong> [[STA_SKILLS]].</p><p><strong>GEW-Waffen:</strong> [[GEW_SKILLS]].</p><p>Fernkampfwaffen bekommen den gleichen Bonus wie im Nahkampf, Armbrüste ausgenommen: Sie geben keinen Schadensbonus. Wurfwaffen wie Messer oder Speere nutzen die Fertigkeit der Nahkampfwaffe und damit deren Bonus.</p>'),
    ('voraussetzung_staerke', 'Voraussetzung Stärke', 'STA', NULL, 'Voraussetzung Stärke STA Nachteil Waffe', NULL, '<p>Die Spalte „STA“ in der Waffenliste ist die <strong>Voraussetzung</strong>, kein Bonus. Ist deine Stärke niedriger, greifst und parierst du mit Nachteil. Liegt sie unter der Hälfte der Voraussetzung, kannst du die Waffe gar nicht einsetzen. Führst du eine Einhandwaffe mit beiden Händen, sinkt die Voraussetzung um 3.</p>'),
    ('waffen_griff', 'Waffen & Griff', 'Waffen', NULL, NULL, NULL, '<p>Du kannst bis zu <strong>drei Waffen in Griffweite</strong> haben (auf dem Charakterbogen eintragen). Zum Angreifen muss die Waffe gezogen sein. Ziehen oder Tauschen einer Waffe in Griffweite ist eine freie Aktion, eine Waffe vom Boden oder aus dem Inventar aufzunehmen kostet eine Aktion.</p><p>Waffen brauchen eine oder zwei Hände. Gleichzeitig gezogen sein dürfen nur eine Zweihandwaffe oder zwei Einhandwaffen (ein Schild zählt mit).</p>'),
    ('lange_waffen', 'Lange Waffen', 'Reichweite', NULL, NULL, NULL, '<p>Ein Angriff mit einer Waffe mit dem Merkmal <em>lang</em> (z. B. langer Speer oder Lanze) trifft Feinde bis 4 Meter entfernt (zwei Felder). Damit kannst du auch an einem verbündeten Kämpfer vorbei einen Feind dahinter treffen.</p>'),
    ('liegende_ziele', 'Liegende Ziele', 'Vorteil', NULL, NULL, NULL, '<p>Stehst du und dein Feind liegt am Boden, erhält dein Angriff einen Vorteil und verursacht zusätzlich W6 Schaden.</p>'),
    ('kritischer_treffer_nahkampf', 'Kritischer Treffer (Nahkampf)', 'Drache', 'gold', 'Kritischer Treffer Drache Schaden verdoppeln Schadensbonus Rüstung ignorieren zweiter Angriff', NULL, '<p>Würfelst du beim Angriff einen Drachen, ist es ein <strong>kritischer Treffer</strong>: Gegen ihn hilft Parieren oder Ausweichen nur mit einem eigenen Drachenwurf. Du wählst eine der Wirkungen:</p><ul><li><strong>Doppelte Würfel:</strong> Du verdoppelst die Würfel der Waffe, den Schadensbonus aber nicht. Beispiel: Ein Breitschwert (2W6) mit Schadensbonus W4 richtet 4W6 + W4 an.</li><li><strong>Zweiter Angriff:</strong> Du führst sofort einen weiteren Angriff gegen einen anderen Feind aus, als freie Aktion.</li><li><strong>Rüstung ignoriert:</strong> Die Rüstung schützt nicht, du findest eine Lücke. Nur wählbar, wenn der Angriff Stichschaden verursacht (optionale Regel).</li></ul>'),
    ('schadensarten', 'Schadensarten', 'Optional', NULL, NULL, NULL, '<p>Es gibt drei Schadensarten: <strong>Hieb</strong>, <strong>Stich</strong> und <strong>Wucht</strong>. Die Art steht in der Waffenliste. Manche Waffen (etwa Schwerter) können Hieb- und Stichschaden verursachen. Sag vor dem Wurf an, ob du stichst oder schlägst. Die Schadensart beeinflusst die Wirkung von Rüstung, und Monster können gegen bestimmte Arten resistent sein.</p>'),
    ('wegstossen', 'Wegstoßen', 'STÄ', NULL, NULL, NULL, '<p>Triffst du mit einem Nahkampfangriff und ist dein STÄ-Schadensbonus mindestens so hoch wie der des Gegners, darfst du ihn zusätzlich zum Schaden bis zu 2 Meter in beliebige Richtung stoßen (auf ein angrenzendes Feld). Die Bewegung zählt nicht zu seiner Gesamtbewegung der Runde und löst keine Freien Angriffe aus. Monster können weder wegstoßen noch weggestoßen werden.</p>'),
    ('daemon_beim_angriff', 'Dämon beim Angriff', 'Dämon', NULL, NULL, NULL, '<p>Würfelst du bei einem Angriff einen Dämon, triffst du nicht und kannst den Wurf nicht strapazieren. Zusätzlich kann dir ein Missgeschick passieren (W6):</p><p><strong>Nahkampf</strong></p><ul>
            <li><strong>1:</strong> Du lässt die Waffe fallen. Aufheben kostet eine Aktion.</li>
            <li><strong>2:</strong> Du gibst dir eine Blöße. Der Gegner erhält einen Freien Angriff, der weder ausgewichen noch pariert werden kann.</li>
            <li><strong>3:</strong> Die Waffe bleibt stecken. Befreien kostet eine Aktion und gelingt mit einer STÄ-Probe.</li>
            <li><strong>4:</strong> Du schleuderst die Waffe W3+3 Meter weit weg. Du musst dich bewegen und dann eine Aktion zum Aufheben aufwenden.</li>
            <li><strong>5:</strong> Die Waffe wird beschädigt. Jeder Einsatz geht mit Nachteil, bis ein Handwerker sie repariert.</li>
            <li><strong>6:</strong> Du triffst dich selbst. Schaden wie üblich, aber ohne Schadensbonus.</li>
        </ul><p><strong>Fernkampf</strong></p><ul>
            <li><strong>1:</strong> Du lässt die Waffe fallen. Aufheben kostet eine Aktion.</li>
            <li><strong>2:</strong> Dir gehen die Pfeile aus, du musst neue besorgen. Bei Schleudern und Wurfwaffen würfelst du stattdessen neu.</li>
            <li><strong>3:</strong> Du triffst einen wertvollen oder wichtigen Gegenstand in der Nähe.</li>
            <li><strong>4:</strong> Die Waffe zerbricht. Jeder Einsatz geht mit Nachteil, bis ein Handwerker sie repariert.</li>
            <li><strong>5:</strong> Du triffst einen Mitstreiter in der Nähe. Schaden wie üblich, mit Schadensbonus.</li>
            <li><strong>6:</strong> Du triffst dich selbst. Schaden wie üblich, aber ohne Schadensbonus.</li>
        </ul>'),
    ('unbelebte_objekte', 'Unbelebte Objekte', 'Schaden', NULL, NULL, NULL, '<p>Triffst du einen leblosen Gegenstand wie eine Tür oder ein Schloss, gelingt der Treffer automatisch. Du würfelst nur den Schaden. Leblose Objekte besitzen oft einen Rüstungswert.</p>'),
    ('parieren', 'Parieren', 'Reaktion', NULL, NULL, NULL, '<p>Wirst du im Nahkampf getroffen, kannst du mit einer <strong>gezogenen</strong> Waffe oder einem Schild parieren. Eine Waffe zum Parieren zu ziehen geht nicht, denn freie Aktionen sind nur im eigenen Zug möglich. Du musst das Parieren ansagen, <em>bevor</em> der Angreifer den Schaden würfelt. Du kannst nicht unbewaffnet parieren und nicht denselben Angriff parieren <em>und</em> ausweichen. Parieren ist auch im Liegen möglich. Du würfelst auf deinen Fertigkeitswert der Waffe.</p>
            <ul>
                <li><strong>Reaktion:</strong> Parieren ersetzt deinen Zug, die Initiativkarte wird sofort umgedreht. Wer schon dran war, kann nicht parieren (außer mit der Heldenfähigkeit Defensiv).</li>
                <li><strong>Haltbarkeit:</strong> Gelingt die Parade, trifft der Angriff deine Waffe oder dein Schild, und du erleidest keinen Schaden. Übersteigt der Schaden die Haltbarkeit, ist die Waffe beschädigt und unbrauchbar, bis sie mit einer Handwerk-Probe repariert wird.</li>
                <li><strong>Schild:</strong> Dafür gibt es keine eigene Fertigkeit. Du nutzt jede STÄ-basierte Nahkampffertigkeit außer Messer und Stäbe.</li>
                <li><strong>Stichschaden:</strong> Stichangriffe können nie eine parierende Waffe oder ein Schild beschädigen.</li>
                <li><strong>Monster:</strong> Monsterangriffe können in der Regel nicht pariert werden, sofern nicht anders angegeben.</li>
            </ul>'),
    ('drache_beim_parieren', 'Drache beim Parieren', 'Drache', NULL, NULL, NULL, '<p>Würfelst du beim Parieren einen Drachen, führst du sofort einen <strong>Gegenangriff</strong> gegen den Angreifer aus, einen automatischen Treffer mit deiner Waffe, der weder ausgewichen noch pariert werden kann. Das gilt nicht, wenn auch der Angreifer einen Drachen gewürfelt hat. Dann brauchst du den Drachen allein fürs Parieren und erhältst keinen Gegenangriff.</p>'),
    ('paradebewegung', 'Paradebewegung', 'Bewegung', NULL, NULL, NULL, '<p>Nach einer gelungenen Parade kannst du dich selbst und den Angreifer um 2 Meter (ein Feld) in beliebige Richtung bewegen. Die Bewegung zählt nicht zur Gesamtbewegung und löst keine Freien Angriffe aus.</p>'),
    ('ausweichen', 'Ausweichen', 'Reaktion', NULL, NULL, NULL, '<p>Alternativ zum Parieren kannst du einem Angriff ausweichen. Du kannst nicht denselben Angriff parieren und ausweichen. Ausweichen ist auch im Liegen möglich. Sag es an, bevor der Gegner den Schaden würfelt, und würfle auf <strong>Ausweichen</strong>. Gelingt der Wurf, weichst du aus und erleidest keinen Schaden, sonst wirst du getroffen.</p><ul>
            <li><strong>Reaktion:</strong> wie beim Parieren ersetzt Ausweichen deinen Zug, die Initiativkarte wird umgedreht.</li>
            <li><strong>Bewegung:</strong> Bei Erfolg darfst du dich bis zu 2 Meter in beliebige Richtung bewegen, ohne Freie Angriffe auszulösen.</li>
            <li><strong>Monster:</strong> Monsterangriffe können in der Regel ausgewichen werden, sofern nicht anders angegeben.</li>
        </ul>'),
    ('schwachstelle_finden', 'Schwachstelle finden', 'Stich', NULL, NULL, NULL, '<p>Mit einer Stichwaffe suchst du eine Lücke in Rüstung oder natürlicher Panzerung. Du erhältst einen Nachteil auf den Angriff, aber bei einem Treffer gilt der Feind als ungerüstet.</p>'),
    ('zu_boden_werfen', 'Zu Boden werfen', 'Vergleichend', NULL, NULL, NULL, '<p>Statt Schaden zu verursachen, versuchst du, den Feind umzuwerfen. Das ist eine vergleichende Probe zwischen deiner Waffenfertigkeit und seinem <strong>Ausweichen</strong>. Hat die Waffe das Merkmal <em>Umwerfen</em>, erhältst du einen Vorteil. Der Angriff zählt für dich als Aktion, nicht für den Gegner, und kann nicht pariert oder ausgewichen werden. Nutzvoll im Team: Ein Freund greift den liegenden Feind an, bevor er aufsteht.</p>'),
    ('entwaffnen', 'Entwaffnen', 'Vergleichend', NULL, NULL, NULL, '<p>Du versuchst, dem Gegner die Waffe zu entreißen. Vergleichende Probe zwischen deiner und seiner Waffenfertigkeit. Der Angriff zählt als Aktion für dich, nicht für ihn, und kann nicht pariert oder ausgewichen werden. Hält er die Waffe mit beiden Händen, erhältst du einen Nachteil. Gelingt es, landet die Waffe W6 Meter entfernt in einer Richtung deiner Wahl. Das Aufheben ist eine Aktion. Gegen Schilde und natürliche Waffen wirkt Entwaffnen nicht.</p>'),
    ('umklammern', 'Umklammern', 'Prügelei', NULL, NULL, NULL, '<p>Du versuchst, einen humanoiden Gegner zu umklammern. Vergleichende Probe zwischen deiner <strong>Prügelei</strong> und seiner. Der Angriff zählt für dich als Aktion, nicht für ihn, und kann nicht pariert oder ausgewichen werden. Scheitert er, fällst du zu Boden. Gelingt er, fallt ihr beide, und der Feind steckt in deinem Griff.</p><p>Solange du ihn hältst, kann er sich weder bewegen noch Aktionen ausführen, die Körperbewegung erfordern, außer es zu versuchen, sich zu befreien: eine vergleichende Prügelei-Probe, die für ihn eine freie Aktion ist (für dich nicht). Während du hältst, kannst du dich selbst weder bewegen noch Aktionen mit Körperbewegung ausführen, außer <em>brechen</em>: ein unbewaffneter Angriff mit Vorteil, der weder ausgewichen noch pariert werden kann. Den Gegner loszulassen ist eine freie Aktion.</p>'),
    ('taktik_im_nahkampf', 'Taktik im Nahkampf', 'Tipp', NULL, NULL, NULL, '<p>Deine wertvollste Ressource sind deine Aktionen: Du hast nur eine pro Runde, Reaktionen eingeschlossen. Greift die Gruppe gemeinsam an, lohnt es sich, einen Gegner zu fokussieren, da er nur einmal parieren oder ausweichen kann. Gegen einen gleich starken Feind kann es klug sein zu warten: Verfehlt sein Angriff, musst du nicht parieren und kannst selbst angreifen, während er sich nicht schützen kann. Dafür gibst du ihm die Initiative. Die Heldenfähigkeiten Defensiv und Blitzschnell helfen hier.</p>'),
    ('fernkampfangriff', 'Fernkampfangriff', 'Fernkampf', NULL, NULL, NULL, '<p>Die Waffe muss gezogen sein (freie Aktion). Du solltest mehr als 2 Meter vom Ziel entfernt stehen, also <em>nicht</em> auf einem angrenzenden Feld. Bei 2 Metern oder weniger erhältst du einen Nachteil. Du würfelst auf die Fertigkeit der Waffe. Wurfwaffen nutzen dieselbe Fertigkeit wie im Nahkampf (z. B. Messer oder Speere). Bei einem Treffer bestimmt die Waffe den Schaden, erhöht durch Schadensbonus und Drachenwurf, gesenkt durch Rüstung.</p><p><strong>Reichweite:</strong> Jede Waffe hat eine Reichweite in Metern, in der sie effektiv ist. Bis zur doppelten Reichweite darfst du schießen, dann aber mit Nachteil.</p>'),
    ('kritischer_treffer_fernkampf', 'Kritischer Treffer (Fernkampf)', 'Drache', NULL, NULL, NULL, '<p>Ein Drache beim Fernkampfangriff ist ein kritischer Treffer: Er kann nur ausgewichen (oder mit Schild pariert) werden, wenn der Gegner ebenfalls einen Drachen würfelt. Du wählst:</p><ul>
            <li><strong>Doppelter Schaden:</strong> Würfle die Waffenwürfel doppelt (ohne Schadensbonus und andere Boni). Ein kritischer Treffer mit einem Langbogen verursacht 2W12.</li>
            <li><strong>Rüstung ignoriert:</strong> Rüstung und natürliche Panzerung schützen nicht. Nur bei Stichschaden wählbar (optionale Regel).</li>
        </ul>'),
    ('parieren_ausweichen_fernkampf', 'Parieren & Ausweichen (Fernkampf)', 'Schild', NULL, NULL, NULL, '<p>Einen Fernkampfangriff zu parieren erfordert einen <strong>Schild</strong>. Es funktioniert wie im Nahkampf, nur gibt ein Drache keinen Gegenangriff. Ausweichen geht wie im Nahkampf.</p>'),
    ('verdeckte_ziele', 'Verdeckte Ziele', 'Nachteil', NULL, NULL, NULL, '<p>Ist deine Sicht auf das Ziel teilweise durch ein Hindernis oder eine Person (auch Freund) verdeckt, erhältst du einen Nachteil. Auf dem Raster kannst du an einer Person zwischen dir und dem Ziel vorbei schießen, ebenfalls mit Nachteil. Ist das Ziel völlig außer Sicht (etwa hinter einer Wand), kannst du es nicht beschießen.</p>'),
    ('ruestung_helme', 'Rüstung & Helme', 'Rüstungswert', NULL, NULL, NULL, '<p>Lederrüstung, Kettenhemd oder Plattenpanzer schützen vor Schaden. Rüstung an- oder abzulegen kostet eine Aktion. Du kannst nur eine Rüstung gleichzeitig tragen, sie zählt nicht zur Traglast. Manche Rüstungen geben Nachteile auf bestimmte Fertigkeiten oder schränken die Bewegung ein.</p><p><strong>Rüstungswert:</strong> Bei körperlichem Schaden ziehst du den Rüstungswert vom Schaden ab. Wird der Schaden eines Nahkampfangriffs komplett aufgehoben, nimmt stattdessen die angreifende Waffe den Schaden und kann dabei beschädigt werden.</p><p><strong>Helme:</strong> Sie lassen sich mit der Rüstung kombinieren und erhöhen den Rüstungswert. Auf- und Absetzen kostet eine Aktion. Helme können Nachteile auf bestimmte Fertigkeiten geben.</p>'),
    ('schadensarten_ruestung', 'Schadensarten & Rüstung', 'Optional', NULL, NULL, NULL, '<p>Gilt, wenn die optionale Regel für Schadensarten verwendet wird: Leder und Nietenleder geben +2 Rüstungswert gegen Wucht. Kettenhemd gibt +2 gegen Hieb. Ist die Schadensart nicht angegeben, wirkt die Rüstung normal.</p>'),
    ('improvisierte_waffen', 'Improvisierte Waffen', 'Umgebung', NULL, NULL, NULL, '<p>Die Umgebung lässt sich im Kampf nutzen: als Waffe, Deckung oder zur Fortbewegung. Improvisierte Waffen sind normalerweise nur <strong>einmal</strong> verwendbar und danach verbraucht. Ihr Einsatz ist eine Aktion und lässt sich mit Bewegung kombinieren.</p><p>Pro Kampf stehen meist nur wenige solcher Gegenstände zur Verfügung. Was in der Umgebung herumliegt, siehst du an der Szene.</p>'),
    ('zauber_wirken', 'Zauber wirken', 'WP', NULL, NULL, NULL, '<p>Um einen Zauber zu wirken, gibst du Willenskraftpunkte (WP) aus und legst eine Probe auf deine Fertigkeit in der jeweiligen Schule ab. Gelingt sie, entfaltet der Zauber seine Wirkung wie beschrieben, sonst hat er keine. Du kannst den Wurf strapazieren, falls diese optionale Regel verwendet wird.</p><p>Du besitzt keine Fertigkeitsstufen für einzelne Zauber, nur für die Schule. Entweder du kennst einen Zauber oder nicht. Du behältst die Zauber im Gedächtnis oder in deinem Zauberbuch.</p>'),
    ('kraftstufe', 'Kraftstufe', 'WP', NULL, NULL, NULL, '<p>Die Kraftstufe gibt an, wie viel Macht du einem Zauber verleihst. Sie reicht von 1 bis 3. Das Wirken kostet <strong>2 WP je Kraftstufe</strong>, normale Zauber also immer mindestens 2 WP. Manche Zauber kennen keine Kraftstufen und kosten immer 2 WP.</p>'),
    ('zaubertricks', 'Zaubertricks', 'WP', NULL, NULL, NULL, '<p>Zaubertricks sind schwache, vergleichsweise harmlose Zauber. Sie kosten 1 WP und gelingen automatisch, brauchen im Kampf aber dennoch eine Aktion.</p>'),
    ('komponenten', 'Komponenten', 'Vorgabe', NULL, NULL, NULL, '<p>Für einen Zauber brauchst du die in seiner Beschreibung genannten Komponenten, und er wirkt erst, wenn alle vorhanden sind: <strong>Wort</strong> (Gesang oder Wort der Macht), <strong>Geste</strong> (bestimmte Handbewegung), <strong>Fokus</strong> (ein Gegenstand in der Hand, etwa Stab, Kristallkugel oder Amulett) und <strong>Zutaten</strong> (ein Material, das dabei verbraucht wird).</p>'),
    ('zauberdauer', 'Zauberdauer', 'Aktion', NULL, NULL, NULL, '<p>Soweit nicht anders angegeben, ist das Wirken im Kampf eine Aktion. Reaktionszauber wirkst du außerhalb deines Zuges, sie ersetzen aber im Gegensatz zu Parieren und Ausweichen nicht deine Aktionen der Runde. Du kannst so viele wirken, wie du willst, solange deine WP reichen.</p>'),
    ('reichweite_wirkungsbereich', 'Reichweite & Wirkungsbereich', 'Reichweite', NULL, NULL, NULL, '<p>Zauber wirken nicht über ihre Reichweite hinaus. Flächenzaubern kann man weder ausweichen noch sie parieren, außer es steht anders da. Der Wirkungsbereich ist, wenn nicht anders angegeben, kreisförmig mit dem Zaubernden als Mittelpunkt. Du kannst Ziele vom Bereich ausnehmen, erleidest dabei aber einen Nachteil auf den Wurf. <strong>Kugel:</strong> alle Ziele im Bereich außer dem Zaubernden. <strong>Kegel:</strong> ein Bereich, dessen Breite an jedem Punkt der Entfernung zur Quelle entspricht, die Reichweite ist die Länge.</p>'),
    ('wirkungsdauer', 'Wirkungsdauer', 'Dauer', NULL, NULL, NULL, '<p><strong>Sofort:</strong> setzt sofort ein und hält nicht an. <strong>Runde:</strong> bis du in der nächsten Runde wieder am Zug bist. <strong>Viertel:</strong> ein Viertel lang. <strong>Tagesabschnitt:</strong> bis der laufende Tagesabschnitt endet. <strong>Konzentration:</strong> endet, wenn du eine andere Aktion durchführst, Schaden erleidest oder eine WIL-Probe gegen Furcht misslingt. Bei einer plötzlichen Störung, etwa einem Geräusch, brauchst du eine WIL-Probe (keine Aktion), um die Konzentration zu halten.</p>'),
    ('fehlschlag_drache_und_daemon', 'Fehlschlag, Drache und Dämon', 'Probe', NULL, NULL, NULL, '<p>Misslingt die Probe, hat der Zauber keine Wirkung, aber du gibst die WP trotzdem aus. Du darfst erzählen, wie sich der Fehlschlag auswirkt, solange es keinen spieltechnischen Effekt hat.</p><p><strong>Drache:</strong> Dein Ziel muss ebenfalls einen Drachen werfen, um dem Zauber zu widerstehen, ihn zu parieren oder ihm auszuweichen. Außerdem wählst du einen Effekt: Schaden oder Reichweite werden verdoppelt, der Zauber kostet keine WP oder du wirkst sofort einen weiteren Zauber (mit Nachteil auf die Probe).</p><p><strong>Dämon:</strong> Du kannst den Wurf nicht strapazieren. Für diesen Fall gibt es die Tabelle Magische Patzer unter Tabellen.</p>'),
    ('magie_lernen', 'Magie lernen', 'Lehrer & Grimoire', NULL, NULL, NULL, '<p>Neue Zauber lernst du von einem Lehrer oder aus einem Grimoire. Du brauchst dafür einen Fertigkeitswert in der betreffenden Magieschule (oder in irgendeiner Schule bei allgemeiner Magie).</p><p><strong>Voraussetzungen:</strong> Manche Zauber haben eine Voraussetzung, meist eine Magieschule oder die Kenntnis eines anderen Zaubers.</p><p><strong>Lehrer:</strong> Der einfachste (aber oft teuerste) Weg. Die Unterweisung dauert einen Tagesabschnitt, du kannst den neuen Zauber aber erst nach Ende der Spielsitzung einsetzen. Dann musst du eine Steigerungsmarke der Schule einsetzen, um den Zauber zu lernen, statt die Fertigkeit zu steigern, und legst eine <strong>INT</strong>-Probe mit Vorteil ab. Bei Erfolg lernst du den Zauber, sonst nicht.</p><p><strong>Grimoire:</strong> Mit Glück findest du Zauber in den Grimoires anderer Magier. Du lernst sie wie bei einem Lehrer, würfelst aber auf <strong>Fremdsprachen</strong> statt auf INT, ohne Vorteil.</p><p><strong>Zaubertricks:</strong> Sie sind leichter zu lernen. Von einem Lehrer oder aus einem Grimoire dauert es ein Viertel, ohne Steigerungsmarke und ohne Wurf.</p><p><strong>Magieschulen:</strong> Eine weitere Schule lernst du, indem du zuerst die Heldenfähigkeit Magisches Talent erwirbst und dann mindestens eine Woche bei einem Lehrer mit Fertigkeitswert in der Schule studierst. Am Ende der Woche legst du eine INT-Probe ab. Gelingt sie, erhältst du den Basiswert (INT) als Fertigkeitswert der Schule, sonst kannst du es nach einer weiteren Woche wieder versuchen. Auch Nichtmagier können Magie so lernen.</p>'),
    ('skill_marks', 'Steigerungsmarken', 'Fertigkeit', NULL, NULL, 'Das Kästchen markierst du, wenn du bei der Fertigkeit einen Drachen (1) oder Dämon (20) gewürfelt hast, oder nach den Fragen am Sitzungsende. Beim Level-up darfst du markierte Fertigkeiten steigern.', '<p>Hast du beim Einsatz einer Fertigkeit einen <strong>Drachen</strong> (1) oder <strong>Dämon</strong> (20) gewürfelt, hake das Kästchen neben der Fertigkeit ab. Weitere Marken gibt es nach den Fragen am Sitzungsende. Nur markierte Fertigkeiten dürfen gesteigert werden.</p>'),
    ('session_end_questions', 'Sitzungsende: Steigerungsmarken', 'Regel', NULL, NULL, NULL, '<p>Am Ende der Spielsitzung stellt die Spielleitung die folgenden Fragen. Antwortet ein Spieler mit „Ja“ und kann es begründen, darf er eine weitere Marke bei einer unmarkierten Fertigkeit seiner Wahl setzen. Die Spielleitung hat das letzte Wort, sollte aber großzügig sein. (Marken, die schon im Spiel durch einen Drachen oder Dämon entstanden sind, kommen dazu.)</p><ul><li>Hast du an der Spielsitzung teilgenommen?</li><li>Hast du einen neuen Ort erkundet?</li><li>Hast du einen oder mehrere gefährliche Gegner besiegt?</li><li>Hast du ein Hindernis ohne Gewalt überwunden?</li><li>Hast du deiner Schwäche nachgegeben (optionale Regel)?</li></ul>'),
    ('advancement_roll', 'Steigerungswürfe', 'Fertigkeit', NULL, NULL, 'Würfle am Tisch für jede Marke einen W20. Liegt das Ergebnis <strong>über</strong> dem aktuellen Fertigkeitswert, steigt die Fertigkeit um eins (höchstens bis 18): dann „Steigern“, sonst „Verwerfen“. Die Marke ist danach in beiden Fällen gelöscht.', '<p>Nach dem Setzen der Marken würfelst du für jede Marke einen W20. Liegt das Ergebnis <strong>über</strong> deinem aktuellen Fertigkeitswert, steigt die Fertigkeit um eins, bis höchstens 18. Danach löschst du die Marken und beginnst in der nächsten Spielsitzung neu.</p>'),
    ('lehrer', 'Lehrer', 'Dienst', NULL, NULL, NULL, '<p>Ein Tagesabschnitt intensiven Trainings bei einem Lehrer, dessen Fertigkeitswert mindestens 15 beträgt und über deinem eigenen liegt, gibt dir einen zusätzlichen Steigerungswurf. Du würfelst sofort, ohne das Spielsitzungsende abzuwarten. Ein Lehrer kann eine Fertigkeit nur um <strong>eins</strong> anheben. Danach musst du die Fertigkeit erst durch Erfahrung verbessern, bevor du wieder Hilfe von einem Lehrer bekommen kannst. Lehrer, besonders mit hohem Wert, sind meist sehr teuer (siehe Dienste unter Items).</p>'),
    ('magie_steigern', 'Magie steigern', 'Magie', NULL, NULL, NULL, '<p>Eine Magieschule, die du schon kennst, lässt sich wie jede andere Fertigkeit verbessern. Neue Zauber und neue Magieschulen erfordern jedoch besonderes Training (siehe Zauber, Magie lernen).</p>'),
    ('neue_heldenfaehigkeiten', 'Neue Heldenfähigkeiten', 'Heldentalent', NULL, NULL, NULL, '<p>Du kannst im Spiel auf zwei Wegen neue Heldenfähigkeiten erhalten:</p><ul><li>Steigerst du eine Fertigkeit auf 18, erhältst du sofort eine neue Heldenfähigkeit deiner Wahl. Sinkt die Fertigkeit später unter 18, behältst du die Fähigkeit und erhältst eine weitere, wenn sie wieder auf 18 steigt.</li><li>Nach einer großen Heldentat können die SL oder das Abenteuer dir eine Heldenfähigkeit schenken. Das sollte ein seltenes Ereignis sein, nie öfter als einmal pro Abenteuer von üblicher Länge.</li></ul><p>Um eine neue Heldenfähigkeit zu erhalten, musst du ihre Voraussetzung an Fertigkeiten erfüllen.</p>'),
    ('schwaeche_ueberwinden', 'Schwäche überwinden', 'Optional', NULL, NULL, NULL, '<p>Handelst du während der Sitzung eindeutig gegen deine Schwäche, erhältst du zwei Steigerungsmarken (statt einer fürs Nachgeben). Du hast deine Schwäche damit überwunden und musst sie streichen. Danach musst du eine ganze Sitzung ohne Schwäche spielen, dann darfst du eine neue wählen, am besten eine, die sich aus dem Spiel ergeben hat.</p>'),
    ('die_rolle_der_spielleitung', 'Die Rolle der Spielleitung', 'Tipps', NULL, NULL, NULL, '<p>Als SL beschreibst du, was die Charaktere sehen, wem sie begegnen und welche Herausforderungen warten. Wie die Regie eines Films setzt du die Szene und trägst viel zu einer guten Geschichte bei. Die Rolle kann auch unter allen Mitgliedern der Gruppe wechseln.</p><p><strong>Alle einbinden:</strong> Achte darauf, dass sich alle einbezogen fühlen. Bekommt eine Figur viel Aufmerksamkeit, gib den anderen auch Rampenlicht. Achte aufs Tempo: Streue ruhigere Szenen zwischen intensive Ereignisse. Wird das Spiel zäh und die Spielenden langweilen sich, lass etwas Aufregendes geschehen, das sie zum Reagieren zwingt.</p><p><strong>Offen würfeln:</strong> Die SL würfelt oft für NSC und Monster. Es ist verlockend, heimlich zu würfeln, um das Drama zu steuern, aber wir empfehlen, immer offen zu würfeln. Das bindet alle ein und erhöht die Spannung am Tisch.</p><p><strong>Mit den Spielenden spielen:</strong> Du kontrollierst alle Gegner und Gefahren, aber ihr spielt zusammen, nicht gegeneinander. Setzen die Spielenden einen cleveren Plan erfolgreich um, lass sie sich gut fühlen und freu dich, gemeinsam Geschichten und bleibende Erinnerungen zu erschaffen.</p><p><strong>Die Welt zum Leben erwecken:</strong> Male ein Bild einer echten Welt mit Details, Geräuschen und Gerüchen: die Eulen im nächtlichen Lager, die Frösche im Sumpf, das Rascheln der Blätter im Wind. Ein oder zwei Details reichen oft, damit eine Szene oder ein Ort lebendig wird.</p>'),
    ('nsc_verwalten', 'NSC verwalten', 'NSC', NULL, NULL, NULL, '<p>Mechanisch funktionieren NSC wie Spielercharaktere: Sie bewegen sich, führen Aktionen aus, erleiden Schaden und nutzen WP. In der Praxis solltest du alle Regeln für NSC ignorieren, die keinen Spielercharakter direkt betreffen. Würfle nicht für Aktionen von NSC, es sei denn, sie greifen einen Spielercharakter an oder heilen ihn. Du <em>kannst</em> in anderen Situationen würfeln, wenn es das Drama verstärkt. Gegen eine nicht aufgeführte Fertigkeit würfelt der NSC auf den Standardwert 5.</p>'),
    ('gefolge_bosse', 'Gefolge & Bosse', 'NSC', NULL, NULL, NULL, '<p>NSC lassen sich in zwei Gruppen teilen:</p><p><strong>Gefolge</strong> sind Gruppen weniger bedeutender NSC mit identischen Werten. Sie haben selten Namen oder Persönlichkeit. Ein Gefolgsmitglied mit null TP ist tot, außer die SL möchte, dass es überlebt, etwa um den Charakteren mit letzten Worten etwas Wichtiges zu sagen. Gefolge nutzt fast nie WP und handelt oft im selben Zug.</p><p><strong>Bosse</strong> sind anders: Sie haben oft Namen und Hintergrund und spielen meist eine wichtige Rolle im Abenteuer. Ein Boss zieht eine eigene Initiativkarte, hat WP und nutzt angeborene und Heldenfähigkeiten wie Spielercharaktere. Besonders mächtige Bosse haben oft mehrere Heldenfähigkeiten, nicht zuletzt Robust und Fokussiert mehrfach, was ihnen weit mehr TP und WP als den Spielercharakteren gibt. Lass Bosse nach Möglichkeit nicht zu früh sterben: Ein Boss, der überlebt, um ein andermal zu kämpfen, macht mehr Spaß als ein toter. Sorge auch dafür, dass die Charaktere nicht zu leicht an den Boss herankommen, etwa durch Gefolge, das zuerst erledigt werden muss. Ein Bosskampf sollte herausfordernd sein.</p>'),
    ('nsc_und_fertigkeiten', 'NSC und Fertigkeiten', 'Regel', NULL, NULL, NULL, '<p>NSC nutzen Fertigkeiten wie Spielercharaktere. Die SL würfelt für sie, aber nur für Aktionen, die einen Spielercharakter unmittelbar betreffen, etwa wenn der NSC einen Spielercharakter angreift oder heilt. Bei Aktionen ohne direkten Einfluss entscheidet die SL einfach, was passiert. In den Werten der NSC stehen nicht alle Fertigkeiten: Würfelt die SL gegen eine nicht aufgeführte Fertigkeit, gilt der Standardwert <strong>5</strong>.</p>'),
    ('attribute_fuer_nsc', 'Attribute für NSC', 'NSC', NULL, NULL, NULL, '<p>In Abenteuern stehen für NSC keine Attributswerte, weil sie sehr selten gebraucht werden. Musst du doch einmal gegen einen genauen Attributswert würfeln, nutze diese Richtlinien:</p><ul><li><strong>STÄ &amp; GEW:</strong> Nimm den Schadensbonus. Bei +W6 würfelst du gegen einen Wert von 17, bei +W4 gegen 14, ohne Bonus gegen 10.</li><li><strong>KON:</strong> Würfle gegen die maximalen TP, verringert um 2 je Stufe der Heldenfähigkeit Robust.</li><li><strong>WIL:</strong> Würfle gegen die maximalen WP, falls angegeben, verringert um 2 je Stufe der Heldenfähigkeit Fokussiert. Sind keine WP angegeben, würfle gegen 10.</li><li><strong>INT &amp; CHA:</strong> Würfle gegen 10.</li></ul>'),
    ('typische_nsc', 'Typische NSC', 'Bestiarium', NULL, NULL, NULL, '<p>Werte für typische NSC (Wache, Kultist, Dieb, Dorfbewohner, Jäger, Bandit, Abenteurer, Gelehrter sowie die Bosse Banditenanführer, Ritter-Champion und Erzmagier) stehen im Bestiarium des DM-Bereichs in der Kategorie Alltagsvolk.</p>'),
    ('nsc_erschaffen', 'NSC erschaffen', 'Tabellen', NULL, NULL, NULL, '<p>Mit den Tabellen weiter unten, NSC erschaffen, entsteht schnell ein einzigartiger NSC: Am Tisch würfelst du je einen Würfel jeder Art (W4 Haltung, W6 Volk, W8 Motivation, W10 Beruf, W12 Eigenart, W20 Name, bei dem du einen der drei Namen wählst).</p>'),
    ('nsc_initiative', 'NSC-Initiative', 'Initiative', NULL, NULL, NULL, '<p>Um große Kämpfe zu vereinfachen, kann die Spielleitung eine einzige Karte für eine ganze NSC-Gruppe ziehen. Alle handeln dann im selben Zug, die Reihenfolge untereinander legt die Spielleitung fest. Monster haben oft mehrere Züge pro Runde und ziehen entsprechend mehrere Karten. Bei Überraschung wählt die Spielleitung, ob ein Angriff als überraschend gilt.</p>'),
    ('nsc_bei_besonderen_angriffen', 'NSC bei besonderen Angriffen', 'Vergleichend', NULL, NULL, NULL, '<p>Würfelt die Spielleitung für einen NSC, der die betreffende Fertigkeit nicht hat, würfelt sie gegen den Standardwert 5.</p>'),
    ('nsc_bei_null_tp', 'NSC bei null TP', 'Tod', NULL, NULL, NULL, '<p>Erreicht ein NSC null TP, gibt es keine Todeswürfe. Die Spielleitung entscheidet, ob er lebt oder stirbt. Ein sofort tötender Angriff tötet einen NSC jedoch ebenso wie einen Spielercharakter.</p>'),
    ('improvisierte_waffen_bereitstellen', 'Improvisierte Waffen bereitstellen', 'Umgebung', NULL, NULL, NULL, '<p>Zu Kampfbeginn kann die Spielleitung W3 improvisierte Waffen auswürfeln oder festlegen, ihre Position auf der Karte markieren oder sagen, dass sie überall in der Gegend verfügbar sind. Abenteuer können eigene improvisierte Waffen für einen Ort mitbringen.</p>'),
    ('monster_im_kampf', 'Monster im Kampf', 'Bestiarium', NULL, NULL, NULL, '<p>Ein Monster ist ein Wesen unnatürlichen Ursprungs, eine schreckliche Bestie, die Angst und Schrecken verbreitet. Die Spielleitung steuert Monster im Kampf weitgehend wie Spielercharaktere und NSC, mit einigen wichtigen Unterschieden (siehe unten). Das Bestiarium im Spielleitungsbereich enthält Werte für Monster, humanoide Wesen und gewöhnliche Tiere.</p>'),
    ('grimmigkeit', 'Grimmigkeit', 'Monster', NULL, NULL, NULL, '<p>Manche Monster sind so mächtig, dass sie mehrmals in derselben Runde handeln können. Das zeigt ihr Wert für <strong>Grimmigkeit</strong>. Zu Beginn jeder Runde zieht die Spielleitung für jeden Punkt Grimmigkeit eine Initiativekarte. Das Monster erhält pro Karte einen Zug mit je einer Aktion und einer Bewegung.</p><p><strong>Abwarten:</strong> Tauscht ein Spielercharakter die Initiativekarte mit einem Monster (optionale Regel), darf er sich eine beliebige Karte des Monsters aussuchen. Monster selbst warten nie.</p>'),
    ('groesse', 'Größe', 'Monster', NULL, NULL, NULL, '<p>Die Größe bestimmt, wie viel Fläche ein Monster blockieren kann und durch wie enge Durchgänge es passt.</p><ul>
        <li><strong>Klein:</strong> weniger als einen Meter groß, blockiert keine Fläche und passt durch winzige Durchgänge.</li>
        <li><strong>Normal:</strong> etwa menschengroß, blockiert 2×2 Meter (ein Feld auf der Kampfkarte) und passt durch einen halben Meter breiten Durchgang.</li>
        <li><strong>Groß:</strong> blockiert 4×4 Meter und passt durch einen Meter breiten Durchgang.</li>
        <li><strong>Riesig:</strong> blockiert 8×8 Meter und passt durch einen zwei Meter breiten Durchgang.</li>
        <li><strong>Schwarm:</strong> von Normal bis Riesig, blockiert aber nie die Fläche, in der er sich befindet, und passt durch winzige Durchgänge.</li>
    </ul>'),
    ('monsterbewegung', 'Monsterbewegung', 'Monster', NULL, NULL, NULL, '<p>Wie Spielercharaktere haben Monster eine Bewegungsrate und können sich vor oder nach ihrem Angriff bewegen oder ihre Bewegung davor und danach aufteilen. Bei Monstern gilt die Rate <em>pro Zug</em>, nicht pro Runde. Manche Monster haben unterschiedliche Raten an Land, im Wasser und in der Luft. Starten und Landen sind freie Aktionen.</p>'),
    ('monsterangriffe', 'Monsterangriffe', 'Monster', NULL, NULL, NULL, '<p>Ein Monster greift immer mit einem <strong>Monsterangriff</strong> an. Jedes Monster hat eine eigene Tabelle mit Monsterangriffen. Die Spielleitung wählt in ihrem Zug einen Angriff aus der Tabelle oder bestimmt ihn am Tisch per Wurf. Monster würfeln nie, um ihr Ziel zu treffen: <strong>Monsterangriffe gelingen automatisch.</strong> Ein Monsterangriff zählt als Aktion. Die Reichweite entspricht, sofern nicht anders angegeben, einem Nahkampfangriff (2 Meter).</p><ul>
        <li><strong>Ausweichen &amp; Parieren:</strong> Monsterangriffe können in der Regel ausgewichen, aber nicht pariert werden. Das gilt auch für Angriffe mit Wirkungsbereich, nicht aber für Furchtangriffe. Ausnahmen stehen in der Beschreibung des Angriffs.</li>
        <li><strong>Zustände:</strong> Monsterangriffe können Spielercharakteren Zustände zufügen. Hat der Charakter den Zustand schon, muss der Spieler einen anderen wählen.</li>
        <li><strong>Wiederholte Angriffe:</strong> Ein Monster führt nie zweimal hintereinander denselben Angriff aus. Fällt derselbe Angriff zweimal in Folge, wird er zum nächsten Angriff der Tabelle (aus der 6 wird die 1).</li>
    </ul>'),
    ('gefaehrlichere_monster', 'Gefährlichere Monster', 'Bestiarium', NULL, NULL, NULL, '<p>Die Monster des Bestiariums sind typische Exemplare. Die Spielleitung kann Monster gefährlicher oder harmloser machen, um sie der Kompetenz der Charaktere anzupassen. Am einfachsten erhöht oder senkt man dazu die Grimmigkeit, aber auch die TP lassen sich anpassen.</p>'),
    ('zufallsbegegnungen', 'Zufallsbegegnungen', 'Reise', NULL, NULL, NULL, '<p>Auf Reisen können die Charaktere den seltsamsten Geschöpfen aus nah und fern begegnen, deshalb stehen Zufallsbegegnungen meist im Abenteuer. Einmal pro Tagesabschnitt oder wann immer die SL es für angemessen hält, kann sie auf einer Tabelle für Zufallsbegegnungen würfeln. Die Tabellen hängen vom Gebiet ab. Die SL kann auch eine passende Begegnung wählen oder erfinden. Manche Begegnungen finden sogar nachts oder im Lager statt.</p><p>Wird die Wildnisleben-Probe des Wegführers einer Gruppe fällig und misslingt, folgt ein Reise-Missgeschick (Tabelle weiter unten, Reise &amp; Wildnis).</p>'),
    ('den_abenteuerort_verlassen', 'Den Abenteuerort verlassen', 'Tabelle', NULL, NULL, NULL, '<p>Einen gefährlichen Ort voller Feinde zu verlassen, um zu lagern oder eine Rast über einen Tagesabschnitt zu halten, kann riskant sein. Wenn die Charaktere den Ort für mindestens einen Tagesabschnitt verlassen, wird auf der Tabelle Den Abenteuerort verlassen gewürfelt (weiter unten, Reise &amp; Wildnis). Ergibt das Ergebnis offensichtlich keinen Sinn, wird es ignoriert.</p>');

-- catalog_rule_sections
INSERT INTO catalog_rule_sections (code, title_de, badge_de, intro_de) VALUES
    ('wuerfelproben', 'Würfelproben', 'Regel', NULL),
    ('zustaende', 'Zustände', 'Regel', NULL),
    ('verletzung_tod', 'Verletzung & Tod', 'Regel', NULL),
    ('gefahren_ueberleben', 'Gefahren & Überleben', 'Regel', NULL),
    ('reise_wildnis', 'Reise & Wildnis', 'Regel', NULL),
    ('traglast', 'Traglast', 'Regel', NULL),
    ('ablauf_initiative', 'Ablauf & Initiative', 'Regel', NULL),
    ('aktionen_bewegung', 'Aktionen & Bewegung', 'Regel', NULL),
    ('heimlicher_angriff_hinterhalt', 'Heimlicher Angriff & Hinterhalt', 'Regel', NULL),
    ('gelaende_karten', 'Gelände & Karten', 'Regel', NULL),
    ('nahkampf', 'Nahkampf', 'Regel', NULL),
    ('parieren_ausweichen', 'Parieren & Ausweichen', 'Regel', NULL),
    ('besondere_nahkampfangriffe', 'Besondere Nahkampfangriffe', 'Regel', 'Sag vor dem Wurf an, dass du einen besonderen Angriff verwendest. Viele davon sind vergleichende Proben.'),
    ('fernkampf', 'Fernkampf', 'Regel', NULL),
    ('ruestung_schaden', 'Rüstung & Schaden', 'Regel', NULL),
    ('improvisierte_waffen', 'Improvisierte Waffen', 'Regel', NULL),
    ('magie', 'Magie', 'Regel', NULL),
    ('erfahrung_steigern', 'Erfahrung & Steigern', 'Regel', NULL),
    ('dm_spielleitung', NULL, NULL, NULL),
    ('dm_kampf', NULL, NULL, NULL),
    ('dm_monster', NULL, NULL, NULL),
    ('dm_reise', NULL, NULL, NULL);

-- catalog_rule_placements
INSERT INTO catalog_rule_placements (section_code, rule_code, position, kind) VALUES
    ('wuerfelproben', 'fertigkeitsprobe', 10, 'quick'),
    ('wuerfelproben', 'dragon', 20, 'quick'),
    ('wuerfelproben', 'demon', 30, 'quick'),
    ('wuerfelproben', 'attributsprobe', 40, 'quick'),
    ('wuerfelproben', 'nur_eine_chance', 50, 'quick'),
    ('wuerfelproben', 'vorteil_nachteil', 60, 'quick'),
    ('wuerfelproben', 'hilfe_von_anderen', 70, 'quick'),
    ('wuerfelproben', 'den_wurf_strapazieren', 80, 'quick'),
    ('wuerfelproben', 'vergleichende_probe', 90, 'quick'),
    ('wuerfelproben', 'offene_vergleichende_probe', 100, 'quick'),
    ('zustaende', 'die_sechs_zustaende', 110, 'quick'),
    ('zustaende', 'zustand_erleiden', 120, 'quick'),
    ('verletzung_tod', 'death_rolls', 130, 'quick'),
    ('verletzung_tod', 'aufrappeln', 140, 'quick'),
    ('verletzung_tod', 'leben_retten', 150, 'quick'),
    ('verletzung_tod', 'sofortiger_tod', 160, 'quick'),
    ('verletzung_tod', 'schwere_verletzungen', 170, 'quick'),
    ('gefahren_ueberleben', 'hunger', 180, 'quick'),
    ('gefahren_ueberleben', 'schlafentzug', 190, 'quick'),
    ('gefahren_ueberleben', 'krankheit', 200, 'quick'),
    ('reise_wildnis', 'lager_machen', 210, 'quick'),
    ('reise_wildnis', 'nahrung_in_der_wildnis', 220, 'quick'),
    ('reise_wildnis', 'reiten_im_kampf', 230, 'quick'),
    ('traglast', 'traglast', 240, 'quick'),
    ('traglast', 'schwere_gegenstaende', 250, 'quick'),
    ('traglast', 'kleinkram_muenzen', 260, 'quick'),
    ('traglast', 'ueberladen', 270, 'quick'),
    ('traglast', 'reittiere_fahrzeuge', 280, 'quick'),
    ('ablauf_initiative', 'runden_initiative_ziehen', 290, 'quick'),
    ('ablauf_initiative', 'ueberraschung', 300, 'quick'),
    ('ablauf_initiative', 'warten', 310, 'quick'),
    ('ablauf_initiative', 'initiativkarte_umdrehen', 320, 'quick'),
    ('aktionen_bewegung', 'zug_bewegung_und_aktion', 330, 'quick'),
    ('aktionen_bewegung', 'moegliche_aktionen', 340, 'quick'),
    ('aktionen_bewegung', 'freie_aktionen', 350, 'quick'),
    ('aktionen_bewegung', 'reaktionen', 360, 'quick'),
    ('aktionen_bewegung', 'bewegung_sonderfaelle', 370, 'quick'),
    ('aktionen_bewegung', 'freier_angriff', 380, 'quick'),
    ('heimlicher_angriff_hinterhalt', 'heimlicher_angriff', 390, 'quick'),
    ('heimlicher_angriff_hinterhalt', 'hinterhalt', 400, 'quick'),
    ('gelaende_karten', 'kampfkarten', 410, 'quick'),
    ('gelaende_karten', 'gelaende', 420, 'quick'),
    ('nahkampf', 'nahkampfangriff', 430, 'quick'),
    ('nahkampf', 'schadensbonus_welcher_gilt', 440, 'entry'),
    ('nahkampf', 'voraussetzung_staerke', 450, 'entry'),
    ('nahkampf', 'waffen_griff', 460, 'quick'),
    ('nahkampf', 'lange_waffen', 470, 'quick'),
    ('nahkampf', 'liegende_ziele', 480, 'quick'),
    ('nahkampf', 'kritischer_treffer_nahkampf', 490, 'entry'),
    ('nahkampf', 'schadensarten', 500, 'quick'),
    ('nahkampf', 'wegstossen', 510, 'quick'),
    ('nahkampf', 'daemon_beim_angriff', 520, 'quick'),
    ('nahkampf', 'unbelebte_objekte', 530, 'quick'),
    ('parieren_ausweichen', 'parieren', 540, 'quick'),
    ('parieren_ausweichen', 'drache_beim_parieren', 550, 'quick'),
    ('parieren_ausweichen', 'paradebewegung', 560, 'quick'),
    ('parieren_ausweichen', 'ausweichen', 570, 'quick'),
    ('besondere_nahkampfangriffe', 'schwachstelle_finden', 580, 'quick'),
    ('besondere_nahkampfangriffe', 'zu_boden_werfen', 590, 'quick'),
    ('besondere_nahkampfangriffe', 'entwaffnen', 600, 'quick'),
    ('besondere_nahkampfangriffe', 'umklammern', 610, 'quick'),
    ('besondere_nahkampfangriffe', 'taktik_im_nahkampf', 620, 'quick'),
    ('fernkampf', 'fernkampfangriff', 630, 'quick'),
    ('fernkampf', 'kritischer_treffer_fernkampf', 640, 'quick'),
    ('fernkampf', 'parieren_ausweichen_fernkampf', 650, 'quick'),
    ('fernkampf', 'verdeckte_ziele', 660, 'quick'),
    ('ruestung_schaden', 'ruestung_helme', 670, 'quick'),
    ('ruestung_schaden', 'schadensarten_ruestung', 680, 'quick'),
    ('improvisierte_waffen', 'improvisierte_waffen', 690, 'quick'),
    ('magie', 'zauber_wirken', 700, 'quick'),
    ('magie', 'kraftstufe', 710, 'quick'),
    ('magie', 'zaubertricks', 720, 'quick'),
    ('magie', 'komponenten', 730, 'quick'),
    ('magie', 'zauberdauer', 740, 'quick'),
    ('magie', 'reichweite_wirkungsbereich', 750, 'quick'),
    ('magie', 'wirkungsdauer', 760, 'quick'),
    ('magie', 'fehlschlag_drache_und_daemon', 770, 'quick'),
    ('magie', 'magie_lernen', 780, 'quick'),
    ('erfahrung_steigern', 'skill_marks', 790, 'quick'),
    ('erfahrung_steigern', 'session_end_questions', 800, 'quick'),
    ('erfahrung_steigern', 'advancement_roll', 810, 'quick'),
    ('erfahrung_steigern', 'lehrer', 820, 'quick'),
    ('erfahrung_steigern', 'magie_steigern', 830, 'quick'),
    ('erfahrung_steigern', 'neue_heldenfaehigkeiten', 840, 'quick'),
    ('erfahrung_steigern', 'schwaeche_ueberwinden', 850, 'quick'),
    ('dm_spielleitung', 'die_rolle_der_spielleitung', 10, 'dm'),
    ('dm_spielleitung', 'nsc_verwalten', 20, 'dm'),
    ('dm_spielleitung', 'gefolge_bosse', 30, 'dm'),
    ('dm_spielleitung', 'nsc_und_fertigkeiten', 40, 'dm'),
    ('dm_spielleitung', 'attribute_fuer_nsc', 50, 'dm'),
    ('dm_spielleitung', 'typische_nsc', 60, 'dm'),
    ('dm_spielleitung', 'nsc_erschaffen', 70, 'dm'),
    ('dm_spielleitung', 'session_end_questions', 80, 'dm'),
    ('dm_kampf', 'nsc_initiative', 90, 'dm'),
    ('dm_kampf', 'nsc_bei_besonderen_angriffen', 100, 'dm'),
    ('dm_kampf', 'nsc_bei_null_tp', 110, 'dm'),
    ('dm_kampf', 'improvisierte_waffen_bereitstellen', 120, 'dm'),
    ('dm_monster', 'monster_im_kampf', 130, 'quick'),
    ('dm_monster', 'grimmigkeit', 140, 'quick'),
    ('dm_monster', 'groesse', 150, 'quick'),
    ('dm_monster', 'monsterbewegung', 160, 'quick'),
    ('dm_monster', 'monsterangriffe', 170, 'quick'),
    ('dm_monster', 'gefaehrlichere_monster', 180, 'dm'),
    ('dm_reise', 'zufallsbegegnungen', 190, 'quick'),
    ('dm_reise', 'den_abenteuerort_verlassen', 200, 'dm');

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
UPDATE catalog_items SET weight = 2 WHERE name_de IN ('Fass', 'Feldküche', 'Vorschlaghammer', 'Zelt, klein', 'Fischernetz', 'Harfe');
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
