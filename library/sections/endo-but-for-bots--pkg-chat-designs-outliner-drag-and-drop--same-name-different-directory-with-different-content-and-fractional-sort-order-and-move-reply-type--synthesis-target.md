---
title: Synthesis target
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

Slot machine library `@game/ui/designs/bet-drag-and-drop.md` (a per-package design fragment, located at `packages/ui/designs/...`): 48-line implementation-detail-fragment with `## Features` opening section + numbered subsections + `E(channel).post(...)`-style code example with comment-aligned arguments + `## Files Modified` section at the bottom naming source files with per-file role summary. The bet-drag-and-drop persistence uses fractional sort orders via `(A+B)/2` for between-bet insertions; `moveOverrides` Map for override-vs-default-sort; bet-bullet as the drag-handle; same-parent-constraint (can only reorder among siblings; Tab/Shift-Tab for reparenting); group-drag preserves relative order within selection; five named selection modes (Click + Cmd/Ctrl+Click + Shift+Click + Rubber-band + Escape); modifier-type messages (edit + deletion + move) are invisible-in-the-tree.
