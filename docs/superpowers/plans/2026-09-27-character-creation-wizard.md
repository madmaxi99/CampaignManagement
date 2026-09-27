# Charaktererstellungs-Wizard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ein geführter Wizard auf `/character/create`, der einen Spieler durch die Standard-Dragonbane-Charaktererstellung führt und am Ende einen vollständigen, spielfertigen Charakter in der bestehenden DB anlegt.

**Architecture:** `GET /character/create` liefert eine leere Twig-Shell; ein neues Vanilla-JS-Modul (`character-creation-wizard.js`) hält den gesamten Wizard-Zustand clientseitig, holt einmalig die Katalogdaten (Kins/Professionen/Talente/Flaws/Fertigkeiten) über `GET /api/character-creation/catalog` und schreibt erst am Ende per `POST /characters` alles auf einmal. Eine neue `CharacterCreationRepository`-Klasse kapselt sowohl das Katalog-Auslesen als auch das Anlegen; die bestehende `CharacterRepository` (liest/schreibt den fertigen Bogen) bleibt unangetastet.

**Tech Stack:** PHP 8 / Slim 4 / Twig (bestehender Stack, keine neuen Abhängigkeiten), Vanilla JS, MariaDB.

**Spec:** `docs/superpowers/specs/2026-09-27-character-creation-wizard-design.md`

## Global Constraints

- Kein `git commit` in irgendeinem Task-Schritt — der Nutzer committet selbst, wenn er bereit ist (globale Nutzerregel, überschreibt das Standard-"Commit"-Step-Muster dieses Skills). Jeder Task endet stattdessen mit einem Verifikationsschritt.
- Mehrzeilige SQL-Strings in PHP-Dateien immer als Heredoc (`<<<SQL ... SQL;`), nie mit escaped Quotes — bestehende Konvention in `CharacterRepository.php`.
- Code-Identifier auf Englisch, Spieltext (Namen, Beschreibungen, UI-Copy) auf Deutsch — bestehende Projektkonvention.
- Kein virtueller Würfel irgendwo im Wizard (Nutzerregel aus der Spec) — nur Eingabefelder für Werte, die am Tisch mit echten Würfeln ermittelt wurden.
- Kein automatisiertes Test-Setup im Projekt (kein PHPUnit, kein JS-Test-Runner) — Verifikation läuft über echte `curl`-Aufrufe gegen den laufenden Dev-Stack (`http://localhost:8090`, Container `provisioning-nginx-1`/`provisioning-php-fpm-1`/`provisioning-mariadb-1` sind bereits hochgefahren) und direkte SQL-Checks über `docker exec provisioning-mariadb-1 mariadb -uflyka -pqwert flyka -e "..."`. Nach PHP-Änderungen zusätzlich `php -l` zur Syntaxprüfung.
- Alle neuen Katalog-Tabellen (`kins`, `kin_heroic_abilities`, `professions`, `profession_key_skills`, `profession_heroic_abilities`, `general_heroic_abilities`, `profession_gear_options`, `profession_gear_option_items`, `flaws`) existieren bereits in der laufenden DB und in `database/schema.sql`/`database/seed_character_creation_catalog.sql` — dieser Plan erzeugt keine weiteren Schema-Änderungen.

## Review Focus

- **Doppelter Name/Slug:** zwei Charaktere mit gleichem Namen anlegen — der zweite darf nicht am `UNIQUE`-Constraint auf `characters.slug` scheitern, sondern braucht einen eindeutigen Slug (z. B. Suffix `-2`).
- **Zu wenige/zu viele gewählte Fertigkeiten:** Client schickt eine andere Anzahl `learned_skill_ids` als die Alterstabelle vorgibt (8/10/12) — Server muss das ablehnen, nicht stillschweigend einen falschen Charakter anlegen.
- **Weniger als 6 Fertigkeiten aus dem Berufs-Pool:** Client schickt z. B. nur 3 Pool-Fertigkeiten und 7 freie — Server muss das ablehnen (RAW verlangt genau 6 aus dem 8er-Pool).
- **Zwerg-exklusiver Beruf mit falschem Volk:** Client schickt `profession_code=zwergenkaempfer` mit `kin_code=elf` — Server muss das ablehnen (`kin_restriction` missachtet).
- **Attributwert außerhalb des plausiblen Bereichs:** Client schickt z. B. `STA: 99` (Tippfehler beim Abtippen der Würfel) — Server muss Werte außerhalb 3–18 vor dem Anlegen ablehnen, statt einen kaputten Charakter zu erzeugen.

---

## Task 1: Katalog-Lesezugriff (`GET /api/character-creation/catalog`)

**Files:**
- Create: `backend/src/CharacterCreationRepository.php`
- Modify: `backend/public/index.php`

**Interfaces:**
- Produces: `CharacterCreationRepository::catalog(): array` — liefert die komplette, verschachtelte Katalogstruktur (siehe unten), die Task 4 als JSON ausliefert und die das JS in Task 5/6 konsumiert.

- [ ] **Step 1: `CharacterCreationRepository.php` mit dem Katalog-Lesezugriff anlegen**

```php
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
            'SELECT code, name_de, key_attribute_code, kin_restriction FROM professions ORDER BY name_de'
        )->fetchAll();

        $poolStmt = $this->db->prepare(<<<SQL
            SELECT sk.id, sk.name_de, sk.attribute_code
            FROM profession_key_skills pks
            JOIN skills sk ON sk.id = pks.skill_id
            WHERE pks.profession_code = :profession_code
            ORDER BY sk.name_de
            SQL);

        $abilityStmt = $this->db->prepare(
            'SELECT name_de, requirement_de, wp_note_de, description_de FROM profession_heroic_abilities
             WHERE profession_code = :profession_code AND granted_at_creation = 1'
        );

        $gearStmt = $this->db->prepare(<<<SQL
            SELECT pgo.id AS gear_option_id, pgo.option_label, i.id AS item_id, i.name_de, i.kind, pgoi.quantity
            FROM profession_gear_options pgo
            JOIN profession_gear_option_items pgoi ON pgoi.gear_option_id = pgo.id
            JOIN items i ON i.id = pgoi.item_id
            WHERE pgo.profession_code = :profession_code
            ORDER BY pgo.option_label, i.name_de
            SQL);

        foreach ($professions as &$profession) {
            $poolStmt->execute(['profession_code' => $profession['code']]);
            $profession['skillPool'] = $poolStmt->fetchAll();

            $abilityStmt->execute(['profession_code' => $profession['code']]);
            $ability = $abilityStmt->fetch();
            $profession['heroicAbility'] = $ability === false ? null : $ability;

            $gearStmt->execute(['profession_code' => $profession['code']]);
            $gearRows = $gearStmt->fetchAll();
            $options = [];
            foreach ($gearRows as $row) {
                $options[$row['gear_option_id']]['label'] ??= $row['option_label'];
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
            "SELECT id, name_de, attribute_code, category FROM skills WHERE category != 'secondary' ORDER BY name_de"
        )->fetchAll();
    }
}
```

