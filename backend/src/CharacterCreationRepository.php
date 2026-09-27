<?php

declare(strict_types=1);

final class CharacterCreationRepository
{
    public function __construct(private PDO $db)
    {
    }

    public function catalog(): array
    {
        return [
            'attributes' => $this->attributes(),
            'kins' => $this->kins(),
            'professions' => $this->professions(),
            'generalHeroicAbilities' => $this->generalHeroicAbilities(),
            'flaws' => $this->flaws(),
            'skills' => $this->learnableSkills(),
            'magic' => $this->magicCatalog(),
        ];
    }

    private function attributes(): array
    {
        return $this->db->query('SELECT code, name_de FROM attributes')->fetchAll();
    }

    private function kins(): array
    {
        $kins = $this->db->query(
            'SELECT code, name_de, d12_min, d12_max, movement_base FROM kins ORDER BY d12_min'
        )->fetchAll();

        $abilityStmt = $this->db->prepare(
            'SELECT name_de, wp_note_de, description_de FROM kin_heroic_abilities WHERE kin_code = :kin_code ORDER BY id'
        );

        foreach ($kins as &$kin) {
            $abilityStmt->execute(['kin_code' => $kin['code']]);
            $kin['abilities'] = $abilityStmt->fetchAll();
        }

        return $kins;
    }

    private function professions(): array
    {
        $professions = $this->db->query(
            'SELECT code, name_de, key_attribute_code, kin_restriction, grants_magic FROM professions ORDER BY name_de'
        )->fetchAll();

        $poolStmt = $this->db->prepare(<<<SQL
            SELECT sk.id, sk.name_de, sk.attribute_code, sk.description_de
            FROM profession_key_skills pks
            JOIN skills sk ON sk.id = pks.skill_id
            WHERE pks.profession_code = :profession_code
            ORDER BY sk.name_de
            SQL);

        $abilityStmt = $this->db->prepare(
            'SELECT id, name_de, requirement_de, wp_note_de, description_de, choice_group FROM profession_heroic_abilities
             WHERE profession_code = :profession_code AND granted_at_creation = 1'
        );

        $gearStmt = $this->db->prepare(<<<SQL
            SELECT pgo.id AS gear_option_id, pgo.option_label, pgo.extra_de, pgo.starting_silver_dice,
                   i.id AS item_id, i.name_de, i.kind, pgoi.quantity
            FROM profession_gear_options pgo
            JOIN profession_gear_option_items pgoi ON pgoi.gear_option_id = pgo.id
            JOIN items i ON i.id = pgoi.item_id
            WHERE pgo.profession_code = :profession_code
            ORDER BY pgo.option_label, i.name_de
            SQL);

        foreach ($professions as &$profession) {
            $profession['grants_magic'] = (bool) $profession['grants_magic'];

            $poolStmt->execute(['profession_code' => $profession['code']]);
            $profession['skillPool'] = $poolStmt->fetchAll();

            $abilityStmt->execute(['profession_code' => $profession['code']]);
            $profession['heroicAbilities'] = $abilityStmt->fetchAll();

            $gearStmt->execute(['profession_code' => $profession['code']]);
            $gearRows = $gearStmt->fetchAll();
            $options = [];
            foreach ($gearRows as $row) {
                $options[$row['gear_option_id']]['label'] ??= $row['option_label'];
                $options[$row['gear_option_id']]['extra_de'] ??= $row['extra_de'];
                $options[$row['gear_option_id']]['silverDice'] ??= $row['starting_silver_dice'];
                $options[$row['gear_option_id']]['items'][] = [
                    'itemId' => (int) $row['item_id'],
                    'name' => $row['name_de'],
                    'kind' => $row['kind'],
                    'quantity' => (int) $row['quantity'],
                ];
            }
            $profession['gearOptions'] = array_map(
                fn (int $id, array $option) => ['gearOptionId' => $id] + $option,
                array_keys($options),
                $options
            );
        }

        return $professions;
    }

    private function generalHeroicAbilities(): array
    {
        return $this->db->query(
            'SELECT name_de, requirement_de, wp_note_de, description_de FROM general_heroic_abilities ORDER BY id'
        )->fetchAll();
    }

    private function flaws(): array
    {
        return $this->db->query(
            'SELECT roll_min, roll_max, name_de, description_de FROM flaws ORDER BY roll_min'
        )->fetchAll();
    }

