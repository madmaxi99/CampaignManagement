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
            body: JSON.stringify(body),
        }).then((response) => response.json());
    }

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
                // Clicking the last filled pip clears it; otherwise fill up to the clicked pip.
                const newValue = clickedIndex === current ? clickedIndex - 1 : clickedIndex;

                postJson(`/character/${slug}/${vital}`, { value: newValue }).then((data) => {
                    renderPips(tracker, data[`${vital}_current`]);
                });
            });
        });
    });

    document.querySelectorAll('.condition-chip').forEach((chip) => {
        chip.addEventListener('click', () => {
            const code = chip.dataset.conditionCode;

            postJson(`/character/${slug}/conditions/${code}/toggle`, {}).then((data) => {
                chip.classList.toggle('active', data.active);
            });
        });
    });
})();
