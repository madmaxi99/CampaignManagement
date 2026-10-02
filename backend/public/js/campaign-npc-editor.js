(function () {
    const modal = document.getElementById('npc-form-modal');
    const form = document.getElementById('npc-form');
    if (!modal || !form) {
        return;
    }

    const campaignId = document.querySelector('[data-campaign-id]').dataset.campaignId;
    const npcValues = JSON.parse(document.getElementById('npc-form-data').textContent);
    const title = form.querySelector('[data-npc-form-title]');
    const errorBox = form.querySelector('[data-npc-form-error]');
    let editingId = null;

    function showError(message) {
        errorBox.textContent = message;
        errorBox.hidden = false;
    }

    function openForm(npcId) {
        editingId = npcId;
        form.reset();
        errorBox.hidden = true;

        if (npcId === null) {
            title.textContent = 'Neuer NPC';
        } else {
            title.textContent = 'NPC bearbeiten';
            const values = npcValues[npcId] || {};
            Object.entries(values).forEach(([name, value]) => {
                const field = form.elements[name];
                if (!field) {
                    return;
                }
                if (field.type === 'checkbox') {
                    field.checked = Boolean(value);
                } else {
                    field.value = value === null ? '' : value;
                }
            });
        }

        // The entity modal may be open (Bearbeiten sits inside an NPC card).
        const entityModal = document.getElementById('entity-modal');
        if (entityModal && entityModal.open) {
            entityModal.close();
        }
        modal.showModal();
        form.elements.name_de.focus();
    }

    function formPayload() {
        const payload = {};
        Array.from(form.elements).forEach((field) => {
            if (!field.name || field.type === 'file') {
                return;
            }
            payload[field.name] = field.type === 'checkbox' ? field.checked : field.value;
        });

        return payload;
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

        try {
            const base = `/campaign/${campaignId}/npcs`;
            let npcId = editingId;
            if (npcId === null) {
                npcId = (await postJson(base, formPayload())).id;
            } else {
                await postJson(`${base}/${npcId}`, formPayload());
            }

            const file = form.elements.portrait.files[0];
            if (file) {
                const upload = new FormData();
                upload.append('portrait', file);
                const response = await fetch(`${base}/${npcId}/portrait`, { method: 'POST', body: upload });
                if (!response.ok) {
                    const data = await response.json().catch(() => ({}));
                    throw new Error(`NPC gespeichert, aber das Portrait nicht: ${data.error || 'Fehler beim Hochladen.'}`);
                }
            }

            window.location.reload();
        } catch (error) {
            showError(error.message);
        }
    });

    modal.querySelector('[data-npc-form-close]').addEventListener('click', () => modal.close());

    document.addEventListener('click', (event) => {
        const add = event.target.closest('[data-npc-add]');
        if (add) {
            openForm(null);
            return;
        }
        const edit = event.target.closest('[data-npc-edit]');
        if (edit) {
            openForm(edit.dataset.npcEdit);
        }
    });
}());
