function wireEventTable(table) {
    const button = table.querySelector('[data-roll-button]');
    const resultLabel = table.querySelector('[data-roll-result]');
    const entries = Array.from(table.querySelectorAll('.event-entry'));

    button.addEventListener('click', () => {
        const hasOpenEnded = entries.some((entry) => entry.dataset.openEnded === '1');
        const bounded = entries
            .filter((entry) => entry.dataset.openEnded !== '1')
            .map((entry) => parseInt(entry.dataset.max, 10));
        const maxRoll = hasOpenEnded ? 12 : Math.max(...bounded);

        const roll = Math.floor(Math.random() * maxRoll) + 1;
        resultLabel.textContent = `Wurf: ${roll}`;

        entries.forEach((entry) => {
            const min = parseInt(entry.dataset.min, 10);
            const max = parseInt(entry.dataset.max, 10);
            const openEnded = entry.dataset.openEnded === '1';
            const matches = openEnded ? roll >= min : roll >= min && roll <= max;
            entry.classList.toggle('rolled', matches);
        });
    });
}

document.querySelectorAll('.event-table').forEach(wireEventTable);

const entityModal = document.getElementById('entity-modal');
if (entityModal) {
    const modalBody = entityModal.querySelector('[data-modal-body]');

    // Delegated so links inside cloned modal content (cross-references
    // within another entity's text) open a new entity without rebinding.
    document.addEventListener('click', (event) => {
        const link = event.target.closest('.entity-link');
        if (!link) {
            return;
        }

        event.preventDefault();
        const template = document.getElementById(`tpl-${link.dataset.entityType}-${link.dataset.entityId}`);
        if (!template) {
            return;
        }

        modalBody.innerHTML = '';
        modalBody.appendChild(template.content.cloneNode(true));
        modalBody.querySelectorAll('.event-table').forEach(wireEventTable);
        entityModal.showModal();
    });

    entityModal.querySelector('[data-modal-close]').addEventListener('click', () => entityModal.close());
    entityModal.addEventListener('click', (event) => {
        if (event.target === entityModal) {
            entityModal.close();
        }
    });
}
