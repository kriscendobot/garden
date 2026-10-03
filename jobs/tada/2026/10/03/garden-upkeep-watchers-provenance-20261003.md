Completed and pushed `580ea99bbd9` to `main2`.

- Diagnosed watcher alarms as false blindness during GitHub error responses; `main2` already includes the fix. Leader logs confirm `test262` and `vattr97` self-tests passed at 04:43 UTC.
- Confirmed provenance gaps came from deterministic gauntlet terminal comments lacking `GARDEN_NO_LLM`; the existing `main2` fix marks them automatic. No new watchdog delivery since 03:05 UTC.
- Safely paused watcher services, GC’d the repo-watcher clone from 1,160 packs to 1, restored timers, and added synchronous thresholded `git gc --auto` after successful journal fetches to prevent recurrence.
- Syntax checks passed. Deployment was safely deferred because a monk job had already run 6,838s; the rolling deploy signal remains pending.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-upkeep-watchers-provenance-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (3 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (3 engagement(s) unpriced)
- Wall-clock: 781s

<!-- garden-usage-end -->
