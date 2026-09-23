---
title: "State 8: Eval Command (Inline)"
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Extracted from `packages/chat/DESIGN.md`. Same upstream commit as chat-invariants and chat-components. This document is the operational unfolding of the *modeline completeness* invariant from [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — every state below maps a list of available keyboard actions to a modeline string.
parent: endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline
---

**Modeline:**
- `@ add endowment`
- `Enter evaluate`
- `⌘Enter expand to editor`
- `Esc cancel`

This is the only state whose modeline shows `⌘Enter` —
demonstrating the platform-appropriate modifier-keys principle from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]] at
the modeline layer: the displayed string is `⌘Enter` on macOS,
`Ctrl+Enter` on Windows / Linux.
