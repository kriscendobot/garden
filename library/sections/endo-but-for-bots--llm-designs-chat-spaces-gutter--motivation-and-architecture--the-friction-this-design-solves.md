---
title: The friction this design solves
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Created 2026-02-21. References sibling design `chat-spaces-home.md` (also referenced but not yet ingested). Both this and chat-spaces-gutter live under the same upstream commit as chat-invariants and chat-components (`3b031592`) — the three were committed together when `packages/chat/DESIGN.md` was split.
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture
---

The Chat UI today operates in **single-profile hierarchical
drill-down** mode: start at `endo.Host`, expand the navigation pane,
select a guest or capability to navigate deeper. This works for
exploring the pet-name graph but breaks for users actively managing
**multiple AI agent project loops simultaneously**.

Each AI coding agent (Fae, etc.) is typically a guest under Host,
with its own inbox, conversations, and tool capabilities. Switching
between agents under the drill-down model requires four steps:

1. Navigate back up to Host.
2. Expand the "guests" directory.
3. Select the target guest.
4. Navigate into its inbox or relevant capability.

The design names the consequence: *"this friction discourages
context-switching and forces users to finish one agent interaction
before attending to another."*
