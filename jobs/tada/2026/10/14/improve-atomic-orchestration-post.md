Implemented atomic orchestration posting with repeatable `--child NAME BODY-FILE` arguments. Child plans and the orchestration record now land in one CAS commit while preserving validation, routing, cycle-marker cleanup, ownership checks, and idempotency.

Updated producer documentation and orchestration regression coverage. Pushed commit `c145e3aa65b` to `main2`.

Verification: `orchestrate-test.sh` passed 83/83 tests; Bash syntax, focused ShellCheck, help smoke test, and `git diff --check` passed.

Follow-ups: none.

Self-improvement: Updated orchestration skill and role guidance to make single-CAS posting the canonical workflow.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-atomic-orchestration-post.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 920s

<!-- garden-usage-end -->
