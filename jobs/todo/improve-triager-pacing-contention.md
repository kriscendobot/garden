---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Add a shared, short cooldown/readiness gate for the nonessential pacing-journal refresh so concurrent per-repo triager ticks do not repeatedly contend on one clone lock and emit warnings. Keep normal event triage and fixed timer cadence running; allow one later tick to retry pacing after the gate expires.
