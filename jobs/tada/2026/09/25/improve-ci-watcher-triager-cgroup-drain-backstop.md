**Done: the cgroup-drain backstop is now on garden-ci-watcher@ and garden-triager@.**

**What I did**
- Added `ExecStopPost=-/bin/bash @GARDEN_ROOT@/scripts/jobs/cgroup-drain.sh %n` to `scripts/systemd/garden-ci-watcher@.service` and `scripts/systemd/garden-triager@.service`. It sits right after `ExecStart=`, the same place it has in `garden-comment-watcher@.service`, with a short comment giving the recurrence counts (6 on ci-watcher, 9 on triager) and why the drain is needed.
- The drain waits at most 15s, which is shorter than both units' stop timeouts (`TimeoutStopSec`: 20s for ci-watcher, 30s for triager). So systemd will never time out a stop because of the drain.
- Pushed to `main2` as commit `5649df92936`.

**Checks**
- **Re-rendering:** `install-units.sh`'s `render()` picks up every `garden-*.service` file, including instance templates like these two. So both units are re-rendered on the next install or reconcile, with `@GARDEN_ROOT@` filled in.
- **Unit files:** I rendered both into a temp directory and ran `systemd-analyze --user verify` on them. It reported no errors, and the `ExecStopPost=` line is in both rendered files.
- **Drain script test:** `scripts/jobs/test/cgroup-drain-test.sh` passed 11 of 11.

**Follow-ups**
- Hosts pick up the change at their next deploy and units reconcile.
- After that, the thing to watch is `journalctl --user` for the ci-watcher and triager units. "Found left-over process" should stop appearing there, and if a straggler does show up, the drain logs a line naming it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-triager-cgroup-drain-backstop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (269650 cached reads)
- Output: 3034 tokens
- Cost: $0.466378
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
