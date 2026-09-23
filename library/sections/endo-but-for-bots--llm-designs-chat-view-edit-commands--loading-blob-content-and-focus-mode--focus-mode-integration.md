---
title: Focus-mode integration
source: designs/chat-view-edit-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2691e7d52d061c0a10b89864e879188f2d4e11d7
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-28
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  The capability flow at the daemon boundary and the keyboard-shortcut
  integration into the chat client's focus mode. Read flow uses
  `text()`; write flow uses `write()` on the parent or a new
  `readable-blob` formula. The `v` / `e` focus shortcuts compose with
  the existing focus framework; the design names them explicitly even
  though the focus framework is documented elsewhere.
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode
---

When a message in the transcript contains a value that resolves to a
blob, the focus mode shortcuts extend:

- `v` → `/view` (pre-fills the pet name path from the focused value's
  name)
- `e` → `/edit` (same pre-fill)

These shortcuts only appear when the focused value is a blob or a
directory entry that resolves to a blob. The visibility predicate is
the same shape as other focus-mode actions: the shortcut is offered
only when its target makes sense, and it carries forward the
focused value's identity (its name in the inventory) so the
modal opens already populated and the user does not retype the path.

The `v` and `e` shortcuts compose with the chat client's broader
focus-mode framework. Other focus actions (`r` to reply, `f` to
forward, `Enter` to expand) are already in place; `v` and `e` join
them on the blob branch of the predicate.

### Shortcut name collision

`e` is also the focus-mode shortcut for `/edit` on chat messages, the
sibling design [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]].
The chat-edit-message-ui design names this explicitly in its open
questions and resolves the collision via *focus target*: the
`/edit` chat command in chat-edit-message-ui acts on message
envelopes, while the `/edit` here acts on blob chips; the focused
element's kind discriminates which `/edit` and which `e` shortcut
fires. The slash command name `/edit` itself is the unresolved
open question between the two designs (see the chat-edit-message-ui
[[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]]
section for the three resolution options: rename one of them,
overload-and-dispatch on the field type, or ship one and rename
later).

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
