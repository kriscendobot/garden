Implemented and pushed commit `131a8fd084` to `main2`.

- Bounded every per-PR `gh pr view` with the audit’s existing timeout and kill-after policy.
- Timeouts now log an inconclusive skip and allow scanning to continue.
- Added regression coverage using a hanging metadata-read fixture.
- Verified with the audit regression test, ShellCheck, and `git diff --check`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-design-gauntlet-audit-bounded-pr-reads.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 160s

<!-- garden-usage-end -->
