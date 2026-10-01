---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/scheduler.sh
scripts/jobs/scheduler.sh:559 treats EX_TEMPFAIL as work-present, causing repeated Dependabot dispatches while the shared GitHub API cooldown is active (2026-10-01T01:50:31Z). Handle rc=75 as a quiet deferred preflight result: leave the schedule due and post nothing, so it retries after cooldown expiry without consuming a botanist job.
