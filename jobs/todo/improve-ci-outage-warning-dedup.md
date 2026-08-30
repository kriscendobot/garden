---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
Deduplicate stale-shepherd “journal fetch failed” warnings across per-repo CI watchers with a host-scoped outage latch and recovery notice. One shared journal outage currently emits an indistinguishable warning per watched repository while each correctly skips unsafe board mutation.
