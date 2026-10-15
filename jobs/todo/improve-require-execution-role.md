---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-plan.sh
scripts/jobs/post-plan.sh:385-406 permits a runnable orchestrated child without `role`, `handler-budget-role`, or explicit `handler-timeout`, causing PR #1391’s fixer-like restack to receive the 2400-second default and overrun twice at 2026-10-15T07:20:51Z and 08:03:55Z. Reject such plans at posting time unless one of those execution-budget declarations is present, so long-running work receives the deterministic budget class before claim.
