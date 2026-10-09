import { JSDOM } from 'jsdom';
import { pathToFileURL } from 'node:url';
import path from 'node:path';

const PUBLIC_JS = path.resolve(import.meta.dirname, '../../public/js');
let loadCounter = 0;

/**
 * Lets a page script run against a jsdom page: its globals (document, window,
 * fetch, ...) are installed on globalThis and the file is imported fresh.
 *
 * @param {string} file path of the script, relative to public/js
 * @param {{html: string, fetch?: Function, confirm?: boolean, url?: string, beforeLoad?: (window: Window) => void}} options
 */
export async function loadPage(
    file,
    { html, fetch = notFound, confirm = true, url = 'http://localhost/', beforeLoad = () => {} }
) {
    const dom = new JSDOM(`<!doctype html><body>${html}</body>`, { url });
    const win = dom.window;
    beforeLoad(win);

    const location = { href: url, reloads: 0, reload: () => (location.reloads += 1) };
    const toasts = [];
    const fakeWindow = new Proxy(win, {
        get(target, key) {
            if (key === 'location') return location;
            if (key === 'fetch') return fetch;
            if (key === 'ui') {
                return {
                    toast: (message, kind = 'info') => toasts.push({ message, kind }),
                    confirm: () => Promise.resolve(confirm),
                };
            }
            const value = Reflect.get(target, key);
            return typeof value === 'function' ? value.bind(target) : value;
        },
    });

    Object.assign(globalThis, {
        window: fakeWindow,
        document: win.document,
        fetch,
        FormData: win.FormData,
        File: win.File,
        DOMParser: win.DOMParser,
        HTMLElement: win.HTMLElement,
        Element: win.Element,
    });

    await import(`${pathToFileURL(path.join(PUBLIC_JS, file)).href}?load=${(loadCounter += 1)}`);

    return { document: win.document, window: win, location, toasts };
}

/** Records every request; `routes` maps "METHOD /path" to a body or a function returning one. */
export function fakeFetch(routes = {}) {
    const calls = [];
    const fetch = async (url, options = {}) => {
        const method = options.method || 'GET';
        const call = {
            method,
            url: String(url),
            body: typeof options.body === 'string' ? JSON.parse(options.body) : options.body,
        };
        calls.push(call);

        const route = routes[`${method} ${call.url}`];
        const result = typeof route === 'function' ? route(call) : (route ?? {});
        const status = result.status ?? 200;

        return {
            ok: status >= 200 && status < 300,
            status,
            json: async () => result.json ?? result,
            text: async () => result.text ?? '',
        };
    };
    fetch.calls = calls;

    return fetch;
}

function notFound() {
    return Promise.reject(new Error('unexpected fetch'));
}

/** Waits until pending promises and zero-delay timers have run. */
export async function flush() {
    for (let i = 0; i < 5; i += 1) {
        await new Promise((resolve) => setTimeout(resolve, 0));
    }
}

function fire(element, type) {
    const view = element.ownerDocument.defaultView;
    element.dispatchEvent(new view.Event(type, { bubbles: true }));
}

/** Checks or unchecks a checkbox/radio, or sets a field value, and fires "change". */
export function change(element, value) {
    if (element.type === 'checkbox' || element.type === 'radio') {
        element.checked = value ?? true;
    } else if (value !== undefined) {
        element.value = value;
    }
    fire(element, 'change');
}

/** Sets a field value and fires "input", like typing. */
export function type(element, value) {
    element.value = value;
    fire(element, 'input');
}

export function click(element) {
    const view = element.ownerDocument.defaultView;
    element.dispatchEvent(new view.MouseEvent('click', { bubbles: true, cancelable: true }));
}
