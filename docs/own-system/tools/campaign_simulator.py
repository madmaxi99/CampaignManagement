#!/usr/bin/env python3
"""
Probekampagne-Simulator, Vollregel-Version: 10 feste Encounter mit echten
Kreaturen aus 16-katalog-bestiarium.md, inkl. Bane/Boon, Waffen-Sonderboni,
Kin-Traits, Monster-Moves (Utility + 1x/Kampf-Ultimate) und Mana-Erschoepfung
bei Zauberwirkern. Alles, was zum Kampf selbst gehoert -- absichtlich AUSSER
Positionierung/Reichweite, Flucht und Parley (die drei sind laut 03-kampf.md
erzaehlerisch/nicht mechanisch, bzw. hier schlicht nicht simulierbar).

Was NEU dazugekommen ist gegenueber der vorherigen Version:
  - Mana-Pool pro Caster-PC (4 + hoeherer INT-/WIS-Mod, siehe 14-katalog-
    zauber.md). Pro Zug wird der teuerste noch bezahlbare bekannte Rang
    gewirkt; ist der Pool leer, faellt der Caster auf seine Nahwaffe zurueck
    (Cantrips sind reine Utility-Magie, kein Schadens-Fallback -- final,
    14-katalog-zauber.md), meist ungeuebt und damit mit Bane (siehe unten).
    Pool wird -- wie HP -- zwischen Encountern zurueckgesetzt (Annahme: genug
    erzaehlte Zeit fuer Erholung zwischen den Kaempfen, siehe campaign_
    simulator-Docstring unten).
  - Waffenkunde/Ruestungskunde pro Profession (13-katalog-skills.md): ohne
    Waffenkunde fuer die gefuehrte Waffe -> Bane auf den Angriffswurf (Schaden
    bei Treffer unveraendert). Ohne Ruestungskunde bei Mittel/Schwer -> der
    Ruestungs-AC-Bonus wird nicht realisiert (nur 10+DEX-Mod).
  - Kin pro PC (zufaellig aus den 9 Kin). Nur die 4 kampfrelevanten Traits
    wirken sich hier aus: Ork (Kampfrausch), Goblin (Schwarmgeist), Halbling
    (Kaum zu greifen), Wiedergänger (Jenseits des Todes, 1x/Kampagne).
  - Waffen-Sonderboni (Axt/Streitkolben/Kriegshammer/Hellebarde vs. AC13+/
    Untot+Konstrukt/Schild/Gross-Ziele).
  - Monster nutzen jetzt alle ihre echten Moves (Utility-Effekte generisch
    nachgebaut, Move 3 eines 3-Move-Bosses ist die Ultimate, 1x/Kampf).

Rest-Annahme zwischen Encountern (wie zuvor): volle HP- UND Mana-Erholung,
Downed-PCs (0 bis -10 HP) werden bis zum naechsten Encounter wieder auf die
Beine gebracht, erst -10 HP ist endgueltiger Tod (scheidet fuer den Rest der
Probekampagne aus).
"""

import random
import statistics
from collections import defaultdict

import balance_simulator as bs
from balance_simulator import (
    Combatant, attack_roll, roll_dice, dice_avg, attr_mod, compute_si,
    roll_4d6_drop_lowest, roll_armor_bonus, weapon_bonus,
    PROFESSIONS, MELEE_WEAPON_POOL, EXPERIENCE_TIERS, KIN_LIST,
    SPELL_DICE_BY_RANK, SPELL_RANK_COST, SPELL_RANK_ORDER,
)

# ---------------------------------------------------------------------------
# Alter (final, 01-charakter.md): 1W10, jung-lastig. Aendert NIE das feste
# 5-Skill-Profession-Paket, sondern kommt additiv obendrauf -- 2/4/6 frei
# waehlbare Extra-Skills aus dem kompletten Katalog, plus ein thematischer
# Attribut-Trade-off (Jung: koerperlich staerker, weniger Lebenserfahrung;
# Alt: umgekehrt).
# ---------------------------------------------------------------------------

