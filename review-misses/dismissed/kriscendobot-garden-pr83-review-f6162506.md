---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr83-review-f6162506
verdict: not-a-miss
category: new-direction
review_at: 2026-09-05T04:49:06Z
repo: kriscendobot/garden
comment_url: https://github.com/kriscendobot/garden/pull/83#pullrequestreview-5119824896
identity: kriscendobot/garden#83:review:5119824896
producing_role: designer
---

Maintainer coordination direction across two in-flight designs, not a
review-process miss. PR #83 (`design(quota): reset-time detection`) is the
garden's own-repo design-review carve-out: a docs-only review surface over a
design whose `## Open questions` section carries unresolved maintainer-facing
forks, presented as a PR purely so inline review can happen while the content
itself is already landed direct-to-`main2` (the `garden-design-open-questions`
convention in CLAUDE.md § Conventions). kriskowal's review is an **APPROVAL**
whose sole ask paraphrases to: reconcile this reset-detection design with the
other in-flight cybernetics/quota-calibration design as a follow-up on that
implementation, since the two are simultaneously in flight and may need to
coordinate.

This is squarely "new direction — a scope change or a requirement first stated
in the comment," and specifically a **coordination judgment between two
independently in-flight efforts**. No juror seat's lens is "predict that two
concurrently-in-flight designs will need to be reconciled": that a second,
separately-authored design (`manual-quota-calibration` / the cybernetics control
loop) exists and should be harmonized with this one is a maintainer's
whole-portfolio taste call, not a bug, spec violation, missed edge case, or a
convention encoded in any seat brief, skill, or standing instruction. It could
not have been anticipated by reviewing PR #83's own diff, which is exactly what a
panel reviews.

This is explicitly NOT the `garden-design-pr-gauntlet-bypass` evaluator-gaming
avoidance pattern. A design-with-open-questions review surface deliberately runs
**no** design-panel gauntlet — the CLAUDE.md convention marks it
`<!-- garden-design-open-questions -->` precisely so the completion machinery does
not stage a panel (the content is already on `main2`; the PR is a maintainer
answer-surface, not a pending merge). Grounded in the board: `journal/jobs/tada/`
holds no gauntlet/panel job for PR #83, which here is the intended, convention-
mandated state, not a skipped evaluator. So the absence of a panel is by design,
not a routed-around gate.

The primary's deliverable was verified to exist in the world, not merely
asserted. The primary (`kriscendobot-garden-pr83-review-f6162506`) reports it (a)
added a calibration/reset-detection coordination contract in commit
`79179d90af8b126dd23333698001a591414adaa8` and (b) posted the explicitly-requested
follow-up job `kriscendobot-garden-pr83-reset-calibration-followup`. That job
exists on the board (`journal/jobs/plan/`), blocked behind the PR #80 calibration
campaign, and its body carries the reconciliation task (contiguous-run boundary
across genuine resets, plus wiring `detect-quota-resets.sh` into each pending
PR #80 effectiveness observation). PR #83 is approved and was carried to
finalization by conductor `kriscendobot-garden-pr83-conduct-20260905`. So the
directed follow-up was genuinely created and is durably owned — this is not a
false no-op resolution, and there is no discrepancy to surface.

Recorded as a dismissal so the same coordination directive is never re-litigated
by a requeued retro; no cluster is minted and no improvement job is warranted.
