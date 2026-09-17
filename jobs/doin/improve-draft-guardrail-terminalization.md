---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Treat a conclusive completion-time draft-gate block as a terminal, deduplicated manual-gauntlet handoff rather than a handler failure that the reaper retries. Two already-complete jobs were left in `doin` solely because their PRs were ready without a gauntlet; preserve the no-re-draft safety rule, record one maintainer-visible action, and avoid repeated agent runs.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T00:21:47Z
