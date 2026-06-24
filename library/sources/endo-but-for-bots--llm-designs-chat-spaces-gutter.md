---
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 3
status: current
notes: **Status: Complete** upstream. Introduces the *space* concept used by sibling designs (`chat-spaces-home.md`, `chat-spaces-inbox.md`, `chat-per-space-color-scheme.md`, all not yet ingested). The structurally interesting property of this design is **"No new formula types, no new daemon APIs"** — the entire feature rides on the existing host pet-store (`write`, `list`, `lookup`, `remove`, `storeValue`); a worked example of *client-side convention over a complete daemon API*. Same upstream commit as chat-invariants and chat-components.
---

> Abstract: The Chat UI's *spaces gutter*, a left-edge 48px sidebar of one-click bookmarks into the daemon's capability graph. Solves the multi-agent context-switch friction (cluttered drill-down nav requiring four steps to switch between AI agents) with persistent, orderable, keyboard-accessible (`Cmd+1..9`) bookmarks. Each space is a `SpaceConfig` (id, name, icon, profilePath, mode='inbox', order) stored as a JSON value formula in the host's pet-store under a `spaces` directory. **No new formula types, no new daemon APIs** — uses the existing `write`/`list`/`lookup`/`remove`/`storeValue` vocabulary. Component factory pattern (`createSpacesGutter`) returning a typed API surface (`refresh`, `selectSpace`, `addSpace`, `updateSpace`, `removeSpace`, `getActiveSpaceId`, `getSpaces`). Five user interactions (click / right-click context menu / + button / Cmd+1..9 / hover) implementing keyboard-manual parity. Six future-enhancements items, three already shipped during design iteration (space editing, home space, configurable home space) — inline-strikethrough preserves the roadmap shape.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [motivation-and-architecture](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture.md) | chat-ui, agent-conventions | current |
| [space-model-and-persistence](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence.md) | chat-ui, agent-conventions | current |
| [interactions-keyboard-and-future](../sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future.md) | chat-ui, agent-conventions | current |

## See also

- `chat-spaces-home.md` — sibling design covering the home-space affordance; references this one. Not yet ingested.
- `chat-spaces-inbox.md` — sibling design for the per-space inbox view. Not yet ingested.
- `chat-per-space-color-scheme.md` — sibling for per-space theme variations. Not yet ingested.
- `chat-invariants.md` / `chat-components.md` — the foundational chat designs; this design's keyboard-manual parity and component-factory patterns inherit from them.
