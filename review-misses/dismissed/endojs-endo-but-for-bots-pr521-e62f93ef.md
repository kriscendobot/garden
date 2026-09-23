---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr521-e62f93ef
verdict: not-a-miss
category: new-direction
pr: 521
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/521#issuecomment-4974279651
identity: endojs/endo-but-for-bots#521:comment:4974279651:retro
producing_role: builder
severity: minor
grounds: >
  This retro judges whether the garden REVIEW PROCESS should have anticipated
  kriskowal's comment 4974279651 on #521 and concludes it should not: neither of
  its two asks is a work-product defect a panel, seat, or gate could have caught.
  #521 is a garden-authored (build) draft PR delivering the pass-style + ocapn
  slice of the sturdy-refs design. The comment (paraphrased; verbatim untrusted
  text at comment_url) carries two operational instructions: (1) the PR was opened
  under the WRONG ACCOUNT — kriskowal's own — which blocks him from reviewing it,
  so close it and propose a single review; and (2) collapse the stack for holistic
  review. Both are process/mechanics, not code.
  ASK (1) is a MACHINERY/IDENTITY failure, not a review miss. A garden PR reaching
  GitHub under the maintainer's account instead of the bot's is the fleet
  gh-identity pin misbehaving (the PR predates later identity hardening; created
  2026-06-24), which the SKILL's own boundary rule assigns to the MENTOR loop ("the
  machinery misbehaved"), explicitly not the prosecutor's ("the work was wrong and
  review missed it"). No juror seat or gauntlet stage reviews which GitHub account
  authored a PR, and none should — the panel weighs the diff, not attribution. The
  primary loop (jobs/tada/endojs-endo-but-for-bots-pr521-e62f93ef.md) already
  remediated it operationally: it squashed the stack into one commit byte-identical
  to #521's head, opened #737 as a draft under @kriscendobot so the maintainer can
  review, and closed #521 with a correlation marker.
  ASK (2), collapse the stack, is a PRESENTATION/DIRECTION judgment on this specific
  change, not a violated convention. Stacking is an ENDORSED garden strategy
  (skills/stacked-pr-build), not something a rule forbids; whether a given change is
  better reviewed as a stack or a single holistic PR is a per-change taste call the
  maintainer is making here. He himself flagged it tentatively as "may be necessary"
  in his earlier inline review on the same PR — a direction preference surfaced in
  the comment, not a standing rule the review process failed to apply. No garden
  review-cycle instruction bound and failed to fire; the severity-bypass
  precondition (a standing rule that existed and did not bind) is absent. Recorded
  as a durable dismissal so the same comment is never re-litigated. No cluster
  minted; no threshold; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #521 comment 4974279651 (retro)

kriskowal's comment on #521 (the garden-authored sturdy-refs pass-style/ocapn
build) is two operational instructions, not a code defect: the PR was opened under
the wrong account (his own), which blocks his review — so close it and propose a
single review — and collapse the stack for holistic review.

Not a garden review-process miss. The wrong-account problem is a machinery/identity
failure of the fleet gh-identity pin, which the skill's boundary rule hands to the
mentor loop, not this one; no juror seat or gauntlet stage reviews a PR's authoring
account, nor should it. Collapsing the stack is a presentation/direction call on
this particular change — stacking is an endorsed garden strategy, not a violated
convention, and the maintainer himself raised it only tentatively ("may be
necessary") in an earlier inline review. No standing review-cycle rule bound and
failed to fire. The primary loop already remediated operationally: it collapsed the
stack into a single commit byte-identical to #521's head, opened #737 under
@kriscendobot so the maintainer can review, and closed #521. New direction /
process, not a miss. No cluster, no threshold, no improvement dispatched. See
comment_url for the verbatim text.
