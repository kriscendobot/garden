# Investigate + fix slow fleet-restart in deploy-garden (14 min for 77 units)

**Garden-infra reliability issue.** On the leader (`endolinbot2`), a
`deploy-garden.sh` run took **~14 minutes almost entirely inside
`restart_long_running_fleet`**: drain lifted at 21:37:30, "restart complete:
restarted=77" at 21:51:31 (2026-06-29) — about **11s per unit**. Deploys that
restart only 1–3 units finish in ~10s total. At the current ~15-min `main2`
commit cadence, a 14-min deploy puts the leader in near-continuous drain/restart.

**Why ~11s/unit is wrong:** gardeners are "cheaply idle-blocked" most of the
time; a SIGTERM during a blocking wait should stop them near-instantly. ~11s each
implies every stop is waiting out a timeout rather than exiting on the signal.

**Hypotheses to check (in priority order):**
1. **SIGTERM not promptly forwarded.** The gardener unit execs
   `self-heal-run.sh ... -- gardener.sh %i`. If the wrapper (bash) doesn't
   forward SIGTERM to its child / isn't `exec`-ing the worker, systemd's stop
   waits out `TimeoutStopSec` (default 90s, or whatever the unit sets) then
   SIGKILLs — explaining the per-unit delay. Check `garden-gardener@.service`
   `KillMode`/`TimeoutStopSec` and whether `self-heal-run.sh` `exec`s or traps+
   forwards signals.
2. **Drain lifted BEFORE restart.** `deploy-garden.sh` lifts the drain, *then*
   restarts. If gardeners resume claiming in that window, the per-unit restart
   must stop now-busy workers. Consider restarting the gardener fleet while still
   drained (or not lifting until after), so stops hit idle workers.
3. **Sequential restart of 77 units.** If `restart_long_running_fleet` restarts
   serially, parallelizing (or `try-restart`/batched) would cut wall-time.

**Deliverable:** a fix that makes a gardener stop near-instant (so a full-fleet
restart is seconds, not minutes), measured before/after (per-unit stop time and
total restart wall-time). Touch the deploy/restart path only:
`scripts/jobs/deploy-garden.sh`, `scripts/jobs/deploy-restart.sh`,
`scripts/jobs/self-heal-run.sh`, `scripts/systemd/garden-gardener@.service`.
Land on `main2` via an **isolated worktree off origin/main2** (the shared root
tree is concurrently mutated; commit explicit pathspecs, push `HEAD:main2`).
Add/extend a test under `scripts/jobs/test/` if the change is logic, not just unit config.
