---
title: Seven shipped implementation steps
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco
---

The design records seven steps, all marked complete (`✅`):

| Step | What |
|---|---|
| 1 | Restructure CSS for attribute-based override (the dual-selector pattern from the sibling section) |
| 2 | Add `scheme` to `SpaceConfig` (typedef + `validateSpaceConfig` + `applyScheme` in the selection handler) |
| 3 | Factor out scheme-picker component (the standalone factory described in the sibling section) |
| 4 | Add scheme picker to add-space modal |
| 5 | Add edit-space modal (a new modal; see [[endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances]]) |
| 6 | Add `updateSpace(id, updates)` to spaces gutter API |
| 7 | Monaco editor theme updates via post-message bridge |

The seven steps were sequenced so each could ship independently
(restructure CSS first; everything else can ride on the restructure).
