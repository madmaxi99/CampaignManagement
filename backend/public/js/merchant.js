/*
 * Shop overview (quirks and price lists): filters the rows as you type, opens the lists with a match,
 * and loads the overview into the play page dialog the first time it is opened.
 */
function setup(root) {
    const input = root.querySelector('[data-merchant-search]');
    const groups = Array.from(root.querySelectorAll('[data-merchant-group]'));
    const empty = root.querySelector('[data-merchant-empty]');

    function filter() {
        const needle = input.value.trim().toLowerCase();
        let shown = 0;
        groups.forEach((group) => {
            const rows = Array.from(group.querySelectorAll('[data-merchant-row]'));
            let matches = 0;
            rows.forEach((row) => {
                const match = row.textContent.toLowerCase().includes(needle);
                row.hidden = !match;
                matches += match ? 1 : 0;
            });
            group.hidden = matches === 0;
            shown += matches;
            const count = group.querySelector('[data-merchant-count]');
            if (count) {
                count.textContent = String(matches);
            }
            if (needle !== '') {
                group.open = matches > 0;
            }
        });
        if (empty) {
            empty.hidden = shown > 0;
        }
    }

    input.addEventListener('input', filter);
    root.querySelector('[data-merchant-open]').addEventListener('click', () => {
        groups.forEach((group) => (group.open = true));
    });
    root.querySelector('[data-merchant-close]').addEventListener('click', () => {
        groups.forEach((group) => (group.open = false));
    });
}

async function load(slot) {
    if (slot.dataset.loaded) {
        return;
    }
    slot.dataset.loaded = '1';
    try {
        const response = await fetch(slot.dataset.merchantSrc);
        if (!response.ok) {
            throw new Error('Laden fehlgeschlagen');
        }
        slot.innerHTML = await response.text();
        setup(slot.querySelector('[data-merchant]'));
    } catch {
        delete slot.dataset.loaded;
        slot.textContent = 'Die Händler-Übersicht konnte nicht geladen werden.';
    }
}

document.querySelectorAll('[data-merchant]').forEach(setup);

document.addEventListener('click', (event) => {
    const opener = event.target.closest('[data-ui-open]');
    const slot = opener ? document.querySelector(`${opener.dataset.uiOpen} [data-merchant-src]`) : null;
    if (slot) {
        load(slot);
    }
});
