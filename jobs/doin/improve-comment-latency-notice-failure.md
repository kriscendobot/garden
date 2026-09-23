---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-latency-watch.sh
Make watchdog-notice delivery failures nonfatal: log the failure, retain the alert state for retry, and complete the liveness tick so a journal/push outage cannot restart-loop this service. Add a regression case for a failing notice handler.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T23:21:48Z
