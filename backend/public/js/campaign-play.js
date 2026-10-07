/*
 * Campaign play mode: quick access, entity dialog, dice, encounter tables and chronicle.
 */
import { sendJson, toastError } from './lib/http.js';

const page = document.querySelector('[data-campaign-id]');
if (page) {
    init(page);
}

function init(root) {
    const base = '/dm/campaign/' + root.dataset.campaignId;

    // ---- Encounter tables: roll the smallest standard die that covers the table
    const STANDARD_DICE = [4, 6, 8, 10, 12, 20, 100];

    function wireTable(table) {
        const button = table.querySelector('[data-roll-button]');
        const label = table.querySelector('[data-roll-result]');
        const entries = Array.from(table.querySelectorAll('.event-entry'));
        if (!button) {
            return;
        }

        const top = Math.max.apply(
            null,
            entries.map(function (entry) {
                return parseInt(entry.dataset.max, 10);
            })
        );
        const die =
            STANDARD_DICE.find(function (size) {
                return size >= top;
            }) || top;

        button.addEventListener('click', function () {
            const roll = Math.floor(Math.random() * die) + 1;
            label.textContent = 'W' + die + ': ' + roll;
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

    // ---- Dice
    const result = document.querySelector('[data-dice-result]');
    const history = document.querySelector('[data-dice-history]');
    const rolls = [];
    document.querySelectorAll('[data-die]').forEach(function (button) {
        button.addEventListener('click', function () {
            const die = parseInt(button.dataset.die, 10);
            const roll = Math.floor(Math.random() * die) + 1;
            result.textContent = String(roll);
            result.dataset.die = 'W' + die;
            rolls.unshift('W' + die + ': ' + roll);
            history.textContent = 'Zuletzt: ' + rolls.slice(0, 6).join(' · ');
        });
    });

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
