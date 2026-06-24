---
title: §the-block-position-registry as named position-data-structure (first-explicit-observation)
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

```typescript
interface BlockPosition {
  url: BlockId;
  parentUrl: BlockId | null;
  indexInParent: number;
  depth: number;
}
```

**§the-four-named-fields-of-a-block-position** (URL + parentUrl + indexInParent + depth): the *flattened* position record that batch operations use. Compare cycle 282's typedef vocabulary (ArchivedStat = type + mode + date + comment). **§named-position-records-as-named-data-vocabulary** — every batch operation in this design takes a `BlockPosition[]` as input.
