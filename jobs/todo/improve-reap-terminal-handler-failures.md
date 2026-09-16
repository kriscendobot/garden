---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
When a handler terminates with a non-transient failure, durably stamp its still-claimed job for prompt reaping before or independently of error-reporting side effects. The observed failed review claim remained in `jobs/doin/` for hours after its worker moved on; it should enter the reaper’s bounded retry/doom path immediately rather than wait for the full claim TTL.
