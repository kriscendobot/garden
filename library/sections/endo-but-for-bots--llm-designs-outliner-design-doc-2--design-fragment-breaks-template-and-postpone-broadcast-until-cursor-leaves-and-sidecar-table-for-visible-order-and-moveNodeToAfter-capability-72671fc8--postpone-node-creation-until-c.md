---
title: §Postpone-node-creation-until-cursor-leaves-or-debounce-timer
source-slug: endo-but-for-bots--llm-designs-outliner-design-doc-2
section-slug: design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner-design-doc-2.md
source-repo: endojs/endo-but-for-bots
source-path: designs/outliner-design-doc-2.md
source-author: Endo project (unattributed; design fragment style)
total-lines: 10
ingest-cycle: 263
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-outliner-design-doc-2--design-fragment-breaks-template-and-postpone-broadcast-until-cursor-leaves-and-sidecar-table-for-visible-order-and-moveNodeToAfter-capability-based-mutation
---

Line 7 (the central architectural recommendation):

> *if the cursor is in one node, then the user hits enter, it would create a peer, but we don't know that the user intends to keep it a peer, since they might then hit tab, or shift-tab to indent or dedent respectively, and so my current recommendation is that we postpone node creation until the user's cursor leaves a node, or some debounced timer expires, and then allow indent/dedent operations to be represented as types of edits later*

§Three-named-deferral-strategies-for-broadcast:
1. §**cursor-leaves-the-node** — explicit user-driven boundary.
2. §**debounced-timer** — time-based boundary when cursor doesn't leave.
3. §**represent-as-edits-later** — fallback when broadcast has already happened.

§the-protocol-broadcast-timing-is-a-three-way-choice-not-an-immediate-broadcast — §when-a-UI-action-might-be-corrected-by-an-immediately-following-action, §postpone-the-broadcast-until-the-correction-window-closes + §use-cursor-position-OR-time-as-the-window-boundary; §first-explicit-observation in library of §postpone-broadcast-until-correction-window-closes-using-cursor-position-OR-time-as-boundary.

§the-`peer/indent/dedent`-sequence-IS-the-canonical-example — three keystrokes that could be one logical action; §when-the-most-recent-edit-might-undo-the-second-most-recent, §broadcasting-each-edit-individually-creates-protocol-noise; §the-postponed-broadcast-pattern reduces this noise.

§the-design-uses-"my current recommendation"-as-named-tentativeness-marker — §the-author-is-uncertain + §"my current"-IS-explicit-revision-allowance; §sibling-pattern to design-doc convention §Status: Not Started; §two-named-tentativeness-styles (design-doc-template uses Status field; design-fragment uses prose hedges); §first-explicit-observation in library.

§the-cursor-position-IS-the-natural-edit-boundary — §the-cursor-is-the-user's-focus-of-attention; §when-the-cursor-leaves, §the-edit-is-conceptually-complete; §first-explicit-observation in library.
