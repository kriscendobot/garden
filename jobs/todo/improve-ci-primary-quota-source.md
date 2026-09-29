---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
scripts/jobs/ci-watcher.sh:483 classifies the 2026-09-29T18:38:35 REST primary-quota refusal as a generic transient and opens only the 300s cooldown. Detect `is_gh_primary_rate_limit_text` before that branch and request `api_primary_quota_secs` on the host-wide REST-capable latch; add a regression test so the watcher does not resume known-doomed source polls within the same quota window.