    private function learnableSkills(): array
    {
        return $this->db->query(
            "SELECT id, name_de, attribute_code, category, description_de FROM skills WHERE category != 'secondary' ORDER BY name_de"
        )->fetchAll();
    }

    private function magicCatalog(): array
    {
        return [
            'schools' => $this->db->query(
                "SELECT id, name_de, attribute_code, description_de FROM skills WHERE category = 'secondary' ORDER BY name_de"
            )->fetchAll(),
            'spells' => $this->db->query(<<<SQL
                SELECT id, name_de, type, school_skill_id, components_de, casting_time_de,
                       range_de, duration_de, wp_note_de, effect_de
                FROM spells
                ORDER BY school_skill_id IS NULL DESC, type DESC, name_de
                SQL)->fetchAll(),
        ];
    }

    private const AGE_TABLE = [
        'jung' => ['label' => 'Jung', 'total' => 8, 'modifiers' => ['GEW' => 1, 'KON' => 1]],
        'erwachsen' => ['label' => 'Erwachsen', 'total' => 10, 'modifiers' => []],
        'alt' => ['label' => 'Alt', 'total' => 12, 'modifiers' => ['STA' => -2, 'GEW' => -2, 'KON' => -2, 'INT' => 1, 'WIL' => 1]],
    ];

