/* DM party page: the dialog for picking a character, with a search box. */
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
