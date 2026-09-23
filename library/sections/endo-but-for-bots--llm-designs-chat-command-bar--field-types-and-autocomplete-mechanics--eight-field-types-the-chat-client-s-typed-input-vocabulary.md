---
title: Eight field types — the chat client's typed-input vocabulary
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
