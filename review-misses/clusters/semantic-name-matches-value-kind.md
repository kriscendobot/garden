---
slug: semantic-name-matches-value-kind
category: naming
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-5453eefb
prs: [475]
---


A parameter or local is named for a related but different representation (such as calling a Uint8Array `buffer`), producing expressions where the same word denotes both the wrapper and its backing value; review checks behavior and types but does not compare each identifier's name with its declared and accessed value kind.

**Threshold rationale:** Hold. The new cluster has count=1 and prs={475}, below the default floor of
K >= 3 misses across at least two PRs. The defect is minor naming clarity, so the
single-major standing-rule bypass does not apply even though the stylist brief
already carried the relevant rule. No improvement job is dispatched this round.
