---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/ci-watcher.sh` shares one journal clone across all 14 armed `garden-ci-watcher@<slug>` instances: `GARDEN_CI_VERIFY_CLONE` defaults to `$GARDEN_STATE/ci-watcher/verify` and `GARDEN_CI_RETIRE_CLONE` to `$GARDEN_STATE/ci-watcher/retire`, with no per-slug distinction (ci-watcher.sh:82,87). Because all instances tick concurrently on the same cadence, one instance's reclone (e.g. kriscendobot-minion.town) holds the shared `clone_lock` long enough that a sibling (kriscendobot-ymax-e2e) exhausts its 3×60s wait budget and exits FATAL rc=1 ("cannot acquire clone lock .../ci-watcher/verify.lock after 3 waits of 60s and 0 reclaim attempt(s)"), confirmed by the live holder PID still running past the deadline — a real capacity limit, not a stale/crashed lock. `receipt-watcher.sh` hit and fixed this exact pattern (see its lines ~44-56): switch to a per-slug clone path, `GARDEN_RECEIPT_WATCH_CLONE:=$GARDEN_STATE/receipt-watcher/journal-$slug`, so each systemd-singleton instance owns its own clone and lock with no cross-instance contention. Apply the same change to `ci-watcher.sh`: default `GARDEN_CI_VERIFY_CLONE` to `$GARDEN_STATE/ci-watcher/verify-$slug` and `GARDEN_CI_RETIRE_CLONE` to `$GARDEN_STATE/ci-watcher/retire-$slug`, and add a comment mirroring receipt-watcher.sh's rationale. Bounded clone-directory growth (one per armed slug, ~14 currently), reused across ticks — same shape as the receipt-watcher precedent.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-26T23:58:05Z
