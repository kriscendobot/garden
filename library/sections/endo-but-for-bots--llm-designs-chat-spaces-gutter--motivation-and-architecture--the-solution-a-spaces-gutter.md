---
title: "The solution: a spaces gutter"
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

A **spaces gutter** is a left-edge sidebar providing one-click
access to top-level navigation targets. Properties:

- Each **space is a bookmark** into the capability graph, pre-
  configured with a profile path.
- Spaces are **persistent** (stored as values in the host's pet-
  store).
- Spaces are **orderable**.
- Spaces are **keyboard-accessible** via `Cmd+1..9` (per the
  keyboard-first navigation principle from
  [[endo-but-for-bots--llm-designs-chat-invariants--principles]]).
