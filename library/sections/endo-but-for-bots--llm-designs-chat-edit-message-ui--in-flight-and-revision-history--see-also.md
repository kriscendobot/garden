---
title: See also
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

- [[endo-but-for-bots--llm-designs-daemon-message-streaming]] — provides `editMessage` and `messageHistory`; this section describes the chat-side rendering of both.
- [[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]] — the rendering pipeline the revision panel reuses for each historical payload.
- [[crdt-in-formula-persistence]] — the broader pattern of append-only logs + consumer-side latest-wins resolution.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
