---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:643’s timeout failed to bound the claimed handler: the 2026-09-30T05:36:39Z entry reports rc=124 after 3702s against a 2400s budget. Add an independent process-group watchdog that TERM/KILLs the recorded handler pgid at budget plus grace, and reap/cancel it on every handler exit. Preserve the claim-TTL invariant and test that a TERM-ignoring descendant cannot extend the worker past the configured bound.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T06:31:59Z
