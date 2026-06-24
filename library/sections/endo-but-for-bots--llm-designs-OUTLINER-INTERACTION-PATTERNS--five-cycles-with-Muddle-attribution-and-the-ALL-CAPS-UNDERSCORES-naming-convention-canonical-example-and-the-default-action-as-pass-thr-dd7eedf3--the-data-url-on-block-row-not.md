---
title: §the-`data-url`-on-`.block-row`-not-`.block` as named measurement-decision (first-explicit-observation)
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

> "**Critical detail**: `data-url` is placed on `.block-row`, NOT on the outer `.block` div. The outer `.block` div includes children, so its bounding rect encompasses the entire subtree. Placing `data-url` on `.block-row` ensures that when we measure block positions for drag-select, a parent block's rect doesn't overlap its children's rects."

**§the-place-the-attribute-on-the-element-whose-rect-IS-the-measurement-target shape** (first-explicit-observation): a small DOM-attribute decision that determines whether parent-rects encompass child-rects (and so whether drag-select selects unintended parents). The doc explicitly names this as a "**Critical detail**" — flagging that an attribute placement choice IS a correctness invariant.

§the-attribute-placement-IS-the-correctness-invariant. The first Lesson Learned ("**Measure `.block-row`, not `.block`.**") reaffirms this from the retrospective angle: "Our most persistent drag-select bug was parent blocks being selected when only children were in the selection box."
