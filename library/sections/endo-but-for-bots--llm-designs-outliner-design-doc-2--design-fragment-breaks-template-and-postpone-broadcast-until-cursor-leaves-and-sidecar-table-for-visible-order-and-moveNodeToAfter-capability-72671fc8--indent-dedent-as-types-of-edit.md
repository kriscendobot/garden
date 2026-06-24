---
title: §Indent/dedent as types of edits later
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

Line 7's tail: *"then allow indent/dedent operations to be represented as types of edits later (which are presumably affecting the replyTo value and order of nodes)"*.

§Two-data-fields-affected-by-indent/dedent:
- §**`replyTo`** — the parent-pointer; indent/dedent walks the tree relative to neighbors.
- §**order-of-nodes** — the §visible-order-distinct-from-creation-order.

§the-indent/dedent-operation-decomposes-into-two-field-edits — §when-a-UI-operation-feels-atomic, §the-protocol-may-represent-it-as-a-composition-of-field-edits; §sibling-pattern to capability-systems' decomposition discipline (cycle 234 OAuth's six-step flow); §two-cycles-with-decompose-atomic-UI-operation-into-named-protocol-edits (234 + 263); §first-explicit-observation in library.

§the-`(which are presumably affecting...)`-parenthetical — §the-author-hedges-with-`presumably`; §two-prose-hedges-in-one-fragment so far ("my current recommendation" + "presumably"); §the-hedging-IS-the-evidence-of-design-iteration-in-progress.
