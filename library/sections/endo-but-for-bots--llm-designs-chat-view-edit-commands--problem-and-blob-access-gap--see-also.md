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
  Frames the design's purpose. The chat client already navigates the
  inventory's directory trees but cannot open the leaf blobs; reads
  and edits force a CLI or filesystem round-trip. `/view` and
  `/edit` close that gap.
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap
---

- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]] — the sibling design's framing for a different edit affordance (editing one's own sent chat messages, not blob content); names the open question of which design owns the `/edit` slash-command name.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the inventory-panel architecture the new commands extend with blob-level affordances.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]] — the *Execution* and *Storage* command categories the new commands extend.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