    /**
     * @param array{
     *     name_de: string, kin_code: string, profession_code: string, age_code: string,
     *     raw_attributes: array<string,int>, learned_skill_ids: int[],
     *     heroic_ability_choice: string, profession_heroic_ability_id?: int, flaw_roll: int, gear_option_id: int,
     *     rolled_silver?: int, memento_de: string, appearance_de: string,
     *     magic_school_skill_id?: int, known_trick_ids?: int[], known_spell_ids?: int[]
     * } $input
     */
    public function createCharacter(array $input): string
    {
        $ageCode = $input['age_code'] ?? '';
        if (!isset(self::AGE_TABLE[$ageCode])) {
            throw new InvalidArgumentException('Unbekanntes Alter.');
        }
        $age = self::AGE_TABLE[$ageCode];

        $name = trim((string) ($input['name_de'] ?? ''));
        if ($name === '') {
            throw new InvalidArgumentException('Name darf nicht leer sein.');
        }

        $kin = $this->fetchOne('SELECT * FROM kins WHERE code = :code', ['code' => $input['kin_code'] ?? '']);
        if ($kin === null) {
            throw new InvalidArgumentException('Unbekanntes Volk.');
        }

        $profession = $this->fetchOne('SELECT * FROM professions WHERE code = :code', ['code' => $input['profession_code'] ?? '']);
        if ($profession === null) {
            throw new InvalidArgumentException('Unbekannter Beruf.');
        }
        if ($profession['kin_restriction'] !== null && $profession['kin_restriction'] !== $kin['code']) {
            throw new InvalidArgumentException('Dieser Beruf ist nur für ' . $profession['kin_restriction'] . ' wählbar.');
        }

        $rawAttributes = $input['raw_attributes'] ?? [];
        $finalAttributes = [];
        foreach (['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'] as $code) {
            $value = $rawAttributes[$code] ?? null;
            if (!is_int($value) || $value < 3 || $value > 18) {
                throw new InvalidArgumentException("Attribut {$code} muss zwischen 3 und 18 liegen.");
            }
            $modified = $value + ($age['modifiers'][$code] ?? 0);
            if ($modified > 18) {
                throw new InvalidArgumentException("Attribut {$code} würde mit Alters-Modifikator auf {$modified} steigen (max. 18). Bitte einen anderen Rohwert wählen.");
            }
            $finalAttributes[$code] = $modified;
        }

        $learnedSkillIds = array_values(array_unique(array_map('intval', $input['learned_skill_ids'] ?? [])));
        if (count($learnedSkillIds) !== $age['total']) {
            throw new InvalidArgumentException("Es müssen genau {$age['total']} Fertigkeiten gelernt werden.");
        }

        // Magie-Schule vor der Pool-Prüfung validieren: bei grants_magic-Berufen
        // zählt die gewählte Schule als validierter zusätzlicher Pool-Eintrag,
        // obwohl sie serverseitig nicht in profession_key_skills steht (sie wird
        // im Wizard clientseitig an den Pool angehängt, siehe character-creation-wizard.js).
        $magicSchoolSkillId = null;
        $knownSpellIds = [];
        if ((bool) $profession['grants_magic']) {
            $magicSchoolSkillId = (int) ($input['magic_school_skill_id'] ?? 0);
            $school = $this->fetchOne(
                "SELECT id FROM skills WHERE id = :id AND category = 'secondary'",
                ['id' => $magicSchoolSkillId]
            );
            if ($school === null) {
                throw new InvalidArgumentException('Ungültige Zauberschule.');
            }

            $trickIds = array_values(array_unique(array_map('intval', $input['known_trick_ids'] ?? [])));
            $spellIds = array_values(array_unique(array_map('intval', $input['known_spell_ids'] ?? [])));
            if (count($trickIds) !== 3) {
                throw new InvalidArgumentException('Es müssen genau 3 Zaubertricks gewählt werden.');
            }
            if (count($spellIds) !== 3) {
                throw new InvalidArgumentException('Es müssen genau 3 Rang-1-Zauber gewählt werden.');
            }
            $this->assertSpellSelectionValid($trickIds, 'trick', $magicSchoolSkillId);
            $this->assertSpellSelectionValid($spellIds, 'spell', $magicSchoolSkillId);

            $knownSpellIds = array_merge($trickIds, $spellIds);
        }

        $poolStmt = $this->db->prepare('SELECT skill_id FROM profession_key_skills WHERE profession_code = :code');
        $poolStmt->execute(['code' => $profession['code']]);
        $poolSkillIds = array_map('intval', array_column($poolStmt->fetchAll(), 'skill_id'));
        if ($magicSchoolSkillId !== null) {
            $poolSkillIds[] = $magicSchoolSkillId;
        }

        $poolPicked = count(array_intersect($learnedSkillIds, $poolSkillIds));
        if ($poolPicked < 6) {
            throw new InvalidArgumentException('Mindestens 6 der gelernten Fertigkeiten müssen aus dem Berufs-Pool stammen.');
        }

        $heroicChoice = $input['heroic_ability_choice'] ?? 'profession';
        $talents = [];
        foreach ($kin['abilities'] ?? $this->kinAbilitiesFor($kin['code']) as $ability) {
            $talents[] = $ability;
        }
        if ($heroicChoice === 'robust' || $heroicChoice === 'fokussiert') {
            $general = $this->fetchOne(
                'SELECT name_de, wp_note_de, description_de FROM general_heroic_abilities WHERE name_de = :name',
                ['name' => $heroicChoice === 'robust' ? 'Robust' : 'Fokussiert']
            );
            if ($general === null) {
                throw new InvalidArgumentException('Unbekanntes allgemeines Heroisches Talent.');
            }
            $talents[] = $general;
        } elseif ($heroicChoice === 'profession') {
            $abilityStmt = $this->db->prepare(
                'SELECT id, name_de, wp_note_de, description_de FROM profession_heroic_abilities
                 WHERE profession_code = :code AND granted_at_creation = 1'
            );
            $abilityStmt->execute(['code' => $profession['code']]);
            $professionAbilities = $abilityStmt->fetchAll();

            if (count($professionAbilities) === 1) {
                $talents[] = $professionAbilities[0];
            } elseif (count($professionAbilities) > 1) {
                $chosenId = (int) ($input['profession_heroic_ability_id'] ?? 0);
                $chosen = null;
                foreach ($professionAbilities as $ability) {
                    if ((int) $ability['id'] === $chosenId) {
                        $chosen = $ability;
                        break;
                    }
                }
                if ($chosen === null) {
                    throw new InvalidArgumentException('Bitte eines der Heroischen Talente auswählen.');
                }
                $talents[] = $chosen;
            }
            // 0 Zeilen (Magier): kein Berufs-Talent, dafür Magie (s.u.).
        } else {
            throw new InvalidArgumentException('Ungültige Wahl des Heroischen Talents.');
        }

        if ((bool) $profession['grants_magic']) {
            $talents[] = [
                'name_de' => 'Magie',
                'wp_note_de' => null,
                'description_de' => 'Als Zauberer kannst du Magie benutzen.',
            ];
        }

        $flaw = $this->fetchOne(
            'SELECT name_de, description_de FROM flaws WHERE roll_min <= :roll AND roll_max >= :roll',
            ['roll' => (int) ($input['flaw_roll'] ?? 0)]
        );
        if ($flaw === null) {
            throw new InvalidArgumentException('Ungültige Schwäche.');
        }

        $gearOptionId = (int) ($input['gear_option_id'] ?? 0);
        $gearOption = $this->fetchOne(
            'SELECT extra_de, starting_silver_dice FROM profession_gear_options WHERE id = :id AND profession_code = :code',
            ['id' => $gearOptionId, 'code' => $profession['code']]
        );
        if ($gearOption === null) {
            throw new InvalidArgumentException('Ungültige Ausrüstungs-Option.');
        }

        $silverDice = (string) ($gearOption['starting_silver_dice'] ?? '');
        $rolledSilver = 0;
        if ($silverDice !== '') {
            $maxSilver = (int) substr($silverDice, 1);
            $rolledSilver = (int) ($input['rolled_silver'] ?? 0);
            if ($rolledSilver < 1 || $rolledSilver > $maxSilver) {
                throw new InvalidArgumentException("Gewürfeltes Silber muss zwischen 1 und {$maxSilver} liegen.");
            }
        }

        $gearItems = $this->db->prepare(<<<SQL
            SELECT i.id AS item_id, i.name_de, i.kind
            FROM profession_gear_option_items pgoi
            JOIN items i ON i.id = pgoi.item_id
            WHERE pgoi.gear_option_id = :gear_option_id
            SQL);
        $gearItems->execute(['gear_option_id' => $gearOptionId]);
        $gearRows = $gearItems->fetchAll();

        return $this->insertCharacter(
            $name, $kin, $profession, $age['label'], $finalAttributes,
            $learnedSkillIds, $talents, $flaw, $gearRows, (string) $gearOption['extra_de'], $rolledSilver,
            (string) ($input['memento_de'] ?? ''), (string) ($input['appearance_de'] ?? ''),
            $heroicChoice, $magicSchoolSkillId, $knownSpellIds
        );
    }

