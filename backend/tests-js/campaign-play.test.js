import { test } from 'node:test';
import assert from 'node:assert/strict';
import { loadPage } from './helpers/browser.js';

const HTML = `
<div data-campaign-id="4">
    <a class="entity-link" id="with-text" href="#" data-entity-type="place" data-entity-id="7">Torhaus</a>
    <a class="entity-link" id="without-text" href="#" data-entity-type="place" data-entity-id="8">Leer</a>
    <button id="tab-read" aria-selected="false">Lesen</button>
    <article id="location-7">Torhaus</article>
</div>
<template id="tpl-place-8"><p>Leer</p></template>
<dialog id="entity-sheet"><div id="entity-sheet-body"></div></dialog>
<dialog id="chronicle-sheet"><form id="chronicle-edit-form"></form></dialog>`;

test('a place link switches to the Lesen tab and scrolls to the place instead of opening a dialog', async () => {
    const { document, window } = await loadPage('campaign-play.js', { html: HTML });
    let scrolled = 0;
    document.getElementById('location-7').scrollIntoView = () => {
        scrolled += 1;
    };
    let tabClicks = 0;
    document.getElementById('tab-read').addEventListener('click', () => {
        tabClicks += 1;
    });

    const click = new window.MouseEvent('click', { bubbles: true, cancelable: true });
    document.getElementById('with-text').dispatchEvent(click);

    assert.equal(click.defaultPrevented, true);
    assert.equal(tabClicks, 1);
    assert.equal(scrolled, 1);
    assert.equal(document.getElementById('entity-sheet-body').children.length, 0);
});
