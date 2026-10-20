Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1516 at head `2b7550456e`.

Implemented:

- Root `test:bun` runner covering 109 AVA configurations across 47 packages.
- Bun/AVA compatibility preload and child-process execution.
- Pinned Bun 1.4.3 CI job.
- Structured report with 6 gaps, 4 implemented skeleton items, and 4 deferred items.

Findings:

- 19/109 configurations pass; 8/47 packages are fully green.
- SES lockdown primarily fails on Bun’s non-configurable `URLSearchParams.prototype.length`.
- A temporary two-property SES permit raised the experimental result to roughly half the packages, but was reverted pending security review.
- c8 reports 0% because Bun emits no V8 coverage; `bun test --coverage` rejects AVA tests.
- Portable-runner migration spans 403 files and roughly 2,157 tests.

Verification: all existing CI jobs passed. The new Bun job ran and intentionally failed with the documented 19/109 result. Local lint, action-pin checks, package uniformity, composite-config checks, and pre-push probes passed.

Follow-up: decide whether to audit Bun’s SES intrinsics and whether execution-only Bun CI is useful before funding runner conversion or package-specific fixes.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/probe-endo-bun-testing-20261020.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1720s

<!-- garden-usage-end -->
