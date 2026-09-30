---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/containment-gateway-record-check.sh
The scheduled agent check is deterministic filesystem scanning and hit its 2400s wall at 2026-09-30T03:05:25Z. Move the recursive active-store scan and record remediation from `journal/jobs/doin/fu-minion-town-containment-gateway-endo-sock-1-20260930-015006.md:11` into this bounded script, emitting only findings or scan failures. Have the schedule invoke it directly so routine no-change checks do not consume an agent claim.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T03:36:42Z
