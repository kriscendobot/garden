---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
scripts/jobs/issue-inbox-watcher.sh:690-703 treats a synthetic admission refusal from the live `gh-api:repos/kriscendobot/minion.town/...` latch as a new issue-source quota event, producing the false warning at 2026-10-15T13:05:14Z. Detect the “admission refused: host-shared gh-api cooldown live” diagnostic before adopting an un-attributed latch; freeze the cursor and exit silently, preserving the actual detector’s cooldown and warning. Add a regression case for a `gh-api:` latch owned by a different REST source.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T13:21:50Z
