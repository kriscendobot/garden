I didn't restart the runner. It was never stalled: the queue was just backed up behind one runner, and it has fully drained. Run 39172800433 (PR #199) finished green on its own, so step 2 needed no shepherding.

**Runner check (02:31Z)**
- **API:** there is exactly one runner, `ci-minion-town-0fdb85b6-20261019T021841Z`. It is `online` and idle. The timestamp in its name is just the loop registering a fresh runner after the job that finished at 02:18Z.
- **Queue:** no runs are queued or in progress.
- **Host:** instance i-0fdb85b6bbc081acb in us-west-1. Over SSM, `systemctl is-active ci-runner` returns `active`.
- **Log:** `journalctl -u ci-runner` shows jobs running back to back with no gap from 23:55Z through 02:18Z, and every one succeeded. That covers the whole window the job description called stalled. The claim that nothing had been `in_progress` since 23:52Z doesn't match the log. The single runner was saturated with `Claude harness`, browser `gate`, and `test` jobs, the same pattern as the 2026-10-18 incident in the ops doc. Per § Operate, a restart would only have killed the job in flight, so I didn't run one.

**The three runs**
- **39172800433** (PR #199 `test`, attempt 2, head `085c7445c3…`): finished `success` at 01:08:33Z. The log entry "Running job: test" at 00:58:51Z is this run. The GuestHostPowers durable-restart test passed this time, so there was nothing to investigate. PR #199's checks are all green: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`. The PR is still a draft.
- **39178337996** (feat/new-clip-inventory `test`): `success` at 00:54:47Z.
- **39178337971** (feat/new-clip-inventory `clip frame browser gate`): `success` at 00:58:40Z.

**What changed:** nothing. I made no restart, no commits, and no `CI_RUNS_ON` change, so CI is still on the self-hosted runner.

**Follow-ups:** none required. When oros-studio can't reach the runners API, the backed-up queue it reports may be saturation rather than an outage. The ops doc already covers this.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ci-runner-restart-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (229748 cached reads)
- Output: 2216 tokens
- Cost: $0.4608056
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
