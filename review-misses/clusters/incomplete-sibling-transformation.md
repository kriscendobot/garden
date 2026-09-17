---
slug: incomplete-sibling-transformation
category: correctness-bug
status: closed
count: 4
members:
  - endojs-endo-but-for-bots-pr475-9885f3d8
  - endojs-endo-but-for-bots-pr475-review-69a8dffc
  - endojs-endo-but-for-bots-pr475-review-f66ed689
  - endojs-endo-but-for-bots-pr1099-review-6694e2d7
prs: [475, 1099]
improvement_job: review-improve-incomplete-sibling-transformation
improved_by: main2 8107ace005: skills/sibling-family-sweep (prevention), roles/builder+fixer operating norms, skills/panel-hints/probes/B-sibling-family.sh + roles/jurors/breaker Sibling-family enumeration finding (sensing), scripts/jobs/test/sibling-family-probe-test.sh
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

**Threshold rationale:** Dispatch decision for cluster `incomplete-sibling-transformation` at the tail of
the PR #1099 retro.

State after recording the #1099 miss: count=4, prs={475, 1099}, status=open.

Floor: dispatch at K ≥ 3 misses spanning ≥ 2 distinct PRs. Now met — 4 misses
across two genuinely distinct PRs (#475 and #1099), each a separate maintainer
review cycle with its own head branch, not one long PR masquerading as a pattern.
The two-PR requirement that held this cluster below the floor through all of #475
is now satisfied by the arrival of the pattern on #1099.

Pre-committed dispatch: the cluster's own recorded threshold rationale (written
when it was held at count=3/prs={475}) stated verbatim that "the first matching
miss on a SECOND PR should join this cluster and immediately trip a fresh
threshold call, at which point dispatch is warranted." #1099 is exactly that
second PR.

Judgment above the floor: the members are not coincidental — all four are the
same mechanism (a family-generalizing change converts some sibling sites and
silently skips others, with no panel lens enumerating the family). #1099 shows it
twice in one review (hex vs base64 encode dispatch; harden vs ses make-hardener),
strengthening rather than diluting the signal. No fix is already in flight for the
review-process gap itself (the #1099 code fix landed, but nothing added a durable
sibling-enumeration lens to the gauntlet). Dispatch is warranted.

Dispatching one builder job `review-improve-incomplete-sibling-transformation`
(identity `review-cluster:incomplete-sibling-transformation`) with the two-part
prevention+sensing contract and the per-member re-litigation test.
