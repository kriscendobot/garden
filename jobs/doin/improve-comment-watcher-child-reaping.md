---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Make comment-source subprocess cleanup reliably leave the service cgroup empty across stop/restart races; a gh child still survived into the next watcher invocation despite the existing process-group and cgroup cleanup.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-19T20:53:34Z
