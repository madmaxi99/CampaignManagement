/* Gruppe tab: the dialog for picking a character (with a search box) and the one for adding foes. */
const dialog = document.getElementById('party-picker');
const search = document.getElementById('party-search');

if (dialog && search) {
    document.querySelector('[data-open-picker]').addEventListener('click', () => {
        dialog.showModal();
        search.focus();
    });
    document.querySelector('[data-close-picker]').addEventListener('click', () => dialog.close());
    search.addEventListener('input', () => {
        const term = search.value.trim().toLowerCase();
        dialog.querySelectorAll('.party-candidate').forEach((button) => {
            button.hidden = term !== '' && !button.dataset.search.includes(term);
        });
    });
}

const foeDialog = document.getElementById('foe-picker');
const foeOpen = document.querySelector('[data-open-foe-picker]');

if (foeDialog && foeOpen) {
    const foeSearch = document.getElementById('foe-search');
    const foeValue = document.getElementById('foe-bestiary');
    const foeChosen = document.getElementById('foe-chosen');
    const foeEmpty = document.getElementById('foe-empty');
    const options = Array.from(foeDialog.querySelectorAll('#foe-list [data-id]'));

    const choose = (option) => {
        options.forEach((o) => o.setAttribute('aria-selected', String(o === option)));
        foeValue.value = option.dataset.id;
        foeChosen.textContent = 'Gewählt: ' + option.querySelector('strong').textContent;
    };
    const visible = () => options.filter((o) => !o.hidden);

    foeOpen.addEventListener('click', () => {
        foeDialog.showModal();
        foeSearch.focus();
    });
    foeSearch.addEventListener('input', () => {
        const terms = foeSearch.value.trim().toLowerCase().split(/\s+/).filter(Boolean);
        options.forEach((o) => {
            o.hidden = !terms.every((term) => o.dataset.search.includes(term));
        });
        foeEmpty.hidden = visible().length > 0;
    });
    foeSearch.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault();
            const first = visible()[0];
            if (first) {
                choose(first);
            }
        }
    });
    foeDialog.querySelector('#foe-list').addEventListener('click', (event) => {
        const option = event.target.closest('[data-id]');
        if (option) {
            choose(option);
        }
    });
    foeDialog.querySelector('form').addEventListener(
        'submit',
        (event) => {
            if (foeValue.value === '') {
                event.preventDefault();
                event.stopImmediatePropagation();
                foeChosen.textContent = 'Bitte zuerst ein Monster wählen.';
            }
        },
        true
    );
}
