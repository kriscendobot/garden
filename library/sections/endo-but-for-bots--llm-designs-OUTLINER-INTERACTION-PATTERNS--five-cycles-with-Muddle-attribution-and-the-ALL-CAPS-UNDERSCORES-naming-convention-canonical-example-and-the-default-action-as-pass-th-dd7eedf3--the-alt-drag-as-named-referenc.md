---
title: §the-Alt-drag-as-named-reference-creation-modifier reaffirmed (cycle 277 first-explicit-observation; second cycle)
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

> "**Alt/Option + drag**: Create a reference (link) instead of moving"

```typescript
export function getDragMode(altKey: boolean): 'move' | 'reference' {
  return altKey ? 'reference' : 'move';
}
```

**§two-cycles-with-Alt-drag-as-named-reference-creation-modifier** (277 + 285). The shared name across two cluster designs IS the canonicalization.
