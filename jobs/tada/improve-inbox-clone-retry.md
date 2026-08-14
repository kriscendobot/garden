Implemented and pushed commit `ce4f3f0080` to `main2`.

- `inbox-read.sh` now retries cold journal-clone failures three times with exponential backoff.
- Added coverage for transient recovery and bounded permanent failure.
- Tests: `run-test.sh 4 2` reported 371 passed, 0 failed; focused ShellCheck passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-inbox-clone-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 283s

<!-- garden-usage-end -->
