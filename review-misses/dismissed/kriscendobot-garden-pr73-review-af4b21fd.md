---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr73-review-af4b21fd
verdict: not-a-miss
category: new-direction
pr: 73
repo: kriscendobot/garden
identity: kriscendobot/garden#73:review:5109126019:retro
comment_url: https://github.com/kriscendobot/garden/pull/73#pullrequestreview-5109126019
review_at: 2026-09-04T04:16:40Z
severity: minor
grounds: |
  Forward product direction stated in an APPROVED review. PR #73
  (design: follower self-deploy) is a design-with-open-questions PR carrying
  the <!-- garden-design-open-questions --> marker, opened as a maintainer
  answer-surface for the rolling-deploy posture change. In review 5109126019
  (state=APPROVED, COLLABORATOR kriskowal) the maintainer approved the design
  as-is and directed the next step: "conduct and post a job to implement this
  feature and exercise it to ensure the new deployment system works." That is a
  forward directive to merge and build, not an indictment of the review process
  — nothing in it says the review should have caught a bug, spec violation,
  missed edge case, or violated convention. The design was accepted, not
  corrected.

  Not a process miss / not evaluator-gaming/avoidance: the review process
  demonstrably ran. journal/jobs/tada/ holds the gauntlet chain for pr73
  (gauntlet-clean, gauntlet-panel-1, gauntlet-undraft, gauntlet), so the
  evaluator was neither skipped nor routed around; the measurement did not move
  while the target stood still. (The panel-1 job did flag a latent machinery
  bug — a kind:feature gauntlet was staged on an open-questions design PR that
  should get no design panel, the <!-- garden-design-open-questions -->
  suppression not reaching the feature-gauntlet path — but that is a
  machinery-misbehaved signal owned by the mentor loop, not a work-was-wrong
  review miss, and the panel already surfaced it to the maintainer.)

  The primary job (af4b21fd) genuinely delivered and did NOT close as a no-op.
  Both directive deliverables exist in the world, verified on the board:
  (1) the conductor job kriscendobot-garden-pr73-conduct (journal/jobs/tada/)
  un-drafted and merged the PR (state=MERGED 2026-09-04T04:22:39Z, merge commit
  1d4ed1ad68), and (2) the parked implementation build
  garden-build-follower-self-deploy (journal/jobs/plan/) directs implementing
  the design's recommended Reconciliation-A path and exercising the deployment
  system end-to-end per the maintainer's "ensure it works" ask. No no-op
  discrepancy to report. This is new direction, not a review-process miss.
---

Maintainer review 5109126019 (APPROVED) on kriscendobot/garden PR #73 approved
the follower-self-deploy design as-is and directed the next step: conduct/merge
the design and post a job to implement and exercise the new deployment system.
This is forward product direction in an approving review, not a review-process
miss — a dismissal. The design gauntlet ran on this PR and the primary genuinely
delivered both directive artifacts (the conductor job that merged the PR and the
parked implementation build garden-build-follower-self-deploy). Re-fetch the
verbatim review body at comment_url.
