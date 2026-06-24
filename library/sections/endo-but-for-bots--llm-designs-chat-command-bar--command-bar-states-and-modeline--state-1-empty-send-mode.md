---
title: "State 1: Empty (Send Mode)"
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

**Visual:** Empty input, placeholder visible.

**Modeline:**
- `@ inspect or message` — type @ to start token entry.
- `/ commands` — type / to open command menu.
- `Space continue with @{lastRecipient}` — only if previous recipient exists.

| Key | Action | Manual equivalent |
|---|---|---|
| `@` | Begin token autocomplete | Click token button (if exists) |
| `/` | Open command menu | Click menu button |
| `Space` | Insert last recipient | N/A — convenience shortcut |
