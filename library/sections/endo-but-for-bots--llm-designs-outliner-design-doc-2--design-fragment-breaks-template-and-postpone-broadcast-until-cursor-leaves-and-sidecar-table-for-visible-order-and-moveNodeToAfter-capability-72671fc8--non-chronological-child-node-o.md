---
title: §Non-chronological child node order — a named assumption-break
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

Line 9: *"how we should go about recording the visible order of child nodes, since we are no longer assuming they are listed chronologically"*.

§the-prior-assumption-was-chronological-ordering + §the-new-design-breaks-that-assumption; §sibling-pattern to cycle 250's named-assumption-break (system-items-with-`@`-prefix-remain-with-existing-toggle); §two-cycles-with-named-prior-assumption-break (250 + 263).

§visible-order-distinct-from-creation-order — §two-orderings-now-coexist (creation-order is implicit in creation timestamps; visible-order is explicit in the new sidecar); §sibling-pattern to git's commit-graph (creation order via timestamps + topological order via parent links); §the-design-introduces-a-second-ordering-axis; §first-explicit-observation in library of §two-orderings-coexist-creation-order-implicit-and-visible-order-explicit.
