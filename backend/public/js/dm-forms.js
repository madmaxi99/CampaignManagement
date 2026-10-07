/*
 * Generic DM editing helpers, driven by data attributes (no per-page JS):
 *   form[data-dm-form]  data-action, data-after ("reload" | "goto:/url/{id}"), data-id,
 *                       data-upload-url ("/x/{id}/image"), data-upload-field (default "image")
 *   [data-dm-delete]    data-url, data-confirm, data-after
 *   [data-dm-post]      data-url, data-body (JSON), data-after
 *   [data-monster-add]  data-url, data-select, data-field (default "bestiary_id")
 *   [data-row-add]      data-template (selector of a <template>), data-target (selector of the row container)
 *   [data-row-remove]   removes its closest [data-row]
 *   select[data-switch] shows only the [data-kind] blocks matching the selected value
 *   Field names ending in "[]" are collected into arrays.
 *   textarea[data-notes-url]  autosaves {notes_de}
 */
import { sendJson, toastError } from './lib/http.js';

function after(spec, data) {
    if (!spec || spec === 'reload') {
        window.location.reload();
    } else if (spec.indexOf('goto:') === 0) {
        window.location.href = spec.slice(5).replace('{id}', data && data.id !== undefined ? data.id : '');
    }
}

// ---- forms
document.addEventListener('submit', async function (event) {
    const form = event.target.closest('form[data-dm-form]');
    if (!form) {
        return;
    }
    event.preventDefault();

    const payload = {};
    const files = [];
    new FormData(form).forEach(function (value, key) {
        if (value instanceof File) {
            if (value.size > 0) {
                files.push([key, value]);
            }
        } else if (key.slice(-2) === '[]') {
            const name = key.slice(0, -2);
            (payload[name] = payload[name] || []).push(value);
        } else {
            payload[key] = value;
        }
    });

    const submit = form.querySelector('[type="submit"]');
    if (submit) {
        submit.disabled = true;
    }
    try {
        const data = await sendJson('POST', form.dataset.action, payload);
        const id = form.dataset.id || data.id;
        if (files.length && form.dataset.uploadUrl) {
            const upload = new FormData();
            upload.append(form.dataset.uploadField || 'image', files[0][1]);
            const response = await fetch(form.dataset.uploadUrl.replace('{id}', id), {
                method: 'POST',
                body: upload,
            });
            if (!response.ok) {
                const result = await response.json().catch(function () {
                    return {};
                });
                throw new Error('Gespeichert, aber das Bild nicht: ' + (result.error || 'Fehler beim Hochladen.'));
            }
        }
        after(form.dataset.after, { id: id });
    } catch (error) {
        toastError(error);
        if (submit) {
            submit.disabled = false;
        }
    }
});

// ---- buttons
document.addEventListener('click', async function (event) {
    const del = event.target.closest('[data-dm-delete]');
    if (del) {
        if (await window.ui.confirm(del.dataset.confirm || 'Wirklich löschen?', 'Ja, löschen')) {
            try {
                await sendJson('DELETE', del.dataset.url);
                after(del.dataset.after, {});
            } catch (error) {
                toastError(error);
            }
        }

        return;
    }

    const post = event.target.closest('[data-dm-post]');
    if (post) {
        const run = async function () {
            try {
                await sendJson('POST', post.dataset.url, post.dataset.body ? JSON.parse(post.dataset.body) : {});
                after(post.dataset.after, {});
            } catch (error) {
                toastError(error);
            }
        };
        if (post.dataset.confirm) {
            if (await window.ui.confirm(post.dataset.confirm, post.dataset.confirmLabel || 'Ja')) {
                await run();
            }
        } else {
            await run();
        }

        return;
    }

    const rowAdd = event.target.closest('[data-row-add]');
    if (rowAdd) {
        const template = document.querySelector(rowAdd.dataset.template);
        const target = document.querySelector(rowAdd.dataset.target);
        if (template && target) {
            target.appendChild(template.content.cloneNode(true));
        }

        return;
    }

    const rowRemove = event.target.closest('[data-row-remove]');
    if (rowRemove) {
        const row = rowRemove.closest('[data-row]');
        if (row) {
            row.remove();
        }

        return;
    }

    const add = event.target.closest('[data-monster-add]');
    if (add) {
        const select = document.querySelector(add.dataset.select);
        if (select && select.value) {
            try {
                await sendJson('POST', add.dataset.url, {
                    [add.dataset.field || 'bestiary_id']: parseInt(select.value, 10),
                });
                window.location.reload();
            } catch (error) {
                toastError(error);
            }
        }
    }
});

// ---- kind switch: show only the blocks of the selected value
function applySwitch(select) {
    const scope = select.closest('form') || document;
    scope.querySelectorAll('[data-kind]').forEach(function (block) {
        block.hidden = block.dataset.kind !== select.value;
    });
}
document.addEventListener('change', function (event) {
    if (event.target.matches('select[data-switch]')) {
        applySwitch(event.target);
    }
});
document.querySelectorAll('select[data-switch]').forEach(applySwitch);

// ---- notes autosave (delegated, also works inside cloned dialog content)
const timers = new WeakMap();
document.addEventListener('input', function (event) {
    const area = event.target.closest('textarea[data-notes-url]');
    if (!area) {
        return;
    }
    const status = area.closest('.ui-field') ? area.closest('.ui-field').querySelector('[data-notes-status]') : null;
    window.clearTimeout(timers.get(area));
    if (status) {
        status.textContent = 'Änderungen …';
    }
    timers.set(
        area,
        window.setTimeout(async function () {
            try {
                await sendJson('POST', area.dataset.notesUrl, { notes_de: area.value });
                if (status) {
                    status.textContent = 'Gespeichert.';
                }
            } catch (error) {
                if (status) {
                    status.textContent = 'Nicht gespeichert.';
                }
                toastError(error);
            }
        }, 700)
    );
});