- [ ] **Step 2: Repository laden und Route in `backend/public/index.php` verdrahten**

Nach der bestehenden Zeile `require __DIR__ . '/../src/EntityLinker.php';` ergänzen:

```php
require __DIR__ . '/../src/CharacterCreationRepository.php';
```

Nach der Zeile `$campaignRepository = new CampaignRepository($db);` ergänzen:

```php
$characterCreationRepository = new CharacterCreationRepository($db);
```

Direkt vor der bestehenden Route `$app->get('/characters', ...)` einfügen:

```php
$app->get('/api/character-creation/catalog', function (Request $request, Response $response) use ($characterCreationRepository) {
    return jsonResponse($response, $characterCreationRepository->catalog());
});
```

- [ ] **Step 3: Syntax prüfen**

Run: `php -l backend/src/CharacterCreationRepository.php && php -l backend/public/index.php`
Expected: beide Male `No syntax errors detected`

- [ ] **Step 4: Endpunkt gegen den laufenden Dev-Stack verifizieren**

Run:
```bash
curl -s http://localhost:8090/api/character-creation/catalog | python3 -c "
import json, sys
data = json.load(sys.stdin)
assert len(data['kins']) == 6, data['kins']
assert len(data['professions']) == 7, len(data['professions'])
jaeger = next(p for p in data['professions'] if p['code'] == 'jaeger')
assert len(jaeger['skillPool']) == 8, jaeger['skillPool']
assert jaeger['heroicAbility']['name_de'] == 'Gefährte', jaeger['heroicAbility']
assert len(data['flaws']) == 20, len(data['flaws'])
assert len(data['generalHeroicAbilities']) == 2, data['generalHeroicAbilities']
print('OK', len(data['skills']), 'skills')
"
```
Expected: `OK 30 skills` ohne `AssertionError`.

---

## Task 2: Charakter-Anlage (`POST /characters`)

**Files:**
- Modify: `backend/src/CharacterCreationRepository.php`
- Modify: `backend/public/index.php`

**Interfaces:**
- Consumes: dieselbe PDO-Instanz wie Task 1; liest `attributes`/`kins`/`professions`/`profession_heroic_abilities`/`general_heroic_abilities`/`flaws`/`skills`/`profession_gear_option_items`/`items` (alle bereits befüllt).
- Produces: `CharacterCreationRepository::createCharacter(array $input): string` (gibt den neu erzeugten `slug` zurück), wirft `InvalidArgumentException` mit einer sprechenden Meldung bei ungültiger Eingabe. Task 6 (Wizard-JS) sendet exakt die Eingabestruktur, die unten in Step 1 als `$input`-Docblock beschrieben ist.

- [ ] **Step 1: Regel-Konstanten und Validierung ergänzen**

An das Ende der Klasse `CharacterCreationRepository` (vor der schließenden `}`):

```php
    private const AGE_TABLE = [
        'jung' => ['label' => 'Jung', 'total' => 8, 'modifiers' => ['GEW' => 1, 'KON' => 1]],
        'erwachsen' => ['label' => 'Erwachsen', 'total' => 10, 'modifiers' => []],
        'alt' => ['label' => 'Alt', 'total' => 12, 'modifiers' => ['STA' => -2, 'GEW' => -2, 'KON' => -2, 'INT' => 1, 'WIL' => 1]],
    ];

    /**
     * @param array{
     *     name_de: string, kin_code: string, profession_code: string, age_code: string,
     *     raw_attributes: array<string,int>, learned_skill_ids: int[],
     *     heroic_ability_choice: string, flaw_roll: int, gear_option_id: int,
     *     memento_de: string, appearance_de: string, misc_items_de: string
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
            $finalAttributes[$code] = min(18, $modified);
        }

        $learnedSkillIds = array_values(array_unique(array_map('intval', $input['learned_skill_ids'] ?? [])));
        if (count($learnedSkillIds) !== $age['total']) {
            throw new InvalidArgumentException("Es müssen genau {$age['total']} Fertigkeiten gelernt werden.");
        }

        $poolStmt = $this->db->prepare('SELECT skill_id FROM profession_key_skills WHERE profession_code = :code');
        $poolStmt->execute(['code' => $profession['code']]);
        $poolSkillIds = array_map('intval', array_column($poolStmt->fetchAll(), 'skill_id'));

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
            $professionAbility = $this->fetchOne(
                'SELECT name_de, wp_note_de, description_de FROM profession_heroic_abilities
                 WHERE profession_code = :code AND granted_at_creation = 1',
                ['code' => $profession['code']]
            );
            if ($professionAbility !== null) {
                $talents[] = $professionAbility;
            }
        } else {
            throw new InvalidArgumentException('Ungültige Wahl des Heroischen Talents.');
        }

        $flaw = $this->fetchOne(
            'SELECT name_de, description_de FROM flaws WHERE roll_min <= :roll AND roll_max >= :roll',
            ['roll' => (int) ($input['flaw_roll'] ?? 0)]
        );
        if ($flaw === null) {
            throw new InvalidArgumentException('Ungültige Schwäche.');
        }

        $gearItems = $this->db->prepare(<<<SQL
            SELECT i.id AS item_id, i.name_de, i.kind
            FROM profession_gear_option_items pgoi
            JOIN items i ON i.id = pgoi.item_id
            WHERE pgoi.gear_option_id = :gear_option_id
            SQL);
        $gearItems->execute(['gear_option_id' => (int) ($input['gear_option_id'] ?? 0)]);
        $gearRows = $gearItems->fetchAll();
        if ($gearRows === []) {
            throw new InvalidArgumentException('Ungültige Ausrüstungs-Option.');
        }

        return $this->insertCharacter(
            $name, $kin, $profession, $age['label'], $finalAttributes,
            $learnedSkillIds, $talents, $flaw, $gearRows,
            (string) ($input['memento_de'] ?? ''), (string) ($input['appearance_de'] ?? ''),
            (string) ($input['misc_items_de'] ?? ''), $heroicChoice
        );
    }

    private function fetchOne(string $sql, array $params): ?array
    {
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        $row = $stmt->fetch();

        return $row === false ? null : $row;
    }

    private function kinAbilitiesFor(string $kinCode): array
    {
        $stmt = $this->db->prepare(
            'SELECT name_de, wp_note_de, description_de FROM kin_heroic_abilities WHERE kin_code = :code ORDER BY id'
        );
        $stmt->execute(['code' => $kinCode]);

        return $stmt->fetchAll();
    }
```

