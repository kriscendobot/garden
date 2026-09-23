Landed commit `d28a2d5f76` on `main2`.

- Added independent `max_stage_retries` budget (default 2) with auditable per-stage retry counts.
- Retryable transient failures are atomically re-posted under the same basename. Policy refusals, deterministic failures, and unproven `requeue-exhausted` failures halt immediately with explicit reasons.
- Reaper records transient/deterministic/unknown failure classification.
- Added mutation-proven regression coverage.

Verification:

- New retry-budget test: 16 passed.
- Existing gauntlet suite: 38 passed.
- Reaper doom suite: 9 passed.
- Policy-refusal suite: 5 passed.
- All four guard mutations exited 1 as recorded in the test header.
- Full checks: 9 suites passed; one unrelated pre-existing scholar-role information-hiding check failed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gauntlet-stage-retry-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 943s

<!-- garden-usage-end -->
