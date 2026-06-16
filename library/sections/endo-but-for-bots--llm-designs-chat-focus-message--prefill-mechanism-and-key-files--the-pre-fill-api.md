---
title: The pre-fill API
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

`inline-command-form.js` accepts an optional `prefill` parameter on
`setCommand(name, prefill?)`. The contract:

1. The form renders the fields the command's registry entry declares.
2. Any field name in the `prefill` record that matches a declared
   field is set as that field's initial value.
3. The `focus(skipFilled)` method advances past pre-filled fields, so
   the user lands on the next *empty* field rather than the first
   field overall.

The `skipFilled` parameter is what makes the pre-fill *helpful* rather
than disruptive. Without it, the focus would land on the pre-filled
`messageNumber` field, and the user would have to tab past it to
reach the body field they want to type into. With `skipFilled`, the
form lands the cursor where the user's intent is: the next field they
need to fill themselves.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
