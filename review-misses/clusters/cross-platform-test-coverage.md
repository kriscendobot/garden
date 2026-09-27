---
slug: cross-platform-test-coverage
category: test-gap
status: improvement-dispatched
count: 3
members:
  - endojs-endo-but-for-bots-pr836-review-eda700a0
  - endojs-endo-but-for-bots-pr475-54294cd3
  - endojs-endo-but-for-bots-pr1290-review-fe19b903
prs: [836, 475, 1290]
improvement_job: review-improve-cross-platform-test-coverage
---




A multi-platform package (xs/endor/browser) ships without the corresponding test:xs/test:endor CI variants or a confirmed fallback strategy; coverage the panel did not require.

**Threshold rationale:** Floor met: count=3 across PRs 836, 475, 1290. Members are coherent — each is a platform arm (xs/browser/native-vs-shim) whose tests did not run on, or encoded assumptions about, that platform; two are the same package (@endo/sha256), showing the lesson from #836 did not bind by #1290. No improvement in flight. Dispatched review-improve-cross-platform-test-coverage (builder) with prevention (producer rule for platform-conditional arms) + sensing (panel-hints probe on new condition keys / platform source files / stub test:xs firing coverage-auditor and engine-realist).