AGE_TABLE = [
    ("Jung", 5, 2, {"STR": 1, "WIS": -1}),
    ("Erwachsen", 3, 4, {}),
    ("Alt", 2, 6, {"WIS": 1, "STR": -1}),
]

def roll_age():
    r = random.randint(1, 10)
    acc = 0
    for name, weight, n_skills, attr_mods in AGE_TABLE:
        acc += weight
        if r <= acc:
            return name, n_skills, attr_mods
    return AGE_TABLE[-1][0], AGE_TABLE[-1][2], AGE_TABLE[-1][3]

# Kernset-Skills aus 13-katalog-skills.md, flach fuer die Zufallswahl der
# Alters-Extra-Skills. "Cantrip"-Eintraege bei Caster-Professionen sind keine
# echten Skill-Namen und bleiben hier aussen vor.
ALL_SKILLS = [
    "Acrobatics", "Athletik", "Ausdauer", "Kraftakt", "Reflexe", "Tauchen",
    "Überzeugen", "Einschüchtern", "Täuschen", "Verhandeln", "Anführen",
    "Menschenkenntnis", "Etikette", "Verführen", "Trösten/Beruhigen",
    "Geschichte", "Arkanes Wissen", "Religion", "Medizin", "Naturkunde",
    "Sprachen", "Rechtskunde/Bürokratie", "Sternenkunde/Kartografie",
    "Schmieden", "Alchemie", "Tischlerei/Lederarbeit", "Kochen", "Brauen",
    "Bergbau", "Schneiderei", "Ingenieurskunst",
    "Fährtenlesen", "Tierumgang", "Navigation", "Fallenstellen",
    "Überleben in der Wildnis", "Angeln", "Wetterkunde",
    "Schleichen", "Schlösser knacken", "Taschendiebstahl", "Verkleidung",
    "Falschspiel", "Fährten verwischen",
    "Waffenkunde", "Rüstungskunde", "Kampftaktik", "Reiten",
    "Waffenloser Kampf", "Wurfwaffen", "Verteidigungshaltung",
    "Musizieren", "Erzählen/Auftreten", "Tanzen", "Gaukelei",
    "Konzentration", "Willenskraft", "Meditation", "Intuition/Vorahnung",
]

def pick_extra_skills(n, weapon_trained, armor_relevant, armor_trained):
    """Alters-Extra-Skills: mit Bias, Kampf-Luecken zu schliessen (ein
    Spieler waehlt selten sehenden Auges gegen die eigene Ueberlebenschance),
    Rest zufaellig aus dem vollen Katalog -- reine Tool-Vereinfachung, echte
    Spieler waehlen natuerlich bewusst statt zufaellig."""
    picks = []
    needs_weapon = not weapon_trained
    needs_armor = armor_relevant and not armor_trained
    for _ in range(n):
        if needs_weapon and random.random() < 0.4:
            picks.append("Waffenkunde")
            needs_weapon = False
            continue
        if needs_armor and random.random() < 0.4:
            picks.append("Rüstungskunde")
            needs_armor = False
            continue
        picks.append(random.choice(ALL_SKILLS))
    return picks

# ---------------------------------------------------------------------------
# PC-Generierung (Vollversion mit Kin, Waffentyp, Mana, Alter)
# ---------------------------------------------------------------------------

