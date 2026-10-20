---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
Defect: `scripts/jobs/mirror-closer.sh:325` opens the all-API cooldown after its default state reader’s GraphQL call, silencing REST comment latency work; both watchers reported quota exhaustion at 2026-10-20 16:18:14Z.
Pass the GraphQL scope when handling state-read quota failures and add a regression test that a GraphQL latch does not suppress REST watchers.
