---
title: Single-path autocomplete — the `.`-drilling grammar
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics
---

For `petNamePath` fields:

| Key | Action |
|---|---|
| Type | Filter suggestions from current level |
| `.` | Accept selection, **drill into it** |
| Tab / Enter | Accept selection |
| Escape | Close menu |

The `.`-drilling shape is what lets a user type
`alice.assistant.inbox` as a continuous keyboard motion: type
"alice" → suggestions narrow → `.` accepts and descends into
alice's directory → type "assistant" → suggestions narrow → `.`
again → and so on. The path is built **one segment per Tab-or-`.`**;
the dropdown re-scopes after each segment.

The inline modeline-hint discipline for this autocomplete (per the
sibling section
[[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]]):

```
↑↓ navigate · Tab select · . drill down · Esc cancel
```

Visible *inside* the dropdown, complementing (not duplicating) the
command-bar's modeline below.
