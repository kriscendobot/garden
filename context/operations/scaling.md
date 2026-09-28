---
created: 2026-07-04
updated: 2026-09-28
author: gardener
---

# Sizing the pool and pausing the fleet

Two operator controls over how much a host is doing: **`set-workers`** sizes
its worker pool, and **`drain`** declares a moratorium on new claims (workers
finish their current job and take no new ones; **lift** relaxes it). This page
is when to reach for which and what a healthy pool size looks like. If your
question is "scale up/down" or "pause without killing
in-flight work," you are here; the leadership-handoff use of drain is
[leader-follower.md](leader-follower.md), and the deliberate-deploy use is
[deploy.md](deploy.md).

The worker template, all rendered worker kinds, the scaler, foreman, and budget
controllers are cataloged in
[systemd-units.md](systemd-units.md#worker-pools-and-leveling).

## Sizing the pool

```sh
scripts/jobs/set-workers.sh monk <count>   # native Anthropic / Claude
scripts/jobs/set-workers.sh cleric <count> # OpenAI / Codex
```

`set-monks.sh` and `set-clerics.sh` are convenience wrappers.
The `gardener`
worker kind, `set-gardeners.sh`, and `garden-gardener@` were retired; gardener
remains the shared role and `gardener.sh` spine.
The scaler retains its name
`garden-gardener-scaler` and reconciles `monks:` / `clerics:` in `hosts/<host>`
into `garden-monk@*` / `garden-cleric@*` units.
Deploy reconciliation retires old
units; do not re-arm them.

Declared counts are bounded by backend health and budget admission.
Start small;
there is no universal twenty-worker target.
With configured worker leveling,
the leader apportions a fleet monk ceiling across calibrated subscriptions and
sizes clerics from eligible demand.
See [cybernetics.md](cybernetics.md) for
physical caps, dwell, and the current offline-host allocation gap.

Non-monk kinds accept zero.
The monk setter's zero-count guard still requires
the temporary quota `race` route and another declared, probe-qualified non-Claude
kind.
Otherwise keep a monk or use drain for a temporary pause.
Positive cleric
counts require a successful backend probe; monks may be declared before login,
with effective capacity held at zero until auth is ready.

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

If the intent is only to stop autonomous foreman pumping, use
`scripts/jobs/brake-foreman.sh on [reason]` (and `off` / `status`).
The
journal-backed `config/foreman-brake` follows leadership and stops only the
foreman.
The shipped `GARDEN_FOREMAN_ACTIVE_TARGET` is **10**; setting it to zero
also stops pumping, but is not the current default.
Budget-ramp and mandate
inputs are described in [cybernetics.md](cybernetics.md).

## Which to prefer

- **Temporary pause** (deploy, handoff, maintenance) → **drain on/off**; the
  pool size is preserved.
- **Durable capacity change** (this host should do more, less, or zero work of
  one variety indefinitely) → **`set-workers`** or the corresponding
  per-variety setter. `monks=0` is normally refused; use it only for the
  probe-qualified temporary quota-route exception described above.
- **Retiring a host** → drain, then hand off leadership if it was leader
  ([leader-follower.md](leader-follower.md)).
