---
title: Why this matters for the chat surface
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

The chat client's design center is *keyboard-first navigation of the
capability graph*. The inventory panel, slash-command bar, and `@`
token chips together let a user walk pet-name paths, summon
capabilities, and pass them to commands without ever touching a file
manager or terminal. A directory of blobs the user can list but
cannot open is the single largest hole in that picture: every other
inventory node has an in-chat affordance (a value modal for plain
values, a chip for capabilities, a sub-tree expansion for trees),
but a blob leaf today renders as a path with no further action. The
two new commands extend the chat client's capability-graph reach
down to the byte content the graph terminates in.

The fix is deliberately narrow. The commands do not introduce a new
content-management model, a new immutability mode, or a new daemon
surface; they reuse the existing `text()`, `write()`, and
`readable-blob` formula primitives. The design's *Phases* section
makes this incremental delivery explicit: Phase 1 ships a
plain-text viewer (no extension-based language selection); Phase 2
adds mutable-and-immutable save; Phase 3 adds extension-based
content-type inference; Phase 4 adds the Markdown synchronized
preview. Each phase is independently useful, and the most complex
piece (the Markdown side-by-side preview with scroll synchronization)
is deferred to the last phase so the core commands ship without it.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
