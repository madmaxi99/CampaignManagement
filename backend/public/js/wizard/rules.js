/*
 * What the creation wizard knows about the rules: pure functions over the
 * wizard state and the catalog, no DOM. The server validates everything again.
 */
import { AGE_TABLE, ATTRIBUTE_ORDER, MAGIC_PICK_COUNT, MAX_ATTRIBUTE, POOL_PICK_COUNT } from './config.js';

export function createState() {
    return {
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
        rawAttributes: Object.fromEntries(ATTRIBUTE_ORDER.map((code) => [code, null])),
        swapUsed: false,
        heroicAbilityChoice: 'profession',
        flawRoll: null,
        mementoDe: '',
        appearanceDe: '',
        error: '',
    };
}

export function selectedKin(state, catalog) {
    return catalog.kins.find((kin) => kin.code === state.kinCode) || null;
}

export function selectedProfession(state, catalog) {
    return catalog.professions.find((profession) => profession.code === state.professionCode) || null;
}

export function ageModifier(state, code) {
    const age = AGE_TABLE[state.ageCode];

    return age ? age.modifiers[code] || 0 : 0;
}

/** The attribute after the age modifier, or null while no value is entered. */
export function finalAttribute(state, code) {
    const raw = state.rawAttributes[code];

    return Number.isInteger(raw) ? raw + ageModifier(state, code) : null;
}

export function isTooHigh(state, code) {
    const final = finalAttribute(state, code);

    return final !== null && final > MAX_ATTRIBUTE;
}

export function attributesOverflow(state) {
    return ATTRIBUTE_ORDER.some((code) => isTooHigh(state, code));
}

export function allAttributesFilled(state) {
    return ATTRIBUTE_ORDER.every((code) => Number.isInteger(state.rawAttributes[code]));
}

/** Preselects what the current step would otherwise leave undecided (the first gear option). */
export function applyDefaults(state, catalog) {
    if (state.step !== 3) {
        return;
    }
    const options = selectedProfession(state, catalog).gearOptions;
    if (state.gearOptionId === null && options.length > 0) {
        state.gearOptionId = options[0].gearOptionId;
    }
}

/** The step sequence depends on the profession: the magic step is only for casters. */
export function visibleSteps(state, catalog) {
    const profession = selectedProfession(state, catalog);
    const steps = [1, 2, 3, 4];
    if (profession && profession.grants_magic) {
        steps.push(5);
    }

    return steps.concat(6, 7, 8, 9);
}

export function currentGearOption(state, catalog) {
    const profession = selectedProfession(state, catalog);

    return profession.gearOptions.find((option) => option.gearOptionId === state.gearOptionId) || null;
}

export function silverMax(state, catalog) {
    const dice = currentGearOption(state, catalog)?.silverDice;

    return dice ? parseInt(dice.slice(1), 10) : 0;
}

function professionStepValid(state, catalog) {
    if (!state.professionCode) {
        return false;
    }
    const profession = selectedProfession(state, catalog);
    if (profession.grants_magic) {
        return state.magicSchoolId !== null;
    }
    if (profession.heroicAbilities.length > 1) {
        return state.professionHeroicAbilityId !== null;
    }

    return true;
}

function nameSkillsGearStepValid(state, catalog) {
    const maxSilver = silverMax(state, catalog);
    const silverOk =
        maxSilver === 0 ||
        (Number.isInteger(state.rolledSilver) && state.rolledSilver >= 1 && state.rolledSilver <= maxSilver);

    return (
        state.nameDe.trim() !== '' &&
        state.ageCode !== null &&
        state.poolPicks.length === POOL_PICK_COUNT &&
        state.gearOptionId !== null &&
        silverOk
    );
}

/** Whether "Weiter" is enabled on the current step. */
export function canContinue(state, catalog) {
    switch (state.step) {
        case 1:
            return Boolean(state.kinCode);
        case 2:
            return professionStepValid(state, catalog);
        case 3:
            return nameSkillsGearStepValid(state, catalog);
        case 4:
            return state.extraPicks.length === AGE_TABLE[state.ageCode].extra;
        case 5:
            return (
                state.magicSchoolId !== null &&
                state.trickPicks.length === MAGIC_PICK_COUNT &&
                state.spellPicks.length === MAGIC_PICK_COUNT
            );
        case 6:
            return allAttributesFilled(state) && !attributesOverflow(state);
        case 7:
            return Boolean(state.flawRoll);
        default:
            return true;
    }
}

/** The request body for POST /characters. */
export function buildPayload(state, catalog) {
    const caster = Boolean(selectedProfession(state, catalog).grants_magic);

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
        magic_school_id: caster ? state.magicSchoolId : null,
        known_trick_ids: caster ? state.trickPicks : [],
        known_spell_ids: caster ? state.spellPicks : [],
        memento_de: state.mementoDe,
        appearance_de: state.appearanceDe,
    };
}
