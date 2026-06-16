---
title: §the-three-layer-architecture-with-the-canonical-three-name-choice (first-explicit-observation; fourth cycle in cluster)
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

```
Behavior Layer (pure functions; editing.ts + navigation.ts + selection.ts + dragDrop.ts)
Component Layer (React; BlockContent + Block + BlockTree + BoundingBoxSelection)
Data Layer (Automerge CRDT; BlockHandle + BlockTreeContext)
```

**§four-cycles-with-three-layer-architectures-as-named-design-rationale** (extends cycle 277's three-cycle pattern; 271 + 273 + 277 + 285). The three layer names are slightly different across the cluster's instances:

- Cycle 271 instance: (TBD; not extracted here)
- Cycle 273 instance: behavior + component + data (TBD by name)
- Cycle 277 instance: behavior + component + data
- Cycle 285 instance: Behavior + Component + Data (canonical-three-name-choice)

The naming converges. **§the-three-layer-architecture-IS-the-cluster-canonical-shape**.
