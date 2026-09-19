---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-get.sh
Harden journal-fetch outage classification so recurring ambiguous transport failures return the shared temporary-unavailable status and open one host cooldown, rather than producing per-repository cursor-read WARNs. Preserve loud handling for positively identified local clone, authentication, and upstream failures; add regression coverage for the observed rc=1 fetch-failure shape.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-19T19:21:17Z
