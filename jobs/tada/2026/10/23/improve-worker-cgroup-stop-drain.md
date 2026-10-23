Implemented and pushed commit `1b0b585fd33` to `main2`.

- Added bounded worker `ExecStopPost` cgroup draining via `cgroup-drain.sh`, preventing residual descendants from overlapping restarts.
- Added a regression assertion to the worker stop-timeout check.
- Verified: all 13 check suites passed; cgroup-drain tests passed 14/14; ShellCheck and `systemd-analyze verify` passed.
- Follow-up: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-cgroup-stop-drain.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 852s

<!-- garden-usage-end -->
