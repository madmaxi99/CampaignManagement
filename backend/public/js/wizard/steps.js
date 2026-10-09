/* The markup of the nine wizard steps. Handlers are attached in handlers.js. */
import {
    AGE_TABLE,
    ATTRIBUTE_LABELS,
    ATTRIBUTE_ORDER,
    GEAR_ROLL_LABELS,
    MAGIC_PICK_COUNT,
    POOL_PICK_COUNT,
} from './config.js';
import { choiceCard, choiceHead, descriptionLine, disabled, escapeHtml, inlineChoice, navigation } from './html.js';
import {
    ageModifier,
    canContinue,
    currentGearOption,
    finalAttribute,
    isTooHigh,
    selectedKin,
    selectedProfession,
    silverMax,
} from './rules.js';

const renderers = [
    null,
    kinStep,
    professionStep,
    nameSkillsGearStep,
    extraSkillsStep,
    magicStep,
    attributesStep,
    flawStep,
    mementoStep,
    appearanceStep,
];

export function renderStep(state, catalog) {
    return renderers[state.step](state, catalog);
}

export function attributeModifierText(state, code) {
    const modifier = ageModifier(state, code);

    return `Alters-Bonus: ${modifier >= 0 ? '+' : ''}${modifier} → Endwert: ${finalAttribute(state, code) ?? '—'}`;
}

/** "GEW +1 · KON +1" for an age card; the minus is a real minus sign. */
function ageModifierText(modifiers) {
    const parts = Object.entries(modifiers).map(
        ([code, value]) => `${code} ${value > 0 ? '+' : '−'}${Math.abs(value)}`
    );

    return parts.length > 0 ? parts.join(' · ') : 'keine Attributänderung';
}

/**
 * Skills as two alphabetical lists: general ones and combat skills.
 * `renderRow` turns one skill into its markup.
 */
function groupedSkillRows(skills, renderRow) {
    const byName = (a, b) => a.name_de.localeCompare(b.name_de, 'de');
    const groups = [
        ['Allgemeine Fertigkeiten', skills.filter((skill) => skill.category !== 'combat')],
        ['Kampffertigkeiten', skills.filter((skill) => skill.category === 'combat')],
    ];

    return groups
        .filter(([, list]) => list.length > 0)
        .map(
            ([title, list]) => `
                <h4 class="wizard-subheading">${title}</h4>
                <div class="wizard-choice-grid">${list.sort(byName).map(renderRow).join('')}</div>
            `
        )
        .join('');
}

export const ATTRIBUTE_ERROR_TEXT = 'Über 18! Bitte einen niedrigeren Rohwert eintragen.';

const nav = (state, catalog, options = {}) => navigation({ enabled: canContinue(state, catalog), ...options });

function kinStep(state, catalog) {
    const rows = catalog.kins
        .map((kin) => {
            const abilities = kin.abilities
                .map(
                    (ability) => `
                        <div class="wizard-ability">
                            <strong>${ability.name_de}</strong>${ability.wp_note_de ? ` <span class="wizard-wp-note">(WP ${ability.wp_note_de})</span>` : ''}
                            <p>${ability.description_de}</p>
                        </div>
                    `
                )
                .join('');
            const range = kin.d12_min + (kin.d12_max > kin.d12_min ? `–${kin.d12_max}` : '');

            return choiceCard({
                name: 'kin',
                value: kin.code,
                selected: state.kinCode === kin.code,
                content: choiceHead(kin.name_de, `W12: ${range}`) + abilities,
            });
        })
        .join('');

    return `
        <h2>1. Volk</h2>
        <p class="wizard-intro">Wähle dein Volk, oder würfle W12 am Tisch und wähle die passende Zeile.</p>
        <div class="wizard-choice-list">${rows}</div>
        ${nav(state, catalog, { first: true })}
    `;
}

