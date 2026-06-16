---
title: §the-pending-focus-queue-as-named-cross-remount-state (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
authors: [Endo project (with attribution to Muddle project)]
status: (no explicit metadata table)
ingest-cycle: 285
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 996
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--five-cycles-with-Muddle-attribution-and-the-ALL-CAPS-UNDERSCORES-naming-convention-canonical-example-and-the-default-action-as-pass-through-and-three-vertical-zones-and-double-rAF-for-mobile
---

> "When a block is created (e.g., Enter creates a sibling), the new block doesn't exist in the DOM yet. The focus manager queues the focus request: `focusBlock(newUrl, 'start');` // The block with newUrl hasn't mounted yet. // When it mounts and registers its textarea, the pending focus fires."

**§the-focus-request-queued-against-a-future-DOM-element shape**: the focus manager IS a state machine that can hold a "you should focus this URL when it appears" claim *before* the URL has any DOM representation. **§the-pending-focus-IS-the-bridge-across-the-remount-gap**.

Listed as Lesson Learned #4: "**Focus management is a state machine.** The pattern of 'queue focus for a block that doesn't exist yet' is essential. Any operation that changes tree structure (Enter, Backspace merge, indent, unindent) will destroy and recreate DOM nodes. The focus manager must handle the gap."

§the-tree-structural-operations-destroy-and-recreate-DOM-nodes shape: the design explicitly names this DOM-volatility as the constraint that drives the state-machine design.
