Implemented and pushed commit `04bac4826f` to `main2`.

Changed the approval reconciler to capture and classify `post-job.sh` failures, preserve diagnostic tails, retry with bounded jittered backoff, and re-fetch the journal before every confirmation. Uncertain failures are accepted when the job landed; persistent failures defer explicitly to the next tick.

Added regression coverage for transient recovery, nonzero-but-landed posts, and bounded persistent failure handling.

Verification:
- `approval-reconciler-test.sh`: 15 passed, 0 failed
- Full `scripts/jobs/test/run-test.sh`: 368 passed, 0 failed
- Bash syntax and `git diff --check`: clean

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-reconciler-post-confirmation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 370s

<!-- garden-usage-end -->
