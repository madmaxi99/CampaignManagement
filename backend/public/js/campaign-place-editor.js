(function () {
    const modal = document.getElementById('place-form-modal');
    const form = document.getElementById('place-form');
    if (!modal || !form) {
        return;
    }

    const campaignId = document.querySelector('[data-campaign-id]').dataset.campaignId;
    const placeValues = JSON.parse(document.getElementById('place-form-data').textContent);
    const title = form.querySelector('[data-place-form-title]');
    const errorBox = form.querySelector('[data-place-form-error]');
    let editingId = null;

    function openForm(placeId) {
        editingId = placeId;
        form.reset();
        errorBox.hidden = true;
        title.textContent = placeId === null ? 'Neuer Ort' : 'Ort bearbeiten';

        // A place cannot be its own parent: hide it in the selector while editing.
        Array.from(form.elements.parent_id.options).forEach((option) => {
            option.hidden = placeId !== null && option.value === String(placeId);
        });

        if (placeId !== null) {
            Object.entries(placeValues[placeId] || {}).forEach(([name, value]) => {
                if (form.elements[name]) {
                    form.elements[name].value = value === null ? '' : value;
                }
            });
        }

        const entityModal = document.getElementById('entity-modal');
        if (entityModal && entityModal.open) {
            entityModal.close();
        }
        modal.showModal();
        form.elements.name_de.focus();
    }

    async function postJson(url, body) {
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body),
        });
        const data = await response.json().catch(() => ({}));
        if (!response.ok) {
            throw new Error(data.error || 'Speichern fehlgeschlagen.');
        }

        return data;
    }

    form.addEventListener('submit', async (event) => {
        event.preventDefault();
        errorBox.hidden = true;

        const payload = {};
        ['name_de', 'parent_id', 'description_de', 'dm_text_de', 'encounter_table_id'].forEach((name) => {
            payload[name] = form.elements[name].value;
        });

        try {
            const base = `/campaign/${campaignId}/places`;
            let placeId = editingId;
            if (placeId === null) {
                placeId = (await postJson(base, payload)).id;
            } else {
                await postJson(`${base}/${placeId}`, payload);
            }

            const file = form.elements.image.files[0];
            if (file) {
                const upload = new FormData();
                upload.append('image', file);
                const response = await fetch(`${base}/${placeId}/image`, { method: 'POST', body: upload });
                if (!response.ok) {
                    const data = await response.json().catch(() => ({}));
                    throw new Error(`Ort gespeichert, aber das Bild nicht: ${data.error || 'Fehler beim Hochladen.'}`);
                }
            }

            window.location.reload();
        } catch (error) {
            errorBox.textContent = error.message;
            errorBox.hidden = false;
        }
    });

    modal.querySelector('[data-place-form-close]').addEventListener('click', () => modal.close());

    document.addEventListener('click', (event) => {
        if (event.target.closest('[data-place-add]')) {
            openForm(null);
            return;
        }
        const edit = event.target.closest('[data-place-edit]');
        if (edit) {
            openForm(edit.dataset.placeEdit);
        }
    });
}());