def generate_pc_v2(tier_idx, profession_name=None, name_suffix=""):
    tier = EXPERIENCE_TIERS[tier_idx]
    prof = next(p for p in PROFESSIONS if p["name"] == profession_name) if profession_name else random.choice(PROFESSIONS)
    rolls = sorted((roll_4d6_drop_lowest() for _ in range(6)), reverse=True)
    stats = {"STR": 10, "CON": 10, "DEX": 10, "INT": 10, "WIS": 10, "CHA": 10}
    order = [prof["stat"], "CON"] + [s for s in ("DEX", "INT", "WIS", "CHA", "STR") if s not in (prof["stat"], "CON")]
    for stat, val in zip(order, rolls):
        stats[stat] = val

    age_name, n_extra_skills, age_attr_mods = roll_age()
    for stat, delta in age_attr_mods.items():
        stats[stat] = max(3, min(18, stats[stat] + delta))

    con_mod, dex_mod = attr_mod(stats["CON"]), attr_mod(stats["DEX"])
    int_mod, wis_mod = attr_mod(stats["INT"]), attr_mod(stats["WIS"])
    primary_mod = attr_mod(stats[prof["stat"]])
    hp = max(1, 10 + con_mod * 3)

    armor_bonus = roll_armor_bonus(prof["armor_cat"], tier["armor_rarity"])
    armor_relevant = prof["armor_cat"] != "Leicht"
    # Kanon-Trigger ist eigentlich "10 Kaempfe mit der Waffe/Ruestung ueberlebt"
    # (13-katalog-skills.md) -- diese feste 10-Encounter-Probekampagne trifft
    # das quasi exakt (10 Kaempfe insgesamt), aber generate_pc_v2 kennt den
    # Kampagnenfortschritt nicht. Tool-Vereinfachung: ab Tier 2 (~20h gespielt)
    # als Naeherung fuer "hat genug echte Kaempfe hinter sich" behandelt --
    # zusaetzlich zum Alters-Extra-Skill-Pick unten (zweiter, unabhaengiger Weg).
    extra_skills = pick_extra_skills(n_extra_skills, prof["weapon_trained"], armor_relevant, prof["armor_trained"])
    weapon_trained = prof["weapon_trained"] or tier_idx >= 2 or "Waffenkunde" in extra_skills
    armor_trained = not armor_relevant or prof["armor_trained"] or "Rüstungskunde" in extra_skills
    ac = 10 + dex_mod + (armor_bonus if armor_trained else 0)
    weapon_atk_bonus, weapon_dmg_bonus = bs.WEAPON_ENCHANT[tier["weapon_rarity"]]
    atk_bonus = primary_mod + (2 if weapon_trained else 0) + weapon_atk_bonus

    weapon_type = ""
    if prof["stat"] == "STR" and not prof["caster"]:
        wn, wsides, weapon_type = random.choice(MELEE_WEAPON_POOL)
        dmg = (wn, wsides, primary_mod + weapon_dmg_bonus)
    else:
        wn, wsides, wname = prof["weapon"]
        weapon_type = wname
        dmg = (wn, wsides, primary_mod + weapon_dmg_bonus)

    mana_max = 0
    spell_options = []
    if prof["caster"]:
        mana_max = 4 + max(int_mod, wis_mod)
        max_rank = tier["max_spell_rank"]
        # Cantrips sind reine Utility-Magie (final, 14-katalog-zauber.md) --
        # bei Tier 0 (nur Cantrip bekannt) gibt es also gar keinen Schadenszauber,
        # der Charakter greift dann immer mit der Nahwaffe an (siehe pc_choose_attack)
        if max_rank != "Cantrip":
            allowed = SPELL_RANK_ORDER[SPELL_RANK_ORDER.index(max_rank):]
            for rank in allowed:
                n, sides = SPELL_DICE_BY_RANK[rank]
                spell_options.append((rank, SPELL_RANK_COST[rank], (n, sides, primary_mod)))

    dmg_avg = dice_avg(*(spell_options[0][2] if spell_options else dmg))
    si = compute_si(hp, ac, atk_bonus, dmg_avg, tier="Standard")
    kin = random.choice(KIN_LIST)

    return Combatant(
        name=f"{profession_name or prof['name']}{name_suffix} ({tier['name']}, {kin}, {age_name})",
        hp=hp, max_hp=hp, ac=ac, atk_bonus=atk_bonus, dmg=dmg, side="PC",
        kin=kin, weapon_type=weapon_type, mana=mana_max, mana_max=mana_max,
        spell_options=spell_options, weapon_untrained=not weapon_trained,
        meta={"profession": profession_name or prof["name"], "tier": tier["name"], "si": si, "kin": kin,
              "age": age_name, "extra_skills": extra_skills, "armor_trained": armor_trained,
              "primary_stat": prof["stat"], "primary_mod": primary_mod},
    )

