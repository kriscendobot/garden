---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-29T06:35:09Z
---
Implemented and pushed 7b2d6a401c8: budget-level now persists remote-spend failure incidents keyed by pool, host, operation, and reason; logs only the first identical warning; counts suppressed repeats; and emits reason-specific summaries when a valid snapshot returns. Added a deterministic stale/mismatch/recovery/re-arm regression and enrolled it in focused CI.

Execution evidence: budget-level-snapshot-warning-dedup-test.sh passed; proportional-worker-leveling-test.sh reported 9 passed, 0 failed; budget-snapshot-warning-dedup-test.sh and alert-maintainer-edge-test.sh passed; full shell bash -n and production scripts/jobs/*.sh ShellCheck gates passed. live-budget-admission-test.sh reported 55 passed and 3 pre-existing retired-kind expectation failures (gardener versus monk), unrelated to this change.

Self-improvement: nothing this time.
