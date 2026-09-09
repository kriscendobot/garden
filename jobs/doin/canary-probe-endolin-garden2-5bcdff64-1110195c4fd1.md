---
requires: host=endolin-garden2-5bcdff64
canary-probe: true
handler-timeout: 120
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# rolling-deploy canary probe for endolin-garden2-5bcdff64 @ 1110195c4fd1

Synthetic no-op round-trip probe: claim -> complete -> tada on the freshly deployed code.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-09T20:44:15Z
