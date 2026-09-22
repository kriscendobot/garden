---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/transcript-capture.sh
Bound transcript enumeration, redaction/gzip work, and remote git operations with a tick deadline and resumable batch limit. An unbounded capture run reached the 900-second systemd timeout; retain unprocessed spool and ledger state for the next tick.
