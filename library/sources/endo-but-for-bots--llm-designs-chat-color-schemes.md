---
source: designs/chat-color-schemes.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 4e7e623ef841f5d23f985bc57386195c93a709af
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 3
status: current
notes: **Status: Complete** upstream. The *parent* of [[endo-but-for-bots--llm-designs-chat-per-space-color-scheme]] (which adds per-space override) and [[endo-but-for-bots--llm-designs-chat-high-contrast-mode]] (which extends the scheme enum). The interesting library artifact is the dark-mode palette derivation from the **endojs.org brand** plus the per-token rationale table, which together make the palette auditable. The implementation introduces the **dual-selector pattern** (`@media (prefers-color-scheme: dark)` + `:root[data-scheme='dark']`) that the per-space-color-scheme design generalizes to all 5 scheme values.
---

> Abstract: The dark-mode story for the Chat client: parameterize ~94 hardcoded colors in `index.css` into ~25 new CSS custom properties, introduce a dark `:root` block whose values are **derived from the endojs.org brand palette** (burgundy `#BB2D40` for accent, orange-to-coral gradient for code-syntax accent, warm dark grays for backgrounds), respect `prefers-color-scheme`, and bridge the Monaco editor's iframe boundary via a `set-theme` postMessage. The implementation is a 4-step rollout where **Step 1 is visually invisible** (the rename pass before the feature pass), with the dual-selector pattern (`@media` + `[data-scheme]`) landing in Step 2 to enable explicit per-space override.

## Sections

| Section | Topics | Status |
|---|---|---|
| [motivation-and-current-state](../sections/endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state.md) | chat-ui, patterns | current |
| [dark-mode-palette-and-rationale](../sections/endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale.md) | chat-ui, patterns | current |
| [implementation-and-monaco-bridge](../sections/endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge.md) | chat-ui, patterns, agent-conventions | current |
