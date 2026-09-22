---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/receipt-watcher.sh` is missing the `reap_cgroup_stragglers` EXIT-path sweep that `scripts/jobs/comment-watcher.sh` gained in commit a6f6b82e0b ("fix(comment-watcher): reap cgroup stragglers in a wait-until-empty loop"). Port that same bounded wait-until-empty cgroup sweep into receipt-watcher.sh's `cleanup()` (currently at line 140, which only reaps `SRC_PID`), keyed to the `garden-receipt-watcher@*.service` cgroup leaf pattern instead of `garden-comment-watcher*.service`.

Failure signature: `garden-receipt-watcher@endojs-endo-but-for-bots.service` exceeded `TimeoutStartSec` (900s) and systemd SIGKILLed its cgroup mid-run (`Killing process 1399589 (receipt-watcher)` plus two live `cursor-set.sh` children, 2026-09-22T04:17:58Z), because a prior run's stragglers were still occupying the cgroup at start time. Those children were killed while holding the `clone_lock` flock on the shared journal cursor clone (`$GARDEN_STATE/cursors/journal`, used by every watcher's `cursor-set.sh`/`cursor-get.sh`), corrupting an in-flight index write and causing an UNRELATED sibling — `garden-triager@kriscendobot-minion.town` — to fail seconds later with `fatal: unable to write new index file` (exit 128) against that same shared clone.

Fix scope: add the same `_straggler_alive` + bounded re-read-and-kill loop (with `GARDEN_RECEIPT_CGROUP_REAP_DEADLINE_SECS`, mirroring `GARDEN_COMMENT_CGROUP_REAP_DEADLINE_SECS`) to receipt-watcher.sh's `cleanup()`, so its own service cgroup is verified empty of descendants before the watcher exits — preventing the next `systemctl start` from ever needing to SIGKILL a live, lock-holding straggler. Carry over the existing FF3-style test fixture pattern (`GARDEN_COMMENT_CGROUP_PROCS_FILE` → a receipt-watcher equivalent) if a parallel test exists for comment-watcher's version.
