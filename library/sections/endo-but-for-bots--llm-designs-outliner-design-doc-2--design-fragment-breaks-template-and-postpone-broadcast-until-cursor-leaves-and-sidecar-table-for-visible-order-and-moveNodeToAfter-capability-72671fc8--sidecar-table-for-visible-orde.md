---
title: §Sidecar-table-for-visible-order — backward-compat discipline
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

Line 9: *"It would be best if we can do this without modifying the message schema, so maybe we have an extra table within the outliner channel that allows storing this kind of information"*.

§Named-backward-compat-discipline — *"without modifying the message schema"*; §the-message-schema-is-treated-as-frozen + §new-data-goes-in-a-sidecar-table; §sibling-pattern to cycle 245's panic-cluster's pre-lockdown-capture + cycle 246's lockdown-relink-of-shims (don't-modify-the-platform; capture-it-instead); §the-discipline-is-the-same-across-platform-and-protocol-layers — §when-a-thing-is-treated-as-immutable, §augment-via-a-named-sidecar-not-by-mutation; §three-cycles-with-augment-via-named-sidecar-not-by-mutation (245 + 246 + 263).

§"an extra table within the outliner channel" — §the-sidecar-lives-WITHIN-the-outliner-channel + §it-IS-channel-local-not-message-local; §the-sidecar's-scope-IS-the-channel-not-the-individual-message; §first-explicit-observation in library of §the-sidecar-lives-within-the-channel-not-on-the-individual-message-as-named-scope-decision.
