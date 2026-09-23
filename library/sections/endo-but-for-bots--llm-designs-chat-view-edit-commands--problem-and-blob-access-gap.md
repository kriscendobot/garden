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
kind: index
section_count: 3
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

Sections:

- [What is the problem being solved?](endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap--what-is-the-problem-being-solved.md)
- [Why this matters for the chat surface](endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap--why-this-matters-for-the-chat-surface.md)
- [See also](endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap--see-also.md)

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
