---
slug: incomplete-sibling-transformation
category: correctness-bug
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr475-9885f3d8
  - endojs-endo-but-for-bots-pr475-review-69a8dffc
prs: [475]
---



A commit that generalizes an operation across a family of sibling call sites (read-only byte ops, twin packages, a shared helper shape) converts some sites but silently skips others; no panel lens enumerates every sibling of the generalized operation and verifies each was converted, so a skipped sibling carrying a live latent bug reaches the maintainer.

**Threshold rationale:** Held below the dispatch floor. The cluster now has count=2 but prs={475}; both
members are facets of the same long-running byteArray campaign, so the required
three misses across at least two distinct PRs are not met. This member is
severity moderate and cites a review-lens completeness gap, not a standing
major-severity rule whose failure warrants the single-miss bypass. No
`review-improve-incomplete-sibling-transformation` job is dispatched. A matching
miss on another PR should join this cluster and trigger a fresh threshold call.