# ---------------------------------------------------------------------------
# Monster: echte Bestiarium-Werte + Moves (Move 3 eines 3-Move-Bosses ist
# immer die Ultimate, 1x/Kampf -- siehe 16-katalog-bestiarium.md).
# Utility-Effekt-Codes (generisch, siehe Docstring oben):
#   ally_boon_atk    -- alle lebenden Verbuendeten bekommen fuer den Rest der
#                       Runde Boon auf ihren Angriffswurf
#   enemy_bane_atk1  -- ein zufaelliges lebendes PC-Ziel bekommt Bane auf
#                       seinen naechsten Angriff
#   enemy_bane_atkN  -- gilt fuer ALLE lebenden PCs
#   block_incoming   -- der naechste eingehende Treffer gegen den Nutzer wird
#                       komplett negiert
#   halve_incoming   -- Schaden gegen die eigene Seite ist diese Runde halbiert
#   summon_fodder    -- beschwoert 1 zusaetzliche schwache Einheit (max. 1x/Kampf)
#   heal_self        -- heilt sich selbst um 50% der Max-HP
#   double_attack    -- greift zweimal in dieser Runde an (jeweils normale Werte)
#   aoe_dmg          -- trifft ALLE lebenden PCs einzeln mit einem Angriffswurf
# ---------------------------------------------------------------------------

def dmg_move(name, dmg):
    return {"name": name, "dmg": dmg, "kind": "dmg", "effect": None}

def util_move(name, effect):
    return {"name": name, "dmg": None, "kind": "utility", "effect": effect}

def ult_move(name, effect, dmg=None):
    return {"name": name, "dmg": dmg, "kind": "ultimate", "effect": effect}

def mk(name, hp, ac, atk, moves, tags=frozenset()):
    def factory(i):
        return Combatant(name=f"{name}-{i}", hp=hp, max_hp=hp, ac=ac, atk_bonus=atk,
                          dmg=moves[0]["dmg"], side="Monster", tags=frozenset(tags),
                          moves=[dict(m) for m in moves])
    return factory

GOBLIN_PLUENDERER = mk("Goblin-Plünderer", 3, 10, 2, [dmg_move("Dolchstich", (1, 4, 0))])
WOLF              = mk("Wolf", 9, 12, 4, [dmg_move("Biss", (1, 6, 0)), util_move("Rudel-Hetzen", "ally_boon_atk")])
BAER              = mk("Bär", 18, 12, 5, [dmg_move("Tatzenhieb", (1, 10, 0)), util_move("Umklammern", "enemy_bane_atk1")])
WACHOFFIZIER      = mk("Wachoffizier/Soldat", 12, 12, 4,
                       [dmg_move("Schwerthieb", (1, 8, 0)), util_move("Schildwall", "halve_incoming")],
                       tags={"Schild"})
ORK_GRUNZER       = mk("Ork-Grunzer", 6, 11, 3, [dmg_move("Keulenschlag", (1, 6, 0))])
ORK_KRIEGER       = mk("Ork-Krieger", 12, 12, 4, [dmg_move("Axthieb", (1, 8, 0)), util_move("Wutschrei", "ally_boon_atk")])
ORK_HORDENFUEHRER = mk("Ork-Hordenführer", 30, 14, 7,
                       [dmg_move("Axthieb", (1, 10, 0)), util_move("Kriegsschrei", "ally_boon_atk"),
                        ult_move("Blutrausch", "double_attack", dmg=(1, 10, 0))])
