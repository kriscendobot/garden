from_host: endolin-garden2-5bcdff64
from: watchdog:root-repo-guard
sent_at: 2026-08-09T20:22:19Z
watchdog_key: root-repo-objstore-endolin-garden2-5bcdff64
notice_count: 2
first_seen: 2026-07-30T09:52:22Z
last_seen: 2026-08-09T20:22:19Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-07-30T09:52:22Z, latest 2026-08-09T20:22:19Z).
The SAME condition (`root-repo-objstore-endolin-garden2-5bcdff64`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

root repo /home/kris/garden2 object store is UNMAINTAINABLE: 'git gc' fails (fatal: gc is already running on machine 'endolin-garden2-5bcdff64' pid 2558467 (use --force if not)) and a non-destructive 'fetch --refetch' from the canonical origin did not restore it. 0 object(s) reachable from refs are missing locally (e.g.  ). State: 51 packs, 10 loose objects, 0 stale gc.log(s). While gc cannot run, git's automatic cleanup stays disabled, packs accumulate unbounded, and EVERY git call in this repo — including every journal sync, since journal/ is a worktree of it — pays the cost and prints the gc.log banner on stderr. This guard will NOT repair destructively on its own, because the refs that reach the missing objects are real history. Reconcile by hand: list them with 'git -C /home/kris/garden2 rev-list --objects --missing=print --all | grep "^?"', find the refs that reach them, back each one up first ('git -C /home/kris/garden2 branch root-guard-backup/$(date -u +%Y%m%dT%H%M%SZ)-<name> <ref>'), then re-point or drop the ref and re-run 'git -C /home/kris/garden2 gc'. (host=endolin-garden2-5bcdff64)
