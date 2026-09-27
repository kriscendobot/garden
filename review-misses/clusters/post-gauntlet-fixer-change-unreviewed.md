---
slug: post-gauntlet-fixer-change-unreviewed
category: process
status: closed
count: 4
members:
  - endojs-endo-but-for-bots-pr475-review-e560d700
  - endojs-endo-but-for-bots-pr858-review-8add9193
  - endojs-endo-but-for-bots-pr1226-review-adf95686
  - endojs-endo-but-for-bots-pr1227-review-e348b253
prs: [475, 858, 1226, 1227]
improvement_job: review-improve-post-gauntlet-fixer-change-unreviewed
improved_by: 05e02d8f4d1 (scripts/jobs/assert-panel-head-fresh.sh, scripts/jobs/gardener.sh, scripts/jobs/panel-run-record.sh, roles/COMMON.md, skills/panel/SKILL.md, designs/manual-gauntlet-trigger.md, tests)
---







A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head, leaving newly introduced state invariants for the maintainer to reconstruct.

**Threshold rationale:** Held below the dispatch floor. The cluster now has count=2 across PRs #475 and
#858. Both members show the same lifecycle gap: a substantive repair landed
after the last gauntlet panel and reached the maintainer without a fresh review
of the introducing head. The second member extends the pattern from a fixer to
a shepherd, but K >= 3 is not met. This minor maintainability miss does not
qualify for the major-severity bypass. No `review-improve-post-gauntlet-fixer-
change-unreviewed` job is dispatched. A third matching miss on any PR should
trigger a fresh threshold evaluation; the improvement should generalize the
cluster from fixer-only wording to all post-gauntlet repair roles.

**Threshold rationale:** # Dispatch rationale: post-gauntlet-fixer-change-unreviewed

Dispatch at the default floor. The cluster now has three misses across three
distinct PRs (`count=3`, `prs=[475, 858, 1226]`). They are one lifecycle failure,
not coincidental defects: a fixer, a shepherd, and now a designer each made a
substantive change after the last panel-reviewed head, and the changed head
reached maintainer review without a fresh correctness/design pass.

The third member confirms the earlier threshold note's prediction that the gap
crosses post-gauntlet repair roles. Holding would leave the old panel verdict
appearing current after arbitrary substantive revisions. No improvement for this
cluster is already in flight. Dispatch one builder job to generalize prevention
to all PR-touching producer roles and add a deterministic reviewed-head freshness
check. The job preserves the manual-gauntlet-trigger policy and requires a
re-litigation demonstration against all three historical sequences.
