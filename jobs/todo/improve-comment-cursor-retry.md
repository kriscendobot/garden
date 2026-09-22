---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Capture cursor-set diagnostics and add a bounded retry/classification path before leaving the cursor unchanged. Repeated rc=1 cursor writes on kriscendobot-minion.town risk replaying work every tick while the current warning cannot identify or absorb a transient journal-write failure.
