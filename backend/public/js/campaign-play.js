/*
 * Campaign play mode: quick access, entity dialog, encounter tables and chronicle.
 */
import { sendJson, toastError } from './lib/http.js';

const page = document.querySelector('[data-campaign-id]');
if (page) {
    init(page);
}

function init(root) {
    const base = '/dm/campaign/' + root.dataset.campaignId;

    // ---- Encounter tables: type in the roll made at the table, the matching row lights up
    function wireTable(table) {
        const input = table.querySelector('[data-roll-input]');
        const entries = Array.from(table.querySelectorAll('.event-entry'));
        if (!input) {
            return;
        }

        input.addEventListener('input', function () {
            const roll = parseInt(input.value, 10);
            entries.forEach(function (entry) {
                const min = parseInt(entry.dataset.min, 10);
                const max = parseInt(entry.dataset.max, 10);
                const open = entry.dataset.openEnded === '1';
                entry.classList.toggle('rolled', open ? roll >= min : roll >= min && roll <= max);
            });
        });
    }

    document.querySelectorAll('[data-event-table]').forEach(wireTable);

    // ---- Entity dialog (NPC, place, item, monster), also opened from links in texts
    const sheet = document.getElementById('entity-sheet');
    const sheetBody = document.getElementById('entity-sheet-body');

    document.addEventListener('click', function (event) {
        const link = event.target.closest('.entity-link');
        if (!link) {
            return;
        }
        event.preventDefault();
        const template = document.getElementById('tpl-' + link.dataset.entityType + '-' + link.dataset.entityId);
        if (!template) {
            return;
        }
        sheetBody.replaceChildren(template.content.cloneNode(true));
        sheetBody.querySelectorAll('[data-event-table]').forEach(wireTable);
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
