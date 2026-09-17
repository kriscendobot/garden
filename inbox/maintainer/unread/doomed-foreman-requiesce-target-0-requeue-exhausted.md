from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T21:33:26Z
doom_base: foreman-requiesce-target-0
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-17T21:33:26Z
last_seen: 2026-09-17T21:33:26Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/foreman-requiesce-target-0; it stays HELD until a human promotes it
(promote-plan.sh foreman-requiesce-target-0) or removes it, so nothing is lost.
Original job base: foreman-requiesce-target-0

--- original job body ---
---
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Reduce the foreman's active-job target back to 0

Maintainer directive (kriskowal, 2026-09-17T21:08Z), reversing the partial
un-quiesce from `foreman-partial-unquiesce-target-2`
(commit `78772d0c3e`, 0 -> 2) two days ago. Quota pressure has since climbed
significantly (leader 77%, garden2 66% weekly, both manually verified
2026-09-17) — back to a full quiesce.

The liaison has already applied the immediate-effect **foreman brake**
(`config/foreman-brake` on journal2) for instant relief; this job is the
standing-baseline correction so the target doesn't silently resume pumping
at 2 whenever the brake is later lifted.

## Change

In `scripts/systemd/garden-foreman.service`, change
`GARDEN_FOREMAN_ACTIVE_TARGET=2` back to `GARDEN_FOREMAN_ACTIVE_TARGET=0`.
Update the adjacent comment to reflect the new history (July 14 quiesce ->
September 16 partial lift to 2 -> September 17 back to 0, quota pressure).
Land on `main2` as usual.

## Verify

`garden-foreman-test.sh` / `foreman-decision-log-test.sh` still pass. Once
deployed, `.garden-state/foreman/decisions.log` should show `target=0` /
`guard=subscribed` again (though the brake already silences the pump
regardless of target, so this is a standing-baseline fix, not an urgent
one — no need to force a deploy for it).

Report the before/after target value and confirm the two prior tests pass.
