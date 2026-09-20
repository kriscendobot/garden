---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
Recognize a Follow-ups section that only presents an already-surfaced maintainer decision as closed, rather than requiring a new handoff or override; this prevented an accepted #1310 status-report directive from completing and caused a duplicate retry.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-20T15:53:11Z
