---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
Add a shared, bounded cooldown for transient GitHub API failures: record one detected 5xx/HTML/rate-limit blip, let sibling per-repo ticks skip quietly during that window, and emit only the initial warning. This prevents a single provider outage from producing a warning burst across every watcher while preserving the existing fail-closed “never guess” behavior.
