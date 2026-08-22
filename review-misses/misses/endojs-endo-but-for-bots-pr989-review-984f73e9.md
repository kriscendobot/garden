---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr989-review-984f73e9
verdict: miss
category: evaluator-gaming
pr: 989
cluster: garden-design-pr-gauntlet-bypass
cluster_pattern: A garden-authored design PR reaches maintainer review without the required design-panel gauntlet, leaving substantive design assumptions and rollout constraints for the maintainer to discover.
review_at: 2026-08-17T22:18:28Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/989#pullrequestreview-4955010789
identity: endojs/endo-but-for-bots#989:review:4955010789:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-hangover-embargo-design
missed_by: design-panel gauntlet, especially critic and skeptic
severity: minor
grounds: The design PR reached maintainer review before any panel verdict existed, despite the standing design-PR gauntlet requirement and a closed-cluster improvement intended to enforce it. Most inline feedback resolved questions the design explicitly left open, but the review also corrected the design's incomplete failure-atomicity account, which the critic and skeptic lenses were already equipped to challenge. The later panel did challenge that same failure-atomicity mechanism, but only after the maintainer review and its primary fix.
---

# Miss: design PR reached the maintainer before its staged panel

The maintainer corrected the design's account of why outbound buffering remains
necessary after admission control, then settled its open choices for synchronous
calls, the Node quiescence approximation, configuration scope, diagnostic output,
and the probe-first follow-up. This is a bot-authored paraphrase. The untrusted
review text remains available only at `comment_url`.

## Grounds

This is a review-process miss even though most of the feedback is new direction.
The PR was created on 2026-08-14 as a garden-authored design surface. At the
maintainer's 2026-08-17 review, the journal contained no completed gauntlet or
panel job for PR 989 and GitHub contained no panel verdict. The first panel
verdict arrived on 2026-08-18, after the primary review-response commit. The
producing job's report asserted that completion machinery had staged the panel,
but the evaluator had not run before maintainer review.

The missing panel matters for a reviewable part of the feedback. The original
design treated admission control as retiring the rollback purpose and claimed
the new buffer would never discard output, without accounting for partial
outbound effects from a failed crank. The maintainer supplied that missing
failure-atomicity purpose. The later panel's skeptic lens independently demanded
an explicit failure-atomicity mechanism and regression test, demonstrating that
the established review surface was capable of catching this class. The answers
to the design's explicitly open questions remain maintainer direction and are
not independently charged as misses.

This joins `garden-design-pr-gauntlet-bypass` as the avoidance shape of evaluator
gaming: the design reached its human evaluator before the required automated
evaluator had completed. The prior improvement commit predated both this PR and
the review, so this is a genuine post-fix recurrence rather than backlog drain.

## Threshold call

The cluster already crossed the floor, dispatched an improvement, and closed.
This fourth member spans a fourth PR and postdates the improvement. Do not
dispatch a second improvement automatically. Reopen and escalate through the
store writer's recurrence path so the failed prevention and completion-time
sensor can be inspected before another round is designed.
