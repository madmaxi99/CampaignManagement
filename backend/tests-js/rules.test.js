import { test } from 'node:test';
import assert from 'node:assert/strict';
import { loadPage, type } from './helpers/browser.js';

const HTML = `
<input id="rules-search">
<div class="ui-tabs">
    <button class="ui-tab" id="tab-a" aria-controls="panel-a">A</button>
    <button class="ui-tab" id="tab-b" aria-controls="panel-b">B</button>
</div>
<div class="ui-tabpanel" id="panel-a">
    <h2>Würfel</h2>
    <details data-search="fertigkeitsprobe würfle einen w20 für märchen"><summary>Probe</summary></details>
    <details data-search="drache dämon w20"><summary>Drache</summary></details>
    <h2>Zustände</h2>
    <details data-search="erschöpft nachteil"><summary>Erschöpft</summary></details>
</div>
<div class="ui-tabpanel" id="panel-b" hidden>
    <h2>Waffen</h2>
    <details data-search="schwert schaden"><summary>Schwert</summary></details>
</div>
<div data-rules-empty hidden>Nichts gefunden.</div>`;

function state(document) {
    const entries = Array.from(document.querySelectorAll('[data-search]')).map((entry) => entry.hidden);
    const headings = Array.from(document.querySelectorAll('h2')).map((heading) => heading.hidden);
    const badges = Array.from(document.querySelectorAll('.ui-tab')).map(
        (tab) => tab.querySelector('[data-rules-hits]')?.textContent ?? null
    );

    return { entries, headings, badges };
}

test('all words must match, umlauts are folded, headings and badges follow the hits', async () => {
    const { document } = await loadPage('rules.js', { html: HTML });
    const input = document.getElementById('rules-search');

    type(input, 'W20 maerchen');
    assert.deepEqual(state(document), {
        entries: [false, true, true, true],
        headings: [false, true, true],
        badges: ['1', '0'],
    });

    type(input, 'schaden');
    assert.deepEqual(state(document).badges, ['0', '1']);
    assert.equal(document.querySelector('[data-rules-empty]').hidden, false, 'open tab has no hit');

    type(input, '');
    assert.deepEqual(state(document), {
        entries: [false, false, false, false],
        headings: [false, false, false],
        badges: [null, null],
    });
    assert.equal(document.querySelector('[data-rules-empty]').hidden, true);
});

test('a short hit list is opened and closed again when the search is cleared', async () => {
    const { document } = await loadPage('rules.js', { html: HTML });
    const input = document.getElementById('rules-search');
    const probe = document.querySelector('details');

    type(input, 'w20');
    assert.equal(probe.open, true);

    type(input, '');
    assert.equal(probe.open, false);
});
