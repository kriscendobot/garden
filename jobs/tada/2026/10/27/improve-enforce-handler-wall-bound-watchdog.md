## Completion report: improve-enforce-handler-wall-bound-watchdog

I hardened the watchdog and fixed how handler time is measured. The change is pushed to `main2` as `b65c4afe11e`. The focused watchdog test and all the related suites pass, except one suite that already failed before the change.

**What caused the overrun record.** The handler did not run 10,265s. Unit `garden-monk@2` logged `watchdog TERMed … rc=137` at 12:57:19, about 7,288s after the claim at 10:55:51. That is the budget plus the 60s kill-after, plus job setup before launch. The gardener then spent about 67 more minutes on journal bookkeeping after the handler returned (FAILED logged at 13:47:16, classified at 14:04:04). The "elapsed" figure was taken only after all that, so the bookkeeping time was counted as handler runtime. Separately, I found a real way for the gardener to hang: it waited on the handler with no time limit after the fail-closed reap. A handler that survives SIGKILL would have blocked that wait forever.

**Changes:**
- **`gardener.sh`, elapsed time:** the handler's elapsed time is now recorded the moment it returns. Every classification uses that value: deadline-overrun, elapsed-constancy, exit-0 requeue, and usage. If bookkeeping after the handler takes 60s or more, it is logged separately as post-handler latency.
- **`gardener.sh`, bounded wait:** after a fail-closed reap, the gardener keeps polling and SIGKILLs the handler's process group again every second. It only waits on a child that is already dead or a zombie.
  - If the handler is still alive `GARDEN_HANDLER_UNREAPABLE_WAIT` seconds (new setting, default 20) past its kill deadline, the gardener records `UNREAPED`, stops waiting and records rc=124.
  - If the watchdog is still alive but its KILL did not end the handler, that is now caught as a new fail-closed reason, `survived-kill`.
- **`gardener.sh`, failure evidence:** the watchdog's record now appears in the `handler FAILED` log line, the deadline-overrun journal entry and the maintainer alert. It includes the absolute deadlines, the TERM/KILL/FAIL_CLOSED/UNREAPED observations, the handler's elapsed time and rc. It is kept out of the captured handler output, so the transient-vs-real failure classification is unchanged. The existing `handler FAILED (rc=N) for '<base>'` prefix is also unchanged, because other tests match on it.
- **`gardener.sh`, new overrun kind:** a signal death with the watchdog's TERM on record now counts as a `watchdog-wall` deadline overrun.
- **`common.sh`:** `process_tree_pids` now builds the process tree from one `ps` call. It used to start one `awk` per `/proc` entry, which took seconds per walk on a busy host and delayed the fail-closed KILL.
- **Contract comment:** the comment near lines 131–140 now says the wall bound applies to the handler's own runtime, and cites the 2026-10-27 incident.
- **`handler-wall-watchdog-test.sh`:** it now checks that the recorded handler elapsed time stays within the bound and that the watchdog evidence appears in the failure and overrun records. It also checks that the vanished-watchdog reap ends the handler before its kill deadline.
  - Before my change this test was already failing 2 checks. The descendant outlived its bound by 1s because of the slow process-tree walk. The gardener-return check allowed only 10s, which includes host-dependent bookkeeping; I widened it.

**Tests:**
- `handler-wall-watchdog-test.sh`: 21/21 passed, on five runs.
- All passed:
  - `handler-orphan-reap`
  - `signal-kill-classifier`
  - `terminal-handler-failure-reap`
  - `post-loop-wallclock-deadline`
  - `worker-startup-cgroup-reap`
  - `elapsed-constancy-classifier`
  - `panel-head-freshness-completion`
  - `completion-signal` (49/49)
- `monk-claude-tree-reap-test.sh` fails 5 checks in its `monk-claude.sh` handler section. It fails the same way on an unmodified copy of the code, so this change did not cause it.

**Follow-ups for the successor `improve-enforce-handler-wall-bound-regression`:**
- The UNREAPED path (a handler that survives SIGKILL) is not covered by a test. Simulating that state would need a test seam or a FUSE-style block.
- Descendants that have already been reparented to init are outside the handler's tree. They are still swept only by the cgroup sweep at the next worker start.
- The adversarial descendant regression and the final wall-bound validation remain with that successor, as planned.
- The ~67-minute post-handler bookkeeping delay is a separate latency problem, probably repo-lock contention during that hour's deploy. It is now logged but not fixed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-enforce-handler-wall-bound-watchdog.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (875153 cached reads)
- Output: 4344 tokens
- Cost: $3.6640661999999997
- Wall-clock: 826s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
