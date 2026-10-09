/*
 * Character creation wizard: nine steps built from the catalog the server
 * hands out (data-catalog-url), submitted as one POST /characters.
 */
import { sendJson } from '../lib/http.js';
import { remember } from '../lib/my-characters.js';
import { STEP_TITLES } from './config.js';
import { attachHandlers } from './handlers.js';
import { escapeHtml } from './html.js';
import { applyDefaults, buildPayload, createState, visibleSteps } from './rules.js';
import { renderStep } from './steps.js';

const wizard = document.querySelector('.wizard');
if (wizard) {
    start(wizard);
}

async function start(root) {
    const catalog = await fetch(root.dataset.catalogUrl).then((response) => response.json());
    const state = createState();

    function render() {
        applyDefaults(state, catalog);
        const steps = visibleSteps(state, catalog);
        const position = steps.indexOf(state.step) + 1;
        const stepper = steps
            .map((step, index) => {
                const done = index < position - 1;
                const current = index === position - 1;
                const classes = `ui-step${done ? ' ui-step--done' : ''}${current ? ' ui-step--current' : ''}`;

                return `<li class="${classes}"${current ? ' aria-current="step"' : ''}>${done ? '&#10003;' : index + 1}</li>`;
            })
            .join('');

        root.innerHTML = `
            <div class="wizard-step">
                <ol class="ui-stepper" aria-label="Fortschritt">${stepper}</ol>
                <p class="wizard-progress">Schritt ${position} von ${steps.length} &middot; ${STEP_TITLES[state.step]}</p>
                ${state.error ? `<p class="wizard-error">${escapeHtml(state.error)}</p>` : ''}
                ${renderStep(state, catalog)}
            </div>
        `;
        applyDesignSystem(root);
        attachHandlers(root, { state, catalog, render, goRelative, submit });
    }

    function goRelative(delta) {
        const steps = visibleSteps(state, catalog);
        const target = steps[steps.indexOf(state.step) + delta];
        if (target !== undefined) {
            state.step = target;
            state.error = '';
            render();
        }
    }

    async function submit() {
        state.appearanceDe = document.getElementById('appearance-input').value;
        try {
            const data = await sendJson('POST', '/characters', buildPayload(state, catalog));
            // A character made here is "mine" in this browser (see characters-list.js).
            remember(data.id);
            window.location.href = `/character/${data.id}`;
        } catch (error) {
            state.error = error.message;
            render();
        }
    }

    render();
}

// The step markup is built as strings; give its controls the design-system classes.
function applyDesignSystem(root) {
    root.querySelectorAll('.wizard-nav button').forEach((button) => {
        button.classList.add('ui-btn');
        if (button.id === 'prev-step') {
            button.classList.add('ui-btn--ghost');
        }
    });
    root.querySelectorAll('#swap-button').forEach((button) =>
        button.classList.add('ui-btn', 'ui-btn--small', 'ui-btn--gold')
    );
    root.querySelectorAll('input[type="text"], input[type="number"]').forEach((input) =>
        input.classList.add('ui-input')
    );
    root.querySelectorAll('textarea').forEach((textarea) => textarea.classList.add('ui-textarea'));
    root.querySelectorAll('select').forEach((select) => select.classList.add('ui-select'));
}
