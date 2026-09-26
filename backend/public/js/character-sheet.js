(function () {
    const sheet = document.querySelector('.sheet');
    if (!sheet) {
        return;
    }

    const slug = sheet.dataset.slug;

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

                postJson(`/character/${slug}/${vital}`, { value: newValue }).then((data) => {
                    renderPips(tracker, data[`${vital}_current`]);
                });
            });
        });
    });

    // --- Conditions ---

    document.querySelectorAll('.condition-chip').forEach((chip) => {
        chip.addEventListener('click', () => {
            const code = chip.dataset.conditionCode;

            postJson(`/character/${slug}/conditions/${code}/toggle`).then((data) => {
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
            postJson(`/character/${slug}/skills/${checkbox.dataset.skillId}/mark`, { marked: checkbox.checked });
        });
    });

    // --- Downtime panel ---

    const downtimeModal = document.getElementById('downtime-modal');
    const downtimeList = document.getElementById('downtime-list');

    function renderDowntimeList(skills) {
        if (skills.length === 0) {
            downtimeList.innerHTML = '<li class="downtime-empty">Keine markierten Fertigkeiten.</li>';

            return;
        }

        downtimeList.innerHTML = skills.map((skill) => `
            <li data-skill-id="${skill.id}">
                <span class="entry-name">${skill.name_de} <small>(${skill.attribute_code})</small></span>
                <span class="entry-value">${skill.value}</span>
                <button type="button" class="advance-button" data-apply="1" data-skill-id="${skill.id}">Aufleveln</button>
                <button type="button" class="advance-button" data-apply="0" data-skill-id="${skill.id}">Verwerfen</button>
            </li>
        `).join('');
    }

    document.getElementById('downtime-button').addEventListener('click', () => {
        fetch(`/character/${slug}/skills/marked`)
            .then((response) => response.json())
            .then((skills) => {
                renderDowntimeList(skills);
                downtimeModal.showModal();
            });
    });

    document.getElementById('downtime-modal-close').addEventListener('click', () => downtimeModal.close());
    downtimeModal.addEventListener('click', (event) => {
        if (event.target === downtimeModal) {
            downtimeModal.close();
        }
    });

    downtimeList.addEventListener('click', (event) => {
        const button = event.target.closest('.advance-button');
        if (!button) {
            return;
        }

        postJson(`/character/${slug}/skills/${button.dataset.skillId}/advance`, { apply: button.dataset.apply === '1' })
            .then(() => window.location.reload());
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

            postJson(`/character/${slug}/currency`, body).then(() => {
                currencySaveButton.textContent = 'Gespeichert!';
                setTimeout(() => { currencySaveButton.textContent = 'Speichern'; }, 1500);
            });
        });
    }

    // --- Learn spell ---

    const learnSpellButton = document.getElementById('learn-spell-button');
    if (learnSpellButton) {
        learnSpellButton.addEventListener('click', () => {
            const select = document.getElementById('learn-spell-select');
            if (!select.value) {
                return;
            }

            postJson(`/character/${slug}/spells`, { spell_id: parseInt(select.value, 10) })
                .then(() => window.location.reload());
        });
    }

    // --- Weapons / Armor / Inventory: add, quantity change, remove ---

    function wireEquipmentSegment(segment, selectId, quantityInputId, addButtonId) {
        const addButton = document.getElementById(addButtonId);
        if (addButton) {
            addButton.addEventListener('click', () => {
                const select = document.getElementById(selectId);
                if (!select.value) {
                    return;
                }
                const quantity = parseInt(document.getElementById(quantityInputId).value, 10) || 1;

                postJson(`/character/${slug}/${segment}`, { item_id: parseInt(select.value, 10), quantity })
                    .then(() => window.location.reload());
            });
        }
    }

    wireEquipmentSegment('weapons', 'weapon-catalog-select', 'weapon-quantity-input', 'weapon-add-button');
    wireEquipmentSegment('armor', 'armor-catalog-select', 'armor-quantity-input', 'armor-add-button');
    wireEquipmentSegment('inventory', 'inventory-catalog-select', 'inventory-quantity-input', 'inventory-add-button');

    document.querySelectorAll('.quantity-input').forEach((input) => {
        input.addEventListener('change', () => {
            const quantity = parseInt(input.value, 10) || 0;

            postJson(`/character/${slug}/${input.dataset.segment}/${input.dataset.rowId}/quantity`, { quantity })
                .then(() => window.location.reload());
        });
    });

    document.querySelectorAll('.remove-button').forEach((button) => {
        button.addEventListener('click', () => {
            deleteRequest(`/character/${slug}/${button.dataset.segment}/${button.dataset.rowId}`)
                .then(() => window.location.reload());
        });
    });
})();