    private function fetchOne(string $sql, array $params): ?array
    {
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $row = $stmt->fetch();

        return $row === false ? null : $row;
    }

    /** @param int[] $ids */
    private function assertSpellSelectionValid(array $ids, string $type, int $schoolSkillId): void
    {
        $placeholders = implode(',', array_fill(0, count($ids), '?'));
        $stmt = $this->db->prepare(<<<SQL
            SELECT id FROM spells
            WHERE type = ? AND (school_skill_id IS NULL OR school_skill_id = ?) AND id IN ({$placeholders})
            SQL);
        $stmt->execute([$type, $schoolSkillId, ...$ids]);
        $found = array_map('intval', array_column($stmt->fetchAll(), 'id'));

        if (count(array_unique($found)) !== count($ids)) {
            $label = $type === 'trick' ? 'Zaubertricks' : 'Zauber';
            throw new InvalidArgumentException("Ungültige Auswahl bei den {$label}.");
        }
    }

    private function kinAbilitiesFor(string $kinCode): array
    {
        $stmt = $this->db->prepare(
            'SELECT name_de, wp_note_de, description_de FROM kin_heroic_abilities WHERE kin_code = :code ORDER BY id'
        );
        $stmt->execute(['code' => $kinCode]);

        return $stmt->fetchAll();
    }

    private function movement(string $kinCode, int $gew): int
    {
        $base = match ($kinCode) {
            'mensch', 'elf' => 10,
            'wolfsmensch' => 12,
            default => 8, // halbling, zwerg, ente
        };

        $modifier = match (true) {
            $gew <= 6 => -4,
            $gew <= 9 => -2,
            $gew <= 12 => 0,
            $gew <= 15 => 2,
            default => 4,
        };

        return $base + $modifier;
    }

    private function damageBonus(int $value): string
    {
        return match (true) {
            $value <= 12 => '—',
            $value <= 16 => 'W4',
            default => 'W6',
        };
    }

    private function baseChance(int $value): int
    {
        return match (true) {
            $value <= 5 => 3,
            $value <= 8 => 4,
            $value <= 12 => 5,
            $value <= 15 => 6,
            default => 7,
        };
    }

    private function slugify(string $name): string
    {
        $transliterated = strtr($name, [
            'ä' => 'ae', 'ö' => 'oe', 'ü' => 'ue', 'Ä' => 'ae', 'Ö' => 'oe', 'Ü' => 'ue', 'ß' => 'ss',
        ]);
        $slug = (string) preg_replace('/[^a-z0-9]+/', '_', strtolower($transliterated));
        $slug = trim($slug, '_');

        $candidate = $slug;
        $suffix = 2;
        while ($this->fetchOne('SELECT id FROM characters WHERE slug = :slug', ['slug' => $candidate]) !== null) {
            $candidate = $slug . '_' . $suffix;
            $suffix++;
        }

        return $candidate;
    }

