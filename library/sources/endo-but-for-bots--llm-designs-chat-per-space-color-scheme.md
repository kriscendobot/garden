---
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 3
status: current
notes: **Status: Complete** upstream. Extends the `scheme` field on `SpaceConfig` referenced (but not detailed) by `chat-spaces-home.md`. Depends on `chat-color-schemes.md` and `chat-high-contrast-mode.md` (neither ingested yet — both are listed as parents in this design). All 7 implementation steps are shipped. **Notes a SpaceConfig drift**: the typedef is fragmented across three chat-spaces designs — see the third section for the union shape and recommendation to keep the [[space]] concept page as the cumulative source-of-truth.
---

> Abstract: Adds per-space color-scheme preferences to the chat-spaces affordance. Five scheme values: `'auto'` (default), `'light'`, `'dark'`, `'high-contrast-light'`, `'high-contrast-dark'`. Scheme is applied by setting a `data-scheme` attribute on the document element; CSS uses a **dual-selector pattern** that defines dark values in both a media query (for auto) and an attribute selector (for explicit override), with a `:not([data-scheme="light"])` clause keeping them mutually exclusive. Standalone `scheme-picker.js` component: 2×2 grid of captioned preview cells (each shows miniature chat bubbles in its own scheme colors) above an "Auto (follow system)" button. Eager-preview + lazy-commit interaction: cell selection immediately applies the scheme as a live preview; modal cancellation calls `restoreScheme()`; modal submit keeps it. Component API: `getValue`, `setValue`, `onChange`, `restoreScheme`. Mounted into both the add-space and edit-space modals via a shared `#scheme-picker-slot` div. SpaceConfig gains an optional `scheme: ColorScheme` field; backward-compatible via `validateSpaceConfig`'s whitelist-with-default discipline. Home space scheme is always `'auto'` (not user-overridable). Monaco-iframe theming via `set-theme` post-message bridge. Seven shipped implementation steps; one follow-up open (live Monaco preview while picker is open).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [scheme-values-and-css-application](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-values-and-css-application.md) | chat-ui, patterns | current |
| [scheme-picker-component](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component.md) | chat-ui, patterns | current |
| [spaceconfig-extension-persistence-and-monaco](../sections/endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco.md) | chat-ui, agent-conventions | current |

## See also

- `chat-color-schemes.md` — parent (introduces light + dark schemes); not yet ingested.
- `chat-high-contrast-mode.md` — parent (high-contrast variants); not yet ingested.
- `chat-spaces-gutter.md`, `chat-spaces-home.md`, `chat-spaces-inbox.md` — the chat-spaces family this extends; SpaceConfig typedef is fragmented across the gutter + this design.
- `chat-components.md` — Monaco-iframe boundary and the CSS theme tokens.
