Everything landed cleanly. Job complete.

---

## Completion report: `improve-deploy-sync-fleet-onto-landed-fixes`

**Landed on `origin/main2` as `5d6490e62`** (built in an isolated worktree off `origin/main2` per the shared-tree convention, then torn down).

### What I built
A deterministic deploy reconciler that re-execs the long-running fleet onto landed script fixes:

- **`scripts/jobs/deploy-sync.sh`** (new) — each tick: fetches `origin/main2`; advances the checkout **only** by a strict clean fast-forward (`git merge --ff-only`), skip-and-log if the tree is tracked-dirty or diverged (never clobbers a peer's in-flight edits; untracked files don't block, mirroring the watchman); and when `scripts/` actually changed, restarts the long-running services so they re-exec. Re-renders units first when `scripts/systemd/` changed. Honors the killswitch (advances the tree but defers restarts when the fleet is intentionally stopped).
- **`scripts/systemd/garden-deploy-sync.{service,timer}`** (new) — a self-heal-wrapped oneshot on a ~3-min cadence. Auto-enabled by `install-units.sh`'s derived enable-set (no hand-list edit needed).
- **`scripts/jobs/gardener.sh`** (modified, +19 lines) — drops a local, lock-free busy marker (`$GARDEN_STATE/gardeners/<id>/busy`) while a handler runs and clears it between claims (and at startup, so a crash can't permanently exempt an id). This is the **between-claims, not mid-job** gate: deploy-sync restarts idle/crash-looping gardeners immediately and defers a mid-job gardener to a later tick. (Singleton long-running units — bulletin/driver/watcher — are restarted directly; timer-driven oneshots are deliberately *not* restarted since they re-read their script on the next firing.)

### Verification
- New **`deploy-sync-test.sh`**: 25/25 pass (no-op, clean deploy with idle-restarted vs busy-deferred gardeners, non-scripts change, killswitch defer, dirty-tree skip, untracked-file pass-through, diverged skip).
- **`run-test.sh`** subtest 1 (concurrency): green — the gardener loop still claims/completes cleanly with the marker edits (doin/work empty).
- Fixed a **pre-existing** stale failure in `enable-services-test.sh` (asserted `garden-design-poller.service`, retired 2026-06-26) → that suite now 14/14.

### Follow-ups surfaced to the maintainer (via inbox)
1. **Bringup**: the reconciler is inert until armed; `garden-deploy-sync.timer` auto-enables on the next `install-units.sh install && enable-services`.
2. **Live tree is currently dirty-wedged** (the job's root symptom): `/home/kris` is 6 behind `origin/main2`, blocked by a working-copy edit to `skills/gardener-inbox-error-reporting/report-error.sh` whose content is **byte-identical to origin's committed version** (a redundant uncommitted edit). git refuses the fast-forward while dirty, so *both* the watchman and deploy-sync skip the advance. `git -C /home/kris checkout -- <that file>` is lossless and unwedges it. I deliberately did **not** mutate the shared live tree from a gardener job.
