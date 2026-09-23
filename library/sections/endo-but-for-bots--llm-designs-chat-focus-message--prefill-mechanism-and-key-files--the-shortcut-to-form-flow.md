---
title: The shortcut-to-form flow
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

When a shortcut key is pressed in focus mode:

1. Read `data-number` from the `.focused` envelope element (the
   attribute is set by `inbox-component.js` per
   [[endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model]]).
2. Call `enterCommandMode(commandName, { messageNumber: number })`.
3. The inline form renders with the message number already filled in.
4. Focus advances to the next empty field.

The chain `data-number → setCommand prefill → focus(skipFilled)` is
the path from "user pressed `r`" to "user is typing the reply body."
Each link in the chain is independently generic: the `data-number`
attribute is just a DOM attribute; the prefill record is just a
key-value mapping; the `skipFilled` advance is a generic property of
the form's focus logic. Nothing in the path knows specifically about
focus mode.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
