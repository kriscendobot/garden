---
posted_at: 2026-11-06T01:21:17Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:6598 issues requests unserialized after its 60-second admission-lock wait, observed for review-metadata fanout at Nov 06 00:54:12. Defer the request with a transient result (and bounded retry on a later tick) instead, preserving the cooldown single-flight invariant when a sibling holds the lock.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-06T01:21:33Z
