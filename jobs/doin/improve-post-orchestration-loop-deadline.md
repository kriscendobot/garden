---
posted_at: 2026-11-01T05:20:39Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-orchestration.sh
The push-retry loop at post-orchestration.sh:315 runs up to `GARDEN_POST_ATTEMPTS` (50) times with no `GARDEN_POST_DEADLINE_SECS` check. During a degraded journal remote, each attempt holds the producer clone lock, which starves other producers (the 2026-11-01 30-minute lock hold). `post-job.sh:354-356` shows the pattern to copy: record `post_loop_start`, check `SECONDS`, and exit with `GARDEN_OFFLINE_RC` (rc=75) on expiry. Apply it here and add a test for an unreachable journal, as `watchdog-notice-cas-test` does.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T05:57:04Z
