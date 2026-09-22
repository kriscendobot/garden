---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
Cursor reads repeatedly time out with rc=124 despite the helper’s intended lock-wait handling. Derive and enforce the cursor-stage timeout floor from the actual cursor lock wait (including grace), preventing environment overrides from guillotining the helper before it can return the quiet temporary-unavailable result.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T08:52:15Z
