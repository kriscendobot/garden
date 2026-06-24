---
title: What is the problem being solved?
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

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
