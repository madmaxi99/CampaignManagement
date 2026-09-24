#!/usr/bin/env python3
"""
Balance-Simulator fuer das eigene TTRPG-System (docs/own-system/).

Generiert 3-PC-Parteien auf unterschiedlichen Erfahrungsstufen (frisch erstellt
bis ~30h gespielt), berechnet ihre Gesamt-Staerke per Staerke-Index (SI, gleiche
Formel wie im Bestiarium, siehe 09-bestiary-und-npcs.md), und laesst 10
verschiedene Gegner-Zusammenstellungen mit demselben Gesamt-SI je 10x gegen sie
antreten (macht 100 Kaempfe pro Partei). Nach jedem 100er-Block wird eine neue
Partei gewuerfelt -- macht 1000 Kaempfe insgesamt.

Kampfverhalten ist bewusst simpel und fuer beide Seiten identisch: jede Runde
zufaellige Reihenfolge (Karten-Initiative wird hier durch reines Shuffle
ersetzt), jeder Combatant greift ein zufaelliges lebendes Ziel der Gegenseite
an (Angriffswurf vs. AC, bei Treffer Schaden), gekaempft wird bis eine Seite
komplett kampfunfaehig (HP <= 0) ist.

WICHTIG -- Annahmen dieses Tools, die ueber die bisher fixierte Kanon-Mechanik
hinausgehen (weil im Katalog noch nicht in Zahlen gegossen):
  - Waffen-Verzauberungsbonus nach Rarity: Common/Uncommon mundan (+0/+0,
    passend zu "ab Rare aufwaerts Verzauberungen" in 07-ausruestung...),
    Rare +1 Angriff/+2 Schaden, Legendary +2 Angriff/+4 Schaden.
  - Zauber-Schaden pro Rang (grobe Analogie zu Waffen-Wuerfeln): Cantrip 1W4,
    R1 1W6, R2 1W8, R3 2W6 -- Attributmod (INT/WIS, je nach Kategorie) zaehlt
    wie bei Waffen dazu.
  - Erfahrungsstufe aendert NUR Ausruestungs-Rarity und hoechsten bekannten
    Zauberrang, NICHT Attribute/HP (passt zum "kein XP-Fortschritt, Macht
    kommt ueber Gear"-Prinzip aus 01-charakter.md).
Diese Annahmen sind fuers Balancing gedacht, keine Katalog-Ergaenzung.

TUNING-BEFUND (siehe MULTIPLIER_TABLE + power_scale in generate_monster):
Ohne Korrektur schwankte die Gewinnrate bei IDENTISCHEM Gesamt-SI zwischen 44%
und 97%, je nach Gegner-Zusammenstellung -- SI allein war kein verlaesslicher
Schwierigkeitsgrad. Zwei Korrekturen wurden eingebaut:
  1. power_scale: ein generisches Monster mit ueberdurchschnittlichem
     Einzel-SI (z. B. weil sich wenige Einheiten ein grosses Budget teilen)
     bekommt nicht nur mehr HP, sondern auch spuerbar bessere AC/Angriff/
     Schaden -- sonst ist "wenige, aufgepumpte Fodder" IMMER ungefaehrlich,
     egal wie viel SI man ihnen gibt (reine HP-Sponges beissen nicht).
  2. MULTIPLIER_TABLE: leichte Korrektur nach Kopfzahl (Action Economy),
     kleinere Gruppen (1-2) werden leicht angehoben, grosse Schwaerme (7+)
     leicht abgewertet.
Damit sinkt die Spanne auf ca. 37-86% (Mean ~58%) -- deutlich enger, aber
nicht perfekt flach. Der Rest der Varianz kommt aus dem TIER-MIX selbst:
Fodder-lastige Zusammenstellungen bleiben bei gleichem SI tendenziell
guenstiger fuer die Party als Standard/Boss-lastige, unabhaengig von der
Kopfzahl. Das ist ein echter Befund, keine Rechenschwaeche des Tools: SI ist
ein guter grober Gradmesser, ersetzt aber nicht den Blick auf die tatsaechliche
Zusammensetzung eines Encounters.
"""

import random
import statistics
from dataclasses import dataclass, field
from collections import defaultdict

# ---------------------------------------------------------------------------
# Grundbausteine (aus 02-kernmechanik.md / 03-kampf.md)
# ---------------------------------------------------------------------------

