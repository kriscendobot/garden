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

## Commands

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

## Viewer panel (`/view`)

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

## Editor panel (`/edit`)

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

## Panel layout

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

## See also

- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — the `petNamePath` field type and the autocomplete grammar both commands inherit.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]] — the Markdown renderer the table above points to, separated into its own section because the synchronized-scroll mechanism is non-trivial.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — how the modal gets the bytes and how focus-mode keybindings invoke each command.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]] — the design decisions that justify Monaco reuse, modal overlay, and content-type-from-extension.
- [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]] — the profile and inventory surfaces the new commands compose with.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
