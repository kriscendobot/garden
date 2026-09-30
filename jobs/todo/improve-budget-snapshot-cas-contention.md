---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
scripts/jobs/usage-meter.sh:813-857 publishes every host immediately on the shared cadence boundary; CAS exhaustion recurred at 13:31:43 and 13:46:13. Add deterministic host-keyed publication staggering within each snapshot bucket, while preserving bounded retry and maximum-age guarantees, and cover simultaneous-host contention in the publisher test.
