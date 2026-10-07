/* Rules reference: one search box filters the entries of every tab. */
const search = document.getElementById('rules-search');
if (search) {
    init(search);
}

function init(input) {
    const empty = document.querySelector('[data-rules-empty]');

    function apply() {
        const query = input.value.trim().toLowerCase();
        document.querySelectorAll('[data-search]').forEach(function (entry) {
            entry.hidden = query !== '' && !entry.dataset.search.includes(query);
        });

        const panel = document.querySelector('.ui-tabpanel:not([hidden])');
        const hasHit =
            !panel ||
            Array.from(panel.querySelectorAll('[data-search]')).some(function (entry) {
                return !entry.hidden;
            });
        empty.hidden = hasHit;
    }

    input.addEventListener('input', apply);
    document.querySelectorAll('.ui-tab').forEach(function (tab) {
        tab.addEventListener('click', function () {
            window.setTimeout(apply, 0);
        });
    });
}
