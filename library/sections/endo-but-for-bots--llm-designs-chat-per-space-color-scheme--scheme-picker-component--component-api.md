---
title: Component API
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component
---

The hardened API:

| Method | Purpose |
|---|---|
| `getValue()` | Returns the current `ColorScheme`. |
| `setValue(scheme)` | Update selection programmatically. |
| `onChange(callback)` | Register a change listener (fires on cell selection). |
| `restoreScheme()` | Restore the scheme from before picker creation (undo all previews). |

The four-method API is deliberately small. There is no
`applyScheme()` on the API — that's a module-internal side effect
of `setValue` and the cell-click handler. The caller cannot ask
the picker to apply a scheme other than the one it's showing; if
the caller wants to apply a scheme independently, it imports
`applyScheme` from `spaces-gutter.js`.
