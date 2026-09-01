---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Before a restarted worker begins claiming, deterministically detect and terminate stale processes remaining in its systemd cgroup from a prior worker run. The repeated `garden-cleric@1` leftover-process warnings show process-group reaping misses detached descendants; clean them at startup so they cannot accumulate indefinitely.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T14:51:10Z
