---
requires: host=oros-studio-garden-ce242c49
canary-probe: true
handler-timeout: 120
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# liaison-posted round-trip probe for oros-studio-garden-ce242c49

Synthetic no-op probe (same shape rolling-deploy uses): claim -> complete -> tada
on this host, to validate the newly-onboarded host can claim work and push
evidence to origin/journal2.
