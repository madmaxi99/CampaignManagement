import { test } from 'node:test';
import assert from 'node:assert/strict';
import { change, click, fakeFetch, flush, loadPage } from './helpers/browser.js';

async function open(html, routes = {}, options = {}) {
    const fetch = fakeFetch(routes);
    const page = await loadPage('dm-forms.js', { html, fetch, ...options });

    return { ...page, fetch };
}

function submit(document, form) {
    form.dispatchEvent(new document.defaultView.Event('submit', { bubbles: true, cancelable: true }));
}

test('sends a form as JSON, collecting [] fields into arrays', async () => {
    const { document, fetch, location } = await open(
        `<form data-dm-form data-action="/dm/things" data-after="goto:/dm/things/{id}">
            <input name="name_de" value="Turm">
            <input name="tags[]" value="a"><input name="tags[]" value="b">
            <button type="submit">Speichern</button>
        </form>`,
        { 'POST /dm/things': { id: 12 } }
    );

    submit(document, document.querySelector('form'));
    await flush();

    assert.deepEqual(fetch.calls, [{ method: 'POST', url: '/dm/things', body: { name_de: 'Turm', tags: ['a', 'b'] } }]);
    assert.equal(location.href, '/dm/things/12');
});

test('reports a server error and re-enables the form', async () => {
    const { document, toasts } = await open(
        `<form data-dm-form data-action="/dm/things"><input name="name_de" value=""><button type="submit">Speichern</button></form>`,
        { 'POST /dm/things': { status: 422, json: { error: 'Der Name fehlt.' } } }
    );

    submit(document, document.querySelector('form'));
    await flush();

    assert.deepEqual(toasts, [{ message: 'Der Name fehlt.', kind: 'error' }]);
    assert.equal(document.querySelector('button').disabled, false);
});

test('deletes only after confirmation', async () => {
    const html = `<button data-dm-delete data-url="/dm/things/3" data-after="goto:/dm">Löschen</button>`;

    const declined = await open(html, {}, { confirm: false });
    click(declined.document.querySelector('button'));
    await flush();
    assert.equal(declined.fetch.calls.length, 0);

    const accepted = await open(html, { 'DELETE /dm/things/3': {} });
    click(accepted.document.querySelector('button'));
    await flush();
    assert.deepEqual(accepted.fetch.calls, [{ method: 'DELETE', url: '/dm/things/3', body: undefined }]);
    assert.equal(accepted.location.href, '/dm');
});

test('adds and removes rows from a template', async () => {
    const { document } = await open(`
        <template id="tpl"><div data-row>neu <button data-row-remove>x</button></div></template>
        <div id="rows"></div>
        <button data-row-add data-template="#tpl" data-target="#rows">+</button>`);

    click(document.querySelector('[data-row-add]'));
    click(document.querySelector('[data-row-add]'));
    assert.equal(document.querySelectorAll('[data-row]').length, 2);

    click(document.querySelector('[data-row-remove]'));
    assert.equal(document.querySelectorAll('[data-row]').length, 1);
});

test('shows only the blocks that match the selected kind', async () => {
    const { document } = await open(`
        <form>
            <select data-switch><option value="weapon">w</option><option value="armor">a</option></select>
            <div data-kind="weapon">Waffe</div><div data-kind="armor">Rüstung</div>
        </form>`);
    const blocks = Array.from(document.querySelectorAll('[data-kind]'));

    assert.deepEqual(
        blocks.map((block) => block.hidden),
        [false, true]
    );

    change(document.querySelector('select'), 'armor');
    assert.deepEqual(
        blocks.map((block) => block.hidden),
        [true, false]
    );
});
