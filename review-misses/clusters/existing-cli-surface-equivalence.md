---
slug: existing-cli-surface-equivalence
category: process
status: closed
count: 3
members:
  - endojs-endo-but-for-bots-pr658-review-97e5a186
  - endojs-endo-but-for-bots-pr897-review-8efe291e
  - endojs-endo-but-for-bots-pr1085-review-d35f5e0c
prs: [658, 897, 1085]
improvement_job: review-improve-existing-cli-surface-equivalence
improved_by: 5475bc942d: roles/COMMON.md § Pre-existing equivalent surface; skills/panel-hints/probes/C-curator-sibling-surface.sh; roles/jurors/curator/AGENT.md § Trace the pre-existing sibling surface; skills/panel-hints/SKILL.md; scripts/jobs/test/existing-cli-surface-equivalence-probe-test.sh
---





A code-panel approves a new CLI verb or path-specific branch without tracing the existing command's equivalent virtual-filesystem route, so redundant public surface reaches maintainer review.

**Threshold rationale:** Dispatch at the floor. `existing-cli-surface-equivalence` reached count=3 across 3
distinct PRs (658, 897, 1085) — meeting the default floor (K ≥ 3 misses, ≥ 2 PRs).
The #897 record explicitly foretold this member ("a third matching miss ... should
join and trip a fresh threshold call"), so this is calibrated recurrence, not a
one-PR pattern masquerading as systemic. All three share one mechanism catchable by
one durable check: a code panel approves a new public surface (CLI verb, path/route
branch, or exported API function) without tracing its pre-existing sibling for
redundancy and compositional coherence, because the seats that own that lens
(decomplector, ergonomist) are design-panel-only. The single-loop code fixes keep
recurring PR-by-PR while the panel keeps missing the pattern — exactly the
double-loop's mandate. Dispatched one builder job
`review-improve-existing-cli-surface-equivalence` (identity
`review-cluster:existing-cli-surface-equivalence`) carrying the two-part contract
(prevention in the producing artifact + a code-panel probe-and-seat sensing check)
and a per-member re-litigation test.
