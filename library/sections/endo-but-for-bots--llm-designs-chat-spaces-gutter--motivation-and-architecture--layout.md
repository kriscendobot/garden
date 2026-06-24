---
title: Layout
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

The gutter is positioned at the absolute left edge:

```
| gutter | #pets (sidebar) | #messages (inbox) |
| 48px   | var(--sidebar-width)                |
```

CSS variables added (extending the 13-token theme set named in
[[endo-but-for-bots--llm-designs-chat-components--css-variables-and-security]]):

- `--gutter-width: 48px` — width of the spaces gutter.
- Existing elements shifted right by `--gutter-width`.

The single-variable extension is the canonical way to add a layout
element without breaking existing component CSS — all rule sets that
position content from the left edge consume `--gutter-width`, so a
future theme can resize the gutter without touching component
stylesheets.
