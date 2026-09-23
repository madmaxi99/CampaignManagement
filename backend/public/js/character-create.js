(function () {
    var dataEl = document.getElementById('character-data');
    var form = document.getElementById('character-form');
    if (!dataEl || !form) {
        return;
    }

    var data = JSON.parse(dataEl.textContent);

    var kinSelect = document.getElementById('kin-select');
    var kinAbilitiesEl = document.getElementById('kin-abilities');

    var professionSelect = document.getElementById('profession-select');
    var mageTraditionField = document.getElementById('mage-tradition-field');
    var magicTraditionSelect = document.getElementById('magic-tradition-select');
    var professionCoreSkillsEl = document.getElementById('profession-core-skills');

    var ageSelect = document.getElementById('age-select');
    var ageHintEl = document.getElementById('age-hint');

    var attrInputs = {
        STR: document.getElementById('attr-str'),
        CON: document.getElementById('attr-con'),
        AGL: document.getElementById('attr-agl'),
        INT: document.getElementById('attr-int'),
        WIL: document.getElementById('attr-wil'),
        CHA: document.getElementById('attr-cha'),
    };
    var derivedValuesEl = document.getElementById('derived-values');

    var extraSkillsList = document.getElementById('extra-skills-list');
    var extraSkillsHint = document.getElementById('extra-skills-hint');

    var haSection = document.getElementById('ha-section');
    var haList = document.getElementById('ha-list');
    var spellSection = document.getElementById('spell-section');
    var spellRank1List = document.getElementById('spell-rank1-list');
    var spellTrickList = document.getElementById('spell-trick-list');
    var spellRank1Count = document.getElementById('spell-rank1-count');
    var spellTrickCount = document.getElementById('spell-trick-count');

    var weaknessSelect = document.getElementById('weakness-select');
    var gearRows = document.getElementById('gear-rows');

    var ageSlots = { young: 2, adult: 4, old: 6 };

    function baseChance(value) {
        if (value <= 5) return 3;
        if (value <= 8) return 4;
        if (value <= 12) return 5;
        if (value <= 15) return 6;
        return 7;
    }

    function attrValue(attr) {
        var v = parseInt(attrInputs[attr].value, 10);
        return isNaN(v) ? 0 : v;
    }

    function damageBonusLabel(value) {
        if (value <= 12) return 'none';
        if (value <= 16) return '+D4';
        return '+D6';
    }

    function schoolIdByName(name) {
        var school = data.magicSchools.filter(function (s) { return s.name === name; })[0];
        return school ? school.id : null;
    }

    var traditionSchoolName = { elementalist: 'Elementalism', mentalist: 'Mentalism', animist: 'Animism' };
    var generalSchoolId = schoolIdByName('General');

    function currentProfession() {
        var id = professionSelect.value;
        return data.professions.filter(function (p) { return String(p.id) === String(id); })[0] || null;
    }

    function isMage() {
        var profession = currentProfession();
        return profession && profession.name === data.mageProfessionName;
    }

    function coreSkillsForCurrentSelection() {
        var professionId = professionSelect.value;
        var rows = (data.professionCoreSkills[professionId] || []);
        if (!isMage()) {
            return rows;
        }

        var traditionSchoolId = schoolIdByName(traditionSchoolName[magicTraditionSelect.value]);
        return rows.filter(function (row) {
            return row.magic_school_id === null || row.magic_school_id === traditionSchoolId;
        });
    }

    // --- Kin ---
    kinSelect.addEventListener('change', function () {
        var abilities = data.kinAbilities[kinSelect.value] || [];
        kinAbilitiesEl.innerHTML = abilities.map(function (a) {
            return '<strong>' + a.name + '</strong>' + (a.wp_cost ? ' (WP ' + a.wp_cost + ')' : '') + ': ' + a.description;
        }).join('<br>') || 'Keine Kin-Ability hinterlegt.';
        updateDerived();
    });

    // --- Profession ---
    function renderCoreSkills() {
        var rows = coreSkillsForCurrentSelection();
        professionCoreSkillsEl.textContent = rows.length
            ? rows.map(function (r) { return r.skill_name; }).join(', ')
            : '—';
    }

    function renderHeroicAbilities() {
        var professionId = professionSelect.value;
        var pool = (data.professionHeroicAbilityPool[professionId] || []).map(function (p) { return p.heroic_ability_id; });

        haList.innerHTML = data.heroicAbilities.map(function (ha) {
            return '<li><label><input type="radio" name="heroic_ability_id" value="' + ha.id + '"' +
                (pool[0] === ha.id ? ' checked' : '') + '> <strong>' + ha.name + '</strong>' +
                (ha.requirement ? ' (' + ha.requirement + ')' : '') + (ha.wp_cost ? ' — WP ' + ha.wp_cost : '') +
                '<span class="char-ability-desc">' + ha.description + '</span></label></li>';
        }).join('');
    }

    function renderSpellPickers() {
        var traditionSchoolId = schoolIdByName(traditionSchoolName[magicTraditionSelect.value]);

        var rank1 = data.spells.filter(function (s) { return s.rank === 1 && s.school_id === traditionSchoolId; });
        var tricks = data.spells.filter(function (s) {
            return s.rank === 0 && (s.school_id === traditionSchoolId || s.school_id === generalSchoolId);
        });

        spellRank1List.innerHTML = rank1.map(function (s) {
            return '<li><label><input type="checkbox" name="spell_ids[]" value="' + s.id + '" class="spell-rank1-checkbox"> <strong>' + s.name + '</strong>' +
                (s.wp_cost ? ' — WP ' + s.wp_cost : '') + '<span class="char-ability-desc">' + s.description + '</span></label></li>';
        }).join('') || '<li class="entry-empty">Erst Tradition wählen.</li>';

        spellTrickList.innerHTML = tricks.map(function (s) {
            return '<li><label><input type="checkbox" name="spell_ids[]" value="' + s.id + '" class="spell-trick-checkbox"> <strong>' + s.name + '</strong>' +
                '<span class="char-ability-desc">' + s.description + '</span></label></li>';
        }).join('') || '<li class="entry-empty">Erst Tradition wählen.</li>';

        enforceSpellLimits();
    }

    function enforceSpellLimits() {
        enforceCheckboxGroupLimit('.spell-rank1-checkbox', 3, spellRank1Count);
        enforceCheckboxGroupLimit('.spell-trick-checkbox', 3, spellTrickCount);
    }

    function enforceCheckboxGroupLimit(selector, max, counterEl) {
        var boxes = Array.prototype.slice.call(document.querySelectorAll(selector));
        var checkedCount = boxes.filter(function (b) { return b.checked; }).length;
        if (counterEl) {
            counterEl.textContent = String(checkedCount);
        }
        boxes.forEach(function (b) {
            b.disabled = !b.checked && checkedCount >= max;
        });
    }

    function renderExtraSkills() {
        var coreSkillIds = coreSkillsForCurrentSelection().map(function (r) { return r.skill_id; });
        var options = data.skills.filter(function (s) { return coreSkillIds.indexOf(s.id) === -1; });

        extraSkillsList.innerHTML = options.map(function (s) {
            return '<li><label><input type="checkbox" name="trained_skill_ids[]" value="' + s.id + '" data-attribute="' + s.governing_attribute + '" class="extra-skill-checkbox">' +
                '<span>' + s.name + '</span><span class="char-skill-value" data-attribute-display="' + s.governing_attribute + '"></span></label></li>';
        }).join('');

        updateSkillValues();
        enforceExtraSkillLimit();
    }

    function enforceExtraSkillLimit() {
        var age = ageSelect.value;
        var max = ageSlots[age] || 0;
        var boxes = Array.prototype.slice.call(document.querySelectorAll('.extra-skill-checkbox'));
        var checkedCount = boxes.filter(function (b) { return b.checked; }).length;
        extraSkillsHint.textContent = checkedCount + ' / ' + max + ' ausgewählt';
        boxes.forEach(function (b) {
            b.disabled = !b.checked && checkedCount >= max;
        });
    }

    function updateSkillValues() {
        var spans = document.querySelectorAll('#extra-skills-list [data-attribute-display]');
        spans.forEach(function (span) {
            var attr = span.getAttribute('data-attribute-display');
            var value = baseChance(attrValue(attr));
            span.textContent = value + ' / ' + (value * 2);
        });
    }

    professionSelect.addEventListener('change', function () {
        mageTraditionField.hidden = !isMage();
        haSection.hidden = isMage();
        spellSection.hidden = !isMage();
        magicTraditionSelect.value = '';

        renderCoreSkills();
        renderHeroicAbilities();
        renderExtraSkills();
        if (isMage()) {
            renderSpellPickers();
        }
    });

    magicTraditionSelect.addEventListener('change', function () {
        renderCoreSkills();
        renderExtraSkills();
        renderSpellPickers();
    });

    // --- Age ---
    var ageLabels = { young: 'Young — 6+2 Skills, AGL & CON +1', adult: 'Adult — 6+4 Skills, keine Attribut-Änderung', old: 'Old — 6+6 Skills, STR/AGL/CON -2, INT/WIL +1' };
    ageSelect.addEventListener('change', function () {
        ageHintEl.textContent = ageLabels[ageSelect.value] || '';
        enforceExtraSkillLimit();
    });

    extraSkillsList.addEventListener('change', function (event) {
        if (event.target.classList.contains('extra-skill-checkbox')) {
            enforceExtraSkillLimit();
        }
    });

    spellRank1List.addEventListener('change', enforceSpellLimits);
    spellTrickList.addEventListener('change', enforceSpellLimits);

    // --- Attributes / derived values ---
    function updateDerived() {
        var kin = data.kins.filter(function (k) { return String(k.id) === String(kinSelect.value); })[0];
        var baseMovement = kin ? kin.base_movement : null;
        var agl = attrValue('AGL');
        var str = attrValue('STR');
        var con = attrValue('CON');
        var wil = attrValue('WIL');

        var movementMod = agl <= 6 ? -4 : agl <= 9 ? -2 : agl <= 12 ? 0 : agl <= 15 ? 2 : 4;
        var movement = baseMovement !== null ? baseMovement + movementMod : '—';

        derivedValuesEl.textContent = 'Movement: ' + movement +
            ' · Damage Bonus STR: ' + damageBonusLabel(str) +
            ' · Damage Bonus AGL: ' + damageBonusLabel(agl) +
            ' · HP: ' + (con || '—') +
            ' · WP: ' + (wil || '—');

        updateSkillValues();
    }

    Object.keys(attrInputs).forEach(function (attr) {
        attrInputs[attr].addEventListener('input', updateDerived);
    });

    // --- Weakness ---
    weaknessSelect.innerHTML = '<option value="">— keine —</option>' +
        data.weaknesses.map(function (w) { return '<option value="' + w + '">' + w + '</option>'; }).join('');

    // --- Gear ---
    var GEAR_ROWS = 6;
    var gearRowsHtml = '';
    for (var i = 0; i < GEAR_ROWS; i++) {
        gearRowsHtml += '<div class="sheet-add-item">' +
            '<select name="item_id[]"><option value="">— kein Item —</option>' +
            data.items.map(function (it) { return '<option value="' + it.id + '">' + it.name + '</option>'; }).join('') +
            '</select>' +
            '<input type="number" name="item_qty[]" min="1" value="1" style="width:5rem;">' +
            '</div>';
    }
    gearRows.innerHTML = gearRowsHtml;
})();
