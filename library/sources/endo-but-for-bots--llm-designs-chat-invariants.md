---
source: designs/chat-invariants.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 2
status: current
notes: **Status: Complete** upstream. Extracted from `packages/chat/DESIGN.md`. **First chat-related ingest** — establishes the `chat-ui` topic page. The chat-design corpus on the llm branch is large (~20+ files: chat-components, chat-spaces-*, chat-edit-*, chat-markdown-render, chat-command-bar, etc.); this is the foundational document those build on. The six invariants are *must* rules; the six principles are *should* guidelines.
---

> Abstract: Familiar Chat is a web-based keyboard-first UI for the Endo daemon — command-driven (slash commands + `@`-prefixed pet-name token chips + structured forms), with a modeline showing available keyboard actions. Six **invariants** (modeline completeness; keyboard-manual parity; state visibility; escape consistency; progressive complexity; uniform autocomplete list-navigation) are bug-or-not-a-bug rules. Six **principles** (structured input over text parsing; keyboard-first navigation; progressive disclosure; visual feedback; contextual autocomplete; platform-appropriate modifier keys) are aesthetic guidelines. The autocomplete list-navigation invariant is the most concrete — *Page Up / Page Down moves by (visible rows − 1)* so the user sees motion (avoids the lose-your-place jumping common in keyboard UIs). The structured-input principle is the UI-side counterpart of the daemon's *producers own typed shape, consumers own rendering* convention. The platform-modifier-keys principle compounds across every modeline hint, button label, and tooltip.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-six-invariants](../sections/endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants.md) | chat-ui, agent-conventions | current |
| [principles](../sections/endo-but-for-bots--llm-designs-chat-invariants--principles.md) | chat-ui, agent-conventions | current |

## See also

- `packages/chat/DESIGN.md` — the source this document was extracted from; the larger chat design lives here
- `chat-components.md`, `chat-spaces-*.md`, `chat-command-bar.md`, `chat-edit-message-ui.md`, etc. — sibling chat designs not yet ingested; this document is the foundation they build on
