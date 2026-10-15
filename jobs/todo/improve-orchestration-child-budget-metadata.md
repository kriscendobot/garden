---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-orchestration.sh
scripts/jobs/post-orchestration.sh:259 accepts automatic child bodies without a runtime role or handler budget; the PR #774 restack consequently hit the generic 2400s wall at 2026-10-15T05:00:06Z. Require structured role or handler-budget metadata for atomic automatic children, and reject/hold ambiguous bodies before they enter the board.
