---
slug: pattern-shape-over-procedural-validator
category: style-convention
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr1336-review-38f12d4f
prs: [1336]
---


A tool or Exo boundary describes argument validity with @endo/patterns shapes but adds a local procedural validator for a reusable value kind instead of expressing that kind as a shared matcher in @endo/patterns; review treats the local check as sufficient and misses the abstraction boundary.

**Threshold rationale:** Hold below the dispatch floor. This new cluster has count=1 on one PR, and the
miss is moderate rather than major. Existing guidance covered reuse of exported
`@endo/*` primitives, but no standing rule required moving a missing generic
value-kind predicate into `@endo/patterns`, so the single-major bypass does not
apply. Dispatch no improvement job unless this pattern reaches the default floor
of at least three misses across at least two PRs.
