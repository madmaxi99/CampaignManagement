/*
 * Character sheet: vitals, conditions, skill marks, free-text gear rows,
 * coins, "Gedächtnis" and the detail sheet. Edits save immediately (toast),
 * only adding or removing a row reloads the page.
 */
import { sendJson, toastError } from './lib/http.js';
import { forget } from './lib/my-characters.js';

const page = document.querySelector('.sheet');
if (page) {
    init(page);
}

function init(sheet) {
    const id = sheet.dataset.id;

    function saved() {
        window.ui.toast('Gespeichert');
    }

    // ---- Vitals: − / + around a bar
    const renderVital = {};
    document.querySelectorAll('[data-vital]').forEach(function (vital) {
        const key = vital.dataset.vital;
        const bar = vital.querySelector('.ui-bar');
        const fill = vital.querySelector('.ui-bar__fill');
        const label = vital.querySelector('.ui-bar__label');
        const max = parseInt(vital.dataset.max, 10);

        function render(current) {
            vital.dataset.current = String(current);
            fill.style.width = (max > 0 ? Math.round((current / max) * 100) : 0) + '%';
            label.textContent = current + ' / ' + max;
            bar.setAttribute('aria-valuenow', String(current));
        }

        renderVital[key] = render;

        vital.querySelectorAll('[data-vital-step]').forEach(function (button) {
            button.addEventListener('click', function () {
                const current = parseInt(vital.dataset.current, 10);
                const next = Math.min(max, Math.max(0, current + parseInt(button.dataset.vitalStep, 10)));
                if (next === current) {
                    return;
                }
                render(next); // optimistic, corrected by the server answer
                sendJson('POST', '/character/' + id + '/' + key, { value: next })
                    .then(function (data) {
                        render(data[key + '_current']);
                    })
                    .catch(function (error) {
                        render(current);
                        toastError(error);
                    });
            });
        });
    });

    // ---- Conditions
    document.querySelectorAll('[data-condition]').forEach(function (chip) {
        chip.addEventListener('click', function () {
            sendJson('POST', '/character/' + id + '/conditions/' + chip.dataset.condition + '/toggle', {})
                .then(function (data) {
                    chip.setAttribute('aria-pressed', data.active ? 'true' : 'false');
                })
                .catch(toastError);
        });
    });

    // ---- Rest: the server rolls the dice and answers with the new values
    const restSheet = document.querySelector('[data-rest-sheet]');
    if (restSheet) {
        restSheet.querySelectorAll('[data-rest]').forEach(function (button) {
            button.addEventListener('click', function () {
                const type = button.dataset.rest;
                const body = { type };
                if (type === 'short') {
                    body.tended = restSheet.querySelector('[data-rest-tended]').checked;
                    body.condition = restSheet.querySelector('[data-rest-condition]').value;
                }
                sendJson('POST', '/character/' + id + '/rest', body)
                    .then(function (data) {
                        ['hp', 'wp'].forEach(function (key) {
                            renderVital[key](data[key + '_current']);
                        });
                        data.cleared.forEach(function (code) {
                            const chip = document.querySelector('[data-condition="' + code + '"]');
                            if (chip) {
                                chip.setAttribute('aria-pressed', 'false');
                            }
                        });
                        if (typeof restSheet.close === 'function') {
                            restSheet.close();
                        }
                        window.ui.toast(
                            '+' +
                                data.hp_gain +
                                ' TP, +' +
                                data.wp_gain +
                                ' WP' +
                                (data.cleared.length > 0 ? ', ' + data.cleared.length + ' Zustand geheilt' : '')
                        );
                    })
                    .catch(toastError);
            });
        });
    }

    // ---- Skill advancement marks
    document.querySelectorAll('[data-skill-mark]').forEach(function (box) {
        box.addEventListener('change', function () {
            sendJson('POST', '/character/' + id + '/skills/' + box.dataset.skillMark + '/mark', {
                marked: box.checked,
            }).catch(function (error) {
                box.checked = !box.checked;
                toastError(error);
            });
        });
    });

    // ---- Detail sheet (skills and spells)
    const detailSheet = document.getElementById('detail-sheet');
    const detailBody = document.getElementById('detail-sheet-body');

    function node(tag, text, className) {
        const element = document.createElement(tag);
        element.textContent = text;
        if (className) {
            element.className = className;
        }

        return element;
    }

    function fact(label, value) {
        const row = node('p', '');
        row.appendChild(node('strong', label + ': '));
        row.appendChild(document.createTextNode(value));

        return row;
    }

    const CATEGORIES = { regular: 'Fertigkeit', combat: 'Kampffertigkeit', secondary: 'Sekundäre Fertigkeit' };

    function showDetail(detail) {
        detailBody.replaceChildren(node('h2', detail.name));
        if (detail.type === 'spell') {
            [
                ['Vorgabe', detail.components],
                ['Zauberdauer', detail.castingTime],
                ['Reichweite', detail.range],
                ['Wirkungsdauer', detail.duration],
                ['Kosten', detail.wpNote],
            ].forEach(function (pair) {
                if (pair[1]) {
                    detailBody.appendChild(fact(pair[0], pair[1]));
                }
            });
            detailBody.appendChild(node('p', detail.effect));
        } else {
            detailBody.appendChild(fact('Art', CATEGORIES[detail.category] || detail.category));
            detailBody.appendChild(fact('Attribut', detail.attribute));
            detailBody.appendChild(fact('Wert', String(detail.value)));
        }
        detailSheet.showModal();
    }

    document.querySelectorAll('[data-detail]').forEach(function (button) {
        button.addEventListener('click', function () {
            showDetail(JSON.parse(button.dataset.detail));
        });
    });

    // ---- Free-text gear fields (weapons, armor, inventory): save on change
    document.querySelectorAll('[data-segment][data-field]').forEach(function (input) {
        input.addEventListener('change', function () {
            let value;
            if (input.type === 'checkbox') {
                value = input.checked;
            } else if (input.type === 'number') {
                value = input.value === '' ? null : parseInt(input.value, 10);
            } else {
                value = input.value;
            }
            const url =
                input.dataset.segment === 'armor'
                    ? '/character/' + id + '/armor/' + input.dataset.slot
                    : '/character/' + id + '/' + input.dataset.segment + '/' + input.dataset.rowId;

            const body = {};
            body[input.dataset.field] = value;
            sendJson('POST', url, body).then(saved).catch(toastError);

            // Keep the collapsed row's title in step with the name and quantity fields.
            const entry = input.closest('.gear-entry');
            if (entry && input.dataset.segment !== 'armor') {
                if (input.dataset.field === 'name_de') {
                    (entry.querySelector('.gear-name') ?? entry.querySelector('.ui-details__title')).textContent =
                        value;
                } else if (input.dataset.field === 'quantity') {
                    entry.querySelector('.gear-qty').textContent = (value ?? 0) + '×';
                }
            }
        });
    });

    document.querySelectorAll('[data-add]').forEach(function (button) {
        button.addEventListener('click', function () {
            sendJson('POST', '/character/' + id + '/' + button.dataset.add, {})
                .then(function () {
                    window.location.reload();
                })
                .catch(toastError);
        });
    });

    document.querySelectorAll('[data-remove]').forEach(function (button) {
        button.addEventListener('click', function () {
            sendJson('DELETE', '/character/' + id + '/' + button.dataset.remove + '/' + button.dataset.rowId)
                .then(function () {
                    window.location.reload();
                })
                .catch(toastError);
        });
    });

    // ---- Coins: one save for the three fields
    const coinInputs = Array.from(document.querySelectorAll('[data-coin]'));
    coinInputs.forEach(function (input) {
        input.addEventListener('change', function () {
            const body = {
                gold: parseInt(document.getElementById('coins-gold').value, 10) || 0,
                silver: parseInt(document.getElementById('coins-silver').value, 10) || 0,
                copper: parseInt(document.getElementById('coins-copper').value, 10) || 0,
            };
            sendJson('POST', '/character/' + id + '/currency', body)
                .then(saved)
                .catch(toastError);
        });
    });

    // ---- Gedächtnis: autosave while typing
    const memory = document.getElementById('memory-text');
    const memoryStatus = document.querySelector('[data-memory-status]');
    if (memory) {
        let timer = null;
        let lastSaved = memory.value;

        function saveMemory() {
            const text = memory.value;
            memoryStatus.textContent = 'Speichert …';
            sendJson('POST', '/character/' + id + '/memory', { text: text })
                .then(function () {
                    lastSaved = text;
                    memoryStatus.textContent = 'Alles gespeichert.';
                })
                .catch(function (error) {
                    memoryStatus.textContent = 'Noch nicht gespeichert – wird erneut versucht.';
                    toastError(error);
                });
        }

        memory.addEventListener('input', function () {
            memoryStatus.textContent = 'Änderungen …';
            window.clearTimeout(timer);
            timer = window.setTimeout(saveMemory, 800);
        });

        // Do not lose the last words when the page is left right away.
        window.addEventListener('pagehide', function () {
            if (memory.value !== lastSaved) {
                window.fetch('/character/' + id + '/memory', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ text: memory.value }),
                    keepalive: true,
                });
            }
        });
    }

    // ---- Portrait upload (only offered while there is none)
    const portraitInput = document.getElementById('portrait-input');
    if (portraitInput) {
        portraitInput.addEventListener('change', function () {
            if (!portraitInput.files[0]) {
                return;
            }
            const data = new FormData();
            data.append('portrait', portraitInput.files[0]);
            window
                .fetch('/character/' + id + '/portrait', { method: 'POST', body: data })
                .then(function (response) {
                    return response.json();
                })
                .then(function (result) {
                    if (result.error) {
                        toastError(new Error(result.error));

                        return;
                    }
                    window.location.reload();
                })
                .catch(toastError);
        });
    }

    // ---- Delete character (confirmed in the sheet)
    const deleteConfirm = document.querySelector('[data-delete-confirm]');
    if (deleteConfirm) {
        deleteConfirm.addEventListener('click', function () {
            sendJson('DELETE', '/character/' + id)
                .then(function () {
                    forget(id);
                    window.location.href = '/characters';
                })
                .catch(toastError);
        });
    }
}
