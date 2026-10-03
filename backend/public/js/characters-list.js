/*
 * Character list: "Meine Charaktere" (remembered in this browser) on top,
 * everything else as a searchable archive.
 */
(function () {
    'use strict';

    const STORAGE_KEY = 'trpg.myCharacters';
    const mineList = document.querySelector('[data-mine]');
    const archiveList = document.querySelector('[data-archive]');
    if (!mineList || !archiveList) {
        return;
    }

    const mineEmpty = document.querySelector('[data-mine-empty]');
    const archiveEmpty = document.querySelector('[data-archive-empty]');
    const searchInput = document.getElementById('char-search');
    const filterTabs = Array.from(document.querySelectorAll('[data-filter-value]'));
    let filter = 'all';

    function loadMine() {
        try {
            const ids = JSON.parse(window.localStorage.getItem(STORAGE_KEY) || '[]');
            return Array.isArray(ids) ? ids.map(String) : [];
        } catch (error) {
            return [];
        }
    }

    function saveMine(ids) {
        try {
            window.localStorage.setItem(STORAGE_KEY, JSON.stringify(ids));
        } catch (error) {
            // Private mode etc.: the list just is not remembered.
        }
    }

    let mine = loadMine();

    function insertSorted(list, card) {
        const name = card.dataset.name;
        const next = Array.from(list.children).find((other) => other.dataset.name.localeCompare(name, 'de') > 0);
        list.insertBefore(card, next || null);
    }

    function place(card) {
        const pinned = mine.includes(card.dataset.charId);
        const pin = card.querySelector('[data-pin]');
        pin.setAttribute('aria-pressed', pinned ? 'true' : 'false');
        pin.setAttribute('aria-label', pinned ? 'Aus meinen Charakteren entfernen' : 'Zu meinen Charakteren hinzufügen');
        card.classList.toggle('char-card--mine', pinned);
        insertSorted(pinned ? mineList : archiveList, card);
    }

    function applyFilter() {
        const query = searchInput.value.trim().toLowerCase();
        let visible = 0;

        Array.from(archiveList.children).forEach((card) => {
            const matchesText = query === '' || card.dataset.search.includes(query);
            const matchesFilter = filter === 'all' || (filter === 'default') === (card.dataset.default === '1');
            const show = matchesText && matchesFilter;
            card.hidden = !show;
            visible += show ? 1 : 0;
        });

        archiveEmpty.hidden = visible > 0;
        mineEmpty.hidden = mineList.children.length > 0;
    }

    document.querySelectorAll('.char-card').forEach(place);
    applyFilter();

    document.addEventListener('click', (event) => {
        const pin = event.target.closest('[data-pin]');
        if (!pin) {
            return;
        }
        const card = pin.closest('.char-card');
        const id = card.dataset.charId;
        mine = mine.includes(id) ? mine.filter((other) => other !== id) : mine.concat(id);
        saveMine(mine);
        place(card);
        applyFilter();
    });

    searchInput.addEventListener('input', applyFilter);

    filterTabs.forEach((tab) => {
        tab.addEventListener('click', () => {
            filter = tab.dataset.filterValue;
            filterTabs.forEach((other) => other.setAttribute('aria-selected', other === tab ? 'true' : 'false'));
            applyFilter();
        });
    });
}());
