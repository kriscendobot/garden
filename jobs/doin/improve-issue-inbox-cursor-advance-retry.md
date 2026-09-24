---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
scripts/jobs/issue-inbox-watcher.sh:876-888 does a single bare `cursor-set.sh` call and WARN-exits on any nonzero rc, so a transient journal-write CAS collision (rc=1, observed 17:03:58, 17:18:00, and 17:20:09 in one 20-minute journalctl window) silently stalls the cursor advance every tick until a lucky retry lands. common.sh already has `advance_cursor_with_retry` (common.sh:4686) which retries under backoff on ambiguous contention and only WARNs-and-gives-up on a positively-identified DEFINITE failure (auth drift, corruption, etc.); comment-watcher.sh is already migrated to it (per scripts/jobs/test/comment-watcher-test.sh:256-289). Replace the inline cursor-set/WARN block in issue-inbox-watcher.sh with a call to `advance_cursor_with_retry "$CURSOR_KEY"` fed the same body, mirroring comment-watcher.sh's call site. mention-watcher.sh:518-525 has the identical un-migrated inline pattern and should get the same treatment in the same change since it shares the exact bug.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-24T17:21:13Z
