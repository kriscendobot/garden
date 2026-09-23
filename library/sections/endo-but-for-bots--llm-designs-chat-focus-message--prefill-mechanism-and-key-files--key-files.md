---
title: Key files
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

The four files the focus-mode design touches:

| File | Change |
|------|--------|
| `packages/chat/chat-bar-component.js` | Focus mode logic, keyboard handling, modeline, chain/connection algorithms |
| `packages/chat/inline-command-form.js` | `prefill` parameter on `setCommand`, `skipFilled` on `focus` |
| `packages/chat/inbox-component.js` | Envelope wrapping, `data-number`/`data-message-id`/`data-reply-to` |
| `packages/chat/index.css` | Envelope, focus, chain line, and connection styles |

The split lines up with the design's architectural division: the
`chat-bar-component` owns mode and behavior; the
`inline-command-form` owns the form API; the `inbox-component` owns
the rendering of envelopes (and the data attributes they carry); the
CSS file owns the visual surface. The four files are the surface the
design names; the
[[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]]
section gives the broader context of the chat package's file layout
and what each component is responsible for.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
