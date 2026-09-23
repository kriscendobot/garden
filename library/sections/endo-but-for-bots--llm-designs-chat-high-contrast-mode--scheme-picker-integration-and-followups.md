---
title: Scheme picker extended to 5 options, 4-step implementation, 3 follow-up gaps
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
topics: [chat-ui, patterns, agent-conventions]
status: current
kind: index
section_count: 5
---

> Abstract: The scheme picker from [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component]] grows from 4 cells (`Auto` + `Light`/`Dark` cells in a 2x1 row, then 2x2 with this design) to a **5-option unified layout**: a full-width "Auto (follow system)" button above a **2x2 grid** of captioned preview cells (Light, Dark, HC Light, HC Dark). High-contrast cells render preview borders and contrast treatments so the user sees a faithful sample before commit. Explicitly **no separate "Auto" for high contrast** — `auto` defers to the system for both `prefers-color-scheme` and `prefers-contrast` axes. Implementation is **4 ✅-completed steps** modifying `index.css` (high-contrast token blocks, media-query rules, `data-scheme` selectors), `spaces-gutter.js` (`ColorScheme` typedef, `validateSpaceConfig`, `applyScheme`), `add-space-modal.js`, `edit-space-modal.js`, and creating `scheme-picker.js` with high-contrast preview cells. Three follow-up gaps remain: WCAG AAA audit not done, focus-ring overrides not added, hover-border policy not applied to all interactive elements.

Sections:

- [Scheme picker layout (5 options)](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups--scheme-picker-layout-5-options.md)
- [Implementation (4 steps, all ✅ completed)](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups--implementation-4-steps-all-completed.md)
- [Modified files](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups--modified-files.md)
- [Testing (5 scenarios, all completed)](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups--testing-5-scenarios-all-completed.md)
- [Three acknowledged follow-up gaps](endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups--three-acknowledged-follow-up-gaps.md)

Source: [designs/chat-high-contrast-mode.md](https://github.com/endojs/endo-but-for-bots/blob/7706eefb443675838806fea0d209d7bb1359df83/designs/chat-high-contrast-mode.md) at commit `7706eefb`.
