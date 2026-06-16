---
title: Mounted into two modals
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

The picker is mounted into both the add-space modal and the
edit-space modal via a `#scheme-picker-slot` div:

| Modal | Mount surface | Use |
|---|---|---|
| `add-space-modal.js` | `#scheme-picker-slot` inside the form | Picks a scheme for a *new* space |
| `edit-space-modal.js` | `#scheme-picker-slot` inside the form | Edits the scheme on an *existing* space |

The shared-slot-id discipline is what lets one picker factory serve
both modals — the picker doesn't know which modal hosts it; it
just mounts into whatever container is named.

This is the same shared-affordance discipline as the cycle-57
`icon-selector.js` extraction (see
[[endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances]]):
identify the duplicated UI element, extract to its own component,
mount via a slot. The chat client now has at least two such
extracted shared components (icon-selector + scheme-picker); a
*third* would warrant a `shared-affordances/` subdirectory.
