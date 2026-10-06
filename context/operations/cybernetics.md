---
created: 2026-09-27
updated: 2026-09-27
author: gardener
---

# Budget and feedback controls

Current operator map, checked against `main2` on 2026-09-27.
The historical
[audit](../../designs/cybernetics-audit.md) and
[resilience design](../../designs/cybernetics-economic-resilience.md) explain
why these loops exist; this page describes their implemented behavior.

## Subscription accounting and admission

Budget controls follow the subscription, not the machine.
Journal
`config/budget-pools` defines pools, and `config/subscription-mapping` maps host/kind
consumers to them.
The meter publishes per-host contributions under
`budget/live/<subscription>/<host>`; reset windows and rate estimates are
subscription-specific.
Check the mappings before interpreting a host's spend as
the whole bill.
The implementation is [usage-meter.sh](../../scripts/jobs/usage-meter.sh).

A configured claim pool must be metered and calibrated: unmetered or
uncalibrated pools fail closed at admission.
This differs from an absent budget
configuration, which leaves budgeting off, and from a leveler sensor failure,
which holds allocation rather than treating unreadable spend as zero.

`append-quota-checkpoint.sh <subscription> <weekly-percent> [session-percent]`
pairs the human dashboard reading with the sum of host contributions in the
freshest sample's reset window.
Mismatched windows are excluded and recorded in
`meter_hosts`; the oldest included sample sets the pairing time.
A spread over
900 seconds lowers confidence.
Corrections remain append-only with `supersedes`
pointing to the old `checked_at`; `fit-quota-calibration.sh` excludes superseded
rows, including when the correction reuses that timestamp.
A checkpoint measures;
it does not itself change a cap or worker count.

## Fleet allocation and restraint

The leader's [budget-level.sh](../../scripts/jobs/budget-level.sh) reads
`config/worker-leveling`: `monk-fleet-ceiling N`, `cleric-fleet-ceiling N`, and
`host <host> <monk-physical-cap> <cleric-physical-cap>` rows.
Calibrated pool caps
and valid host physical caps are prerequisites to increasing monk capacity.
The host scaler applies the resulting declarations subject to backend health.

- **Monks:** bounded largest-remainder allocation shares one fleet ceiling,
  with a default floor of one per mapped host and the configured physical caps.
  Weights are calibrated cap times `1 + 19 * pacing_bias`.
  Bias rises when
  quota remaining exceeds time remaining in the subscription's own reset window,
  up to 1; unused quota near reset can therefore earn up to 20 times the base
  weight.
  The subsequent spend/pacing calculation chooses a target within each
  allocation.
  A ceiling is not a promise that every slot is busy.
- **Clerics:** a shared envelope follows active claims plus eligible queued
  demand, with a bounded idle reserve.
  It respects provider/role/host constraints,
  excludes manual mentat jobs from automatic demand sizing, and refuses a shrink
  that would stop an active higher-numbered cleric slot.
  Manual mentat work may
  still be claimed by an already-provisioned cleric.
- **Actuation:** defaults are one slot per step, two same-direction observations
  before raising, one before lowering.
  Reaching the target resets the streak;
  changing direction starts a new streak.
  The leader's drain suspends leveling.
  Remote changes go through benign sysop `set-workers`, not cross-host edits.
  A malformed monk configuration freezes raises; a calibrated over-budget host
  can still step down toward the floor.
  Freeze/recovery notices are edge-latched.

**Offline hosts are derotated.**
[worker-derotate.sh](../../scripts/jobs/worker-derotate.sh) runs just before the
leveler in the same leader-only scheduler tick.
A host whose `budget/live` heartbeat is stale past `GARDEN_HOST_OFFLINE_AFTER`
(the rolling-deploy canary predicate, shared as `host_liveness` in `common.sh`) on
two consecutive ticks has its row zeroed.
The same commit records its exact prior caps in journal `worker-derotate/<host>`.
The leveler then excludes it quietly, and the live hosts absorb the envelope.
A fresh heartbeat restores those caps and drops the marker.
Each episode posts one notice and one recovery.
Only marker-owned rows are restored.
A row an operator zeroes by hand stays zeroed.
If an operator re-sets a derotated row, the marker is relinquished and the
operator's value stands.
A missing or unparseable heartbeat is treated as unknown, so the host is neither
zeroed nor restored.
A stale reading of the leader's own heartbeat freezes the tick.
To hand a hand-zeroed row to the mechanism, run
`worker-derotate.sh adopt <host> <monk> <cleric>`.
The host's next fresh heartbeat then restores those caps.
`worker-derotate.sh status` lists the markers.

