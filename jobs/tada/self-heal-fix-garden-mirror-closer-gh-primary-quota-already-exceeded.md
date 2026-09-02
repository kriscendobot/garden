Implemented and landed on `origin/main2`:

- `68b98daa9c`: mirror-closer treats primary-quota-only ticks as degraded success, preserves unresolved mappings, and keeps mixed/non-quota failures nonzero.
- `6f340d0457`: recognizes gh’s “API rate limit already exceeded” wording without misclassifying secondary throttles.
- Added regression coverage for fast-fail classification, quota-only mirror ticks, warning output, and no `closed_at:` stamp.

Verification:

- `gh-api-retry-test.sh`: 48 passed, 0 failed.
- `mirror-closer-test.sh --no-e2e`: 36 passed, 0 failed.
- Worktree clean and synchronized with `origin/main2`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mirror-closer-gh-primary-quota-already-exceeded.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 70s

<!-- garden-usage-end -->
