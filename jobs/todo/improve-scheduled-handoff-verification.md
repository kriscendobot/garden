---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/complete-job.sh
The 2026-09-28T21:06:18Z completion gate rejected a durable one-time scheduled successor because complete-job.sh:166 accepts only an already-materialized board job. Recognize a matching future `schedules/*.md` `once:` record and `job_basename_prefix` as a verifiable handoff, shared with assert-followup-posted.sh, so agents can reliably defer deployment-gated retries without being reaped.
