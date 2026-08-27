Implemented Group D dependency classification and pushed commit `1937bba48` to `feat/endor-run-entry-point-deps` for PR #282.

Changed the walker to classify production, development, peer, optional, and bundled dependencies; exclude transitive dev dependencies; graduate the three requested parity fixtures; commit Node-reference goldens; and raise the exercised floor to 19.

Verification passed: all 323 Endor tests, golden drift check, Rustfmt, Prettier, diff checks, regression mutations, and all eight pre-push gate stages. Posted the required PR summary comment. Follow-ups: none.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endor-walker-dep-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1568s

<!-- garden-usage-end -->
