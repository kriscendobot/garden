---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
`verify_fetch` (comment-watcher.sh:469-476) calls `ensure_clone "$VERIFY"`, which internally takes `clone_lock`/`clone_unlock` (common.sh:4317-4341) around only the corruption-check-and-heal, then releases the lock *before* calling `journal_fetch "$VERIFY"` unlocked. Because `$GARDEN_COMMENT_VERIFY_CLONE` defaults to one shared path (`$GARDEN_STATE/comment-watcher/verify`) reused across every repo slug's comment-watcher instance (garden, minion.town, endo-but-for-bots), concurrent ticks race an unlocked `git fetch` into the same working directory, corrupting it — 25 corrupt-clone self-heals logged in ~30h across all three slugs (e.g. Sep 25 00:42:52, 01:31:25, 02:15:55, 03:03:45, 04:32:32, 06:06:49, 06:51:39). The self-heal recovers each time but at the cost of a full reclone every occurrence. Fix: hold `clone_lock "$VERIFY"` across both the `ensure_clone` call and the subsequent `journal_fetch` in `verify_fetch`, releasing only after the fetch completes — mirroring the existing serialized-shared-clone pattern already used for the per-host journal-cursor clone (common.sh § cursor-IO serialization, ~line 4162).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T07:22:11Z
