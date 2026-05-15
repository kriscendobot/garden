---
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 2
status: current
notes: **Status: Complete** upstream. Sibling design to [[endo-but-for-bots--llm-designs-chat-spaces-gutter]]. **Corrects** the gutter design's keyboard-shortcut numbering — gutter said "Home is always first (Cmd+1)" but home moves to **Cmd+0** with user spaces at Cmd+1..9. Different upstream commit (`7f5671c6`) from the gutter design (`3b031592`), reflecting that home was a follow-on refinement. The home space is also referenced as "shipped" in chat-spaces-gutter's roadmap table.
---

> Abstract: The Configurable Home Space (Space 0) refinement to the spaces gutter. Home is **indelible in four invariants** (always position 0, always named "Home", always bound to root agent, cannot be deleted) and **configurable in two fields** (icon and scheme). `HOME_SPACE_DEFAULTS` provides fallback values; merge-on-load combines stored `icon`/`scheme` with default `name`/`profilePath`/`id`/`mode`; normalize-on-save enforces indelible fields before storing at `['spaces', '0']`. Four reusable patterns surface: (1) `data-menu-scope` attribute on context-menu items (`"all"` / `"delible"`) — single declarative point where indelibility shapes the menu, replacing N conditional branches; (2) `showName` parameter on the edit-modal factory — one factory, two configurations, differentiated by the only field that varies; (3) shared `icon-selector.js` extraction — removes 95% duplicate code between `add-space-modal.js` and `edit-space-modal.js`; (4) watcher specializes on space `'0'` — *delete-zero resets to defaults, doesn't delete*. Corrected numbering: `spaces/N` = `Cmd+N` for N = 0..9, home at 0. The previous chat-spaces-gutter keyboard handler must be aligned (Cmd+1..9 was dispatching to positions 0..8; new mapping is Cmd+N → position N).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [indelible-space-zero-and-numbering](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering.md) | chat-ui, agent-conventions | current |
| [context-menu-scope-modal-reuse-and-shared-affordances](../sections/endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances.md) | chat-ui, agent-conventions, patterns | current |

## See also

- `chat-spaces-gutter.md` — the parent design this refines; keyboard handler needs updating to align with this design's numbering.
- `chat-spaces-inbox.md`, `chat-per-space-color-scheme.md` — sibling chat-spaces-* designs not yet ingested.
- `chat-invariants.md` and `chat-components.md` — the foundational chat designs.

The new `space` concept page collects this source's sections alongside the gutter's; the concept page is the right entry point for an agent investigating *what is a space?* rather than reading either parent design directly.
