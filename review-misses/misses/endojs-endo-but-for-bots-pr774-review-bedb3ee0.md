---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr774-review-bedb3ee0
verdict: miss
category: process
pr: 774
cluster: post-gauntlet-fixer-change-unreviewed
cluster_pattern: A substantive change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head.
review_at: 2026-10-22T05:56:37Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/774#pullrequestreview-5609838628
identity: endojs/endo-but-for-bots#774:review:5609838628:retro
producing_role: fixer
producing_job: endojs-endo-but-for-bots-pr774-parcel-restack-20261015-r5527149922
missed_by: gauntlet chain and exact-head panel-freshness disposition
severity: major
grounds: |
  The maintainer's review approved head ef1ae4f9 and gave only lifecycle and
  budget direction: advance this PR toward merge and queue the next Parcel
  layer for the foreman. It had no inline findings. In isolation those clauses
  would be new direction, not a defect a panel should have anticipated.

  The actual review history makes this a process miss nonetheless. The only
  durable panel runs for PR #774 reviewed ef4662f0 and 12050148 on 2026-09-30;
  both ended must-fix against the earlier SturdyRef implementation. The later
  work replaced that implementation with the Parcel layer-1 contract and
  presented dbd2b003. The restack completion itself recorded the deterministic
  exact-head result as review-required because 12050148 did not cover dbd2b003,
  and said no gauntlet was staged by that completion. A fresh gauntlet did start
  on 2026-10-15, but it halted at clean on 501a4f42 after an unrelated CI flake,
  before any panel stage. The subsequent conduct rebase produced ef1ae4f9. No
  panel reviewed dbd2b003, 501a4f42, or ef1ae4f9 before the approval and conduct
  path.

  This violates the standing exact-head rule in roles/COMMON.md: a completed
  panel covers its reviewed commit, every commit delta is review-relevant, and
  an earlier verdict must not be presented as coverage for a changed head. The
  sensor detected the stale head but its advisory disposition did not bind the
  later approval-to-conduct path. Reaching the merge pipeline with a wholesale
  post-panel rewrite and no passing panel is major even though the maintainer's
  own review reported no code defect.

  This is process failure, not evaluator gaming. The work did not change what a
  gate measured, and the attempted gauntlet shows the evaluator was not
  deliberately routed around; the chain simply permitted approval and conduct
  after the clean-stage halt without requiring a fresh exact-head panel.

  Independent world checks also qualify the primary's disposition. The deferred
  layer-2 builder plan exists at jobs/plan/ebfb-parcel-layer2-build-20261022.md,
  and both conduct jobs exist in tada. They un-drafted and rebased the PR, but
  GitHub still shows it open and unmerged because CI became red. The primary did
  not claim a completed merge, but its shorthand that both asks were handled
  means durable delegation rather than completion of conduct. This is not a
  false-peer no-op; it does not cure the missing exact-head panel.
---

The maintainer approved the current Parcel implementation and directed the
garden to advance it toward merge and queue the next layer. Those operational
instructions are paraphrased here; the original untrusted review remains at
comment_url.

The miss is that the rewritten Parcel head reached approval and conduct without
any completed panel over that implementation. The last two panel runs were
must-fix reviews of the superseded SturdyRef version, and the replacement
gauntlet halted before panel. The existing exact-head sensor noticed the stale
coverage but did not prevent the later conduct path.
