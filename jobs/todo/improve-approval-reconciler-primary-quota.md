---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/approval-reconciler.sh
scripts/jobs/approval-reconciler.sh:530 classifies GitHub’s primary-quota 403 as a generic transient, yielding a misleading 300s cooldown at 2026-10-04T11:49:02Z. Detect `is_gh_primary_rate_limit_text` before the generic transient branch, use `api_primary_quota_secs`, and add a regression fixture for the shared PR source’s primary-quota stderr.
