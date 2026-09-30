---
requires: host=endolin-garden2-5bcdff64
canary-probe: true
handler-timeout: 120
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# rolling-deploy canary probe for endolin-garden2-5bcdff64 @ 3414686f1dfe

Synthetic no-op round-trip probe: claim -> complete -> tada on the freshly deployed code.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T07:00:02Z
