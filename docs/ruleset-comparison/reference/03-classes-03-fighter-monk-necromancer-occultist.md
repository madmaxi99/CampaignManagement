# 13th Age Archmage Engine — Classes: Fighter, Monk, Necromancer, Occultist

## Fighter

### Level Progression

| Level | Multiclass | Total Hit Points | Total Feats | Maneuvers Known | Maneuver Pool Available | Class Talents | Level-up Ability Bonuses | Damage Bonus From Ability Score |
|-------|-----------|-------------------|-------------|-----------------|------------------------|---------------|----------------------|--------------------------------|
| 1 | 1 adventurer | (8 + CON mod) x 3 | 3 | 1st level | 3 | Not affected | — | ability modifier |
| — | Multiclass Level 1 | (8 + CON mod) x 3 | 3 | 1st level | 3 | — | — | ability modifier |
| 2 | 2 adventurer | (8 + CON mod) x 4 | 4 | 1st level | 3 | — | — | ability modifier |
| 3 | 3 adventurer | (8 + CON mod) x 5 | 5 | 3rd level | 3 | +1 to 3 abilities | ability modifier |
| 4 | 4 adventurer | (8 + CON mod) x 6 | 6 | 3rd level | 3 | — | ability modifier |
| 5 | 4 adventurer | (8 + CON mod) x 8 | 6 | 5th level | 4 | — | +1 to 3 abilities |
| 6 | 1 champion | (8 + CON mod) x 10 | 6 | 5th level | 4 | — | 2 x ability modifier |
| 7 | 4 adventurer, 2 champion | (8 + CON mod) x 12 | 7 | 7th level | 4 | — | 2 x ability modifier |
| 8 | 4 adventurer, 3 champion | (8 + CON mod) x 16 | 8 | 7th level | 4 | — | 2 x ability modifier |
| 9 | 4 adventurer, 3 champion, 1 epic | (8 + CON mod) x 20 | 8 | 9th level | 4 | +1 to 3 abilities | 3 x ability modifier |
| 10 | 4 adventurer, 3 champion, 2 epic | (8 + CON mod) x 24 | 9 | 9th level | 4 | — | 3 x ability modifier |
| — | 4 adventurer, 3 champion, 3 epic | — | 9 | — | — | — | 3 x ability modifier |

**(M): Indicates columns in which multiclass characters lag one level behind.**

**Fighter weapon attack maneuvers deal damage based on the fighter's level.** You also don't have to keep track of upgrading a 1st level maneuver into a 3rd level maneuver, because all the maneuvers function at your level. You can change which maneuvers you know and have ready whenever you gain a level.

### Stats

| Stat | Value |
|------|-------|
| Ability Bonus | +2 Strength or Constitution (different from racial bonus) |
| Initiative | Dex mod + Level |
| Armor Class (heavy armor) | 15 + middle mod of Con/Dex/Wis + Level |
| Armor Class (shield and heavy armor) | 16 + middle mod of Con/Dex/Wis + Level |
| Physical Defense | 10 + middle mod of Str/Con/Dex + Level |
| Mental Defense | 10 + middle mod of Int/Wis/Cha + Level |
| Hit Points | (8 + Con mod) x Level modifier (see level progression chart) |
| Recoveries | 9 |
| Recovery Dice | (1d10 x Level) + Con mod |
| Backgrounds | 8 points, max 5 in any one background |
| Icon Relationships | 3 points |
| Talents | 3 (see level progression chart) |
| Feats | 1 per Level |

### Basic Attacks

**Melee Attack**
- At-Will
- Target: One enemy
- Attack: Strength + Level vs. AC
- Hit: WEAPON + Strength damage
- Miss: Damage equal to your level

**Ranged Attack**
- At-Will
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: WEAPON + Dexterity damage
- Miss: —

### Class Features

Fighters have two class features: Extra Tough and Threatening.

**Extra Tough**

You start with nine recoveries instead of the usual eight.

- **Adventurer Feat:** Increase your total recoveries by 1.

**Threatening**

Whenever an enemy attempts to disengage from you, it takes a penalty to its check equal to your Dexterity or Constitution modifier, whichever is higher.

The penalty doesn't apply if you are stunned, grabbed, or otherwise incapable of making an opportunity attack.

- **Adventurer Feat:** Whenever an enemy fails to disengage from you, you also deal damage to that enemy equal to your Dexterity or Constitution modifier. At 5th level, damage is double the modifier. At 8th level, it's triple.
- **Champion Feat:** Whenever a non-mook enemy fails to disengage from you, it's vulnerable to your attacks for the rest of the battle.

### Class Talents

Choose three of the following class talents. You get an additional fighter class talent at 6th level.

Fighters have flexible attacks called maneuvers; you roll your attack and then choose which maneuver you want the attack to use. You only get to use one maneuver with each attack, so it's usually best to choose maneuvers with a few different triggering rolls.

**Cleave**

Once per battle, make a fighter melee attack as a free action after one of your melee attacks drops an enemy to 0 hp.

- **Adventurer Feat:** If you have your move action available, you can use it before making your Cleave attack to reach an enemy you are not already engaged with.
- **Champion Feat:** You can use Cleave twice each battle, but only once a round.
- **Epic Feat:** You gain a +4 attack bonus with your Cleave attacks.

**Comeback Strike**

Once per battle as a free action, make another attack with a –2 penalty after your first fighter attack during your turn misses.

- **Adventurer Feat:** You no longer take the –2 penalty to your Comeback Strike attacks.
- **Champion Feat:** Once per day, you can use Comeback Strike twice in a battle.
- **Epic Feat:** You gain a +4 attack bonus with your Comeback Strike attacks.

**Counter-Attack**

