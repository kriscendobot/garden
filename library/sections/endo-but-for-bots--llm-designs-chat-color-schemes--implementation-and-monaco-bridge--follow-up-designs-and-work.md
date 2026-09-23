---
title: Follow-up designs and work
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

The chat color-scheme story extends into two follow-up designs (both completed upstream):

1. [chat-per-space-color-scheme](../sources/endo-but-for-bots--llm-designs-chat-per-space-color-scheme.md) — Add `scheme` to `SpaceConfig` so the user can override the system preference per space; lift the `data-scheme` attribute system to a 5-value enum.
2. [chat-high-contrast-mode](../sources/endo-but-for-bots--llm-designs-chat-high-contrast-mode.md) — Add `'high-contrast-light'` and `'high-contrast-dark'` scheme values; respond to `prefers-contrast: more`; replace shadows with borders in high-contrast.

Open follow-up work:

- **Contrast audit**: Verify all text and interactive elements meet WCAG AA (4.5:1) contrast ratios in both light and dark modes. Some hardcoded colors in inline styles or third-party content may not have been parameterized.
- **Print styles**: Dark mode variables are not suppressed in print media; a `@media print` block could force light values.

Source: [designs/chat-color-schemes.md](https://github.com/endojs/endo-but-for-bots/blob/4e7e623ef841f5d23f985bc57386195c93a709af/designs/chat-color-schemes.md) at commit `4e7e623e`.
