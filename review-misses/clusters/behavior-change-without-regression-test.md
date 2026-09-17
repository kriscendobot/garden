---
slug: behavior-change-without-regression-test
category: test-gap
status: open
count: 2
members:
  - kriscendobot-minion.town-pr66-review-21dce903
  - endojs-endo-but-for-bots-pr1125-review-b4f3aac8
prs: [66, 1125]
---



A source PR changes an end-to-end user path without a regression test exercising the new behavior, and the coverage stage or coverage-auditor does not require one before maintainer review.

**Threshold rationale:** Held below the dispatch floor. This newly minted cluster has count=1 on one PR.
The miss is minor and does not qualify for the severity bypass. No improvement
job is dispatched. A later matching miss should re-evaluate the cluster at the
tail of that retrospective; at K >= 3 across at least two PRs, the improvement
should add prevention in the producer/gauntlet entry path and durable sensing in
the coverage stage, with each historical diff used for the re-litigation test.
