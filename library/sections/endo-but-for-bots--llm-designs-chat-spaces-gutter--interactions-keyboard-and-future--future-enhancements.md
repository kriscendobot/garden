---
title: Future enhancements
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

The design records six items, three of which were shipped during
the design's iteration (struck-through inline) and three still
pending:

| # | Item | Status |
|---|---|---|
| 1 | Drag-and-drop reordering | Pending |
| 2 | Unread badges (poll/subscribe to inbox counts) | Pending |
| 3 | Space editing (rename, change icon) | **Shipped** via context menu → Edit Space modal |
| 4 | Space modes beyond inbox (conversations, channels) | Pending |
| 5 | Home space (Cmd+0 to return to Host root) | **Shipped** — Home space is always first (Cmd+1) |
| 6 | Configurable home space (custom icon + color scheme for space 0) | **Shipped** — see `chat-spaces-home.md` (not yet ingested) |

The inline-strikethrough-on-shipped pattern is itself worth noting:
the design document is treated as a *living* record where shipped
items are not deleted but visibly closed. This matches the
shape-not-content principle in reverse — the *shape* of the roadmap
table is preserved, with status replacing absence.