function heroicAbilitySection(state, catalog, profession) {
    if (profession.heroicAbilities.length === 0 && profession.grants_magic) {
        // "Allgemein" has no skill_id -- you can't train in it, so it's excluded here.
        const schoolRows = catalog.magic.schools
            .filter((school) => school.skill_id !== null)
            .map((school) =>
                inlineChoice({
                    type: 'radio',
                    name: 'magic-school',
                    value: school.id,
                    isChecked: state.magicSchoolId === school.id,
                    content: `<strong>${school.name_de}</strong>${descriptionLine(school.description_de)}`,
                })
            )
            .join('');

        return `
            <div class="wizard-ability">
                <strong>Kein Berufs-Talent — dafür Magie. Wähle deine Zauberschule:</strong>
                <div class="wizard-choice-grid">${schoolRows}</div>
            </div>
        `;
    }

    if (profession.heroicAbilities.length === 1) {
        const ability = profession.heroicAbilities[0];

        return `
            <div class="wizard-ability">
                <strong>Heroisches Talent: ${ability.name_de}</strong>
                <p>${ability.description_de}</p>
                <p class="wizard-note">Dieses Talent bekommst du bei der Erstellung automatisch — eine Wahl gibt es dabei nicht.</p>
            </div>
        `;
    }

    const choiceRows = profession.heroicAbilities
        .map((ability) =>
            inlineChoice({
                type: 'radio',
                name: 'profession-heroic-ability',
                value: ability.id,
                isChecked: state.professionHeroicAbilityId === ability.id,
                content: `<strong>${ability.name_de}</strong><p>${ability.description_de}</p>`,
            })
        )
        .join('');

    return `
        <div class="wizard-ability">
            <strong>Heroisches Talent — wähle eines:</strong>
            <div class="wizard-choice-grid">${choiceRows}</div>
        </div>
    `;
}

