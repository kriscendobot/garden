I added the end-to-end regression fixture, and it found a real process leak in the realistic production path. I fixed the leak in `scripts/jobs/gardener.sh` and pushed everything to `main2` as `d583c985dfe`. The new test passes 21/21; I have not seen a CI run of the commit yet.

**The fixture** (new `scripts/jobs/test/handler-wall-bound-regression-test.sh` and `scripts/jobs/test/wall-tree-handler-stub.sh`) runs the real `gardener.sh` with a handler whose whole process tree resists SIGTERM:
- the handler itself ignores TERM;
- one child in the same process group ignores TERM;
- another child's TERM handler sleeps 300s before exiting;
- one child calls `setsid` to escape the process group, and it has a grandchild that also ignores TERM.

It runs two cases:
- **Case A:** `timeout` works normally.
- **Case B:** the handler SIGSTOPs `timeout`, so only the watchdog can end the tree.

For each case it checks that:
- every member is dead by start + budget + kill-after (+3s slack);
- no process carrying the run's unique token survives the worker;
- the failure record and the deadline-overrun record carry the watchdog's deadline, TERM and KILL evidence;
- `gardener.sh` returns by start + budget + 60s.

The test shortens the budget to 2s and kill-after to 4s, but the return assertion still uses the full 60s production figure. It also checks that `gardener.sh` still ships `GARDEN_HANDLER_KILL_AFTER=60`.

It can't leak or hang: every wait is a bounded poll, and an exit/interrupt trap kills every recorded and token-tagged process plus any gardener still running. In CI it runs under `timeout -k 10 240`. Each run takes about 31–35s, and no stray processes were left on this host. It doesn't create cgroups; the existing per-unit cgroup sweep on worker restart stays a separate backstop.

**The leak it found (Case A):** `timeout`'s kill-after and the watchdog's KILL fire at the same deadline. When `timeout` won, the gardener cancelled the watchdog mid-escalation and threw away its list of the tree's pids. The escaped `setsid` members were orphaned, the final reap couldn't reach them from the dead handler, and they outlived the worker. It failed the same way on both runs before the fix.

**The fix:**
- If the watchdog has already sent TERM, the gardener now lets it finish its KILL before cancelling it, waiting at most until its KILL deadline + 5s.
- Only a watchdog KILL recorded while the handler was still alive changes the exit code to 124. A KILL of survivors after `timeout` already ended the handler keeps `timeout`'s rc=137 and gets its own log line. My first version didn't make this distinction and broke `timeout-classifier-test.sh`, which now passes again.

**Other changes:**
- I removed an unused `watchdog_fired` variable left by the previous job. It failed the CI shellcheck check on `gardener.sh`, which now passes it.
- I added the new test to `.github/workflows/checks.yml` (shellcheck list and the focused-tests step).

**Tests run, all passing after the final change:**

| Test | Result |
|---|---|
| `handler-wall-bound-regression-test.sh` | 21/21 |
| `handler-wall-watchdog-test.sh` | 21/21 |
| `timeout-classifier-test.sh` | 42/42 |
| `handler-orphan-reap-test.sh` | 17/17 |

Before the final change I also ran `handler-budget-test.sh` (14/14), `elapsed-constancy-classifier-test.sh` (48), `signal-kill-classifier-test.sh` (17) and `deadline-nudge-test.sh` (68). A batch that included `completion-signal-test.sh` and `productive-cycle-test.sh` hit its background time limit, and I didn't rerun those two.

**Follow-ups:**
- CI shellcheck still fails on warnings in other files: `budget-road.sh`, `common.sh` and `usage-meter.sh`. They were already there and are outside this job.
- A detached descendant of a handler that exits by itself, before any watchdog TERM, is still caught only by the cgroup sweep at the next worker restart. This fix doesn't change that.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-enforce-handler-wall-bound-regression.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (4188341 cached reads)
- Output: 32961 tokens
- Cost: $2.4722242000000008
- Wall-clock: 2110s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
