---
title: User interactions
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

| Action | Affordance | Result |
|---|---|---|
| **Click space icon** | Mouse | Navigate to that space's profile path. |
| **Right-click space icon** | Mouse | Context menu — Edit Space / Delete Space. |
| **Click "+" button** | Mouse | Dialog to add new space (name, icon, profile path, scheme). |
| **`Cmd+1` … `Cmd+9`** | Keyboard | Quick switch to space by position (per the keyboard-first navigation principle). |
| **Hover over icon** | Mouse | Tooltip shows space name + shortcut. |

The table is the literal expression of the **keyboard-manual parity
invariant** from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]:
every keyboard-accessible action (`Cmd+1..9`) has a corresponding
manual action (click), and every manual action (right-click context
menu) is also reachable through the keyboard (Tab focus + Menu key,
per the platform's standard accessibility path).
