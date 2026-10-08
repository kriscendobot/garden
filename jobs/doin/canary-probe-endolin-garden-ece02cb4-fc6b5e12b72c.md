---
requires: host=endolin-garden-ece02cb4
canary-probe: true
handler-timeout: 120
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# rolling-deploy canary probe for endolin-garden-ece02cb4 @ fc6b5e12b72c

Synthetic no-op round-trip probe: claim -> complete -> tada on the freshly deployed code.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-08T22:21:40Z