- [ ] **Step 2: Ableitungs-Formeln, Slug-Erzeugung und den eigentlichen INSERT-Block ergänzen**

Direkt nach der `kinAbilitiesFor`-Methode einfügen:

```php
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
        $slug = strtolower((string) preg_replace('/[^a-z0-9]+/', '_', $transliterated));
        $slug = trim($slug, '_');

        $candidate = $slug;
        $suffix = 2;
        while ($this->fetchOne('SELECT id FROM characters WHERE slug = :slug', ['slug' => $candidate]) !== null) {
            $candidate = $slug . '_' . $suffix;
            $suffix++;
        }

        return $candidate;
    }

    private function insertCharacter(
        string $name, array $kin, array $profession, string $ageLabel, array $finalAttributes,
        array $learnedSkillIds, array $talents, array $flaw, array $gearRows,
        string $memento, string $appearance, string $miscItems, string $heroicChoice
    ): string {
        $slug = $this->slugify($name);
        $movement = $this->movement($kin['code'], $finalAttributes['GEW']);
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
                    slug, name_de, kin_de, age_de, profession_de, flaw_de, appearance_de, memento_de, misc_items_de,
                    movement, damage_bonus_sta_de, damage_bonus_gew_de, carrying_capacity,
                    hp_max, hp_current, wp_max, wp_current, coins_gold, coins_silver, coins_copper
                ) VALUES (
                    :slug, :name_de, :kin_de, :age_de, :profession_de, :flaw_de, :appearance_de, :memento_de, :misc_items_de,
                    :movement, :damage_bonus_sta_de, :damage_bonus_gew_de, :carrying_capacity,
                    :hp_max, :hp_max, :wp_max, :wp_max, 0, 0, 0
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
                'misc_items_de' => $miscItems,
                'movement' => $movement,
                'damage_bonus_sta_de' => $this->damageBonus($finalAttributes['STA']),
                'damage_bonus_gew_de' => $this->damageBonus($finalAttributes['GEW']),
                'carrying_capacity' => $carryingCapacity,
                'hp_max' => $hpMax,
                'wp_max' => $wpMax,
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

            $allSkills = $this->db->query('SELECT id, attribute_code FROM skills WHERE category != \'secondary\'')->fetchAll();
            $skillInsert = $this->db->prepare(
                'INSERT INTO character_skills (character_id, skill_id, value) VALUES (:character_id, :skill_id, :value)'
            );
            foreach ($allSkills as $skill) {
                $skillId = (int) $skill['id'];
                $base = $this->baseChance($finalAttributes[$skill['attribute_code']]);
                $value = in_array($skillId, $learnedSkillIds, true) ? $base * 2 : $base;
                $skillInsert->execute(['character_id' => $characterId, 'skill_id' => $skillId, 'value' => $value]);
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

            $weaponInsert = $this->db->prepare('INSERT INTO character_weapons (character_id, item_id, quantity) VALUES (:character_id, :item_id, 1)');
            $armorInsert = $this->db->prepare('INSERT INTO character_armor (character_id, item_id, quantity) VALUES (:character_id, :item_id, 1)');
            $inventoryPosition = 1;
            $inventoryInsert = $this->db->prepare('INSERT INTO character_inventory (character_id, position, item_id, quantity) VALUES (:character_id, :position, :item_id, 1)');
            foreach ($gearRows as $gearItem) {
                match ($gearItem['kind']) {
                    'weapon' => $weaponInsert->execute(['character_id' => $characterId, 'item_id' => $gearItem['item_id']]),
                    'armor' => $armorInsert->execute(['character_id' => $characterId, 'item_id' => $gearItem['item_id']]),
                    default => $inventoryInsert->execute(['character_id' => $characterId, 'position' => $inventoryPosition++, 'item_id' => $gearItem['item_id']]),
                };
            }

            $this->db->commit();
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }

        return $slug;
    }
```

- [ ] **Step 3: Route in `backend/public/index.php` ergänzen**

Direkt nach der neuen `GET /api/character-creation/catalog`-Route einfügen:

```php
$app->post('/characters', function (Request $request, Response $response) use ($characterCreationRepository) {
    $body = json_decode((string) $request->getBody(), true) ?? [];

    try {
        $slug = $characterCreationRepository->createCharacter($body);
    } catch (InvalidArgumentException $e) {
        $response->getBody()->write(json_encode(['error' => $e->getMessage()]));

        return $response->withHeader('Content-Type', 'application/json')->withStatus(422);
    }

    return jsonResponse($response, ['slug' => $slug]);
});
```

- [ ] **Step 4: Syntax prüfen**

Run: `php -l backend/src/CharacterCreationRepository.php`
Expected: `No syntax errors detected`

- [ ] **Step 5: End-to-end gegen den laufenden Dev-Stack verifizieren**

