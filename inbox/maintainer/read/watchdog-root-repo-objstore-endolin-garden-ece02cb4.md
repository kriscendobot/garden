from_host: endolin-garden-ece02cb4
from: watchdog:root-repo-guard
sent_at: 2026-07-31T05:22:31Z
watchdog_key: root-repo-objstore-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-07-31T05:22:30Z
last_seen: 2026-07-31T05:22:31Z
---
root repo /home/kris/garden object store is UNMAINTAINABLE: 'git gc' fails (fatal: gc is already running on machine 'endolin-garden-ece02cb4' pid 3728245 (use --force if not)) and a non-destructive 'fetch --refetch' from the canonical origin did not restore it. 0 object(s) reachable from refs are missing locally (e.g.  ). State: 51 packs, 8 loose objects, 0 stale gc.log(s). While gc cannot run, git's automatic cleanup stays disabled, packs accumulate unbounded, and EVERY git call in this repo — including every journal sync, since journal/ is a worktree of it — pays the cost and prints the gc.log banner on stderr. This guard will NOT repair destructively on its own, because the refs that reach the missing objects are real history. Reconcile by hand: list them with 'git -C /home/kris/garden rev-list --objects --missing=print --all | grep "^?"', find the refs that reach them, back each one up first ('git -C /home/kris/garden branch root-guard-backup/$(date -u +%Y%m%dT%H%M%SZ)-<name> <ref>'), then re-point or drop the ref and re-run 'git -C /home/kris/garden gc'. (host=endolin-garden-ece02cb4)
