---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/issue-source-gh.sh
scripts/jobs/handlers/issue-source-gh.sh:96 calls `die` on primary-quota exhaustion before its parent can degrade, producing the 2026-09-29T08:34:52Z `FATAL` despite a recoverable shared cooldown. Return a distinguishable nonzero status with the captured diagnostic for primary-quota/transient API failures, so `issue-inbox-watcher.sh` owns the cooldown and emits only its single warning.