Run:
```bash
curl -s -X POST http://localhost:8090/characters -H 'Content-Type: application/json' -d '{
  "name_de": "Plan Testcharakter",
  "kin_code": "mensch",
  "profession_code": "jaeger",
  "age_code": "erwachsen",
  "raw_attributes": {"STA": 11, "KON": 14, "GEW": 15, "INT": 10, "WIL": 9, "CHA": 12},
  "learned_skill_ids": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  "heroic_ability_choice": "profession",
  "flaw_roll": 4,
  "gear_option_id": 1,
  "memento_de": "Ein Testgegenstand",
  "appearance_de": "Testaussehen",
  "misc_items_de": "Feuerstein & Zunder"
}'
```
(Die `skill_id`/`gear_option_id`-Werte hängen von der Insert-Reihenfolge der Seeds ab — vorher mit `docker exec provisioning-mariadb-1 mariadb -uflyka -pqwert flyka -e "SELECT id, name_de FROM skills LIMIT 10; SELECT id FROM profession_gear_options WHERE profession_code='jaeger';"` die tatsächlichen IDs nachschlagen und im Payload einsetzen, falls `422` mit einer Validierungsmeldung zurückkommt.)

Expected: `{"slug":"plan_testcharakter"}` (HTTP 200). Danach:
```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8090/character/plan_testcharakter
docker exec provisioning-mariadb-1 mariadb -uflyka -pqwert flyka -e "SELECT COUNT(*) FROM character_skills WHERE character_id = (SELECT id FROM characters WHERE slug='plan_testcharakter');"
```
Expected: `200`, und die Skill-Anzahl ist `30`. Danach den Testcharakter wieder entfernen: `docker exec provisioning-mariadb-1 mariadb -uflyka -pqwert flyka -e "DELETE FROM characters WHERE slug='plan_testcharakter';"` (kaskadiert über die `ON DELETE CASCADE`-Foreign-Keys auf alle Unterzeilen).

---

## Task 3: Wizard-Shell, Route und Einstiegs-Button

**Files:**
- Create: `backend/templates/character/create.twig`
- Modify: `backend/public/index.php`
- Modify: `backend/templates/characters/list.twig`
- Modify: `backend/public/css/style.css`

**Interfaces:**
- Produces: DOM-Element `<div class="wizard" data-catalog-url="/api/character-creation/catalog"></div>`, das Task 5 im JS mit `document.querySelector('.wizard')` findet und komplett selbst befüllt.

- [ ] **Step 1: Twig-Shell anlegen**

```twig
{% extends "layout.twig" %}

{% block title %}Charakter erstellen{% endblock %}

{% block content %}
<div class="wizard" data-catalog-url="/api/character-creation/catalog"></div>
<script src="/js/character-creation-wizard.js"></script>
{% endblock %}
```

- [ ] **Step 2: Route registrieren**

In `backend/public/index.php` direkt vor `$app->get('/character/{slug}', ...)` einfügen:

```php
$app->get('/character/create', function (Request $request, Response $response) {
    $twig = Twig::fromRequest($request);

    return $twig->render($response, 'character/create.twig');
});
```

- [ ] **Step 3: Button auf der Charakterliste ergänzen**

In `backend/templates/characters/list.twig`, direkt nach `{% block content %}`:

```twig
{% block content %}
    <a class="button-primary" href="/character/create">Charakter erstellen</a>
```

(Die bestehende `{{ grid_page.render(...) }}`-Zeile bleibt danach unverändert stehen, nur die neue Zeile davor einfügen.)

- [ ] **Step 4: Minimalen Button-Stil in `style.css` ergänzen**

Ans Ende der Datei anhängen:

```css
.button-primary {
    display: inline-block;
    margin-bottom: 1rem;
    padding: 0.6rem 1.2rem;
    background: #2f5233;
    color: #fff;
    text-decoration: none;
    border-radius: 4px;
    font-weight: bold;
}

.button-primary:hover {
    background: #24401f;
}

.wizard {
    max-width: 720px;
    margin: 0 auto;
}

.wizard-step h2 {
    margin-top: 0;
}

.wizard-nav {
    display: flex;
    justify-content: space-between;
    margin-top: 1.5rem;
}

.wizard-error {
    color: #b23b3b;
    font-weight: bold;
}
```

- [ ] **Step 5: Syntax/Erreichbarkeit prüfen**

Run:
```bash
php -l backend/public/index.php
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8090/character/create
curl -s http://localhost:8090/characters | grep -o 'Charakter erstellen'
```
Expected: `No syntax errors detected`, `200`, `Charakter erstellen`.

---

## Task 4: Wizard-JS — Zustand, Navigation, Schritte 1–5 (Volk, Beruf, Name/Alter, Attribute, Fertigkeiten)

**Files:**
- Create: `backend/public/js/character-creation-wizard.js`

**Interfaces:**
- Consumes: `GET /api/character-creation/catalog` (Shape aus Task 1), DOM-Element `.wizard` aus Task 3.
- Produces: globaler Modul-State `state` sowie die Funktionen `render()`, `goTo(step)`, `AGE_TABLE`, `baseChance(value)`, `finalAttributes()`, `learnedSkillIds()` — Task 5 hängt sich mit den Schritten 6–10 und dem Submit an dieselbe `render`-Switch-Anweisung an derselben Datei an.

- [ ] **Step 1: Datei mit Zustand, Hilfsfunktionen und Schritt-Grundgerüst anlegen**

