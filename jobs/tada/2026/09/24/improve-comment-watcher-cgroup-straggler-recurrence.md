I found why the leak keeps coming back, fixed it in all three watchers, and pushed the fix to `main2` as `adea391f954`.

**Root cause.** I tested this on this host with throwaway systemd units, since the host is a follower and I couldn't read the leader's logs. When a `Type=oneshot`, `KillMode=mixed` unit's main process exits, systemd SIGKILLs whatever is left in the cgroup straight away. That happens on a clean exit and on a skipped ExecCondition too, not only on a stop. The inline comments claiming "the backstop only fires on a systemd stop" were wrong.
- systemd doesn't wait for those processes to leave, so the unit goes inactive while they are still dying.
- The timer is `OnUnitActiveSec=90s`, measured from the previous tick's start. After a tick that ran about 90s or longer, the next start fires as soon as the unit goes inactive, and sees those not-yet-dead processes.
- A git blocked in disk or network I/O (the "D-state" the job suspected) only dies when that I/O returns, so it can easily still be there.
- Anything alive when the watcher exits takes this path. That includes `self-heal-run.sh`'s git capture after a failed tick, which runs after the watcher's own reap, and any straggler that outlasts the reap's 3s deadline.

**Timing note.** The two-consecutive-zero-reads fix (`098bdfccb`) was committed at 10:58:02Z, after the 10:57:28Z incident, so the leader was not yet running it at that point.

**What changed** (this covers all three of the job's suggestions):
1. **New `scripts/jobs/cgroup-drain.sh`**, added as `ExecStopPost=-…/cgroup-drain.sh %n`. It runs after systemd's kill, in the same cgroup, and keeps the unit from finishing until the cgroup is really empty, so the timer can't start the next tick early.
   - It kills any remaining process and returns after two reads 0.1s apart both find nothing.
   - It gives up after 15s, which is inside the unit's 20s stop timeout.
   - It logs each straggler once with its state, parent, process group, age, wait channel and command line. Any survivor is logged again at the deadline.
   - It does nothing unless its own cgroup is the unit named by `%n`.
2. **Better diagnostics in the watchers.** When the in-script reap hits its deadline, the warning now describes each survivor the same way (via `cgroup-drain.sh --describe`). I left the 3s default alone because there's no data to tune it with; the drain is the real backstop now.
3. **Wired into `garden-comment-watcher@`, `garden-issue-inbox` and `garden-dependabot-watcher@`**, which share the same reap code. I also corrected the wrong comments in the unit and script files.

**Verification:**
- The new `scripts/jobs/test/cgroup-drain-test.sh` passes all 11 cases.
- The existing suites still pass: comment-watcher 381, issue-inbox 46, dependabot 53, with 0 failures.
- shellcheck shows no new findings.
- In a live throwaway unit, a clean cgroup drained silently in about 0.13s. A process leaked after systemd's kill was killed and logged by its command line (`git-leak-sim 304`) before the unit finished.

**Follow-ups:**
- The unit changes take effect only when the units are re-rendered on the next deploy.
- If a straggler shows up again, the drain's log line will name the process and say whether it was stuck in I/O (state D).
- If it turns out to be a detached `git gc`/`maintenance` started by a journal fetch, the next fix would be to turn off `gc.autoDetach` for the watchers' git calls. I haven't done that because nothing has confirmed it yet.
- ExecStopPost doesn't run when `is-main-host.sh` skips the tick. systemd still kills anything that check leaves behind, just without waiting. That fetch already runs under `timeout`, which kills its whole process group, so I left this case alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-cgroup-straggler-recurrence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3491390 cached reads)
- Output: 39538 tokens
- Cost: $2.4591179999999997
- Wall-clock: 595s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
