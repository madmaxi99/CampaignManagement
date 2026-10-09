/*
 * Campaign play mode: quick access, entity dialog and chronicle.
 */
import { sendJson, toastError } from './lib/http.js';

const page = document.querySelector('[data-campaign-id]');
if (page) {
    init(page);
}

function init(root) {
    const base = '/dm/campaign/' + root.dataset.campaignId;

    // ---- Entity dialog (NPC, item, monster), also opened from links in texts
    const sheet = document.getElementById('entity-sheet');
    const sheetBody = document.getElementById('entity-sheet-body');

    // Places are read in the Lesen tab: switch to it and scroll to the place
    function jumpToPlace(id) {
        const target = document.getElementById('location-' + id);
        if (!target) {
            return false;
        }
        const readTab = document.getElementById('tab-read');
        if (readTab && readTab.getAttribute('aria-selected') !== 'true') {
            readTab.click();
        }
        if (sheet && sheet.open) {
            sheet.close();
        }
        target.scrollIntoView({ block: 'start' });
        return true;
    }

    document.addEventListener('click', function (event) {
        const ref = event.target.closest('.location-ref');
        if (ref && jumpToPlace(ref.getAttribute('href').replace('#location-', ''))) {
            event.preventDefault();
            return;
        }
        const link = event.target.closest('.entity-link');
        if (!link) {
            return;
        }
        if (link.dataset.entityType === 'place' && jumpToPlace(link.dataset.entityId)) {
            event.preventDefault();
            return;
        }
        const template = document.getElementById('tpl-' + link.dataset.entityType + '-' + link.dataset.entityId);
        if (!template) {
            return;
        }
        event.preventDefault();
        sheetBody.replaceChildren(template.content.cloneNode(true));
        if (!sheet.open) {
            sheet.showModal();
        }
    });

    // ---- Quick access search
    const search = document.getElementById('quick-search');
    if (search) {
        const groups = Array.from(document.querySelectorAll('[data-quick-group]'));
        const empty = document.querySelector('[data-quick-empty]');
        search.addEventListener('input', function () {
            const query = search.value.trim().toLowerCase();
            let visible = 0;
            groups.forEach(function (group) {
                let shown = 0;
                group.querySelectorAll('[data-quick-item]').forEach(function (item) {
                    const match = query === '' || item.dataset.quickItem.indexOf(query) !== -1;
                    item.hidden = !match;
                    shown += match ? 1 : 0;
                });
                group.hidden = shown === 0;
                visible += shown;
            });
            empty.hidden = visible > 0;
        });
    }

    // ---- Chronicle
    const form = document.querySelector('[data-chronicle-form]');
    if (form) {
        form.addEventListener('submit', async function (event) {
            event.preventDefault();
            try {
                await sendJson('POST', base + '/chronicle', {
                    title_de: form.elements.title_de.value,
                    text_de: form.elements.text_de.value,
                });
                window.location.href = base + '/play#chronicle';
                window.location.reload();
            } catch (error) {
                toastError(error);
            }
        });
    }

    const editSheet = document.getElementById('chronicle-sheet');
    const editForm = document.getElementById('chronicle-edit-form');
    let editingId = null;

    document.addEventListener('click', async function (event) {
        const entry = event.target.closest('[data-entry-id]');
        if (!entry) {
            return;
        }
        if (event.target.closest('[data-entry-edit]')) {
            editingId = entry.dataset.entryId;
            editForm.elements.title_de.value = entry.dataset.entryTitle || '';
            editForm.elements.text_de.value = entry.dataset.entryText || '';
            editSheet.showModal();
        } else if (event.target.closest('[data-entry-delete]')) {
            if (await window.ui.confirm('Diesen Eintrag löschen?', 'Ja, löschen')) {
                try {
                    await sendJson('DELETE', base + '/chronicle/' + entry.dataset.entryId);
                    window.location.reload();
                } catch (error) {
                    toastError(error);
                }
            }
        }
    });

    editForm.addEventListener('submit', async function (event) {
        event.preventDefault();
        try {
            await sendJson('POST', base + '/chronicle/' + editingId, {
                title_de: editForm.elements.title_de.value,
                text_de: editForm.elements.text_de.value,
            });
            window.location.reload();
        } catch (error) {
            toastError(error);
        }
    });
}