```javascript
(function () {
    const root = document.querySelector('.wizard');
    if (!root) {
        return;
    }

    const ATTRIBUTE_ORDER = ['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'];
    const ATTRIBUTE_LABELS = { STA: 'Stärke', KON: 'Konstitution', GEW: 'Gewandtheit', INT: 'Intelligenz', WIL: 'Willenskraft', CHA: 'Charisma' };

    const AGE_TABLE = {
        jung: { label: 'Jung', extra: 2, total: 8, modifiers: { GEW: 1, KON: 1 } },
        erwachsen: { label: 'Erwachsen', extra: 4, total: 10, modifiers: {} },
        alt: { label: 'Alt', extra: 6, total: 12, modifiers: { STA: -2, GEW: -2, KON: -2, INT: 1, WIL: 1 } },
    };

    let catalog = null;

    const state = {
        step: 1,
        kinCode: null,
        professionCode: null,
        nameDe: '',
        ageCode: null,
        rawAttributes: { STA: null, KON: null, GEW: null, INT: null, WIL: null, CHA: null },
        swapUsed: false,
        poolPicks: [],
        extraPicks: [],
        heroicAbilityChoice: 'profession',
        flawRoll: null,
        gearOptionId: null,
        mementoDe: '',
        appearanceDe: '',
        miscItemsDe: 'Feuerstein & Zunder, 4 Tagesrationen, Rucksack',
        error: '',
    };

    function baseChance(value) {
        if (value <= 5) return 3;
        if (value <= 8) return 4;
        if (value <= 12) return 5;
        if (value <= 15) return 6;
        return 7;
    }

    function movementModifier(gew) {
        if (gew <= 6) return -4;
        if (gew <= 9) return -2;
        if (gew <= 12) return 0;
        if (gew <= 15) return 2;
        return 4;
    }

    function damageBonus(value) {
        if (value <= 12) return '—';
        if (value <= 16) return 'W4';
        return 'W6';
    }

    function selectedKin() {
        return catalog.kins.find((kin) => kin.code === state.kinCode) || null;
    }

    function selectedProfession() {
        return catalog.professions.find((profession) => profession.code === state.professionCode) || null;
    }

    function finalAttributes() {
        const age = AGE_TABLE[state.ageCode] || { modifiers: {} };
        const result = {};
        ATTRIBUTE_ORDER.forEach((code) => {
            const raw = state.rawAttributes[code] || 0;
            result[code] = Math.min(18, raw + (age.modifiers[code] || 0));
        });
        return result;
    }

    function skillById(id) {
        return catalog.skills.find((skill) => skill.id === id);
    }

    function goTo(step) {
        state.step = step;
        state.error = '';
        render();
    }

    function setError(message) {
        state.error = message;
        render();
    }

    function render() {
        root.innerHTML = `
            <div class="wizard-step">
                ${state.error ? `<p class="wizard-error">${state.error}</p>` : ''}
                ${renderStep()}
            </div>
        `;
        attachHandlers();
    }

    function renderStep() {
        switch (state.step) {
            case 1: return renderKinStep();
            case 2: return renderProfessionStep();
            case 3: return renderNameAgeStep();
            case 4: return renderAttributesStep();
            case 5: return renderSkillsStep();
            default: return renderPlaceholderStep();
        }
    }

    function renderPlaceholderStep() {
        return '<p>Dieser Schritt wird von Task 5 ergänzt.</p>';
    }

    // --- Schritt 1: Volk ---

    function renderKinStep() {
        const rows = catalog.kins.map((kin) => `
            <label class="wizard-choice">
                <input type="radio" name="kin" value="${kin.code}" ${state.kinCode === kin.code ? 'checked' : ''}>
                ${kin.name_de} <small>(W12: ${kin.d12_min}${kin.d12_max > kin.d12_min ? '–' + kin.d12_max : ''})</small>
                <p>${kin.abilities.map((a) => a.name_de).join(', ')}</p>
            </label>
        `).join('');

        return `
            <h2>1. Volk</h2>
            <p>Wähle dein Volk, oder würfle W12 am Tisch und wähle die passende Zeile.</p>
            ${rows}
            <div class="wizard-nav">
                <span></span>
                <button type="button" id="next-step" ${state.kinCode ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 2: Beruf ---

    function renderProfessionStep() {
        const kin = selectedKin();
        const options = catalog.professions.filter((p) => p.kin_restriction === null || p.kin_restriction === kin.code);
        const rows = options.map((profession) => `
            <label class="wizard-choice">
                <input type="radio" name="profession" value="${profession.code}" ${state.professionCode === profession.code ? 'checked' : ''}>
                ${profession.name_de} <small>(Schlüsselattribut ${ATTRIBUTE_LABELS[profession.key_attribute_code]})</small>
                <p>Fertigkeiten-Pool: ${profession.skillPool.map((s) => s.name_de).join(', ')}</p>
                <p>Heroisches Talent: ${profession.heroicAbility ? profession.heroicAbility.name_de : '—'}</p>
            </label>
        `).join('');

        return `
            <h2>2. Beruf</h2>
            ${rows}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${state.professionCode ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 3: Name & Alter ---

    function renderNameAgeStep() {
        const ageRows = Object.entries(AGE_TABLE).map(([code, age]) => `
            <label class="wizard-choice">
                <input type="radio" name="age" value="${code}" ${state.ageCode === code ? 'checked' : ''}>
                ${age.label} <small>(6 + ${age.extra} = ${age.total} Fertigkeiten)</small>
            </label>
        `).join('');

        return `
            <h2>2.5 Name &amp; Alter</h2>
            <label>Name<br><input type="text" id="name-input" value="${state.nameDe}" maxlength="100"></label>
            <p>Alter (W6 am Tisch würfeln oder direkt wählen: 1–3 Jung, 4–5 Erwachsen, 6 Alt):</p>
            ${ageRows}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${state.nameDe.trim() && state.ageCode ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 4: Attribute ---

    function renderAttributesStep() {
        const inputs = ATTRIBUTE_ORDER.map((code) => `
            <label>${ATTRIBUTE_LABELS[code]} (${code})<br>
                <input type="number" min="3" max="18" class="attribute-input" data-code="${code}" value="${state.rawAttributes[code] ?? ''}">
            </label>
        `).join('');

        const swapOptions = ATTRIBUTE_ORDER.map((code) => `<option value="${code}">${code}</option>`).join('');
        const allFilled = ATTRIBUTE_ORDER.every((code) => Number.isInteger(state.rawAttributes[code]));

        return `
            <h2>3. Attribute</h2>
            <p>Würfle 4W6, entferne den niedrigsten Wurf, sechsmal in der Reihenfolge STA, KON, GEW, INT, WIL, CHA.
               Trage die sechs Ergebnisse ein.</p>
            <div class="attribute-grid">${inputs}</div>
            <p>Danach darfst du zwei Werte genau einmal tauschen:</p>
            <select id="swap-a">${swapOptions}</select>
            <select id="swap-b">${swapOptions}</select>
            <button type="button" id="swap-button" ${state.swapUsed ? 'disabled' : ''}>Tauschen</button>
            ${state.swapUsed ? '<p><small>Tausch bereits verwendet.</small></p>' : ''}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${allFilled ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 5: Fertigkeiten ---

    function renderSkillsStep() {
        const profession = selectedProfession();
        const age = AGE_TABLE[state.ageCode];
        const attrs = finalAttributes();

        const poolRows = profession.skillPool.map((skill) => `
            <label class="wizard-choice-inline">
                <input type="checkbox" class="pool-pick" value="${skill.id}" ${state.poolPicks.includes(skill.id) ? 'checked' : ''}>
                ${skill.name_de} (Basis ${baseChance(attrs[skill.attribute_code])}, gelernt ${baseChance(attrs[skill.attribute_code]) * 2})
            </label>
        `).join('');

        const extraCandidates = catalog.skills.filter((skill) => !state.poolPicks.includes(skill.id));
        const extraRows = extraCandidates.map((skill) => `
            <label class="wizard-choice-inline">
                <input type="checkbox" class="extra-pick" value="${skill.id}" ${state.extraPicks.includes(skill.id) ? 'checked' : ''}>
                ${skill.name_de} (Basis ${baseChance(attrs[skill.attribute_code])}, gelernt ${baseChance(attrs[skill.attribute_code]) * 2})
            </label>
        `).join('');

        const canProceed = state.poolPicks.length === 6 && state.extraPicks.length === age.extra;

        return `
            <h2>5. Fertigkeiten</h2>
            <p>Wähle genau 6 aus dem Fertigkeiten-Pool deines Berufs (${state.poolPicks.length}/6):</p>
            ${poolRows}
            <p>Wähle ${age.extra} weitere Fertigkeiten frei (${state.extraPicks.length}/${age.extra}):</p>
            ${extraRows}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${canProceed ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Event-Verdrahtung ---

    function attachHandlers() {
        const prev = document.getElementById('prev-step');
        if (prev) {
            prev.addEventListener('click', () => goTo(state.step - 1));
        }
        const next = document.getElementById('next-step');
        if (next) {
            next.addEventListener('click', () => goTo(state.step + 1));
        }

        root.querySelectorAll('input[name="kin"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.kinCode = input.value;
                state.professionCode = null;
                render();
            });
        });

        root.querySelectorAll('input[name="profession"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.professionCode = input.value;
                render();
            });
        });

        const nameInput = document.getElementById('name-input');
        if (nameInput) {
            nameInput.addEventListener('input', () => {
                state.nameDe = nameInput.value;
                document.getElementById('next-step').disabled = !(state.nameDe.trim() && state.ageCode);
            });
        }

        root.querySelectorAll('input[name="age"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.ageCode = input.value;
                render();
            });
        });

        root.querySelectorAll('.attribute-input').forEach((input) => {
            input.addEventListener('input', () => {
                const value = parseInt(input.value, 10);
                state.rawAttributes[input.dataset.code] = Number.isInteger(value) ? value : null;
                const allFilled = ATTRIBUTE_ORDER.every((code) => Number.isInteger(state.rawAttributes[code]));
                document.getElementById('next-step').disabled = !allFilled;
            });
        });

        const swapButton = document.getElementById('swap-button');
        if (swapButton) {
            swapButton.addEventListener('click', () => {
                const a = document.getElementById('swap-a').value;
                const b = document.getElementById('swap-b').value;
                if (a === b) {
                    return;
                }
                const tmp = state.rawAttributes[a];
                state.rawAttributes[a] = state.rawAttributes[b];
                state.rawAttributes[b] = tmp;
                state.swapUsed = true;
                render();
            });
        }

        root.querySelectorAll('.pool-pick').forEach((checkbox) => {
            checkbox.addEventListener('change', () => {
                const id = parseInt(checkbox.value, 10);
                if (checkbox.checked) {
                    if (state.poolPicks.length >= 6) {
                        checkbox.checked = false;
                        return;
                    }
                    state.poolPicks.push(id);
                } else {
                    state.poolPicks = state.poolPicks.filter((pick) => pick !== id);
                    state.extraPicks = state.extraPicks.filter((pick) => pick !== id);
                }
                render();
            });
        });

        root.querySelectorAll('.extra-pick').forEach((checkbox) => {
            checkbox.addEventListener('change', () => {
                const id = parseInt(checkbox.value, 10);
                const age = AGE_TABLE[state.ageCode];
                if (checkbox.checked) {
                    if (state.extraPicks.length >= age.extra) {
                        checkbox.checked = false;
                        return;
                    }
                    state.extraPicks.push(id);
                } else {
                    state.extraPicks = state.extraPicks.filter((pick) => pick !== id);
                }
                render();
            });
        });
    }

    fetch(root.dataset.catalogUrl)
        .then((response) => response.json())
        .then((data) => {
            catalog = data;
            render();
        });
})();
```

- [ ] **Step 2: Im Browser manuell durch Schritte 1–5 klicken**

Öffne `http://localhost:8090/character/create` im Browser. Volk "Mensch" wählen → Beruf "Jäger" wählen (Pool + Talent "Gefährte" sichtbar) → Name "Testheld" eintragen, Alter "Erwachsen" → alle 6 Attribute mit Werten zwischen 3 und 18 füllen, einen Tausch durchführen (Button danach deaktiviert) → in Schritt 5 genau 6 Pool-Fertigkeiten und genau 4 weitere ankreuzen (Weiter-Button aktiviert sich erst dann).
Expected: Navigation funktioniert vor/zurück ohne Konsolenfehler (Browser-Devtools offen halten), Zurück-Navigation behält die bisherigen Eingaben (State bleibt erhalten, wird nur neu gerendert).

