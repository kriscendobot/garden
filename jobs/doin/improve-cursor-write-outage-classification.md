---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-set.sh
Detect journal transport outages and honor the shared cooldown before retrying CAS writes; classify bounded ambiguous fetch failures conservatively while preserving loud structural/auth failures. The current repeated rc=1 cursor reads/advances let write retries run long enough to contribute to receipt-watcher systemd timeouts.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-19T21:21:17Z
