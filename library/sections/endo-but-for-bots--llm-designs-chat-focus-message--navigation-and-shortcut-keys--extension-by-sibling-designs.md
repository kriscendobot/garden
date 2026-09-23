---
title: Extension by sibling designs
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
  Both the per-message navigation gestures (arrow keys, PageUp/PageDown
  with viewport accumulation) and the per-command single-letter shortcuts
  that transition out of focus mode into the inline command form with
  `messageNumber` pre-filled. The five shortcut keys (`r`/`d`/`a`/`g`/`s`)
  are exactly the commands in `command-registry.js` that have a
  `messageNumber` field and are common enough to warrant a single-key
  dispatch.
parent: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys
---

Two sibling designs extend the shortcut key list under their own kinds
of focused value, not by adding to the focus-message design itself:

- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]]
  adds `e` (edit) when the focused element is a **message envelope**
  the user sent (sender-only authority).
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]]
  adds `v` (view) and `e` (edit) when the focused element is a **blob
  chip** or a directory entry that resolves to a blob.

The `e` collision between chat-message edit and blob edit is
resolved by *focus target*: the same keystroke fires different
commands depending on whether the currently-focused element is a
message envelope or a blob chip. Both sibling designs name the
collision explicitly; the chat-edit-message-ui design also names the
`/edit` slash-command-name collision as an unresolved open question
(see its
[[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]]
section).

The base set in this section is *what focus mode itself ships with*;
the extensions ship with the respective sibling designs.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
