---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1460-review-5f2333db
verdict: not-a-miss
category: new-direction
pr: 1460
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
identity: endojs/endo-but-for-bots#1460:review:5527149922:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1460#pullrequestreview-5527149922
review_at: 2026-10-15T02:06:49Z
producing_role: designer
producing_job: parcel-design-20261014
severity: minor
grounds: |
  Review 5527149922 (CHANGES_REQUESTED) has a body that is a workflow
  directive (address the feedback, then post an orchestration that restacks
  each existing SturdyRef-stack PR onto the Parcel changes in sequence) and
  one inline comment on designs/sturdy-refs-endor-syscall.md. The inline
  comment asks the bot to reconsider whether that companion design is
  superseded or needs a transformative rewrite now that Parcel exists, and
  then supplies new architecture: Slot Machine is a CapTP variant that must
  carry Parcels, so "syscall" is likely the wrong framing; the Slot Machine
  client should ask the comms vat to open a Parcel; and per-vat key pairs (or
  a supervisor slot mapping like SwingSet/OCap Kernel) may be required. The
  maintainer states they do not recall the current Slot Machine wire
  representation. These are design requirements first stated in this review,
  not a violation of any seat brief, skill, or standing rule. The restack
  orchestration is a new lifecycle directive.

  Review history: the gauntlet for #1460 had run viability (proceed) and clean
  (no-op, docs only) before the review; no panel had run yet when the
  maintainer reviewed at 02:06Z, and the PR merged at 03:04Z, before the panel
  stage claimed (panel-1 then skipped as already merged). The panel did not
  fail to catch anything. The maintainer reviewed while the PR was still mid
  gauntlet; the gauntlet was not skipped. The related cluster
  stale-related-design-direction covers builds that proceed against a related
  design that already carries invalidating maintainer direction. That does
  not fit here, because the direction first appears in this review.

  World check (independent of the primary report): the merged PR contains
  commit 6973c078f6 ("docs(parcel): design Slot Machine carriage and
  opening"), which rewrites the syscall document as Parcels-across-Slot-Machine.
  GitHub records #1460 merged at 2026-10-15T03:04:42Z (b11661caf3). The restack
  orchestration endojs-endo-but-for-bots-parcel-stack-restack-20261015-r5527149922
  and its per-PR parcel-restack children are present in jobs/tada. The
  primary's claims hold, so there is no discrepancy.
---

The maintainer asked the bot to reconsider a companion SturdyRef design in light
of Parcel. They sketched new Slot Machine and comms-vat architecture and asked
for a sequential restack orchestration. This is new direction plus a workflow
directive, with no panel stage that could have run earlier. The rewrite and the
orchestration both exist. Dismissed. Re-fetch the verbatim review at comment_url.
