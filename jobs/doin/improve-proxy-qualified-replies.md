---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/proxy-claude.sh
Validate each generated ANSWER before delivery; on rejected bare issue/PR references, perform one bounded repair pass with the validator diagnostics, then defer that question with a deduplicated maintainer note if it remains invalid. This prevents the same malformed proxy reply from crash-looping garden-proxy every five minutes.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-23T03:49:34Z
