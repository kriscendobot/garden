---
role: fixer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-21T05:01:05Z -->

# fixer (garden main2, direct — no PR for the garden's own repo) — reap the spawned process tree on handler overrun/poison

## The bug (root cause of a real incident)
On 2026-07-20/21 the `xs2rust-endor-press` leaked **356 orphaned processes** —
four `endor-xst` each pegging a full core (oldest **15.5h**) plus a **344-proc**
`endor`/`manager-node.js` daemon tree — all reparented to `systemd --user`
(ppid 165) with **no agent watching**. The pegged cores then starved the next
hourly tick, which overran its 2400s handler budget and poisoned in turn: a
self-reinforcing loop. The maintainer killed the orphans by hand and paused the
schedule.

Root cause: when a claim-scoped handler exceeds its budget (`rc=124` at the wall)
or a job is poisoned / requeue-exhausted, the reaper moves the **board job** to
`jobs/plan/` but **never kills the OS process tree the handler spawned**. The
tests/daemons run on headless forever.

## The fix (fleet-wide; all roles, not xs2rust-specific)
1. Launch every claim-scoped handler's work in its **own process group / session**
   (`setsid`/`setpgid`) so the whole descendant tree is addressable as one group.
2. On handler-budget overrun (the `rc=124` wall) AND on poison/requeue-exhaustion,
   the reaper/handler MUST **kill that process group** — `SIGTERM` then `SIGKILL`
   to `-<pgid>` — so no `endor-xst`/`endor`/`node` descendant survives the job.
3. Idempotent + safe: never touch a *different* live job's group; only the reaped
   job's own group.

Files: `scripts/jobs/` (the reaper + the handler/worker spine — e.g. the overrun
path in the watchdog/reaper and the per-job handler wrapper). Land directly on
`main2` (garden convention: no self-PR).

## Definition of done
A test or reproducible demonstration proving a handler that **exceeds its timebox
leaves ZERO orphaned processes** (spawn a child tree, overrun, assert the group is
gone). Report the commit sha and the before/after process evidence. This is the
structural backstop; the `xs2rust-endor-press` charter separately now mandates
per-test `timeout` + self-reaping as defense-in-depth.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  worker_kind: gardener
  claimed_at: 2026-07-21T05:01:09Z
