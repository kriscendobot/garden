---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/post-orchestration.sh
Add an atomic adoption path for `gate: go-ahead` children into a new orchestration, retagging both `gate: orchestrated` and `orchestrated_by` in the same journal commit; tighten ordinary child validation to require those fields for parked children. The current existence-only check can record a campaign whose watcher cannot promote its children.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-25T10:36:21Z