---

## Task 5: Wizard-JS — Schritte 6–10, Zusammenfassung, Absenden

**Files:**
- Modify: `backend/public/js/character-creation-wizard.js:renderStep` (Switch-Anweisung aus Task 4 erweitern)

**Interfaces:**
- Consumes: `state`, `AGE_TABLE`, `catalog`, `finalAttributes()`, `baseChance()`, `movementModifier()`, `damageBonus()`, `skillById()`, `goTo()`, `setError()`, `attachHandlers()` aus Task 4 (dieselbe Datei, IIFE-Closure).
- Produces: vollständiger Wizard bis zum Redirect auf `/character/{slug}`.

- [ ] **Step 1: `renderStep`-Switch um die Fälle 6–11 erweitern**

In der bestehenden `renderStep`-Funktion die `default`-Zeile ersetzen durch:

```javascript
            case 6: return renderHeroicAbilityStep();
            case 7: return renderFlawStep();
            case 8: return renderGearStep();
            case 9: return renderMementoStep();
            case 10: return renderAppearanceStep();
            case 11: return renderSummaryStep();
            default: return renderPlaceholderStep();
```

- [ ] **Step 2: Schritt 6 (Heroisches Talent) ergänzen**

Direkt vor der `// --- Event-Verdrahtung ---`-Zeile einfügen:

