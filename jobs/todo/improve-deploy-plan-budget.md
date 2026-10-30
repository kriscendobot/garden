---
posted_at: 2026-10-30T07:51:00Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-plan.sh
scripts/jobs/post-plan.sh:341 permits a deferred deployment-and-production-evidence job without a runtime budget; the 2026-10-30T07:45:02Z entry shows `minion-town-shell-captp-session-rung0a-deploy` deterministically killed at the 2400s default. Detect deployment/production-observation plans lacking `role`, `handler-budget-role`, or `handler-timeout:` and stamp a claim-safe long budget (or refuse them with an actionable error). Add a regression test covering the resulting promoted job frontmatter.
