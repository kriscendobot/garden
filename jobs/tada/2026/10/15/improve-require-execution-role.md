Implemented and pushed commit `2a58e858fea` to `main2`.

- `post-plan.sh` now rejects orchestrated children lacking `role`, `handler-budget-role`, or a valid explicit timeout.
- Shared validation with atomic orchestration posting and updated producer guidance/tests.
- Tests passed: frontmatter 20/20, orchestration 83/83, retry narrowing 24/24, arc apportionment 39/39. Bash syntax and diff checks also passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-require-execution-role.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1842s

<!-- garden-usage-end -->
