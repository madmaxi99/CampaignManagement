#!/usr/bin/env python3
"""
Kalibrierung fuer einen kuenftigen Encounter-Generator: nicht mehr "teste die
eine Beispiel-Kampagne", sondern "finde robuste Rand-Bedingungen fuer Leicht/
Mittel/Schwer/Endboss, die ueber verschiedene Partygroessen (N) und Erfahrungs-
stufen hinweg halten". Ziel-Output eines spaeteren Generators: "3 Leute,
mittlere Gegner bitte" -> eine passende Monster-Liste.

Design-Prinzip (User-Vorgabe): Endboss-Kaempfe sind ABSICHTLICH im direkten
Kampf kaum zu gewinnen -- die vorgesehene Loesung ist Verhandlung/Schwachstelle
finden/austricksen, nicht Dauerfeuer. Eine niedrige Gewinnrate selbst fuer die
staerkste (Veteranen-)Party ist hier also ein Feature, kein Bug. Trotzdem wird
NICHT einfach nur HP hochskaliert -- alle Achsen (Anzahl/Typ der Gegner, AC,
Angriffsbonus, Moves/Ultimate-Nutzung, sogar PC-Waffen/Zauberschaden) werden
gemeinsam betrachtet, wie es ein Encounter-Designer tun wuerde.

Alle Kaempfe hier sind EINZELNE, unabhaengige Encounter (keine Kampagnen-
Sequenz mit Attrition zwischen Kaempfen) -- das ist die richtige Betriebsart
fuer einen Encounter-Generator, der pro Anfrage einen einzelnen Kampf liefert.
"""

import random
import statistics
from collections import defaultdict

import balance_simulator as bs
import campaign_simulator as camp
from campaign_simulator import (
    generate_pc_v2, simulate_fight_with_death,
    GOBLIN_PLUENDERER, WACHOFFIZIER, ELITEGARDIST, ORK_HORDENFUEHRER, FROSTRIESE,
    dmg_move, util_move, ult_move, mk,
)

# ---------------------------------------------------------------------------
# Generische Encounter-Bausteine (Stellvertreter fuer "irgendein Fodder/
# Standard/Boss", nicht an eine bestimmte Kreatur gebunden). WACHOFFIZIER
# dient als "schwacher Standard" (Leicht), ELITEGARDIST als "starker Standard"
# (Mittel/Schwer-Baustein) -- empirisch bestaetigt: 3x Elitegardist vs. eine
# 3er-Party lag im Vortest bei ~63-66%, passend fuer die Mittel-Zielspanne.
# ---------------------------------------------------------------------------

FODDER      = GOBLIN_PLUENDERER   # HP 3,  AC 10, Angriff +2, 1 Move
WEAK_STD    = WACHOFFIZIER        # HP 12, AC 12, Angriff +4, 2 Moves
STANDARD    = ELITEGARDIST        # HP 18, AC 13, Angriff +7, 2 Moves
BOSS        = ORK_HORDENFUEHRER   # HP 30, AC 14, Angriff +7, 3 Moves inkl. Ultimate

# "Endboss": bewusst nicht nur hochskaliertes HP, sondern auf allen Achsen
# staerker als ein normaler Boss -- hoehere AC (schwerer zu treffen), hoeherer
# Angriffsbonus (trifft zuverlaessiger), zusaetzlicher AOE-Ultimate, und ein
# zweiter Move-Damage-Wert oberhalb der sonst hoechsten Boss-Werte.
ENDBOSS = mk(
    "Endboss", hp=42, ac=17, atk=9,
    moves=[
        dmg_move("Wucht-Schlag", (1, 12, 3)),
        dmg_move("Zweit-Angriff", (1, 10, 2)),
        ult_move("Verheerung", "aoe_dmg", dmg=(2, 12, 3)),
    ],
    tags={"Gross"},
)

def buff_for_tier(monsters, tier):
    """Erfahrungsstufe (0-3) skaliert NICHT die Anzahl (das macht die Encounter-
    Groesse instabil/unrealistisch), sondern die Qualitaet der Gegner: +1 AC
    und +1 Angriffsbonus pro Stufe -- kontinuierlich statt Ganzzahl-Sprünge,
    und inhaltlich vertretbar (staerkere Ausruestung/Ausbildung dieser
    Gegnergruppe fuer eine erfahrenere Party)."""
    for m in monsters:
        m.ac += tier
        m.atk_bonus += tier
    return monsters

def build_encounter(difficulty, party_size, tier=1):
    n = party_size
    if difficulty == "Leicht":
        mons = [WEAK_STD(i) for i in range(max(1, n - 1))] + [FODDER(i) for i in range(n)]
    elif difficulty == "Mittel":
        mons = [STANDARD(i) for i in range(n)]
    elif difficulty == "Schwer":
        mons = [BOSS(0)] + [STANDARD(i) for i in range(max(1, n - 1))]
    elif difficulty == "Endboss":
        # bewusst NICHT nach Erfahrungsstufe skaliert -- soll fuer jede Party
        # ungefaehr gleich brutal bleiben, das ist ja der Sinn eines Endbosses,
        # der nicht per Dauerfeuer fallen soll
        return [ENDBOSS(0)] + [STANDARD(i) for i in range(max(0, n - 1))]
    else:
        raise ValueError(difficulty)
    return buff_for_tier(mons, tier)

# ---------------------------------------------------------------------------
# Kalibrierungs-Lauf: fuer jede Partygroesse x Erfahrungsstufe x Schwierigkeit
# ---------------------------------------------------------------------------

def run_calibration(party_sizes=(2, 3, 4, 5), tiers=(0, 1, 2, 3), trials=60, seed=42):
    if seed is not None:
        random.seed(seed)
    results = defaultdict(list)
    for n in party_sizes:
        for tier in tiers:
            for difficulty in ("Leicht", "Mittel", "Schwer", "Endboss"):
                wins = 0
                rounds_list = []
                for _ in range(trials):
                    pcs = [generate_pc_v2(tier) for _ in range(n)]
                    monsters = build_encounter(difficulty, n, tier)
                    won, _, rounds = simulate_fight_with_death(pcs, monsters)
                    wins += won
                    rounds_list.append(rounds)
                results[(n, tier, difficulty)] = (wins / trials, statistics.mean(rounds_list))
    return results

TIER_NAMES = ["Frisch", "~10h", "~20h", "~30h"]

def summarize(results, party_sizes, tiers):
    for difficulty in ("Leicht", "Mittel", "Schwer", "Endboss"):
        print(f"\n=== {difficulty} ===")
        header = "Party" + "".join(f"  {TIER_NAMES[t]:>8s}" for t in tiers)
        print(header)
        for n in party_sizes:
            row = f"N={n}   "
            for t in tiers:
                wr, _ = results[(n, t, difficulty)]
                row += f"  {wr*100:7.1f}%"
            print(row)

if __name__ == "__main__":
    party_sizes = (2, 3, 4, 5)
    tiers = (0, 1, 2, 3)
    results = run_calibration(party_sizes, tiers, trials=60, seed=42)
    summarize(results, party_sizes, tiers)
