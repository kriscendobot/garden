---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1916 isolates unclassified source timeouts even when five distinct sources timed out between 03:27:29 and 03:28:17. Add a locked rolling multi-slug timeout threshold that opens the existing host-wide API cooldown and emits one episode warning, while retaining per-slug backoff for isolated timeouts.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T03:59:36Z
