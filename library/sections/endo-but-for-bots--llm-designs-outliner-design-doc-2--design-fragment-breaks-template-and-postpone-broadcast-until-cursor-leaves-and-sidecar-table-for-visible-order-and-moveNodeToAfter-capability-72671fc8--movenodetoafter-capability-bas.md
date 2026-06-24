---
title: §moveNodeToAfter capability-based mutation
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

Line 9: *"The ability to mutate the placement of a node should require access to that node, like `channel.moveNodeToAfter(node, newPrecursor)` or something"*.

§The-mutation-requires-the-node-capability — §holding-the-node-IS-the-authorization-to-mutate-its-placement; §sibling-pattern to cycle 261's substrate-canonical-two-facet-pattern (capability-by-construction); §nine-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259 + 261 + 263).

§`channel.moveNodeToAfter(node, newPrecursor)` — §the-method-takes-two-named-capability-arguments (the node being moved + the new predecessor); §the-API-signature-IS-the-authorization-contract.

§"or something" — the author's prose-hedge on the API name itself; §three-prose-hedges-in-one-fragment ("my current recommendation" + "presumably" + "or something"); §first-explicit-observation in library of §three-prose-hedges-in-one-design-fragment-as-evidence-of-active-design-discussion.
