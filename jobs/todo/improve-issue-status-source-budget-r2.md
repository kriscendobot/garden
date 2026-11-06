---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:54Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T03:39:08Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-status-pass.sh
scripts/jobs/issue-status-pass.sh:211 repeatedly exhausts the tick before the source read (12:51:55Z, 13:17:05Z, 13:20:22Z). Read and trust-filter the source before expensive board snapshot work, reserving its configured timeout from the pass budget; then build the board only after a successful source read.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-06T03:53:05Z -->
