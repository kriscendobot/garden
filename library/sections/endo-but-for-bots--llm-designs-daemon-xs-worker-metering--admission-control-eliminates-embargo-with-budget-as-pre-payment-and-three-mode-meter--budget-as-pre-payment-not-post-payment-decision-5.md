---
source: designs/daemon-xs-worker-metering.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-metering.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Complete
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 184
lane: designs
status: current
title: §Budget-as-pre-payment-not-post-payment (Decision 5)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```
budget represents *available* steps, not a credit limit.
Steps are subtracted after each crank.
Messages are only delivered when the budget can cover
the worst case (hard limit).
```

§Pre-payment = §spend-from-budget-after-the-fact-but-only-
commit-when-budget-can-cover-worst-case.

§The-result: §actual-crank-cost-may-be-much-less-than-hard_
limit, §leaving-budget-for-the-next-crank. §A-budget-of
10×hard_limit doesn't mean 10 cranks — it means "at least 10
cranks, often more if cranks complete cheaply".

§Compare-to-the-rejected-embargo-model: that model would have
required §post-payment via outbound-buffering, where if the
crank aborted, the buffered outputs are discarded. §Pre-payment-
admission-control-eliminates-the-need.

§Compare-to-cycle-181-base64's §native-error-fallback-via-
polyfill-rerun: that pays §two-decode-runs-on-the-error-path
for §best-possible-diagnostic. §Both-are-§trade-off-named-
explicitly patterns; the cost is paid on a specific path so
the happy-path is clean.
