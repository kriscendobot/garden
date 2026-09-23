---
title: Release lifecycle
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, eventual-send]
status: current
notes: Second of five sections for chat-slot-slash-commands. Captures the slot's state machine (empty → slashCompose → evaluating → chipRetained, with a parallel petNameCompose path) and the per-verb handler retained-value protocol (handler returns `{ id, release }` where `release` is an exo capability). The state machine grows two states beyond the existing pet-name autocomplete + committed-chip pair.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol
---

The Chat UI holds the `release` capability on the slot model. It
calls `E(release).release()` when:

- The slot is cleared (user backspaces the chip, edits the
  field, or types a new slash command over the top of an
  existing one).
- The outer form is cancelled (`Esc`, close button, navigation
  away).
- The outer form is submitted **successfully**. The downstream
  formula now has its own retention edge to `id`, so the Chat
  UI no longer needs to hold the pin.

If the submission fails, the slot remains filled with the chip
and the pin is retained, so the user can correct other fields and
resubmit without re-evaluating.

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
