import { test } from 'node:test';
import assert from 'node:assert/strict';
import { click, loadPage } from './helpers/browser.js';

async function open(html) {
    return loadPage('ui.js', {
        html,
        beforeLoad: (win) => {
            // jsdom has no modal dialogs: showModal/close only toggle the open attribute
            win.HTMLDialogElement.prototype.showModal = function () {
                this.setAttribute('open', '');
            };
            win.HTMLDialogElement.prototype.close = function () {
                this.removeAttribute('open');
            };
        },
    });
}

test('a click on a place image shows it large in a dialog, a click on the dialog closes it', async () => {
    const { document } = await open('<img class="place-image" src="/images/places/64.png" alt="Karte">');

    click(document.querySelector('img.place-image'));

    const lightbox = document.querySelector('dialog.image-lightbox');
    assert.ok(lightbox.hasAttribute('open'));
    assert.match(lightbox.querySelector('img').src, /images\/places\/64\.png$/);
    assert.equal(lightbox.querySelector('img').alt, 'Karte');

    click(lightbox);
    assert.equal(lightbox.hasAttribute('open'), false);
});

test('other images are left alone', async () => {
    const { document } = await open('<img class="ui-avatar" src="/a.png" alt="">');

    click(document.querySelector('img'));

    assert.equal(document.querySelector('dialog.image-lightbox'), null);
});
