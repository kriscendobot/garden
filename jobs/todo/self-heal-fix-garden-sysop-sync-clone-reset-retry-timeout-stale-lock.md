---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix the reset-retry branch of `sync_clone()` in `scripts/jobs/common.sh` (the `else` arm around lines 7208-7229, which ends in `die "hard reset of $dir to origin/$JOURNAL_BRANCH failed after retry"`). Failure signature, seen on garden-sysop 2026-09-30 21:31-21:34: `journal fetch in .../.garden-state/sysop/journal timed out (>45s, rc=124) on attempt 1`, then `rc=137 on attempt 2`, then `FATAL: hard reset ... failed after retry: ... cannot lock ref 'HEAD': Unable to create '.../.git/HEAD.lock': File exists`. The lock was left behind with no live git process holding it (mtime matches the timed-out fetch).

Two gaps:
(1) After the retry `journal_fetch`, the branch only checks `_fetch_stderr_is_offline`. The two other fetch sites in the same function also treat `rc -eq 124 || rc -eq 137` (the timeout kill and the escalation SIGKILL) as offline and exit `$GARDEN_OFFLINE_RC`. Add those rc checks, and ideally the `journal_bounded_fetch_is_ambiguous_outage` check too, so a stalled re-fetch skips the tick cleanly instead of falling through to the reset.
(2) Before the retry `git reset --hard`, call `_sweep_stale_git_locks "$dir"` again. `clone_lock` is still held here, so any git lock file present can only have been left by a git child we killed (for example a fetch killed with rc=137). The function already sweeps once at the start, but not after its own killed retry fetch.

Optional: consider adding `gc.log.lock` to the sweep list, or deleting it on the `gc.log` corrupt path. This clone has a leftover `gc.log.lock` from 2026-09-29.

Add a test under `scripts/jobs/test/`, modeled on `receipt-watcher-test.sh`'s second-reset case. It should cover: first reset fails, the re-fetch returns 124 or 137, and the result is an offline exit rather than a FATAL. A second case: a leftover `HEAD.lock` appears between the re-fetch and the retry reset, and the retry reset succeeds.