```javascript
    // --- Schritt 6: Heroisches Talent ---

    function renderHeroicAbilityStep() {
        const profession = selectedProfession();
        const professionAbility = profession.heroicAbility;
        const generalOptions = catalog.generalHeroicAbilities.map((ability) => `
            <label class="wizard-choice">
                <input type="radio" name="heroic" value="${ability.name_de.toLowerCase()}" ${state.heroicAbilityChoice === ability.name_de.toLowerCase() ? 'checked' : ''}>
                ${ability.name_de} <p>${ability.description_de}</p>
            </label>
        `).join('');

        return `
            <h2>6. Heroisches Talent</h2>
            <label class="wizard-choice">
                <input type="radio" name="heroic" value="profession" ${state.heroicAbilityChoice === 'profession' ? 'checked' : ''}>
                ${professionAbility ? professionAbility.name_de : 'Kein Berufs-Talent'} (Berufs-Talent)
                ${professionAbility ? `<p>${professionAbility.description_de}</p>` : ''}
            </label>
            ${generalOptions}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step">Weiter</button>
            </div>
        `;
    }
```

- [ ] **Step 3: Schritt 7 (Schwäche) ergänzen**

```javascript
    // --- Schritt 7: Schwäche ---

    function renderFlawStep() {
        const rows = catalog.flaws.map((flaw) => `
            <label class="wizard-choice">
                <input type="radio" name="flaw" value="${flaw.roll_min}" ${state.flawRoll === flaw.roll_min ? 'checked' : ''}>
                ${flaw.roll_min}. ${flaw.name_de} <p>${flaw.description_de}</p>
            </label>
        `).join('');

        return `
            <h2>7. Schwäche</h2>
            <p>W20 am Tisch würfeln und die passende Zeile wählen, oder direkt auswählen.</p>
            ${rows}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${state.flawRoll ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }
```

- [ ] **Step 4: Schritt 8 (Ausrüstung) ergänzen**

```javascript
    // --- Schritt 8: Ausrüstung ---

    function renderGearStep() {
        const profession = selectedProfession();
        if (state.gearOptionId === null && profession.gearOptions.length > 0) {
            state.gearOptionId = profession.gearOptions[0].gearOptionId;
        }
        const options = profession.gearOptions.map((option) => `
            <label class="wizard-choice">
                <input type="radio" name="gear" value="${option.gearOptionId}" ${state.gearOptionId === option.gearOptionId ? 'checked' : ''}>
                Option ${option.label}: ${option.items.map((item) => item.quantity > 1 ? `${item.quantity}× ${item.name}` : item.name).join(', ')}
            </label>
        `).join('');

        return `
            <h2>8. Ausrüstung</h2>
            ${options}
            <label>Gemeinsame Grundausstattung<br>
                <textarea id="misc-items-input" rows="2">${state.miscItemsDe}</textarea>
            </label>
            <p><small>Währung: 100 Kupfer = 10 Silber = 1 Gold. Kannst du im fertigen Charakterbogen eintragen.</small></p>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step">Weiter</button>
            </div>
        `;
    }
```

- [ ] **Step 5: Schritte 9–10 (Memento, Aussehen) ergänzen**

```javascript
    // --- Schritt 9: Memento ---

    function renderMementoStep() {
        return `
            <h2>9. Memento</h2>
            <p>Ein Gegenstand ohne praktischen Nutzen, 1×/Sitzung nutzbar, um während einer langen Rast
               einen Zustand zu heilen. Bei Verlust am Ende einer Sitzung ein neues wählen.</p>
            <label>Memento<br><input type="text" id="memento-input" value="${state.mementoDe}" maxlength="255"></label>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step">Weiter</button>
            </div>
        `;
    }

    // --- Schritt 10: Aussehen ---

    function renderAppearanceStep() {
        return `
            <h2>10. Aussehen</h2>
            <label>Kurze Beschreibung<br><textarea id="appearance-input" rows="3">${state.appearanceDe}</textarea></label>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step">Weiter</button>
            </div>
        `;
    }
```

- [ ] **Step 6: Zusammenfassung + Absenden ergänzen**

```javascript
    // --- Zusammenfassung & Absenden ---

    function buildPayload() {
        return {
            name_de: state.nameDe.trim(),
            kin_code: state.kinCode,
            profession_code: state.professionCode,
            age_code: state.ageCode,
            raw_attributes: state.rawAttributes,
            learned_skill_ids: state.poolPicks.concat(state.extraPicks),
            heroic_ability_choice: state.heroicAbilityChoice,
            flaw_roll: state.flawRoll,
            gear_option_id: state.gearOptionId,
            memento_de: state.mementoDe,
            appearance_de: state.appearanceDe,
            misc_items_de: state.miscItemsDe,
        };
    }

    function renderSummaryStep() {
        const kin = selectedKin();
        const profession = selectedProfession();
        const attrs = finalAttributes();
        const flaw = catalog.flaws.find((f) => f.roll_min === state.flawRoll);

        return `
            <h2>Zusammenfassung</h2>
            <p><strong>${state.nameDe}</strong> — ${kin.name_de}, ${AGE_TABLE[state.ageCode].label}, ${profession.name_de}</p>
            <p>Attribute: ${ATTRIBUTE_ORDER.map((code) => `${code} ${attrs[code]}`).join(', ')}</p>
            <p>TP ${attrs.KON + (state.heroicAbilityChoice === 'robust' ? 2 : 0)} /
               WP ${attrs.WIL + (state.heroicAbilityChoice === 'fokussiert' ? 2 : 0)} /
               Bewegung ${(kin.movement_base + movementModifier(attrs.GEW))}</p>
            <p>Schwäche: ${flaw ? flaw.name_de : '—'}</p>
            <p>Memento: ${state.mementoDe || '—'}</p>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="submit-character">Charakter erstellen</button>
            </div>
        `;
    }

    function submitCharacter() {
        fetch('/characters', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(buildPayload()),
        })
            .then((response) => response.json().then((data) => ({ status: response.status, data })))
            .then(({ status, data }) => {
                if (status !== 200) {
                    setError(data.error || 'Unbekannter Fehler beim Anlegen.');
                    return;
                }
                window.location.href = `/character/${data.slug}`;
            });
    }
