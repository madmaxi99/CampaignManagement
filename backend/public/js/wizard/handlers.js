/* Event wiring of the wizard: reads the controls of the rendered step into the state. */
import { AGE_TABLE, MAGIC_PICK_COUNT, POOL_PICK_COUNT } from './config.js';
import { ATTRIBUTE_ERROR_TEXT, attributeModifierText } from './steps.js';
import { canContinue, isTooHigh } from './rules.js';

/**
 * @param {HTMLElement} root the wizard element
 * @param {{state: object, catalog: object, render: Function, goRelative: Function, submit: Function}} app
 */
export function attachHandlers(root, { state, catalog, render, goRelative, submit }) {
    const byId = (id) => document.getElementById(id);

    function updateNext() {
        const next = byId('next-step');
        if (next) {
            next.disabled = !canContinue(state, catalog);
        }
    }

    /** Radio group: store the chosen value, then redraw. */
    function onRadio(name, apply) {
        root.querySelectorAll(`input[name="${name}"]`).forEach((input) => {
            input.addEventListener('change', () => {
                apply(input.value);
                render();
            });
        });
    }

    /** Text field: store what is typed, optionally re-checking "Weiter" without a redraw. */
    function onText(id, apply, { revalidate = false } = {}) {
        const input = byId(id);
        if (!input) {
            return;
        }
        input.addEventListener('input', () => {
            apply(input.value);
            if (revalidate) {
                updateNext();
            }
        });
    }

    /** Checkboxes limited to `limit` picks, kept as an id list in state[key]. */
    function onPicks(selector, key, limit, { onRemove = () => {} } = {}) {
        root.querySelectorAll(selector).forEach((checkbox) => {
            checkbox.addEventListener('change', () => {
                const id = parseInt(checkbox.value, 10);
                if (checkbox.checked) {
                    if (state[key].length >= limit()) {
                        checkbox.checked = false;
                        return;
                    }
                    state[key].push(id);
                } else {
                    state[key] = state[key].filter((pick) => pick !== id);
                    onRemove(id);
                }
                render();
            });
        });
    }

    const integer = (value) => parseInt(value, 10);

    byId('prev-step')?.addEventListener('click', () => goRelative(-1));
    byId('next-step')?.addEventListener('click', () => goRelative(1));
    byId('submit-character')?.addEventListener('click', submit);

    // Step 1 and 2
    onRadio('kin', (code) => {
        state.kinCode = code;
        state.professionCode = null;
        state.professionHeroicAbilityId = null;
    });
    function selectProfession(code) {
        if (state.professionCode === code) {
            return;
        }
        Object.assign(state, {
            professionCode: code,
            professionHeroicAbilityId: null,
            poolPicks: [],
            gearOptionId: null,
            rolledSilver: null,
            magicSchoolId: null,
            trickPicks: [],
            spellPicks: [],
        });
    }
    onRadio('profession', selectProfession);
    // Picking a school or heroic ability inside a profession card also picks that profession.
    onRadio('profession-heroic-ability', (id) => {
        const owner = catalog.professions.find((p) => p.heroicAbilities.some((a) => a.id === integer(id)));
        selectProfession(owner.code);
        state.professionHeroicAbilityId = integer(id);
    });
    onRadio('magic-school', (id) => {
        selectProfession(catalog.professions.find((p) => p.grants_magic).code);
        state.magicSchoolId = integer(id);
        state.poolPicks = state.poolPicks.filter(
            (skillId) => !catalog.magic.schools.some((s) => s.skill_id === skillId)
        );
        state.trickPicks = [];
        state.spellPicks = [];
    });

    // Step 3
    onText('name-input', (value) => (state.nameDe = value), { revalidate: true });
    onRadio('age', (code) => {
        state.ageCode = code;
        state.extraPicks = [];
    });
    onPicks('.pool-pick', 'poolPicks', () => POOL_PICK_COUNT, {
        onRemove: (id) => (state.extraPicks = state.extraPicks.filter((pick) => pick !== id)),
    });
    onRadio('gear', (id) => {
        state.gearOptionId = integer(id);
        state.rolledSilver = null;
    });
    onText('rolled-silver-input', (value) => (state.rolledSilver = value === '' ? null : integer(value)), {
        revalidate: true,
    });

    // Step 4 and 5
    onPicks('.extra-pick', 'extraPicks', () => AGE_TABLE[state.ageCode].extra);
    onPicks('.trick-pick', 'trickPicks', () => MAGIC_PICK_COUNT);
    onPicks('.spell-pick', 'spellPicks', () => MAGIC_PICK_COUNT);

    // Step 6: edit one value in place (a redraw would take the focus away)
    root.querySelectorAll('.attribute-input').forEach((input) => {
        input.addEventListener('input', () => {
            const code = input.dataset.code;
            const value = integer(input.value);
            state.rawAttributes[code] = Number.isInteger(value) ? value : null;

            const card = input.closest('.wizard-attribute-card');
            const tooHigh = isTooHigh(state, code);
            card.classList.toggle('wizard-attribute-card--error', tooHigh);
            card.querySelector('.wizard-attribute-modifier').textContent = attributeModifierText(state, code);

            let error = card.querySelector('.wizard-attribute-error');
            if (tooHigh && !error) {
                error = document.createElement('p');
                error.className = 'wizard-attribute-error';
                error.textContent = ATTRIBUTE_ERROR_TEXT;
                card.appendChild(error);
            } else if (!tooHigh && error) {
                error.remove();
            }
            updateNext();
        });
    });
    byId('swap-button')?.addEventListener('click', () => {
        const a = byId('swap-a').value;
        const b = byId('swap-b').value;
        if (a === b) {
            return;
        }
        [state.rawAttributes[a], state.rawAttributes[b]] = [state.rawAttributes[b], state.rawAttributes[a]];
        state.swapUsed = true;
        render();
    });

    // Step 7 to 9
    onRadio('flaw', (roll) => {
        state.flawRoll = integer(roll);
    });
    onText('memento-input', (value) => (state.mementoDe = value));
    onText('appearance-input', (value) => (state.appearanceDe = value));
}
