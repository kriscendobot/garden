---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/follow-up.sh
scripts/jobs/follow-up.sh:212 suppresses cursor-set diagnostics and retries only on the next tick after the 10:18:35 publication failure. Use the shared bounded cursor-advance retry/classification helper so transient lock/CAS failures retry within the tick and deterministic remote rejections retain their diagnostic and repair alert.
