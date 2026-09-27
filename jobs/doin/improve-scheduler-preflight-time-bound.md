---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/scheduler.sh
Defect: `scripts/jobs/scheduler.sh:546` invokes a schedule preflight without a wall-clock bound; `garden-scheduler.service` timed out at 16:53:00Z. Run each preflight under a bounded timeout, clean its context file, log the schedule name on expiry, and preserve the existing fail-open dispatch behavior so one wedged preflight cannot consume the entire scheduler start budget.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-27T16:54:40Z
