---
title: "State 3: Token Only (Chip present, no message)"
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

**Visual:** Single token chip in input, cursor after it.

**Modeline:**
- `Enter inspect or write message` — dual purpose based on content.
- `⌫ delete chip` — backspace removes the chip.

| Key | Action | Manual equivalent |
|---|---|---|
| `Enter` | Inspect the referenced value | Click chip |
| `Backspace` | Delete the chip | Click × on chip (if visible) |
| Any text | Begin composing message | Type directly |
