---
title: Interaction with focus chains
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

Editing a message does not change its `messageId`, its `replyTo`
linkage, or its message number. The reply-chain visualization in
[[endo-but-for-bots--llm-designs-chat-focus-message]] is unaffected.
The focused message stays focused across an edit. If the user edits
the focused message, the envelope re-renders with the new body but
retains the `.focused` class and ring highlight.

This is an instance of *identity is more durable than rendering*: the
typed message identity (number + reply linkage) survives the surface
change (body text + revision-history accretion). A consumer (the
focus-chain visualizer, the inbox-position lookup) that walks
identities does not need to be re-walked when a body changes; only the
rendering surface re-renders. The producer-typed-shape /
consumer-rendering split (see [[producer-typed-shape-consumer-rendering]])
applies here as it does to the chip mechanism.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
