/**
 * The characters this browser "owns" (shown first in the list), kept in
 * localStorage as a list of id strings. Storage may be unavailable (private
 * mode), then nothing is remembered and nothing breaks.
 */
const STORAGE_KEY = 'trpg.myCharacters';

export function loadMine() {
    try {
        const ids = JSON.parse(window.localStorage.getItem(STORAGE_KEY) || '[]');
        return Array.isArray(ids) ? ids.map(String) : [];
    } catch {
        return [];
    }
}

export function saveMine(ids) {
    try {
        window.localStorage.setItem(STORAGE_KEY, JSON.stringify(ids));
    } catch {
        // Not remembered, which is fine.
    }
}

export function remember(id) {
    saveMine(loadMine().concat(String(id)));
}

export function forget(id) {
    saveMine(loadMine().filter((other) => other !== String(id)));
}