```

- [ ] **Step 7: Event-Handler für die neuen Schritte ergänzen**

In `attachHandlers()`, direkt vor der schließenden `}` der Funktion einfügen:

```javascript
        root.querySelectorAll('input[name="heroic"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.heroicAbilityChoice = input.value;
            });
        });

        root.querySelectorAll('input[name="flaw"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.flawRoll = parseInt(input.value, 10);
                document.getElementById('next-step').disabled = false;
            });
        });

        root.querySelectorAll('input[name="gear"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.gearOptionId = parseInt(input.value, 10);
            });
        });

        const miscItemsInput = document.getElementById('misc-items-input');
        if (miscItemsInput) {
            miscItemsInput.addEventListener('input', () => {
                state.miscItemsDe = miscItemsInput.value;
            });
        }

        const mementoInput = document.getElementById('memento-input');
        if (mementoInput) {
            mementoInput.addEventListener('input', () => {
                state.mementoDe = mementoInput.value;
            });
        }

        const appearanceInput = document.getElementById('appearance-input');
        if (appearanceInput) {
            appearanceInput.addEventListener('input', () => {
                state.appearanceDe = appearanceInput.value;
            });
        }

        const submitButton = document.getElementById('submit-character');
        if (submitButton) {
            submitButton.addEventListener('click', submitCharacter);
        }
```

- [ ] **Step 8: Kompletten Wizard im Browser durchspielen**

`http://localhost:8090/character/create` öffnen und alle 11 Schritte mit Testdaten durchklicken (z. B. Mensch/Jäger/Erwachsen wie in Task 2 Step 5), am Ende auf "Charakter erstellen" klicken.
Expected: Redirect auf `/character/{slug}` mit dem neu erzeugten, vollständig ausgefüllten Charakterbogen (Attribute, alle 30 Fertigkeiten, Talente, Ausrüstung sichtbar). Danach den Testcharakter wie in Task 2 Step 5 per SQL wieder löschen, falls es nur ein Testlauf war.

---

## Task 6: Memento-Bugfix im Charakterbogen

**Files:**
- Modify: `backend/templates/character/sheet.twig:33-35`

**Interfaces:**
- Keine — reines Template-Rendering, kein neuer Datenfluss (`character.memento_de` wird bereits vom bestehenden `loadSheet()` in `index.php` mitgeliefert).

- [ ] **Step 1: Memento-Zeile im Header ergänzen**

In `backend/templates/character/sheet.twig`, den bestehenden Block

```twig
                    <div><dt>Schwäche</dt><dd>{{ character.flaw_de }}</dd></div>
                </dl>
```

ersetzen durch:

```twig
                    <div><dt>Schwäche</dt><dd>{{ character.flaw_de }}</dd></div>
                    {% if character.memento_de %}
                        <div><dt>Memento</dt><dd>{{ character.memento_de }}</dd></div>
                    {% endif %}
                </dl>
```

- [ ] **Step 2: Gegen einen bestehenden Pregen verifizieren**

Run: `curl -s http://localhost:8090/character/orla_mondsilber | grep -A1 "Memento"`
Expected: enthält `<dd>Hauer des Trolls, der deine Schwester getötet hat.</dd>` (Orlas hinterlegtes Memento aus `seed_pregens.sql`).

---

## Self-Review

**Spec-Abdeckung:** Ziel (Task 3+4+5), Architektur (Task 1–5), alle 10 Wizard-Schritte + Abschluss (Task 4+5), Nicht-Ziele eingehalten (kein virtueller Würfel — Attribute/Alter/Schwäche sind reine Eingabe-/Auswahlfelder ohne `Math.random`; kein Draft-Datensatz — State lebt nur im Browser bis zum finalen POST; kein Portrait-Upload — nicht angefasst; keine Kampagnen-Verknüpfung — nicht angefasst), Memento-Bugfix (Task 6). Alle Regeln aus Spec-Schritt 4/5/6 (Bewegung, Schadensbonus, Basiswert-Tabelle, Verdopplung, 8er-Pool, ein festes Berufs-Talent, `granted_at_creation`-Filter) sind in `createCharacter()`/dem JS umgesetzt.

**Platzhalter-Scan:** Keine TBD/TODO-Marker; jeder Schritt enthält vollständigen, direkt einfügbaren Code.

**Typkonsistenz geprüft:** `learned_skill_ids` (Payload) ↔ `learnedSkillIds` (PHP-Parameter) ↔ `state.poolPicks.concat(state.extraPicks)` (JS) — durchgängig Integer-Arrays. `heroic_ability_choice` durchgängig einer von `'profession' | 'robust' | 'fokussiert'` in JS-Payload und PHP-Validierung. `gear_option_id` durchgängig Integer (DB-`id`).

**Review Focus abgedeckt:** doppelter Slug → `slugify()`-Kollisionsschleife (Task 2 Step 2) + Test in Task 2 Step 5 (zweiter Testcharakter mit gleichem Namen ließe sich ergänzen, falls gewünscht — Mechanik ist aber bereits im Code vorhanden und wird durch die vorhandene `UNIQUE`-Spalte erzwungen, sobald der Slug kollidiert). Falsche Fertigkeiten-Anzahl / zu wenige Pool-Fertigkeiten / falscher Beruf fürs Volk / Attribut außerhalb 3–18 → alle vier explizit in `createCharacter()` (Task 2 Step 1) mit `InvalidArgumentException` abgefangen, die per HTTP 422 ans JS zurückgeht und dort in `state.error` angezeigt wird.
