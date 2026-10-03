---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/common.sh, `ensure_clone` (line 4829) and the identical pattern inside `clone_lock` (line 4570) both do `garden_repo_lock "$dir" exclusive || die "repository lock unavailable for $dir"`. `garden_repo_lock` returns 124 specifically when `_garden_lock_wait` times out waiting on a live (possibly overdue but not dead) holder — distinct from other failure rcs (bad/missing repo, etc). Treat an rc=124 lock-wait timeout as transient, matching the established pattern elsewhere in this file (`sync_clone`'s offline-skip path, and `clone_lock`'s `GARDEN_CLONE_LOCK_SOFT` busy-holder path): log and `exit "$GARDEN_OFFLINE_RC"` instead of `die`, so `self-heal-run.sh` classifies it as a clean skip-and-retry-next-tick rather than escalating to a diagnose-and-fix-job responder. Keep `die` for any other `garden_repo_lock` failure rc (genuine repo error). Failure signature: "garden repo lock: timeout after ${GARDEN_REPO_LOCK_WAIT}s: .../repo.lock (exclusive)" immediately followed by "FATAL: repository lock unavailable for <dir>", observed when another live process holds the clone's exclusive repo lock for longer than GARDEN_REPO_LOCK_WAIT (10s) — a normal occurrence under fleet contention, not a repository defect.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-03T09:10:18Z
