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
  Both the per-message navigation gestures (arrow keys, PageUp/PageDown
  with viewport accumulation) and the per-command single-letter shortcuts
  that transition out of focus mode into the inline command form with
  `messageNumber` pre-filled. The five shortcut keys (`r`/`d`/`a`/`g`/`s`)
  are exactly the commands in `command-registry.js` that have a
  `messageNumber` field and are common enough to warrant a single-key
  dispatch.
parent: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys
---

- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the *modeline completeness*, *keyboard-manual parity*, and *escape consistency* UI invariants the focus-mode navigation and shortcut surface honor.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]] — the nine command categories; the five focus-mode shortcuts span Messaging (`r`), Storage / Cleanup (`d`, `a`), Execution (`g`), and Forms (`s`).
- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — the `messageNumber` typed field; one of the eight types focus-mode pre-fills.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]] — the `e` chat-message-edit shortcut extension to focus mode.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — the `v` and `e` blob-editor shortcut extensions to focus mode.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
