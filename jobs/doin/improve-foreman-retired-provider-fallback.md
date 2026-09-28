---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/foreman-claude.sh
scripts/jobs/handlers/foreman-claude.sh:124 fatals on a retired `local` entry, leaving the foreman unavailable at 18:09, 18:14, and 18:19. Filter retired `local` from the provider order with a one-time warning, then continue with remaining valid providers; fail only if none remain.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T18:21:03Z
