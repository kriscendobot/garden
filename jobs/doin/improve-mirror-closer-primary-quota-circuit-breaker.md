---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
After the first GitHub primary-quota failure in a tick, stop querying remaining mappings and emit one aggregate degraded warning; preserve all mappings unresolved for retry after quota reset. This avoids repeated doomed API calls and fatal-per-mapping log noise. Add hermetic coverage in the mirror-closer test.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T18:51:15Z
