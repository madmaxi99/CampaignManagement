SET NAMES utf8mb4;

-- Corrects the melee/ranged weapon and armor stats seeded by the earlier
-- catalog files against the real tables in docs/bilder/ (Chapter 2 -
-- Equipment): several wrong prices, a couple of wrong damage dice,
-- wrong/missing traits, and STR requirements that weren't tracked at all.
-- Must run after every seed file that creates catalog_item_weapons/
-- catalog_item_armor rows (see provisioning/docker-compose.yml mount order).
-- See migrate_item_stats_fix.sql for the live-DB version of this same fix.

-- ============================================================
-- Weapons
-- ============================================================

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 2, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 7, w.range_de = 'STR', w.damage_de = '2W6', w.durability = 9,
    w.traits_de = 'Niederwerfend, Hieb, kann geworfen werden'
    WHERE i.name_de = 'Beil';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 12, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 10
    WHERE i.name_de = 'Breitschwert';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 1, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = NULL, w.range_de = 'STR', w.durability = 9,
    w.traits_de = 'Unauffällig, Stich, Hieb, kann geworfen werden'
    WHERE i.name_de = 'Dolch';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 5, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 10, w.range_de = 'STR',
    w.traits_de = 'Niederwerfend, Stich, kann geworfen werden'
    WHERE i.name_de = 'Dreizack';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 16, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 13, w.damage_de = '2W8', w.durability = NULL,
    w.traits_de = 'Wucht, Niederwerfend, kann nicht zum Parieren verwendet werden'
    WHERE i.name_de = 'Dreschflegel';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 7, w.traits_de = 'Stich, benötigt Köcher, kein Schadensbonus'
    WHERE i.name_de = 'Handarmbrust';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 13, w.traits_de = 'Lang, Niederwerfend, Stich, Hieb'
    WHERE i.name_de = 'Hellebarde';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 7
    WHERE i.name_de = 'Keule';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 10, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 10, w.durability = 12, w.traits_de = 'Wucht, Niederwerfend'
    WHERE i.name_de = 'Kriegshammer, klein';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 16
    WHERE i.name_de = 'Kriegshammer, schwer';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 10, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 10, w.traits_de = 'Niederwerfend, Hieb'
    WHERE i.name_de = 'Krummsäbel';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 25, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 7
    WHERE i.name_de = 'Kurzbogen';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 8, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 7
    WHERE i.name_de = 'Kurzschwert';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 0, i.price_silver = 5, i.price_copper = 0,
    w.str_requirement = 7, w.range_de = 'STR×2', w.traits_de = 'Stich, kann geworfen werden'
    WHERE i.name_de = 'Kurzspeer';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 50, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 13, w.traits_de = 'Stich, benötigt Köcher, kein Schadensbonus'
    WHERE i.name_de = 'Langbogen';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 25, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 13, w.damage_de = '2W8', w.durability = 15
    WHERE i.name_de = 'Langschwert';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 1, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 10
    WHERE i.name_de = 'Langspeer';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 12, i.price_silver = 0, i.price_copper = 0,
    w.grip_de = '1-händig', w.str_requirement = 13, w.damage_de = '2W10', w.durability = 12
    WHERE i.name_de = 'Lanze';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 75, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 7, w.damage_de = '2W6', w.traits_de = 'Stich, benötigt Köcher, kein Schadensbonus'
    WHERE i.name_de = 'Leichte Armbrust';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 0, i.price_silver = 5, i.price_copper = 0,
    w.str_requirement = NULL, w.range_de = 'STR', w.traits_de = 'Unauffällig, Stich, kann geworfen werden'
    WHERE i.name_de = 'Messer';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 13, w.traits_de = 'Wucht'
    WHERE i.name_de = 'Morgenstern';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = NULL
    WHERE i.name_de = 'Parierdolch';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 13
    WHERE i.name_de = 'Schild, groß';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 4, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 7
    WHERE i.name_de = 'Schild, klein';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 0, i.price_silver = 1, i.price_copper = 0,
    w.str_requirement = NULL, w.durability = NULL, w.traits_de = 'Wucht, kleiner Gegenstand'
    WHERE i.name_de = 'Schleuder';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    w.str_requirement = 13, w.traits_de = 'Stich, benötigt Köcher, kein Schadensbonus'
    WHERE i.name_de = 'Schwere Armbrust';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 0, i.price_silver = 2, i.price_copper = 0,
    w.str_requirement = 7, w.traits_de = 'Wucht, Niederwerfend'
    WHERE i.name_de = 'Stab';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 10, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 13, w.traits_de = 'Niederwerfend, Hieb'
    WHERE i.name_de = 'Streitaxt';

UPDATE catalog_items i JOIN catalog_item_weapons w ON w.item_id = i.id SET
    i.price_gold = 25, i.price_silver = 0, i.price_copper = 0,
    w.str_requirement = 16
    WHERE i.name_de = 'Zweihandaxt';

-- ============================================================
-- Armor
-- ============================================================

UPDATE catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id SET
    a.armor_value = 1, i.price_gold = 2, i.price_silver = 0, i.price_copper = 0,
    a.penalty_stealth = 0, a.penalty_evasion = 0, a.penalty_acrobatics = 0
    WHERE i.name_de = 'Lederrüstung';

UPDATE catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id SET
    i.price_gold = 10, i.price_silver = 0, i.price_copper = 0,
    a.penalty_stealth = 1, a.penalty_evasion = 0, a.penalty_acrobatics = 0
    WHERE i.name_de = 'Beschlagenes Leder';

UPDATE catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id SET
    i.price_gold = 50, i.price_silver = 0, i.price_copper = 0,
    a.penalty_stealth = 1, a.penalty_evasion = 1, a.penalty_acrobatics = 0
    WHERE i.name_de = 'Kettenpanzer';

UPDATE catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id SET
    i.price_gold = 500, i.price_silver = 0, i.price_copper = 0
    WHERE i.name_de = 'Plattenpanzer';

UPDATE catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id SET
    i.price_gold = 12, i.price_silver = 0, i.price_copper = 0,
    a.penalty_perception = 1, a.penalty_ranged = 0
    WHERE i.name_de = 'Offener Helm';

UPDATE catalog_items i JOIN catalog_item_armor a ON a.item_id = i.id SET
    i.price_gold = 100, i.price_silver = 0, i.price_copper = 0,
    a.penalty_perception = 1, a.penalty_ranged = 1
    WHERE i.name_de = 'Großhelm';
