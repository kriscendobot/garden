---
title: The "edited" caption
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

A message that has been edited at least once carries an `edited
<timestamp>` caption in its envelope footer, where `<timestamp>` is the
time of the most recent edit. The caption *replaces* (rather than
supplements) the original send timestamp, since a reader who wants the
original time can open the revision panel. This is a deliberate
trade-off in favor of compactness: a typical message envelope footer
has room for one timestamp without crowding, and the revision panel
carries the full history anyway.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
