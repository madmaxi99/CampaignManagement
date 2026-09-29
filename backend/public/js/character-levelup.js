(function () {
    const root = document.querySelector('.levelup');
    if (!root) {
        return;
    }

    const id = root.dataset.id;

    function postJson(path, body) {
        return fetch(path, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body || {}),
        }).then((response) => response.json());
    }

    // --- Skills: stage apply/discard, nothing sent until Speichern ---

    const pendingSkillDecisions = new Map();

    document.querySelectorAll('.levelup-skill-decision').forEach((button) => {
        button.addEventListener('click', () => {
            const skillId = button.dataset.skillId;
            pendingSkillDecisions.set(skillId, button.dataset.decision === 'apply');

            const row = button.closest('li');
            row.querySelectorAll('.levelup-skill-decision').forEach((sibling) => {
                sibling.classList.toggle('active', sibling === button);
            });
        });
    });

    // --- Heroic abilities: stage a pick per row, disable that row afterwards ---

    const pendingAbilityPicks = [];

    document.querySelectorAll('.levelup-learn-ability').forEach((button) => {
        button.addEventListener('click', () => {
            const row = button.closest('li');
            const select = row.querySelector('.levelup-school-select');
            const pick = { heroic_ability_id: parseInt(button.dataset.abilityId, 10) };
            if (select && select.value) {
                pick.school_skill_id = parseInt(select.value, 10);
            }
            pendingAbilityPicks.push(pick);

            button.disabled = true;
            button.textContent = 'Vorgemerkt';
            if (select) {
                select.disabled = true;
            }
        });
    });

    // --- Spells: stage a pick per row, disable that row afterwards ---

    const pendingSpellIds = new Set();

    document.querySelectorAll('.levelup-learn-spell').forEach((button) => {
        button.addEventListener('click', () => {
            pendingSpellIds.add(parseInt(button.dataset.spellId, 10));
            button.disabled = true;
            button.textContent = 'Vorgemerkt';
        });
    });

    // --- Save: apply every staged change, then back to the sheet ---

    document.getElementById('levelup-save').addEventListener('click', () => {
        const requests = [];

        pendingSkillDecisions.forEach((apply, skillId) => {
            requests.push(postJson(`/character/${id}/skills/${skillId}/advance`, { apply }));
        });

        pendingAbilityPicks.forEach((pick) => {
            requests.push(postJson(`/character/${id}/heroic-abilities`, pick));
        });

        pendingSpellIds.forEach((spellId) => {
            requests.push(postJson(`/character/${id}/spells`, { spell_id: spellId }));
        });

        Promise.all(requests).then(() => {
            window.location.href = `/character/${id}`;
        });
    });
})();
