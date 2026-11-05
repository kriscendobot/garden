---
posted_at: 2026-11-05T14:21:39Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1941 records a second transient failure only as progress; four distinct jobs reached that state on `endolin-garden-ece02cb4` between 13:53:51Z and 14:13:28Z. Add a short-lived, host-local distinct-base burst detector that emits one deduplicated error and engages a bounded retry/claim cooldown for correlated second-attempt transient failures, while retaining the reaper as disposition owner.
