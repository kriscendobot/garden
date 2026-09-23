---
title: Files modified
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

| File | Change |
|---|---|
| `packages/chat/icon-selector.js` | **New** — shared icon selector module. |
| `packages/chat/add-space-modal.js` | Import shared icon selector; remove duplicates. |
| `packages/chat/edit-space-modal.js` | Import shared icon selector; add `showName` option. |
| `packages/chat/spaces-gutter.js` | Home config storage / loading; context menu; wiring. |
| `packages/chat/test/component/spaces-gutter-home.test.js` | **New** — component tests. |
