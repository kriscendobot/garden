---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Make the GitHub API cooldown state unambiguously host-shared across every systemd watcher invocation and verify it survives concurrent ticks. The digest shows CI watchers continuing quota-exhausted rollup calls after a primary-rate-limit detection, so the existing reactive cooldown is not suppressing sibling/next-tick requests reliably.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T07:51:35Z
