import { test } from 'node:test';
import assert from 'node:assert/strict';
import { change, click, fakeFetch, flush, loadPage, type } from './helpers/browser.js';

const HTML = `
<div data-campaign-id="4">
    <input id="quick-search">
    <a class="entity-link" id="here" href="#location-7" data-entity-type="place" data-entity-id="7">Torhaus</a>
    <a class="entity-link" id="monster" href="#" data-entity-type="bestiary" data-entity-id="3">Wolf</a>
    <article id="location-7">Torhaus</article>
    <dialog id="foes">
        <article data-foe data-foe-id="11" data-foe-max="9" class="foe">
            <input data-foe-hp-input value="9">
            <div data-foe-bar data-hp="9" class="ui-bar" aria-valuenow="9"><div class="ui-bar__fill"></div><span class="ui-bar__label">TP 9/9</span></div>
            <span data-foe-down hidden>Besiegt</span>
        </article>
        <input id="foe-search"><input id="foe-count" value="2">
        <div id="foe-list">
            <button data-id="3" data-search="wolf tier">Wolf</button>
            <button data-id="4" data-search="bär tier">Bär</button>
            <button data-id="5" data-search="skelett untot">Skelett</button>
            <p id="foe-empty" hidden></p>
        </div>
    </dialog>
    <details class="menu" open><summary>Werkzeuge</summary><div class="menu__list"><button id="pick">Jagd</button></div></details>
    <p id="outside">außerhalb</p>
</div>
<template id="tpl-bestiary-3" data-bestiary-id="3"><p>Wolf</p></template>
<dialog id="entity-sheet"><div id="entity-sheet-body"></div></dialog>
<dialog id="chronicle-sheet"><form id="chronicle-edit-form"></form></dialog>`;

async function openPlay(routes = {}) {
    const fetch = fakeFetch(routes);
    const page = await loadPage('campaign-play.js', { html: HTML, fetch });
    page.document.getElementById('entity-sheet').showModal = function () {
        this.setAttribute('open', '');
    };

    return { ...page, fetch };
}

function clickEvent(window) {
    return new window.MouseEvent('click', { bubbles: true, cancelable: true });
}

test('a place scrolls into view instead of opening a dialog', async () => {
    const { document, window } = await openPlay();
    let scrolled = 0;
    document.getElementById('location-7').scrollIntoView = () => (scrolled += 1);

    const event = clickEvent(window);
    document.getElementById('here').dispatchEvent(event);

    assert.equal(event.defaultPrevented, true);
    assert.equal(scrolled, 1);
    assert.equal(document.getElementById('entity-sheet-body').children.length, 0);
});

test('a monster card offers "In den Kampf" and adds the foe', async () => {
    const { document, window, fetch } = await openPlay({ 'POST /dm/campaign/4/foes': { added: true } });

    document.getElementById('monster').dispatchEvent(clickEvent(window));
    const button = document.querySelector('#entity-sheet-body button');
    assert.equal(button.textContent, 'In den Kampf');

    click(button);
    await flush();
    assert.deepEqual(fetch.calls[0].body, { bestiary_id: '3', count: 1 });
});

test('typed hit points are saved, shown in the bar and clamped to the maximum', async () => {
    const { document, fetch } = await openPlay({ 'POST /dm/campaign/4/foes/11': { saved: true } });
    const foe = document.querySelector('[data-foe]');
    const input = foe.querySelector('[data-foe-hp-input]');

    change(input, '0');
    await flush();
    assert.equal(foe.querySelector('.ui-bar__label').textContent, 'TP 0/9');
    assert.equal(foe.querySelector('[data-foe-down]').hidden, false);
    assert.equal(foe.classList.contains('is-down'), true);
    assert.equal(fetch.calls.at(-1).body.hp_current, 0);

    change(input, '23');
    await flush();
    assert.equal(input.value, '9');
    assert.equal(fetch.calls.at(-1).body.hp_current, 9);
    assert.equal(foe.classList.contains('is-down'), false);
});

test('the foe search narrows the list while typing', async () => {
    const { document } = await openPlay();
    const options = Array.from(document.querySelectorAll('#foe-list [data-id]'));
    const search = document.getElementById('foe-search');

    type(search, 'tier');
    assert.deepEqual(
        options.map((o) => o.hidden),
        [false, false, true]
    );
    type(search, 'tier wolf');
    assert.deepEqual(
        options.map((o) => o.hidden),
        [false, true, true]
    );
    type(search, 'drache');
    assert.equal(document.getElementById('foe-empty').hidden, false);
});

test('the tools menu closes after a pick and after a click outside', async () => {
    const { document } = await openPlay();
    const menu = document.querySelector('.menu');

    assert.equal(menu.hasAttribute('open'), true);
    click(document.getElementById('pick'));
    assert.equal(menu.hasAttribute('open'), false);

    menu.setAttribute('open', '');
    click(document.getElementById('outside'));
    assert.equal(menu.hasAttribute('open'), false);
});
