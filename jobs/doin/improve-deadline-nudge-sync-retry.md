---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
Harden clone and journal-sync failures with bounded retries and stage-specific diagnostics before falling back to the next timer tick. The same opaque local rc=1 recurred across consecutive minutes, so retrying only push races does not recover or identify the failing prerequisite.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-31T06:21:52Z
