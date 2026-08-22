---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr796-95d66baa
verdict: not-a-miss
category: new-direction
review_at: 2026-08-21T23:24:07Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/796#issuecomment-5376416419
identity: endojs/endo-but-for-bots#796:comment:5376416419
---

Maintainer observation, not a review-process miss: the comment merely surmises
that #796 is still in draft because its gauntlet never completed — and that
surmise is exactly correct. Grounded in the board: the feature gauntlet
`endojs-endo-but-for-bots-pr796-gauntlet` ran clean, panel round 1, and fix
round 1 (all in journal/jobs/tada/), then HALTED because its panel round 2 stage
(`...-gauntlet-panel-2`) was reaper-doomed with `doom_signature:
requeue-exhausted` (`requeue_cycles: 5`). The recovery gauntlet
`...-gauntlet-resume-20260821` likewise halted when its fix round 1 stage was
reaper-doomed the same way. The draft flag correctly stayed set the whole time;
no seat, gate, or standing instruction failed to catch a defect in the work —
the review simply never ran to completion because the orchestration stages were
doomed. That is an automation/reliability failure (the reaper exhausting a
gauntlet stage's requeue allowance and halting the chain, leaving the PR silently
in draft until a human noticed), squarely the mentor loop's domain — "the
machinery misbehaved," not "the work was wrong and review missed it." There is no
panel-seat or pre-push-gate lever that could sense a reaper-doomed gauntlet, so
this is prosecutor-out-of-scope by construction, not merely below the floor.
Distinct from the `garden-design-pr-gauntlet-bypass` cluster, which is a design
PR reaching maintainer review with NO gauntlet run (evaluator-gaming avoidance):
here the gauntlet was correctly invoked and genuinely ran partway. The primary's
deliverable was verified to exist in the world, not just asserted: successor job
`endojs-endo-but-for-bots-pr796-resume-gauntlet-after-crc32-20260821` is present
in journal/jobs/tada/, and the maintainer reply (comment 5376553480, by
kriscendobot at 2026-08-21T23:48:10Z) confirms the same diagnosis on the PR.
Recorded as a dismissal so the same observation is never re-litigated; the
recurring reaper-dooming of gauntlet stages is flagged for the mentor loop, not
actioned here.
