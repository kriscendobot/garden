---
title: Problem and blob-access gap
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
---

> Abstract: The chat client renders the inventory panel and lets the
> user navigate directory trees, but the leaves of those trees
> (`ReadableBlob`, `SnapshotBlob`, and the blob entries that hang off a
> `ReadableTree` or `Directory`) have no in-chat surface for reading
> their content or modifying it. Today users escape to `endo cat` on
> the command line or check out the blob to the local filesystem and
> write back. The proposed `/view` and `/edit` slash commands close
> that gap: each opens a modal panel that resolves a pet name path to a
> blob and renders or edits its content. The motivating audience is
> agent-driven workflows where an agent produces text artifacts (code,
> configuration, prose) inside Chat and the user wants to review or
> tweak them without leaving the conversation.

## What is the problem being solved?

The Chat UI can display values and navigate directory trees in the
inventory panel, but there is no way to *view* or *edit* the content
of blobs from within Chat. Users who want to read a file must use the
CLI (`endo cat`) or check it out to the local filesystem. Users who
want to edit must round-trip through the filesystem and write back.

Two new commands, `/view` and `/edit`, would let users inspect and
modify blob content directly in the Chat interface. This is
especially useful for agents that produce text artifacts (code,
configuration, prose) that users want to review or tweak without
leaving the conversation.

## Why this matters for the chat surface

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

## See also

- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]] — the sibling design's framing for a different edit affordance (editing one's own sent chat messages, not blob content); names the open question of which design owns the `/edit` slash-command name.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the inventory-panel architecture the new commands extend with blob-level affordances.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]] — the *Execution* and *Storage* command categories the new commands extend.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
