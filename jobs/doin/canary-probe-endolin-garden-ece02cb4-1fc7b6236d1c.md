---
requires: host=endolin-garden-ece02cb4
canary-probe: true
handler-timeout: 120
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# rolling-deploy canary probe for endolin-garden-ece02cb4 @ 1fc7b6236d1c

Synthetic no-op round-trip probe: claim -> complete -> tada on the freshly deployed code.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T13:29:24Z
