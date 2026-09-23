---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr836-review-eda700a0
verdict: miss
category: test-gap
pr: 836
cluster: cross-platform-test-coverage
cluster_pattern: A multi-platform package (xs/endor/browser) ships without the corresponding test:xs/test:endor CI variants or a confirmed fallback strategy; coverage the panel did not require.
review_at: 2026-07-26T15:05:50Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/836#pullrequestreview-4782014530
identity: endojs/endo-but-for-bots#836:review:4782014530
missed_by: coverage-auditor
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

sha256 ships without test:xs / test:endor variants exercised by CI, and a pure-JS browser fallback is added without confirming whether WebCrypto/ponyfill is the right path. Cross-platform test coverage gap the panel did not require.