def attr_mod(score):
    return (score - 10) // 2

def roll_4d6_drop_lowest():
    rolls = sorted(random.randint(1, 6) for _ in range(4))
    return sum(rolls[1:])

def dice_avg(n, sides, mod=0):
    return n * (sides + 1) / 2 + mod

def roll_dice(n, sides, mod=0):
    return sum(random.randint(1, sides) for _ in range(n)) + mod

def attack_roll(atk_bonus, ac, adv=0):
    """adv: +1 = Boon (2 wuerfeln, besseren nehmen), -1 = Bane (schlechteren
    nehmen), 0 = normal. Bane/Boon aus 02-kernmechanik.md."""
    if adv > 0:
        d20 = max(random.randint(1, 20), random.randint(1, 20))
    elif adv < 0:
        d20 = min(random.randint(1, 20), random.randint(1, 20))
    else:
        d20 = random.randint(1, 20)
    if d20 == 1:
        return False, False
    if d20 == 20:
        return True, True
    return (d20 + atk_bonus) >= ac, False

# Tier-Mittelwerte fuer die SI-Formel (aus 09-bestiary-und-npcs.md)
TIER_MID = {
    "Fodder":   {"ac": 10.5, "atk": 2.5, "dmg": 3.0},
    "Standard": {"ac": 12.5, "atk": 4.5, "dmg": 4.5},
    "Boss":     {"ac": 14.5, "atk": 6.5, "dmg": 5.5},
}

def compute_si(hp, ac, atk, dmg_avg, tier="Standard"):
    mid = TIER_MID[tier]
    dev = ((ac - mid["ac"]) + (atk - mid["atk"]) + (dmg_avg - mid["dmg"])) / 3
    return max(1, round(hp / 3 + dev))

# ---------------------------------------------------------------------------
# Ruestung: AC-Bonus-Wuerfel (15-katalog-items.md)
# ---------------------------------------------------------------------------

ARMOR_CATEGORY_DIE = {"Leicht": 2, "Mittel": 3, "Schwer": 4}
RARITY_FLAT_BONUS = {"Common": 0, "Uncommon": 1, "Rare": 2, "Legendary": 4}

def roll_armor_bonus(category, rarity):
    return random.randint(1, ARMOR_CATEGORY_DIE[category]) + RARITY_FLAT_BONUS[rarity]

# Waffen-Verzauberung nach Rarity (Tool-Annahme, siehe Docstring oben)
WEAPON_ENCHANT = {
    "Common": (0, 0), "Uncommon": (0, 0), "Rare": (1, 2), "Legendary": (2, 4)
}

# Zauber-Schaden pro Rang. Cantrip bewusst NICHT hier drin (final in
# 14-katalog-zauber.md: Cantrips sind reine Utility-Magie, kein Cantrip macht
# Schaden) -- ohne bezahlbaren R1+ faellt ein Caster auf seine Nahwaffe zurueck,
# nicht auf einen Schadens-Cantrip.
SPELL_DICE_BY_RANK = {
    "R1": (1, 6), "R2": (1, 8), "R3": (2, 6)
}
SPELL_RANK_COST = {"R1": 1, "R2": 2, "R3": 4}
SPELL_RANK_ORDER = ["R3", "R2", "R1"]  # teuerste zuerst probieren

# Die 9 Kin aus 11-katalog-kins.md. Nur die 4 kampfrelevanten Traits werden in
# campaign_simulator.py mechanisch umgesetzt (Ork/Goblin/Halbling/Wiedergänger)
# -- der Rest (Nachtsicht, Gift-/Schlaf-Resistenz, Sturzschaden o. Ae.) wirkt
# sich in diesem reinen Kampf-Loop nicht aus und bleibt Flavor.
KIN_LIST = ["Mensch", "Zwerg", "Halbling", "Elf", "Echsenvolk", "Katzenvolk", "Ork", "Goblin", "Wiedergänger"]

# ---------------------------------------------------------------------------
# Erfahrungsstufen: aendern NUR Gear-Rarity + hoechsten Zauberrang
# ---------------------------------------------------------------------------

