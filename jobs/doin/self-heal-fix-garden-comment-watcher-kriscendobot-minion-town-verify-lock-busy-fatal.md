---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In `scripts/jobs/comment-watcher.sh` `verify_fetch()` (~line 488), the outer `clone_lock "$VERIFY"` on the host-shared `.garden-state/comment-watcher/verify.lock` is a HARD lock. When a live peer instance holds it longer than the 3×60s ladder, `clone_lock` dies with rc=1 and wakes self-heal. Failure signature: `FATAL: cannot acquire clone lock /home/kris/garden2/.garden-state/comment-watcher/verify.lock after 3 waits of 60s and 0 reclaim attempt(s) (a live holder is still busy ...)`. In this incident the holder was the live `comment-watcher.sh kriscendobot-garden` tick, running for over 5 minutes. The existing `clone_lock_is_busy_contention` classification only covers the inner `ensure_clone_or_latch_outage` subshell, not this outer lock.

Fix: mirror `ci-watcher.sh` `verify_fetch` (~line 235-254). Take the outer lock as `GARDEN_CLONE_LOCK_SOFT=1 GARDEN_CLONE_LOCK_SOFT_COOLDOWN_KEY=comment-watcher-verify clone_lock "$VERIFY"`, so a busy live holder becomes a quiet `GARDEN_OFFLINE_RC` (75) skip that also latches a host cooldown for sibling slugs. Before landing, confirm this is safe: a skipped tick must not advance the cursor, and a skip during the `fresh` post-confirm must leave the comment for re-processing on the next tick, where the idempotency pre-check dedups it. Add a test in the same style as the ci-watcher soft-lock coverage.

Secondary item: the shared VERIFY clone is 1.7G (`.garden-state/comment-watcher/verify`). Check whether it is bloated (packs or gc.log, the same class as the state-clone bloat wedge) and gc it if so, because a slow fetch there is what makes holders outlast the ladder.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T04:05:42Z
