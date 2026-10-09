import { test } from 'node:test';
import assert from 'node:assert/strict';
import { click, loadPage, type } from './helpers/browser.js';

const card = (id, name, extra = '') =>
    `<li class="char-card" data-char-id="${id}" data-name="${name}" data-search="${name.toLowerCase()}" ${extra}><button data-pin></button></li>`;

const HTML = `
<ul data-mine></ul><p data-mine-empty hidden>nichts</p>
<input id="char-search">
<button data-filter-value="all" aria-selected="true">Alle</button>
<button data-filter-value="default" aria-selected="false">Vorgefertigt</button>
<ul data-archive>
    ${card(1, 'Berta', 'data-default="1"')}${card(2, 'Anton', 'data-default="0"')}${card(3, 'Cäsar', 'data-default="0"')}
</ul>
<p data-archive-empty hidden>leer</p>`;

const names = (list) => Array.from(list.children).map((item) => item.dataset.name);

test('shows remembered characters on top, sorted by name', async () => {
    const { document, window } = await prepare(['3', '1']);

    assert.deepEqual(names(document.querySelector('[data-mine]')), ['Berta', 'Cäsar']);
    assert.deepEqual(names(document.querySelector('[data-archive]')), ['Anton']);
    assert.equal(window.localStorage.getItem('trpg.myCharacters'), '["3","1"]');
});

test('pinning moves a card up and remembers it', async () => {
    const { document, window } = await prepare([]);
    const pin = document.querySelector('[data-char-id="2"] [data-pin]');

    click(pin);

    assert.deepEqual(names(document.querySelector('[data-mine]')), ['Anton']);
    assert.equal(pin.getAttribute('aria-pressed'), 'true');
    assert.deepEqual(JSON.parse(window.localStorage.getItem('trpg.myCharacters')), ['2']);

    click(pin);
    assert.deepEqual(names(document.querySelector('[data-mine]')), []);
    assert.equal(document.querySelector('[data-mine-empty]').hidden, false);
});

test('search and filter only affect the archive', async () => {
    const { document } = await prepare([]);
    const hidden = () =>
        Array.from(document.querySelectorAll('.char-card'))
            .filter((item) => item.hidden)
            .map((item) => item.dataset.name);

    type(document.getElementById('char-search'), 'ber');
    assert.deepEqual(hidden(), ['Anton', 'Cäsar']);

    type(document.getElementById('char-search'), 'zzz');
    assert.equal(document.querySelector('[data-archive-empty]').hidden, false);

    type(document.getElementById('char-search'), '');
    click(document.querySelector('[data-filter-value="default"]'));
    assert.deepEqual(hidden(), ['Anton', 'Cäsar']);
});

function prepare(mine) {
    return loadPage('characters-list.js', {
        html: HTML,
        beforeLoad: (window) => window.localStorage.setItem('trpg.myCharacters', JSON.stringify(mine)),
    });
}
