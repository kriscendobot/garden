---
title: Loading blob content and focus-mode integration
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
kind: index
section_count: 3
---

> Abstract: Both commands load blob content by resolving the typed
> `petNamePath` to a capability and calling `text()` on the resulting
> blob. The mechanism is a three-step path walk: (1) the first
> segment resolves as a pet name in the current profile's namespace;
> (2) when the resolved value is a tree or directory, `lookup()`
> walks the remaining segments; (3) `text()` on the final blob
> returns the content as a string. `/edit`'s save is the inverse:
> for a mutable blob, `write()` on the parent directory with the
> entry name and new content; for an immutable blob, a fresh
> `readable-blob` formula via the daemon and a pet-name prompt.
> Focus-mode keyboard shortcuts extend with `v` → `/view` and `e` →
> `/edit`, both pre-filling the pet name path from the focused
> value's name. The shortcuts only appear when the focused value is a
> blob or a directory entry that resolves to a blob.

Sections:

- [Loading content](endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode--loading-content.md)
- [Focus-mode integration](endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode--focus-mode-integration.md)
- [See also](endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode--see-also.md)

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
