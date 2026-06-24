---
title: "State 2: Token Autocomplete Visible"
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

**Visual:** Autocomplete menu showing matching pet names.

**Modeline:**
- `select reference`
- `Space chat` — complete token and continue typing message.
- `Enter inspect` — complete token and inspect the value.
- `↑↓ navigate`

| Key | Action | Manual equivalent |
|---|---|---|
| `↑` / `↓` | Navigate suggestions | Click on suggestion |
| `Space` / `Tab` | Complete token, add space, continue typing | Click suggestion |
| `Enter` | Complete token and inspect value | Double-click suggestion |
| `:` | Enter edge name mode | N/A — keyboard shortcut |
| `Escape` | Close menu | Click outside menu |
| `Backspace` | Delete character / close if at trigger | N/A |
