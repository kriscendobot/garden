---
title: Multi-path chip input — composing several `petNamePaths`
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

For `petNamePaths` fields, completed paths become *removable chips*
inside a chip-container input:

```
┌─────────────────────────────────────────────────────────────┐
│ [path.to.first ×] [second-name ×] [third.path| ]            │
└─────────────────────────────────────────────────────────────┘
```

Keyboard grammar — each key has a *distinct* outcome that
distinguishes "keep this path going" from "finish this path and
start another":

| Key | Outcome |
|---|---|
| `.` | Accept current suggestion, create chip, **continue drilling into it** |
| `Space` | Accept current suggestion, create chip, **start fresh path** |
| `Enter` | Accept current input and **submit the form** |
| `Backspace` (on empty) | Remove the last chip |
| Arrow keys | Navigate suggestions |

The two-key distinction between `.` (drill) and `Space` (fresh
path) is the multi-path equivalent of the single-path `.`-drilling
grammar. The keyboard-manual-parity discipline applies:

- Each chip has a `×` for mouse removal (manual equivalent of
  empty-input Backspace).
- Submit is reachable via Enter OR a Submit button.

The chip-container input is also a worked example of the
[[token-chip]] discipline applied to *input* fields, not just
inline message references. Both surface the same concept:
*reference identity rendered as a removable chip*.

The inline modeline-hint:

```
↑↓ navigate · . drill down · Space add · Enter submit · Esc cancel
```
