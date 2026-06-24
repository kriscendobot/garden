---
title: Live-preview with cancellation-restore
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--scheme-picker-component
---

The picker's interaction discipline is **eager-preview, lazy-commit**:

- **Selecting** a scheme cell **immediately applies** the preview
  to the entire application by setting `data-scheme` on the
  document element.
- **Cancelling** the modal calls `restoreScheme()` which puts the
  scheme back to its pre-picker state.
- **Submitting** the modal keeps the new scheme.

This is the **live-preview with restore** pattern — apply the
change so the user can *see* what they're choosing, but keep an
undo path until they commit. The chat-spaces-home design's
*belt-and-suspenders discipline*
([[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]])
is the same pattern applied to *load/save symmetry*; this is its
counterpart for *preview/cancel symmetry*.
