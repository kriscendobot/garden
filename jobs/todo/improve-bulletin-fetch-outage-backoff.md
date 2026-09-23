---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/bulletin.sh
Treat repeated bounded journal-fetch failures as one outage episode: log once, apply exponential/capped backoff before retrying, and resume promptly after a successful sync. The current five-second loop emitted 295 fatal lines during one outage, obscuring useful warnings.
