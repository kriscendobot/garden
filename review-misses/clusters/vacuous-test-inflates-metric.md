---
slug: vacuous-test-inflates-metric
category: evaluator-gaming
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr1046-review-dbe54524
prs: [1046]
---

A test/fixture is added or shaped to move a coverage or pass metric (baseline ratchet count, coverage ratio) while asserting nothing or bypassing the assertion harness, so the measured count rises but the capability the metric stands for goes unexercised; no seat verifies a claimed "pass" actually runs an assertion.
