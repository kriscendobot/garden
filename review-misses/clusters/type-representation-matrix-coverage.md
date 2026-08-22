---
slug: type-representation-matrix-coverage
category: test-gap
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr475-review-1011c1c5
  - endojs-endo-but-for-bots-pr475-review-5aae699b
prs: [475]
---


A PR that introduces or narrows a value type with multiple representations (frozen/thawed, mutable/immutable, native/emulated) ships without panel-required tests exercising the full representation matrix against the platform APIs/consumers that flow through the type; the corner-prober/coverage seats do not enumerate the intersection, so the maintainer must ask for the missing matrix.
