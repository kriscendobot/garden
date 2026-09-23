---
title: §the-fractional-sort-order-via-`(A+B)/2` (first-explicit-observation)
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

> "When dropping between nodes with sort orders A and B, the new order = (A + B) / 2."

**§the-`(A+B)/2` insertion-between-existing-items as named-canonical-sort-order pattern** (first-explicit-observation): a classic technique for inserting between items in a sorted list **without renumbering anything**. The fractional value sits between A and B; further insertions sit between adjacent fractional values, ad infinitum (modulo floating-point precision).

**§the-named-floating-point-as-named-insertion-key**: the design uses *floating-point arithmetic* as a stand-in for *insertion order without rebuilds*. Sibling-pattern to many database-row-ordering schemes; sibling-pattern to fractional-indexing crates in collaborative editors.

§the-precision-limit-IS-the-named-trade-off: at some point, `(A + B) / 2` returns A or B due to floating-point precision, but the design names this as not-the-current-concern.
