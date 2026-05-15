---
title: Five scheme values, `data-scheme` attribute, and the dual-selector CSS pattern
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
notes: **Status: Complete** upstream. Depends on `chat-color-schemes.md` (the parent design that introduces light + dark schemes) and `chat-high-contrast-mode.md` (for the high-contrast variants); neither parent ingested yet. Extends the `scheme` field on `SpaceConfig` first referenced by [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] but not detailed there.
---

## Five scheme values

```js
/**
 * @typedef {'auto' | 'light' | 'dark' | 'high-contrast-light' | 'high-contrast-dark'} ColorScheme
 */
```

| Value | What it means |
|---|---|
| `'auto'` | Defer to the system's `prefers-color-scheme` media query (default). |
| `'light'` | Force the light scheme from `chat-color-schemes.md`. |
| `'dark'` | Force the dark scheme from `chat-color-schemes.md`. |
| `'high-contrast-light'` | High-contrast light variant from `chat-high-contrast-mode.md`. |
| `'high-contrast-dark'` | High-contrast dark variant from `chat-high-contrast-mode.md`. |

The `auto` value (or `undefined`) means *follow system preference*.
The other four are explicit per-space overrides.

## Application via `data-scheme` attribute

When a space is selected, the scheme is applied by setting a
`data-scheme` attribute on the document root element:

```js
const applyScheme = (scheme) => {
  if (scheme === 'auto' || scheme === undefined) {
    document.documentElement.removeAttribute('data-scheme');
  } else {
    document.documentElement.setAttribute('data-scheme', scheme);
  }
};
```

The attribute's *absence* means "auto" (let the media query
govern). The attribute's *presence* with one of the four explicit
values forces that scheme.

## The dual-selector CSS pattern

The CSS from `chat-color-schemes.md` is restructured so the dark
values are defined in **both** a media query and an attribute
selector, with a `:not()` clause to keep them mutually exclusive:

```css
/* System preference (auto) */
@media (prefers-color-scheme: dark) {
  :root:not([data-scheme="light"]) {
    /* dark values */
  }
}

/* Explicit dark override */
:root[data-scheme="dark"] {
  /* dark values */
}
```

The three behaviors fall out of the combination:

| `data-scheme` | System preference | Effective scheme |
|---|---|---|
| (absent) | light | light (media query inactive) |
| (absent) | dark | dark (media query active) |
| `"light"` | (either) | light (media query active but `:not(light)` clause excludes) |
| `"dark"` | (either) | dark (attribute selector forces) |

The pattern is a worked example of **single source of truth across
two activation mechanisms** — the dark values are written once, in
two selectors that together cover the four `(data-scheme,
system-preference)` cells. This is the chat-UI counterpart of the
[[sentinel-with-rationale]] discipline applied to CSS: the `:not()`
clause's *why* (mutual exclusion with the explicit-light override)
licenses the otherwise-redundant-looking dual selector.

## Why this design exists separately

The parent design `chat-color-schemes.md` introduces the schemes
themselves (light + dark, driven by media query); this design adds
the **per-space override mechanism** on top. The split keeps the
*what is a dark scheme* question separate from the *who decides
which scheme applies* question:

- *What* — `chat-color-schemes.md` (not yet ingested).
- *Who* — this design.

The high-contrast variants from `chat-high-contrast-mode.md` (also
not yet ingested) integrate via the same `data-scheme` mechanism:
the variant names become two more attribute values; no further
machinery is needed.
