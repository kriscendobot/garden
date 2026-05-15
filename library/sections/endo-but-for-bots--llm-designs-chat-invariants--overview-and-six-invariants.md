---
title: Familiar Chat overview + the six MUST-hold UI invariants
source: designs/chat-invariants.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Extracted from `packages/chat/DESIGN.md`. First chat-related ingest in the library; establishes the `chat-ui` topic. The six invariants here are **hard rules** — *violations indicate bugs*; the six principles in the sibling section are aesthetic guidelines.
---

## What Familiar Chat is

> *Familiar Chat is a web-based interface for interacting with the
> Endo daemon. It provides a command-driven UI for managing an
> inventory of named values (pet names), sending messages between
> peers, and evaluating JavaScript expressions in isolated workers.*

The interface is keyboard-first with a command-driven model — slash
commands, `@`-prefixed pet-name token chips, autocomplete dropdowns,
a modeline showing available keyboard actions, and a profile
indicator in the header.

## Six design invariants

The six invariants below MUST hold across the entire UI. Violations
indicate bugs or missing features.

### 1. Modeline completeness

> **Every keyboard action available in the current state MUST be
> hinted in the modeline.**

The modeline displays contextual hints showing which keyboard actions
are available. If a keyboard shortcut works in a given state but is
not shown in the modeline, that is a bug.

### 2. Keyboard-manual parity

> **Every keyboard-accessible action MUST have a corresponding manual
> (mouse / touch) action.**

Users should never be *forced* to use the keyboard. Every operation
achievable via keyboard shortcut must also be reachable through a
clickable button, a menu item, or direct manipulation (drag, click).

### 3. State visibility

> **The current UI mode and available actions MUST be visually
> apparent.**

Users should always know:

- What mode they're in (send, selecting, inline command, etc.)
- What actions are available.
- What will happen when they press Enter.

### 4. Escape consistency

> **Escape MUST always return to a safer / simpler state without
> losing critical data.**

| From | To |
|---|---|
| Any modal | Close and return to previous state |
| Command mode | Return to send mode |
| Autocomplete menu | Close menu, preserve typed text |
| (always) | Never lose unsaved work without confirmation |

### 5. Progressive complexity

> **Simple tasks MUST remain simple; complexity is opt-in.**

| Operation | Surface |
|---|---|
| Send a message | `@recipient message` + Enter |
| Inspect a value | `@name` + Enter |
| Commands | `/command` reveals structured form |
| Advanced eval | ⌘Enter (Ctrl+Enter on Windows/Linux) expands to a full editor |

### 6. Autocomplete list navigation

> **All autocomplete dropdowns MUST use the same list-navigation and
> paging behavior.**

- **Home** selects the first item; **End** selects the last.
- **Page Down** moves selection down by **(visible rows − 1)** so the previous row stays visible and the user *sees* the list move.
- **Page Up** moves selection up by the same step so one row of overlap is preserved.
- Visible row count = `pageSize = floor(containerHeight / itemHeight)`; the step is `max(1, pageSize − 1)`.

This invariant applies to **all** autocompletes: command selector,
token autocomplete, pet-name-path autocomplete, pet-name-paths
autocomplete, and inline-command-form edge-name dropdown.

## Why the invariants exist

The shape of these invariants — *every keyboard action is also
manual; every mode and action is visible; escape is always safe;
simple tasks stay simple* — is a deliberate **lift of the keyboard-
manual symmetry and the safe-escape discipline from Emacs and
modal-editor culture into a web UI**. The autocomplete list-navigation
invariant in particular is a worked solution to the common keyboard-
UI bug where Page Down jumps so far the user loses spatial
orientation in the list.

See
[[endo-but-for-bots--llm-designs-chat-invariants--principles]] for the
companion *should*-rules (the design principles that motivate but do
not bind).
