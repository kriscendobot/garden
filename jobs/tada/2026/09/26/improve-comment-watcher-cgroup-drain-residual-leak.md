Implemented and pushed commit `256c8dc6122` to `main2`.

- Cgroup drain now requires three empty reads spaced 0.5 seconds apart, providing a one-second settling window.
- Added a regression test that injects a delayed straggler after 250 ms and confirms it is killed and logged.
- Verification: cgroup drain tests passed 14/14; ShellCheck and all-script syntax checks passed.
- CI’s unrelated baseline failures remain in three existing suites: gauntlet retry, gauntlet viability, and maintainer-inbox hiding.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-cgroup-drain-residual-leak.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 320s

<!-- garden-usage-end -->
