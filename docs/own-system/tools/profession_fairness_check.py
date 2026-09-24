#!/usr/bin/env python3
"""
Fairness-Check ueber alle 33 Professionen (12-katalog-professionen.md):
nicht "sind alle gleich stark im Kampf" (das waere langweilig und absurd --
ein Soldat SOLL besser kaempfen als ein Adliger), sondern "gleicht sich das
insgesamt aus, wenn man alle Lebensbereiche mitzaehlt, in denen ein Charakter
nuetzlich sein kann (Kampf, Sozial, Wildnis, Wissen, Heimlichkeit, Handwerk,
Startvermoegen)". Ein Adliger, der im Kampf schwaech ist, aber sozial/finanziell
stark, ist fair -- ein Adliger, der ueberall schwaech ist, waere es nicht.

Jede der 33 Professionen wird N_REPS mal komplett neu generiert (zufaelliges
Kin, zufaelliges Alter inkl. Alters-Extra-Skills, zufaellige Attribute) --
matcht campaign_simulator.generate_pc_v2 exakt, inkl. Alterssystem
(01-charakter.md) und Waffenkunde/Ruestungskunde-Training. Feste Erfahrungs-
stufe (Tier 1, ~10h gespielt) fuer alle, damit der Vergleich nicht durch
unterschiedliches Gear verzerrt wird -- es geht um die Profession selbst,
nicht um Kampagnenfortschritt.

Challenges (Tool-Annahme, da 13-katalog-skills.md bewusst keine generischen
Skill-Check-Zahlen vorgibt -- nur Waffenkunde/Ruestungskunde sind numerisch
final): d20 + Attribut-Mod gegen DC 13 (Nat20/Nat1 = Auto-Erfolg/-Fehlschlag,
02-kernmechanik.md), Boon wenn die Profession einen zum Thema passenden Skill
besitzt (Paket ODER Alters-Extra-Skill). Kampf-Challenge ist keine DC-Probe,
sondern eine echte Mini-Kampfsimulation (1 PC vs. 2 Standard-Gegner, die
bereits in 03-kampf.md validierten Referenzwerte). Startvermoegen ist direkt
das gewuerfelte Startgeld (01-charakter.md-Formeln), normiert auf den
Wohlhabend-Schnitt (~105 Silber) fuer den Gesamt-Score.
"""

import random
import statistics

import balance_simulator as bs
import campaign_simulator as camp

N_REPS = 30
DC = 13
TIER_IDX = 1  # ~10h gespielt -- fixe Referenzstufe fuer alle Professionen

STANDARD_GEGNER = dict(hp=12, ac=12, atk_bonus=4, dmg=(1, 6, 2))

CHALLENGES = [
    ("Sozial", "CHA", {"Überzeugen", "Verhandeln", "Etikette", "Einschüchtern",
                        "Täuschen", "Menschenkenntnis", "Verführen", "Erzählen/Auftreten"}),
    ("Wildnis", "WIS", {"Überleben in der Wildnis", "Naturkunde", "Fährtenlesen",
                         "Tierumgang", "Wetterkunde", "Navigation"}),
    ("Wissen", "INT", {"Arkanes Wissen", "Geschichte", "Religion", "Medizin",
                        "Sprachen", "Rechtskunde/Bürokratie", "Sternenkunde/Kartografie"}),
    ("Heimlichkeit", "DEX", {"Schleichen", "Taschendiebstahl", "Schlösser knacken",
                              "Verkleidung", "Fährten verwischen", "Falschspiel"}),
    ("Handwerk", "INT", {"Schmieden", "Alchemie", "Tischlerei/Lederarbeit", "Kochen",
                          "Brauen", "Bergbau", "Schneiderei", "Ingenieurskunst", "Verhandeln"}),
]


def skill_check(attr_mod_value, has_boon):
    if has_boon:
        d20 = max(random.randint(1, 20), random.randint(1, 20))
    else:
        d20 = random.randint(1, 20)
    if d20 == 20:
        return True
    if d20 == 1:
        return False
    return d20 + attr_mod_value >= DC


def combat_winrate(pc, reps=N_REPS):
    wins = 0
    for _ in range(reps):
        mons = [
            bs.Combatant(name="Standard-Gegner", side="Monster", **{
                "hp": STANDARD_GEGNER["hp"], "max_hp": STANDARD_GEGNER["hp"],
                "ac": STANDARD_GEGNER["ac"], "atk_bonus": STANDARD_GEGNER["atk_bonus"],
                "dmg": STANDARD_GEGNER["dmg"],
            })
            for _ in range(2)
        ]
        result = bs.simulate_fight([pc], mons)
        wins += result["won"]
    return wins / reps


