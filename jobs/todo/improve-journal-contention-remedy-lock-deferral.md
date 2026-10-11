---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-contention-watch.sh
scripts/jobs/journal-contention-watch.sh:155 retries optional clone remediation while a live owner holds its lock, emitting fail-open WARNs for bulletin and orch at 18:39:39Z and 18:40:20Z. Record a per-clone live-lock deferral/backoff and suppress the expected soft-lock diagnostic until its expiry; retry deterministically afterward.
