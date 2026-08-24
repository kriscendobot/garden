---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mentor.sh
Persist and rate-limit repeated identical transient-provider outages: retain retry behavior, but suppress duplicate warnings with bounded exponential backoff and emit a single recovery notice. The current every-tick WARN loop violates silent-until-error and repeatedly reprocesses the same digest.