Once per round when the escalation die is even and an enemy misses you with a natural odd melee attack roll, you can make a basic melee attack dealing half damage against that enemy as a free action. (The attack can't use any limited abilities or flexible attack maneuvers.)

- **Adventurer Feat:** Your Counter-Attack attack now deals full damage.
- **Champion Feat:** You can use Counter-Attack once per turn instead of once per round (in effect, you're free to Counter-Attack once per enemy turn).
- **Epic Feat:** You can now use Counter-Attack when the escalation die is 3+.

**Deadeye Archer**

Your attacks with d8 ranged weapons (heavy crossbow, longbow) now deal d10 damage per level. Your attacks with d6 ranged weapons (light crossbow, shortbow) now deal d8 damage per level. In addition, your misses with basic ranged attacks deal damage equal to your level.

- **Adventurer Feat:** If you spend a quick action to aim before making a ranged basic attack, add your Dexterity modifier to the damage if you miss.
- **Champion Feat:** Once per battle, expand your crit range with a fighter ranged attack by 4 (usually to 16+) for that attack. Declare you're using this feat power before you roll the attack.
- **Epic Feat:** Your crit range with ranged weapon attacks expands by 1 (usually to 19+).

**Heavy Warrior**

Once per battle while wearing heavy armor, when you are hit by an attack that targets AC, as a free action, you can take half damage from that attack instead.

- **Adventurer Feat:** Once per day, you can use Heavy Warrior twice in a battle (against different attacks).
- **Champion Feat:** You can also use the power against an attack that targets PD.
- **Epic Feat:** Once per day, you can reroll a recharge roll for a magic armor power.

**Power Attack**

Once per battle before you roll an attack, you can declare you're using Power Attack to deal additional damage with that attack roll. If the attack hits, you deal the following additional damage:
- Deal 1d4 additional damage per level if you are using a one-handed weapon.
- Deal 1d6 additional damage per level if you are using a two-handed weapon.

- **Adventurer Feat:** You deal the additional Power Attack damage even if the attack misses.
- **Champion Feat:** One battle per day, you can use Power Attack twice in the battle.
- **Epic Feat:** One-handed weapon damage using Power Attack increases to 1d6 per level; two-handed weapon damage using Power Attack increases to 1d8 per level.

**Skilled Intercept**

Once per round as a free action, roll a normal save (11+) to intercept an enemy who is moving to attack one of your nearby allies. You can pop free from one enemy to move and intercept the attack. If you are engaged with more than one enemy, the others can take opportunity attacks against you.

The moving enemy makes its attack with you as a target instead. If you're wearing heavy armor and the attack hits, you only take half damage.

- **Adventurer Feat:** You can pop free from up to two enemies when using Skilled Intercept.
- **Champion Feat:** You gain a bonus to your Skilled Intercept save equal to the escalation die.
- **Epic Feat:** Enemies can't make opportunity attacks against you during your Skilled Intercept movement.

**Tough as Iron**

Once per battle, you can rally using a quick action instead of a standard action.

- **Adventurer Feat:** Once per day, you can rally twice during a battle as a quick action, without needing to roll a save for the second rally.
- **Champion Feat:** Increase your total number of recoveries by 2.
- **Epic Feat:** When you roll a natural 20 with an attack, you gain an additional use of Tough As Iron this battle.

### 1st Level Maneuvers

**Brace for It**
- Flexible melee attack
- Triggering Roll: Any miss
- Effect: Until the end of your next turn, the first critical hit you take from a melee attack becomes a normal hit instead.
- **Adventurer Feat:** Brace for it now works against a critical hit from any type of attack.
- **Champion Feat:** Brace for it works against any number of critical hits before your next turn.

**Carve an Opening**
- Flexible melee attack
- Triggering Roll: Any natural odd roll
- Effect: Your crit range with melee attacks expands by a cumulative +1 this battle until you score a melee critical hit. When you score a melee critical hit, your crit range drops back to normal.
- **Champion Feat:** The crit range bonus from carve an opening is +2 instead of +1.

**Deadly Assault**
- Flexible melee or ranged attack
- Triggering Roll: Any natural even hit
- Effect: Reroll any 1s from your damage roll. You're stuck with the rerolls.
- **Adventurer Feat:** Now you can reroll both 1s and 2s with deadly assault.
- **Champion Feat:** Deadly assault now also triggers on a natural 17+.

**Defensive Fighting**
- Flexible melee attack
- Triggering Roll: Natural 16+; if you fight with a shield, also any natural even roll
- Effect: Gain a +2 bonus to AC until the end of your next turn.
- **Adventurer Feat:** You also gain the bonus to Physical Defense.
- **Champion Feat:** The bonus increases to +3.
- **Epic Feat:** You also gain the bonus to Mental Defense.

**Grim Intent**
- Flexible melee attack
- Triggering Roll: Any natural even miss
- Effect: The next time you would deal miss damage with a melee attack, add a WEAPON die to that damage. At 5th level, instead add 2 total WEAPON dice; at 8th level, instead add 3 total WEAPON dice.

**Heavy Blows**
- Flexible melee attack
- Triggering Roll: Any natural even miss
- Effect: You gain a bonus to your miss damage with that attack equal to the escalation die.
- **Champion Feat:** If you attacked with a two-handed weapon, heavy blows can trigger on any miss, odd or even.
- **Epic Feat:** The bonus instead equals double the escalation die with a one-handed weapon, or triple it with a two-handed weapon.

**Precision Attack**
- Flexible melee attack
- Triggering Roll: Any hit with a natural 16+
- Effect: You gain a bonus to the damage roll equal to your Dexterity modifier. At 5th level, the damage bonus increases to double your Dexterity modifier; at 8th level the damage bonus increases to triple it.
- **Adventurer Feat:** You can now use precision attack with a ranged attack.

**Second Shot**
- Flexible ranged attack
- Triggering Roll: Natural 16+
- Effect: After this attack, you can make a basic ranged attack with the same weapon (as long as it's not a weapon that takes a quick action to reload or draw) with a –4 attack penalty. You can't use any maneuvers with the second attack.
- **Champion Feat:** The second shot attack penalty is –2 instead.

**Shield Bash**
- Flexible melee attack
- Special: You must be using a shield.
- Triggering Roll: Any natural even roll
- Effect: The target pops free from you after the attack (does not allow opportunity attacks).
- **Adventurer Feat:** If the target is also engaged with any of your allies, you can have it pop free from them as well.
- **Champion Feat:** Once per battle, you can also daze the target (save ends) of your shield bash attack, if that enemy is staggered.

**Two-Weapon Pressure**
- Flexible melee attack
- Special: You must be using a weapon in each hand.
- Triggering Roll: Any miss
- Effect: Until the end of your next turn, you gain a +2 melee attack bonus against the target.
- **Champion Feat:** The bonus increases to +4.

### 3rd Level Maneuvers

**Hack & Slash**
- Flexible melee attack
- Special: You can use this maneuver only once per round.
- Triggering Roll: Any natural even roll, when the escalation die is 2+
- Effect: Make another melee weapon attack against a different target.

**Make 'em Flinch**
- Flexible ranged attack
- Triggering Roll: Any natural even miss
- Effect: Add the higher modifier from your Strength or Dexterity to the miss damage. At 5th level the damage bonus increases to double your chosen modifier; at 8th level the damage bonus increases to triple it.

**Punish Them**
- Flexible melee attack
- Special: You can use this maneuver only when you make an opportunity attack.
- Triggering Roll: Any hit with a natural 16+
- Effect: The target is dazed until the end of its turn.
- **Adventurer Feat:** If the target was moving, it stops moving and loses the rest of its move action.
- **Champion Feat:** The dazed effect is now save ends.
- **Epic Feat:** The target is now weakened (save ends) instead of dazed.

**Steady Now**
- Flexible melee attack
- Triggering Roll: Any natural even miss
- Effect: You gain temporary hit points equal to your Constitution modifier.
- **Champion Feat:** The temporary hit points increase to double your Constitution modifier.

**Strong Guard**
- Flexible melee attack
- Special: You must be using a shield.
- Triggering Roll: Any miss
- Effect: One ally next to you (including an ally engaged with the same enemy as you) gains a +2 AC bonus until the start of your next turn or until you are no longer next to them.
- **Champion Feat:** Bonus also applies to PD.
- **Epic Feat:** Bonus increases to +3.

### 5th Level Maneuvers

**A Dozen Cuts**
- Flexible melee attack
- Triggering Roll: Any natural even hit
- Effect: The target also takes ongoing damage equal to double your Dexterity modifier, or triple it at 8th level.
- **Champion Feat:** Once per battle, you can trigger a dozen cuts with a natural odd hit.

**Hero's Skill**
- Flexible melee or ranged attack
- Triggering Roll: Any natural even miss
- Effect: Add +2 to the attack roll, then halve any damage dealt by the attack if it hits.
- **Champion Feat:** Add +4 to the attack roll instead of +2.
- **Epic Feat:** The damage is no longer halved on a hit after using hero's skill.

**Sword Master's Anticipation**
- Flexible melee attack
- Special: You must have the Skilled Intercept talent to use this maneuver.
- Triggering Roll: Any natural even roll
- Effect: The next time you use Skilled Intercept this battle, your Skilled Intercept save automatically succeeds.

### 7th Level Maneuvers

**Never Surrender**
- Flexible melee attack
- Triggering Roll: Any natural even roll
- Effect: You can roll a save against a save ends effect.
- **Epic Feat:** You gain a +2 bonus to the save.

**Spinning Charge**
- Flexible melee attack
- Special: You must have moved before the attack.
- Triggering Roll: Any natural even hit
- Effect: After dealing damage, you can pop free from the target, move to a different nearby enemy, and make a basic melee attack against that enemy. You can't use any maneuvers with the second attack, and it deals only half damage.
- **Epic Feat:** If the escalation die is 3+, the second spinning charge attack deals full damage.

**Sword of Destiny**
- Flexible melee attack
- Triggering Roll: Natural 20
- Effect: You can heal using a free recovery.
- **Epic Feat:** If the escalation die is 3+, you can now trigger sword of destiny with a natural 18+.

### 9th Level Maneuvers

**Combat Mastery**
- Flexible melee attack
- Special: You can use this maneuver only once per battle.
- Triggering Roll: Natural 16+
- Effect: Increase the escalation die by 1.
- **Epic Feat:** Combat mastery now also triggers on any natural even hit.

**Set 'em Up**
- Flexible melee attack
- Triggering Roll: Any hit with a natural 16+
- Effect: The crit range of your attacks against the target expands by 3 (generally 17+) until the end of the battle (cumulative).
- **Epic Feat:** The crit range bonus from set 'em up now also applies to any ally who attacks the target while you are engaged with it.

---

## Monk

### Ability Scores

Monks gain a +2 class bonus to two of: Strength, Dexterity, or Wisdom, as long one of them isn't the same ability you increase with your +2 racial bonus.

### Backgrounds

Possible backgrounds include: holy acolyte, mountain sanctuary guardsman, traveling circus acrobat, river guide, spider-cult assassin, tunnel vermin exterminator, bodyguard, farmer, hallucinogenic mushroom farmer, wild mountain ginseng harvester, traveling tournament organizer, civil rights organizer.

### Gear

At 1st level, a monk may start with one or two weapons, a change of clothes, and perhaps a ranged weapon—or none of those.

**Gold Pieces:** Monks may start with either 25 gp or 1d6 x 10 gp.

**Armor**

| Armor Type | Base AC | Atk Penalty |
|-----------|---------|------------|
| None | 11 | — |
| Light | 11 | — |
| Heavy | 12 | -4 |
| Shield | +1 | -2 |

**Melee Weapons**

A monk usually fights with his hands and feet (JAB, PUNCH, and KICK), though if he has traditional weapons from his training, he can use those. When a monk fights with weapons not from his tradition, he uses the fighter's weapon chart with a -2 atk penalty.

**Ranged Weapons**

| Type | Damage |
|------|--------|
| **Thrown** |  |
| Small | 1d4 dagger, star |
| Light or Simple | 1d6 javelin |
| Heavy or Martial | — |
| **Crossbow** |  |
| — | 1d4 (-2 atk) hand crossbow |
| — | 1d6 (-3 atk) light crossbow |
| — | 1d8 (-4 atk) heavy crossbow |
| **Bow** |  |
| — | 1d6 (-2 atk) shortbow |
| — | 1d8 (-3 atk) longbow |

### Level Progression

| Level | Class Talents (M) | Total Feats | Forms (M) | Ki (M) | Level-up Ability Bonuses | Damage Bonus From Ability Score |
|-------|------------------|-----------|----------|--------|----------------------|--------------------------------|
| 1 (As 1st level PC) | 1 or 2 adventurer (3 total) | 4 adventurer | 3 adventurer | 0 + Wis mod | Not affected | ability modifier |
| 1 (Multiclass) | 2 adventurer | 4 adventurer | 3 adventurer, 1 champion | 1 + Wis mod | — | ability modifier |
| 2 | 1 adventurer | 4 adventurer | 3 adventurer, 1 champion | 2 + Wis mod | — | ability modifier |
| 3 | 3 adventurer | 4 adventurer, 1 champion | 2 adventurer, 2 champion | 2 + Wis mod | +1 to 3 abilities | ability modifier |
| 4 | 2 adventurer | 4 adventurer, 2 champion | 2 adventurer, 2 champion | 2 + Wis mod | — | ability modifier |
| 5 | 2 adventurer | 4 adventurer, 3 champion | 2 adventurer, 2 champion | 3 + Wis mod | +1 to 3 abilities | 2 x ability modifier |
| 6 | 3 adventurer | 4 adventurer, 3 champion | 2 adventurer, 2 champion, 1 epic | 3 + Wis mod | — | 2 x ability modifier |
| 7 | 2 adventurer | 4 adventurer, 3 champion, 1 epic | 2 adventurer, 2 champion, 1 epic | 3 + Wis mod | +1 to 3 abilities | 2 x ability modifier |
| 8 | 2 adventurer | 4 adventurer, 3 champion, 2 epic | 2 adventurer, 2 champion, 2 epic | 3 + Wis mod | — | 3 x ability modifier |
| 9 | 3 adventurer | 4 adventurer, 3 champion, 3 epic | 2 adventurer, 2 champion, 2 epic | 3 + Wis mod | +1 to 3 abilities | 3 x ability modifier |

**(M): Indicates columns in which multiclass characters lag one level behind.**

### Stats

| Stat | Value |
|------|-------|
| Ability Bonus | +2 Strength, Dexterity, or Wisdom in two scores (different from racial bonus) |
| Initiative | Dex mod + Level |
| Armor Class (no/light armor) | 11 + middle mod of Con/Dex/Wis + Level |
| Physical Defense | 11 + middle mod of Str/Con/Dex + Level |
| Mental Defense | 11 + middle mod of Int/Wis/Cha + Level |
| Hit Points | (7 + Con mod) x Level modifier (see level progression chart) |
| Recoveries | 8 |
| Recovery Dice | (1d8 x level) + Con mod |
| Backgrounds | 8 points, max 5 in any one background |
| Icon Relationships | 3 points (4 at 5th level; 5 at 8th level) |
| Talents | 3 (see level progression chart) |
| Feats | 1 per Level |

### Basic Attacks

**Melee Attack**
- At-Will
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage
- Miss: Damage equal to your level

**Ranged Attack**
- At-Will
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: WEAPON + Dexterity damage
- Miss: —

### Class Features

All monks have attacks dealing JAB, PUNCH, and KICK damage, use forms as the basis of their actions during each round, use ki points, and are considered to fight with two-weapons even when they're just fighting with their fists and feet. They also can take advantage of magical bracers.

**JAB, PUNCH, and KICK Attacks**

Under normal circumstances, melee weapons that are traditional in a monk's style function like special effects for monks. Most monk attacks are rated as JAB, PUNCH, or KICK attacks, in the same sense that most fighter attacks are WEAPON attacks.

- JAB attacks deal 1d6 damage per level.
- PUNCH attacks deal 1d8 damage per level.
- KICK attacks deal 1d10 damage per level.

Monks don't use weapon damage dice unless they are using a non-traditional weapon or a basic ranged attack that is not part of one of their monk forms.

When fighting barehanded, with bracers, or with traditional monk weapons, monks use damage dice based on the form they are attacking with, or PUNCH damage for basic melee attacks. While using a magic weapon, monks add the weapon's attack and damage bonus to their attacks, and they can use that weapon's power(s).

All monk attacks that use Dexterity as the attack stat use Strength as the ability score that determines damage.

**Forms**

When you learn a monk form, you learn all three elements of that form: an opening attack, flow attack, and finishing attack. Each element generally requires a standard action to use.

Your first standard action attack in a battle must be an opening. Your second attack can be a flow attack from any form you know, or it can be another opening. After you use a flow attack, your next monk attack must be a finishing attack from any form you know, or it can be another opening. (You can't use flow attack twice in a row.) After a finishing attack you must start over with an opening on your next standard action. If you do not attack one turn, you must start over with an opening on your next standard action. This form progression applies whether you hit or miss with your attack.

As long as you use the proper element of the form (opening, flow, or finishing attack), you can use an opening, flow, or finishing attack from ANY of the forms you know.

When you use an element of a form, you gain an AC bonus until the start of your next turn. After using an opening attack you gain a +1 bonus to AC. After using a flow attack, you gain a +2 bonus to AC. After using a finishing attack, you gain a +3 bonus to AC. If elven grace or some other power lets you use multiple elements of your forms in a turn, the AC bonuses don't stack but you do get to use the highest bonus.

**Ki**

You gain a number of ki points each day equal to 1 + your Wisdom modifier. You can spend ki to modify the natural result of one of your attack rolls. Ki is a daily resource. When you take a full heal-up, you regain all your ki points. You don't regain ki during a quick rest.

After rolling an attack, you can spend 1 point of ki as a free action to change your attack's natural result by 1, unless that result is a natural 1. The change can be +1 or -1. Spending ki is a free action, but you can only spend 1 point of ki each turn.

- **Adventurer Feat:** You gain 1 additional point of ki each day.
- **Champion Feat:** You can spend as much ki as you like during a turn. You must spend each point of ki on a different attack roll or a different ki power.
- **Epic Feat:** Work with your GM to invent a new ki power related to your one unique thing or some other aspect of your character's story. If the ki power is too good and overshadows your other ki powers, the GM should rule that you can only use it once a day.

**Two-Weapon Fighting**

Since monks are trained to strike with all their limbs, they can always be considered to be fighting with two weapons in melee, even when they're barehanded. The principal advantage of "two-weapon fighting" is that you get to reroll your attack when you roll a natural 2 with a melee attack, sticking with the reroll.

**Bracers as Magic Items**

Monks get magic-weapon style powers from magical bracers. In practice, a monk fighting barehanded looks to bracers for magical advantage. A monk who fights with the monastery's traditional weapons might use bracers or a magical weapon, but a monk wearing magical bracers can't use a magical melee weapon at the same time.

### Adventure Tier Talents

Choose three of the following adventurer-tier class talents. You get an additional monk class talent at 6th level and 9th level.

You are free to take as many of the Seven Deadly Secrets talents as you wish (up to the class limit) but you can only use one of them per battle. You can choose which one just before using it.

**Flurry (Seven Deadly Secrets)**

If you use Flurry in a battle, you can't use any other Deadly Secrets talents that battle.

You gain the following attack:
- Melee attack
- At-Will (once per round), when the escalation die is 3+
- Quick action
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage
- Miss: —

**Ki Power (A Thousand Palms):** You must be engaged with 2 or more enemies to use this power. After making a Flurry attack, you can spend 1 point of ki to make another Flurry attack against a target you have not already attacked with Flurry this turn.

- **Adventurer Feat:** You can now use Flurry when the escalation die is 2+.
- **Champion Feat:** Your Flurry attack now deals damage equal to your level on a miss.
- **Epic Feat:** When the escalation die is 4+, your Flurry attack deals PUNCH + Strength damage instead of JAB + Strength.

**Greeting Fist (Seven Deadly Secrets)**

If you use Greeting Fist in a battle, you can't use any other Seven Deadly Secrets talent that battle.

The first time you make a melee attack against each enemy during a battle (including the first mook of a mob), the target takes 1d8 extra damage on a hit.

- 2nd level monk: 2d6 extra damage.
- 4th level monk: 2d8 extra damage.
- 6th level monk: 4d6 extra damage.
- 8th level monk: 4d10 extra damage.
- 10th level monk: 6d12 extra damage.

**Ki Power (Opening the Death Gate):** When you deal Greeting Fist damage, you can spend 1 point of ki to double that damage (as usual, a crit would then triple that damage).

- **Adventurer Feat:** Once per battle when you miss with your first melee attack against an enemy, you can use Greeting Fist against that enemy later that battle.
- **Champion Feat:** When you successfully disengage from an enemy, that enemy takes damage equal to your level. Popping free doesn't count; the damage only applies when you use the disengage action. (This damage doesn't count as an attack, so if you hadn't attacked that enemy yet, you could still use Greeting Fist on it later.)
- **Epic Feat:** Once per battle, reroll an attack that qualified for Greeting Fist damage.

**Temple Weapon Master (Seven Deadly Secrets)**

If you use Temple Weapon Master in a battle, you can't use any other Seven Deadly Secrets talents that battle.

Once per battle while you're fighting with a weapon or weapons associated with your monastic tradition, you can turn a natural even miss into a hit.

**Ki Power (Supreme Warrior Discipline):** When you use your Temple Weapon Master power, you can spend 1 point of ki to gain a bonus to AC equal to the current escalation die until an attack against AC misses you or until the end of the battle. (The AC bonus increases or decreases as the escalation die increases or decreases.)

- **Adventurer Feat:** The AC bonus from the ki power also applies to your PD. An attack against your PD that misses also ends the bonus.
- **Champion Feat:** When you roll a natural 2 with a monk attack while fighting with your monastic weapons, in addition to the reroll you get from Two-Weapon Fighting, you gain a bonus to the rerolled attack equal to your Strength modifier or your Wisdom modifier.
- **Epic Feat:** One battle per day, the damage dice of your finishing attacks increase by one size (max d12). (For example, d10s become d12s.)

**Diamond Focus**

You gain a +2 bonus to saves while you're not staggered.

In addition, you can go one round without using a monk attack form and still maintain your place in the attack form progression. For example, if you made an opening attack last round but don't attack this round (or with your next standard action) for any reason, even being stunned or unconscious, you can still use a flow attack with your next standard action.

**Ki Power (Diamond Soul):** When you are dazed, weakened, or stunned, you can spend 1 point of ki to make an immediate normal save (11+). If you succeed, the effect ends. If you fail, the condition affects you normally. (This power also works on effects that aren't save ends. It also breaks the stunned rule by letting you use a free action to spend ki.)

- **Adventurer Feat:** You can also use the ki power to save when you're confused or hampered.
- **Champion Feat:** The ki power save is now an easy save (6+).
- **Epic Feat:** You can also use the ki power to save against a last gasp effect (but it doesn't count against your total if you fail).

**Heaven's Arrow**

Unlike other monks, you have no attack penalty with ranged weapons, including thrown weapons, longbows, shortbows, and crossbows. Your basic ranged attacks also deal miss damage equal to your level.

Once per battle when you would make a melee attack as an element of one of your monk forms, you can use a ranged attack against a nearby enemy instead. This attack deals damage according to the JAB/PUNCH/KICK hierarchy that's part of the form rather than WEAPON damage like basic attacks.

**Ki Power (Wind from Heaven):** You can spend 1 point of ki to regain your Heaven's Arrow power when it's expended.

- **Adventurer Feat:** You can now target enemies that are faraway when you use the Heaven's Arrow power. The ranged weapon you're using might have an attack penalty against faraway enemies, but your attack otherwise functions as normal.
- **Champion Feat:** You can now use the Heaven's Arrow power twice per battle.
- **Epic Feat:** You no longer take opportunity attacks when you make ranged attacks while engaged.

**Leaf on Wind**

Once per battle when you use a move action, you can take another move action as a free action.

In addition, if you fall with a wall, tree, or other physical object next to you, you can fall up to 30 feet per level without taking damage. (You slap the surface, catch handholds, and use other maneuvers to slow your descent.)

**Ki Power (Wind's Comrade):** You can spend 1 point of ki during your turn to gain flight until the end of your turn.

- **Adventurer Feat:** You gain a +3 bonus to disengage checks.
- **Champion Feat:** When an enemy makes an attack against you that targets more than one creature, you only take half damage from that attack, hit or miss.
- **Epic Feat:** Roll a normal save at the end of any turn in which you use the ki power. If you succeed, your flight lasts until the end of your next turn. (It's not advisable to count on this working by staying in midair, though you could of course fly next to a wall, counting on your ability to slow your fall as outlined above!)

**Overworld Lineage, aka Phoenix-touched**

If you wish, any time an element of the monk class refers to Wisdom, you can replace that element with a reference to Charisma.

In addition, while you're staggered, when you roll a natural even attack roll, you heal damage equal to your Strength modifier or your Wisdom modifier (double that modifier at 5th level; triple it at 8th level).

**Ki Power (Imperial Phoenix Flare):** Once per day when you are staggered, you can spend 1 point of ki to heal using a recovery. You heal half the hit points you roll for the recovery, and one enemy engaged with you of your choice takes the other half in fire damage.

- **Adventurer Feat:** You can now use this ki power twice per day.
- **Champion Feat:** Once per day after rolling a death save, you can gain +4 bonus to the roll.
- **Epic Feat:** The first time you die after taking this feat, you are resurrected at a place of power like your home monastery or other sanctum between one and four days later, assuming another resurrection doesn't find you first. (This counts against your normal resurrection limit, as normal.)

**Spinning Willow Style**

When a ranged attack or close-quarters attack that targets AC hits you, you can roll a normal save. If you succeed, you take only half damage from the attack.

**Ki Power (The Willow Bends):** You can spend 1 point of ki to turn a failed Spinning Willow Style save into a success.

- **Adventurer Feat:** You can now use Spinning Willow Style to save against ranged attacks and close-quarter attacks that target PD.
- **Champion Feat:** If you roll a natural 18+ on the save, you instead take no damage from the attack and can choose one nearby enemy. It takes one-quarter of the damage as you deflect the attack.
- **Epic Feat:** Spinning Willow Style saves are now easy saves (6+).

### Champion Tier Talents

At 6th level, you gain an additional monk class talent. You can choose to take another adventurer-tier talent, or select from the talents that follow.

**Disciple of the Hidden Flame**

When you gain this talent, choose a class: cleric, sorcerer, or wizard. Each time you take a full heal-up, choose a non-feature spell of your level or lower from that class. You can't choose the same spell twice in a row; you must choose a different option each time you take a full heal-up.

If the spell is at-will, you can cast it in place of a flow attack. If the spell is limited use, you can cast it in place of a finishing attacks. Use your Wisdom as the ability score that determines attack and damage with the spell.

**Ki Power (Gather the Flame):** You can spend 1 point of ki when you cast your Disciple of the Hidden Flame spell to cast it as if you possessed the adventurer-tier and champion-tier feat for that spell, if any. At 8th level, treat the spell like you possessed the epic-tier feat for it, if any, when you spend the ki.

**Improbable Stunt**

Once per battle as a quick action, you can pull off an outrageous improvisational stunt that no one else could manage, with the possible exception of a swashbuckling rogue! The stunt is not itself an attack but it might lead to one.

The outrageous action of your stunt isn't something you have to roll for, even if it would ordinarily require a skill check to pull off, though you'll still have to roll for an attack that follows up your stunt.

**Ki Power (Ludicrous Improbability Maneuver):** You can spend 1 ki point to use Improbable Stunt again this battle.

**Path of the Perfect Warrior**

One battle per day, you can increase your JAB damage dice to d8s, your PUNCH damage dice to d10s, and your KICK damage dice to d12s.

**Ki Power (Perfect Breath):** Once per day when you are healing using a recovery, you can spend 1 point of ki to heal using a second recovery as well. The second recovery is a free.

### Epic Tier Talents

At 9th level, you gain an additional monk class talent. As usual, you can choose a talent from a lower tier, or an epic tier. Epic-tier talents have feats but no associated ki powers.

**Abundant Step**

Once per battle when the escalation die is 1+, you can teleport to a nearby location you can see as a move action.

- **Epic Feat:** You can now teleport to a faraway location you can see.

**Champion of Three Worlds**

When you make a finishing attack, roll an additional d20 (usually two) for the attack roll. Use the result of your choice.

- **Epic Feat:** Once per battle when you make a flow attack, you can roll an additional d20 for the attack roll.

**Procession of the Sun and Moon**

Once per level, while meditating during a quick rest, you can decide that it's time for the start of a new day. You and each of your willing allies can make a hard save (16+). Each character who succeeds regains all spells, powers, hit points, ki, and recoveries as if they had taken a full heal-up and started a new day.

The only character element that does not reset as if it was a new day are your icon relationship rolls and any icon relationships.

- **Epic Feat:** You and each of your allies gain a bonus to the save equal to your Strength modifier or your Wisdom modifier.

### Adventure Tier Forms

**Claws of the Panther**

**Opening Attack (Panther Spins Free)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage, and you can pop free from the target.
- Miss: Damage equal to your level.

**Flow Attack (Cat Cuts between Hounds)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Natural Even Hit: As a hit, plus each enemy engaged with you takes 1d6 damage (2d6 damage at 5th level; 4d6 damage at 8th level).
- Natural Even Miss: Half damage.
- Natural Odd Miss: Damage equal to your level.

**Finishing Attack (Twinned Panther Claw)**
- Melee attack
- Targets: Up to two enemies
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage.
- Natural Even Miss: Half damage.
- Natural Odd Miss: Damage equal to your level.

**Adventurer Feat Ki Power (Predator's Return):** You can spend 1 point of ki when your finishing attack misses all targets to use a flow attack instead of an opening attack with your next standard action—in effect, you get to skip the opening attack of your next form's progression.

**Dance of the Mantis**

**Opening Attack (Springing Mantis Strike)**
- Melee attack
- Special: When you start your turn unengaged, you can move before the attack as part of the standard action for this attack.
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage.

**Flow Attack (The Pincer Whirls Shut)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage, or KICK + Strength damage against large or huge targets.
- Natural Even Hit: As a hit, plus you can roll a disengage check as a free action after the attack.
- Miss: Half damage.

**Finishing Attack (Precise Mantis Kick)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level + 2 vs. AC
- Hit: KICK + Strength damage.
- Natural Even Miss: Your crit range with opening, flow, and finishing attacks expands by 1 until the end of the battle.
- Natural Odd Miss: Damage equal to your level.

**Adventurer Feat Ki Power (The Dance Continues):** You can spend 1 point of ki during your turn to roll a disengage check as free action.

**Dutiful Guardian**

**Opening Attack (One Must Be Free)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage, and one ally engaged with the target can pop free from it.
- Miss: Damage equal to your level.

**Flow Attack (Wind Horse Shakes Mane)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage, and you choose one of the following benefits: you can take a move action as a free action; OR you gain a +4 bonus to PD until the start of your next turn.
- Miss: Half damage.

**Finishing Attack (Temple Lion Stands True)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage.
- Natural Even Hit: As a hit, plus you can rally as a free action unless you have already rallied this battle.
- Natural Even Miss: Half damage.
- Natural Odd Miss: Damage equal to your level.

**Adventurer Feat:** When you intercept an enemy that is moving to attack one of your allies, you gain a +3 bonus to all defenses until the end of that turn (so against that enemy's attacks).

**Original Venom**

**Opening Attack (First Deadly Venom)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage, and if the target is staggered after the attack, it also takes 5 ongoing poison damage.
- Miss: You take damage equal to your level.

**Flow Attack (Second Certain Toxin)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. PD
- Hit: PUNCH + Strength damage.
- Natural Even Hit: As a hit, plus 5 ongoing poison damage.
- Miss: You take damage equal to your level.

**Finishing Attack (Third Poisonous Lesson)**
- Melee attack
- Target: One enemy taking ongoing damage
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage.
- Natural Even Hit: As a hit, plus 10 ongoing poison damage, and if the target has 45 hp points or fewer, it's hampered (save ends both). (The hp threshold also goes up automatically based on your level.)
  - 3rd level monk: 72 hp or fewer.
  - 5th level monk: 108 hp or fewer.
  - 7th level monk: 180 hp or fewer.
  - 9th level monk: 300 hp or fewer.
- Natural Odd Hit: As a hit, plus 5 ongoing poison damage.
- Miss: You take damage equal to your level.

**Adventurer Feat:** You gain resist poison 14+.

**Three Cunning Tricksters**

**Opening Attack (Fox Senses Weakness)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage.
- Natural Even Miss: Half damage.
- Natural Odd Miss: —

**Flow Attack (Monkey Taps the Shoulder)**
- Melee attack
- Special: When you use this attack, you can pop free from one enemy anytime during that turn as a free action.
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Miss: Half damage.

**Finishing Attack (Crane Summons Carp)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage.
- Natural Even Hit: As a hit, plus when an enemy engaged with you targets you with an attack before the start of your next turn, you can deal JAB + Strength damage to it as an interrupt action.
- Miss: Half damage.

**Adventurer Feat Ki Power (The Gift Returns):** When you roll a natural 18+ on a save, you can spend 1 point of ki to transfer the effect/ongoing damage you saved against to an enemy engaged with you (in addition to ending the effect on you). Of course, death saves and last gasp saves are excluded.

**Way of the Metallic Dragon**

**Opening Attack (Bronze Thwarts an Army)**
- Melee attack
- Target: One enemy
- Special: You must be engaged with two enemies to use this attack.
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Miss: Damage equal to your level.

**Flow Attack (Silver Warrior Advances)**
- Melee attack
- Target: One enemy that has more hit points than you
- Attack: Dexterity + Level vs. AC
- Natural Even Hit: PUNCH + Strength damage, and 10 ongoing cold damage.
- Natural Odd Hit: PUNCH + Strength damage, and one of your allies can pop free from the target.
- Miss: Half damage.

**Finishing Attack (General Slays the Hordes)**
- Melee attack
- Targets: Up to two enemies; choose one for the first attack and the other for the second attack
- First Attack: Dexterity + Level vs. AC
  - Hit: KICK + Strength damage.
  - Miss: Damage equal to your level.
- Second Attack: Dexterity + Level vs. AC
  - Hit: PUNCH + Strength fire damage.
  - Miss: Damage equal to your level.

**Adventurer Feat Ki Power (Become the Dragon):** When you drop a non-mook enemy to 0 hp with a finishing attack, you can spend 1 point of ki to gain a second standard action during your next turn. You're gathering power, preparing to unleash havoc, or doing something similar. If for some reason you decide not to take the extra standard action during your next turn, you get the point of ki back, but can't spend any more ki this battle.

### Champion Tier Forms

**Heaven's Thunder**

**Opening Attack (Moon in Storming Sky)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. PD
- Hit: JAB + Strength damage, and each time an enemy attacks you before the start of your next turn, it takes thunder damage equal to twice your level after the attack.

**Flow Attack (Thunder Restores the Balance)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage, and you can roll a save against a save ends effect.
- Natural Even Hit: As a hit, plus you gain a bonus to the save equal to your Wisdom modifier.
- Miss: Half damage.

**Finishing Attack (This Too Was Foreseen)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. PD
- Hit: KICK + Strength thunder damage.
- Natural Even Hit: As a hit, plus one random nearby enemy takes 10 ongoing thunder damage.
- Natural Odd Hit: As a hit, plus after this attack, your crit range expands by 1 until the end of the battle.
- Miss: Half damage.

**Champion Feat:** You can now target a nearby enemy with this too was foreseen.

**Epic Feat:** You now heal 5d10 hp each time you use a finishing attack while staggered.

**Iron Crusader Form**

**Opening Attack (No Retreat)**
- Melee attack
- Special: You can use this opening attack only if you or one of your allies has dropped to 0 hit points or below during this battle.
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Miss: Half damage.

**Flow Attack (No Mercy)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Special: You gain a +4 bonus with this attack when you target a staggered enemy.
- Hit: PUNCH + Strength damage.
- Miss: Damage equal to your level.

**Finishing Attack (No Weakness)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Special: You gain a +4 bonus with this attack when you target an enemy taking ongoing damage.
- Hit: KICK + Strength damage.
- Natural Even Hit: As a hit, plus you gain resist damage 16+ until the start of your next turn.
- Miss: Damage equal to your level.

**Champion Feat:** You can also use the no retreat opening attack if you have been staggered this battle.

**Epic Feat:** One battle per day, your crit range expands by 2 (cumulative) each time you drop a non-mook enemy to 0 hp.

**Rising Phoenix**

**Opening Attack (Rising Phoenix Fist)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. PD
- Hit: JAB + Strength fire damage.
- Natural Even Miss: 5 ongoing fire damage.
- Natural Odd Miss: —

**Flow Attack (Becomes the Pillar of Flame)**
- Melee
- Target: One enemy
- Attack: Dexterity + Level vs. PD
- Hit: PUNCH + Strength fire damage, and you can roll a disengage check as a free action. If you disengage from all enemies, you gain flight until the end of your next turn.
- Miss: Damage equal to your level.

**Finishing Attack (Life Burning Fire Fist)**
- Melee attack
- Target: One enemy that is higher level than you
- Attack: Dexterity + Level vs. PD
- Hit: PUNCH + Strength fire damage.
- Natural Even Hit: As a hit, plus you can heal using a recovery.
- Natural Odd Hit: As a hit, plus you can roll a save against a save ends effect.
- Natural Even Miss: Half damage.
- Natural Odd Miss: —

**Champion Feat:** Once per day as a free action, double the healing you get when you heal using a recovery (from any effect).

**Epic Feat:** One battle per day as a free action, choose yourself or a nearby ally. That creature gains a bonus to death saves equal to your Wisdom modifier until the end of the battle.

**Three Evil Dragons**

**Opening Attack (The Burning Shadow)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage, and if the target is staggered after the attack, choose one: you can pop free from the target; OR the target takes ongoing acid damage equal to your level.
- Miss: Damage equal to your level.

**Flow Attack (Blue Lightning Fist)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Natural Even Hit: PUNCH + Strength damage, and one random nearby enemy takes lightning damage equal to double your level.
- Natural Odd Hit: PUNCH + Strength damage, and you gain flight until the end of your next turn.
- Miss: Half damage, and one random nearby enemy takes lightning damage equal to your level.

**Finishing Attack (Red Fury)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage, and 1d6 extra fire damage for each point on the escalation die.
- Miss: Damage equal to your level.

**Champion Feat:** Once per battle when an enemy hits you with an attack that targets AC or PD while you are flying, you can force that enemy to reroll the attack as a free action.

**Epic Feat:** Once per day when you miss all targets with a finishing attack, you can make another finishing attack with your next standard action—in effect, you get to redo the last form of that progression.

**Tiger in Storm**

**Opening Attack (Stalking Tiger)**
- Melee attack
- Target: One enemy that isn't engaged with any of your allies.
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage.
- Natural Even Hit: As a hit, plus 2d6 ongoing lightning damage.
- Miss: Both you and the target take damage equal to your level.

**Flow Attack (Tiger Follows Blood)**
- Melee attack
- Target: One enemy that isn't engaged with any of your allies.
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage, and you can pop free from the target.
- Natural Even Hit: As a hit, plus if you are engaged with an enemy other than the target at the end of your turn, one enemy engaged with you takes 10 damage (as your attack sets up a final clawing strike).
- Miss: Half damage.

**Finishing Attack (Striped Lightning Roars)**
- Melee attack
- Target: One enemy that isn't engaged with any of your allies.
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage.
- Natural Even Hit: As a hit, plus 1d3 nearby enemies other than the target each take lightning damage equal to double your level.
- Miss: Half damage.

**Champion Feat Ki Power (Storm's Eye):** When an enemy misses you with an attack that deals cold, lightning, or thunder damage, you can spend 1 point of ki to heal using a recovery.

**Epic Feat:** You gain resist energy damage 16+ to cold, thunder, and lightning.

### Epic Tier Forms

**Death's Quivering Shadow**

**Opening Attack (Invoke the Name)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. PD
- Hit: JAB + Strength damage.
- Natural Even Hit: As a hit, plus the target takes ongoing negative energy damage equal to its level.
- Miss: You take 5 ongoing negative energy damage.

**Flow Attack (Stunning Fist)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Natural Even Hit: As a hit, plus if the target has 180 hp or fewer after the attack, it's stunned until the end of your next turn.
- Miss: Damage equal to your level.

**Finishing Attack (Ghostwalk of the Fallen King)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage, and 15 ongoing negative energy damage.
- Natural Even Hit: As a hit, plus until the end of your next turn, you gain flight and resist damage 16+ to all damage as you become incorporeal. (You can move through solid objects but can't end your turn in them.)
- Miss: Damage equal to your level.

**Epic Feat Ki Power (Quivering Palm):** Once per day when you hit a target with a finishing attack, you can spend 1 point of ki to create a link with the target. Until the next full heal-up, regardless of how faraway the target is, you can spend 1 point of ki and two consecutive quick actions to deal PUNCH + Wisdom damage to the target. You can keep spending quick actions and ki to deal this damage once per round until you run out of ki for the day.

**Feathered Serpent**

**Opening Attack (Coils Dispense Blessings)**
- Melee attack
- Target: Each enemy engaged with you
- Attack: Wisdom + Level vs. AC
- Hit: JAB + Wisdom damage.
- Miss: Damage equal to your level.

**Flow Attack (Feathers on Talons on Scales)**
- Melee attack
- Always: When you use this flow attack, choose one effect: pop free from one enemy anytime during your turn as a free action; or you gain flight until the end of your next turn.
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Miss: Half damage.

**Finishing Attack (Poisoned Heaven Kick)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage.
- Natural Even Hit: As a hit, plus if the target has 180 hp or fewer after the attack, it's hampered until the end of your next turn. If it has more than 180 hp, it takes 20 ongoing poison damage instead.
- Miss: Half damage.

**Epic Feat:** Once per battle as a quick action, you can roll a difficult save (16+) against a save ends effect affecting you that was caused by an enemy's attack. If you succeed, transfer the effect to an enemy engaged with you.

**Flagrant Blossoms**

**Opening Attack (The Petals Open)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage, and if this attack drops a non-mook to 0 hp, you can use a finishing attack with your next standard action.

**Flow Attack (Fist Shows the Path to Wisdom)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Natural Even Hit: As a hit, plus a random nearby ally can roll an icon relationship die (you choose which icon) that can be used as a story-guide result later in the adventure; the roll must be a 5 or a 6 to get an advantage as normal.
- Miss: Half damage.

**Finishing Attack (Lotus Dreams the World)**
- Melee attack
- Target: One enemy
- Attack: Wisdom + Level vs. MD
- Natural Even Hit: KICK + Wisdom damage, and you or an ally gains a +2 bonus to saves until the end of the battle.
- Natural Odd Hit: KICK + Wisdom damage, and the target takes a –2 penalty to saves until the end of the battle.
- Miss: Half damage.

**Epic Feat:** Once per day when you use the lotus dreams the world finishing attack, a nearby ally can heal using a free recovery and can roll a save against each save ends effect affecting it.

**Spiral Path**

**Opening Attack (The Cycle Opens)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: JAB + Strength damage.
- Natural Even Hit: As a hit, plus a different nearby enemy takes force damage equal to half that damage.

**Flow Attack (Spiral Ascension Widens)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: PUNCH + Strength damage.
- Natural Even Hit: As a hit, plus the escalation die increases by 1.
- Miss: Damage equal to your level.

**Finishing Attack (Star Joins as Ally)**
- Melee attack
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: KICK + Strength damage, and as a free action you can teleport next to a different nearby enemy you can see (engaging it) and make a PUNCH attack against it.
- Miss (PUNCH): The target takes damage equal to your level.
- Miss: Half damage, and you can't use attacks from the Spiral Path form until your next battle.

**Epic Feat:** One battle per day, choose a monk talent you don't ordinarily possess. This battle, you have that talent.

---

## Necromancer

### Ability Scores

Necromancers gain a +2 class bonus to Intelligence or Charisma, as long as it isn't the same ability you increase with your +2 racial bonus.

### Backgrounds

Possible backgrounds include: failed village priest, archeologist, swamp baron, living dungeon escapee, former necromancer acolyte, death giant servitor, former mummy, reformed outlaw, resurrected Imperial hero, and burnt-out wizard.

### Gear

At 1st level, a necromancer starts with various dark robes or traveling clothes, a dagger, a staff, a few treasured bones or funerary urns, and other miscellaneous items suggested by their backgrounds.

**Gold Pieces:** Necromancers may start with either 25 gp or 1d6 x 10 gp.

**Armor**

| Armor Type | Base AC | Atk Penalty |
|-----------|---------|------------|
| None | 10 | — |
| Light | 10 | — |
| Heavy | 11 | -2 |
| Shield | +1 | -2 |

**Melee Weapons**

| Type | Small | Light or Simple | Heavy or Martial |
|------|-------|-----------------|-----------------|
| One-Handed | 1d4 dagger | 1d6 (-2 atk) mace, shortsword | 1d8 (-5 atk) longsword, warhammer |
| Two-Handed | 1d6 club, staff | 1d8 (-4 atk) spear | 1d10 (-6 atk) greatsword |

**Ranged Weapons**

| Type | Small | Light or Simple | Heavy or Martial |
|------|-------|-----------------|-----------------|
| Thrown | 1d4 dagger, star | 1d6 (-2 atk) javelin | — |
| Crossbow | 1d4 hand crossbow | 1d6 (-1 atk) light crossbow | 1d8 (-4 atk) heavy crossbow |
| Bow | — | 1d6 (-2 atk) shortbow | 1d8 (-5 atk) longbow |

### Level Progression

| Level | Class Talents | 1st Level (M) | 3rd Level (M) | 5th Level (M) | 7th Level (M) | 9th Level (M) | Level-up Ability Bonuses | Damage Bonus From Ability Score |
|-------|---------------|---|---|---|---|---|----------------------|--------------------------------|
| 1 | As 1st level PC | 1 adventurer | 3 | — | — | — | Not affected | — |
| — | Multiclass Level 1 | 2 adventurer | 4 | — | — | — | — | — |
| 2 | — | 1 adventurer | 5 | — | — | — | ability modifier | — |
| 3 | 3 adventurer | 3 adventurer | 3 | 3 | — | — | — | ability modifier |
| 4 | 4 adventurer | — | 4 | 6 | — | — | — | ability modifier |
| 5 | 4 adventurer, 1 champion | — | — | 6 | 6 | — | +1 to 3 abilities | 2 x ability modifier |
| 6 | 4 adventurer, 2 champion | — | — | — | 8 | 8 | — | 2 x ability modifier |
| 7 | 4 adventurer, 3 champion | — | — | — | 6 | 8 | — | 2 x ability modifier |
| 8 | 4 adventurer, 3 champion, 1 epic | — | — | — | — | 9 | +1 to 3 abilities | 3 x ability modifier |
| 9 | 4 adventurer, 3 champion, 2 epic | — | — | — | — | 9 | — | 3 x ability modifier |
| 10 | 4 adventurer, 3 champion, 3 epic | — | — | — | — | 10 | +1 to 3 abilities | 3 x ability modifier |

**(M): Indicates columns in which multiclass characters lag one level behind.**

**Note:** Although not listed on the table, this class gets three talents. It does not get more at higher levels.

**\*You don't subtract the modifier from your base hp value if you have a negative Constitution modifier.**

### Stats

| Stat | Value |
|------|-------|
| Ability Bonus | +2 Intelligence or Charisma (different from racial bonus) |
| Initiative | Dex mod + Level |
| Armor Class (light armor) | 10 + middle mod of Con/Dex/Wis + Level |
| Physical Defense | 10 + middle mod of Str/Con/Dex + Level |
| Mental Defense | 11 + middle mod of Int/Wis/Cha + Level |
| Hit Points | (6 + Con mod) x Level modifier (see level progression chart) |
| Recoveries | 8 |
| Recovery Dice | (1d6 x Level) + Con mod |
| Backgrounds | 8 points, max 5 in any one background |
| Icon Relationships | 3 points (4 at 5th level; 5 at 8th level) |
| Talents | 3 |
| Feats | 1 per Level |

### Basic Attacks

**Melee Attack**
- At-Will
- Target: One enemy
- Attack: Strength + Level vs. AC
- Hit: WEAPON + Strength damage
- Miss: —

**Ranged Attack**
- At-Will
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: WEAPON + Dexterity damage
- Miss: —

### Class Features

All necromancers share the following class features.

**Arcane Implements**

As a character casting arcane magic, your best options for improving your spellcasting are wands and staffs.

**Death's Master**

All necromancers must spend at least one relationship point with any necromantic icon. (This may be conflicted or negative.) If your one unique thing somehow suggests that you might be free of this requirement, make a case to your GM that this is a way in which you are unique.

**Ritual Magic**

Necromancers can cast their spells as rituals (see Running the Game, Rituals).

**Spell Choices**

Like other standard spellcasters, you choose the spells you will be able to cast after each full heal-up.

**Summoning**

Your summoning spells use the standard summoning rules. The following feats enable you to improve your summoning powers.

- **Adventurer Feat:** Your summoned creatures can add the escalation die to their attacks.
- **Champion Feat:** When you summon mooks, increase the number of mooks you summon by 1.
- **Epic Feat:** The first time one of your non-mook summoned creatures is dropped each battle, roll a normal save. If you succeed, the summoned creature is not slain but instead remains in the battle with 10 hp.

**Wasting Away**

Necromancers are frail, gaunt, parched, skinny, sickly, wasted, cadaverous, dependent on unearthly substances, or partially dead. This isn't just an aesthetic note—as a necromancer, you must subtract your Constitution modifier from all your necromancer spell attacks if your modifier is positive. In addition, you don't die until you fail five death saves. Similarly, you don't succumb to last gasp save effects until you fail the fifth save.

- **Adventurer Feat:** If your Constitution modifier is negative, add +1 to your necromancer spell attacks.
- **Champion Feat:** You don't die from damage until your negative hit points equal your maximum hit points, instead of half your maximum.
- **Epic Feat:** One battle per day, you can choose to succeed with death saves on an 11+ instead of a 16+.

### Class Talents

**Cackling Soliloquist**

If you spend your move action, your quick action, and your standard action casting a daily spell that ordinarily only requires a standard action—while screaming grandiloquently, cackling maniacally, or megalomaniacally describing the grandeur of your plans and the futility of your enemies' resistance—the daily spell is recharge 18+ after battle instead of daily, and you can invent a slight improvement to the spell, especially if it's partly story-oriented, that provides an extra benefit determined by the GM or by you (with GM approval).

- **Adventurer Feat:** You gain temporary hit points equal to 1d6 + your level + Charisma modifier when you use Cackling Soliloquist (double your Charisma modifier at 5th level; triple it at 8th level).
- **Champion Feat:** Your soliloquized spell is now a recharge 16+ after battle instead of 18+.
- **Epic Feat:** Once per day, you can hog the spotlight when using Cackling Soliloquist. When you do, you heal using a free recovery and steal the escalation die, keeping it all to yourself. Until the end of your next turn, you are the only creature—PC, NPC, or monster—that can use the escalation die, and you treat the escalation die as if it were an 8. At the end of your next turn, return the escalation die to the table, one point higher than it was when you seized it.

**Dead Wizard**

You gain the Cantrips class feature from the wizard class. The talent functions like the wizard's class feature with the following exceptions:

- You can't cast mending.
- Your light cantrip has a sickly flicker or a dark edge. Feel free to call it darklight.

- **Adventurer Feat:** You can take a wizard spell in place of one of your necromancer spells of the same level. You can change this spell for a new one you know whenever you take a full heal-up.
- **Champion Feat:** You gain a bonus wizard spell that is at least two levels below your level, in addition to the spells you can cast as a necromancer. You can change this spell for a new one you know whenever you take a full heal-up.
- **Epic Feat:** You gain a second bonus wizard spell, but this one can be of your level or lower. You can change this spell for a new one you know whenever you take a full heal-up.

**Death Priest**

When you have icon relationship advantages you're waiting to use during a session, you can interpret them as interactions/public discussions with the spirits of the recent or ancient dead in the area, providing information you require (and possibly, when there's a complication from a 5 roll, also providing that information to your enemies or otherwise getting you into some type of trouble).

**Séance:** Similarly, once per day while you're not in battle, you can perform a short rite (1–2 minutes) to call upon a spirit of the dead that's related to a random icon other than a necromantic icon. The spirit will speak to you, relaying information helpfully, or under protest if it's related to an icon that considers you an enemy or with which you have a negative relationship.

You can't always rely on the dead to speak the truth, or to know what they are talking about. Whenever you use the séance power above, the GM secretly rolls a d20 before the discussion. On a 3+, the spirit knows what it is talking about. On a 1–2, the information is outdated, sabotaged, or just erroneous. (Note that this roll is only used for séances, not for spirits you talk to thanks to icon advantages mentioned above.)

At 5th level you can use séance two times per day. At 8th level you can use it three times per day.

- **Adventurer Feat:** Whenever you take a full heal-up, you can choose whether you'd like to move a single point in a relationship with a positively or negatively aligned icon to one of the other icons. Tell a story of what has taken place to cause the shift, unless it's already obvious from the events of the campaign. When you shift this relationship, the new point must match any current relationships with that icon, but it can be positive, negative, or conflicted if it's currently the only point you have with that icon.
- **Champion Feat:** You gain a bonus cleric spell that is at least two levels below your level, in addition to the spells you can cast as a necromancer. You can change this spell for a new one you know whenever you take a full heal-up. You can also substitute references to Wisdom with references to Intelligence in the spell.
- **Epic Feat:** You gain the lowest-tier feat, if any, associated with your bonus cleric spell.

**Deathknell**

As a quick action, you can drop a nearby enemy that has 5 hp or fewer down to 0 hp. When you drop an enemy using Deathknell, you heal 1d6 hit points.

You can use Deathknell to drop a mook, but only if it's the last mook in its mob and the mob has 5 hp or fewer left.

- 3rd level spell: Drop an enemy with 10 hp or fewer. Heal 1d10 hit points.
- 5th level spell: Drop an enemy with 15 hp or fewer. Heal 2d8 hit points.
- 7th level spell: Drop an enemy with 20 hp or fewer. Heal 4d6 hit points.
- 9th level spell: Drop an enemy with 25 hp or fewer. Heal 4d8 hit points.

- **Adventurer Feat:** When you use Deathknell, one of your nearby conscious allies can gain the healing instead of you.
- **Champion Feat:** Double the healing gained from Deathknell when you drop an enemy.
- **Epic Feat:** You can increase the escalation die by 1 instead of healing when you kill a non-mook enemy with Deathknell.

**It's Complicated**

When you roll icon relationship dice, the first 6 you roll is a 5 instead.

You gain an extra necromancer spell at the highest spell level you can normally cast (as shown under spells known on the necromancer level progression chart). For example, you would gain an extra 3rd level spell if you're 4th level, or an extra 5th level spell if you're 5th level.

- **Champion Feat:** All 6s you roll with relationship dice count as 5s. You gain another extra necromancer spell, but it must be at least two levels lower than your level.

**Redeemer**

Undead you summon release holy energy bursts as they drop to 0 hp, dealing a small amount of damage to each enemy engaged with them.

Mooks you summon deal holy damage equal to your Charisma modifier (double your Charisma modifier at 5th level; triple it at 8th level).

Non-mooks you summon deal holy damage equal to your Charisma modifier x 1d4 (1d8 at 5th level; 2d6 at 8th level).

In story terms, you're not likely to have a positive relationship with any necromantic icons if you take the Redeemer talent.

- **Adventurer Feat:** The first time each battle an undead creature you have summoned attacks, it gains an attack bonus equal to your Charisma modifier.
- **Champion Feat:** When one of your summoned undead creatures drops to 0 hp, instead of having it deal holy damage to engaged enemies, you can heal hit points equal to that damage instead.
- **Epic Feat:** You can memorize a single spell that summons undead twice.

**Skeletal Minion**

You have a skeleton minion the same level as you that acts as a servant, fights alongside you in battle, and is replaced by a new skeletal minion when it inevitably collapses or is destroyed. It is not a summoned create; summoning rules don't apply.

Your minion acts on your initiative, taking a standard action, a move action, and (if applicable) a quick action. You decide whether it takes its turn before or after you.

The listed attack and damage values are for melee attacks. Your skeletal minion can't heal. When it drops to 0 hp, it's destroyed for that battle. When you take a quick rest, a new (or patched up) skeletal minion will take its place.

**Level 1 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +6 vs. AC |
| Damage | d6 |
| AC | 17 |
| PD | 15 |
| MD | 11 |
| HP | 14 |

**Level 2 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +7 vs. AC |
| Damage | d8 |
| AC | 18 |
| PD | 16 |
| MD | 12 |
| HP | 18 |

**Level 3 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +9 vs. AC |
| Damage | d12 |
| AC | 19 |
| PD | 17 |
| MD | 13 |
| HP | 22 |

**Level 4 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +10 vs. AC |
| Damage | 2d6 |
| AC | 21 |
| PD | 19 |
| MD | 15 |
| HP | 27 |

**Level 5 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +11 vs. AC |
| Damage | 2d8 |
| AC | 22 |
| PD | 20 |
| MD | 16 |
| HP | 36 |

**Level 6 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +13 vs. AC |
| Damage | 3d6 |
| AC | 23 |
| PD | 21 |
| MD | 17 |
| HP | 45 |

**Level 7 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +14 vs. AC |
| Damage | 3d8 |
| AC | 25 |
| PD | 23 |
| MD | 19 |
| HP | 54 |

**Level 8 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +15 vs. AC |
| Damage | 4d6 |
| AC | 26 |
| PD | 24 |
| MD | 20 |
| HP | 72 |

**Level 9 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +17 vs. AC |
| Damage | 4d8 |
| AC | 27 |
| PD | 25 |
| MD | 21 |
| HP | 90 |

**Level 10 Skeletal Minion**

| Stat | Value |
|------|-------|
| Attack | +18 vs. AC |
| Damage | 5d6 |
| AC | 28 |
| PD | 26 |
| MD | 22 |
| HP | 108 |

**Skeletal Minion Feats**

Like animal companion feats, skeletal minion feats don't build on each other. You don't have to take them in a particular order, as long as you qualify for the tier.

**Adventurer Feats**

- Your skeletal minion now adds the escalation die to its attack rolls.
- When an enemy attempts to disengage from the skeletal minion, it takes a penalty to the check equal to the escalation die.
- As a quick action, you can set your skeletal minion ablaze, or extinguish the blaze. While it's flaming, your skeleton minion's damage dice increase by one size, and it deals fire damage with its melee attacks, but it takes damage equal to your level each time its natural attack roll is odd.

**Champion Feats**

- Add a damage die of the same size to your skeletal minion's damage rolls (for example, 3d6 becomes 4d6).
- Add double your Charisma modifier to your skeletal minion's hit points. At 8th level, add triple it.
- Add a damage die of the same size to your skeletal minion's damage rolls (for example, 4d6 becomes 5d6, and this is cumulative with the champion feat).

**Epic Feats**

- Your skeletal minion gains a +2 bonus to all defenses.

**Sorta Dead**

In some ways, you're dead already. You don't need to eat or sleep or breathe. You can't drown in normal water/liquid, though magical gas will still affect you.

When a spell or effect targets or applies to undead, you can decide whether you want to count as undead for that specific effect. (For example, you could count as undead to take advantage of a target's vulnerability created by the ripping claws attack of a starving ghoul mook you summoned via summon undead.)

The first time you die each level, roll a normal save, adding your Charisma modifier. If you succeed, you heal using a free recovery instead of dying. If you were dying because of last gasp saves, consider yourself saved from the last gasp problem also.

- **Adventurer Feat:** You gain resist poison 16+ and resist negative energy 16+.
- **Champion Feat:** The spells zombie form, ghoul form, ghost form, and vampiric form all function as recharge 16+ after battle spells for you, though you still memorize them as daily spells.
- **Epic Feat:** No undead creature that is not under the direct command of a necromantic icon can attack you unless you attack it or cast a spell against it first.

[*Note: The Necromancer's spell lists (1st, 3rd, 5th, 7th, and 9th level spells) are extensive and numerous. Due to length constraints, those spell entries are included in the source text but not detailed here. Reference the source material for complete spell descriptions, which include Channel Life, Chant of Endings, Command Undead, Death's Gauntlet, Summon Undead, Terror, Unholy Blast, Zombie Form, The Bones Beneath, Circle of Death, Ghoul Form, Negative Energy Shield, Ray of Enfeeblement, Speak with Dead, Summon Horror, Wave of Decay, Death's Call, Rotting Curse, Summon Wraith, You Know What to Do, Cone of Corruption, Feigned Defeat, Ghost Form, Finger of Death, The Last of the Wine, and Vampiric Form.*]

### Summoning Rules

These general rules also apply to the druid's Elemental Caster class talent.

**Standard action spells:** Casting a summoning spell generally requires a standard action. The creature(s) you summon appears next to you, though feats or powers might enable you to summon it nearby instead.

**Duration:** A summoned creature fights for you until the end of the battle or until it drops to 0 hit points. At 0 hp, summoned creatures are slain and removed from the battle.

**One summoning spell at a time:** Each spellcaster can have only a single summoning spell active at a time. If all the creatures from an earlier summoning spell have been slain, you're free to cast another. Alternatively, you can dismiss your own previously summoned creatures as a quick action to clear the way for a new summoning spell.

**Halfway there:** Summoned creatures are not the same as real creatures. They're partly real, partly magical. Their abilities don't always match the capabilities of the creatures that the adventurers encounter for real. Sometimes this is reflected in a summoned creature's attacks or abilities. It's always reflected in a summoned creature's hit points.

**Hit points:** Each summoned creature stat block indicates its base hit points. Starting hit points for summoned creatures are nearly always lower than hit points for non-summoned versions of the same creature. Some class feats might increase the hit points of summoned creatures.

**Actions on arrival:** The turn you summon a creature, that creature takes its turn immediately after your turn in initiative order. During its turn, the summoned creature can act like any other creature, taking a standard, move, and quick action. The summoned creature continues to take its turn immediately after you (even if your initiative order changes) until the end of the battle.

**Escalation die:** As a rule, summoned creatures don't benefit from the escalation die. A summoned creature can add the escalation die to attacks, however, if you use a quick action to give it orders or magical reinforcement. The summoned creature then gets to use the escalation die until the start of your next turn, including for opportunity attacks and other attacks that it gets to make during other creatures' turns. For example, during the turn you summon the creature, you use a quick action afterward to give it orders, allowing it to use the escalation die bonus. At the start of your next turn, the creature no longer gets to use the escalation die, so you'll have to use another quick action again during that turn for the creature to keep getting the benefit. If you've summoned a mob of mooks, a single quick action lets every member of the mob use the escalation die.

**Allies:** Summoned creatures generally count as your allies (for roleplaying as well as for resolving effects).

**No recoveries, bad healing:** Summoned creatures don't have recoveries. If you cast a healing spell on a summoned creature that requires the use of a recovery, the summoned creature heals hit points equal to your level. If you use an effect that would heal a summoned creature without using a recovery, the summoned creature only heals half the normal hit points of the effect. Temporary hit points still work normally.

**No nastier specials:** Creatures you summon don't use nastier specials.

**Spell or creature:** When a summoning spell is cast, it's definitely a spell. After casting the spell, a summoned creature is a creature.

---

## Occultist

There is only one occultist, and your one unique thing should account for your knowledge and mastery of powers hidden and occluded.

### Ability Scores

The occultist gains a +2 class bonus to Intelligence or Wisdom, as long as it isn't the same ability you increase with your +2 racial bonus.

### Backgrounds

Possible backgrounds for the occultist's singular knowledge include: librarian of the forbidden, or wandering mystic. Perhaps the occultist is a holy one whose secret knowledge comes from the heavens, or perhaps she has been touched by the abyss, and her secret knowledge comes from someplace far more sinister.

### Gear

At 1st level, the occultist starts with the embroidered robes, secret scrolls, and runic vestments that you would expect from someone with such arcane power. He might have a small item that looks like a harmless bauble but whose markings become more intricate and mesmerizing the longer it's viewed. To defend himself, he has a staff or a dagger hidden under his robe. He also has some personal possessions left over from his earlier life.

**Gold Pieces:** The occultist may start with either 25 gp or 1d6 x 10 gp.

**Armor**

| Armor Type | Base AC | Atk Penalty |
|-----------|---------|------------|
| None | 10 | — |
| Light | 11 | — |
| Heavy | 13 | -2 |
| Shield | +1 | -2 |

**Melee Weapons**

| Type | Small | Light or Simple | Heavy or Martial |
|------|-------|-----------------|-----------------|
| One-Handed | 1d4 dagger | 1d6 (-2 atk) mace, shortsword | 1d8 (-4 atk) longsword, warhammer |
| Two-Handed | 1d6 club, staff | 1d8 (-2 atk) spear | 1d10 (-4 atk) greatsword |

**Ranged Weapons**

| Type | Small | Light or Simple | Heavy or Martial |
|------|-------|-----------------|-----------------|
| Thrown | 1d4 dagger, dart | 1d6 (-2 atk) javelin | — |
| Crossbow | 1d4 hand crossbow | 1d6 (-1 atk) light crossbow | 1d8 (-4 atk) heavy crossbow |
| Bow | — | 1d6 (-2 atk) shortbow | 1d8 (-5 atk) longbow |

### Level Progression

| Level | Class Talents (M) | 1st Level (M) | 3rd Level (M) | 5th Level (M) | 7th Level (M) | 9th Level (M) | Level-up Ability | Damage Bonus From Ability Score |
|-------|------------------|---|---|---|---|---|----------------------|--------------------------------|
| 1 | As 1st level PC | 1 or 2 (3 total) | 3 | — | — | — | Not affected | ability modifier |
| — | Multiclass Level 1 | 2 adventurer | 4 | — | — | — | — | ability modifier |
| 2 | 1 adventurer | 4 | 5 | — | — | — | ability modifier | ability modifier |
| 3 | 3 adventurer | 4 | 2 | 3 | — | — | — | ability modifier |
| 4 | 4 adventurer | 4 | — | 6 | — | — | — | ability modifier |
| 5 | 4 adventurer, 1 champion | 5 | — | 3 | 3 | — | +1 to 3 abilities | 2 x ability modifier |
| 6 | 4 adventurer, 2 champion | 5 | — | — | 7 | — | — | 2 x ability modifier |
| 7 | 4 adventurer, 3 champion | 5 | — | — | 4 | 4 | — | 2 x ability modifier |
| 8 | 4 adventurer, 3 champion, 1 epic | 6 | — | — | — | 6 | +1 to 3 abilities | 3 x ability modifier |
| 9 | 4 adventurer, 3 champion, 2 epic | 9 | — | — | — | — | — | 3 x ability modifier |
| 10 | 4 adventurer, 3 champion, 3 epic | 10 | — | — | — | — | +1 to 3 abilities | 3 x ability modifier |

**(M): Indicates columns in which multiclass characters lag one level behind.**

### Stats

| Stat | Value |
|------|-------|
| Ability Bonus | +2 Intelligence or Wisdom (different from racial bonus) |
| Initiative | Dex mod + Level |
| Armor Class (no/light armor) | 11 + middle mod of Con/Dex/Wis + Level |
| Physical Defense | 10 + middle mod of Str/Con/Dex + Level |
| Mental Defense | 11 + middle mod of Int/Wis/Cha + Level |
| Hit Points | (6 + Con mod) x Level modifier (see level progression chart) |
| Recoveries | 8 |
| Recovery Dice | (1d6 x Level) + Con mod |
| Backgrounds | 8 points, max 5 in any one background |
| Icon Relationships | 3 points (4 at 5th level; 5 at 8th level) |
| Talents | 4 (see level progression chart) |
| Feats | 1 per Level |

### Basic Attacks

**Melee Attack**
- At-Will
- Target: One enemy
- Attack: Strength + Level vs. AC
- Hit: WEAPON + Strength damage
- Miss: Damage equal to your level

**Ranged Attack**
- At-Will
- Target: One enemy
- Attack: Dexterity + Level vs. AC
- Hit: WEAPON + Dexterity damage
- Miss: —

### Class Features

**Arcane Implements**

You use arcane power to alter fate. While wands and staffs are designed for casting spells that are different from the spells you use, given a little time you can bend such an implement to your will.

- **Epic Feat:** If you find a magic weapon that isn't an arcane implement but that calls to your soul, you can bend it to your will and use its attack and damage bonus for spellcasting also. Any other arcane benefits you gain from the weapon are at the GM's discretion.

**Delayed Magical Healing**

Magical healing effects heal you one round after the effect would normally be applied. You gain the healing at the start of the turn of whoever applied the magical healing effect, or at the start of your next turn if you drank a healing potion or found some other way of magically healing yourself during your last turn. This doesn't apply outside of combat or when you rally.

- **Adventurer Feat:** Your baseline hit points are 7 instead of 6.
- **Champion Feat:** Once per battle when a healing effect would be applied to you, you can roll a save (11+). If you succeed, you get the healing immediately. If you fail, lose a hit point.
- **Epic Feat:** Increase your total recoveries by 1. Once per day as a free action when a natural attack roll of 17 or less hits you, you take only half damage from that attack instead.

**Focus and Spellcasting**

Wielding your arcane power of reality requires two steps. First, you take time to focus your mind. Once you have this focus, you can cast a spell. Casting a spell generally expends your focus, though there will be exceptions depending on the spell.

Gaining your focus requires a standard action, and it draws opportunity attacks just like using a ranged attack does. (The "range" in this case is "beyond this world.") You can cast most of your spells only in response to an event, typically during an enemy's turn or an ally's turn.

- **Adventurer Feat:** When you cast a spell and retain your focus, you gain a +2 bonus to all defenses until the start of your next turn.
- **Champion Feat:** While you have your focus, when an enemy misses you with an attack, it takes psychic damage equal to your level.
- **Epic Feat:** The "retain focus" range of your occultist spells increases by 2 (for example, 1–5 would be 1–7).

**Rebuke**

With focus, you can pummel someone with their own negative karma. In addition to the spells you normally know based on your level, you also know karmic rebuke. There are no feats associated with this spell, but you can improve it with the Superior Rebuke talent.

Karmic rebuke requires a quick action instead of an interrupt action. It's designed so you can cast it during your turn when you've retained your focus, then use your standard action to get your focus back that same turn.

**Karmic Rebuke**
- Close-quarters spell
- At-Will
- Quick action to cast; expend focus
- Target: One nearby enemy
- Attack: Intelligence + Level vs. MD
- Hit: 1d6 + Wisdom psychic damage.
- 3rd level spell: 3d6 damage.
- 5th level spell: 5d6 damage.
- 7th level spell: 5d8 damage.
- 9th level spell: 7d10 damage.

**Uniqueness**

You're the only occultist. Your one unique thing should address your identity as the occultist, but you need to contribute your own personal take on the character just like you would with a dwarf fighter or other character class. A character's unique concerns story material beyond a class description, yours included.

**Spell Choices and Flexible Recharge**

Like a standard spellcaster, you choose the spells you will be able to cast after each full heal-up. When you successfully recharge a spell, you can regain any spell of that spell's level, not necessarily the same spell again. In effect, you roll to recharge that level's spell slot.

- **Adventurer Feat:** Once per day, you can automatically succeed on a recharge roll that's 6+ (but not 11+ or 16+).
- **Champion Feat:** Once per day when you recharge a spell (usually during a quick rest), you can make a recharge roll for a recharge spell even if you haven't expended that spell (allowing you to have an additional use of that spell available).
- **Epic Feat:** Once per day, you can automatically succeed on a recharge roll.

### Class Talents

Choose four of the following class talents. You get an additional occultist class talent at 5th level, and again at 8th level.

**Brain-Melting Secrets**

When you hit with a spell attack that deals psychic damage, one target of the attack can't attack you during its next turn this battle unless you are the only nearby enemy.

- **Adventurer Feat:** The effect works whenever you hit an enemy with a spell, not only one that deals psychic damage.
- **Champion Feat:** You are immune to the confused and dazed conditions. In addition, charm, fear, sleep, and similar mental effects have no effect on you.
- **Epic Feat:** Once per battle when you deal psychic damage to an enemy, if it has 300 hp or fewer, you can also weaken it (save ends).

**Hewer of Truth**

You can use an edged melee weapon without an attack penalty. You can use Intelligence instead of Strength for your attack rolls with that weapon, and Wisdom instead of Strength for your damage rolls. In addition, when you hit an enemy engaged with you with a spell, you can cause a small amount of extra harm to that foe with your weapon. The target takes ongoing damage equal to your melee attack miss damage.

- **Adventurer Feat:** Twice per day when an enemy engaged with you misses you with an attack, you can deal ongoing damage to it equal to your Wisdom modifier + Level as you give it a quick slice you're your weapon (double your Wisdom modifier at 5th level; triple it at 8th level).
- **Champion Feat:** While you have your focus, you gain a +4 bonus to opportunity attacks.
- **Epic Feat:** Once per day when you hit an enemy with karmic rebuke, you can make a basic melee attack as a free action.

**Icon Channeler**

You cannot take this talent if you have taken the Icon Envoy talent.

You have three fewer relationship dice than normal (i.e. none at adventurer tier, one at champion tier, and two at epic tier). Instead, when all the characters get to roll relationship dice, you get a 5 to apply to any icon you choose. Like any other character, you can gain relationship dice through extraordinary story events. Remember, just because an icon is out to kill you doesn't mean you have relationship dice with that icon. Dice represent the utility of a connection in the story not its strength. If you encounter icons other than the standard ones, you can probably talk the GM into letting you align your soul to them, but expect it to cost you.

- **Adventurer Feat:** Choose three icons when you take this feat. Each time you apply your 5 to one of those icons, roll a d6. On a 5–6, change that 5 you're applying to a 6.
- **Champion Feat:** As the adventurer feat, except that you can also choose three more icons (six total) when you take this feat that allow you to roll the d6 when you apply a 5 to one of them.
- **Epic Feat:** You now get two 5s when the other characters roll icon relationship dice. You can roll a d6 for each 5 if you apply it to a chosen icon from the adventurer and champion feats.

**Icon Envoy**

You cannot take this talent if you have taken the Icon Channeler talent.

Each time the characters roll relationship dice, declare which player will get at least a 5 with one of their icons before the rolls. The player rolls one of their dice for that icon before the others. That first roll counts as a 5 unless the player rolls 6. Roll all other icon dice normally.

- **Adventurer Feat:** Once per level, instead of working with the icon relationships your ally has, give an ally a 5 with an icon they don't have a relationship with.
- **Champion Feat:** If the first roll for the called icon is even (2, 4, 6), it counts as a 6 instead of a 5.
- **Epic Feat:** If the first roll for the called icon is odd (1, 3, 5), you can declare a second player and one of their icons, and have them roll one icon die the same way.

**Otherworld Shadow**

A shadow self haunts and lurks near you most of the time, sometimes an actual shadow on a wall, but other times only a presence sensed just over your shoulder. Once per day as an interrupt action, negate all damage and effects from an enemy's attacks against you that turn as your shadow absorbs them. Using this talent's power means you avoid damage from a monster's multiple attacks if it has them. It also works against multiple attacks from mooks in the same mob working on the same initiative count, but not attacks from multiple non-mook monsters.

- **Adventurer Feat:** Your shadow grants you greater personal resilience: increase your total recoveries by 1.
- **Champion Feat:** Once per day as a free action, you can end all ongoing damage affecting you as you pass off the damage to your shadow.
- **Epic Feat:** Once per day as a free action, you gain a fear aura that affects each enemy attacking you or engaged with you. The hit point threshold for the fear effect is the standard value for a monster five levels above you. Allies are not subject to the fear effect unless they cast a spell that targets you or otherwise interact with you directly in some way. Even in this case, that ally can spend a move action to be immune to your shadow's fear aura for one round.

| PC Level | Fear Threshold HP (Level + 5) |
|----------|-------------------------------|
| 1 | 30 |
| 2 | 36 |
| 3 | 48 |
| 4 | 60 |
| 5 | 72 |
| 6 | 96 |
| 7 | 120 |
| 8 | 144 |
| 9 | 192 |
| 10 | 230 |

**Stance of Necessity**

Twice per day as a quick action, you can gain a +4 bonus to all defenses. The protection lasts until the end of the battle and is in effect while you do NOT have your focus. The bonus also ends when an attack hits you while you don't have your focus.

- **Adventurer Feat:** You can guard a nearby ally instead of yourself (you don't have to see that ally). The defense bonus ends if either you or the ally is hit while you don't have your focus.
- **Champion Feat:** Your Stance of Necessity uses are now recharge 16+ instead of daily.
- **Epic Feat:** When an enemy misses you with an attack while you don't have your focus, it takes psychic damage equal to triple your Wisdom modifier + Level.

**Superior Rebuke**

The first time each round that you expend your focus to cast a spell as an interrupt action and fail to retain your focus, roll a d20 afterward. On an 18–20, you can also cast karmic rebuke as a free action, using that roll in place of your attack roll. You can use this talent again during a later round in the battle once you have your focus again.

- **Adventurer Feat:** You can also make the karmic rebuke attack when the d20 roll is 2–4 (low monster MD plus an escalation die bonus often means you'll still hit).
- **Champion Feat:** You can also make a karmic rebuke attack as a free action when you roll a natural 5, 10, 15, or 20 on initiative, even if you don't have your focus.
- **Epic Feat:** One battle per day as a free action, you can enhance your karmic rebuke. When you enhance it, enemies are vulnerable (crit range expands by 2) to your karmic rebuke attacks until the end of the battle or until you score a critical hit with the attack.

**Unwinding the Soul**

When you cast a spell and roll a natural 11+ with the attack, after the attack you can "unwind" the target as a free action, making it vulnerable to your attacks until the end of the battle. You can unwind only one enemy at a time, so if you choose to unwind a different enemy, the previous foe is no longer vulnerable to your attacks.

- **Adventurer Feat:** You can now unwind a second enemy, but if you unwind a third, the first enemy is no longer vulnerable. You can also take this feat multiple times, allowing you to unwind another enemy each time you select it.
- **Champion Feat:** You can now unwind an enemy with any attack roll other than a natural 1 when you cast a spell, instead of only on an 11+.
- **Epic Feat:** When you attack an enemy that you have begun to unwind and roll a natural 11+ against it, it takes extra psychic damage equal to your Wisdom modifier + Level from all subsequent hits by you or your allies.

**Warp Flesh**

When you cast a spell that targets Mental Defense and the target has a higher MD than PD, the attack "twists" and targets PD instead. When a spell twists this way, it deals force damage instead of its normal damage type.

- **Adventurer Feat:** When you cast a spell that twists, you gain temporary hit points equal to your Wisdom modifier (double your Wisdom modifier at 5th level; triple it at 8th level).
- **Champion Feat:** When you score a critical hit with a spell, the target also takes ongoing force damage equal to double your Wisdom modifier (triple it at 8th level). The ongoing damage isn't doubled by the crit.
- **Epic Feat:** Once per battle when you hit an enemy with a spell, you can negate all of the target's resistances (hard save ends, 16+). This effect occurs even if the target's PD is higher than its MD.

### 1st Level Spells

**Better Yet, Here**
- Close-quarters spell
- At-Will
- Interrupt action to cast; expend focus
- Trigger: One of your allies hits a nearby enemy with an attack.
- Target: The enemy hit by the attack
- Attack: Intelligence + Level vs. MD
- Hit: The target takes 2d6 + Wisdom extra damage from the hit. (If your attack crits, double the damage you are adding to your ally's attack, but not their base damage.)
- Miss: The target takes extra damage from the hit equal to the spell level.
- Retain Focus: 1–5.
- 3rd level spell: 4d6 damage.
- 5th level spell: 6d6 damage.
- 7th level spell: 6d10 damage.
- 9th level spell: 8d10 damage.
- **Champion Feat:** When this attack drops the enemy to 0 hp or drops the last mook of a mob, you don't expend your focus.
- **Epic Feat:** When the triggering ally scores a critical hit with the attack, you don't expend your focus.

**Bitter Lessons**
- Close-quarters spell
- Recharge 16+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby enemy misses with an attack.
- Target: The attacking enemy
- Attack: Intelligence + Level vs. MD
- Hit: 2d6 + Wisdom psychic damage, and the ally the target missed gains the same amount of temporary hit points.
- Miss: Half damage, and you take the other half of the damage.
- Retain Focus: 1–15.
- 3rd level spell: 4d6 damage.
- 5th level spell: 6d6 damage.
- 7th level spell: 6d10 damage.
- 9th level spell: 8d10 damage.

**Brilliant Comeback**
- Close-quarters spell
- Recharge 6+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby ally uses a recovery.
- Effect: The triggering ally can make a basic attack as a free action. Instead of using their attack bonus, that ally uses an attack bonus equal to your Intelligence modifier + 5.
- 3rd level spell: Intelligence modifier +7.
- 5th level spell: Intelligence modifier +10.
- 7th level spell: Intelligence modifier +12.
- 9th level spell: Intelligence modifier +15.
- Retain Focus: 1–15
- **Adventurer Feat:** The triggering ally adds hit points equal to your Wisdom modifier to the recovery (double your Wisdom modifier at 5th level; triple it at 8th level).
- **Champion Feat:** The triggering ally can make an at-will attack instead of a basic attack.
- **Epic Feat:** The target of the triggering ally's attack is vulnerable to that attack.

**Inevitable Fall**
- Close-quarters spell
- Recharge 16+ after battle
- Interrupt action to cast; expend focus
- Trigger: One of your allies attacks a nearby enemy and misses.
- Target: The missed enemy
- Attack: Intelligence + Level vs. MD
- Hit: 4d8 + Wisdom psychic damage, and 5 ongoing psychic damage.
- Miss: 5 ongoing psychic damage.
- Retain Focus: 1–5.
- 3rd level spell: 8d6 damage, and 10 ongoing damage; 10 ongoing damage on a miss.
- 5th level spell: 8d10 damage, and 15 ongoing damage; 15 ongoing damage on a miss.
- 7th level spell: 2d6 x 10 damage, and 25 ongoing damage; 25 ongoing damage on a miss.
- 9th level spell: 2d10 x 10 damage, and 35 ongoing damage; 35 ongoing damage on a miss.
- **Adventurer Feat:** The save to end the ongoing damage, hit or miss, is hard (16+).

**Moment of Karma**
- Close-quarters spell
- At-Will
- Interrupt action to cast; expend focus
- Trigger: A nearby enemy hits you with an attack.
- Target: The attacking enemy
- Attack: Intelligence + Level vs. MD
- Hit: 3d6 + Wisdom psychic damage.
- Miss: Damage equal to spell level.
- Retain Focus: 1–5.
- 3rd level spell: 5d6 damage.
- 5th level spell: 5d10 damage.
- 7th level spell: 7d10 damage.
- 9th level spell: 10d10 damage.
- **Adventurer Feat:** When the target is staggered before the attack, it's vulnerable to this attack.
- **Champion Feat:** When you hit with this spell, the target also takes ongoing damage equal to double your Wisdom modifier (triple it at 8th level).
- **Epic Feat:** Add triple your Wisdom modifier to your miss damage.

**Timely Mistake**
- Close-quarters spell
- Recharge 6+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby enemy hits you or an ally with a natural odd attack roll.
- Target: The attacking enemy
- Attack: Intelligence + Level vs. MD
- Hit: 1d6 + Wisdom psychic damage, and the target rerolls the attack and must use the lower result.
- Miss: Damage equal to spell level.
- 3rd level spell: 3d6 damage.
- 5th level spell: 5d6 damage.
- 7th level spell: 5d8 damage.
- 9th level spell: 7d10 damage.
- Retain Focus: 1–5.
- **Adventurer Feat:** If the triggering attack targets one of your allies, that ally gains a bonus to all defenses against the rerolled attack equal to your Wisdom modifier.
- **Champion Feat:** This spell's damage dice increase by one size (for example, d6s become d8s).
- **Epic Feat:** When you miss with this spell but retain your focus with the roll, the target takes double the miss damage, unless you rolled a 1.

### 3rd Level Spells

**Blood for Blood**
- Close-quarters spell
- At-Will
- Interrupt action to cast; expend focus
- Trigger: One of your allies is staggered by a nearby enemy's attack.
- Target: The attacking enemy
- Attack: Intelligence + Level vs. MD
- Hit: 3d6 + Wisdom psychic damage, and the target is vulnerable (save ends).
- Miss: Damage equal to spell level.
- 5th level spell: 5d6 damage.
- 7th level spell: 5d8 damage.
- 9th level spell: 7d10 damage.
- Retain Focus: 1–5.
- **Adventurer Feat:** The spell can now trigger when an ally is dazed, weakened, or stunned by an enemy's attack.
- **Champion Feat:** On a hit, the target is now vulnerable until the end of battle.
- **Epic Feat:** Your retain focus range with this spell is now 1–15.

**Diversion of Pain**
- Close-quarters spell
- Recharge 6+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby enemy of 5th level or lower hits one of your allies with an attack that could have targeted you or a different ally.
- Effect: The triggering attack now targets you or a different ally of your choice as long as that creature would be a legal target of the attack. Keep the same attack roll.
- 5th level spell: An enemy of 8th level or less can now trigger this spell.
- 7th level spell: An enemy of 11th level or less can now trigger this spell.
- 9th level spell: An enemy of any level can now trigger this spell.
- Retain Focus: 1–15.
- **Adventurer Feat:** The new target of the attack gains a +2 bonus to all defenses against the triggering attack.
- **Champion Feat:** You can now cast this spell when a triggering enemy hits you with an attack.
- **Epic Feat:** The new target gains resist damage 18+ against the triggering attack.

**Fortune Smiles**
- Close-quarters spell
- Recharge 6+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby ally fails a save against an effect created by a level 1–4 enemy.
- Effect: That ally gains a bonus to the save equal to your Intelligence modifier.
- 5th level spell: A level 5–7 effect.
- 7th level spell: A level 8–10 effect.
- 9th level spell: A level 11+ effect.
- Retain Focus: —
- **Champion Feat:** Your retain focus range with this spell is now 1–5.
- **Epic Feat:** When you cast this spell, choose a second nearby ally. It can roll a save against a save ends effect.

**Strike of the Last Breath**
- Close-quarters spell
- At-Will
- Interrupt action to cast; expend focus
- Trigger: A nearby ally drops to 0 hp or below from the attack of an enemy engaged with it.
- Target: The triggering ally
- Attack: Intelligence + Level vs. MD
- Effect: Before the target drops, it can make a basic attack against the attacking enemy as a free action (if possible), but uses your attack roll instead. On a hit, the attack deals normal damage, and the target (your ally) takes less damage from the triggering attack equal to 3d6 + Wisdom modifier.
- If the target can't make a basic attack against the enemy making the triggering attack, this spell has no effect.
- Retain Focus: 1–5.
- 5th level spell: Prevent 5d6 damage.
- 7th level spell: Prevent 5d8 damage.
- 9th level spell: Prevent 7d10 damage.
- **Adventurer Feat:** The target can make an at-will attack instead of a basic attack.

### 5th Level Spells

**Call of Doom**
- Close-quarters spell
- At-Will
- Free action to cast
- Trigger: You drop to 0 hp or below or roll a death save.
- Special: You can cast this spell without having your focus. If the trigger is you dropping, you cast it before you drop. If the trigger is a death save, you cast it while unconscious.
- Target: The closest random nearby enemy
- Attack: Intelligence + Level vs. MD
- Hit: 7d6 + Wisdom psychic damage.
- Retain Focus: —.
- 7th level spell: 6d10 damage.
- 9th level spell: 10d10 damage.

**Crooked Step**
- Close-quarters spell
- Recharge 16+ after battle
- Interrupt action to cast; expend focus
- Trigger: An enemy with 100 hp or fewer moves to engage one of your allies and attacks.
- Effect: The triggering enemy rerolls its attack and uses the roll of your choice. If the attack misses, that enemy isn't engaged with your ally (i.e. it wasn't able to move quickly/close enough).
- 7th level spell: 160 hp or fewer.
- 9th level spell: 250 hp or fewer.
- Retain Focus: 1–5.
- **Champion Feat:** The ally the triggering enemy is attacking gains a bonus to all defenses against that attack equal to your Intelligence modifier.
- **Epic Feat:** When this spell makes the triggering enemy miss with an attack, that enemy takes psychic damage equal to (1d8 x the spell level) + triple your Wisdom modifier. For example, casting at 7th level with a Wisdom of 20, and rolling a 4 on the d8, you'd deal 43 damage (28 + 15).

**Fateful Confrontation**
- Close-quarters spell
- Recharge 16+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby unengaged enemy ends its turn.
- Target: The triggering enemy
- Attack: Intelligence + Level vs. MD
- Hit: Until the start of the target's next turn, you and each of your allies can make melee attacks against it as if you were engaged with it, as long as the attacker can see the target. Note, when you or an ally attacks the target while nearby or faraway, the attacker isn't actually engaged with the target.
- Retain Focus: 1–5.
- **Adventurer Feat:** The spell now triggers against a faraway unengaged enemy.
- **Champion Feat:** Your retain focus range with this spell is now 1–15.
- **Epic Feat:** The spell is now recharge 11+ after battle instead.

**Stifle**
- Close-quarters spell
- Recharge 6+ after battle
- Interrupt action to cast; expend focus
- Trigger: An enemy with 70 hp or fewer fails a disengage check or is targeted with an opportunity attack.
- Target: The triggering enemy
- Attack: Intelligence + Level vs. MD
- Hit: The target ends its movement, if any, and can't take any more actions this turn.
- Retain Focus: 1–10.
- 7th level spell: 100 hp or fewer.
- 9th level spell: 160 hp or fewer.
- **Champion Feat:** On a hit, the target also takes psychic damage equal to your Level + double your Wisdom modifier (triple it at 8th level).
- **Epic Feat:** Increase the triggering hit point threshold by 50.

### 7th Level Spells

**Arcane Loop**
- Close-quarters spell
- Recharge 16+ after battle
- Interrupt action to cast; expend focus
- Trigger: A nearby ally casts a daily or recharge spell of 7th level or lower.
- Effect: The triggering ally doesn't expend that spell.
- Retain Focus: —.
- 9th level spell: A spell of 9th level or lower.
- **Champion Feat:** The triggering ally also gains temporary hit points equal to double your Wisdom modifier + the level of the triggering spell. In addition, that ally gains the temporary hit points again when they cast that spell this battle.
- **Epic Feat:** Your retain focus range with this spell is now 1–15.

**Liberating Blow**
- Close-quarters spell
- At-Will
- Interrupt action to cast; expend focus
- Trigger: A nearby ally fails a disengage check.
- Effect: The triggering ally can make a basic melee attack against an enemy engaged with it as a free action, but it uses your attack roll instead of its own: Intelligence + Level vs. MD. On a hit, the attack deals normal damage and the disengage check is successful.
- Retain Focus: 1–5.
- 9th level spell: The target can now make an at-will or close-quarters attack instead of a basic melee attack, using your attack roll.
- **Epic Feat:** The target's disengage check is successful whether or not the attack hits.

### 9th Level Spells

**Hasten Fate**
- Close-quarters spell
- Recharge 6+ after battle
- Interrupt action to cast; expend focus
- Trigger: A non-mook enemy drops to 0 hp while the escalation die is 3, 4, or 5.
- Effect: Increase the escalation die by 1.
- Retain Focus: —.
- **Epic Feat:** The spell now triggers when the escalation die is 2–5.

**Rewind the Skeins**
- Close-quarters spell
- Once per level
- Standard action to cast; you can only cast this spell out of battle
- Trigger: You realize that the last two minutes of out of battle roleplay or existence have gone horribly wrong and you want to rewind and try to redirect reality in a manner that you wish.
- Effect: Reality goes back two minutes. You remember what happened the first time. No one else does. This effect usually can't rewind past battles—it's designed for reliving or avoiding social interactions, roleplaying moments, traps, non-combat events, earthquakes, tarrasque appearances (if you could use it before rolling initiative!), and even icon relationship rolls.
- **Epic Feat:** Take it back five minutes.
