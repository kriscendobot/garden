---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/decision-append.sh
scripts/jobs/decision-append.sh:126 uses the default 3×60s clone-lock ladder for observability-only ledger writes, producing the 12:07:43 fatal under a live lock. Run the append clone operations in soft, short-wait mode and fail open through the existing outage latch, so controller actuation is never delayed by ledger contention.
