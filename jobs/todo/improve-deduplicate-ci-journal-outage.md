---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
Harden the host-scoped journal-outage latch: two per-repo watchers on the same host both logged “host outage episode opened” in one outage despite the intended deduplication. Ensure the latch and lock resolve to one truly shared, race-safe path across all unit invocations, and extend the concurrent-outage test to reproduce this deployment shape.
