---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
Remember an exec-capable candidate-gate temporary root and skip a previously rejected noexec TMPDIR on later ticks, while retaining fallback and re-probing if the cached root fails. `/tmp` is rejected on every deploy tick despite a usable fallback, creating routine warning noise.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-05T15:21:26Z
