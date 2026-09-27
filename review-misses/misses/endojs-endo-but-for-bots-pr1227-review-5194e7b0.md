---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1227-review-5194e7b0
verdict: miss
category: docs-drift
pr: 1227
cluster: docs-claim-contradicts-code-semantics
review_at: 2026-09-22T00:16:33Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1227#pullrequestreview-5273072032
identity: endojs/endo-but-for-bots#1227:review:5273072032
producing_role: designer
producing_job: design-endo-daemon-guest-bot-incarnation (commit d10ebb239; PR 1227)
missed_by: archivist (design-panel docs-prose accuracy lens)
severity: minor
---

The maintainer review bundled two different kinds of feedback. Its request to
rewrite the proposal around Endo's landed wake-on-message guest-pin mechanism
was new direction, not a review miss: the implementing PR was created on
2026-09-17 and merged on 2026-09-19, after this design's six panel rounds on
2026-09-08 and 2026-09-09. Those panels could not review a replacement mechanism
that did not yet exist.

The review's inline terminology correction was a miss. At the reviewed commit,
the design stated that Endo's persistent state was an immutable formula graph.
That conflated the fixed nature of each written formula with the graph that
contains formulas: the graph can gain formulas and collect unreachable ones, so
the accurate graph-level description is append-only rather than immutable. The
six panel rounds repeatedly examined formula-graph semantics and even relied on
the immutable-graph premise in findings, but none challenged this definite,
in-repo-verifiable technical claim. This is the same failure shape as the
`docs-claim-contradicts-code-semantics` cluster: review assessed design prose
without cross-verifying a factual statement about the repository's persistence
model against its authoritative semantics. It is not evaluator gaming; the
document made an imprecise factual assertion rather than moving a measurement.

The cluster's prior improvement landed on 2026-09-17. The maintainer review was
submitted afterward, so the deterministic store writer decides whether this is
a recurrence and owns any resulting escalation. No second improvement round is
dispatched from this scoped retrospective.