ASSASSINE         = mk("Assassine", 18, 13, 5, [dmg_move("Heimtückischer Stich", (1, 8, 0))])  # Rauchflucht (Flucht) ausgeklammert
BANDITENANFUEHRER = mk("Banditenanführer", 15, 12, 4, [dmg_move("Klingenhieb", (1, 8, 0)), util_move("Fieser Trick", "enemy_bane_atk1")])
BANDITEN_LAKAI    = mk("Banditen-Lakai", 6, 11, 2, [dmg_move("Klingenhieb", (1, 6, 0))])
KULT_HOHEPRIESTER = mk("Kult-Hohepriester", 27, 13, 6,
                       [dmg_move("Schattengriff", (1, 8, 0)), util_move("Diener beschwören", "summon_fodder"),
                        ult_move("Blutopfer", "heal_self")])
KULTIST           = mk("Kultist", 15, 12, 4, [dmg_move("Ritualdolch", (1, 6, 0)), util_move("Dunkles Gebet", "enemy_bane_atkN")])
NEKROMANT         = mk("Nekromant", 27, 13, 6,
                       [dmg_move("Schattengriff", (1, 6, 0)), util_move("Diener erheben", "summon_fodder"),
                        ult_move("Furchtwelle", "enemy_bane_atkN")],
                       tags={"Untot"})
SKELETT_KRIEGER   = mk("Skelett-Krieger", 6, 11, 3, [dmg_move("Knochenklinge", (1, 6, 0))], tags={"Untot"})
ELITEGARDIST      = mk("Elitegardist", 18, 13, 7,
                       [dmg_move("Präziser Hieb", (1, 6, 2)), util_move("Parade", "block_incoming")],
                       tags={"Schild"})
WACHREKRUT        = mk("Wachrekrut", 6, 10, 3, [dmg_move("Schwerthieb", (1, 6, 0))], tags={"Schild"})
KRIEGSHAUPTMANN   = mk("Kriegshauptmann", 27, 14, 7,
                       [dmg_move("Klingenhieb", (1, 10, 0)), util_move("Kommandoruf", "ally_boon_atk"),
                        ult_move("Duellant", "challenge_bonus_dmg", dmg=(1, 10, 0))],
                       tags={"Schild"})
FROSTRIESE        = mk("Frostriese", 36, 15, 7,
                       [dmg_move("Eisfaust", (1, 12, 0)), dmg_move("Frostatem", (1, 8, 0)),
                        ult_move("Lawinenwurf", "aoe_dmg", dmg=(2, 12, 0))],
                       tags={"Gross"})

def encounter(builders):
    return [b(i) for i, b in enumerate(builders)]

CAMPAIGN = [
    ("1. Erste Begegnung",         "Leicht",        lambda: encounter([GOBLIN_PLUENDERER]*6)),
    ("2. Waldauftrag",             "Mittel",        lambda: encounter([BAER, WOLF, WOLF])),
    ("3. Stress mit der Wache",    "Equal",         lambda: encounter([ELITEGARDIST]*3)),
    ("4. Orks auf dem Weg",        "Leicht-Mittel", lambda: encounter([ORK_GRUNZER]*3 + [ORK_KRIEGER])),
    ("5. Miniboss: Hordenführer",  "Miniboss",      lambda: encounter([ORK_HORDENFUEHRER] + [ORK_GRUNZER]*4)),
    ("6. Verrat im Dunkeln",       "Mittel-Schwer", lambda: encounter([ASSASSINE, BANDITENANFUEHRER] + [BANDITEN_LAKAI]*3)),
    ("7. Kult-Zirkel",             "Equal",         lambda: encounter([KULT_HOHEPRIESTER] + [KULTIST]*3)),
    ("8. Untote Vorhut",           "Mittel-Schwer", lambda: encounter([NEKROMANT] + [SKELETT_KRIEGER]*4)),
    ("9. Die letzte Wache",        "Schwer",        lambda: encounter([KRIEGSHAUPTMANN, ELITEGARDIST, ELITEGARDIST, WACHREKRUT])),
    ("10. Endboss: Der Frostriese","Endboss",       lambda: encounter([FROSTRIESE] + [ELITEGARDIST]*2)),
]

