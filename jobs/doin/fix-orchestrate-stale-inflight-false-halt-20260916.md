---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
The orchestrate watcher declares a child FAILED on a stale in-flight reading while
that child is actually completing successfully. This halts whole orchestrations on
a false premise and parks the remaining children indefinitely.

TWO CONFIRMED INSTANCES, both found in a single liaison muster on 2026-09-16:

1. `credit-controls-20260916` (posted 05:44Z, halted 07:04Z). The halt record read:
   "child credit-controls-stale-pr-viability-gate stalled in flight for 2505s on
   host endolin-garden2-5bcdff64 (handler-timeout=2400s, multiplier=1)". FALSE.
   That child completed successfully and its own `jobs/tada/` report records a
   wall-clock of **463s** — it pushed `c32821fa15` to main2 with regression
   coverage and mutation testing. The orchestration nonetheless declared
   `orchestration-status: halted`, `failure-kind: handler-timeout`, and parked the
   final child (`credit-controls-panel-seat-metering-and-tiering`), which then sat
   blocked behind a child that had already succeeded.

2. `minion-town-clipometer-esbuild-orchestration` (halted 2026-09-03). Recorded
   "0/4 children done" after child 1 stalled 2501s vs a 2400s budget. But child 1
   recovered on a reaper requeue and COMPLETED — draft PR
   kriscendobot/minion.town#84 exists with CI green. The orchestration record was
   never corrected, and children 2-4 stayed parked for two weeks on a false
   "0/4 done".

Note the shape difference, which matters for the diagnosis: instance 2 is a
genuine overrun that was later recovered by a requeue (so the halt was merely
never revised); instance 1 is a job that NEVER overran at all (463s against a
2400s budget) yet was reported at 2505s. Instance 1 in particular suggests the
watcher is reading a stale or wrong in-flight timestamp — perhaps a claim record
left by an earlier attempt, or an elapsed computed against the wrong clock or the
wrong claim — rather than merely failing to re-check a recovered child.

TASK:
1. Find the root cause in `scripts/jobs/orchestrate.sh` (and whatever in-flight
   elapsed/claim state it reads). Explain specifically how a 463s job is reported
   as a 2505s stall.
2. Before declaring a child failed, RE-CHECK whether it has reached `jobs/tada/`.
   The completion record is the authority; an in-flight timing reading is not.
3. Decide whether a halted orchestration should self-correct when a child it
   declared failed is later observed complete, and implement it if so. Both
   instances here would have resolved themselves.
4. Regression test pinning: a child that completes well within its budget must
   never halt its parent.

This bug is expensive out of proportion to its size: it silently parks approved,
funded work for weeks and the halt message reads authoritative while being wrong.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T23:17:23Z
