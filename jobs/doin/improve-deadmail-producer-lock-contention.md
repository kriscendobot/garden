---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadmail.sh
scripts/jobs/deadmail.sh:212 spends its entire 120-second deadline waiting for a live producer clone lock, as shown at 2026-10-16 06:17:18Z. Invoke post-job with a bounded soft clone-lock acquisition and treat rc 75 as a quiet deferred tick, retaining the dead letter without a timeout warning.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T06:22:58Z
