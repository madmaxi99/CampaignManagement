import { test } from 'node:test';
import assert from 'node:assert/strict';
import { click, fakeFetch, flush, loadPage, type } from './helpers/browser.js';

const HTML = `
<div data-campaign-id="4">
    <input id="quick-search">
    <a class="entity-link" id="here" href="/dm/campaign/4/play/chapter/1#location-7" data-entity-type="place" data-entity-id="7">Torhaus</a>
    <a class="entity-link" id="elsewhere" href="/dm/campaign/4/play/chapter/2#location-9" data-entity-type="place" data-entity-id="9">Keller</a>
    <a class="entity-link" id="monster" href="#" data-entity-type="bestiary" data-entity-id="3">Wolf</a>
    <article id="location-7">Torhaus</article>
    <section id="foes" hidden>
        <article data-foe data-foe-id="11" data-foe-max="9" class="foe">
            <button data-foe-hp="-1">-1</button><button data-foe-hp="1">+1</button>
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
    </section>
    <button data-foes-open>Gegner</button>
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

test('a place of this chapter scrolls into view instead of opening a dialog', async () => {
    const { document, window } = await openPlay();
    let scrolled = 0;
    document.getElementById('location-7').scrollIntoView = () => (scrolled += 1);

    const event = clickEvent(window);
    document.getElementById('here').dispatchEvent(event);

    assert.equal(event.defaultPrevented, true);
    assert.equal(scrolled, 1);
    assert.equal(document.getElementById('entity-sheet-body').children.length, 0);
});

test('a place of another chapter is left to the link, which opens that chapter', async () => {
    const { document, window } = await openPlay();

    const event = clickEvent(window);
    document.getElementById('elsewhere').dispatchEvent(event);

    assert.equal(event.defaultPrevented, false);
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

test('the hit point counter changes in place and stops at zero', async () => {
    const { document, fetch } = await openPlay({ 'POST /dm/campaign/4/foes/11': { saved: true } });
    const foe = document.querySelector('[data-foe]');
    const minus = foe.querySelector('[data-foe-hp="-1"]');

    for (let i = 0; i < 10; i += 1) {
        click(minus);
        await flush();
    }

    assert.equal(foe.querySelector('.ui-bar__label').textContent, 'TP 0/9');
    assert.equal(foe.querySelector('[data-foe-down]').hidden, false);
    assert.equal(foe.classList.contains('is-down'), true);
    assert.equal(fetch.calls.at(-1).body.hp_current, 0);
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

test('the Gegner button opens and closes the panel', async () => {
    const { document } = await openPlay();
    const panel = document.getElementById('foes');

    click(document.querySelector('[data-foes-open]'));
    assert.equal(panel.hidden, false);
    click(document.querySelector('[data-foes-open]'));
    assert.equal(panel.hidden, true);
});
