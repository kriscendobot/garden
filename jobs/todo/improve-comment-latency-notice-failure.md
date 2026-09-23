---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-latency-watch.sh
Make watchdog-notice delivery failures nonfatal: log the failure, retain the alert state for retry, and complete the liveness tick so a journal/push outage cannot restart-loop this service. Add a regression case for a failing notice handler.
