---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pr-feedback-preflight.sh
Detect a referenced issue before attempting PR-feedback evidence gathering, and treat it as an inapplicable preflight no-op without warning/alert noise. Issue directives currently trigger expected GitHub 404s that are logged as a fail-open infrastructure failure.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-01T05:21:09Z
