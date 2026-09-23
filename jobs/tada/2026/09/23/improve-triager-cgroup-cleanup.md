## Completion report: `improve-triager-cgroup-cleanup`

I pushed the fix to `main2` as `4bfeb0a679`. A stopped or finished triager tick now cleans up its fetch and handler child processes before it exits. That stops the "left-over process (git) in control group" warnings from the next start.

**What was wrong:** `triager.sh` handled a stop signal with only `trap 'exit 143' TERM`. Bash waited for the running command to finish before handling the signal, so the trap could sit behind a `timeout git fetch` or the handler (which can run up to the 780s tick budget). When the trap did run, it killed nothing, so git children could outlive the tick.

**What changed in `scripts/jobs/triager.sh`:**
- **New wrapper, `triager_run_reaped`:** it runs a command under `timeout` in the background, in its own process group, and waits for it. That lets a stop signal interrupt the wait immediately. It now wraps the paced `ls-remote` probe, the steady-state `git fetch`, and the handler (both the time-limited path and the no-deadline path). The call sites write output to temp files instead of capturing it with `$(...)`, because a capture would put the child where the trap can't reach it.
- **New cleanup, `triager_cleanup`:** it runs on exit, TERM and INT, following the same pattern as `comment-watcher.sh` and `receipt-watcher.sh`:
  1. It sends TERM to the child's whole process group.
  2. It waits for the group to finish, which takes at most the 10s kill-after grace.
  3. It sends SIGKILL to the group as a backstop.
  4. It sweeps the unit's own cgroup and kills any leftover process that moved into a different group. This happens on every exit, including a normal tick, and is capped by the new `GARDEN_TRIAGER_CGROUP_REAP_DEADLINE_SECS` setting (default 3s).
- **Sweep safety:** the sweep only acts inside a `garden-triager@*.service` cgroup, apart from a fixture file that tests can use. It never kills the triager itself, its parent processes, or `self-heal-run.sh`'s `tee` that carries the log output. That `tee` is a sibling process, not a parent, so a sweep that only protected parents would kill it (the comment-watcher's sweep appears to have this flaw). Temp files are removed during cleanup.

**What changed in `scripts/systemd/garden-triager@.service`:**
- `KillMode=mixed`: the stop signal goes only to the main process, which passes it on so the triager's trap does the cleanup.
- `SuccessExitStatus=143 130 SIGTERM SIGINT`: a stop is recorded as a normal exit, not a failure.
- `TimeoutStopSec=30s`: long enough for the trap's worst cleanup (10s + 3s), well under the 2-minute timer, and shorter than the implicit 90s default that could collide with the next run.

**Tests:** I added section P to `scripts/jobs/test/triager-test.sh`:
- A stop during the handler, where the handler's child ignores TERM. The tick exits with 143 in about 0s, leaves no child running, and does not advance the cursor.
- The exit-time cgroup sweep kills an orphaned process in a separate group while the test shell survives.

`triager-test.sh` passes 160/160 on three consecutive runs. One earlier run failed test O4, which uses a 1-second deadline and ran out of time before the handler started under load; I believe that's a timing flake in the test rather than this change. `triager-pacing-test.sh` (14/14) and `triager-claude-handler-test.sh` (7/7) pass, and shellcheck reports no new warnings.

**Follow-ups:**
- Journal round-trips (`cursor-get` / `cursor-set` and the pacing refresh) still run in the foreground and are not wrapped. A stop that lands during one of them waits for it to finish, and if that takes longer than 30s, systemd's SIGKILL at `TimeoutStopSec` clears the cgroup. Wrapping those calls is possible if that backstop turns out to fire in practice.
- The `comment-watcher`, `receipt-watcher` and `dependabot-watcher` sweeps appear to be able to kill `self-heal-run.sh`'s `tee`. It's worth a small fix to protect that sibling the same way the triager now does.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-cgroup-cleanup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (3104985 cached reads)
- Output: 26476 tokens
- Cost: $2.1727489999999996
- Wall-clock: 358s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
