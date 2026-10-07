import { test } from 'node:test';
import assert from 'node:assert/strict';
import { catalog } from './fixtures/catalog.js';
import {
    attributesOverflow,
    buildPayload,
    canContinue,
    createState,
    finalAttribute,
    silverMax,
    visibleSteps,
} from '../public/js/wizard/rules.js';

function stateWith(changes) {
    return Object.assign(createState(), changes);
}

test('the magic step only exists for casters', () => {
    assert.deepEqual(visibleSteps(stateWith({ professionCode: 'fighter' }), catalog), [1, 2, 3, 4, 6, 7, 8, 9]);
    assert.deepEqual(visibleSteps(stateWith({ professionCode: 'mage' }), catalog), [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    assert.deepEqual(visibleSteps(createState(), catalog), [1, 2, 3, 4, 6, 7, 8, 9]);
});

test('age modifiers apply to the final attribute and can push it over 18', () => {
    const state = stateWith({ ageCode: 'jung', rawAttributes: { ...createState().rawAttributes, GEW: 18, STA: 10 } });

    assert.equal(finalAttribute(state, 'GEW'), 19);
    assert.equal(finalAttribute(state, 'STA'), 10);
    assert.equal(finalAttribute(state, 'CHA'), null);
    assert.equal(attributesOverflow(state), true);
    assert.equal(attributesOverflow({ ...state, ageCode: 'erwachsen' }), false);
});

test('the silver die of the chosen gear option limits the rolled silver', () => {
    const state = stateWith({ professionCode: 'fighter', gearOptionId: 11 });
    assert.equal(silverMax(state, catalog), 6);
    assert.equal(silverMax({ ...state, professionCode: 'mage', gearOptionId: 21 }, catalog), 0);
});

test('"Weiter" depends on the step', () => {
    assert.equal(canContinue(stateWith({ step: 1 }), catalog), false);
    assert.equal(canContinue(stateWith({ step: 1, kinCode: 'human' }), catalog), true);

    assert.equal(canContinue(stateWith({ step: 2, professionCode: 'fighter' }), catalog), true);
    assert.equal(canContinue(stateWith({ step: 2, professionCode: 'mage' }), catalog), false, 'school missing');
    assert.equal(canContinue(stateWith({ step: 2, professionCode: 'mage', magicSchoolId: 2 }), catalog), true);

    const step3 = {
        step: 3,
        professionCode: 'fighter',
        nameDe: 'A',
        ageCode: 'jung',
        poolPicks: [1, 2, 3, 4, 5, 6],
        gearOptionId: 11,
        rolledSilver: 3,
    };
    assert.equal(canContinue(stateWith(step3), catalog), true);
    assert.equal(canContinue(stateWith({ ...step3, rolledSilver: 7 }), catalog), false);
    assert.equal(canContinue(stateWith({ ...step3, nameDe: '  ' }), catalog), false);
    assert.equal(canContinue(stateWith({ ...step3, poolPicks: [1] }), catalog), false);

    assert.equal(canContinue(stateWith({ step: 4, ageCode: 'jung', extraPicks: [9] }), catalog), false);
    assert.equal(canContinue(stateWith({ step: 4, ageCode: 'jung', extraPicks: [9, 10] }), catalog), true);

    assert.equal(canContinue(stateWith({ step: 7 }), catalog), false);
    assert.equal(canContinue(stateWith({ step: 7, flawRoll: 2 }), catalog), true);
});

test('only casters send magic choices', () => {
    const base = { kinCode: 'human', magicSchoolId: 2, trickPicks: [1, 2, 3], spellPicks: [11, 12, 13], nameDe: ' A ' };

    const fighter = buildPayload(stateWith({ ...base, professionCode: 'fighter' }), catalog);
    assert.equal(fighter.name_de, 'A');
    assert.equal(fighter.magic_school_id, null);
    assert.deepEqual(fighter.known_trick_ids, []);

    const mage = buildPayload(stateWith({ ...base, professionCode: 'mage' }), catalog);
    assert.equal(mage.magic_school_id, 2);
    assert.deepEqual(mage.known_spell_ids, [11, 12, 13]);
});
