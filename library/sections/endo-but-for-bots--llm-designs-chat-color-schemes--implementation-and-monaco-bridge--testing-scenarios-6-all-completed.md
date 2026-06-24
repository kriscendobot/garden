---
title: Testing scenarios (6, all completed)
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

1. ~~Verify light mode is visually unchanged after Step 1.~~ ✅
2. ~~Toggle macOS Appearance to Dark and verify dark mode renders.~~ ✅
3. ~~Verify error states (red badges, error tooltips) are legible in both modes.~~ ✅
4. ~~Verify code syntax highlighting contrast in both modes.~~ ✅
5. ~~Verify modal backdrops and tooltips in both modes.~~ ✅
6. ~~Verify Monaco editor theme switches with system preference.~~ ✅

The Step-1-is-visually-invisible scenario is the most important: it forces the migration to be *colorimetrically faithful* before any dark mode work begins. If Step 1 changes light-mode rendering, a token was either renamed wrong or assigned a wrong value, and the regression is caught before the dark-mode work compounds it. This is the **mechanical-refactor-then-feature** discipline applied to a CSS migration: do the rename pass first, verify the rename is null, then add the feature on top.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
