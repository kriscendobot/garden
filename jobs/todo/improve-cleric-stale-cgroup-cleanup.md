---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Before a restarted worker begins claiming, deterministically detect and terminate stale processes remaining in its systemd cgroup from a prior worker run. The repeated `garden-cleric@1` leftover-process warnings show process-group reaping misses detached descendants; clean them at startup so they cannot accumulate indefinitely.
