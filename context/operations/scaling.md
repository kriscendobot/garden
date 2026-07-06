# Sizing the pool and pausing the fleet

Two operator controls over how much a host is doing: **`set-gardeners`** sizes
its worker pool, and **`drain`** pauses it (workers finish their current job and
take no new ones). This page is when to reach for which and what a healthy pool
size looks like. If your question is "scale up/down" or "pause without killing
in-flight work," you are here; the leadership-handoff use of drain is
[leader-follower.md](leader-follower.md), and the deliberate-deploy use is
[deploy.md](deploy.md).

## Sizing the pool

```sh
scripts/jobs/set-gardeners.sh <count> <host>
```

This writes journal state (`hosts/<host>`) that this host's
`garden-gardener-scaler` reconciles — **each host scales its own pool.** ~20
workers is normal. The count is sized for **concurrency, not CPU**: most workers
are idle-blocked waiting on messages at any moment (a job can block a long time
waiting on a maintainer reply or a peer), and sleeping is the cheapest thing an
agent can do. Tune per host by its capacity, not by core count. Adding hosts
adds concurrency with no duplication — the job-board CAS dedups the work
([leader-follower.md](leader-follower.md)).

## Pausing: drain

```sh
scripts/jobs/drain-fleet.sh on [reason]    # workers finish current jobs, take no new ones
scripts/jobs/drain-fleet.sh off            # resume claiming
```

Drain is the **graceful pause**: no work is killed, in-flight jobs run to
completion, and no new jobs are claimed. Prefer it over scaling to zero when the
pause is temporary — draining preserves the configured pool size, so `drain off`
restores the fleet without re-sizing. Reach for it before a leadership handoff
(the outgoing leader drains first, [leader-follower.md](leader-follower.md)) and
as the first move of the deliberate deploy ([deploy.md](deploy.md), which
drains, quiesces, merges, and lifts). Recovering a fleet that is stuck after an
outage — hung agents, dead letters, poison — is a different engagement: see
[health.md](health.md) and `skills/restore/SKILL.md`.

## Which to prefer

- **Temporary pause** (deploy, handoff, maintenance) → **drain on/off**; the
  pool size is preserved.
- **Durable capacity change** (this host should do more or less work
  indefinitely) → **`set-gardeners`**.
- **Retiring a host** → drain, then hand off leadership if it was leader
  ([leader-follower.md](leader-follower.md)), then `set-gardeners 0` if you want
  its pool gone.
