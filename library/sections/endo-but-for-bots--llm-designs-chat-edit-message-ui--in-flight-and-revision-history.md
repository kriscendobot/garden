---
title: Edit while in flight, the "edited" caption, and the revision panel
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
kind: index
section_count: 6
---

`editMessage` is an ordinary eventual send. The user may issue a
second `/edit` against the same message number while a prior edit is
still in flight. The chat UI does not gate this. The daemon's revision
log is append-only, and the recipient resolves ordering from the
revision timestamps, so a "racing edits from the same sender" scenario
degrades to *last edit wins* rather than to a broken envelope.

Sections:

- [In-flight visual state](endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history--in-flight-visual-state.md)
- [The "edited" caption](endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history--the-edited-caption.md)
- [The revision panel](endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history--the-revision-panel.md)
- [Interaction with focus chains](endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history--interaction-with-focus-chains.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history--see-also.md)

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
