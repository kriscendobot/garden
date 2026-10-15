Implemented and pushed commit `ef3dcbd8869` to `main2`.

- Semantic mentor rejections below the retry threshold now warn and exit successfully without advancing input markers.
- Threshold behavior remains unchanged: consume the digest, alert once, and stop retrying.
- Genuine non-semantic handler defects still fail the unit.
- Updated regression coverage for successful exit status and marker preservation.
- Verified: mentor provider suite passed 53/53; rejection-backstop test passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-semantic-rejection-service-health.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 174s

<!-- garden-usage-end -->
