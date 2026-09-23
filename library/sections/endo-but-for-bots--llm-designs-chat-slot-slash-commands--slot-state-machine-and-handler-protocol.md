---
title: Slot state machine and per-verb handler retained-value protocol
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, eventual-send]
status: current
notes: Second of five sections for chat-slot-slash-commands. Captures the slot's state machine (empty → slashCompose → evaluating → chipRetained, with a parallel petNameCompose path) and the per-verb handler retained-value protocol (handler returns `{ id, release }` where `release` is an exo capability). The state machine grows two states beyond the existing pet-name autocomplete + committed-chip pair.
kind: index
section_count: 3
---

The slot component's state machine grows two new states beyond
its existing **pet name autocomplete** and **committed chip**
states. Each verb handler returns a pair `{ id, release }` where
`id` is the resulting formula identifier and `release` is an exo
capability whose only method is `release()`. The Chat UI holds
the release capability on the slot model and invokes it on slot
clear, form cancel, or successful form submit.

Sections:

- [Slot state machine](endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol--slot-state-machine.md)
- [Per-verb handler retained-value protocol](endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol--per-verb-handler-retained-value-protocol.md)
- [Release lifecycle](endo-but-for-bots--llm-designs-chat-slot-slash-commands--slot-state-machine-and-handler-protocol--release-lifecycle.md)

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
