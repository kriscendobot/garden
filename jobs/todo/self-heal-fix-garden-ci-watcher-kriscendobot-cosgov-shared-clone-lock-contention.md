---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
`scripts/jobs/ci-watcher.sh` — every armed `garden-ci-watcher@<slug>` instance (~15 repos, same 90s cadence, `RandomizedDelaySec=30s`) shares ONE clone directory for both the read-only journal-verify clone and the stale-shepherd retire clone:

- line 82: `: "${GARDEN_CI_VERIFY_CLONE:=$GARDEN_STATE/ci-watcher/verify}"`
- line 87: `: "${GARDEN_CI_RETIRE_CLONE:=$GARDEN_STATE/ci-watcher/retire}"`

All instances therefore contend on the same sibling `clone_lock` (`common.sh`'s `.lock` file next to the clone dir). Failure signature observed on `kriscendobot-cosgov`: `clone lock .../ci-watcher/verify.lock busy >60s; backoff + retry (2/3)` ×2, then `FATAL: cannot acquire clone lock ... after 3 waits of 60s and 0 reclaim attempt(s) (a live holder is still busy...)` — a genuinely live sibling instance holding the lock past the 180s retry budget, not a crashed/stale holder (0 reclaims because the holder's stamp never crossed `GARDEN_LOCK_TTL=300s`).

This is the identical shape already diagnosed and fixed for `scripts/jobs/receipt-watcher.sh` on 2026-09-22 (see its `GARDEN_RECEIPT_WATCH_CLONE` default at line 59: `$GARDEN_STATE/receipt-watcher/journal-$slug`, with the rationale comment directly above it explaining the exact same shared-clone thundering-herd contention across per-slug systemd singletons). Port that fix to `ci-watcher.sh`: change both defaults to be per-slug, e.g.

```
: "${GARDEN_CI_VERIFY_CLONE:=$GARDEN_STATE/ci-watcher/verify-$slug}"
: "${GARDEN_CI_RETIRE_CLONE:=$GARDEN_STATE/ci-watcher/retire-$slug}"
```

with a comment mirroring `receipt-watcher.sh`'s rationale (each systemd instance is a per-repo singleton, so a per-slug clone has no concurrent users and the default `clone_lock` budget suffices; the shared clone was the only source of cross-instance contention). Check `scripts/jobs/test/ci-watcher-test.sh` for any test relying on the old shared-path default and update if needed. No functional change to what VERIFY/RETIRE are used for — only their default location.

<!-- garden-transient-elapsed: kind=signature through=0 values=10 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-27T00:23:03Z -->
