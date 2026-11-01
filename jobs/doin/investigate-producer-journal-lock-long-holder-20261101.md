---
posted_at: 2026-11-01T04:56:21Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
garden (main2): scripts/jobs/common.sh clone_lock / garden_repo_lock, producer journal clone ($GARDEN_STATE/producer/journal).

On endolin-garden-ece02cb4, 2026-11-01 ~04:18:50–04:45Z, a single process (pid 708218, already gone, unit unidentified) held the producer journal clone's repository lock (repo-locks/659587c3…/repo.lock) for ~30 minutes, re-stamping its holder record at 04:18:50, 04:27:17 and 04:37:59. Every other producer on the host (foreman post, send, entry, reaper doom-notice, journal-contention-watch) hit rc=75 or a FATAL clone-lock give-up during that window (`journalctl --user --since "2026-11-01 04:15" --until "2026-11-01 04:50" | grep producer/journal`).

Two things to look at:
1. Find which producer can hold that clone for tens of minutes (a loop that re-locks per item without yielding, or a git command without a bound), and give it a wall-clock deadline / yield like post-job.sh's GARDEN_POST_DEADLINE_SECS. Consider logging the holder's GARDEN_TAG/unit in the repo-lock holder record so the "overdue-holder pid=N" line names the culprit next time.
2. clone_lock's stale-steal of journal.lock (>GARDEN_LOCK_TTL) is defeated when the same live holder still has the repository flock: the stealer then waits GARDEN_REPO_LOCK_WAIT and exits rc=75 anyway (seen 04:32:19→04:32:29 and 04:42:20→04:42:30). Decide whether the TTL steal is still meaningful now that garden_repo_lock nests inside it, or whether an overdue repo-lock holder should be surfaced (watchdog-notice) instead.

Also noticed: repo-locks/*/fetch.lock.holder.<pid> records leak (60+ dead-pid records under that key dating back to 2026-10-15); _garden_repo_fetch only removes its own record on normal return. Low priority.

Context: the foreman side was fixed in main2 a9310301aae (improve-foreman-post-job-tempfail-handling), which retries post-job rc=75 in place.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T04:57:03Z
