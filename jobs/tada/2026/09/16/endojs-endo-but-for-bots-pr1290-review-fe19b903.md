Implemented and pushed commit `3e84158dcc647ce195d438082808c8953d2d1855` to PR #1290.

- Added a top-level Playwright test bundling SHA-256 through compartment mapper’s `browser` condition and exercising sync and async APIs.
- Consolidated sync/async SHA-256 test vectors.
- Replied to inline comment `4031653464`, posted summary `5705983958`, and re-requested review from `kriskowal`.
- Verified 115 SHA-256 tests, package lint/types, local Chromium rendering, and passing CI browser tests.
- Full local verification encountered unrelated environment/repository failures: missing `zizmor`, host-shell daemon-spawn failures, missing Moddable lint dependency, and TypeDoc OOM.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-review-fe19b903.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2230s

<!-- garden-usage-end -->
