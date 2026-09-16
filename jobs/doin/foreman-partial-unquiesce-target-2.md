---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Raise the foreman's active-job target from 0 to 2 (partial un-quiesce)

Maintainer directive (kriskowal, this session, 2026-09-16), reversing part of
the fleet-wide quiesce landed 2026-07-14 (`d954683f1f`,
"foreman: quiesce fleet-wide — GARDEN_FOREMAN_ACTIVE_TARGET 3 -> 0
(maintainer-directed)"), which set `GARDEN_FOREMAN_ACTIVE_TARGET=0` in
`scripts/systemd/garden-foreman.service`. That investigation is
`investigate-malingering-foreman` — read its tada report for full context:
target=0 makes `inflight >= target` always true, so the foreman's pump has
been fully silent fleet-wide for 9 weeks (traceless until that job's new
`decisions.log` instrumentation landed).

Context for the value chosen: current quota usage is well under the 0.85
back-off mark (leader ~53%, garden2 ~24% weekly, both manually verified
2026-09-16), there are 124 `gate: deferred` plan jobs parked and untouched
this whole time, and the fleet now spans 3 hosts (leader, garden2, and the
newly-onboarded oros-studio). The maintainer chose **2**, not the pre-quiesce
default of 3 or the script's baked-in default of 5 — a deliberately modest
re-opening, not a full restoration.

## Change

In `scripts/systemd/garden-foreman.service`, change
`GARDEN_FOREMAN_ACTIVE_TARGET=0` to `GARDEN_FOREMAN_ACTIVE_TARGET=2` (mirror
the exact shape of the July commit, reversed). Land on `main2` (this repo
takes direct pushes, no PR — see CLAUDE.md § Conventions).

## Verify

- `garden-foreman-test.sh` / `foreman-decision-log-test.sh` (just added by
  the investigation job) still pass.
- After your change lands and rolls out through the normal deploy pipeline
  (no separate manual action needed — don't run a deploy yourself for this;
  let the existing rolling-deploy cadence pick it up), confirm via
  `.garden-state/foreman/decisions.log` on a host that's picked up the new
  unit that a tick actually logs `pumped`/`promoted` rather than
  `subscribed target=0`. If you want to confirm sooner rather than waiting
  for the natural cadence, you MAY use the same maintainer-authorized sysop
  `deploy` op the investigation job was granted
  (`send-host-op.sh <host> op=deploy authorized_by=kriskowal`) — same scope
  and caveats as that job (use purposefully, not repeatedly).

Report the before/after: a decisions.log line showing `target=0`
pre-change, and one showing `target=2` with an actual promotion post-change.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T05:26:41Z