# ---------------------------------------------------------------------------
# Kampf-Engine mit voller Regel-Abdeckung
# ---------------------------------------------------------------------------

def pc_choose_attack(pc):
    """Waehlt den teuersten noch bezahlbaren Schadenszauber. Ist keiner mehr
    bezahlbar (oder ist der Charakter kein Caster): Ruecksfall auf die
    Nahwaffe -- Cantrips sind reine Utility-Magie, kein Schadens-Fallback
    (final, 14-katalog-zauber.md). rank=None markiert einen Waffenangriff."""
    for rank, cost, dmg in pc.spell_options:
        if pc.mana >= cost:
            pc.mana -= cost
            return dmg, rank
    return pc.dmg, None

def choose_monster_move(monster, round_no):
    ult = next((m for m in monster.moves if m["kind"] == "ultimate"), None)
    if ult and not monster.flags.get("used_ultimate") and round_no >= 2:
        monster.flags["used_ultimate"] = True
        return ult
    util_moves = [m for m in monster.moves if m["kind"] == "utility"]
    if util_moves and random.random() < 0.3:
        move = util_moves[0]
        if move["effect"] == "summon_fodder" and monster.flags.get("summoned_once"):
            pass
        else:
            if move["effect"] == "summon_fodder":
                monster.flags["summoned_once"] = True
            return move
    dmg_moves = [m for m in monster.moves if m["kind"] == "dmg"]
    return dmg_moves[0] if dmg_moves else monster.moves[0]

def resolve_attack(attacker, target, dmg_tuple, side_round_boon, all_combatants, weapon_attack=False):
    """Ein einzelner Angriffswurf + Schaden, inkl. Bane/Boon/Sonderboni/Traits.
    Gibt (hit, dmg_dealt) zurueck. weapon_attack=True (Nahwaffe statt Zauber,
    siehe pc_choose_attack) zieht bei fehlender Waffenkunde Bane (13-katalog-
    skills.md) -- Zauber sind davon nie betroffen."""
    adv = 0
    boon_dmg = False
    if side_round_boon.get(attacker.side):
        adv += 1
    if attacker.flags.pop("bane_next_atk", False):
        adv -= 1
    if weapon_attack and attacker.weapon_untrained:
        adv -= 1
    if attacker.side == "PC" and attacker.kin == "Goblin" and id(target) in side_round_boon.get("goblin_targets", set()):
        adv += 1
    if attacker.side == "PC" and attacker.weapon_type:
        bonus = weapon_bonus(attacker.weapon_type, target)
        if bonus == "atk":
            adv += 1
        elif bonus == "dmg":
            boon_dmg = True
    if target.kin == "Halbling" and "Gross" in attacker.tags:
        adv -= 1
    adv = max(-1, min(1, adv))

    # Ork-Kampfrausch (aktiv fuer den Rest DIESES Kampfes, kein permanenter
    # Stat-Zuwachs -- wird ueber das Flag pro Angriff dazugerechnet, nicht in
    # atk_bonus/dmg eingebrannt, sonst wuerde es sich ueber Encounter hinweg
    # aufsummieren):
    rausch = 2 if attacker.flags.get("kampfrausch") else 0
    hit, crit = attack_roll(attacker.atk_bonus + rausch, target.ac, adv=adv)
    if not hit:
        return False, 0
    if target.flags.pop("block_incoming", False):
        return True, 0  # Parade: Treffer landet, aber Schaden komplett negiert

    raw = roll_dice(dmg_tuple[0], dmg_tuple[1], dmg_tuple[2] + rausch)
    if boon_dmg:
        raw = max(raw, roll_dice(dmg_tuple[0], dmg_tuple[1], dmg_tuple[2] + rausch))
    if crit:
        raw *= 2
    if side_round_boon.get(f"halve_{target.side}"):
        raw = raw // 2

    target.hp -= raw
    # Trait wird erst NACH diesem Treffer scharf, wenn er den Verteidiger
    # gerade unter die Haelfte gebracht hat (gilt fuer den Rest des Kampfes)
    if target.side == "PC" and target.kin == "Ork" and target.hp <= target.max_hp / 2 and not target.flags.get("kampfrausch"):
        target.flags["kampfrausch"] = True

    # Wiedergänger: 1x pro Kampagne einen todeswuerdigen Treffer ignorieren
    if target.hp <= 0 and target.side == "PC" and target.kin == "Wiedergänger" and not target.meta.get("_downimmune_used"):
        target.meta["_downimmune_used"] = True
        target.hp = 1

    return True, raw

