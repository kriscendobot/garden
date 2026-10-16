---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Failure signature: `scripts/jobs/watchman.sh` (garden-watchman, timer-driven oneshot) exits 1 with `FATAL: cannot resolve deployed HEAD in $GARDEN_ROOT` after each of its 3 `git rev-parse --verify --quiet HEAD` attempts logs `garden repo lock: timeout after 10s: …/repo.lock (shared)` and `garden repo lock: busy pid=<N> …; retaining lock inode` (from `scripts/jobs/common.sh` ~L73–80). The holder in this incident (pid 1843294) held the lock from 12:15:06 to past 12:15:39. That is longer than the ~33s retry window added by f8451bd70d1 (job self-heal-fix-garden-watchman-local-main2-lock-retry), so the earlier fix doesn't cover it.

Fix: in `watchman.sh`'s local-HEAD resolution loop (~L43–52), tell lock contention apart from a genuinely unresolvable HEAD. If the last failure came from the repo-lock wrapper timing out or reporting busy, log `WARN: root repo lock busy; skipping tick` and `exit 0`. The next timer tick will retry, and nothing is lost because the broadcast is keyed on HEAD changing between ticks. Keep the `die` only for a HEAD that is truly unresolvable when the lock is not contended. Pick one way to detect contention and implement it:
- capture rev-parse's stderr and match the `garden repo lock: timeout` line, or
- better, have the common.sh lock wrapper return a distinct exit code for lock timeout and check that code.

Apply the same skip-on-busy treatment to the `origin/$GARDEN_MAIN_BRANCH` rev-parse on the next line. Extend the existing lock-timeout fixture in `scripts/jobs/test/wedge-resolve-test.sh` (~L200) so that persistent contention on every attempt yields rc 0 with the skip log line, not FATAL. Optionally, also log which command holds the lock so long-held exclusive locks (e.g. maintain/repack or deploy) can be identified.
