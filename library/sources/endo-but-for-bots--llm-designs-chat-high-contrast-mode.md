---
source: designs/chat-high-contrast-mode.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7706eefb443675838806fea0d209d7bb1359df83
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 2
status: current
notes: **Status: Complete** upstream. Depends on [[endo-but-for-bots--llm-designs-chat-color-schemes]] and [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme]]. Extends the `ColorScheme` enum from 3 to 5 values, introduces the **combined media query** `(prefers-color-scheme: dark) and (prefers-contrast: more)` for auto-dark-and-high-contrast, and applies the **shadows-to-borders substitution-of-channel** technique throughout high-contrast schemes. Ships *Complete* with 3 acknowledged follow-up gaps (WCAG AAA audit, focus-ring refinement, hover-state borders).
---

> Abstract: Accessibility extension to the Chat client's color-scheme system: adds `'high-contrast-light'` and `'high-contrast-dark'` to the `ColorScheme` enum, widens `'auto'` to respect `prefers-contrast: more` alongside `prefers-color-scheme`, and applies the **substitution of channel** technique (shadows become borders) so users with low vision read elevation cues reliably. The scheme picker grows to 5 options in a 2x2 grid plus full-width Auto button. Implementation is 4 ✅-completed steps modifying `index.css`, `spaces-gutter.js`, the two space modals, and creating `scheme-picker.js`. Three follow-up gaps remain documented for a future audit pass.

## Sections

| Section | Topics | Status |
|---|---|---|
| [scheme-extension-and-css-structure](../sections/endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-extension-and-css-structure.md) | chat-ui, patterns | current |
| [scheme-picker-integration-and-followups](../sections/endo-but-for-bots--llm-designs-chat-high-contrast-mode--scheme-picker-integration-and-followups.md) | chat-ui, patterns, agent-conventions | current |
