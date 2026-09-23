---
title: Three acknowledged follow-up gaps
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups
---

The design names three open gaps despite shipping:

- **WCAG AAA contrast audit**: The token values were chosen to increase contrast but have not been systematically verified against WCAG AAA (7:1) ratios for every text/background combination. A dedicated audit with a contrast checker tool would confirm compliance.
- **Focus ring refinement**: The design calls for `3px solid outline + offset` focus rings in high-contrast. The current implementation sets `box-shadow` to `none` but does not add explicit focus ring overrides. Elements using `box-shadow` for focus indication may lose visibility.
- **Hover state borders**: The design specifies hover states should gain a border in addition to the background tint. This has not been explicitly added for all interactive elements.

The pattern of **shipping with acknowledged gaps recorded in the design** is consistent with [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco]] and other shipped chat designs: a follow-up list inline with the *Complete* status keeps roadmap shape visible.

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.
