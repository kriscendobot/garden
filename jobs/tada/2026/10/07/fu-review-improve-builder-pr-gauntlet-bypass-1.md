Fixed held-draft gauntlet re-staging and pushed commit `ef20e012edd` to `main2`.

- Re-stage basenames now include the PR head SHA, preventing same-day collisions while preserving idempotency for the same head.
- Added regression coverage for a second held-draft finish on the same PR and day.
- Verified with the handoff test, syntax checks, and `git diff --check`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-review-improve-builder-pr-gauntlet-bypass-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 188s

<!-- garden-usage-end -->
