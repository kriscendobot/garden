---
title: Shared icon-selector extraction
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances
---

The icon-selector UI was previously duplicated between
`add-space-modal.js` and `edit-space-modal.js`. The design extracts
it to a new `icon-selector.js` module that exports:

| Export | Purpose |
|---|---|
| `ICON_CATEGORIES` | Hardened category-to-emoji map |
| `ALL_ICONS` | Hardened flat array of all icons |
| `letterIcon(letters)` | Truncates input to 2 uppercase chars (the letter-icon variant) |
| `renderIconSelector({ selectedIcon, useLetterIcon })` | Returns HTML string |

This is the *third extraction* in the chat client's recent
architectural history (the first two were the per-concern component
splits captured in
[[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]]).
The shared-module-as-extraction pattern is the chat client's
canonical way to *remove duplication* without prematurely abstracting.