def apply_utility_effect(user, move, side_round_boon, allies, enemies, all_combatants):
    effect = move["effect"]
    if effect == "ally_boon_atk":
        side_round_boon[user.side] = True
    elif effect == "enemy_bane_atk1":
        alive_enemies = [e for e in enemies if e.hp > 0]
        if alive_enemies:
            random.choice(alive_enemies).flags["bane_next_atk"] = True
    elif effect == "enemy_bane_atkN":
        for e in enemies:
            if e.hp > 0:
                e.flags["bane_next_atk"] = True
    elif effect == "block_incoming":
        user.flags["block_incoming"] = True
    elif effect == "halve_incoming":
        side_round_boon[f"halve_{user.side}"] = True
    elif effect == "summon_fodder":
        idx = sum(1 for c in all_combatants if c.side == "Monster")
        all_combatants.append(GOBLIN_PLUENDERER(f"beschworen{idx}"))
    elif effect == "heal_self":
        user.hp = min(user.max_hp, user.hp + user.max_hp // 2)

def simulate_fight_with_death(pcs, monsters, max_rounds=50):
    combatants = [Combatant(**vars(c)) for c in pcs] + [Combatant(**vars(c)) for c in monsters]
    for c in combatants:
        c.flags = {}
    rounds = 0
    while rounds < max_rounds:
        active_pc = [c for c in combatants if c.side == "PC" and c.hp > 0]
        alive_mon = [c for c in combatants if c.side == "Monster" and c.hp > 0]
        if not active_pc or not alive_mon:
            break
        rounds += 1
        side_round_boon = {"goblin_targets": set()}
        order = [c for c in combatants if c.hp > 0]
        random.shuffle(order)
        for c in order:
            if c.hp <= 0:
                continue
            enemies = [e for e in combatants if e.side != c.side and e.hp > 0]
            allies = [a for a in combatants if a.side == c.side and a.hp > 0]
            if not enemies:
                continue

            if c.side == "PC":
                target = random.choice(enemies)
                dmg_tuple, rank = pc_choose_attack(c)
                hit, dealt = resolve_attack(c, target, dmg_tuple, side_round_boon, combatants, weapon_attack=(rank is None))
                if hit:
                    side_round_boon["goblin_targets"].add(id(target))
            else:
                move = choose_monster_move(c, rounds)
                if move["dmg"] is None:
                    # jede nicht-schadende Move (Utility ODER eine Ultimate ohne
                    # eigenen Schaden wie Blutopfer/Furchtwelle) laeuft ueber
                    # den generischen Effekt-Resolver
                    apply_utility_effect(c, move, side_round_boon, allies, enemies, combatants)
                    continue
                target_pool = [e for e in enemies if e.hp > 0]  # Down-PCs (<=0) werden in Ruhe gelassen
                if not target_pool:
                    continue
                if move["effect"] == "aoe_dmg":
                    for t in list(target_pool):
                        if t.hp > 0:
                            resolve_attack(c, t, move["dmg"], side_round_boon, combatants)
                    continue
                target = random.choice(target_pool)
                dmg_tuple = move["dmg"]
                if move["effect"] == "challenge_bonus_dmg":
                    hit, dealt = resolve_attack(c, target, dmg_tuple, side_round_boon, combatants)
                    if hit:
                        target.hp -= roll_dice(1, 6, 0)
                    continue
                resolve_attack(c, target, dmg_tuple, side_round_boon, combatants)
                if move["effect"] == "double_attack":
                    target_pool2 = [e for e in enemies if e.hp > 0]
                    if target_pool2:
                        resolve_attack(c, random.choice(target_pool2), dmg_tuple, side_round_boon, combatants)

    pcs_out = [c for c in combatants if c.side == "PC"]
    mon_alive = [c for c in combatants if c.side == "Monster" and c.hp > 0]
    party_won = any(c.hp > 0 for c in pcs_out) and not mon_alive
    return party_won, pcs_out, rounds

def run_campaign_for_party(pcs):
    party = [Combatant(**vars(p)) for p in pcs]
    log = []
    for name, difficulty, build in CAMPAIGN:
        living = [p for p in party if p.hp > -10]
        if not living:
            log.append({"encounter": name, "difficulty": difficulty, "skipped": True,
                        "won": False, "survivors": 0, "deaths_this_fight": 0, "rounds": 0})
            continue
        for p in living:
            p.hp = p.max_hp
            p.mana = p.mana_max
            p.flags = {}
        monsters = build()
        won, pcs_after, rounds = simulate_fight_with_death(living, monsters)
        deaths_this_fight = sum(1 for p in pcs_after if p.hp <= -10)
        for updated in pcs_after:
            for orig in party:
                if orig.name == updated.name:
                    orig.hp, orig.mana, orig.flags, orig.atk_bonus, orig.dmg = (
                        updated.hp, updated.mana, updated.flags, updated.atk_bonus, updated.dmg
                    )
                    orig.meta = updated.meta
        survivors_active = sum(1 for p in party if p.hp > -10)
        log.append({"encounter": name, "difficulty": difficulty, "skipped": False,
                    "won": won, "survivors": survivors_active,
                    "deaths_this_fight": deaths_this_fight, "rounds": rounds})
        if survivors_active == 0:
            break
    return log

def run_full_campaign_sim(n_parties=100, seed=42):
    if seed is not None:
        random.seed(seed)
    all_logs = []
    for _ in range(n_parties):
        pcs = [generate_pc_v2(random.randrange(len(EXPERIENCE_TIERS))) for _ in range(3)]
        all_logs.append(run_campaign_for_party(pcs))
    return all_logs

def summarize_campaign(all_logs):
    n = len(all_logs)
    print(f"{n} Parteien durch die 10-Encounter-Probekampagne geschickt (Vollregel-Version)\n")

    by_enc = defaultdict(list)
    for log in all_logs:
        for entry in log:
            by_enc[entry["encounter"]].append(entry)

    for name, difficulty, _ in CAMPAIGN:
        entries = [e for e in by_enc[name] if not e["skipped"]]
        if not entries:
            print(f"  {name:28s} ({difficulty:12s}) -- nie erreicht")
            continue
        wr = sum(e["won"] for e in entries) / len(entries)
        avg_surv = statistics.mean(e["survivors"] for e in entries)
        avg_rounds = statistics.mean(e["rounds"] for e in entries)
        print(f"  {name:28s} ({difficulty:12s}) erreicht={len(entries):3d}/{n}  "
              f"Siegrate={wr*100:5.1f}%  Ø-Überlebende danach={avg_surv:.2f}/3  Ø-Runden={avg_rounds:4.1f}")

    completed = sum(1 for log in all_logs if not log[-1]["skipped"] and log[-1]["survivors"] > 0)
    tpk = sum(1 for log in all_logs if any(e["survivors"] == 0 for e in log))
    full_end = sum(1 for log in all_logs if log[-1].get("survivors", 0) == 3)
    print(f"\n  Kampagne durchgestanden: {completed}/{n} ({completed/n*100:.1f}%)   "
          f"TPK irgendwann: {tpk}/{n} ({tpk/n*100:.1f}%)   Alle 3 am Ende: {full_end}/{n} ({full_end/n*100:.1f}%)")

if __name__ == "__main__":
    logs = run_full_campaign_sim(n_parties=100, seed=42)
    summarize_campaign(logs)
