---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
scripts/jobs/comment-watcher.sh:1664 propagates a primary-quota rc 75 without opening the shared REST cooldown; the 2026-09-28T19:33:37Z warning shows comment-latency-watch opening it later. Detect the primary-quota stderr in this branch, call start_api_cooldown, and cleanly skip while preserving cursor freeze; add a regression test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T19:51:11Z
