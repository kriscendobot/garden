---
slug: type-annotation-narrowing-sweep
category: type-error
status: open
count: 3
members:
  - endojs-endo-but-for-bots-pr475-review-662af34e
  - endojs-endo-but-for-bots-pr475-review-b4dd5851
  - endojs-endo-but-for-bots-pr475-review-92a260ae
prs: [475]
---




A value-type narrowing tightens the runtime shape but leaves consuming functions' JSDoc type annotations at the pre-narrowing wider union (type-correct, so tsc and the typist pass), and the maintainer must ask why the wider arm remains.

**Threshold rationale:** Hold. The cluster now has three misses, but all three are review comments on PR
#475, so it fails the default floor's requirement to span at least two distinct
PRs. Each member is a minor, type-correct over-broad annotation rather than a
major correctness or security failure, so the standing-rule severity bypass does
not apply. No improvement job is dispatched until the pattern recurs on another
PR.
