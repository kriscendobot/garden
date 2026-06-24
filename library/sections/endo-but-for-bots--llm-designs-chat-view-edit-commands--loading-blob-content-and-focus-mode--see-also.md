---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]] — the profile system that scopes the pet-name namespace the first path segment resolves into.
- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — how the `petNamePath` typed input field constructs the path with `.`-drilling autocomplete.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the inventory panel that displays the names and trees the path walks; the focus-mode framework that the new `v` and `e` shortcuts join.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]] — the named collision over the `/edit` slash command and `e` focus shortcut; the three resolution options under consideration.
- [[smallcaps-encoding]] — content-addressed encoding for marshaled values; conceptually adjacent to content-addressed blobs but at a different layer (marshal vs daemon blob).

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
