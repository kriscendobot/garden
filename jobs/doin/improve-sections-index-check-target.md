---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/regenerate-sections-index.sh
scripts/jobs/regenerate-sections-index.sh:108 lets a bare `--check` select the long-lived deployed journal, yielding a false stale verdict after staging; this occurred at 2026-10-11T19:10:22Z. Make `--check` reject that ambiguous/default target and require `--library` outside a worker clone, with a regression test; apply the same guard to `regenerate-topics-counts.sh`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-11T19:22:02Z
