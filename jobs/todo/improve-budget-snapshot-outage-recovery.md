---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
scripts/jobs/usage-meter.sh:887 exhausts CAS retries, while :926 suppresses all further failures; the 21:01:05 publication CAS warning was followed by a 21:20:11 stale remote snapshot. After the snapshot max-age elapses, re-clone and retry publication once with an edge-latched escalation, retaining fail-open worker reconciliation.
