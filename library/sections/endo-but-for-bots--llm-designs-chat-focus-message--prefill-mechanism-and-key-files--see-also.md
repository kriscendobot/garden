---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys]] — the shortcut-key list (`r` / `d` / `a` / `g` / `s`) the pre-fill mechanism dispatches into; modeline rendering.
- [[endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model]] — the `data-number` attribute the shortcut-to-form flow reads; the DOM substrate the algorithm consumes.
- [[endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map]] — the broader chat package file layout; the four key files this section names sit within that map.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — the sibling design that composes with the same pre-fill primitive, pre-filling `petNamePath` rather than `messageNumber`.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions]] — the chat-message-edit design that pre-fills the *body* field from typed payload; one more consumer of the same `prefill` mechanism.
- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — the typed-field-types vocabulary; the pre-fill mechanism operates on these typed fields.
- [[producer-typed-shape-consumer-rendering]] — the broader principle: a generic pre-fill primitive at the typed-shape layer (the form's field model) lets multiple consumers (focus-mode, blob-editor, message-editor) compose without each needing its own pre-fill plumbing.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
