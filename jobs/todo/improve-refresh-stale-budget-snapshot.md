---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/budget-level.sh
scripts/jobs/budget-level.sh:316 skips the `claude-oros` pool when its remote spend snapshot is stale, as logged at 04:20:06. Add a deterministic stale-snapshot remediation request to the owning host and keep the pool non-increasable until a fresh snapshot is accepted, rather than relying on an agent to notice the suppressed warning.
