---
slug: incomplete-sibling-transformation
category: correctness-bug
status: open
count: 3
members:
  - endojs-endo-but-for-bots-pr475-9885f3d8
  - endojs-endo-but-for-bots-pr475-review-69a8dffc
  - endojs-endo-but-for-bots-pr475-review-f66ed689
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

**Threshold rationale:** Held below the dispatch floor. The cluster now has count=3 but prs={475}: all
three members (9885f3d8, review-69a8dffc, review-f66ed689) are facets of the same
long-running immutable-arraybuffer / byteArray campaign on PR #475. The floor
requires at least three misses across at least two DISTINCT PRs, and the two-PR
requirement exists precisely to stop one long, heavily-reviewed PR from
masquerading as a systemic, cross-work pattern — so the K>=3 count alone does not
trip it. This member is severity moderate and cites a review-lens completeness
gap (no seat enumerates the sibling call sites that jointly maintain an
invariant), not a standing major-severity rule whose failure would warrant the
single-miss bypass. No review-improve-incomplete-sibling-transformation job is
dispatched. The pattern is real and well-attested; the first matching miss on a
SECOND PR should join this cluster and immediately trip a fresh threshold call,
at which point dispatch is warranted.
