Implemented and pushed commit `b4e48fb7b2` to `main2`.

- Added a 780-second tick deadline and 60-second per-PR approval/mergeability probe bounds.
- Safely defers the current and remaining PRs to the next stateless tick with one actionable warning.
- Prevents timed-out mergeability probes from being misclassified as red CI.
- Added regression coverage; approval reconciler suite passes 18/18.
- Changed script passes Bash syntax and targeted ShellCheck.
- Follow-up: repository-wide CI remains red on unrelated pre-existing SC2034 warnings in `cost-by-pr.sh` and `qwen-mentor-trial-status.sh`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-reconciler-bounds.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 990s

<!-- garden-usage-end -->
