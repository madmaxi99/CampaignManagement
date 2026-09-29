(function () {
    const root = document.querySelector('.wizard');
    if (!root) {
        return;
    }

    const ATTRIBUTE_ORDER = ['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'];
    const ATTRIBUTE_LABELS = { STA: 'Stärke', KON: 'Konstitution', GEW: 'Gewandtheit', INT: 'Intelligenz', WIL: 'Willenskraft', CHA: 'Charisma' };
    const GEAR_ROLL_LABELS = { A: '1-2', B: '3-4', C: '5-6' };
    const MAGIC_PICK_COUNT = 3;

    const AGE_TABLE = {
        jung: { label: 'Jung', extra: 2, total: 8, modifiers: { GEW: 1, KON: 1 } },
        erwachsen: { label: 'Erwachsen', extra: 4, total: 10, modifiers: {} },
        alt: { label: 'Alt', extra: 6, total: 12, modifiers: { STA: -2, GEW: -2, KON: -2, INT: 1, WIL: 1 } },
    };

    const STEP_TITLES = {
        1: 'Volk', 2: 'Beruf', 3: 'Name, Alter, Fertigkeiten & Ausrüstung', 4: 'Weitere Fertigkeiten',
        5: 'Magie', 6: 'Attribute', 7: 'Schwäche', 8: 'Memento', 9: 'Aussehen',
    };

    let catalog = null;

    const state = {
        step: 1,
        kinCode: null,
        professionCode: null,
        professionHeroicAbilityId: null,
        nameDe: '',
        ageCode: null,
        poolPicks: [],
        gearOptionId: null,
        rolledSilver: null,
        extraPicks: [],
        magicSchoolId: null,
        trickPicks: [],
        spellPicks: [],
        rawAttributes: { STA: null, KON: null, GEW: null, INT: null, WIL: null, CHA: null },
        swapUsed: false,
        heroicAbilityChoice: 'profession',
        flawRoll: null,
        mementoDe: '',
        appearanceDe: '',
        error: '',
    };

    function selectedKin() {
        return catalog.kins.find((kin) => kin.code === state.kinCode) || null;
    }

    function selectedProfession() {
        return catalog.professions.find((profession) => profession.code === state.professionCode) || null;
    }

    function ageModifier(code) {
        const age = AGE_TABLE[state.ageCode];
        return age ? (age.modifiers[code] || 0) : 0;
    }

    function finalAttributes() {
        const result = {};
        ATTRIBUTE_ORDER.forEach((code) => {
            const raw = state.rawAttributes[code] || 0;
            result[code] = raw + ageModifier(code);
        });
        return result;
    }

    function attributesOverflow() {
        return ATTRIBUTE_ORDER.some((code) => {
            const raw = state.rawAttributes[code];
            return Number.isInteger(raw) && raw + ageModifier(code) > 18;
        });
    }

    function escapeHtml(value) {
        return String(value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function descriptionLine(text) {
        return text ? `<p class="wizard-choice-detail">${text}</p>` : '';
    }

    // --- Navigation: profession-dependent step sequence (Magic step only for casters) ---

    function visibleSteps() {
        const profession = selectedProfession();
        const steps = [1, 2, 3, 4];
        if (profession && profession.grants_magic) {
            steps.push(5);
        }
        steps.push(6, 7, 8, 9);
        return steps;
    }

    function goTo(step) {
        state.step = step;
        state.error = '';
        render();
    }

    function goRelative(delta) {
        const steps = visibleSteps();
        const index = steps.indexOf(state.step);
        const nextIndex = index + delta;
        if (nextIndex >= 0 && nextIndex < steps.length) {
            goTo(steps[nextIndex]);
        }
    }

    function setError(message) {
        state.error = message;
        render();
    }

    function render() {
        const steps = visibleSteps();
        const position = steps.indexOf(state.step) + 1;
        root.innerHTML = `
            <div class="wizard-step">
                <p class="wizard-progress">Schritt ${position} von ${steps.length} &middot; ${STEP_TITLES[state.step]}</p>
                ${state.error ? `<p class="wizard-error">${escapeHtml(state.error)}</p>` : ''}
                ${renderStep()}
            </div>
        `;
        attachHandlers();
    }

    function renderStep() {
        switch (state.step) {
            case 1: return renderKinStep();
            case 2: return renderProfessionStep();
            case 3: return renderNameSkillsGearStep();
            case 4: return renderExtraSkillsStep();
            case 5: return renderMagicStep();
            case 6: return renderAttributesStep();
            case 7: return renderFlawStep();
            case 8: return renderMementoStep();
            case 9: return renderAppearanceStep();
            default: return '';
        }
    }

    // --- Schritt 1: Volk ---

    function renderKinStep() {
        const rows = catalog.kins.map((kin) => {
            const selected = state.kinCode === kin.code;
            const abilities = kin.abilities.map((ability) => `
                <div class="wizard-ability">
                    <strong>${ability.name_de}</strong>${ability.wp_note_de ? ` <span class="wizard-wp-note">(WP ${ability.wp_note_de})</span>` : ''}
                    <p>${ability.description_de}</p>
                </div>
            `).join('');

            return `
                <label class="wizard-choice ${selected ? 'wizard-choice--selected' : ''}">
                    <input type="radio" name="kin" value="${kin.code}" ${selected ? 'checked' : ''}>
                    <div class="wizard-choice-head">
                        <span class="wizard-choice-title">${kin.name_de}</span>
                        <span class="wizard-choice-meta">W12: ${kin.d12_min}${kin.d12_max > kin.d12_min ? '–' + kin.d12_max : ''}</span>
                    </div>
                    ${abilities}
                </label>
            `;
        }).join('');

        return `
            <h2>1. Volk</h2>
            <p class="wizard-intro">Wähle dein Volk, oder würfle W12 am Tisch und wähle die passende Zeile.</p>
            <div class="wizard-choice-list">${rows}</div>
            <div class="wizard-nav">
                <span></span>
                <button type="button" id="next-step" ${state.kinCode ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 2: Beruf (inkl. Heroischem Talent) ---

    function professionStepValid() {
        if (!state.professionCode) {
            return false;
        }
        const profession = selectedProfession();
        if (profession.grants_magic) {
            return state.magicSchoolId !== null;
        }
        if (profession.heroicAbilities.length > 1) {
            return state.professionHeroicAbilityId !== null;
        }
        return true;
    }

    function renderProfessionStep() {
        const kin = selectedKin();
        const options = catalog.professions.filter((p) => p.kin_restriction === null || p.kin_restriction === kin.code);
        const rows = options.map((profession) => {
            const selected = state.professionCode === profession.code;
            const pool = profession.skillPool
                .map((skill) => `${skill.name_de} (${ATTRIBUTE_LABELS[skill.attribute_code]})`)
                .join(', ');

            let abilitySection;
            if (profession.heroicAbilities.length === 0 && profession.grants_magic) {
                // "Allgemein" has no skill_id -- you can't train in it, so it's excluded here.
                const schoolRows = catalog.magic.schools.filter((school) => school.skill_id !== null).map((school) => `
                    <label class="wizard-choice-inline">
                        <input type="radio" name="magic-school" value="${school.id}" ${state.magicSchoolId === school.id ? 'checked' : ''} ${selected ? '' : 'disabled'}>
                        <strong>${school.name_de}</strong>
                        ${descriptionLine(school.description_de)}
                    </label>
                `).join('');
                abilitySection = `
                    <div class="wizard-ability">
                        <strong>Kein Berufs-Talent — dafür Magie. Wähle deine Zauberschule:</strong>
                        <div class="wizard-choice-grid">${schoolRows}</div>
                    </div>
                `;
            } else if (profession.heroicAbilities.length === 1) {
                const ability = profession.heroicAbilities[0];
                abilitySection = `
                    <div class="wizard-ability">
                        <strong>Heroisches Talent: ${ability.name_de}</strong>
                        <p>${ability.description_de}</p>
                        <p class="wizard-note">Dieses Talent bekommst du bei der Erstellung automatisch — eine Wahl gibt es dabei nicht.</p>
                    </div>
                `;
            } else {
                const choiceRows = profession.heroicAbilities.map((ability) => `
                    <label class="wizard-choice-inline">
                        <input type="radio" name="profession-heroic-ability" value="${ability.id}" ${state.professionHeroicAbilityId === ability.id ? 'checked' : ''} ${selected ? '' : 'disabled'}>
                        <strong>${ability.name_de}</strong>
                        <p>${ability.description_de}</p>
                    </label>
                `).join('');
                abilitySection = `
                    <div class="wizard-ability">
                        <strong>Heroisches Talent — wähle eines:</strong>
                        <div class="wizard-choice-grid">${choiceRows}</div>
                    </div>
                `;
            }

            return `
                <label class="wizard-choice ${selected ? 'wizard-choice--selected' : ''}">
                    <input type="radio" name="profession" value="${profession.code}" ${selected ? 'checked' : ''}>
                    <div class="wizard-choice-head">
                        <span class="wizard-choice-title">${profession.name_de}</span>
                        <span class="wizard-choice-meta">Schlüsselattribut ${ATTRIBUTE_LABELS[profession.key_attribute_code]}</span>
                    </div>
                    <p class="wizard-choice-detail"><strong>8 Fertigkeiten zur Auswahl (im nächsten Schritt wählst du 6 davon):</strong> ${pool}</p>
                    ${abilitySection}
                </label>
            `;
        }).join('');

        return `
            <h2>2. Beruf</h2>
            <div class="wizard-choice-list">${rows}</div>
            <div class="wizard-ability wizard-ability--muted">
                <strong>Magie</strong>
                <p>Zauberei ist außer beim Magier noch nicht wählbar. Zur Einordnung schon mal die drei Schulen:
                   <strong>Animismus</strong> (Geister &amp; Götter, Respekt statt Kontrolle),
                   <strong>Elementarismus</strong> (Wind, Wasser, Feuer, Erde),
                   <strong>Mentalismus</strong> (Kontrolle über den eigenen und fremde Geister durch Fokussierung),
                   dazu Allgemeine Magie (schulunabhängige Zaubertricks/Zauber).</p>
            </div>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${professionStepValid() ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 3: Name & Alter + Pool-Fertigkeiten + Ausrüstung ---

    function currentGearOption() {
        const profession = selectedProfession();
        return profession.gearOptions.find((option) => option.gearOptionId === state.gearOptionId) || null;
    }

    function silverMax() {
        const option = currentGearOption();
        const dice = option && option.silverDice;
        return dice ? parseInt(dice.slice(1), 10) : 0;
    }

    function step3Valid() {
        const maxSilver = silverMax();
        const silverOk = maxSilver === 0 || (Number.isInteger(state.rolledSilver) && state.rolledSilver >= 1 && state.rolledSilver <= maxSilver);
        return state.nameDe.trim() !== '' && state.ageCode !== null
            && state.poolPicks.length === 6 && state.gearOptionId !== null && silverOk;
    }

    function renderNameSkillsGearStep() {
        const profession = selectedProfession();

        const ageRows = Object.entries(AGE_TABLE).map(([code, age]) => `
            <label class="wizard-choice wizard-choice--compact ${state.ageCode === code ? 'wizard-choice--selected' : ''}">
                <input type="radio" name="age" value="${code}" ${state.ageCode === code ? 'checked' : ''}>
                ${age.label} <small>(6 + ${age.extra} = ${age.total} Fertigkeiten)</small>
            </label>
        `).join('');

        // A school in catalog.magic.schools has its OWN id (matches catalog_spells.school_id),
        // distinct from skill_id (matches catalog_skills.id / character_skills.skill_id). The
        // pool/checkbox below is skill-based, so map the chosen school to a skill-shaped entry.
        const poolSkills = profession.grants_magic
            ? profession.skillPool.concat(catalog.magic.schools
                .filter((s) => s.id === state.magicSchoolId)
                .map((s) => ({ id: s.skill_id, name_de: s.name_de, attribute_code: s.attribute_code, description_de: s.description_de })))
            : profession.skillPool;
        const poolRows = poolSkills.map((skill) => `
            <label class="wizard-choice-inline">
                <input type="checkbox" class="pool-pick" value="${skill.id}" ${state.poolPicks.includes(skill.id) ? 'checked' : ''}>
                <strong>${skill.name_de}</strong> <small>(${ATTRIBUTE_LABELS[skill.attribute_code]})</small>
                ${descriptionLine(skill.description_de)}
            </label>
        `).join('');

        if (state.gearOptionId === null && profession.gearOptions.length > 0) {
            state.gearOptionId = profession.gearOptions[0].gearOptionId;
        }
        const gearRows = profession.gearOptions.map((option) => `
            <label class="wizard-choice ${state.gearOptionId === option.gearOptionId ? 'wizard-choice--selected' : ''}">
                <input type="radio" name="gear" value="${option.gearOptionId}" ${state.gearOptionId === option.gearOptionId ? 'checked' : ''}>
                <div class="wizard-choice-head">
                    <span class="wizard-choice-title">Option ${option.label}</span>
                    <span class="wizard-choice-meta">W6: ${GEAR_ROLL_LABELS[option.label] || '?'}</span>
                </div>
                <p>${option.items.map((item) => item.quantity > 1 ? `${item.quantity}× ${item.name}` : item.name).join(', ')}${option.extra_de ? `, ${option.extra_de}` : ''}</p>
            </label>
        `).join('');

        const maxSilver = silverMax();
        const silverField = maxSilver > 0 ? `
            <label class="wizard-field">Gewürfeltes Silber (${currentGearOption().silverDice} würfeln, 1–${maxSilver})<br>
                <input type="number" id="rolled-silver-input" min="1" max="${maxSilver}" value="${state.rolledSilver === null ? '' : state.rolledSilver}"></label>
        ` : '';

        return `
            <h2>3. Name, Alter, Fertigkeiten &amp; Ausrüstung</h2>
            <label class="wizard-field">Name<br><input type="text" id="name-input" value="${escapeHtml(state.nameDe)}" maxlength="100"></label>
            <p class="wizard-intro">Alter (W6 am Tisch würfeln oder direkt wählen: 1–3 Jung, 4–5 Erwachsen, 6 Alt):</p>
            <div class="wizard-choice-list">${ageRows}</div>

            <h3>Fertigkeiten-Pool deines Berufs</h3>
            <p class="wizard-intro">Wähle genau 6 aus dem Fertigkeiten-Pool deines Berufs (${state.poolPicks.length}/6):</p>
            <div class="wizard-choice-grid">${poolRows}</div>

            <h3>Ausrüstung</h3>
            ${profession.gearOptions.length > 1 ? '<p class="wizard-intro">W6 am Tisch würfeln oder direkt eine Option wählen:</p>' : ''}
            <div class="wizard-choice-list">${gearRows}</div>
            ${silverField}
            <p class="wizard-note">Währung: 100 Kupfer = 10 Silber = 1 Gold. Anpassbar im fertigen Charakterbogen.</p>

            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${step3Valid() ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 4: Weitere Fertigkeiten ---

    function renderExtraSkillsStep() {
        const age = AGE_TABLE[state.ageCode];
        const extraCandidates = catalog.skills.filter((skill) => !state.poolPicks.includes(skill.id));

        const extraRows = extraCandidates.map((skill) => `
            <label class="wizard-choice-inline">
                <input type="checkbox" class="extra-pick" value="${skill.id}" ${state.extraPicks.includes(skill.id) ? 'checked' : ''}>
                <strong>${skill.name_de}</strong> <small>(${ATTRIBUTE_LABELS[skill.attribute_code]} &middot; ${skill.category === 'combat' ? 'Kampf' : 'Regulär'})</small>
                ${descriptionLine(skill.description_de)}
            </label>
        `).join('');

        return `
            <h2>4. Weitere Fertigkeiten</h2>
            <p class="wizard-intro wizard-count-banner">Wähle ${age.extra} weitere Fertigkeiten frei — aktuell ${state.extraPicks.length} von ${age.extra} gewählt.</p>
            <div class="wizard-choice-grid">${extraRows}</div>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${state.extraPicks.length === age.extra ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 5: Magie (nur für Berufe mit grants_magic) ---

    function magicStepValid() {
        return state.magicSchoolId !== null
            && state.trickPicks.length === MAGIC_PICK_COUNT
            && state.spellPicks.length === MAGIC_PICK_COUNT;
    }

    function renderMagicStep() {
        const school = catalog.magic.schools.find((s) => s.id === state.magicSchoolId);
        const generalSchool = catalog.magic.schools.find((s) => s.skill_id === null);
        const isGeneral = (spell) => spell.school_id === generalSchool.id;

        const availableTricks = catalog.magic.spells.filter((spell) => spell.type === 'trick'
            && (isGeneral(spell) || spell.school_id === state.magicSchoolId));
        const availableSpells = catalog.magic.spells.filter((spell) => spell.type === 'spell'
            && (isGeneral(spell) || spell.school_id === state.magicSchoolId));

        const trickRows = availableTricks.map((spell) => `
            <label class="wizard-choice-inline">
                <input type="checkbox" class="trick-pick" value="${spell.id}" ${state.trickPicks.includes(spell.id) ? 'checked' : ''}>
                <strong>${spell.name_de}</strong> ${isGeneral(spell) ? '<small>(Allgemein)</small>' : ''}
                <p>${spell.effect_de}</p>
            </label>
        `).join('');

        const spellRows = availableSpells.map((spell) => `
            <label class="wizard-choice-inline">
                <input type="checkbox" class="spell-pick" value="${spell.id}" ${state.spellPicks.includes(spell.id) ? 'checked' : ''}>
                <strong>${spell.name_de}</strong> ${isGeneral(spell) ? '<small>(Allgemein)</small>' : ''}
                <small>${spell.wp_note_de || ''}</small>
                <p>${spell.effect_de}</p>
            </label>
        `).join('');

        return `
            <h2>5. Magie</h2>
            <p class="wizard-intro">Zauberschule: <strong>${school.name_de}</strong> (gewählt in Schritt 2)</p>

            <h3>Zaubertricks</h3>
            <p class="wizard-intro wizard-count-banner">Wähle genau ${MAGIC_PICK_COUNT} (${state.trickPicks.length}/${MAGIC_PICK_COUNT}):</p>
            <div class="wizard-choice-grid">${trickRows}</div>

            <h3>Rang-1-Zauber</h3>
            <p class="wizard-intro wizard-count-banner">Wähle genau ${MAGIC_PICK_COUNT} (${state.spellPicks.length}/${MAGIC_PICK_COUNT}):</p>
            <div class="wizard-choice-grid">${spellRows}</div>

            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${magicStepValid() ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 6: Attribute ---

    function renderAttributesStep() {
        const allFilled = ATTRIBUTE_ORDER.every((code) => Number.isInteger(state.rawAttributes[code]));
        const overflow = attributesOverflow();

        const cards = ATTRIBUTE_ORDER.map((code) => {
            const raw = state.rawAttributes[code];
            const modifier = ageModifier(code);
            const final = Number.isInteger(raw) ? raw + modifier : null;
            const tooHigh = final !== null && final > 18;

            return `
                <div class="wizard-attribute-card ${tooHigh ? 'wizard-attribute-card--error' : ''}">
                    <label>${ATTRIBUTE_LABELS[code]} (${code})</label>
                    <input type="number" min="3" max="18" class="attribute-input" data-code="${code}" value="${raw ?? ''}">
                    <p class="wizard-attribute-modifier">Alters-Bonus: ${modifier >= 0 ? '+' : ''}${modifier} &rarr; Endwert: ${final ?? '—'}</p>
                    ${tooHigh ? '<p class="wizard-attribute-error">Über 18! Bitte einen niedrigeren Rohwert eintragen.</p>' : ''}
                </div>
            `;
        }).join('');

        const swapOptions = ATTRIBUTE_ORDER.map((code) => `<option value="${code}">${code}</option>`).join('');

        return `
            <h2>6. Attribute</h2>
            <p class="wizard-intro">Würfle 4W6, entferne den niedrigsten Wurf, sechsmal in der Reihenfolge STA, KON, GEW, INT, WIL, CHA.
               Trage die sechs Ergebnisse ein.</p>
            <div class="wizard-attribute-grid">${cards}</div>
            <p class="wizard-intro">Danach darfst du zwei Werte genau einmal tauschen:</p>
            <div class="wizard-swap-row">
                <select id="swap-a">${swapOptions}</select>
                <select id="swap-b">${swapOptions}</select>
                <button type="button" id="swap-button" ${state.swapUsed ? 'disabled' : ''}>Tauschen</button>
            </div>
            ${state.swapUsed ? '<p class="wizard-note">Tausch bereits verwendet.</p>' : ''}
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${allFilled && !overflow ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 7: Schwäche ---

    function renderFlawStep() {
        const rows = catalog.flaws.map((flaw) => `
            <label class="wizard-choice ${state.flawRoll === flaw.roll_min ? 'wizard-choice--selected' : ''}">
                <input type="radio" name="flaw" value="${flaw.roll_min}" ${state.flawRoll === flaw.roll_min ? 'checked' : ''}>
                <div class="wizard-choice-head">
                    <span class="wizard-choice-title">${flaw.roll_min}. ${flaw.name_de}</span>
                </div>
                <p>${flaw.description_de}</p>
            </label>
        `).join('');

        return `
            <h2>7. Schwäche</h2>
            <p class="wizard-intro">W20 am Tisch würfeln und die passende Zeile wählen, oder direkt auswählen.</p>
            <div class="wizard-choice-list">${rows}</div>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step" ${state.flawRoll ? '' : 'disabled'}>Weiter</button>
            </div>
        `;
    }

    // --- Schritt 8: Memento ---

    function renderMementoStep() {
        const examples = catalog.mementos.map((entry) => `<li>${entry.description_de}</li>`).join('');

        return `
            <h2>8. Memento</h2>
            <p class="wizard-intro">Ein Gegenstand ohne praktischen Nutzen, 1×/Sitzung nutzbar, um während einer langen Rast
               einen Zustand zu heilen. Bei Verlust am Ende einer Sitzung ein neues wählen.</p>
            <label class="wizard-field">Memento<br><input type="text" id="memento-input" value="${escapeHtml(state.mementoDe)}" maxlength="255"></label>
            <p class="wizard-note">Beispiele (W20 würfeln oder eigenes ausdenken):</p>
            <ol class="wizard-static-list">${examples}</ol>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="next-step">Weiter</button>
            </div>
        `;
    }

    // --- Schritt 9: Aussehen (letzter Schritt, direkt Absenden) ---

    function renderAppearanceStep() {
        const examples = catalog.appearances.map((entry) => `<li>${entry.description_de}</li>`).join('');

        return `
            <h2>9. Aussehen</h2>
            <label class="wizard-field">Kurze Beschreibung<br><textarea id="appearance-input" rows="3">${escapeHtml(state.appearanceDe)}</textarea></label>
            <p class="wizard-note">Beispiele (W20 würfeln oder eigenes ausdenken):</p>
            <ol class="wizard-static-list">${examples}</ol>
            <div class="wizard-nav">
                <button type="button" id="prev-step">Zurück</button>
                <button type="button" id="submit-character">Charakter erstellen</button>
            </div>
        `;
    }

    function buildPayload() {
        const profession = selectedProfession();

        return {
            name_de: state.nameDe.trim(),
            kin_code: state.kinCode,
            profession_code: state.professionCode,
            profession_heroic_ability_id: state.professionHeroicAbilityId,
            age_code: state.ageCode,
            raw_attributes: state.rawAttributes,
            learned_skill_ids: state.poolPicks.concat(state.extraPicks),
            heroic_ability_choice: state.heroicAbilityChoice,
            flaw_roll: state.flawRoll,
            gear_option_id: state.gearOptionId,
            rolled_silver: state.rolledSilver,
            magic_school_id: profession.grants_magic ? state.magicSchoolId : null,
            known_trick_ids: profession.grants_magic ? state.trickPicks : [],
            known_spell_ids: profession.grants_magic ? state.spellPicks : [],
            memento_de: state.mementoDe,
            appearance_de: state.appearanceDe,
        };
    }

    function submitCharacter() {
        state.appearanceDe = document.getElementById('appearance-input').value;
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
                window.location.href = `/character/${data.id}`;
            });
    }

    // --- Event-Verdrahtung ---

    function attachHandlers() {
        const prev = document.getElementById('prev-step');
        if (prev) {
            prev.addEventListener('click', () => goRelative(-1));
        }
        const next = document.getElementById('next-step');
        if (next) {
            next.addEventListener('click', () => goRelative(1));
        }

        root.querySelectorAll('input[name="kin"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.kinCode = input.value;
                state.professionCode = null;
                state.professionHeroicAbilityId = null;
                render();
            });
        });

        root.querySelectorAll('input[name="profession"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.professionCode = input.value;
                state.professionHeroicAbilityId = null;
                state.poolPicks = [];
                state.gearOptionId = null;
                state.rolledSilver = null;
                state.magicSchoolId = null;
                state.trickPicks = [];
                state.spellPicks = [];
                render();
            });
        });

        root.querySelectorAll('input[name="profession-heroic-ability"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.professionHeroicAbilityId = parseInt(input.value, 10);
                render();
            });
        });

        const nameInput = document.getElementById('name-input');
        if (nameInput) {
            nameInput.addEventListener('input', () => {
                state.nameDe = nameInput.value;
                document.getElementById('next-step').disabled = !step3Valid();
            });
        }

        root.querySelectorAll('input[name="age"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.ageCode = input.value;
                state.extraPicks = [];
                render();
            });
        });

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

        root.querySelectorAll('input[name="gear"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.gearOptionId = parseInt(input.value, 10);
                state.rolledSilver = null;
                render();
            });
        });

        const rolledSilverInput = document.getElementById('rolled-silver-input');
        if (rolledSilverInput) {
            rolledSilverInput.addEventListener('input', () => {
                state.rolledSilver = rolledSilverInput.value === '' ? null : parseInt(rolledSilverInput.value, 10);
                document.getElementById('next-step').disabled = !step3Valid();
            });
        }

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

        root.querySelectorAll('input[name="magic-school"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.magicSchoolId = parseInt(input.value, 10);
                state.poolPicks = state.poolPicks.filter((id) => !catalog.magic.schools.some((s) => s.skill_id === id));
                state.trickPicks = [];
                state.spellPicks = [];
                render();
            });
        });

        root.querySelectorAll('.trick-pick').forEach((checkbox) => {
            checkbox.addEventListener('change', () => {
                const id = parseInt(checkbox.value, 10);
                if (checkbox.checked) {
                    if (state.trickPicks.length >= MAGIC_PICK_COUNT) {
                        checkbox.checked = false;
                        return;
                    }
                    state.trickPicks.push(id);
                } else {
                    state.trickPicks = state.trickPicks.filter((pick) => pick !== id);
                }
                render();
            });
        });

        root.querySelectorAll('.spell-pick').forEach((checkbox) => {
            checkbox.addEventListener('change', () => {
                const id = parseInt(checkbox.value, 10);
                if (checkbox.checked) {
                    if (state.spellPicks.length >= MAGIC_PICK_COUNT) {
                        checkbox.checked = false;
                        return;
                    }
                    state.spellPicks.push(id);
                } else {
                    state.spellPicks = state.spellPicks.filter((pick) => pick !== id);
                }
                render();
            });
        });

        root.querySelectorAll('.attribute-input').forEach((input) => {
            input.addEventListener('input', () => {
                const value = parseInt(input.value, 10);
                state.rawAttributes[input.dataset.code] = Number.isInteger(value) ? value : null;
                render();
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

        root.querySelectorAll('input[name="flaw"]').forEach((input) => {
            input.addEventListener('change', () => {
                state.flawRoll = parseInt(input.value, 10);
                render();
            });
        });

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
    }

    fetch(root.dataset.catalogUrl)
        .then((response) => response.json())
        .then((data) => {
            catalog = data;
            render();
        });
})();
