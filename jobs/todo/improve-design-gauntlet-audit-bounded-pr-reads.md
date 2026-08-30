---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/design-pr-gauntlet-coverage-audit.sh
Bound each per-PR `gh pr view` call with the audit’s existing timeout policy and treat a timeout as an inconclusive skip. The service exceeded its 900-second systemd deadline despite bounded repo enumeration, so an unbounded per-PR metadata read can stall the whole periodic backstop.
