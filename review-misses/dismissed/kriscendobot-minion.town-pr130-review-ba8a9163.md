---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr130-review-ba8a9163
verdict: not-a-miss
category: new-direction
pr: 130
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#130:review:5358829715
comment_url: https://github.com/kriscendobot/minion.town/pull/130#pullrequestreview-5358829715
review_at: 2026-09-29T21:39:30Z
severity: minor
grounds: |
  Approval plus forward direction, not a defect report. Review 5358829715
  (APPROVED, kriskowal, no inline comments) on PR #130 (fix(deploy): avoid
  daemon health-probe spawn race) asks the bot to (1) conduct the PR and
  (2) investigate making the Endo daemon's lifecycle controls more idempotent
  upstream. Neither names a bug, spec/style violation, missed edge case, or
  violated convention in #130's diff. (1) is a merge instruction that grants
  the maintainer approval the parked conductor job was waiting for. (2) is a
  new upstream research direction in endojs/endo-but-for-bots (auto-start on
  `endo list`, stop leaving workers behind), first stated in this review.
  #130's scope was a minion.town deploy-script workaround, and no seat brief,
  skill, or standing rule requires the panel to propose upstream daemon
  redesigns for a downstream deploy fix. Nobody could have anticipated it, so
  this is not a review-process miss.

  Not evaluator-gaming: the review endorses the change as built and does not
  claim a gate was skipped or satisfied in letter only.

  World check of the primary (not taken on its report): both deliverables
  exist. Researcher job endo-daemon-controls-idempotency-research is in tada
  and produced endojs/endo-but-for-bots#1383
  (designs/daemon-lifecycle-idempotency.md), linked from a bot comment on
  #130. The conductor job
  kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume was
  promoted and ran, but it did NOT merge. It closed with
  orchestration-failed: true because #139, merged at 21:59Z, rewrote the same
  deploy-endo-daemon.sh probe and rollback code, so #130 now conflicts and
  still needs a weave or a supersede-and-close decision. As of this retro,
  #130 is still OPEN. That is a downstream state change after the approval,
  not something the review should have caught.
---

Maintainer approved PR #130 and asked for it to be merged, plus a separate
upstream investigation into making the Endo daemon's start/stop controls more
idempotent. Both are forward direction, not a defect the panel should have caught.
