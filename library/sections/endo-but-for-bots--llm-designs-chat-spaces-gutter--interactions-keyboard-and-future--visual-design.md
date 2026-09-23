---
title: Visual design
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future
---

| Element | Style |
|---|---|
| Gutter background | `var(--bg-active)` — slightly darker than sidebar |
| Space icons | 40 × 40 px buttons with emoji |
| Active space | Blue highlight (`var(--accent-primary)`) |
| Badge | Red pill for unread count (future) |
| Add button | Dashed border, "+" character |

The visual-feedback principle from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]] is
visible at the *active-space-highlight* step: a user always knows
which space is current.
