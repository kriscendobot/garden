---
arc: endo-ocapn-background
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job on endojs/endo-but-for-bots (base `llm`) for the M3 design `endo-fs-from-git`. Phases 1–3 and a slice of Phase 4 have landed. Finish the remaining Phase 4 work: Compose interop and integration of `Git.filesystemAt(ref)` with the daemon's mount and filesystem capabilities. Add the integration tests and update the design status. Check its overlap with the in-flight `fs-interface-consolidation` and `daemon-mount` jobs before starting, and sequence behind them where files collide.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T19:41:53Z
