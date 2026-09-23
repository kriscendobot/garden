Implemented and pushed commit `86272788ce5` to `main2`.

- Bounded the complete triage handler/posting phase by the tick’s remaining budget.
- Deadline expiry now exits cleanly without advancing activity cursors or incrementing failure counts.
- Added post-handler deadline enforcement before cursor work.
- Added timeout and retry regression coverage.

Verification: `scripts/jobs/test/triager-test.sh` — 151 passed, 0 failed; `bash -n` and `git diff --check` passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-tick-bounds.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 335s

<!-- garden-usage-end -->
