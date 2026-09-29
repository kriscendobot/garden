---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/issue-source-gh.sh
scripts/jobs/handlers/issue-source-gh.sh:96 calls `die` on primary-quota exhaustion before its parent can degrade, producing the 2026-09-29T08:34:52Z `FATAL` despite a recoverable shared cooldown. Return a distinguishable nonzero status with the captured diagnostic for primary-quota/transient API failures, so `issue-inbox-watcher.sh` owns the cooldown and emits only its single warning.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T09:14:33Z
