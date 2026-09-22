---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/transcript-capture.sh
Bound transcript enumeration, redaction/gzip work, and remote git operations with a tick deadline and resumable batch limit. An unbounded capture run reached the 900-second systemd timeout; retain unprocessed spool and ledger state for the next tick.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T00:52:36Z
