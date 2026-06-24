---
title: §two-cycles-with-the-same-design-file-name-in-different-directories (first-explicit-observation)
section-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop--same-name-different-directory-with-different-content-and-fractional-sort-order-and-move-reply-type
source-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/chat/designs/outliner_drag_and_drop.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 289
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 48
parent: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop--same-name-different-directory-with-different-content-and-fractional-sort-order-and-move-reply-type
---

The endo-but-for-bots repository contains **two files named `outliner_drag_and_drop.md` in different directories**:

- **`designs/outliner_drag_and_drop.md`** (1020 lines, cycle 277) — the comprehensive UI pattern guide attributed to Muddle, Part 1 + Part 2 structure, 23 ToC items, three-layer architecture.
- **`packages/chat/designs/outliner_drag_and_drop.md`** (48 lines, cycle 289) — the chat-package implementation-guide-fragment with code examples and file references.

**Same name, different scope, different audience**. The top-level design is the *cluster-wide* spec; the package-level design is the *chat-package-specific* implementation guide. **§the-same-name-in-two-directories IS the named cross-directory-content shape** — extends cycle 273's §cross-directory-drift (which was a *broken reference*) into a *deliberate-shared-naming* pattern: the package-level file IS named after the cluster-level file it implements.

**§three-cycles-with-cross-directory-naming-evidence in the outliner cluster**: cycle 263 (fragment references `docs/OUTLINER_INTERACTION_PATTERNS.md` — broken cross-directory ref) + cycle 273 (confirms the actual file lives at `designs/...` not `docs/...`) + cycle 289 (same filename in two different `designs/` directories, both valid). §the-outliner-cluster-IS-cross-directory-rich.
