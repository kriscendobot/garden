---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Suppress the shared `kind:progress` entry for a first `exit-0-unsatisfying` requeue; the current cycle-1 path contradicts its silent-until-repeat policy and needlessly sends routine self-healing noise to the mentor. Preserve escalation for repeated or near-doom cycles, with regression coverage.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-12T18:21:15Z
