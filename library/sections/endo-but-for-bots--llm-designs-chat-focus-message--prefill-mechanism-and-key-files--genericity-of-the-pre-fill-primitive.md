---
title: Genericity of the pre-fill primitive
source: designs/chat-focus-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8fe17b1c61bf50fae8a97f97bc2aa7385a209f11
source_date: 2026-03-04
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  The mechanism that connects "press a shortcut key in focus mode" to
  "open the inline command form with `messageNumber` pre-filled and
  focus on the next empty field." Two API additions: `prefill?` on
  `setCommand(name, prefill?)` and `skipFilled` on `focus()`. Together
  they form a generic pre-fill primitive — not specific to focus
  mode — that other features (the blob `/view` and `/edit` editors;
  potentially the chat-message `/edit`) can compose with. Out-of-scope
  list at the bottom captures three deliberately-not-attempted ideas
  the design names explicitly.
parent: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files
---

The two API additions — `prefill?` on `setCommand` and `skipFilled` on
`focus()` — are deliberately generic primitives, not focus-mode-
specific. Any caller can pre-fill any form field through the same
mechanism.

Sibling designs that compose with the same primitive:

- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]]
  uses focus mode plus the `v` and `e` shortcuts to dispatch `/view`
  and `/edit` against blob chips, pre-filling the `petNamePath` field
  with the focused blob's pet-name path. The same `setCommand`-with-
  `prefill` API serves both message-number and pet-name-path pre-fills.

- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions]]
  uses pre-fill in a slightly different shape: the *body* field is
  pre-populated from the message's typed payload (not the rendered
  DOM); embedded token chips carry the underlying locator. The same
  `prefill` mechanism carries the structured body and chip references
  rather than just a scalar like the message number.

The genericity is the reason the focus-mode design can ship the
mechanism once and have it compose with later features without those
features needing to extend it.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
