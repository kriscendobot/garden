---
title: Modified files
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge
---

The change is **scoped to two files**:

- `packages/chat/index.css`:
  - Added new custom properties to `:root` (Step 1).
  - Replaced hardcoded color values with `var(--*)` references (Step 1).
  - Added `@media (prefers-color-scheme: dark)` block (Step 2).
  - Added `[data-scheme='dark']` explicit override block (Step 2).
  - Added scrollbar color overrides for dark schemes.
- `packages/chat/monaco-iframe-main.js`:
  - `detectTheme()` checks parent `data-scheme` attribute.
  - Listens for `set-theme` messages to update Monaco theme.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