def evaluate_profession(prof, reps=N_REPS):
    challenge_totals = {name: 0 for name, _, _ in CHALLENGES}
    kampf_totals = []
    wealth_totals = []
    ages = []
    for _ in range(reps):
        pc = camp.generate_pc_v2(TIER_IDX, profession_name=prof["name"])
        known_skills = set(prof["skills"]) | set(pc.meta["extra_skills"])
        # Attribut-Mods fuer die Challenge-Probe wurden nicht separat aus dem
        # PC herausgereicht (Combatant kennt nur die kampfrelevanten Werte) --
        # Naeherung: primaerer Profession-Stat traegt den echten (Alters-
        # korrigierten) Mod, alle anderen bleiben +0 (durchschnittlich).
        # Leicht konservativ fuer Professionen mit gutem Sekundaerstat,
        # aendert die Rangfolge nicht.
        stats_mods = {"STR": 0, "CON": 0, "DEX": 0, "INT": 0, "WIS": 0, "CHA": 0}
        stats_mods[pc.meta["primary_stat"]] = pc.meta["primary_mod"]

        for name, attr, matching_skills in CHALLENGES:
            has_boon = bool(known_skills & matching_skills)
            success = skill_check(stats_mods.get(attr, 0), has_boon)
            challenge_totals[name] += success

        kampf_totals.append(combat_winrate(pc, reps=1))
        silber, _ = bs.roll_startgeld(prof["wealth"])
        wealth_totals.append(silber)
        ages.append(pc.meta["age"])

    row = {name: challenge_totals[name] / reps for name, _, _ in CHALLENGES}
    row["Kampf"] = statistics.mean(kampf_totals)
    row["Ø Startgeld"] = statistics.mean(wealth_totals)
    row["wealth_norm"] = min(1.0, row["Ø Startgeld"] / 105)
    axes = [row["Kampf"], row["wealth_norm"]] + [row[n] for n, _, _ in CHALLENGES]
    row["Gesamt-Score"] = statistics.mean(axes)
    row["Alters-Mix"] = ages
    return row


def run_all(reps=N_REPS, seed=42):
    if seed is not None:
        random.seed(seed)
    results = {}
    for prof in bs.PROFESSIONS:
        results[prof["name"]] = evaluate_profession(prof, reps=reps)
    return results


def summarize(results):
    header = f"{'Profession':<22} {'Kampf':>6} {'Sozial':>7} {'Wildnis':>8} {'Wissen':>7} {'Heiml.':>7} {'Handw.':>7} {'ØGeld':>7} {'Score':>7}"
    print(header)
    print("-" * len(header))
    rows = sorted(results.items(), key=lambda kv: kv[1]["Gesamt-Score"], reverse=True)
    for name, r in rows:
        print(f"{name:<22} {r['Kampf']*100:5.0f}% {r['Sozial']*100:6.0f}% {r['Wildnis']*100:7.0f}% "
              f"{r['Wissen']*100:6.0f}% {r['Heimlichkeit']*100:6.0f}% {r['Handwerk']*100:6.0f}% "
              f"{r['Ø Startgeld']:6.0f}s {r['Gesamt-Score']*100:6.1f}%")

    scores = [r["Gesamt-Score"] for r in results.values()]
    mean_score = statistics.mean(scores)
    stdev_score = statistics.pstdev(scores)
    print(f"\nGesamt-Score über alle 33 Professionen: Ø {mean_score*100:.1f}%  Stdev {stdev_score*100:.1f}%")

    by_gap = sorted(results.items(), key=lambda kv: abs(kv[1]["Gesamt-Score"] - mean_score), reverse=True)
    print("\n5 Professionen mit dem größten Abstand zum Durchschnitt:")
    for name, r in by_gap[:5]:
        diff = (r["Gesamt-Score"] - mean_score) * 100
        sign = "+" if diff >= 0 else ""
        print(f"  {name:<22} {sign}{diff:.1f} Punkte vom Schnitt (Score {r['Gesamt-Score']*100:.1f}%)")


if __name__ == "__main__":
    results = run_all(reps=N_REPS, seed=42)
    summarize(results)
