---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Stop emitting a shared journal progress entry for a first-cycle transient merely to reconstruct elapsed-time history. Persist the minimal elapsed classification deterministically with the claim/requeue metadata (coordinate with `reaper.sh` if needed), and emit journal output only on a repeated/near-doom condition. This keeps routine self-healing failures out of the mentor digest while preserving early wedge detection.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-24T05:53:12Z
