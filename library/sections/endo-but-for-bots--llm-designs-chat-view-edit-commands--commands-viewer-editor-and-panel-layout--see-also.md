---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — the `petNamePath` field type and the autocomplete grammar both commands inherit.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]] — the Markdown renderer the table above points to, separated into its own section because the synchronized-scroll mechanism is non-trivial.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — how the modal gets the bytes and how focus-mode keybindings invoke each command.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]] — the design decisions that justify Monaco reuse, modal overlay, and content-type-from-extension.
- [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]] — the profile and inventory surfaces the new commands compose with.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
