---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/decision-append.sh
Add a host-scoped outage latch with one opening warning and a recovery summary. Repeated fail-open ledger writes are observability-only and currently emit recurring warnings during the same journal outage.
