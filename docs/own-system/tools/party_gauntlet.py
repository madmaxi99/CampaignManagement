#!/usr/bin/env python3
"""
10 fest zusammengestellte 3-PC-Parteien (statt zufaellig gewuerfelter)
laufen durch dieselbe 10-Encounter-Probekampagne aus campaign_simulator.py.
Jede Partei wird mehrfach durchgespielt (Wuerfel bleiben zufaellig), damit man
pro Partei eine stabile Erfolgsquote sieht statt eines einzelnen Zufallslaufs.

Beantwortet nebenbei zwei Rueckfragen:
  - Werden Zauber "gemacht"? Ja -- Caster-Professionen (Magier, Kleriker,
    Heiler, Kultist) greifen mit ihrem staerksten bekannten Zauber an statt
    mit einer Waffe (Schaden skaliert mit der Erfahrungsstufe: Cantrip -> R1
    -> R2 -> R3, siehe SPELL_DICE_BY_RANK in balance_simulator.py). Das ist
    aber eine Vereinfachung: kein Mana-Verbrauch, keine Utility-Zauber, immer
    "staerkste Option" -- fuer echte Mana-Erschoepfung siehe TODO unten.
  - Wie lang sind Kampfrunden? Siehe Rundenzahlen im Report -- plus eine
    grobe Echtzeit-Hochrechnung am Ende.
"""

import random
import statistics
from collections import defaultdict

import campaign_simulator as camp

def generate_pc_forced(tier_idx, profession_name, name_suffix=""):
    return camp.generate_pc_v2(tier_idx, profession_name=profession_name, name_suffix=name_suffix)

# tier_idx: 0=Frisch, 1=~10h, 2=~20h, 3=~30h/legendaer
PARTIES = [
    ("1. Die Frischlinge",       [("Soldat", 0), ("Wildnisläufer", 0), ("Magier", 0)]),
    ("2. Halbjahres-Crew",       [("Söldner", 1), ("Jäger/Trapper", 1), ("Kleriker", 1)]),
    ("3. Erfahrene Truppe",      [("Elitegardist", 2), ("Dieb/Schurke", 2), ("Magier", 2)]),
    ("4. Die Veteranen",         [("Soldat", 3), ("Wildnisläufer", 3), ("Kleriker", 3)]),
    ("5. Frontkämpfer-Trio",     [("Soldat", 0), ("Söldner", 1), ("Elitegardist", 2)]),
    ("6. Zauber-Trio",           [("Magier", 1), ("Kleriker", 1), ("Kultist", 1)]),
    ("7. Glücksritter (Mix)",    [("Wildnisläufer", 1), ("Barde", 2), ("Heiler", 0)]),
    ("8. Einsame Wölfe (DEX)",   [("Dieb/Schurke", 1), ("Söldner", 1), ("Mönch/Asket", 1)]),
    ("9. Tank & schwaches Glied",[("Elitegardist", 3), ("Heiler", 2), ("Bauer", 0)]),
    ("10. Reich, aber ungeübt",  [("Bauer", 3), ("Barde", 3), ("Dieb/Schurke", 3)]),
]

def build_party(spec):
    return [generate_pc_forced(tier, prof, f"#{i}") for i, (prof, tier) in enumerate(spec)]

def run_gauntlet(n_reps=30, seed=42):
    if seed is not None:
        random.seed(seed)
    results = {}
    for party_name, spec in PARTIES:
        template = build_party(spec)
        total_si = sum(pc.meta["si"] for pc in template)
        logs = []
        for _ in range(n_reps):
            pcs = build_party(spec)  # frisch gewuerfelt (Attribute), gleiche Professionen/Stufen
            logs.append(camp.run_campaign_for_party(pcs))
        results[party_name] = {"template": template, "si": total_si, "logs": logs}
    return results

def furthest_encounter_index(log):
    non_skipped = [e for e in log if not e["skipped"]]
    return len(non_skipped)

def summarize_gauntlet(results):
    print(f"10 feste Parteien, je {len(next(iter(results.values()))['logs'])}x durch die Probekampagne geschickt\n")

    all_rounds = []
    caster_hits = defaultdict(int)

    for party_name, data in results.items():
        template = data["template"]
        roster = ", ".join(f"{pc.meta['profession']} ({pc.meta['kin']}, {pc.meta['tier']}, SI {pc.meta['si']})" for pc in template)
        logs = data["logs"]
        n = len(logs)
        reached = [furthest_encounter_index(log) for log in logs]
        all_alive_end = sum(1 for log in logs if log[-1]["survivors"] == 3 and not log[-1]["skipped"])
        any_alive_end = sum(1 for log in logs if log[-1]["survivors"] > 0)
        endboss_won = sum(1 for log in logs if len(log) == 10 and not log[9]["skipped"] and log[9]["won"])
        for log in logs:
            for e in log:
                if not e["skipped"]:
                    all_rounds.append(e["rounds"])

        print(f"{party_name}")
        print(f"  Party: {roster}  [Gesamt-SI {data['si']}]")
        print(f"  Ø erreichte Encounter: {statistics.mean(reached):.1f}/10  "
              f"Endboss besiegt: {endboss_won}/{n} ({endboss_won/n*100:.0f}%)  "
              f"Kampagne ueberlebt (>=1 PC am Ende): {any_alive_end}/{n} ({any_alive_end/n*100:.0f}%)  "
              f"Alle 3 am Ende: {all_alive_end}/{n} ({all_alive_end/n*100:.0f}%)")
        print()

    print("--- Rundenlaenge (ueber alle Parteien/Encounter) ---")
    print(f"  Ø Runden pro Kampf: {statistics.mean(all_rounds):.1f}   "
          f"Median: {statistics.median(all_rounds):.1f}   Max: {max(all_rounds)}")
    # grobe Echtzeit-Hochrechnung: ~3 Akteure PC + ~3 Akteure Monster im Schnitt,
    # pro Akteur-Zug am Tisch grob 20-30 Sekunden (ansagen, Wuerfeln, Schaden abziehen)
    avg_actors_per_round = 5  # 3 PC + ~2 lebende Gegner im Schnitt (Gegner sterben im Verlauf)
    seconds_per_turn = 25
    avg_seconds = statistics.mean(all_rounds) * avg_actors_per_round * seconds_per_turn
    print(f"  Grobe Echtzeit-Hochrechnung: {avg_actors_per_round} Akteure/Runde x ~{seconds_per_turn}s/Zug "
          f"-> ~{avg_seconds/60:.1f} Minuten fuer einen durchschnittlichen Kampf am Tisch")

if __name__ == "__main__":
    results = run_gauntlet(n_reps=30, seed=42)
    summarize_gauntlet(results)
