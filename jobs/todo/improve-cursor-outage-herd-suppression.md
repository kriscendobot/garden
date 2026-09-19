---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-get.sh
Atomically latch journal-read outages and expose a temporary-unavailable result so cursor consumers can skip quietly during the shared cooldown, instead of every triager/comment watcher repeatedly fetching and warning per repo. Preserve loud structural/authentication failures.
