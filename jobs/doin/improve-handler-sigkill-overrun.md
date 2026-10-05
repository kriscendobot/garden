---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1340 classifies rc=137 as an external kill before the deadline-overrun path, although the timeout escalation is also rc=137. At 2026-10-05T11:10:43Z, `retire-gardener-clone-alias-verify-deploy-reaper` repeated rc=137 after 3240s and consumed its ordinary retry. Detect SIGKILL at the configured handler wall plus kill grace, stamp the deadline-overrun hint, and let the reaper split/escalate it without treating it as an arbitrary transient signal.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-05T11:21:29Z
