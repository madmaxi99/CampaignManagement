(function () {
    const sheet = document.querySelector('.sheet');
    if (!sheet) {
        return;
    }

    const id = sheet.dataset.id;

    function postJson(path, body) {
        return fetch(path, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body || {}),
        }).then((response) => response.json());
    }

    function deleteRequest(path) {
        return fetch(path, { method: 'DELETE' });
    }

    // --- HP / WP pips ---

    function renderPips(tracker, current) {
        tracker.dataset.current = String(current);
        tracker.querySelectorAll('.pip').forEach((pip) => {
            const index = parseInt(pip.dataset.index, 10);
            pip.classList.toggle('filled', index <= current);
        });
        tracker.querySelector('.vital-count').textContent = `${current} / ${tracker.dataset.max}`;
    }

    document.querySelectorAll('.vital-tracker').forEach((tracker) => {
        const vital = tracker.dataset.vital; // "hp" or "wp"

        tracker.querySelectorAll('.pip').forEach((pip) => {
            pip.addEventListener('click', () => {
                const clickedIndex = parseInt(pip.dataset.index, 10);
                const current = parseInt(tracker.dataset.current, 10);
                const newValue = clickedIndex === current ? clickedIndex - 1 : clickedIndex;

                postJson(`/character/${id}/${vital}`, { value: newValue }).then((data) => {
                    renderPips(tracker, data[`${vital}_current`]);
                });
            });
        });
    });

    // --- Conditions ---

    document.querySelectorAll('.condition-chip').forEach((chip) => {
        chip.addEventListener('click', () => {
            const code = chip.dataset.conditionCode;

            postJson(`/character/${id}/conditions/${code}/toggle`).then((data) => {
                chip.classList.toggle('active', data.active);
            });
        });
    });

    // --- Detail modal (skills & spells) ---

    const detailModal = document.getElementById('detail-modal');
    const detailContent = document.getElementById('detail-modal-content');

    function renderSkillDetail(detail) {
        return `
            <h2>${detail.name}</h2>
            <p>Attribut: ${detail.attribute}</p>
            <p>Kategorie: ${detail.category}</p>
            <p>Wert: ${detail.value}</p>
        `;
    }

    function renderSpellDetail(detail) {
        return `
            <h2>${detail.name}</h2>
            ${detail.components ? `<p>Vorgabe: ${detail.components}</p>` : ''}
            ${detail.castingTime ? `<p>Zauberdauer: ${detail.castingTime}</p>` : ''}
            ${detail.range ? `<p>Reichweite: ${detail.range}</p>` : ''}
            ${detail.duration ? `<p>Wirkungsdauer: ${detail.duration}</p>` : ''}
            <p>Kosten: ${detail.wpNote}</p>
            <p>${detail.effect}</p>
        `;
    }

    document.querySelectorAll('.entry-row').forEach((row) => {
        row.addEventListener('click', () => {
            const detail = JSON.parse(row.dataset.detail);
            detailContent.innerHTML = detail.type === 'spell' ? renderSpellDetail(detail) : renderSkillDetail(detail);
            detailModal.showModal();
        });
    });

    document.getElementById('detail-modal-close').addEventListener('click', () => detailModal.close());
    detailModal.addEventListener('click', (event) => {
        if (event.target === detailModal) {
            detailModal.close();
        }
    });

    // --- Skill advancement marking ---

    document.querySelectorAll('.skill-mark').forEach((checkbox) => {
        checkbox.addEventListener('change', () => {
            postJson(`/character/${id}/skills/${checkbox.dataset.skillId}/mark`, { marked: checkbox.checked });
        });
    });

    // --- Currency ---

    const currencySaveButton = document.getElementById('currency-save-button');
    if (currencySaveButton) {
        currencySaveButton.addEventListener('click', () => {
            const body = {
                gold: parseInt(document.getElementById('coins-gold').value, 10) || 0,
                silver: parseInt(document.getElementById('coins-silver').value, 10) || 0,
                copper: parseInt(document.getElementById('coins-copper').value, 10) || 0,
            };

            postJson(`/character/${id}/currency`, body).then(() => {
                currencySaveButton.textContent = 'Gespeichert!';
                setTimeout(() => { currencySaveButton.textContent = 'Speichern'; }, 1500);
            });
        });
    }

    // --- Weapons / Armor / Inventory: free-text rows (add, edit field, remove) ---

    document.querySelectorAll('.add-row-button').forEach((button) => {
        button.addEventListener('click', () => {
            postJson(`/character/${id}/${button.dataset.segment}`, {}).then(() => window.location.reload());
        });
    });

    document.querySelectorAll('.free-text-field').forEach((input) => {
        input.addEventListener('change', () => {
            const segment = input.dataset.segment;
            const value = input.type === 'number' ? (input.value === '' ? null : parseInt(input.value, 10)) : input.value;
            const url = segment === 'armor'
                ? `/character/${id}/armor/${input.dataset.slot}`
                : `/character/${id}/${segment}/${input.dataset.rowId}`;

            postJson(url, { [input.dataset.field]: value }).then(() => window.location.reload());
        });
    });

    document.querySelectorAll('.armor-penalty-checkbox').forEach((checkbox) => {
        checkbox.addEventListener('change', () => {
            postJson(`/character/${id}/armor/${checkbox.dataset.slot}`, { [checkbox.dataset.field]: checkbox.checked })
                .then(() => window.location.reload());
        });
    });

    document.querySelectorAll('.remove-button').forEach((button) => {
        button.addEventListener('click', () => {
            deleteRequest(`/character/${id}/${button.dataset.segment}/${button.dataset.rowId}`)
                .then(() => window.location.reload());
        });
    });

    const deleteCharacterButton = document.getElementById('delete-character-button');
    if (deleteCharacterButton) {
        deleteCharacterButton.addEventListener('click', () => {
            if (!confirm('Diesen Charakter wirklich unwiderruflich löschen?')) {
                return;
            }
            deleteRequest(`/character/${id}`).then(() => {
                window.location.href = '/characters';
            });
        });
    }

    // --- Portrait upload (only shown once, while there is no portrait yet) ---

    const portraitUploadForm = document.getElementById('portrait-upload-form');
    if (portraitUploadForm) {
        portraitUploadForm.addEventListener('submit', (event) => {
            event.preventDefault();

            const input = document.getElementById('portrait-upload-input');
            if (!input.files[0]) {
                return;
            }

            const formData = new FormData();
            formData.append('portrait', input.files[0]);

            fetch(`/character/${id}/portrait`, { method: 'POST', body: formData })
                .then((response) => response.json())
                .then((data) => {
                    if (data.error) {
                        alert(data.error);

                        return;
                    }
                    window.location.reload();
                });
        });
    }
})();
