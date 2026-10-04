---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
`scripts/jobs/common.sh:5107` makes leader resolution fail over after one `_journal_git_fetch`, while `journal_fetch` at `scripts/jobs/common.sh:5239` already provides bounded retries; journalctl logged this fallback at 2026-10-04T19:58:53Z. Route the leader-marker probe through the same bounded retry behavior before arming the stale-cache fallback, and extend `main-host-test.sh` to prove a transient first fetch failure recovers without warning.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-04T20:21:00Z
