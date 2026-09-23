Done. Completion report:

---

**Job: improve-comment-watcher-cgroup-reap-on-normal-exit — complete**

**What I did:** Closed the acknowledged straggler gap in `scripts/jobs/comment-watcher.sh`'s `cleanup()` that produced the recurring `Found left-over process (git) in control group while starting unit` warning.

**What changed (1 file, +73/−17):**
- Added `reap_cgroup_stragglers()` — a final cgroup-wide straggler sweep. It resolves this process's own service cgroup from the `0::` unified line of `/proc/self/cgroup`, reads `/sys/fs/cgroup<path>/cgroup.procs`, and `kill -KILL`s every pid **except `$$` and its ancestor chain** (self-heal-run.sh, systemd). This catches the `gh --paginate`-forked git credential helper that placed itself in a *different* process group — escaping the existing negated-PGID reap — and that survived a *normal* successful tick exit, since the unit's cgroup-wide SIGKILL backstop only fires on a systemd *stop*, never on clean completion.
- Restructured `cleanup()` so the original pgid reap runs only when a source pid is set (the signal path), while the new sweep runs **unconditionally at the tail** — so it covers the normal-exit path where `SOURCE_TIMEOUT_PID` is already cleared and the old code early-returned.
- **Safety guards** make it a strict no-op outside a real service cgroup: bails when `/proc/self/cgroup` is unreadable or has no `0::` line (non-systemd test runs, cgroup v1, the `timeout`-absent branch), and refuses any leaf that isn't `garden-comment-watcher*.service` so a shared session/scope cgroup in the test harness is never swept.
- Updated the two surrounding explanatory comment blocks to reflect that the different-group straggler is now caught on every exit path rather than left to the stop-time backstop.

**Verification:**
- `bash -n` clean.
- Full suite `scripts/jobs/test/comment-watcher-test.sh`: **115 passed, 0 failed** (incl. the FF/FF2 signal-reap cases). `comment-claude-fallback-test.sh`: 8/0.
- Isolated checks: confirmed no-op in the test's non-service cgroup (a spawned sleep survives), the service-leaf glob matches `garden-comment-watcher@*.service` and rejects `user-*.slice`, and a positive run proved a cgroup.procs straggler is killed while `$$` is spared.

**Landed:** committed with explicit pathspec and pushed via rebase CAS loop to `main2` (`1fc9b3cd9..097464520`).

**Follow-ups:** None required. The unit's short-`TimeoutStopSec` cgroup-wide SIGKILL backstop remains as a redundant stop-path safety net; it is now strictly secondary to the in-script sweep. No `--dry` flag exists in the script — the stub-driven test harness is the equivalent stub run and is green.
