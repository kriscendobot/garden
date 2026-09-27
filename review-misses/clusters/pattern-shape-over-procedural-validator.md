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
