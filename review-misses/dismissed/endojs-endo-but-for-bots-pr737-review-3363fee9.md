---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr737-review-3363fee9
verdict: not-a-miss
category: new-direction
repo: endojs/endo-but-for-bots
pr: 737
comment_url: https://github.com/endojs/endo-but-for-bots/pull/737#pullrequestreview-4718500574
identity: endojs/endo-but-for-bots#737:review:4718500574
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr737-review-3363fee9
missed_by: none
severity: minor
grounds: The review arrived while #737 was a draft and before any gauntlet or panel result. The preceding #521 retrospective records that the earlier draft had no panel and was replaced by #737 through a directive loop. The #737 primary job and its response builder show that the review introduced an integrated realm-wide shim, shared locator-map, and locator-representation design choice. No panel seat brief, gate, or standing rule bound that design before the review.
---

The maintainer requested a new realm-scoped first-wins shim so related CapTP
networks share opaque sturdyref-to-locator mappings, with locator records kept as
objects rather than URI-shaped values. This is architectural direction first
introduced by the review, not a previously binding review check that failed to
fire. Source: https://github.com/endojs/endo-but-for-bots/pull/737#pullrequestreview-4718500574
