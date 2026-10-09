/*
 * Design-system behaviour: CSRF header for DM requests, dialogs (sheets),
 * tabs and toasts. Loaded on every page.
 */
(function () {
    'use strict';

    // ---- CSRF: add the session token to every same-origin state-changing fetch.
    const meta = document.querySelector('meta[name="csrf-token"]');
    const csrfToken = meta ? meta.content : '';
    const nativeFetch = window.fetch.bind(window);

    window.fetch = function (input, init) {
        init = init || {};
        const isRequest = input instanceof Request;
        const method = String(init.method || (isRequest ? input.method : 'GET')).toUpperCase();
        const url = new URL(isRequest ? input.url : input, window.location.href);

        if (csrfToken && method !== 'GET' && method !== 'HEAD' && url.origin === window.location.origin) {
            const headers = new Headers(init.headers || (isRequest ? input.headers : undefined));
            if (!headers.has('X-CSRF-Token')) {
                headers.set('X-CSRF-Token', csrfToken);
            }
            init = Object.assign({}, init, { headers: headers });
        }

        return nativeFetch(input, init).then(function (response) {
            // Session ran out while the DM page was open: back to the login.
            if (response.status === 401 && url.pathname.indexOf('/dm/') === 0) {
                window.location.href = '/dm/login?next=' + encodeURIComponent(window.location.pathname);
            }

            return response;
        });
    };

    // ---- Toasts: ui.toast('Gespeichert') / ui.toast('Fehler', 'error')
    function toast(message, type) {
        const host = document.querySelector('[data-ui-toasts]');
        if (!host) {
            return;
        }
        const node = document.createElement('div');
        node.className = 'ui-toast' + (type === 'error' ? ' ui-toast--error' : '');
        node.textContent = message;
        host.appendChild(node);
        window.setTimeout(function () {
            node.remove();
        }, 3500);
    }

    // ---- Sheets (<dialog class="ui-sheet">): data-ui-open="#id", data-ui-close
    document.addEventListener('click', function (event) {
        const opener = event.target.closest('[data-ui-open]');
        if (opener) {
            const dialog = document.querySelector(opener.dataset.uiOpen);
            if (dialog && typeof dialog.showModal === 'function') {
                dialog.showModal();
            }
            return;
        }

        const closer = event.target.closest('[data-ui-close]');
        if (closer) {
            const dialog = closer.closest('dialog');
            if (dialog) {
                dialog.close();
            }
            return;
        }

        // Click on the backdrop (the dialog element itself) closes the sheet.
        if (event.target instanceof HTMLDialogElement && event.target.classList.contains('ui-sheet')) {
            event.target.close();
        }
    });

    // ---- Tabs: [data-ui-tabs] with .ui-tab[aria-controls] and .ui-tabpanel.
    // With data-ui-tabs-hash the selected tab lives in the URL hash (#skills),
    // so a reload or a shared link opens the same tab.
    document.querySelectorAll('[data-ui-tabs]').forEach(function (tablist) {
        const tabs = Array.from(tablist.querySelectorAll('.ui-tab'));
        const useHash = tablist.hasAttribute('data-ui-tabs-hash');

        function select(tab, updateHash) {
            tabs.forEach(function (other) {
                const active = other === tab;
                other.setAttribute('aria-selected', active ? 'true' : 'false');
                const panel = document.getElementById(other.getAttribute('aria-controls'));
                if (panel) {
                    panel.hidden = !active;
                }
            });
            if (useHash && updateHash) {
                window.history.replaceState(null, '', '#' + tab.id.replace(/^tab-/, ''));
            }
        }

        tabs.forEach(function (tab) {
            tab.addEventListener('click', function () {
                select(tab, true);
            });
        });

        if (useHash && window.location.hash) {
            const wanted = document.getElementById('tab-' + window.location.hash.slice(1));
            if (wanted && tabs.indexOf(wanted) !== -1) {
                select(wanted, false);
            }
        }
    });

    // ---- Confirm: ui.confirm('Wirklich löschen?', 'Ja, löschen').then(function (yes) { ... })
    function confirmDialog(message, okLabel) {
        return new Promise(function (resolve) {
            const dialog = document.createElement('dialog');
            dialog.className = 'ui-sheet';
            const form = document.createElement('form');
            form.method = 'dialog';
            const text = document.createElement('p');
            text.textContent = message;
            text.style.fontSize = 'var(--fs-lead)';
            const row = document.createElement('div');
            row.className = 'ui-row';
            const ok = document.createElement('button');
            ok.className = 'ui-btn ui-btn--danger';
            ok.value = 'ok';
            ok.textContent = okLabel || 'Ja';
            const cancel = document.createElement('button');
            cancel.className = 'ui-btn ui-btn--ghost';
            cancel.value = 'cancel';
            cancel.textContent = 'Abbrechen';
            row.append(ok, cancel);
            form.append(text, row);
            dialog.append(form);
            dialog.addEventListener('close', function () {
                const answer = dialog.returnValue === 'ok';
                dialog.remove();
                resolve(answer);
            });
            document.body.appendChild(dialog);
            dialog.showModal();
            cancel.focus();
        });
    }

    window.ui = { toast: toast, confirm: confirmDialog };
})();
