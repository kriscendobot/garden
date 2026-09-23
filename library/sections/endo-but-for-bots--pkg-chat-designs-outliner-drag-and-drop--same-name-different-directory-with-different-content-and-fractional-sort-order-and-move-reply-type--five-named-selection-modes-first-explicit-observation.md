---
title: §five-named-selection-modes (first-explicit-observation)
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

The Group Selection section enumerates **five named selection modes**:

1. **Click**: Selects a single node (clears other selection).
2. **Cmd/Ctrl+Click**: Toggles individual node in selection.
3. **Shift+Click**: Range-selects between last-clicked and clicked node.
4. **Rubber-band**: Click and drag on empty space to draw a selection rectangle; all nodes whose rows intersect are selected.
5. **Escape**: Clears selection.

**§five-named-keyboard-and-mouse-selection-modes as named-UX-spec-shape**. Compare cycle 285's `OUTLINER_INTERACTION_PATTERNS.md` §the-contiguous-only-selection-IS-a-named-simplification (which deliberately *forbids* non-contiguous Ctrl+Click) — this file *allows* Cmd/Ctrl+Click as a toggle. **§two-cycles-with-different-Cmd/Ctrl+Click-treatment in the outliner cluster** (285 forbids + 289 allows). §convention-divergence-within-the-cluster (third such observation alongside §the-cluster-has-four-named-naming-conventions and cycle 277's into-zone divergence).
