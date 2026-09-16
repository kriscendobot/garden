---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fetch-source.sh
When the Wayback availability API rate-limits, fall back deterministically to a bounded CDX timestamp lookup and fetch that capture’s `id_` original bytes. This removes repeated scholar-agent improvisation during bulk mailing-list archive ingestion while preserving a concrete, recorded capture timestamp.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T16:21:22Z
