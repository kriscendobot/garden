---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/scheduler.sh
Capture the budget-level controller’s stderr and exit status, then emit a deduplicated actionable alert with the failure detail. It is failing repeatedly every 15 minutes while the scheduler only logs a generic fail-open warning, leaving no diagnostic trail to harden or repair the controller.
