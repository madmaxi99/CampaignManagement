SET NAMES utf8mb4;

-- The four Elementalism summon spells (Gnom/Erde, Salamander/Feuer, Sylphe/Luft,
-- Undine/Wasser), rank 3 each. Stats transcribed from docs/bilder/ (Dragonbane
-- core rulebook, Chapter 5 - Magic, Elementalism). Each elemental's HP/damage
-- scale with the caster's power level ("pro Kraftstufe"/"per power level"),
-- so the stat block lives in the spell text rather than a fixed-stat monster
-- row -- these aren't independent bestiary entries, they're spell effects.

INSERT INTO catalog_spells (name_de, type, rank, school_id, components_de, casting_time_code, range_de, duration_code, wp_note_de, effect_de) VALUES
    ('Gnom', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste, Zutat (Stein oder Erde)', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe',
        'Voraussetzung: Steinwall. Du beschwörst einen Erdelementar. Der Gnom nimmt die Gestalt eines Humanoiden aus grau-braunem Sand und Lehm an und gilt im Kampf als Monster. Er folgt den Befehlen seines Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 8, TP: 5 pro Kraftstufe, Rüstung: 4.\nWaffe – Steinfäuste: Trifft automatisch im Nahkampf (kann pariert oder ausgewichen werden) und verursacht 1W6 Wuchtschaden pro Kraftstufe.\nPfeiler: Der Gnom kann Pfeiler mit derselben Kraftstufe wirken, mit der er beschworen wurde, unter Verwendung der WP des Magiers.'),
    ('Salamander', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste, Zutat (offenes Feuer)', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe',
        'Voraussetzung: Feuerstoß. Du beschwörst einen Feuerelementar. Der Salamander nimmt die Gestalt einer feurigen Echse an und gilt im Kampf als Monster. Er folgt den Befehlen seines Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 12, TP: 5 pro Kraftstufe, Rüstung: —.\nWaffe – Feuriger Griff: Trifft automatisch im Nahkampf (kann pariert oder ausgewichen werden) und verursacht 1W6 Schaden pro Kraftstufe; Rüstung hat keine Wirkung.\nFeuerkugel: Der Salamander kann Feuerstoß mit derselben Kraftstufe wirken, mit der er beschworen wurde, unter Verwendung der WP des Magiers.\nResistenz: Stichschaden wird halbiert.\nImmunität: Der Salamander ist immun gegen Feuerschaden, auch magisches.'),
    ('Sylphe', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe',
        'Voraussetzung: Wirbelwind. Du beschwörst einen Luftelementar. Die Sylphe erscheint als sturmwolkenartiges Wesen in Vogelgestalt und gilt im Kampf als Monster. Sie folgt den Befehlen ihres Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 24, TP: 5 pro Kraftstufe, Rüstung: —.\nWaffe – Heulende Winde: Trifft automatisch im Nahkampf (kann nur ausgewichen, nicht pariert werden), schleudert das Ziel 1W4 m pro Kraftstufe zurück und verursacht denselben Wuchtschaden.\nWindstoß: Die Sylphe kann Windstoß mit derselben Kraftstufe wirken, mit der sie beschworen wurde, unter Verwendung der WP des Magiers.\nResistenz: Stichschaden wird halbiert.'),
    ('Undine', 'spell', 3,
        (SELECT id FROM catalog_schools WHERE skill_id = (SELECT id FROM catalog_skills WHERE name_de = 'Elementarismus')),
        'Wort, Geste, Zutat (Wasser)', 'viertel', '4 m', 'viertel', '2 WP je Kraftstufe',
        'Voraussetzung: Flutwelle. Du beschwörst einen Wasserelementar. Die Undine erscheint wie eine Gezeitenwelle in Gestalt einer Frau, vollständig aus Wasser bestehend, und gilt im Kampf als Monster. Sie folgt den Befehlen ihres Beschwörers, agiert eigenständig mit eigener Initiative (freie Aktion), muss aber in Sichtweite des Magiers bleiben.\n\nBewegung: 12, TP: 5 pro Kraftstufe, Rüstung: —.\nWaffe – Nasse Umarmung: Trifft automatisch im Nahkampf (kann nur ausgewichen, nicht pariert werden) und verursacht 1W6 Schaden pro Kraftstufe; Rüstung hat keine Wirkung.\nFlutwelle: Die Undine kann Flutwelle mit derselben Kraftstufe wirken, mit der sie beschworen wurde, unter Verwendung der WP des Magiers.\nResistenz: Stichschaden wird halbiert.');
