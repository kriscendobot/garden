---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
Make `budget_publish_local_pool` retry boundedly after a failed journal push: re-sync, rebuild the cadence-bucketed snapshot, and retry CAS publication before declaring remote budget visibility unavailable. Preserve fail-open behavior and add coverage for a transient push-race failure.
