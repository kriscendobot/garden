---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh:45 — `GARDEN_RECEIPT_WATCH_CLONE` defaults to one clone (`$GARDEN_STATE/receipt-watcher/journal`) shared across ALL 16 `garden-receipt-watcher@<slug>` templated instances, which run concurrently (OnUnitActiveSec=300s, RandomizedDelaySec=60s spread against per-run wall times of 30–100s+). This causes routine cross-instance contention on the shared clone_lock/lockfile serializing `ensure_clone`/`sync_clone` (fetch + `git reset --hard`).

Failure signature: `FATAL: receipt journal prerequisite failed for <repo> (rc=1; see prerequisite stderr above)` at receipt-watcher.sh:91, with EMPTY prerequisite stderr (no `git`/`journal fetch failed`/lock-wait diagnostic text at all — ruling out the documented die() paths inside `clone_lock`/`journal_fetch`, which always log before exiting). journalctl confirms this recurs across DIFFERENT slugs (kriscendobot-garden, kriscendobot-proposal-compartments, kriscendobot-cosgov, kriscendobot-endo-but-for-bots, endojs-endo-but-for-bots) clustered within the same few-minute window on 2026-09-22, all at the identical step — consistent with contention on the shared clone/lock (possibly the unguarded retry `git reset -q --hard` at common.sh:6023, which has no log/die wrapper, or a clone_lock stale-reclaim race under load) rather than a per-repo or network cause. The clone is healthy now (git status clean, up to date), so it self-resolved once the concurrent instances desynced.

Fix: default `GARDEN_RECEIPT_WATCH_CLONE` to a per-slug path, e.g. `$GARDEN_STATE/receipt-watcher/journal-$slug`, so each of the 16 templated instances syncs its own clone and no longer contends for one shared lockfile. Verify against `scripts/jobs/test/receipt-watcher-test.sh` (may need a fixture update if it hardcodes the shared clone path) and confirm `receipts/$slug`, panel-runs, and jobs/index reads still resolve correctly per-instance.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T01:11:11Z