function professionStep(state, catalog) {
    const kin = selectedKin(state, catalog);
    const options = catalog.professions.filter((p) => p.kin_restriction === null || p.kin_restriction === kin.code);
    const rows = options
        .map((profession) => {
            const selected = state.professionCode === profession.code;
            const pool =
                profession.skillPool
                    .map((skill) => `${skill.name_de} (${ATTRIBUTE_LABELS[skill.attribute_code]})`)
                    .join(', ') + (profession.grants_magic ? ', gewählte Zauberschule' : '');

            return choiceCard({
                name: 'profession',
                value: profession.code,
                selected,
                content: `
                    ${choiceHead(profession.name_de, `Schlüsselattribut ${ATTRIBUTE_LABELS[profession.key_attribute_code]}`)}
                    <p class="wizard-choice-detail"><strong>8 Fertigkeiten zur Auswahl (im nächsten Schritt wählst du ${POOL_PICK_COUNT} davon):</strong> ${pool}</p>
                    ${heroicAbilitySection(state, catalog, profession)}
                `,
            });
        })
        .join('');

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
        ${nav(state, catalog)}
    `;
}

function nameSkillsGearStep(state, catalog) {
    const profession = selectedProfession(state, catalog);

    const ageRows = Object.entries(AGE_TABLE)
        .map(([code, age]) =>
            choiceCard({
                name: 'age',
                value: code,
                selected: state.ageCode === code,
                compact: true,
                content: `${age.label} <small>(${POOL_PICK_COUNT} + ${age.extra} = ${age.total} Fertigkeiten)</small> <small>· ${ageModifierText(age.modifiers)}</small>`,
            })
        )
        .join('');

    // A school in catalog.magic.schools has its OWN id (matches catalog_spells.school_id),
    // distinct from skill_id (matches catalog_skills.id / character_skills.skill_id). The
    // pool/checkbox below is skill-based, so map the chosen school to a skill-shaped entry.
    const poolSkills = profession.grants_magic
        ? profession.skillPool.concat(
              catalog.magic.schools
                  .filter((school) => school.id === state.magicSchoolId)
                  .map((school) => ({
                      id: school.skill_id,
                      name_de: school.name_de,
                      attribute_code: school.attribute_code,
                      description_de: school.description_de,
                  }))
          )
        : profession.skillPool;
    const poolRows = groupedSkillRows(poolSkills, (skill) =>
        inlineChoice({
            type: 'checkbox',
            className: 'pool-pick',
            value: skill.id,
            isChecked: state.poolPicks.includes(skill.id),
            content: `<strong>${skill.name_de}</strong> <small>(${ATTRIBUTE_LABELS[skill.attribute_code]})</small>${descriptionLine(skill.description_de)}`,
        })
    );

    const gearRows = profession.gearOptions
        .map((option) => {
            const items = option.items.map((item) =>
                item.quantity > 1 ? `${item.quantity}× ${item.name}` : item.name
            );

            return choiceCard({
                name: 'gear',
                value: option.gearOptionId,
                selected: state.gearOptionId === option.gearOptionId,
                content: `
                    ${choiceHead(`Option ${option.label}`, `W6: ${GEAR_ROLL_LABELS[option.label] || '?'}`)}
                    <p>${items.join(', ')}${option.extra_de ? `, ${option.extra_de}` : ''}</p>
                `,
            });
        })
        .join('');

    const maxSilver = silverMax(state, catalog);
    const silverField =
        maxSilver > 0
            ? `
                <label class="wizard-field">Gewürfeltes Silber (${currentGearOption(state, catalog).silverDice} würfeln, 1–${maxSilver})<br>
                    <input type="number" id="rolled-silver-input" min="1" max="${maxSilver}" value="${state.rolledSilver ?? ''}"></label>
            `
            : '';

    return `
        <h2>3. Name, Alter, Fertigkeiten &amp; Ausrüstung</h2>
        <label class="wizard-field">Name<br><input type="text" id="name-input" value="${escapeHtml(state.nameDe)}" maxlength="100"></label>
        <p class="wizard-intro">Alter (W6 am Tisch würfeln oder direkt wählen: 1–3 Jung, 4–5 Erwachsen, 6 Alt):</p>
        <div class="wizard-choice-list">${ageRows}</div>

        <h3>Fertigkeiten-Pool deines Berufs</h3>
        <p class="wizard-intro">Wähle genau ${POOL_PICK_COUNT} der 8 Fertigkeiten deines Berufs (${state.poolPicks.length}/${POOL_PICK_COUNT}):</p>
        ${poolRows}

        <h3>Ausrüstung</h3>
        ${profession.gearOptions.length > 1 ? '<p class="wizard-intro">W6 am Tisch würfeln oder direkt eine Option wählen:</p>' : ''}
        <div class="wizard-choice-list">${gearRows}</div>
        ${silverField}
        <p class="wizard-note">Währung: 100 Kupfer = 10 Silber = 1 Gold. Anpassbar im fertigen Charakterbogen.</p>

        ${nav(state, catalog)}
    `;
}

function extraSkillsStep(state, catalog) {
    const age = AGE_TABLE[state.ageCode];
    const rows = groupedSkillRows(
        catalog.skills.filter((skill) => !state.poolPicks.includes(skill.id)),
        (skill) =>
            inlineChoice({
                type: 'checkbox',
                className: 'extra-pick',
                value: skill.id,
                isChecked: state.extraPicks.includes(skill.id),
                content: `<strong>${skill.name_de}</strong> <small>(${ATTRIBUTE_LABELS[skill.attribute_code]})</small>${descriptionLine(skill.description_de)}`,
            })
    );

    return `
        <h2>4. Weitere Fertigkeiten</h2>
        <p class="wizard-intro wizard-count-banner">Wähle ${age.extra} weitere Fertigkeiten frei — aktuell ${state.extraPicks.length} von ${age.extra} gewählt.</p>
        ${rows}
        ${nav(state, catalog)}
    `;
}

function magicStep(state, catalog) {
    const school = catalog.magic.schools.find((s) => s.id === state.magicSchoolId);
    const generalSchool = catalog.magic.schools.find((s) => s.skill_id === null);
    const isGeneral = (spell) => spell.school_id === generalSchool.id;
    const available = (type) =>
        catalog.magic.spells.filter(
            (spell) => spell.type === type && (isGeneral(spell) || spell.school_id === state.magicSchoolId)
        );

    const rows = (type, className, picks, withNote) =>
        available(type)
            .map((spell) =>
                inlineChoice({
                    type: 'checkbox',
                    className,
                    value: spell.id,
                    isChecked: picks.includes(spell.id),
                    content: `
                        <strong>${spell.name_de}</strong> ${isGeneral(spell) ? '<small>(Allgemein)</small>' : ''}
                        ${withNote ? `<small>${spell.wp_note_de || ''}</small>` : ''}
                        <p>${spell.effect_de}</p>
                    `,
                })
            )
            .join('');

    return `
        <h2>5. Magie</h2>
        <p class="wizard-intro">Zauberschule: <strong>${school.name_de}</strong> (gewählt in Schritt 2)</p>

        <h3>Zaubertricks</h3>
        <p class="wizard-intro wizard-count-banner">Wähle genau ${MAGIC_PICK_COUNT} (${state.trickPicks.length}/${MAGIC_PICK_COUNT}):</p>
        <div class="wizard-choice-grid">${rows('trick', 'trick-pick', state.trickPicks, false)}</div>

        <h3>Rang-1-Zauber</h3>
        <p class="wizard-intro wizard-count-banner">Wähle genau ${MAGIC_PICK_COUNT} (${state.spellPicks.length}/${MAGIC_PICK_COUNT}):</p>
        <div class="wizard-choice-grid">${rows('spell', 'spell-pick', state.spellPicks, true)}</div>

        ${nav(state, catalog)}
    `;
}

function attributesStep(state, catalog) {
    const cards = ATTRIBUTE_ORDER.map((code) => {
        const tooHigh = isTooHigh(state, code);

        return `
            <div class="wizard-attribute-card ${tooHigh ? 'wizard-attribute-card--error' : ''}">
                <label>${ATTRIBUTE_LABELS[code]} (${code})</label>
                <input type="number" min="3" max="18" class="attribute-input" data-code="${code}" value="${state.rawAttributes[code] ?? ''}">
                <p class="wizard-attribute-modifier">${attributeModifierText(state, code)}</p>
                ${tooHigh ? `<p class="wizard-attribute-error">${ATTRIBUTE_ERROR_TEXT}</p>` : ''}
            </div>
        `;
    }).join('');

    const swapOptions = ATTRIBUTE_ORDER.map((code) => `<option value="${code}">${code}</option>`).join('');

    return `
        <h2>6. Attribute</h2>
        <p class="wizard-intro">Würfle sechsmal 4W6 und entferne jeweils den niedrigsten Wurf.
           Trage die sechs Ergebnisse in beliebiger Reihenfolge ein: Du entscheidest, welcher Wert zu welchem Attribut gehört.</p>
        <div class="wizard-attribute-grid">${cards}</div>
        <p class="wizard-intro">Danach darfst du zwei Werte genau einmal tauschen:</p>
        <div class="wizard-swap-row">
            <select id="swap-a">${swapOptions}</select>
            <select id="swap-b">${swapOptions}</select>
            <button type="button" id="swap-button" ${disabled(state.swapUsed)}>Tauschen</button>
        </div>
        ${state.swapUsed ? '<p class="wizard-note">Tausch bereits verwendet.</p>' : ''}
        ${nav(state, catalog)}
    `;
}

function flawStep(state, catalog) {
    const rows = catalog.flaws
        .map((flaw) =>
            choiceCard({
                name: 'flaw',
                value: flaw.roll_min,
                selected: state.flawRoll === flaw.roll_min,
                content: `${choiceHead(`${flaw.roll_min}. ${flaw.name_de}`)}<p>${flaw.description_de}</p>`,
            })
        )
        .join('');

    return `
        <h2>7. Schwäche</h2>
        <p class="wizard-intro">W20 am Tisch würfeln und die passende Zeile wählen, oder direkt auswählen.</p>
        <div class="wizard-choice-list">${rows}</div>
        ${nav(state, catalog)}
    `;
}

function mementoStep(state, catalog) {
    const examples = catalog.mementos.map((entry) => `<li>${entry.description_de}</li>`).join('');

    return `
        <h2>8. Memento</h2>
        <p class="wizard-intro">Ein Gegenstand ohne praktischen Nutzen, 1×/Sitzung nutzbar, um während einer langen Rast
           einen Zustand zu heilen. Bei Verlust am Ende einer Sitzung ein neues wählen.</p>
        <label class="wizard-field">Memento<br><input type="text" id="memento-input" value="${escapeHtml(state.mementoDe)}" maxlength="255"></label>
        <p class="wizard-note">Beispiele (W20 würfeln oder eigenes ausdenken):</p>
        <ol class="wizard-static-list">${examples}</ol>
        ${nav(state, catalog)}
    `;
}

function appearanceStep(state, catalog) {
    const examples = catalog.appearances.map((entry) => `<li>${entry.description_de}</li>`).join('');

    return `
        <h2>9. Aussehen</h2>
        <label class="wizard-field">Kurze Beschreibung<br><textarea id="appearance-input" rows="3">${escapeHtml(state.appearanceDe)}</textarea></label>
        <p class="wizard-note">Beispiele (W20 würfeln oder eigenes ausdenken):</p>
        <ol class="wizard-static-list">${examples}</ol>
        ${nav(state, catalog, { nextId: 'submit-character', nextLabel: 'Charakter erstellen' })}
    `;
}
