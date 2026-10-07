import { test } from 'node:test';
import assert from 'node:assert/strict';
import { catalog } from './fixtures/catalog.js';
import { change, click, fakeFetch, flush, loadPage, type } from './helpers/browser.js';

const URL = '/api/character-creation/catalog';

async function openWizard(extraRoutes = {}) {
    const fetch = fakeFetch({ [`GET ${URL}`]: catalog, ...extraRoutes });
    const page = await loadPage('wizard/index.js', {
        html: `<div class="wizard" data-catalog-url="${URL}"></div>`,
        fetch,
    });
    await flush();

    return { ...page, fetch, root: page.document.querySelector('.wizard') };
}

const progress = (root) => root.querySelector('.wizard-progress').textContent.replace(/\s+/g, ' ').trim();
const next = (root) => root.querySelector('#next-step');
const pick = (root, selector, value) => change(root.querySelector(`${selector}[value="${value}"]`));

async function advance(root) {
    click(next(root));
    await flush();
}

async function chooseKinAndProfession(root, profession) {
    pick(root, 'input[name="kin"]', 'human');
    await advance(root);
    pick(root, 'input[name="profession"]', profession);
}

const ATTRIBUTES = ['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'];

/** Fills in steps 3 to 8 of a fighter with valid input and stops at the appearance step. */
async function fillUpToAppearance(root, { age = 'erwachsen', attribute = '10' } = {}) {
    await chooseKinAndProfession(root, 'fighter');
    await advance(root);

    type(root.querySelector('#name-input'), 'A');
    pick(root, 'input[name="age"]', age);
    [1, 2, 3, 4, 5, 6].forEach((id) => change(root.querySelector(`.pool-pick[value="${id}"]`)));
    type(root.querySelector('#rolled-silver-input'), '1');
    await advance(root);

    const extra = age === 'jung' ? [9, 10] : [9, 10, 11, 12];
    extra.forEach((id) => change(root.querySelector(`.extra-pick[value="${id}"]`)));
    await advance(root);

    ATTRIBUTES.forEach((code) => type(root.querySelector(`.attribute-input[data-code="${code}"]`), attribute));
    await advance(root);
    pick(root, 'input[name="flaw"]', '1');
    await advance(root);
    await advance(root);
}

test('starts at step 1 and only allows continuing once a kin is chosen', async () => {
    const { root } = await openWizard();

    assert.match(progress(root), /^Schritt 1 von 8/);
    assert.equal(next(root).disabled, true);

    pick(root, 'input[name="kin"]', 'human');
    assert.equal(next(root).disabled, false);
});

test('a magic profession gets the extra magic step', async () => {
    const { root } = await openWizard();
    await chooseKinAndProfession(root, 'mage');
    assert.equal(next(root).disabled, true, 'needs a school first');

    pick(root, 'input[name="magic-school"]', '2');
    assert.equal(next(root).disabled, false);
    assert.match(progress(root), /^Schritt 2 von 9/);
});

test('choosing a school directly also chooses the magic profession', async () => {
    const { root } = await openWizard();
    pick(root, 'input[name="kin"]', 'human');
    await advance(root);

    pick(root, 'input[name="magic-school"]', '2');
    assert.equal(root.querySelector('input[name="profession"][value="mage"]').checked, true);
    assert.equal(next(root).disabled, false);
});

test('age cards show how the attributes change', async () => {
    const { root } = await openWizard();
    await chooseKinAndProfession(root, 'fighter');
    await advance(root);

    const card = (code) => root.querySelector(`input[name="age"][value="${code}"]`).closest('label').textContent;
    assert.match(card('jung'), /GEW \+1 · KON \+1/);
    assert.match(card('erwachsen'), /keine Attributänderung/);
    assert.match(card('alt'), /STA −2 · GEW −2 · KON −2 · INT \+1 · WIL \+1/);
});

test('skills are split into general and combat skills, each alphabetical', async () => {
    const { root } = await openWizard();
    await chooseKinAndProfession(root, 'fighter');
    await advance(root);

    const headings = [...root.querySelectorAll('.wizard-subheading')].map((h) => h.textContent);
    assert.deepEqual(headings, ['Allgemeine Fertigkeiten', 'Kampffertigkeiten']);

    for (const grid of root.querySelectorAll('.wizard-subheading + .wizard-choice-grid')) {
        const names = [...grid.querySelectorAll('strong')].map((s) => s.textContent);
        assert.deepEqual(
            names,
            [...names].sort((a, b) => a.localeCompare(b, 'de'))
        );
    }
});

