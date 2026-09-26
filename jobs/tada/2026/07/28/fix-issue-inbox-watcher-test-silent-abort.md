Fixed and pushed `cf04788ffb` to `main2`.

- Guarded both reactji handler calls; fixture now emits a successful reaction response and pins its stub via `GARDEN_GH`.
- Added an EXIT safeguard that prints an `ABORTED` result line on unexpected `set -e` exits.
- Verified: `RESULT: 40 passed, 0 failed`, `TEST_RC=0`.
- Scanned comparable handler calls; no additional silent-abort fix was needed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-issue-inbox-watcher-test-silent-abort.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 140s

<!-- garden-usage-end -->
