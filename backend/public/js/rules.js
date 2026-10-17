/*
 * Rules reference: one search box filters the entries of every tab. All words
 * must occur (umlauts and ß are folded, so "maerchen" finds "Märchen"). Tabs
 * show their hit count, headings without a visible entry are hidden, and a
 * short hit list is opened so the matching text is visible right away.
 */
const search = document.getElementById('rules-search');
if (search) {
    init(search);
}

const AUTO_OPEN_MAX_HITS = 5;

const FOLDS = { ä: 'ae', ö: 'oe', ü: 'ue', ß: 'ss' };

function fold(text) {
    return text.toLowerCase().replace(/[äöüß]/g, (char) => FOLDS[char]);
}

function init(input) {
    const empty = document.querySelector('[data-rules-empty]');
    const tabs = Array.from(document.querySelectorAll('.ui-tab'));
    const haystacks = new WeakMap();
    const autoOpened = new Set();

    function haystack(entry) {
        if (!haystacks.has(entry)) {
            haystacks.set(entry, fold(entry.dataset.search));
        }

        return haystacks.get(entry);
    }

    function entriesOf(node) {
        return node.matches('[data-search]') ? [node] : Array.from(node.querySelectorAll('[data-search]'));
    }

    // Hides the h2 headings of a panel whose entries are all filtered out.
    function updateHeadings(panel, active) {
        let heading = null;
        let hasEntry = false;
        let hasVisible = false;

        function close() {
            if (heading) {
                heading.hidden = active && hasEntry && !hasVisible;
            }
        }

        Array.from(panel.children).forEach(function (child) {
            if (child.tagName === 'H2') {
                close();
                heading = child;
                hasEntry = false;
                hasVisible = false;

                return;
            }
            const entries = entriesOf(child);
            hasEntry = hasEntry || entries.length > 0;
            hasVisible = hasVisible || entries.some((entry) => !entry.hidden);
        });
        close();
    }

    function updateBadge(tab, hits, active) {
        let badge = tab.querySelector('[data-rules-hits]');
        if (!active) {
            badge?.remove();

            return;
        }
        if (!badge) {
            badge = document.createElement('span');
            badge.className = 'ui-badge';
            badge.dataset.rulesHits = '';
            tab.appendChild(badge);
        }
        badge.textContent = String(hits);
    }

    function apply() {
        const words = fold(input.value).split(/\s+/).filter(Boolean);
        const active = words.length > 0;

        autoOpened.forEach(function (entry) {
            entry.open = false;
        });
        autoOpened.clear();

        const hits = [];
        document.querySelectorAll('[data-search]').forEach(function (entry) {
            const matches = !active || words.every((word) => haystack(entry).includes(word));
            entry.hidden = !matches;
            if (active && matches) {
                hits.push(entry);
            }
        });

        if (active && hits.length <= AUTO_OPEN_MAX_HITS) {
            hits.forEach(function (entry) {
                if (entry.tagName === 'DETAILS' && !entry.open) {
                    entry.open = true;
                    autoOpened.add(entry);
                }
            });
        }

        document.querySelectorAll('.ui-tabpanel').forEach(function (panel) {
            updateHeadings(panel, active);
            const tab = tabs.find((candidate) => candidate.getAttribute('aria-controls') === panel.id);
            if (tab) {
                updateBadge(tab, panel.querySelectorAll('[data-search]:not([hidden])').length, active);
            }
        });

        const panel = document.querySelector('.ui-tabpanel:not([hidden])');
        const hasHit = !active || !panel || panel.querySelector('[data-search]:not([hidden])') !== null;
        empty.hidden = hasHit;
    }

    input.addEventListener('input', apply);
    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            window.setTimeout(apply, 0);
        });
    });
}
