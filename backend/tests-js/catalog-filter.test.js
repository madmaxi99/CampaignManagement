import { test } from 'node:test';
import assert from 'node:assert/strict';
import { loadPage, type } from './helpers/browser.js';

const HTML = `
<input data-catalog-filter>
<div data-catalog-items>
    <a class="outline__item" href="/a"><span>Bär</span></a>
    <a class="outline__item" href="/b" aria-current="page"><span>Wolf</span></a>
    <a class="outline__item" href="/c"><span>Wolfsrudel</span></a>
    <p data-catalog-empty hidden>Nichts gefunden.</p>
</div>`;

test('filters the entries by text and shows a note when nothing is left', async () => {
    const { document } = await loadPage('catalog-filter.js', { html: HTML });
    const items = Array.from(document.querySelectorAll('.outline__item'));
    const empty = document.querySelector('[data-catalog-empty]');

    type(document.querySelector('[data-catalog-filter]'), 'wolf');
    assert.deepEqual(
        items.map((item) => item.hidden),
        [true, false, false]
    );
    assert.equal(empty.hidden, true);

    type(document.querySelector('[data-catalog-filter]'), 'drache');
    assert.ok(items.every((item) => item.hidden));
    assert.equal(empty.hidden, false);

    type(document.querySelector('[data-catalog-filter]'), '');
    assert.ok(items.every((item) => !item.hidden));
    assert.equal(empty.hidden, true);
});
