---
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 2
status: current
notes: **Status: Complete** upstream. Third in the chat-spaces family (after gutter and home); completes the trio. The structurally interesting property: **zero new files** — pure composition of existing components (`inboxComponent`, `bodyComponent`, `sendFormComponent`, `resolvePowers`) with the space's `profilePath`. Same *client-side convention over a complete daemon API* discipline that chat-spaces-gutter established, applied one level deeper. Different upstream commit (`0ee0cbb3`) from chat-spaces-gutter (`3b031592`) and chat-spaces-home (`7f5671c6`); landed separately as the third refinement.
---

> Abstract: Inbox mode for spaces — the primary interaction mode. `mode: 'inbox'` (the only currently-supported value) makes selecting a space navigate to its `profilePath`, render the agent's inbox in the main content area, and enable messaging. The existing `inboxComponent` is *preserved unchanged*; `resolvePowers` walks the profilePath through name resolution to get target-agent powers; the same component renders any agent's inbox by being handed different powers. Two integration flows are diagrammed: space-selection (gutter → bodyComponent → inboxComponent) and messaging (chat-bar → send → followMessages). **Zero new files added** — pure composition. Future-enhancements list (4 items): unread badges (with daemon-vs-client tradeoff noted), last-message preview, notification sounds, quick reply. In-space message context: profile-path breadcrumbs (already implemented), send-target defaults to space's agent, available commands scoped to space's capabilities. The test plan's Cmd+N shortcut matches the source-truth `Cmd+1..9` numbering (Cmd+1 = home), not chat-spaces-home's aspirational Cmd+0 table.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [mode-flow-and-power-resolution](../sections/endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution.md) | chat-ui, agent-conventions | current |
| [badges-message-context-and-future](../sections/endo-but-for-bots--llm-designs-chat-spaces-inbox--badges-message-context-and-future.md) | chat-ui, agent-conventions | current |

## See also

- `chat-spaces-gutter.md` and `chat-spaces-home.md` — the other two members of the chat-spaces family
- `chat-components.md` — `inboxComponent`, `bodyComponent`, `sendFormComponent` are documented there
- `chat-command-bar.md` — the command-bar that operates within an in-space context
- `chat-invariants.md` and `chat-components.md` — the foundational chat designs
