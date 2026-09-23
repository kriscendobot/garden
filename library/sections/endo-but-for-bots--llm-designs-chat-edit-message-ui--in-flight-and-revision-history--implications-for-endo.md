---
title: Implications for Endo
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Covers two coupled surfaces: the in-flight visual state for an edit
  the daemon has not yet acknowledged, and the read-only revision panel
  that renders the array returned by `E(profile).messageHistory(number)`.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history
---

The append-only revision log on the daemon side, paired with the
*last edit wins* race-resolution rule on the recipient side, mirrors
the CRDT-shape patterns elsewhere in Endo's persistence story (see
[[crdt-in-formula-persistence]] for the abandoned-but-instructive
bidirectional version): a producer can re-send arbitrarily often, the
substrate accumulates history without coordination, and consumers read
the latest. The chat UI's "racing edits degrade to last-edit-wins"
rule is the consumer-side complement to the daemon-side append-only
log. Future surfaces that surface daemon-state in the chat client can
borrow the same shape: hide ordering questions inside the daemon, let
the UI render the latest, expose the history through a read-only
panel.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
