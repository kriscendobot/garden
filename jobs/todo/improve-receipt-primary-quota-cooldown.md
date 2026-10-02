---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
scripts/jobs/receipt-watcher.sh:97-101 treats GitHub primary-quota stderr as a generic transient and logs a 300s cooldown, though the 2026-10-02T19:45:23Z warning was followed by a 3599s primary-quota latch.
Detect primary quota before the generic transient path, request `api_primary_quota_secs`, and log the actual full quota cooldown; add a regression test for the adopted `gh_api_retry` latch.
