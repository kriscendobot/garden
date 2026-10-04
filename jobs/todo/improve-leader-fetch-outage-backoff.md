---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:5043 retries a timeout-bounded leader fetch after the 30-second cache TTL even during an open `leader-fetch` fallback episode, so every leader-gated unit can queue another failing remote probe. The warning at 2026-10-04T11:53:35Z confirms that failure path. Add a host-shared, atomic retry-backoff marker so callers reuse the cached leader during the outage and only one bounded probe is due per interval. Clear the marker on a successful fetch, retain the existing persistent-failure escalation, and extend `main-host-test.sh` for concurrent callers plus recovery.
