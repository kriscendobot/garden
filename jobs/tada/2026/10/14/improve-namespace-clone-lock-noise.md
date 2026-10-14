Implemented and pushed commit `0396add351f1` to `main2`.

- Fixed pipefail/SIGPIPE misclassification that replayed per-clone soft-lock warnings.
- Added a non-TTY journald-priority regression fixture requiring one `<6>` coalesced summary and no `<4>` warnings.
- Passed namespace maintenance and orphan-sweep tests, Bash syntax checks, ShellCheck, and `git diff --check`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-namespace-clone-lock-noise.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 184s

<!-- garden-usage-end -->
