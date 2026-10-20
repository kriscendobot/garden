---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:10794 omits `weaver`, so the PR #201 weave received the generic 2400s wall and deterministically timed out at 2026-10-20T13:37:26Z. Add a configurable 7200s weaver default to the canonical budget resolver and cover it with the handler-budget test, so gardener and reaper retain the same safe long-running budget.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-20T13:54:18Z
