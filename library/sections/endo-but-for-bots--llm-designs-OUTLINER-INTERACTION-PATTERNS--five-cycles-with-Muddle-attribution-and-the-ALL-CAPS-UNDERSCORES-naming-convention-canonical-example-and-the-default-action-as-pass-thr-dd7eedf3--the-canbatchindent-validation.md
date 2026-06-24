---
title: §the-`canBatchIndent`-validation-before-batch-operation discipline (first-explicit-observation)
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
export function canBatchIndent(...): boolean {
  if (direction === 'indent') {
    return selectedBlocks[0].indexInParent > 0;
  } else {
    return selectedBlocks.every(b => b.parentUrl !== null && b.depth > 0);
  }
}
```

**§the-`can`-prefixed-validation-function-before-the-batch-operation pattern**: a named `canX` predicate that checks the operation's validity *for the entire selection* before any change is applied. **§the-batch-validation-IS-all-or-nothing**.

§the-`can`-prefix-as-named-predicate-convention. §the-validation-IS-decoupled-from-the-execution.
