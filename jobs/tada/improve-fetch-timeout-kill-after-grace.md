The commit is landed on `origin/main2`, inbox is empty. The job is complete.

---

## Completion report

**Job:** `improve-fetch-timeout-kill-after-grace` — landed as `94f0386a3` on `main2`.

**Problem:** Both journal-fetch call sites in `scripts/jobs/common.sh` (`leader_host`, `journal_fetch`) used a bare `timeout "$GARDEN_FETCH_TIMEOUT" git fetch`. Bare `timeout` sends only SIGTERM; git's transport child (`git-remote-https` on a half-open TLS connection) doesn't reliably die on SIGTERM — `git fetch` blocks in `waitpid` on the wedged child, so the wrapper's direct child survives the deadline and the transport grandchild orphans into the service cgroup, producing the `garden-reaper.service: Found left-over process <pid> (git)` warnings.

**What I did:**
- Added knob `GARDEN_FETCH_KILL_AFTER` (default 10s).
- Centralized the two inline `timeout … git fetch` invocations into one helper `_journal_git_fetch`, so the grace policy can't drift. It wraps with `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER"`. Confirmed (GNU coreutils 9.4) that `timeout` without `--foreground` already runs the command in its own process group and signals the whole group on expiry — so both the SIGTERM and the escalated SIGKILL reach the transport grandchild; no `setsid` needed.
- Threaded the new rc=137 (SIGKILL escalation) through the existing transient classification so neither expiry path false-escalates: `journal_fetch` now logs both 124 and 137 as a timeout, and `sync_clone`'s offline branch treats both as EX_TEMPFAIL (75) — the same clean-skip the rc=124 stall already took.
- Added `fetch-timeout-test.sh` SUBTEST 8: a fake `git` that ignores SIGTERM and hangs is bounded by `--kill-after` (rc=137 in ~2s, not 30s) and classified EX_TEMPFAIL (75), proving the wedge is closed end-to-end.

**Verification:** `bash -n` clean; full `fetch-timeout-test.sh` suite **12/12 pass** (the 7 pre-existing subtests plus the new one). Independently confirmed the mechanism: a SIGTERM-ignoring child modeling `git` blocked on a wedged transport returns rc=137 at ~5s and the whole group is killed.

This mirrors the just-landed gardener handler `--kill-after` grace (commit `a89e9bcda`) for the identical SIGTERM-ignoring-child problem.

**Follow-ups:** None. The change is self-contained; `GARDEN_FETCH_KILL_AFTER` is overridable per the file's convention if 10s ever needs tuning.
