# Sizing the pool and pausing the fleet

Two operator controls over how much a host is doing: **`set-gardeners`** sizes
its worker pool, and **`drain`** declares a moratorium on new claims (workers
finish their current job and take no new ones; **lift** relaxes it). This page
is when to reach for which and what a healthy pool size looks like. If your
question is "scale up/down" or "pause without killing
in-flight work," you are here; the leadership-handoff use of drain is
[leader-follower.md](leader-follower.md), and the deliberate-deploy use is
[deploy.md](deploy.md).

## Sizing the pool

```sh
scripts/jobs/set-gardeners.sh <count>
```

This writes this host's journal state (`hosts/<host>`) that its
`garden-gardener-scaler` reconciles — **each host scales its own pool.** ~20
workers is normal. The count is sized for **concurrency, not CPU**: most workers
are idle-blocked waiting on messages at any moment (a job can block a long time
waiting on a maintainer reply or a peer), and sleeping is the cheapest thing an
agent can do. Tune per host by its capacity, not by core count. Adding hosts
adds concurrency with no duplication — the job-board CAS dedups the work
([leader-follower.md](leader-follower.md)).

Every non-gardener worker variety accepts an explicit count of zero. During the
temporary Claude weekly-quota route, an endolin host may also set `gardeners: 0`
only after it has declared a positive non-Claude pool whose backend probe passes
(for example `clerics: 1`). The writer and scaler both require the active quota
route and reject the change when no qualified non-Claude class remains, so a host
cannot configure itself to zero claimers. Restore Claude capacity with
`scripts/jobs/set-gardeners.sh <count>`.

The setter is deliberately local-only: its optional `[host]` must equal this
host's `GARDEN`. To change an unattended follower, do not edit `hosts/<host>`
from here; send `op=set-workers` to the target's standing sysop as described in
[host-operations.md](host-operations.md).

## Pausing: drain

```sh
scripts/jobs/drain-fleet.sh on [reason]    # workers finish current jobs, take no new ones
scripts/jobs/drain-fleet.sh off            # resume claiming
```

**Drain enacts a moratorium on undertaking further work, while allowing work
already in progress to finish.** **Lift** (`drain off`) relaxes the moratorium
and workers resume claiming. So it is the **graceful pause**: no work is killed,
in-flight jobs run to completion, and no new jobs are claimed.

What is being drained is the **`doin/` board** — the set of in-flight claims. It
empties because inflow stopped (no new claims) while outflow continues (claimed
jobs finish). That is the metaphor: **draining as a process**, a pool emptying,
**not a physical drain** — there is no fixture here to plug, uncork, or open. A
moratorium is *in force* or *lifted*, and the two operator words for those acts
are **drain** and **lift**.

Prefer drain over scaling to zero when the pause is temporary — draining
preserves the configured pool size, so `drain off` restores the fleet without
re-sizing. Reach for it before a leadership handoff (the outgoing leader drains
first, [leader-follower.md](leader-follower.md)) and as the first move of the
deliberate deploy ([deploy.md](deploy.md), which drains, quiesces, merges, and
lifts). Recovering a fleet that is stuck after an
outage — hung agents, dead letters, doom — is a different engagement: see
[health.md](health.md) and `skills/restore/SKILL.md`.

### What drain does not stop

Drain is a **claim moratorium**, not a global write lock. On a drained leader,
the direct job-producing watchers and `orchestrate.sh` see the marker and exit,
but the scheduler has no drain guard and can still dispatch due schedules into
`todo/`. `repo-watcher.sh` continues reconciling watcher units, the self-heal
wrapper may post a scoped repair after a service failure, and the sysop must keep
ticking so it can receive `drain off`. Those producers can therefore grow queued
work while no gardener on the drained host will claim it; gardeners on other,
undrained hosts can still claim it.

If the intent is only to stop autonomous foreman pumping, do not drain the
leader. The shipped `garden-foreman.service` sets
`GARDEN_FOREMAN_ACTIVE_TARGET=0`, which independently prevents both deferred
promotion and newly generated foreman work while leaving orchestration,
schedules, watchers, and claiming untouched. Raising that target re-enables the
foreman. A proposed separate brake has not landed in the current code; the active
target is the live foreman-specific control.

## Which to prefer

- **Temporary pause** (deploy, handoff, maintenance) → **drain on/off**; the
  pool size is preserved.
- **Durable capacity change** (this host should do more, less, or zero work of
  one variety indefinitely) → **`set-gardeners`** or the corresponding
  per-variety setter. `gardeners=0` is normally refused; use it only for the
  probe-qualified temporary quota-route exception described above.
- **Retiring a host** → drain, then hand off leadership if it was leader
  ([leader-follower.md](leader-follower.md)).