test('walks through all steps and submits the character', async () => {
    const { root, fetch, location } = await openWizard({ 'POST /characters': { id: 42 } });

    await chooseKinAndProfession(root, 'fighter');
    await advance(root);

    // step 3: name, age, six pool skills, silver
    type(root.querySelector('#name-input'), '  Alberta ');
    pick(root, 'input[name="age"]', 'jung');
    [1, 2, 3, 4, 5, 6].forEach((id) => change(root.querySelector(`.pool-pick[value="${id}"]`)));
    assert.equal(next(root).disabled, true, 'silver is still missing');
    type(root.querySelector('#rolled-silver-input'), '4');
    assert.equal(next(root).disabled, false);
    await advance(root);

    // step 4: two extra skills for a young character
    [9, 10].forEach((id) => change(root.querySelector(`.extra-pick[value="${id}"]`)));
    await advance(root);

    // step 6: attributes
    ['STA', 'KON', 'GEW', 'INT', 'WIL', 'CHA'].forEach((code, index) =>
        type(root.querySelector(`.attribute-input[data-code="${code}"]`), String(10 + index))
    );
    await advance(root);

    pick(root, 'input[name="flaw"]', '2');
    await advance(root);
    type(root.querySelector('#memento-input'), 'Kiesel');
    await advance(root);
    type(root.querySelector('#appearance-input'), 'Groß');
    click(root.querySelector('#submit-character'));
    await flush();

    const [, request] = fetch.calls;
    assert.deepEqual(request, {
        method: 'POST',
        url: '/characters',
        body: {
            name_de: 'Alberta',
            kin_code: 'human',
            profession_code: 'fighter',
            profession_heroic_ability_id: null,
            age_code: 'jung',
            raw_attributes: { STA: 10, KON: 11, GEW: 12, INT: 13, WIL: 14, CHA: 15 },
            learned_skill_ids: [1, 2, 3, 4, 5, 6, 9, 10],
            heroic_ability_choice: 'profession',
            flaw_roll: 2,
            gear_option_id: 11,
            rolled_silver: 4,
            magic_school_id: null,
            known_trick_ids: [],
            known_spell_ids: [],
            memento_de: 'Kiesel',
            appearance_de: 'Groß',
        },
    });
    assert.equal(location.href, '/character/42');
});

test('remembers the new character as one of mine', async () => {
    const { root, window } = await openWizard({ 'POST /characters': { id: 7 } });
    window.localStorage.setItem('trpg.myCharacters', '["3"]');

    await fillUpToAppearance(root);
    click(root.querySelector('#submit-character'));
    await flush();

    assert.deepEqual(JSON.parse(window.localStorage.getItem('trpg.myCharacters')), ['3', '7']);
});

test('refuses a seventh pool skill', async () => {
    const { root } = await openWizard();
    await chooseKinAndProfession(root, 'fighter');
    await advance(root);

    [1, 2, 3, 4, 5, 6, 7].forEach((id) => change(root.querySelector(`.pool-pick[value="${id}"]`)));

    assert.equal(root.querySelectorAll('.pool-pick:checked').length, 6);
});

test('flags attributes that exceed 18 with the age bonus and swaps only once', async () => {
    const { root } = await openWizard();
    await fillUpToAppearance(root, { age: 'jung' });
    click(root.querySelector('#prev-step'));
    click(root.querySelector('#prev-step'));
    click(root.querySelector('#prev-step'));

    type(root.querySelector('.attribute-input[data-code="GEW"]'), '18');
    assert.ok(root.querySelector('.wizard-attribute-error'), 'GEW 18 + 1 is over the limit');
    assert.equal(next(root).disabled, true);

    type(root.querySelector('.attribute-input[data-code="GEW"]'), '9');
    assert.equal(root.querySelector('.wizard-attribute-error'), null);
    assert.equal(next(root).disabled, false);

    root.querySelector('#swap-a').value = 'STA';
    root.querySelector('#swap-b').value = 'CHA';
    type(root.querySelector('.attribute-input[data-code="STA"]'), '12');
    click(root.querySelector('#swap-button'));
    assert.equal(root.querySelector('.attribute-input[data-code="CHA"]').value, '12');
    assert.equal(root.querySelector('#swap-button').disabled, true);
});

test('shows the server error when creating fails', async () => {
    const { root } = await openWizard({ 'POST /characters': { status: 422, json: { error: 'Nope.' } } });

    await fillUpToAppearance(root);
    click(root.querySelector('#submit-character'));
    await flush();

    assert.equal(root.querySelector('.wizard-error').textContent, 'Nope.');
});