    /**
     * @param int[] $learnedSkillIds
     * @param int[] $knownSpellIds
     */
    private function insertCharacter(
        string $name, array $kin, array $profession, string $ageLabel, array $finalAttributes,
        array $learnedSkillIds, array $talents, array $flaw, array $gearRows, string $gearExtraDe, int $rolledSilver,
        string $memento, string $appearance, string $heroicChoice,
        ?int $magicSchoolSkillId, array $knownSpellIds
    ): string {
        $slug = $this->slugify($name);
        $movement = $this->movement($kin['code'], $finalAttributes['GEW']);
        // Traglast = ceil(STA/2); nicht im Schnellstarter explizit, aber gegen alle 7 Pregens verifiziert.
        $carryingCapacity = (int) ceil($finalAttributes['STA'] / 2);
        $hpBonus = $heroicChoice === 'robust' ? 2 : 0;
        $wpBonus = $heroicChoice === 'fokussiert' ? 2 : 0;
        $hpMax = $finalAttributes['KON'] + $hpBonus;
        $wpMax = $finalAttributes['WIL'] + $wpBonus;
        $flawText = $flaw['name_de'] . '. ' . $flaw['description_de'];

        $this->db->beginTransaction();

        try {
            $insert = $this->db->prepare(<<<SQL
                INSERT INTO characters (
                    slug, name_de, kin_de, age_de, profession_de, flaw_de, appearance_de, memento_de,
                    movement, damage_bonus_sta_de, damage_bonus_gew_de, carrying_capacity,
                    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
                ) VALUES (
                    :slug, :name_de, :kin_de, :age_de, :profession_de, :flaw_de, :appearance_de, :memento_de,
                    :movement, :damage_bonus_sta_de, :damage_bonus_gew_de, :carrying_capacity,
                    :hp_max, :hp_max, :wp_max, :wp_max, 0, :coins_silver, 0
                )
                SQL);
            $insert->execute([
                'slug' => $slug,
                'name_de' => $name,
                'kin_de' => $kin['name_de'],
                'age_de' => $ageLabel,
                'profession_de' => $profession['name_de'],
                'flaw_de' => $flawText,
                'appearance_de' => $appearance,
                'memento_de' => $memento,
                'movement' => $movement,
                'damage_bonus_sta_de' => $this->damageBonus($finalAttributes['STA']),
                'damage_bonus_gew_de' => $this->damageBonus($finalAttributes['GEW']),
                'carrying_capacity' => $carryingCapacity,
                'hp_max' => $hpMax,
                'wp_max' => $wpMax,
                'coins_silver' => $rolledSilver,
            ]);
            $characterId = (int) $this->db->lastInsertId();

            $attributeInsert = $this->db->prepare(
                'INSERT INTO character_attributes (character_id, attribute_code, value) VALUES (:character_id, :code, :value)'
            );
            foreach ($finalAttributes as $code => $value) {
                $attributeInsert->execute(['character_id' => $characterId, 'code' => $code, 'value' => $value]);
            }

            $this->db->prepare('INSERT INTO character_conditions (character_id, condition_code, active) SELECT :character_id, code, 0 FROM conditions')
                ->execute(['character_id' => $characterId]);

            // Rüstung hat immer genau die 2 festen Slot-Zeilen (Kopf/Körper),
            // erst leer angelegt, dann unten aus den Ausrüstungsdaten befüllt.
            $armorSlotInsert = $this->db->prepare('INSERT INTO character_armor (character_id, slot) VALUES (:character_id, :slot)');
            foreach (['head', 'body'] as $slot) {
                $armorSlotInsert->execute(['character_id' => $characterId, 'slot' => $slot]);
            }

            $allSkills = $this->db->query('SELECT id, attribute_code, category FROM skills')->fetchAll();
            $skillInsert = $this->db->prepare(
                'INSERT INTO character_skills (character_id, skill_id, value) VALUES (:character_id, :skill_id, :value)'
            );
            foreach ($allSkills as $skill) {
                $skillId = (int) $skill['id'];
                $isLearned = in_array($skillId, $learnedSkillIds, true) || $skillId === $magicSchoolSkillId;
                if ($skill['category'] === 'secondary' && !$isLearned) {
                    // Magie-Schulen, in denen der Charakter nicht ausgebildet ist, haben
                    // laut Regelwerk keinen Basiswert (auch nicht als Magier).
                    $value = 0;
                } else {
                    $base = $this->baseChance($finalAttributes[$skill['attribute_code']]);
                    $value = $isLearned ? $base * 2 : $base;
                }
                $skillInsert->execute(['character_id' => $characterId, 'skill_id' => $skillId, 'value' => $value]);
            }

            if ($knownSpellIds !== []) {
                $spellInsert = $this->db->prepare(
                    'INSERT IGNORE INTO character_spells (character_id, spell_id) VALUES (:character_id, :spell_id)'
                );
                foreach ($knownSpellIds as $spellId) {
                    $spellInsert->execute(['character_id' => $characterId, 'spell_id' => $spellId]);
                }
            }

            $talentInsert = $this->db->prepare(
                'INSERT INTO character_talents (character_id, name_de, wp_note_de, description_de) VALUES (:character_id, :name_de, :wp_note_de, :description_de)'
            );
            foreach ($talents as $talent) {
                $talentInsert->execute([
                    'character_id' => $characterId,
                    'name_de' => $talent['name_de'],
                    'wp_note_de' => $talent['wp_note_de'] ?? null,
                    'description_de' => $talent['description_de'],
                ]);
            }

            // Waffen/Rüstung/Inventar sind Freitext: Katalog-Stats werden hier
            // einmalig gelesen und als Text übernommen, danach besteht kein
            // Katalog-Bezug mehr (siehe schema.sql-Kommentar an den Tabellen).
            $weaponInsert = $this->db->prepare(<<<SQL
                INSERT INTO character_weapons (character_id, position, name_de, grip_de, range_de, damage_de, traits_de)
                VALUES (:character_id, :position, :name_de, :grip_de, :range_de, :damage_de, :traits_de)
                SQL);
            $armorSlots = ['head' => null, 'body' => null];
            $inventoryInsert = $this->db->prepare(<<<SQL
                INSERT INTO character_inventory (character_id, position, name_de, quantity)
                VALUES (:character_id, :position, :name_de, 1)
                SQL);
            $position = 1;
            foreach ($gearRows as $gearItem) {
                if ($gearItem['kind'] === 'weapon') {
                    $stats = $this->fetchOne(
                        'SELECT grip_de, range_de, damage_de, traits_de FROM item_weapons WHERE item_id = :id',
                        ['id' => $gearItem['item_id']]
                    );
                    $weaponInsert->execute([
                        'character_id' => $characterId, 'position' => $position++,
                        'name_de' => $gearItem['name_de'], 'grip_de' => $stats['grip_de'],
                        'range_de' => $stats['range_de'], 'damage_de' => $stats['damage_de'],
                        'traits_de' => $stats['traits_de'],
                    ]);
                } elseif ($gearItem['kind'] === 'armor') {
                    $stats = $this->fetchOne(
                        'SELECT slot, armor_value, penalty_skills_de FROM item_armor WHERE item_id = :id',
                        ['id' => $gearItem['item_id']]
                    );
                    $armorSlots[$stats['slot']] = [
                        'name_de' => $gearItem['name_de'],
                        'armor_value' => $stats['armor_value'],
                        'penalty_de' => $stats['penalty_skills_de'],
                    ];
                } else {
                    $inventoryInsert->execute(['character_id' => $characterId, 'position' => $position++, 'name_de' => $gearItem['name_de']]);
                }
            }

            $armorUpdate = $this->db->prepare(
                'UPDATE character_armor SET name_de = :name_de, armor_value = :armor_value, penalty_de = :penalty_de
                 WHERE character_id = :character_id AND slot = :slot'
            );
            foreach (['head', 'body'] as $slot) {
                $data = $armorSlots[$slot];
                $armorUpdate->execute([
                    'character_id' => $characterId, 'slot' => $slot,
                    'name_de' => $data['name_de'] ?? null,
                    'armor_value' => $data['armor_value'] ?? null,
                    'penalty_de' => $data['penalty_de'] ?? null,
                ]);
            }

            // Freetext-Ausrüstung aus der Option (Fackel, Feuerstein & Zunder,
            // Tagesrationen etc. -- ohne Silber, siehe rolledSilver oben) wird
            // in einzelne Inventarzeilen aufgesplittet statt als ein Flair-Textblock.
            if (trim($gearExtraDe) !== '') {
                foreach (explode(', ', $gearExtraDe) as $piece) {
                    $inventoryInsert->execute(['character_id' => $characterId, 'position' => $position++, 'name_de' => trim($piece)]);
                }
            }

            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }

        return $slug;
    }
}
