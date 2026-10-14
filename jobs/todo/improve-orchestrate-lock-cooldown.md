---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/orchestrate.sh
scripts/jobs/orchestrate.sh:120-122 refreshes the orchestration clone without a service-scoped contention cooldown; its lock emitted a soft-refresh warning at 2026-10-14T06:37:52Z. Make a busy clone lock a bounded, cleanly deferred tick with an orchestrate-specific cooldown, so concurrent or repeated timer firings retry later without warning churn.
