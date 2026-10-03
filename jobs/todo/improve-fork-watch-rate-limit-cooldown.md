---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fork-watch-provisioner.sh
`scripts/jobs/fork-watch-provisioner.sh:213` calls `gh api` directly, so the rate-limit failure logged at 2026-10-03T15:50:30 only opens its private probe cooldown and does not arm the fleet-wide GitHub API cooldown. Route upstream probes through the shared cooldown-aware API helper, preserving the existing fail-open classification and adding a regression test that a 429 suppresses other GitHub pollers.
