from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-10-03T05:24:07Z
doom_base: resume-halted-gauntlets-20261003
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-10-03T05:24:07Z
last_seen: 2026-10-03T05:24:07Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/resume-halted-gauntlets-20261003; it stays HELD until a human promotes it
(promote-plan.sh resume-halted-gauntlets-20261003) or removes it, so nothing is lost.
Original job base: resume-halted-gauntlets-20261003

--- original job body ---
---
role: shepherd
handler-timeout: 10800
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Resume three gauntlets halted by an unknown stage-job death

Maintainer (kriskowal, muster 2026-10-03) approved resuming these from where they stopped.

- https://github.com/kriscendobot/minion.town/pull/145 — build-ci-minion-town-actions-runner-gauntlet, stopped at panel-4 (requeue-exhausted)
- https://github.com/endojs/endo-but-for-bots/pull/1406 — build-endo-claude-pinned-cli-bump-gauntlet, stopped at panel-6 (requeue-exhausted)
- https://github.com/endojs/endo-but-for-bots/pull/1393 — ebfb-sturdyref-layer4-marshal-20260930-gauntlet, stopped at fix-3 (requeue-exhausted)

For each: find why the stage job died (its doom record and journal log), fix the
cause if it is in the garden or the PR, then resume the gauntlet at the stage where it
stopped (not from round 1) so it runs to un-draft or its review budget. If a resume
mechanism is missing for a finished record, re-post just that stage with the same
iteration count and say how. For minion.town use GARDEN_YARN=npm. Report per-PR outcome.
