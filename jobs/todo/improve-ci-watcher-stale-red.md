---
posted_at: 2026-11-11T02:51:17Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
scripts/jobs/ci-watcher.sh:604-610 permanently skips red bot PRs whose head is older than the activity window; at 2026-11-11T02:43:51Z, unchanged red PR #1646 had no automatic shepherd and required a manual post. Add a bounded, rotating low-frequency rollup sweep for stale eligible PRs so persistent completed-red CI eventually mints the existing deterministic shepherd job without defeating the per-tick API budget.
