import { test } from 'node:test';
import assert from 'node:assert/strict';
import { change, click, fakeFetch, flush, loadPage } from './helpers/browser.js';

const HTML = `
<div class="sheet" data-id="5">
    <div data-vital="hp" data-current="6" data-max="10">
        <button data-vital-step="-1">-</button>
        <div class="ui-bar" aria-valuenow="6"><div class="ui-bar__fill" style="width: 60%"></div></div>
        <span class="ui-bar__label">6 / 10</span>
        <button data-vital-step="1">+</button>
    </div>
    <div data-vital="wp" data-current="2" data-max="8">
        <div class="ui-bar"><div class="ui-bar__fill"></div><span class="ui-bar__label">2 / 8</span></div>
    </div>
    <dialog data-rest-sheet>
        <button data-rest="breather">Verschnaufen</button>
        <input type="checkbox" data-rest-tended>
        <select data-rest-condition><option value="">keinen</option><option value="tired">Erschöpft</option></select>
        <button data-rest="short">Kurze Rast</button>
    </dialog>
    <button class="condition-chip" aria-pressed="false" data-condition="tired">Erschöpft</button>
    <input type="checkbox" data-skill-mark="3">
    <div class="gear-entry">
        <span class="ui-details__title">Schwert</span>
        <input data-segment="weapons" data-row-id="8" data-field="name_de" value="Schwert">
        <input type="number" data-segment="weapons" data-row-id="8" data-field="durability" value="3">
    </div>
    <div class="gear-entry">
        <span class="ui-details__title"><span class="gear-qty">5×</span> <span class="gear-name">Tagesration</span></span>
        <input data-segment="inventory" data-row-id="9" data-field="name_de" value="Tagesration">
        <input type="number" data-segment="inventory" data-row-id="9" data-field="quantity" value="5">
    </div>
    <button data-add="weapons">Neu</button>
    <button data-remove="weapons" data-row-id="8">Entfernen</button>
    <input type="number" id="coins-gold" data-coin value="1">
    <input type="number" id="coins-silver" data-coin value="2">
    <input type="number" id="coins-copper" data-coin value="">
    <button data-delete-confirm>Löschen</button>
</div>`;

async function openSheet(routes = {}) {
    const fetch = fakeFetch(routes);
    const page = await loadPage('character-sheet.js', { html: HTML, fetch });

    return { ...page, fetch };
}

test('changes hit points within 0..max and shows the server value', async () => {
    const { document, fetch } = await openSheet({ 'POST /character/5/hp': { hp_current: 7 } });
    const [minus, plus] = document.querySelectorAll('[data-vital-step]');

    click(plus);
    await flush();

    assert.deepEqual(fetch.calls, [{ method: 'POST', url: '/character/5/hp', body: { value: 7 } }]);
    assert.equal(document.querySelector('.ui-bar__label').textContent, '7 / 10');
    assert.equal(document.querySelector('.ui-bar__fill').style.width, '70%');

    for (let i = 0; i < 12; i += 1) click(minus);
    assert.equal(fetch.calls.at(-1).body.value, 0, 'never below zero');
});

test('puts hit points back and complains when saving fails', async () => {
    const { document, toasts } = await openSheet({ 'POST /character/5/hp': { status: 500 } });

    click(document.querySelector('[data-vital-step="1"]'));
    await flush();

    assert.equal(document.querySelector('.ui-bar__label').textContent, '6 / 10');
    assert.equal(toasts.at(-1).kind, 'error');
});

test('toggles a condition from the server answer', async () => {
    const { document } = await openSheet({ 'POST /character/5/conditions/tired/toggle': { active: true } });
    const chip = document.querySelector('[data-condition]');

    click(chip);
    await flush();

    assert.equal(chip.getAttribute('aria-pressed'), 'true');
});

test('a short rest sends the choices and shows what the server healed', async () => {
    const { document, fetch, toasts } = await openSheet({
        'POST /character/5/rest': { hp_current: 9, wp_current: 5, hp_gain: 3, wp_gain: 3, cleared: ['tired'] },
    });
    const chip = document.querySelector('[data-condition="tired"]');
    chip.setAttribute('aria-pressed', 'true');

    change(document.querySelector('[data-rest-tended]'), true);
    change(document.querySelector('[data-rest-condition]'), 'tired');
    click(document.querySelector('[data-rest="short"]'));
    await flush();

    assert.deepEqual(fetch.calls, [
        { method: 'POST', url: '/character/5/rest', body: { type: 'short', tended: true, condition: 'tired' } },
    ]);
    assert.equal(document.querySelector('[data-vital="hp"] .ui-bar__label').textContent, '9 / 10');
    assert.equal(document.querySelector('[data-vital="wp"] .ui-bar__label').textContent, '5 / 8');
    assert.equal(chip.getAttribute('aria-pressed'), 'false');
    assert.equal(toasts.at(-1).message, '+3 TP, +3 WP, 1 Zustand geheilt');
});

test('undoes a skill mark that could not be saved', async () => {
    const { document } = await openSheet({ 'POST /character/5/skills/3/mark': { status: 500 } });
    const box = document.querySelector('[data-skill-mark]');

    change(box, true);
    await flush();

    assert.equal(box.checked, false);
});

test('saves a gear field and keeps the row title in step', async () => {
    const { document, fetch, toasts } = await openSheet();
    const name = document.querySelector('[data-field="name_de"]');

    change(name, 'Langschwert');
    await flush();
    change(document.querySelector('[data-field="durability"]'), '');
    await flush();

    assert.deepEqual(fetch.calls, [
        { method: 'POST', url: '/character/5/weapons/8', body: { name_de: 'Langschwert' } },
        { method: 'POST', url: '/character/5/weapons/8', body: { durability: null } },
    ]);
    assert.equal(document.querySelector('.ui-details__title').textContent, 'Langschwert');
    assert.equal(toasts.at(-1).message, 'Gespeichert');
});

test('shows the inventory quantity in front of the name and keeps it in step', async () => {
    const { document } = await openSheet();
    const title = () =>
        document.querySelector('[data-row-id="9"]').closest('.gear-entry').querySelector('.ui-details__title');

    change(document.querySelector('[data-segment="inventory"][data-field="quantity"]'), '2');
    change(document.querySelector('[data-segment="inventory"][data-field="name_de"]'), 'Leier');
    await flush();

    assert.equal(title().textContent, '2× Leier');
});

test('adding and removing a row reloads the page', async () => {
    const { document, fetch, location } = await openSheet({ 'DELETE /character/5/weapons/8': {} });

    click(document.querySelector('[data-add]'));
    await flush();
    click(document.querySelector('[data-remove]'));
    await flush();

    assert.deepEqual(
        fetch.calls.map((call) => `${call.method} ${call.url}`),
        ['POST /character/5/weapons', 'DELETE /character/5/weapons/8']
    );
    assert.equal(location.reloads, 2);
});

test('saves all three coin fields together', async () => {
    const { document, fetch } = await openSheet();

    change(document.getElementById('coins-gold'), '4');
    await flush();

    assert.deepEqual(fetch.calls[0].body, { gold: 4, silver: 2, copper: 0 });
});

test('deleting the character also forgets it in this browser', async () => {
    const { document, window, location } = await openSheet({ 'DELETE /character/5': {} });
    window.localStorage.setItem('trpg.myCharacters', '["5","9"]');

    click(document.querySelector('[data-delete-confirm]'));
    await flush();

    assert.deepEqual(JSON.parse(window.localStorage.getItem('trpg.myCharacters')), ['9']);
    assert.equal(location.href, '/characters');
});
