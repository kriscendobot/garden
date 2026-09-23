---
title: 2. Edit is hidden until the message settles
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Four decisions the design names explicitly. Decision 4 (the chip
  carries the locator, not the stale pet name) surfaces an existing
  CLI/chat parity gap captured in the source's *Related: Chat parity
  gap for proposed names* section and folded into this section's
  *Implications for Endo*.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions
---

When the focused message is a not-done message produced by the local
user (rare but possible if the user is driving an agent that streams),
`/edit` is not offered. The streaming sender owns the message during
a streaming session, and manual edits during a stream race the agent's
own edits. The button and shortcut are hidden until the message
settles (`done: true`).

This is the same authority gate as the cross-sender check (the
affordance is only shown when the current profile is the sender), but
gated on a different field: the daemon's `done: true` flag. The two
gates compose into a single visibility predicate: *show edit iff
sender == current profile AND message.done*.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
