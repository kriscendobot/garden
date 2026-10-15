---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/arc-status-report.sh
The completion-press first-pass report ran a path-limited `git log` that exceeded the 120s fleet git bound on oros-studio (rc 124, progress entry 2026-10-15T16:08:06Z). A rerun with GARDEN_REPO_GIT_TIMEOUT=540 took 82s. If the script that builds this report is not this one, apply the fix to the actual report-building script. Set a default GARDEN_REPO_GIT_TIMEOUT of at least 300s for the report's git calls. Also make the path-limited log cheaper, for example with a bounded `--since` window and `--no-renames`, so the report does not need a manual rerun to finish.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-15T21:43:21Z -->
