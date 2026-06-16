---
title: The picker layout
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

The scheme picker is a standalone component (`scheme-picker.js`)
constructed by `createSchemePicker({ $container, initialValue })`.
It presents an "Auto (follow system)" button above a 2×2 grid of
captioned preview cells. Each cell shows miniature chat bubbles
(received 👋, sent 🚀) rendered in the cell's own scheme colors —
giving the user a *visual preview* of each option rather than
abstract swatch chips.

```
  Color scheme
  [ Auto (follow system) ]
  ┌──────────────┐ ┌──────────────┐
  │  👋          │ │  👋          │
  │          🚀  │ │          🚀  │
  │    Light     │ │     Dark     │
  └──────────────┘ └──────────────┘
  ┌──────────────┐ ┌──────────────┐
  │  👋          │ │  👋          │
  │          🚀  │ │          🚀  │
  │ HC Light     │ │  HC Dark     │
  └──────────────┘ └──────────────┘
```

The preview-via-miniature-of-actual-content pattern is what makes
the picker self-documenting: the user does not need to know what
*"dark"* means in this UI's context because the cell shows it.
Compare to a hex-swatch picker or a labeled-button picker —
neither of those communicates "this is what your inbox will look
like."
