/* Small markup helpers shared by the wizard steps. */

export function escapeHtml(value) {
    return String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

export function descriptionLine(text) {
    return text ? `<p class="wizard-choice-detail">${text}</p>` : '';
}

export const checked = (condition) => (condition ? 'checked' : '');
export const disabled = (condition) => (condition ? 'disabled' : '');

/** A big selectable card around a radio input. */
export function choiceCard({ name, value, selected, compact = false, content }) {
    const classes = [
        'wizard-choice',
        compact ? 'wizard-choice--compact' : '',
        selected ? 'wizard-choice--selected' : '',
    ]
        .filter(Boolean)
        .join(' ');

    return `
        <label class="${classes}">
            <input type="radio" name="${name}" value="${value}" ${checked(selected)}>
            ${content}
        </label>
    `;
}

export function choiceHead(title, meta = '') {
    return `
        <div class="wizard-choice-head">
            <span class="wizard-choice-title">${title}</span>
            ${meta ? `<span class="wizard-choice-meta">${meta}</span>` : ''}
        </div>
    `;
}

/** A compact row with an input of any type; `attributes` are extra input attributes. */
export function inlineChoice({ type, name = '', className = '', value, isChecked, isDisabled = false, content }) {
    const nameAttribute = name ? ` name="${name}"` : '';
    const classAttribute = className ? ` class="${className}"` : '';

    return `
        <label class="wizard-choice-inline">
            <input type="${type}"${nameAttribute}${classAttribute} value="${value}" ${checked(isChecked)} ${disabled(isDisabled)}>
            ${content}
        </label>
    `;
}

/** The back/forward buttons at the bottom of a step. */
export function navigation({ first = false, nextId = 'next-step', nextLabel = 'Weiter', enabled = true }) {
    return `
        <div class="wizard-nav">
            ${first ? '<span></span>' : '<button type="button" id="prev-step">Zurück</button>'}
            <button type="button" id="${nextId}" ${disabled(!enabled)}>${nextLabel}</button>
        </div>
    `;
}
