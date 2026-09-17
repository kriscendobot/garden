---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
Recognize a completed gauntlet panel report whose sole follow-up is the deterministic driver-owned fix-loop transition (including a `gauntlet-stage-result: panel=must-fix` marker). The current gate treats it as an unposted successor and repeatedly fails an otherwise successful panel stage.
