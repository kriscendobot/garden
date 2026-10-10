Implemented and pushed commit `2972b8d8284` to `main2`.

- Panel resume now requires exact head SHA, base ref, and SHA-256 PR-body hash matches.
- Panel-run records persist the body hash and include it in run identity.
- Added regressions for body-only and base-ref changes.
- Verified: resume tests 15/15; panel-record tests 34/34.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/panel-resume-key-pr-body-hash.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 266s

<!-- garden-usage-end -->
