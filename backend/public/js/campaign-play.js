/*
 * Campaign play view: index, entity dialog, foes, tools and chronicle.
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

    // Places are read in the chapter text: scroll there instead of opening a dialog
    function scrollToPlace(id) {
        const target = document.getElementById('location-' + id);
        if (!target) {
            return false;
        }
        if (sheet && sheet.open) {
            sheet.close();
        }
        target.scrollIntoView({ block: 'start' });
        return true;
    }

    function openFoes() {
        const panel = document.getElementById('foes');
        if (panel) {
            panel.hidden = false;
        }
    }

    async function addFoe(bestiaryId, count) {
        try {
            await sendJson('POST', base + '/foes', { bestiary_id: bestiaryId, count: count });
            window.location.hash = 'gegner';
            window.location.reload();
        } catch (error) {
            toastError(error);
        }
    }

    document.addEventListener('click', function (event) {
        const ref = event.target.closest('.location-ref');
        if (ref && scrollToPlace(ref.getAttribute('href').replace('#location-', ''))) {
            event.preventDefault();
            return;
        }
        const link = event.target.closest('.entity-link');
        if (!link) {
            return;
        }
        if (link.dataset.entityType === 'place') {
            if (scrollToPlace(link.dataset.entityId)) {
                event.preventDefault();
                return;
            }
            if (link.getAttribute('href') !== '#') {
                return;
            }
        }
        const template = document.getElementById('tpl-' + link.dataset.entityType + '-' + link.dataset.entityId);
        if (!template) {
            return;
        }
        event.preventDefault();
        sheetBody.replaceChildren(template.content.cloneNode(true));
        if (template.dataset.bestiaryId) {
            const button = document.createElement('button');
            button.type = 'button';
            button.className = 'ui-btn ui-btn--gold ui-btn--small';
            button.textContent = 'In den Kampf';
            button.addEventListener('click', function () {
                addFoe(template.dataset.bestiaryId, 1);
            });
            sheetBody.appendChild(button);
        }
        if (!sheet.open) {
            sheet.showModal();
        }
    });

    // ---- Panels: foes (bottom) and tools (right); the hash keeps them open across a reload
    const foesPanel = document.getElementById('foes');
    const toolsPanel = document.getElementById('tools');
    if (window.location.hash === '#gegner') {
        openFoes();
    } else if (window.location.hash === '#werkzeuge' && toolsPanel) {
        toolsPanel.hidden = false;
    }
    document.querySelector('[data-foes-open]')?.addEventListener('click', function () {
        foesPanel.hidden = !foesPanel.hidden;
    });
    document.querySelector('[data-foes-close]')?.addEventListener('click', function () {
        foesPanel.hidden = true;
    });
    document.querySelector('[data-tools-open]')?.addEventListener('click', function () {
        toolsPanel.hidden = !toolsPanel.hidden;
    });
    document.querySelector('[data-tools-close]')?.addEventListener('click', function () {
        toolsPanel.hidden = true;
    });
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            if (foesPanel) {
                foesPanel.hidden = true;
            }
            if (toolsPanel) {
                toolsPanel.hidden = true;
            }
        }
    });

    // ---- Foes: hit points typed in with -1/+1, adding with a search that narrows as you type
    document.addEventListener('click', async function (event) {
        const step = event.target.closest('[data-foe-hp]');
        if (!step) {
            return;
        }
        const foe = step.closest('[data-foe]');
        const bar = foe.querySelector('[data-foe-bar]');
        const max = parseInt(foe.dataset.foeMax, 10);
        const hp = Math.max(0, Math.min(max, parseInt(bar.dataset.hp, 10) + parseInt(step.dataset.foeHp, 10)));
        try {
            await sendJson('POST', base + '/foes/' + foe.dataset.foeId, { hp_current: hp });
        } catch (error) {
            toastError(error);
            return;
        }
        bar.dataset.hp = String(hp);
        bar.setAttribute('aria-valuenow', String(hp));
        bar.querySelector('.ui-bar__fill').style.width = (max > 0 ? Math.round((hp / max) * 100) : 0) + '%';
        bar.querySelector('.ui-bar__label').textContent = 'TP ' + hp + '/' + max;
        foe.classList.toggle('is-down', hp === 0);
        foe.querySelector('[data-foe-down]').hidden = hp > 0;
    });

    const foeSearch = document.getElementById('foe-search');
    const foeList = document.getElementById('foe-list');
    if (foeSearch && foeList) {
        const options = Array.from(foeList.querySelectorAll('[data-id]'));
        const foeEmpty = document.getElementById('foe-empty');
        const count = document.getElementById('foe-count');
        foeSearch.addEventListener('input', function () {
            const terms = foeSearch.value.trim().toLowerCase().split(/\s+/).filter(Boolean);
            options.forEach(function (option) {
                option.hidden = !terms.every(function (term) {
                    return option.dataset.search.includes(term);
                });
            });
            foeEmpty.hidden = options.some(function (option) {
                return !option.hidden;
            });
        });
        foeList.addEventListener('click', function (event) {
            const option = event.target.closest('[data-id]');
            if (option) {
                addFoe(option.dataset.id, parseInt(count.value, 10) || 1);
            }
        });
    }

    // ---- Current place and chapter of the group
    document.addEventListener('click', async function (event) {
        const move = event.target.closest('[data-move-place]');
        const current = event.target.closest('[data-set-current]');
        if (!move && !current) {
            return;
        }
        try {
            if (move) {
                await sendJson('POST', move.dataset.url, { place_id: move.dataset.movePlace, note: true });
                window.location.href = base + '/play#location-' + move.dataset.movePlace;
            } else {
                await sendJson('POST', current.dataset.url, { chapter_id: current.dataset.chapterId });
                window.location.reload();
            }
        } catch (error) {
            toastError(error);
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
                window.location.hash = 'werkzeuge';
                window.location.reload();
            } catch (error) {
                toastError(error);
            }
        });
    }

    // ---- Suggestions from the roll tables: the app picks a row, the DM takes it or drops it
    const dataNode = document.getElementById('play-data');
    const tools = dataNode ? JSON.parse(dataNode.textContent) : { tables: [], npc: [], encounters: {} };
    const pick = function (rows) {
        return rows[Math.floor(Math.random() * rows.length)];
    };
    const saveToChronicle = async function (text) {
        try {
            await sendJson('POST', base + '/chronicle', { text_de: text });
            window.location.hash = 'werkzeuge';
            window.location.reload();
        } catch (error) {
            toastError(error);
        }
    };

    const suggest = document.querySelector('[data-suggest]');
    if (suggest) {
        const select = suggest.querySelector('[data-suggest-table]');
        const result = suggest.querySelector('[data-suggest-result]');
        const text = suggest.querySelector('[data-suggest-text]');
        suggest.querySelector('[data-suggest-go]').addEventListener('click', function () {
            const key = select.value;
            const table =
                key.indexOf('enc-') === 0 ? tools.encounters[key.slice(4)] : tools.tables.find((t) => t.code === key);
            if (!table || !table.rows.length) {
                return;
            }
            text.textContent = table.title + ': ' + pick(table.rows).text;
            result.hidden = false;
        });
        suggest.querySelector('[data-suggest-drop]').addEventListener('click', function () {
            result.hidden = true;
        });
        suggest.querySelector('[data-suggest-take]').addEventListener('click', function () {
            saveToChronicle(text.textContent);
        });
    }

    const generator = document.querySelector('[data-npc-generator]');
    if (generator) {
        const result = generator.querySelector('[data-npc-result]');
        const name = generator.querySelector('[data-npc-name]');
        const description = generator.querySelector('[data-npc-description]');
        generator.querySelector('[data-npc-go]').addEventListener('click', function () {
            const rows = {};
            tools.npc.forEach(function (table) {
                rows[table.code] = table.rows.length ? pick(table.rows).text : '';
            });
            name.value = rows.nsc_name || '';
            description.value = [
                'Volk: ' + rows.nsc_volk,
                'Beruf: ' + rows.nsc_beruf,
                'Haltung: ' + rows.nsc_haltung,
                'Motivation: ' + rows.nsc_motivation,
                'Eigenart: ' + rows.nsc_eigenart,
            ].join('\n');
            result.hidden = false;
        });
        generator.querySelector('[data-npc-drop]').addEventListener('click', function () {
            result.hidden = true;
        });
        generator.querySelector('[data-npc-save]').addEventListener('click', async function () {
            try {
                await sendJson('POST', base + '/npcs', { name_de: name.value, description_de: description.value });
                result.hidden = true;
                window.ui.toast('NSC gespeichert');
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
