## Completion report — `improve-deploy-always-reconciles-units`

**Finding (key context):** The job's core ask was **already satisfied** on `origin/main2` before I started. Two peer commits landed during/before this job:
- `8792b3d2b` — added an **unconditional** unit-reconcile step (`install-units.sh install` + `enable-services`) to `deploy-garden.sh`, right after `record_deployed_sha`. This runs **every deploy regardless of whether `scripts/systemd/` changed**, making the deploy itself the authority that no retired unit survives. That is exactly what the job asked for at the system level, and it eliminates the need for the reactive `*-deploy-reconcile-retired-units` self-heal job.
- `49f4c47e3` — generalized retirement to a self-reconciling `prune_retired` in `install-units.sh` (deleting a unit from `scripts/systemd/` now retires it automatically; the by-name `RETIRED_UNITS` list is empty by default).

**What I did:** Resolved the precise residual gap the job named — the now-redundant `units_changed`-gated `install` inside `restart_long_running_fleet` (`scripts/jobs/deploy-restart.sh`). With `deploy-garden.sh` already reconciling unconditionally *before* calling restart, that gated `install` was both redundant (the render already happened) and strictly weaker (a render alone never disables a retired unit — the very edge that let `garden-deploy-sync` survive a deploy that didn't touch `scripts/systemd/`).

**Change** (commit `f94b54713` on `main2`, one file, +18/−17):
- Removed the `units_changed`-gated `install` block from `restart_long_running_fleet`; the function now solely re-execs the long-running fleet. `scripts_changed` still gates whether any re-exec is needed.
- Removed the now-unused `HERE_RESTART` definition and `units_changed` bookkeeping.
- Updated the header comment to document that unit reconciliation is owned by the deploy's dedicated unconditional step, and that callers must reconcile before calling (deploy-garden.sh does).

**Verification:** `deploy-garden-test.sh` 40/40 and `enable-services-test.sh` 24/24, both re-run after rebasing onto the peer's `49f4c47e3`. The UNIT RECONCILE case exercises the restart path through a real deploy; the CLEAN DEPLOY case changes a non-`systemd/` script and still restarts the fleet, confirming the gate removal didn't break the restart path.

**Process notes:** Developed in an isolated worktree off `origin/main2` (never the root checkout); torn down. First push was rejected by a concurrent peer push (`49f4c47e3`); fetched, rebased cleanly (no conflict — disjoint files), re-verified, re-pushed. Inbox empty at completion.

**Follow-ups:** None required. The redundant-but-harmless double-reconcile concern is resolved; `deploy-garden.sh` is now the single, unambiguous authority for unit reconciliation, and `restart_long_running_fleet` is focused purely on the fleet re-exec.
