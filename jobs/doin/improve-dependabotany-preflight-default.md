---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-schedule.sh
Automatically attach and preserve `dependabotany-preflight.sh` for every `dependabotany-recheck-*` schedule, then migrate the existing schedule. The current ungated daily backstop repeatedly dispatches a gardener for a provably empty Dependabot set and produces verbose clean-confirmation journal entries.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T17:21:03Z
