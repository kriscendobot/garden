Added `clone_unlock "$DIR"` immediately after `sync_clone` in `scripts/jobs/mentor.sh`, releasing the clone and repository locks before digest capture and handler execution.

Checks: `bash -n`; three mentor test suites passed, including 49 provider-order assertions. Pushed commit `7d24877fef8` to `main2`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mentor-leaks-clone-lock-across-handler.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 164s

<!-- garden-usage-end -->