EXPERIENCE_TIERS = [
    {"name": "Frisch erstellt",     "weapon_rarity": "Common",   "armor_rarity": "Common",   "max_spell_rank": "Cantrip"},
    {"name": "~10h gespielt",       "weapon_rarity": "Uncommon", "armor_rarity": "Uncommon", "max_spell_rank": "R1"},
    {"name": "~20h gespielt",       "weapon_rarity": "Rare",     "armor_rarity": "Uncommon", "max_spell_rank": "R2"},
    {"name": "~30h, legendaer",     "weapon_rarity": "Rare",     "armor_rarity": "Legendary","max_spell_rank": "R3"},
]

# ---------------------------------------------------------------------------
# Professionen: alle 33 aus 12-katalog-professionen.md
# ---------------------------------------------------------------------------

# weapon_trained/armor_trained: hat die Profession (kanonisch, 12-katalog-
# professionen.md) Waffenkunde bzw. Ruestungskunde in ihrem festen 5-Skill-
# Paket? Ohne Waffenkunde: Bane auf Angriffe mit der gefuehrten Waffe (siehe
# resolve_attack in campaign_simulator.py). armor_trained ist nur relevant bei
# Mittel/Schwer -- Leichte Ruestung gibt ihren Bonus immer, kein Skill noetig
# (13-katalog-skills.md). "skills" = das komplette 5-Skill-Paket (Klartext wie
# im Katalog, Klammerzusaetze entfernt) -- fuer generische Challenge-Checks
# (siehe profession_fairness_check.py), nicht fuer den Kampf-Loop gebraucht.
# "wealth": Startgeld-Tendenz, ein String oder ein Tupel aus zwei ("je nach")
# Tendenzen, aus denen bei der Generierung zufaellig gewaehlt wird.
# Fuer STR-Nahkampf-Professionen ohne Caster wird "weapon" unten ignoriert --
# die wuerfeln ihre Waffe aus MELEE_WEAPON_POOL (siehe generate_pc/_v2).
PROFESSIONS = [
    {"name": "Soldat", "stat": "STR", "weapon": (1, 8, "Langschwert"), "armor_cat": "Mittel", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Waffenkunde", "Kampftaktik", "Verteidigungshaltung", "Reflexe", "Ausdauer"]},
    {"name": "Söldner", "stat": "STR", "weapon": (1, 6, "Kurzschwert"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": ("Durchschnittlich", "Wohlhabend"),
     "skills": ["Waffenkunde", "Verhandeln", "Menschenkenntnis", "Athletik", "Reflexe"]},
    {"name": "Elitegardist", "stat": "STR", "weapon": (1, 8, "Langschwert"), "armor_cat": "Schwer", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": ("Durchschnittlich", "Wohlhabend"),
     "skills": ["Waffenkunde", "Reflexe", "Etikette", "Einschüchtern", "Menschenkenntnis"]},
    {"name": "Assassine", "stat": "DEX", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Schleichen", "Waffenkunde", "Menschenkenntnis", "Verkleidung", "Fährten verwischen"]},
    {"name": "Kopfgeldjäger", "stat": "STR", "weapon": (1, 6, "Kurzschwert"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Fährtenlesen", "Waffenkunde", "Einschüchtern", "Menschenkenntnis", "Überleben in der Wildnis"]},

    {"name": "Wildnisläufer", "stat": "WIS", "weapon": (1, 8, "Langbogen"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Fährtenlesen", "Navigation", "Überleben in der Wildnis", "Tierumgang", "Wetterkunde"]},
    {"name": "Jäger/Trapper", "stat": "DEX", "weapon": (1, 6, "Kurzbogen"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Fallenstellen", "Tierumgang", "Tischlerei/Lederarbeit", "Fährtenlesen", "Überleben in der Wildnis"]},
    {"name": "Kräuterkundiger", "stat": "WIS", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Naturkunde", "Alchemie", "Überleben in der Wildnis", "Medizin", "Wetterkunde"]},

    {"name": "Dieb/Schurke", "stat": "DEX", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Schleichen", "Schlösser knacken", "Taschendiebstahl", "Verkleidung", "Fährten verwischen"]},
    {"name": "Straßenkind", "stat": "DEX", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Taschendiebstahl", "Schleichen", "Menschenkenntnis", "Fährten verwischen", "Schlösser knacken"]},
    {"name": "Gauner/Falschspieler", "stat": "CHA", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Falschspiel", "Täuschen", "Verhandeln", "Menschenkenntnis", "Verkleidung"]},
    {"name": "Schmuggler", "stat": "DEX", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Verhandeln", "Täuschen", "Schlösser knacken", "Reiten", "Menschenkenntnis"]},

    {"name": "Gelehrter/Scholar", "stat": "INT", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Arkanes Wissen", "Geschichte", "Sprachen", "Rechtskunde/Bürokratie", "Sternenkunde/Kartografie"]},
    {"name": "Kleriker", "stat": "WIS", "weapon": (1, 6, "Streitkolben"), "armor_cat": "Mittel", "caster": True,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Religion", "Medizin", "Überzeugen", "Willenskraft", "Menschenkenntnis"]},
    {"name": "Mönch/Asket", "stat": "DEX", "weapon": (1, 6, "Waffenlos"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": "Arm",
     "skills": ["Waffenloser Kampf", "Willenskraft", "Meditation", "Athletik", "Konzentration"]},
    {"name": "Magier", "stat": "INT", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": True,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Arkanes Wissen", "Konzentration", "Cantrip", "Geschichte", "Sprachen"]},
    {"name": "Kultist", "stat": "INT", "weapon": (1, 4, "Ritualdolch"), "armor_cat": "Leicht", "caster": True,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Arkanes Wissen", "Täuschen", "Cantrip", "Religion", "Einschüchtern"]},
    {"name": "Heiler", "stat": "WIS", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": True,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Medizin", "Trösten/Beruhigen", "Religion", "Naturkunde", "Alchemie"]},

    {"name": "Schmied", "stat": "STR", "weapon": (1, 6, "Streitkolben"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": True, "armor_trained": False, "wealth": ("Durchschnittlich", "Wohlhabend"),
     "skills": ["Schmieden", "Waffenkunde", "Kraftakt", "Verhandeln", "Ausdauer"]},
    {"name": "Bergarbeiter", "stat": "STR", "weapon": (1, 6, "Streitkolben"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Bergbau", "Ausdauer", "Naturkunde", "Kraftakt", "Ingenieurskunst"]},
    {"name": "Steinmetz", "stat": "STR", "weapon": (1, 6, "Streitkolben"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Bergbau", "Ingenieurskunst", "Kraftakt", "Ausdauer", "Verhandeln"]},
    {"name": "Gerber/Lederer", "stat": "STR", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Tischlerei/Lederarbeit", "Verhandeln", "Ausdauer", "Naturkunde", "Kraftakt"]},
    {"name": "Bäcker", "stat": "CHA", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Kochen", "Verhandeln", "Menschenkenntnis", "Brauen", "Ausdauer"]},
    {"name": "Gastwirt", "stat": "CHA", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Durchschnittlich",
     "skills": ["Kochen", "Menschenkenntnis", "Verhandeln", "Brauen", "Einschüchtern"]},
    {"name": "Fuhrmann/Karrenführer", "stat": "STR", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Tierumgang", "Navigation", "Verhandeln", "Ausdauer", "Wetterkunde"]},
    {"name": "Händler", "stat": "CHA", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Wohlhabend",
     "skills": ["Verhandeln", "Menschenkenntnis", "Sternenkunde/Kartografie", "Reiten", "Rechtskunde/Bürokratie"]},
    {"name": "Geldwechsler/Bankier", "stat": "INT", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Wohlhabend",
     "skills": ["Rechtskunde/Bürokratie", "Verhandeln", "Menschenkenntnis", "Täuschen", "Etikette"]},
    {"name": "Bauer", "stat": "STR", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Ausdauer", "Tierumgang", "Kochen", "Naturkunde", "Kraftakt"]},
    {"name": "Knecht/Magd", "stat": "STR", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Ausdauer", "Tierumgang", "Kraftakt", "Naturkunde", "Fährtenlesen"]},

    {"name": "Barde", "stat": "DEX", "weapon": (1, 6, "Kurzschwert"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Musizieren", "Erzählen/Auftreten", "Überzeugen", "Menschenkenntnis", "Sprachen"]},
    {"name": "Schausteller/Gaukler", "stat": "DEX", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Arm",
     "skills": ["Acrobatics", "Gaukelei", "Täuschen", "Tanzen", "Verkleidung"]},
    {"name": "Adliger", "stat": "CHA", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": "Wohlhabend",
     "skills": ["Etikette", "Überzeugen", "Geschichte", "Menschenkenntnis", "Rechtskunde/Bürokratie"]},
    {"name": "Seemann/Matrose", "stat": "DEX", "weapon": (1, 4, "Dolch"), "armor_cat": "Leicht", "caster": False,
     "weapon_trained": False, "armor_trained": False, "wealth": ("Arm", "Durchschnittlich"),
     "skills": ["Acrobatics", "Navigation", "Ausdauer", "Wetterkunde", "Kraftakt"]},
]

STARTGELD_FORMULA = {"Arm": (1, 6, 5), "Durchschnittlich": (2, 6, 5), "Wohlhabend": (3, 6, 10)}

def roll_startgeld(wealth):
    tier = random.choice(wealth) if isinstance(wealth, tuple) else wealth
    n, sides, mult = STARTGELD_FORMULA[tier]
    return roll_dice(n, sides, 0) * mult, tier

# STR-Nahkampf-Professionen (Soldat/Söldner/Elitegardist/Bauer) wuerfeln ihre
# konkrete Waffe aus diesem Pool aus, statt immer Langschwert zu tragen --
# damit die Waffen-Sonderboni aus 15-katalog-items.md (Axt/Streitkolben/
# Kriegshammer/Hellebarde) in der Simulation ueberhaupt vorkommen.
MELEE_WEAPON_POOL = [
    (1, 8, "Langschwert"), (1, 8, "Axt"), (1, 6, "Streitkolben"),
    (1, 10, "Kriegshammer"), (1, 10, "Hellebarde"), (1, 10, "Großschwert"),
]

# Waffen-Sonderboni (final in 15-katalog-items.md): Boon auf Angriff ODER
# Schaden gegen Ziele mit bestimmten Tags. "dmg" = Boon auf den Schadenswurf
# (Schadenswuerfel zweimal, besseren nehmen), "atk" = Boon auf den Angriffswurf.
def weapon_bonus(weapon_type, target):
    if weapon_type == "Axt" and target.ac >= 13:
        return "dmg"
    if weapon_type == "Streitkolben" and ("Untot" in target.tags or "Konstrukt" in target.tags):
        return "dmg"
    if weapon_type == "Kriegshammer" and "Schild" in target.tags:
        return "atk"
    if weapon_type == "Hellebarde" and "Gross" in target.tags:
        return "atk"
    return None

@dataclass
class Combatant:
    name: str
    hp: int
    max_hp: int
    ac: int
    atk_bonus: int
    dmg: tuple  # (n, sides, mod) -- aktueller/primaerer Schadens-Move
    side: str
    meta: dict = field(default_factory=dict)
    # Erweiterungen fuer campaign_simulator.py (volle Kampf-Regeln: Kin-Traits,
    # Waffen-Sonderboni, Mana-Erschoepfung, Monster-Moves). Im einfachen
    # SI-Recipe-Tool oben bleiben das alles Leerwerte/No-ops.
    kin: str = ""
    weapon_type: str = ""
    tags: frozenset = field(default_factory=frozenset)
    mana: int = 0
    mana_max: int = 0
    spell_options: list = field(default_factory=list)  # [(rank, cost, (n,sides,mod)), ...] beste zuerst
    moves: list = field(default_factory=list)           # fuer Monster: [{"name","dmg","kind","effect"}, ...]
    flags: dict = field(default_factory=dict)           # transiente Rundeneffekte
    weapon_untrained: bool = False  # keine Waffenkunde fuer die gefuehrte Waffe -> Bane auf Angriff (13-katalog-skills.md)

    @property
    def alive(self):
        return self.hp > 0

def generate_pc(tier_idx):
    tier = EXPERIENCE_TIERS[tier_idx]
    prof = random.choice(PROFESSIONS)
    rolls = sorted((roll_4d6_drop_lowest() for _ in range(6)), reverse=True)
    # grobe Zuordnung: primaerstat bekommt hoechsten Wurf, CON zweithoechsten,
    # DEX (falls nicht primaer) dritthoechsten, Rest beliebig
    stats = {"STR": 10, "CON": 10, "DEX": 10, "INT": 10, "WIS": 10, "CHA": 10}
    order = [prof["stat"], "CON"] + [s for s in ("DEX", "INT", "WIS", "CHA", "STR") if s not in (prof["stat"], "CON")]
    for stat, val in zip(order, rolls):
        stats[stat] = val

    con_mod = attr_mod(stats["CON"])
    dex_mod = attr_mod(stats["DEX"])
    primary_mod = attr_mod(stats[prof["stat"]])

    hp = max(1, 10 + con_mod * 3)

    armor_bonus = roll_armor_bonus(prof["armor_cat"], tier["armor_rarity"])
    armor_trained = prof["armor_cat"] == "Leicht" or prof["armor_trained"]
    ac = 10 + dex_mod + (armor_bonus if armor_trained else 0)

    weapon_atk_bonus, weapon_dmg_bonus = WEAPON_ENCHANT[tier["weapon_rarity"]]
    # Skills wachsen ueber die Kampagne dazu (final, 13-katalog-skills.md) --
    # Kanon-Trigger ist eigentlich "10 Kaempfe mit der Waffe ueberlebt"
    # (13-katalog-skills.md); Tool-Vereinfachung, weil dieses Tool keine
    # Fights zaehlt: ab Tier 2 (~20h gespielt) als Naeherung dafuer behandelt
    weapon_trained = prof["weapon_trained"] or tier_idx >= 2
    atk_bonus = primary_mod + (2 if weapon_trained else 0) + weapon_atk_bonus  # +2 = Waffenkunde-Skillbonus

    if prof["caster"] and tier["max_spell_rank"] != "Cantrip":
        # Zauberschaden ersetzt den Waffenschaden als Hauptangriff
        n, sides = SPELL_DICE_BY_RANK[tier["max_spell_rank"]]
        dmg = (n, sides, primary_mod)
    else:
        wn, wsides, wname = prof["weapon"]
        dmg = (wn, wsides, primary_mod + weapon_dmg_bonus)

    dmg_avg = dice_avg(*dmg)
    si = compute_si(hp, ac, atk_bonus, dmg_avg, tier="Standard")

    return Combatant(
        name=f"{prof['name']} ({tier['name']})",
        hp=hp, max_hp=hp, ac=ac, atk_bonus=atk_bonus, dmg=dmg, side="PC",
        weapon_untrained=not weapon_trained,
        meta={"profession": prof["name"], "tier": tier["name"], "si": si},
    )

# Typische Einzel-SI pro Tier (Anker fuer "wie stark ist ein Exemplar dieser
# Stufe normalerweise" -- aus den echten Bestiarium-Werten in 16-katalog-
# bestiarium.md grob abgeleitet: Fodder ~1-3, Standard ~4-6, Boss ~8-11).
TIER_BASELINE_SI = {"Fodder": 2, "Standard": 5, "Boss": 9}
TIER_DMG_DICE = {"Fodder": (1, 6), "Standard": (1, 10), "Boss": (1, 12)}

def generate_monster(tier, si_target, idx, power_scale=0.25):
    """Verteilt das SI-Budget eines generischen Monsters nicht nur auf HP,
    sondern anteilig auch auf AC/Angriff/Schaden: ein Exemplar mit deutlich
    ueberdurchschnittlichem Einzel-SI (z. B. weil wenige Einheiten sich ein
    grosses Budget teilen) ist nicht nur eine HP-Sponge, sondern trifft auch
    haerter/praeziser -- sonst wird "wenige, dicke Fodder" faelschlich immer
    ungefaehrlich, egal wie viel SI man ihnen gibt (siehe Tuning-Notizen)."""
    mid = TIER_MID[tier]
    excess = si_target - TIER_BASELINE_SI[tier]
    ac = round(mid["ac"] + power_scale * excess)
    atk = round(mid["atk"] + power_scale * excess)
    n, sides = TIER_DMG_DICE[tier]
    dmg_mod = round(power_scale * excess)
    dmg = (n, sides, dmg_mod)
    dmg_avg = dice_avg(*dmg)
    dev = ((ac - mid["ac"]) + (atk - mid["atk"]) + (dmg_avg - mid["dmg"])) / 3
    hp = max(1, round(3 * (si_target - dev)))
    return Combatant(
        name=f"{tier}-{idx}", hp=hp, max_hp=hp, ac=ac, atk_bonus=atk, dmg=dmg,
        side="Monster", meta={"tier": tier, "si": si_target},
    )

# ---------------------------------------------------------------------------
# Gruppen-Multiplikator: mehr Gegner = mehr Angriffe/Runde = mehr Gefahr,
# unabhaengig vom aufsummierten SI (Action Economy). Analog zum "Multiplying
# Factor" aus D&D 5e DMG, hier als tunbare Tabelle. Der Gesamt-SI eines
# Encounters wird VOR dem Verteilen auf die einzelnen Gegner durch den
# Multiplikator geteilt -- je mehr Gegner, desto weniger SI "Budget" pro Kopf.
# ---------------------------------------------------------------------------

# Getunt (siehe Tuning-Notizen unten): leichte Anhebung fuer sehr kleine
# Gruppen (1-2 Einheiten haben sonst zu viel Party-Fokusfeuer-Vorteil) und
# leichte Abwertung fuer grosse Schwaerme (7+), dazwischen fast neutral.
MULTIPLIER_TABLE = [
    (1, 0.9), (2, 0.95), (3, 1.0), (4, 1.05), (6, 1.1), (10, 1.35), (999, 1.6),
]

def get_multiplier(n_units, table=None):
    table = table or MULTIPLIER_TABLE
    for threshold, mult in table:
        if n_units <= threshold:
            return mult
    return table[-1][1]

# ---------------------------------------------------------------------------
# Gegner-Rezepte: 10 verschiedene Zusammenstellungen bei gleichem Gesamt-SI.
# Jedes Rezept ist eine Liste von (Tier, Anzahl-oder-Funktion, SI-Gewichtsanteil).
# ---------------------------------------------------------------------------

RECIPE_SPECS = [
    ("10x Fodder",             [("Fodder", 10, 1.0)]),
    ("6x Fodder",              [("Fodder", 6, 1.0)]),
    ("4x Fodder (stark)",      [("Fodder", 4, 1.0)]),
    ("Alle Standard (~T/4.5)", [("Standard", lambda t: max(1, round(t / 4.5)), 1.0)]),
    ("3x Standard",            [("Standard", 3, 1.0)]),
    ("1 Boss allein",          [("Boss", 1, 1.0)]),
    ("1 Boss + 3 Fodder",      [("Boss", 1, 0.6), ("Fodder", 3, 0.4)]),
    ("1 Boss + 2 Standard",    [("Boss", 1, 0.5), ("Standard", 2, 0.5)]),
    ("2 Standard + 4 Fodder",  [("Standard", 2, 0.5), ("Fodder", 4, 0.5)]),
    ("2 Boss (halbe Staerke)", [("Boss", 2, 1.0)]),
]

def build_encounter(total_si, spec, mult_table=None):
    resolved = [(tier, (n(total_si) if callable(n) else n), weight) for tier, n, weight in spec]
    n_total = sum(n for _, n, _ in resolved)
    mult = get_multiplier(n_total, mult_table)
    effective_total = total_si / mult
    monsters = []
    for tier, n, weight in resolved:
        per_unit = (effective_total * weight) / n
        monsters.extend(generate_monster(tier, per_unit, i) for i in range(n))
    return monsters

RECIPES = [(name, (lambda t, spec=spec: build_encounter(t, spec))) for name, spec in RECIPE_SPECS]

# ---------------------------------------------------------------------------
# Kampf-Simulation
# ---------------------------------------------------------------------------

def simulate_fight(pcs, monsters, max_rounds=50):
    combatants = [Combatant(**vars(c)) for c in pcs] + [Combatant(**vars(c)) for c in monsters]
    rounds = 0
    while rounds < max_rounds:
        alive_pc = [c for c in combatants if c.side == "PC" and c.alive]
        alive_mon = [c for c in combatants if c.side == "Monster" and c.alive]
        if not alive_pc or not alive_mon:
            break
        rounds += 1
        order = [c for c in combatants if c.alive]
        random.shuffle(order)
        for c in order:
            if not c.alive:
                continue
            enemies = [e for e in combatants if e.side != c.side and e.alive]
            if not enemies:
                break
            target = random.choice(enemies)
            adv = -1 if (c.side == "PC" and c.weapon_untrained) else 0
            hit, crit = attack_roll(c.atk_bonus, target.ac, adv=adv)
            if hit:
                dmg = roll_dice(*c.dmg)
                if crit:
                    dmg *= 2
                target.hp -= dmg

    pc_alive = [c for c in combatants if c.side == "PC" and c.alive]
    mon_alive = [c for c in combatants if c.side == "Monster" and c.alive]
    party_won = bool(pc_alive) and not mon_alive
    return {
        "won": party_won,
        "rounds": rounds,
        "survivors": len(pc_alive),
        "survivor_hp_pct": [max(0, c.hp) / c.max_hp for c in combatants if c.side == "PC"],
    }

# ---------------------------------------------------------------------------
# Hauptlauf: 10 Parteien x 10 Rezepte x 10 Kaempfe = 1000 Kaempfe
# ---------------------------------------------------------------------------

def run_simulation(n_teams=10, fights_per_recipe=10, seed=None):
    if seed is not None:
        random.seed(seed)

    results = []
    for team_idx in range(n_teams):
        pcs = [generate_pc(random.randrange(len(EXPERIENCE_TIERS))) for _ in range(3)]
        total_si = sum(pc.meta["si"] for pc in pcs)

        for recipe_name, recipe_fn in RECIPES:
            for fight_idx in range(fights_per_recipe):
                monsters = recipe_fn(total_si)
                outcome = simulate_fight(pcs, monsters)
                results.append({
                    "team": team_idx,
                    "party_si": total_si,
                    "professions": [pc.meta["profession"] for pc in pcs],
                    "tiers": [pc.meta["tier"] for pc in pcs],
                    "recipe": recipe_name,
                    **outcome,
                })
    return results

def summarize(results):
    print(f"Gesamt: {len(results)} Kaempfe\n")

    overall_wr = sum(r["won"] for r in results) / len(results)
    print(f"Gesamt-Gewinnrate der Parteien: {overall_wr*100:.1f}%\n")

    print("--- Gewinnrate nach Gegner-Zusammenstellung (gleicher Gesamt-SI) ---")
    by_recipe = defaultdict(list)
    for r in results:
        by_recipe[r["recipe"]].append(r)
    for name, _ in RECIPES:
        rs = by_recipe[name]
        wr = sum(r["won"] for r in rs) / len(rs)
        avg_rounds = statistics.mean(r["rounds"] for r in rs)
        avg_surv = statistics.mean(r["survivors"] for r in rs)
        print(f"  {name:24s} Gewinnrate={wr*100:5.1f}%  Ø-Runden={avg_rounds:4.1f}  Ø-Ueberlebende={avg_surv:.2f}/3")

    print("\n--- Gewinnrate nach Erfahrungsstufe (Durchschnitt der 3 PC-Stufen im Team) ---")
    tier_names = [t["name"] for t in EXPERIENCE_TIERS]
    by_tier_mix = defaultdict(list)
    for r in results:
        idxs = [tier_names.index(t) for t in r["tiers"]]
        avg_idx = round(statistics.mean(idxs))
        by_tier_mix[tier_names[avg_idx]].append(r)
    for name in tier_names:
        rs = by_tier_mix.get(name, [])
        if not rs:
            continue
        wr = sum(r["won"] for r in rs) / len(rs)
        print(f"  {name:20s} n={len(rs):4d}  Gewinnrate={wr*100:5.1f}%")

    print("\n--- Ueberlebende & verbleibende HP ---")
    survivor_counts = [r["survivors"] for r in results]
    print(f"  Ø-Ueberlebende pro Kampf: {statistics.mean(survivor_counts):.2f} / 3")
    print(f"  Anteil TPK (0 Ueberlebende): {sum(1 for s in survivor_counts if s == 0) / len(results)*100:.1f}%")
    print(f"  Anteil alle 3 ueberlebt:     {sum(1 for s in survivor_counts if s == 3) / len(results)*100:.1f}%")
    all_hp_pct = [p for r in results for p in r["survivor_hp_pct"] if p > 0]
    if all_hp_pct:
        print(f"  Ø-HP% der Ueberlebenden: {statistics.mean(all_hp_pct)*100:.1f}%")
        print(f"  Median-HP% der Ueberlebenden: {statistics.median(all_hp_pct)*100:.1f}%")

    print("\n--- Party-SI-Streuung ueber die 10 Teams ---")
    team_sis = sorted(set(r["party_si"] for r in results))
    print(f"  Min={min(team_sis):.1f}  Max={max(team_sis):.1f}  Werte={[round(s,1) for s in team_sis]}")

    print("\n--- Profession-Haeufigkeit ---")
    prof_counts = defaultdict(int)
    for r in results:
        for p in r["professions"]:
            prof_counts[p] += 1
    for p, c in sorted(prof_counts.items(), key=lambda x: -x[1]):
        print(f"  {p:16s} {c:4d}x")

if __name__ == "__main__":
    results = run_simulation(n_teams=10, fights_per_recipe=10, seed=42)
    summarize(results)
