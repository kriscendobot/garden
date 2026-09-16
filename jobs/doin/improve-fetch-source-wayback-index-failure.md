---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fetch-source.sh
When both Wayback index lookups fail (for example availability 429 and CDX 503), do not fall through to the bare `2id_` redirect form. Emit a distinct unavailable/index-unreachable result instead, preserving retryable diagnostics; this prevents scholars from repeatedly retrying a known 404 path by hand.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T21:21:17Z
