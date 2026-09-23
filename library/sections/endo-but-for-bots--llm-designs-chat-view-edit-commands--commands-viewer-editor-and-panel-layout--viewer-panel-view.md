---
title: Viewer panel (`/view`)
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

`/view` opens a modal panel with the blob's content rendered
read-only. The viewer selects a rendering mode based on content type:

| Content type             | Renderer                                                        |
|--------------------------|-----------------------------------------------------------------|
| Plain text, source code  | Monaco editor in read-only mode                                 |
| Markdown                 | Synchronized two-panel layout (source + rendered preview)       |
| JSON                     | Monaco with JSON language mode, read-only                       |
| Images (future)          | `<img>` element from base64 stream                              |

Content type is inferred from the pet name path's extension (`.md`,
`.js`, `.json`, etc.) or, when available, from metadata on the blob.
When the extension is ambiguous or absent, the viewer defaults to
plain text.

The extension-as-content-type discipline is recorded as a load-bearing
design decision in the [[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]]
section: blobs in Endo do not carry MIME metadata, so extension-based
inference is the simplest predictable surface, and it matches how
Monaco itself selects language modes.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
