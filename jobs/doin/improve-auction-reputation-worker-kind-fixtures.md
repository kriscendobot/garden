---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/test/auction-reputation-test.sh
The regression suite encodes retired `gardener` arm paths and event kinds at `scripts/jobs/test/auction-reputation-test.sh:114-115`, `:131`, and `:167-183`, causing its reducer assertions to fail despite a successful reducer run. Update all affected fixtures and expected arm paths to the current worker-kind taxonomy (`monk`), and reconcile the stale multi-attempt expected mean at `:531` with the current capped-span calculation. This restores the suite as a trustworthy guard for auction/reputation changes rather than masking real failures behind obsolete expectations.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T21:52:09Z
