/**
 * JSON request to the app. Resolves with the parsed answer ({} when there is
 * none) and rejects with the server's error message, or a generic one.
 */
export async function sendJson(method, url, body) {
    const options = { method };
    if (body !== undefined) {
        options.headers = { 'Content-Type': 'application/json' };
        options.body = JSON.stringify(body);
    }

    const response = await fetch(url, options);
    const data = await response.json().catch(() => ({}));
    if (!response.ok) {
        throw new Error(data.error || 'Das hat nicht geklappt.');
    }

    return data;
}

export function toastError(error) {
    window.ui.toast(error && error.message ? error.message : 'Das hat nicht geklappt.', 'error');
}
