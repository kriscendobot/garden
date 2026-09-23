---
title: Editor panel (`/edit`)
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

`/edit` opens a modal panel with a Monaco editor pre-loaded with the
blob's content. The editor supports saving changes back to the blob.
The save path forks on whether the blob is mutable:

1. **Mutable blobs** (entries in a `Directory` or writable mount):
   the save action calls `write()` on the parent directory with the
   updated content.

2. **Immutable blobs** (`ReadableBlob`, `SnapshotBlob`): the save
   action creates a new blob formula via the daemon and offers to
   store it under a pet name. The original blob is unchanged
   (content-addressed immutability).

The editor panel includes a header showing the pet name path and a
content type indicator, a save button (or `Cmd/Ctrl+S` shortcut) that
writes changes, and a close button that warns on unsaved changes.

The mutable-vs-immutable fork is the load-bearing capability move:
the chat client does not pretend immutable blobs can be edited in
place. Instead, an edit on an immutable blob produces a *new
capability* (a new blob formula) and asks the user to give it a pet
name. The original blob's identity is preserved, and the chat client
remains a faithful surface for the daemon's content-addressed storage
model. Content-addressed immutability is the same discipline applied
elsewhere in the corpus (see `[[smallcaps-encoding]]` for the marshal
side and the formula-graph corpus for the daemon side); here the
chat client is one more consumer that honors the rule rather than
forging mutation atop it.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
