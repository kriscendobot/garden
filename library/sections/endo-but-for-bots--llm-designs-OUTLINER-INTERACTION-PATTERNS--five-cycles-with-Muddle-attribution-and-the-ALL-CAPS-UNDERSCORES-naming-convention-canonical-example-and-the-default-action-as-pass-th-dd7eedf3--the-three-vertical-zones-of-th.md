---
title: §the-three-vertical-zones-of-the-drop-target (first-explicit-observation)
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

| Mouse Position | Zone | Visual Indicator | Result |
|---------------|------|------------------|--------|
| Top 25% | Before | Horizontal blue line above | Insert as sibling before |
| Middle 50% | Into | Blue outline around block | Insert as first child |
| Bottom 25% | After | Horizontal blue line below | Insert as sibling after |

**§the-25%-50%-25%-as-named-asymmetric-three-zone-partition** (first-explicit-observation): the middle "into" zone gets **half** the vertical space; the two edges get a quarter each. This is **§the-largest-target-IS-the-default-action** — "into" is the most-common intent for nested outliners and gets the most pixels.

This contrasts with cycle 277's outliner_drag_and_drop.md which named "into" as **the-hardest-zone-to-hit-deserves-the-tiebreaker"** — *the same target was treated as the hard one in one design, and the easy one in another*. §two-cycles-with-different-treatment-of-the-`into`-zone in the same cluster (277 hardest + 285 easiest); §convention-divergence-within-the-cluster.
