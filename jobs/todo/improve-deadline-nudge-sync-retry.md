---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
Harden clone and journal-sync failures with bounded retries and stage-specific diagnostics before falling back to the next timer tick. The same opaque local rc=1 recurred across consecutive minutes, so retrying only push races does not recover or identify the failing prerequisite.
