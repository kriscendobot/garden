---
posted_at: 2026-11-11T18:21:42Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/budget-level.sh
scripts/jobs/budget-level.sh:228 left codex-endolin on the 0.95 fallback at 2026-11-11T18:05:17Z after its planned reset elapsed, requiring a human to transcribe the next deadline. Before freezing, deterministically ingest a validated future Codex reset timestamp from available provider telemetry through append-reset-event.sh; retain the fallback and one coalesced alert when no authoritative timestamp exists. Cover refreshed, absent, expired, and malformed telemetry cases.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-11T18:33:44Z
