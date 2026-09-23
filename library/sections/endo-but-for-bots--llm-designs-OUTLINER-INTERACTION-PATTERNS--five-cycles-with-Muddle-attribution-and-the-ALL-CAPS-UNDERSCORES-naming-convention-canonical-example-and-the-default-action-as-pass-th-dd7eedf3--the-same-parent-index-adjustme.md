---
title: §the-same-parent-index-adjustment (first-explicit-observation)
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
export function adjustDropIndexForSameParent(
  sourceIndices: number[],
  targetIndex: number
): number {
  const countBefore = sourceIndices.filter(i => i < targetIndex).length;
  return targetIndex - countBefore;
}
```

**§the-removal-shifts-the-index pattern** — when moving blocks within the same parent, removing source blocks shifts indices; the design names a dedicated helper that accounts for this. **§the-named-index-adjustment-helper** (first-explicit-observation): a small but non-obvious correctness concern surfaced as its own named function rather than buried in the move logic.
