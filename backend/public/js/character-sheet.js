/*
 * Character sheet: vitals, conditions, skill marks, free-text gear rows,
 * coins, "Gedächtnis" and the detail sheet. Edits save immediately (toast),
 * only adding or removing a row reloads the page.
 */
(function () {
    'use strict';

    const sheet = document.querySelector('.sheet');
    if (!sheet) {
        return;
    }

    const id = sheet.dataset.id;

    function request(method, path, body) {
        const options = { method: method };
        if (body !== undefined) {
            options.headers = { 'Content-Type': 'application/json' };
            options.body = JSON.stringify(body);
        }

        return fetch(path, options).then(function (response) {
            if (!response.ok) {
                throw new Error('Speichern fehlgeschlagen.');
            }

            return response.status === 204 ? {} : response.json().catch(function () { return {}; });
        });
    }

    function saved() {
        window.ui.toast('Gespeichert');
    }

    function failed(error) {
        window.ui.toast(error && error.message ? error.message : 'Das hat nicht geklappt.', 'error');
    }

    // ---- Vitals: − / + around a bar
    document.querySelectorAll('[data-vital]').forEach(function (vital) {
        const key = vital.dataset.vital;
        const bar = vital.querySelector('.ui-bar');
        const fill = vital.querySelector('.ui-bar__fill');
        const label = vital.querySelector('.ui-bar__label');
        const max = parseInt(vital.dataset.max, 10);

        function render(current) {
            vital.dataset.current = String(current);
            fill.style.width = (max > 0 ? Math.round(current / max * 100) : 0) + '%';
            label.textContent = current + ' / ' + max;
            bar.setAttribute('aria-valuenow', String(current));
        }

        vital.querySelectorAll('[data-vital-step]').forEach(function (button) {
            button.addEventListener('click', function () {
                const current = parseInt(vital.dataset.current, 10);
                const next = Math.min(max, Math.max(0, current + parseInt(button.dataset.vitalStep, 10)));
                if (next === current) {
                    return;
                }
                render(next); // optimistic, corrected by the server answer
                request('POST', '/character/' + id + '/' + key, { value: next })
                    .then(function (data) { render(data[key + '_current']); })
                    .catch(function (error) { render(current); failed(error); });
            });
        });
    });

    // ---- Conditions
    document.querySelectorAll('[data-condition]').forEach(function (chip) {
        chip.addEventListener('click', function () {
            request('POST', '/character/' + id + '/conditions/' + chip.dataset.condition + '/toggle', {})
                .then(function (data) { chip.setAttribute('aria-pressed', data.active ? 'true' : 'false'); })
                .catch(failed);
        });
    });

    // ---- Skill advancement marks
    document.querySelectorAll('[data-skill-mark]').forEach(function (box) {
        box.addEventListener('change', function () {
            request('POST', '/character/' + id + '/skills/' + box.dataset.skillMark + '/mark', { marked: box.checked })
                .catch(function (error) { box.checked = !box.checked; failed(error); });
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
            [['Vorgabe', detail.components], ['Zauberdauer', detail.castingTime], ['Reichweite', detail.range],
                ['Wirkungsdauer', detail.duration], ['Kosten', detail.wpNote]].forEach(function (pair) {
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
        button.addEventListener('click', function () { showDetail(JSON.parse(button.dataset.detail)); });
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
            const url = input.dataset.segment === 'armor'
                ? '/character/' + id + '/armor/' + input.dataset.slot
                : '/character/' + id + '/' + input.dataset.segment + '/' + input.dataset.rowId;

            const body = {};
            body[input.dataset.field] = value;
            request('POST', url, body).then(saved).catch(failed);

            // Keep the collapsed row's title in step with the name field.
            const entry = input.closest('.gear-entry');
            if (entry && input.dataset.field === 'name_de' && input.dataset.segment !== 'armor') {
                entry.querySelector('.ui-details__title').textContent = value;
            }
        });
    });

    document.querySelectorAll('[data-add]').forEach(function (button) {
        button.addEventListener('click', function () {
            request('POST', '/character/' + id + '/' + button.dataset.add, {})
                .then(function () { window.location.reload(); })
                .catch(failed);
        });
    });

    document.querySelectorAll('[data-remove]').forEach(function (button) {
        button.addEventListener('click', function () {
            request('DELETE', '/character/' + id + '/' + button.dataset.remove + '/' + button.dataset.rowId)
                .then(function () { window.location.reload(); })
                .catch(failed);
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
            request('POST', '/character/' + id + '/currency', body).then(saved).catch(failed);
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
            request('POST', '/character/' + id + '/memory', { text: text })
                .then(function () {
                    lastSaved = text;
                    memoryStatus.textContent = 'Alles gespeichert.';
                })
                .catch(function (error) {
                    memoryStatus.textContent = 'Noch nicht gespeichert – wird erneut versucht.';
                    failed(error);
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
            window.fetch('/character/' + id + '/portrait', { method: 'POST', body: data })
                .then(function (response) { return response.json(); })
                .then(function (result) {
                    if (result.error) {
                        failed(new Error(result.error));

                        return;
                    }
                    window.location.reload();
                })
                .catch(failed);
        });
    }

    // ---- Delete character (confirmed in the sheet)
    const deleteConfirm = document.querySelector('[data-delete-confirm]');
    if (deleteConfirm) {
        deleteConfirm.addEventListener('click', function () {
            request('DELETE', '/character/' + id)
                .then(function () {
                    try {
                        const mine = JSON.parse(window.localStorage.getItem('trpg.myCharacters') || '[]');
                        window.localStorage.setItem('trpg.myCharacters', JSON.stringify(mine.filter(function (other) { return String(other) !== String(id); })));
                    } catch (error) {
                        // ignore: nothing to clean up
                    }
                    window.location.href = '/characters';
                })
                .catch(failed);
        });
    }
}());
