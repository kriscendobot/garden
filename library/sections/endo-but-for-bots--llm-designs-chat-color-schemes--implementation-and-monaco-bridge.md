---
title: 4-step rollout, dual selector for explicit override, and Monaco iframe theme bridge
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
kind: index
section_count: 4
---

> Abstract: The implementation rolls out in **four ✅-completed steps**: (1) add new custom properties to the light theme and replace hardcoded references; (2) add the `@media (prefers-color-scheme: dark)` block **plus a duplicate `[data-scheme='dark']` attribute selector** so per-space overrides can force a scheme regardless of system preference (the [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application]] dual-selector pattern was prefigured here); (3) override sent-bubble colors with brand burgundy in dark mode; (4) bridge Monaco editor theme via a `set-theme` postMessage to the iframe child (`endo-light` ↔ `endo-dark`). The change is scoped to **two files**: `packages/chat/index.css` (the bulk of the work) and `packages/chat/monaco-iframe-main.js` (the iframe bridge). Testing is 6 scenarios across light/dark, error legibility, code syntax contrast, modal backdrops, tooltips, and Monaco theme switching.

Sections:

- [The 4 rollout steps](endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge--the-4-rollout-steps.md)
- [Modified files](endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge--modified-files.md)
- [Testing scenarios (6, all completed)](endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge--testing-scenarios-6-all-completed.md)
- [Follow-up designs and work](endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge--follow-up-designs-and-work.md)

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
