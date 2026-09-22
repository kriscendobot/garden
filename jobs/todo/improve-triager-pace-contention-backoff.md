---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
After a soft pacing-clone lock failure, arm a host-shared longer contention cooldown so subsequent triager ticks skip the optional refresh quietly until it expires. The 13 repeated lock warnings show the existing 30-second gate does not suppress a persistently busy clone; add coverage for one warning/failure followed by clean skips and later recovery.
