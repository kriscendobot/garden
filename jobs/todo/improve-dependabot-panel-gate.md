---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/ci-wait-merge.sh
scripts/jobs/gardening/ci-wait-merge.sh:849 requires a completed panel even in `--dependabot-auto-merge`, so the validated MERGE-NOW PR #1550 stalled with `panel-head-blocked reason=missing` at 2026-10-25T20:05:07Z.
For the existing bot-owned, verified Dependabot path only, replace that unavailable agent-panel requirement with a deterministic gate and retain CI, author, rebase, and CHANGES_REQUESTED guards.
Add regression coverage beside T47–T50 proving the narrow exception merges only a verified Dependabot PR and ordinary merges still fail closed without panel coverage.
