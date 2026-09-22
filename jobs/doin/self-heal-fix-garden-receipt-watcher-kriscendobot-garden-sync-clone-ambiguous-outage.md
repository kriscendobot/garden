---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`receipt-watcher.sh` (and every other direct `ensure_clone`/`sync_clone` caller — `comment-watcher.sh`, `ci-watcher.sh`, `triager.sh`) FATALs with rc=1 and empty diagnostic text on the "ambiguous journal-fetch outage" shape (retry-exhausted `journal_fetch`, rc=1, diagnostic matches `journal fetch in .* failed after N attempt`, not auth/corrupt/upstream-gone/local-fs). `journal_bounded_fetch_is_ambiguous_outage()` in `scripts/jobs/common.sh` (added in `917115c9b7`/`897d6beecb`) already classifies exactly this shape as transient for `cursor-get.sh`/`cursor-set.sh`, but `sync_clone()` in `scripts/jobs/common.sh` was never updated to use it: its retry-exhaustion branch (`die "fetch failed in $dir after bounded retries"`, around line ~6000) still treats this shape as a hard structural failure. Fix: in `sync_clone`, before the final `die "fetch failed in $dir after bounded retries"`, check `journal_bounded_fetch_is_ambiguous_outage "$rc" "$GARDEN_FETCH_STDERR"` (mirroring the check already in `cursor-get.sh`/`cursor-set.sh`) and take the same clean `log "offline; skipping tick (rc=$GARDEN_OFFLINE_RC)"; exit "$GARDEN_OFFLINE_RC"` path instead of dying, so every `sync_clone` caller inherits the same weather-vs-real-failure classification the cursor path already got. Add/extend `scripts/jobs/test/cursor-outage-cooldown-test.sh` (or a new `sync-clone` test) to cover a bare `ensure_clone`/`sync_clone` caller hitting this shape.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T05:46:30Z
