---
title: Commands, viewer, editor, and panel layout
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
kind: index
section_count: 5
---

> Abstract: Both `/view` and `/edit` accept one `petNamePath` field
> (the chat client's typed-input vocabulary for pet-name paths) and
> resolve it to a blob (`ReadableBlob`, `SnapshotBlob`, or a blob
> entry inside a `ReadableTree` or `Directory`). `/view` opens a
> read-only modal whose renderer is chosen by file extension: Monaco
> read-only for plain text and source, a synchronized two-panel layout
> for Markdown (see the [[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]]
> section), Monaco JSON-mode read-only for JSON, and a future `<img>`
> path for images. `/edit` opens a Monaco editor pre-loaded with the
> blob's content; **save semantics fork on blob kind**: a mutable
> blob (a writable directory entry) saves via `write()` on the parent
> with the entry name; an immutable blob (`ReadableBlob`,
> `SnapshotBlob`) creates a new content-addressed blob via the daemon
> and prompts the user to store it under a pet name, leaving the
> original unchanged. The panels open as modal overlays consistent
> with the eval-form and help modals, deliberately wider than the
> standard command modal so the editor has horizontal room.

Sections:

- [Commands](endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--commands.md)
- [Viewer panel (`/view`)](endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--viewer-panel-view.md)
- [Editor panel (`/edit`)](endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--editor-panel-edit.md)
- [Panel layout](endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--panel-layout.md)
- [See also](endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout--see-also.md)

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
