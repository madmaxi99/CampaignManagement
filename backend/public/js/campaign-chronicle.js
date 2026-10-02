(function () {
    const root = document.querySelector('[data-campaign-id]');
    if (!root) {
        return;
    }
    const base = `/campaign/${root.dataset.campaignId}`;

    async function send(method, url, body) {
        const response = await fetch(url, {
            method,
            headers: { 'Content-Type': 'application/json' },
            body: body === undefined ? undefined : JSON.stringify(body),
        });
        const data = await response.json().catch(() => ({}));
        if (!response.ok) {
            window.alert(data.error || 'Das hat nicht geklappt.');
            return false;
        }

        return true;
    }

    const form = document.querySelector('[data-chronicle-form]');
    if (form) {
        form.addEventListener('submit', async (event) => {
            event.preventDefault();
            const body = { title_de: form.elements.title_de.value, text_de: form.elements.text_de.value };
            if (await send('POST', `${base}/chronicle`, body)) {
                window.location.reload();
            }
        });
    }

    document.addEventListener('click', async (event) => {
        const edit = event.target.closest('[data-chronicle-edit]');
        if (edit) {
            const entry = edit.closest('[data-chronicle-entry]');
            const title = window.prompt('Überschrift (leer lassen für keine):', entry.querySelector('[data-entry-raw-title]').textContent.trim());
            if (title === null) {
                return;
            }
            const text = window.prompt('Text:', entry.querySelector('[data-entry-text]').textContent);
            if (text === null) {
                return;
            }
            if (await send('POST', `${base}/chronicle/${edit.dataset.chronicleEdit}`, { title_de: title, text_de: text })) {
                window.location.reload();
            }
            return;
        }
        const del = event.target.closest('[data-chronicle-delete]');
        if (del) {
            if (window.confirm('Diesen Eintrag löschen?') && await send('DELETE', `${base}/chronicle/${del.dataset.chronicleDelete}`)) {
                window.location.reload();
            }
            return;
        }
        if (event.target.closest('[data-campaign-restart]')) {
            if (window.confirm('Chronik und NPC-Notizen löschen? Der Inhalt der Kampagne bleibt.') && await send('POST', `${base}/restart`)) {
                window.location.reload();
            }
        }
    });
}());
