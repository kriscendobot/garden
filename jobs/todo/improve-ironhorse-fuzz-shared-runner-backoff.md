---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ironhorse-fuzz.sh
When every fuzz target’s runner returns rc=2 in the same tick, treat it as a shared campaign setup outage: emit one deduplicated warning, skip the remaining targets, and persist a bounded retry cooldown. Have the runner distinguish shared provisioning/toolchain failures from target-specific failures so a missing checkout/toolchain does not repeatedly invoke nine expensive runners or flood logs each tick.
