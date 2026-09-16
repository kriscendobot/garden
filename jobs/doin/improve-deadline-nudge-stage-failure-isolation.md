---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
Wrap each tick stage with explicit status handling and stage-specific error logging, including guaranteed clone-lock cleanup. Repeated `rc=1` warnings without the failing stage show that `set -e` can escape the intended courtesy-timer retry path, leaving a routine transient failure opaque and unrecoverable within the tick.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T19:51:25Z
