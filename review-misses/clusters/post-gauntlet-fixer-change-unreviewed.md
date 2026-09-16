---
slug: post-gauntlet-fixer-change-unreviewed
category: process
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr475-review-e560d700
  - endojs-endo-but-for-bots-pr858-review-8add9193
prs: [475, 858]
---



A substantive fixer change lands after the last panel reviewed the PR and reaches maintainer review without a fresh correctness pass over the new head, leaving newly introduced state invariants for the maintainer to reconstruct.

**Threshold rationale:** Held below the dispatch floor. The cluster now has count=2 across PRs #475 and
#858. Both members show the same lifecycle gap: a substantive repair landed
after the last gauntlet panel and reached the maintainer without a fresh review
of the introducing head. The second member extends the pattern from a fixer to
a shepherd, but K >= 3 is not met. This minor maintainability miss does not
qualify for the major-severity bypass. No `review-improve-post-gauntlet-fixer-
change-unreviewed` job is dispatched. A third matching miss on any PR should
trigger a fresh threshold evaluation; the improvement should generalize the
cluster from fixer-only wording to all post-gauntlet repair roles.
