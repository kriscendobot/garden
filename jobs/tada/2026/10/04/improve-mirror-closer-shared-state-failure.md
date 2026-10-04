Implemented and pushed commit `44473901b67` to `origin/main2`.

- Fingerprints handler failures per tick.
- Stops after the second identical non-quota failure.
- Emits one aggregate error, preserves nonzero exit, and retries unresolved mappings next tick.
- Added regression coverage for cutoff, aggregation, unresolved state, and retry behavior.
- Checks: `mirror-closer-test.sh --no-e2e` passed 77/77; Bash syntax and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mirror-closer-shared-state-failure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 285s

<!-- garden-usage-end -->
