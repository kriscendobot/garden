---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/claim-job.sh
Defect: `scripts/jobs/claim-job.sh:264-298` uses only worker-offset rotation, allowing panel-7 for PR 171 to remain unclaimed for 12 hours while newer jobs are claimed (journal entry 2026-10-11T19:45:58Z).
Add an age-based priority tier with a bounded starvation threshold before the rotated ordinary candidates, preserving canary-probe precedence and host/provider eligibility checks.
