---
title: The dual-selector CSS pattern
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
notes: **Status: Complete** upstream. Depends on `chat-color-schemes.md` (the parent design that introduces light + dark schemes) and `chat-high-contrast-mode.md` (for the high-contrast variants); neither parent ingested yet. Extends the `scheme` field on `SpaceConfig` first referenced by [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] but not detailed there.
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application
---

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
