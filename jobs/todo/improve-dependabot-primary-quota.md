---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
scripts/jobs/dependabot-watcher.sh:367 classifies GitHub primary-quota refusal as a generic transient and opens only a 300s cooldown, despite the 2026-10-01T12:41:50Z warning proving `API rate limit exceeded`. Add the primary-quota branch used by ci-watcher before the generic transient branch, freezing work and arming `api_primary_quota_secs` so retries wait for the hourly reset.
