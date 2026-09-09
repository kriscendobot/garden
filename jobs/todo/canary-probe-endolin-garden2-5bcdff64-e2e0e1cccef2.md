---
requires: host=endolin-garden2-5bcdff64
canary-probe: true
handler-timeout: 120
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# rolling-deploy canary probe for endolin-garden2-5bcdff64 @ e2e0e1cccef2

Synthetic no-op round-trip probe: claim -> complete -> tada on the freshly deployed code.
