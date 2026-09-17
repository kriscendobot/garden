---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Make the GitHub API cooldown state unambiguously host-shared across every systemd watcher invocation and verify it survives concurrent ticks. The digest shows CI watchers continuing quota-exhausted rollup calls after a primary-rate-limit detection, so the existing reactive cooldown is not suppressing sibling/next-tick requests reliably.
