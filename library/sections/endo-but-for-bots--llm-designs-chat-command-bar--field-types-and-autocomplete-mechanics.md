---
title: Eight field types, single-path autocomplete drilling, and multi-path chip composition
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## Eight field types — the chat client's typed-input vocabulary

The command system supports eight field types, each with specialized
rendering and behavior. The table is the chat-UI counterpart of the
[[producer-typed-shape-consumer-rendering]] convention applied to
*input*: each field type is a typed input shape; the UI renders it
according to type, not according to free-form text-parsing.

| Type | Description | UI component |
|---|---|---|
| `petNamePath` | Single hierarchical path (e.g. `dir.subdir.name`) | Text input with autocomplete |
| `petNamePaths` | Multiple paths | Chip container with autocomplete |
| `messageNumber` | Reference to a message | Number input with message picker |
| `text` | Free-form text | Plain text input |
| `edgeName` | Edge name from a message | Text input with autocomplete |
| `locator` | Endo locator URL | Text input |
| `source` | JavaScript source code | Monaco editor (inline or modal) |
| `endowments` | Pet-name → identifier bindings | Specialized chip + binding UI |

`text` is the only *untyped* slot — every other field shape carries
domain semantics into the UI layer. `petNamePath` and
`petNamePaths` are the workhorses (any command that operates on a
named value uses one of them); `endowments` is the most specialized
(used by the eval form to associate a free-name in source with a
pet-name binding); `source` is the only field whose UI is heavy-
weight (Monaco editor).

## Single-path autocomplete — the `.`-drilling grammar

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

## Multi-path chip input — composing several `petNamePaths`

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

## Why the field-type vocabulary matters

The eight field types are how the chat command system **avoids
text-parsing** (one of the design principles in
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]).
Instead of parsing `move foo.bar baz` as freeform text, the
`/move` command exposes two `petNamePath` fields and the user fills
each via the autocomplete grammar described above. The
text-parsing avoidance is the design's *structured input over text
parsing* principle realized at the field-vocabulary layer.

A new command added to the system uses these field types or extends
the vocabulary; new field types are rare enough that adding one
should be a deliberate, documented step (none of the eight have
been added since extraction).
