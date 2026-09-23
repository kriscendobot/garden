---
title: Commands
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
  Combines the design's *Commands*, *Viewer panel*, *Editor panel*,
  and *Panel layout* subsections into one section: the two slash
  commands' shapes, the viewer's content-type renderer table, the
  editor's mutable-vs-immutable save semantics, and the modal-overlay
  layout that hosts them. The mutable-vs-immutable split is the
  load-bearing capability move; the renderer table and modal shape
  are scaffolding around it.
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout
---

| Command | Mode  | Fields        | Effect                                                          |
|---------|-------|---------------|-----------------------------------------------------------------|
| `/view` | Modal | `petNamePath` | Opens a read-only viewer for the blob at the given path         |
| `/edit` | Modal | `petNamePath` | Opens a Monaco editor for the blob at the given path            |

Both commands accept a pet name path that resolves to a blob (a
`ReadableBlob`, `SnapshotBlob`, or a blob entry within a
`ReadableTree` or `Directory`). Path resolution follows the existing
convention: slash-separated segments where the first segment is a
pet name in the current profile's namespace and subsequent segments
navigate into trees.

The `petNamePath` field type is one of the eight typed input field
types the chat command bar already understands (see
[[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]]
for the full vocabulary). Single-path `.`-drilling completes the path
one segment per key.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
