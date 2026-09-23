---
title: The state machine, abstractly
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

The states are organized as a small graph; transitions are
documented per-state by the available keystrokes. The graph's
**only entry points** are State 1 (Empty / Send Mode); every other
state is reached by exactly one keystroke (`@` → token autocomplete;
`/` → command selecting; `Space` from State 1 → State 4 via
last-recipient injection; etc.). **Every state's `Escape` returns to
a safer / simpler ancestor** — this is the escape-consistency
invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]
realized at the state-machine level.

The complete listing of states + their modelines + their keyboard
tables is itself the operational embodiment of the modeline-
completeness invariant: *if every keyboard action appears in the
modeline*, then exhaustively listing every state's keyboard actions
gives the modeline its content. This document is therefore the
*specification* of what the modeline must show in every state.
