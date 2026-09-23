---
title: Five scheme values
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
