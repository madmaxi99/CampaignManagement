/*
 * Catalog list: filters the entries of the open category as you type and
 * scrolls the list to the open entry.
 */
const input = document.querySelector('[data-catalog-filter]');
const list = document.querySelector('[data-catalog-items]');

if (input && list) {
    const entries = Array.from(list.querySelectorAll('.outline__item'));
    const empty = list.querySelector('[data-catalog-empty]');

    input.addEventListener('input', () => {
        const needle = input.value.trim().toLowerCase();
        let shown = 0;
        entries.forEach((entry) => {
            const match = entry.textContent.toLowerCase().includes(needle);
            entry.hidden = !match;
            shown += match ? 1 : 0;
        });
        if (empty) {
            empty.hidden = shown > 0;
        }
    });

    // Only the list scrolls to the open entry, never the page around it.
    const current = list.querySelector('[aria-current="page"]');
    if (current && list.scrollHeight > list.clientHeight) {
        list.scrollTop +=
            current.getBoundingClientRect().top - list.getBoundingClientRect().top - list.clientHeight / 3;
    }
}
