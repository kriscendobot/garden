---
title: Panel layout
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

The viewer and editor open as modal overlays, consistent with the
existing eval form modal and help modal patterns. The modal uses a
wider layout than the standard command modals to give the editor
comfortable horizontal space:

```
┌─────────────────────────────────────────────┐
│ ┌─────────────────────────────────────────┐ │
│ │ header: path, type, [save] [close]      │ │
│ ├─────────────────────────────────────────┤ │
│ │                                         │ │
│ │  Monaco editor / viewer                 │ │
│ │  (or split: editor | preview)           │ │
│ │                                         │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

For the Markdown split view (covered in the
[[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]]
section):

```
┌─────────────────────────────────────────────┐
│ ┌─────────────────────────────────────────┐ │
│ │ header: path, type, [save] [close]      │ │
│ ├────────────────────┬────────────────────┤ │
│ │                    │                    │ │
│ │  Monaco editor     │  Rendered preview  │ │
│ │  (source)          │  (HTML)            │ │
│ │                    │                    │ │
│ └────────────────────┴────────────────────┘ │
└─────────────────────────────────────────────┘
```

The modal-overlay choice is itself recorded as a design decision (see
the *Design Decisions* section): editing and viewing are focused
tasks that benefit from maximum screen space, and a modal can be
dismissed to return to the conversation, whereas a persistent panel
would compete with the transcript and inventory for space.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
