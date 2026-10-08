Fixed `comment-source-gh.sh` to preserve and classify quota-probe stderr under the admission lock. Primary-quota exhaustion now freezes the cursor, latches the cooldown, and blocks review-metadata canary requests.

Added regression coverage. Validation: 478 tests passed, 0 failed.

Pushed commit `c185ee5f97b` to `main2`. No follow-ups required.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-source-quota-probe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1738s

<!-- garden-usage-end -->
