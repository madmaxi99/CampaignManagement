import { test } from 'node:test';
import assert from 'node:assert/strict';
import { loadPage, type, click, fakeFetch, flush } from './helpers/browser.js';

const OVERVIEW = `
<div data-merchant>
    <input data-merchant-search>
    <button data-merchant-open>Alle aufklappen</button>
    <button data-merchant-close>Alle zuklappen</button>
    <details data-merchant-group open>
        <summary>Macken <span data-merchant-count>2</span></summary>
        <table><tbody>
            <tr data-merchant-row><td>Flüstert alles</td></tr>
            <tr data-merchant-row><td>Zählt Münzen dreimal</td></tr>
        </tbody></table>
    </details>
    <details data-merchant-group>
        <summary>Waffen <span data-merchant-count>2</span></summary>
        <table><tbody>
            <tr data-merchant-row><td>Dolch</td></tr>
            <tr data-merchant-row><td>Langschwert</td></tr>
        </tbody></table>
    </details>
    <p data-merchant-empty hidden>Nichts gefunden.</p>
</div>`;

test('search hides rows and lists without a match and opens the lists that match', async () => {
    const { document } = await loadPage('merchant.js', { html: OVERVIEW });
    const [quirks, weapons] = document.querySelectorAll('[data-merchant-group]');

    type(document.querySelector('[data-merchant-search]'), 'dolch');
    assert.equal(quirks.hidden, true);
    assert.equal(weapons.hidden, false);
    assert.equal(weapons.open, true);
    assert.equal(weapons.querySelector('[data-merchant-count]').textContent, '1');
    assert.equal(document.querySelector('[data-merchant-empty]').hidden, true);

    type(document.querySelector('[data-merchant-search]'), 'drache');
    assert.equal(document.querySelector('[data-merchant-empty]').hidden, false);

    type(document.querySelector('[data-merchant-search]'), '');
    assert.equal(quirks.hidden, false);
    assert.equal(weapons.querySelector('[data-merchant-count]').textContent, '2');
});

test('open all and close all toggle every list', async () => {
    const { document } = await loadPage('merchant.js', { html: OVERVIEW });
    const groups = Array.from(document.querySelectorAll('[data-merchant-group]'));

    click(document.querySelector('[data-merchant-open]'));
    assert.ok(groups.every((group) => group.open));
    click(document.querySelector('[data-merchant-close]'));
    assert.ok(groups.every((group) => !group.open));
});

test('the dialog loads the overview once, when it is opened for the first time', async () => {
    const fetch = fakeFetch({ 'GET /dm/merchant': { text: OVERVIEW } });
    const html = `
        <button data-ui-open="#merchant">Händler</button>
        <dialog id="merchant"><div data-merchant-src="/dm/merchant">Lädt …</div></dialog>`;
    const { document } = await loadPage('merchant.js', { html, fetch });

    click(document.querySelector('[data-ui-open]'));
    await flush();
    assert.ok(document.querySelector('#merchant [data-merchant-search]'));

    click(document.querySelector('[data-ui-open]'));
    assert.equal(fetch.calls.length, 1);
});
