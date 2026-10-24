---
slug: post-gauntlet-fixer-change-unreviewed
category: process
status: open
count: 8
members:
  - endojs-endo-but-for-bots-pr475-review-e560d700
  - endojs-endo-but-for-bots-pr858-review-8add9193
  - endojs-endo-but-for-bots-pr1226-review-adf95686
  - endojs-endo-but-for-bots-pr1227-review-e348b253
  - endojs-endo-but-for-bots-pr1349-review-a794b43f
  - endojs-endo-but-for-bots-pr774-review-bedb3ee0
  - endojs-endo-but-for-bots-pr1393-review-9416ed93
  - endojs-endo-but-for-bots-pr1394-review-fa16249a
prs: [475, 858, 1226, 1227, 1349, 774, 1393, 1394]
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

**Threshold rationale:** Held, not dispatched (2026-10-19, retro of endojs-endo-but-for-bots-pr1349-review-a794b43f). This is a GENUINE post-fix recurrence (review_at 2026-10-08 postdates improvement 05e02d8f4d1, 2026-09-27); the writer reopened the cluster and alerted the maintainer under review-miss-recurrence-post-gauntlet-fixer-change-unreviewed. Per skill § 6 a second improvement round does not proceed on autopilot. Diagnosis for the maintainer's decision: the improvement's SENSING worked (assert-panel-head-fresh stamped "review required" on the mentat completion) but its disposition is advisory (maintainer stale-review docket action), and the 2026-09-29 restored automatic handoff stages only builder/design completions that name a PR, not a manual (mentat) or fixer push of substantive new code onto an already-panelled PR. Candidate fix for a sanctioned round: when the freshness check reports unreviewed and the post-panel diff is substantive (new src files / non-test code), stage a scoped panel over the post-panel range instead of only docketing it.

**Threshold rationale:** Held without a second automatic improvement dispatch (2026-10-24, retro of
endojs-endo-but-for-bots-pr774-review-bedb3ee0). The cluster remains above the
default floor and already has improvement job
review-improve-post-gauntlet-fixer-change-unreviewed plus a prior genuine
post-fix recurrence. This member confirms the same residual gap: the exact-head
sensor correctly stamped the Parcel restack as review-required, and a fresh
gauntlet was attempted, but its clean-stage CI halt left no panel verdict and
the later approval/conduct path did not fail closed. Per review-retrospective
section 6, do not dispatch a second improvement round on autopilot. A sanctioned
round should inspect the approval/conductor boundary and require an exact-head
passing panel (or an explicit maintainer override) after a gauntlet halts before
panel.

**Threshold rationale:** Hold without a second improvement dispatch (2026-10-24, retro of
endojs-endo-but-for-bots-pr1394-review-fa16249a). The cluster is already past
the floor and already carries improvement job
`review-improve-post-gauntlet-fixer-change-unreviewed`; PR #1349 genuinely
reopened it after that improvement and triggered the maintainer alert. This new
member is another post-improvement instance while the cluster is open, so the
review-retrospective recurrence rule forbids starting a second round on
autopilot. Two sibling Parcel-stack retros (#774 and #1393) have also joined
the reopened cluster, reinforcing the same halt-before-panel seam.

The instance sharpens the existing diagnosis. The exact-head sensor eventually
worked on the review-response job, but too late. The Parcel pivot staged a
gauntlet that halted before panel, its restack handed off to CI shepherding, and
the terminal shepherd made no new commit. No owner at the halt-to-handoff seam
restored the missing panel stage before human review. A maintainer-sanctioned
next improvement should make unresolved exact-head coverage durable across
gauntlet halts and successor handoffs, and should require the terminal successor
to restage or explicitly block on panel coverage even when that successor itself
does not push a commit. Re-litigate both this sequence (7516782577 to 991e943649)
and all seven earlier members; retain metadata-only and equal-head controls.
