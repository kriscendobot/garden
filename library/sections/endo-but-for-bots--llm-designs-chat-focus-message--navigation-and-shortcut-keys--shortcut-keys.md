---
title: Shortcut keys
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

Single-letter keys enter a command with the focused message number
pre-filled:

| Key | Command | Description |
|-----|---------|-------------|
| `r` | `/reply`   | Reply to the focused message |
| `d` | `/dismiss` | Dismiss the focused message |
| `a` | `/adopt`   | Adopt a value from the focused message |
| `g` | `/grant`   | Grant an eval-proposal |
| `s` | `/submit`  | Submit values for a form |

These are the commands from `command-registry.js` that:

1. Have a `messageNumber` field (so pre-fill is meaningful).
2. Are common enough to warrant a single-key shortcut.

When a shortcut key is pressed, the inline command form opens with the
`messageNumber` field pre-filled and focus advances to the next field
(typically the message body). The mode transition is one half of the
*pressing a shortcut also exits focus mode* contract from the
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]]
section; the pre-fill is the other half, and the pre-fill mechanism
itself is covered in
[[endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files]].

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
