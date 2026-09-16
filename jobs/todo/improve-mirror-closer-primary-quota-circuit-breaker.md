---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
After the first GitHub primary-quota failure in a tick, stop querying remaining mappings and emit one aggregate degraded warning; preserve all mappings unresolved for retry after quota reset. This avoids repeated doomed API calls and fatal-per-mapping log noise. Add hermetic coverage in the mirror-closer test.
