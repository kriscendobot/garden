---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/ironhorse-fuzz-run-gh.sh
Detect Git object corruption while refreshing the dedicated fuzz checkout, quarantine and recreate only that disposable project cache, then retry provisioning once. The recurring `fatal: pack has unresolved deltas` currently disables the entire campaign every 900 seconds despite the persistent corpus living safely outside this checkout.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-31T06:50:59Z
