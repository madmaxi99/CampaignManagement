/*
 * Level-up: every decision is only staged here and sent together on "Speichern".
 */
import { sendJson, toastError } from './lib/http.js';

const page = document.querySelector('.levelup');
if (page) {
    init(page);
}

function init(root) {
    const id = root.dataset.id;
    const saveButton = document.getElementById('levelup-save');
    const counter = document.querySelector('[data-pending-count]');

    const pendingSkillDecisions = new Map();
    const pendingAbilityPicks = [];
    const pendingSpellIds = new Set();

    function updateCounter() {
        const count = pendingSkillDecisions.size + pendingAbilityPicks.length + pendingSpellIds.size;
        counter.textContent = String(count);
        counter.hidden = count === 0;
    }

    // Skills: segmented "Steigern" / "Verwerfen"
    root.querySelectorAll('[data-decision]').forEach(function (button) {
        button.addEventListener('click', function () {
            pendingSkillDecisions.set(button.dataset.skillId, button.dataset.decision === 'apply');
            button
                .closest('.segmented')
                .querySelectorAll('[data-decision]')
                .forEach(function (other) {
                    other.setAttribute('aria-pressed', other === button ? 'true' : 'false');
                });
            updateCounter();
        });
    });

    // Heroic abilities
    root.querySelectorAll('[data-learn-ability]').forEach(function (button) {
        button.addEventListener('click', function () {
            const row = button.closest('li');
            const select = row.querySelector('[data-school-select]');
            const pick = { heroic_ability_id: parseInt(button.dataset.learnAbility, 10) };
            if (select && select.value) {
                pick.school_skill_id = parseInt(select.value, 10);
            }
            pendingAbilityPicks.push(pick);
            button.disabled = true;
            button.textContent = 'Vorgemerkt';
            if (select) {
                select.disabled = true;
            }
            updateCounter();
        });
    });

    // Spells
    root.querySelectorAll('[data-learn-spell]').forEach(function (button) {
        button.addEventListener('click', function () {
            pendingSpellIds.add(parseInt(button.dataset.learnSpell, 10));
            button.disabled = true;
            button.textContent = 'Vorgemerkt';
            updateCounter();
        });
    });

    saveButton.addEventListener('click', function () {
        const requests = [];
        pendingSkillDecisions.forEach(function (apply, skillId) {
            requests.push(sendJson('POST', '/character/' + id + '/skills/' + skillId + '/advance', { apply: apply }));
        });
        pendingAbilityPicks.forEach(function (pick) {
            requests.push(sendJson('POST', '/character/' + id + '/heroic-abilities', pick));
        });
        pendingSpellIds.forEach(function (spellId) {
            requests.push(sendJson('POST', '/character/' + id + '/spells', { spell_id: spellId }));
        });

        saveButton.disabled = true;
        Promise.all(requests)
            .then(function () {
                window.location.href = '/character/' + id;
            })
            .catch(function (error) {
                saveButton.disabled = false;
                toastError(error);
            });
    });
}
