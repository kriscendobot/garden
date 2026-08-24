Implemented and pushed commit `8fca0b9c11e8` to `main2`.

- `post-job.sh` now normalizes a single known `**Role: fixer.**`-style role into leading frontmatter.
- Explicit `role:` metadata and `--role` remain authoritative; unknown or ambiguous roles are ignored.
- Fixer jobs now receive a configurable 7200-second default budget.
- Added regression coverage and updated job-board documentation.
- Tests passed: template-role test (5/5), handler-budget test (26/26), producer argument guard (13/13), syntax and diff checks.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-post-job-normalize-template-role.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 359s

<!-- garden-usage-end -->
