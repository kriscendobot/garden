Addressed review 4986303659; it had no inline comments.

- Rebased PR #1040 onto current `llm`.
- Added scenario-indexed skipped/failed/passed reports and checked-in baseline.
- Wired baseline comparison into `test-xs` CI; unexpected outcome changes now fail CI.
- Added report, compare, and baseline-update commands plus tests and documentation.
- Pushed commits `9d1386308` and `8e3ad54c8`.
- Local unit tests, TypeScript, ESLint, pre-push probes, and pinned Moddable 5.0.0 baseline comparison passed.
- All CI checks passed, including the new baseline gate.
- Posted summary: https://github.com/endojs/endo-but-for-bots/pull/1040#issuecomment-5360676851
- Re-requested review from `kriskowal`.

Follow-up: maintainer review only.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-review-4ed39ee7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1987s

<!-- garden-usage-end -->
