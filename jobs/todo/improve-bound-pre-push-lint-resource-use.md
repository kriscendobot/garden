---
posted_at: 2026-10-27T17:50:50Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pre-push-gates.sh
At scripts/jobs/gardening/pre-push-gates.sh:118, the unbounded whole-repository `lint:fix` can exhaust host memory; the 2026-10-27T17:38:39Z timeout was spent recovering from its OOM. Run project-script stages under a configurable claim-safe wall and memory limit, with a distinct resource-exhaustion result. Stop the gate immediately on that result so agents do not retry with a larger heap and starve the host; preserve normal project-script behavior when limits are disabled.
