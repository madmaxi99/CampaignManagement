import { test } from 'node:test';
import assert from 'node:assert/strict';
import { change, click, fakeFetch, flush, loadPage } from './helpers/browser.js';

const HTML = `
<div class="levelup" data-id="5">
    <span data-pending-count hidden>0</span>
    <li class="levelup-item">
        <div class="segmented">
            <button data-decision="apply" data-skill-id="3" aria-pressed="false">Steigern</button>
            <button data-decision="discard" data-skill-id="3" aria-pressed="false">Verwerfen</button>
        </div>
    </li>
    <li>
        <select data-school-select><option value="">-</option><option value="30">Feuer</option></select>
        <button data-learn-ability="9">Lernen</button>
    </li>
    <li><button data-learn-spell="14">Lernen</button></li>
    <button id="levelup-save">Speichern</button>
</div>`;

async function openLevelup(routes = {}) {
    const fetch = fakeFetch(routes);
    const page = await loadPage('character-levelup.js', { html: HTML, fetch });

    return { ...page, fetch };
}

test('stages decisions locally and counts them', async () => {
    const { document, fetch } = await openLevelup();
    const counter = document.querySelector('[data-pending-count]');

    click(document.querySelector('[data-decision="apply"]'));
    click(document.querySelector('[data-learn-spell]'));

    assert.equal(counter.textContent, '2');
    assert.equal(counter.hidden, false);
    assert.equal(document.querySelector('[data-decision="apply"]').getAttribute('aria-pressed'), 'true');
    assert.equal(document.querySelector('[data-decision="discard"]').getAttribute('aria-pressed'), 'false');
    assert.equal(document.querySelector('[data-learn-spell]').disabled, true);
    assert.equal(fetch.calls.length, 0, 'nothing is sent before saving');
});

test('a changed mind counts once per skill', async () => {
    const { document } = await openLevelup();

    click(document.querySelector('[data-decision="apply"]'));
    click(document.querySelector('[data-decision="discard"]'));

    assert.equal(document.querySelector('[data-pending-count]').textContent, '1');
});

test('sends every staged decision on save and returns to the sheet', async () => {
    const { document, fetch, location } = await openLevelup();

    click(document.querySelector('[data-decision="discard"]'));
    change(document.querySelector('[data-school-select]'), '30');
    click(document.querySelector('[data-learn-ability]'));
    click(document.querySelector('[data-learn-spell]'));
    click(document.getElementById('levelup-save'));
    await flush();

    assert.deepEqual(fetch.calls, [
        { method: 'POST', url: '/character/5/skills/3/advance', body: { apply: false } },
        {
            method: 'POST',
            url: '/character/5/heroic-abilities',
            body: { heroic_ability_id: 9, school_skill_id: 30 },
        },
        { method: 'POST', url: '/character/5/spells', body: { spell_id: 14 } },
    ]);
    assert.equal(location.href, '/character/5');
});

test('stays on the page and shows an error when saving fails', async () => {
    const { document, toasts, location } = await openLevelup({ 'POST /character/5/spells': { status: 500 } });

    click(document.querySelector('[data-learn-spell]'));
    click(document.getElementById('levelup-save'));
    await flush();

    assert.equal(toasts.at(-1).kind, 'error');
    assert.equal(document.getElementById('levelup-save').disabled, false);
    assert.equal(location.href, 'http://localhost/');
});