**Known gap:** a host that still heartbeats but does not claim (drained, wedged
workers, a stuck deploy) is live by this signal and keeps its allocation.
The leader's own drain guard does not solve this.
Treat allocation as heartbeat-live capacity, not claiming capacity.

## Production, pacing, and decision records

The foreman ships with active target **2**.
Its independent journal-backed
`brake-foreman.sh` stops only that pump. `config/foreman-mandate` supplies optional
priority direction. The budget high-water fraction is the **standing
token-backoff ramp**
([design](../../designs/standing-token-backoff-ramp.md)): per subscription,
computed when read (`token_backoff_fraction_for` in `usage-meter.sh`), it starts
at the initial reserve `config/token-backoff-initial` (default 0.50; writer
`set-token-backoff-initial.sh`) when that subscription's window begins and
rises linearly to 1.00 at its next reset. A passed planned reset restarts the
ramp; a Claude manual reset keeps the weekly deadline; a Codex (manual-cadence)
reset starts a window whose deadline is only the next reset time recorded after
it. A window that cannot be resolved uses 0.95, and `budget-level` edge-alerts
asking for the reset time (`append-reset-event.sh <sub> --type
expected-next-scheduled --precision scheduled --at <ISO>`). Each tick logs
`budget-level backoff <pool>: <f> (<source>; ...)`.
`config/token-backoff-fraction` is an **intervention pin** only, for every
pool: `set-token-backoff-fraction.sh <f> [--until <RFC3339>]` writes it and
`--clear` removes it. A pin with `until` holds until that instant even when
quota is available; nothing expires it early. An explicit
`GARDEN_TOKEN_BACKOFF_FRACTION` environment value beats everything. The writer
still works as a one-shot schedule preflight hook (exit 2 means the write is done
and no job is needed).
See
[scaling.md](scaling.md) for the distinct claim moratorium (drain).

The resilience work now implements bounded backed-off ordinary retries,
nonproductive wall-hit splitting, leaf-first deferred promotion, and projected
role-cost pacing for triagers.
Event-bearing triager ticks preempt a pacing wait;
quota/reset handling and gauntlet stage retries have their own policies.

`decision-append.sh` writes weekly, per-host JSONL under
`budget/decisions/<week-start>-<host>.jsonl`, with inputs, provenance, decision,
and outcome.
Record decisions when state changes, not every timer tick.
Triager
pacing suppresses identical normal **and fail-open** decisions, allowing a default
six-hour heartbeat; otherwise the observation system itself creates journal
contention.
A missing ledger row for an unchanged tick is not a dead controller.

## Allocation (proposed)

Above admission and pacing sits an allocation layer: the
[accountant](../../roles/accountant/AGENT.md) apportions the foreman's weekly
token budget across ranked arcs (`config/apportionment`,
`config/arc-budgets/*`, a generated `config/foreman-mandate`) in a weekly
maintainer engagement. It only narrows what admission allows. Design:
[accountant-arc-apportionment](../../designs/accountant-arc-apportionment.md);
the scripts are not built yet.

## Other feedback surfaces

[Health](health.md) describes reaction-anchored comment latency, contention
rings and clone repair, and coalesced opening/recovery notices. [Deploy](deploy.md)
describes fixed-target canaries, candidate tests, follower deferral/quiescence,
and offline catch-up. [Hardening](harden-container.md) distinguishes pending
container recreation from a regression.
These checks observe different things;
zero failed units alone is not evidence that the fleet is processing work.
