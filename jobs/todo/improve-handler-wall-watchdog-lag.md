---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:731 watchdog failed to enforce its claimed bound: the 2026-10-23T19:12:28Z handler ran 15,479s under a 10,800s budget plus 60s grace. Harden the wall watchdog with an independently verifiable deadline and fail-closed process-tree reap when the watchdog is late or disappears; add a regression test for an over-budget handler.
