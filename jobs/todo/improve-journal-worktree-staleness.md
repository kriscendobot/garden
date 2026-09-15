---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-worktree-keeper.sh
Persist the last successful reconciliation and enforce a bounded freshness threshold: retry/recover a stale shared journal worktree and emit one deduplicated actionable alert when it remains behind past the threshold. The keeper currently treats fetch/reconciliation failures as successful ticks, allowing a ~14-hour lag that agents must detect and route around manually.
