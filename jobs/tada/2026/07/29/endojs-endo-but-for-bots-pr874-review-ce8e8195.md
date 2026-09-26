Addressed the sole inline review comment and pushed `af4711660c9`.

- Checks `response.ok` before parsing successful bodies; preserves JSON error details for failed responses.
- Added ordering regression test.
- Posted inline reply and PR summary.

Verification: Google Sheets tests passed (6); package lint passed. Full local verification build remains blocked by an existing `@endo/is-well-formed-string` resolution failure in `packages/pass-style`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr874-review-ce8e8195.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 388s

<!-- garden-usage-end -->
