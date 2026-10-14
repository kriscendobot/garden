---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/review-docket.sh
scripts/jobs/review-docket.sh:608 turns a bounded periodic reconcile timeout into exit 75, producing the systemd failure at 2026-10-14T22:00:13Z. Treat bare-reconcile lock-window exhaustion as a successful deferred tick after preserving the cursor, while retaining retryable failures for intake operations; add coverage for the unit-safe outcome.
