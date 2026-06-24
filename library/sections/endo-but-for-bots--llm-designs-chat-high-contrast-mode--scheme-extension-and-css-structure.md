---
title: ColorScheme enum extension, high-contrast adjustments, and combined-media-query CSS structure
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
kind: index
section_count: 4
---

> Abstract: High-contrast mode extends the `ColorScheme` enum from 3 values (`'auto' | 'light' | 'dark'`) to **5 values** by adding `'high-contrast-light'` and `'high-contrast-dark'`. The `'auto'` semantics widen to **respect `prefers-contrast: more` in combination with `prefers-color-scheme`**: auto + standard contrast → light or dark; auto + `prefers-contrast: more` → high-contrast-light or high-contrast-dark. The high-contrast adjustments table specifies 7 properties that differ from the base scheme (border width, text contrast ratio AA → AAA, focus rings, muted text, hover states, shadows, backdrop opacity). The CSS structure uses the same **dual-selector pattern** as [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]] but now with a **3-way combined media query** (`prefers-color-scheme: dark` AND `prefers-contrast: more`) to handle the auto-dark-and-high-contrast case.

Sections:

- [ColorScheme enum extension](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure--colorscheme-enum-extension.md)
- [High-contrast adjustments (vs. the base scheme)](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure--high-contrast-adjustments-vs-the-base-scheme.md)
- [CSS structure: combined media queries](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure--css-structure-combined-media-queries.md)
- [High-contrast token values](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure--high-contrast-token-values.md)

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.
