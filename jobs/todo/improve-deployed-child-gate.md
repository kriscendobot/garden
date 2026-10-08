---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/orchestrate.sh
scripts/jobs/orchestrate.sh:20 promotes serial children after board completion only, while this child must wait for its predecessor’s leader deployment; it exit-0-unsatisfied twice by 2026-10-08T05:45Z. Add declarative deployed-predecessor metadata and keep such children parked until `fleet/deployed/<leader>` contains the required SHA. This moves deterministic deployment polling out of the agent and prevents requeue wedges.
