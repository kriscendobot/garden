---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/rolling-deploy.sh
scripts/jobs/rolling-deploy.sh:596 and :761 retry a candidate-gate-rejected target every tick, producing repeated leader self-deploy warnings after the 2026-09-27T10:23:51Z rejection. Persist a target-keyed rejected-candidate marker after a nonzero deploy, skip retries quietly until the available SHA changes or an explicit override clears it, while retaining the original deploy error report.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-27T10:58:54Z
