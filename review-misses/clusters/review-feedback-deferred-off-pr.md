---
slug: review-feedback-deferred-off-pr
category: process
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr1301-review-3220af4b
prs: [1301]
---


A review-feedback worker acknowledges a maintainer's CHANGES_REQUESTED item (records the decision, replies in-thread) but defers the actual code change to a parked or orchestrated job without a reviewer-authorized deferral, so the PR head stays unchanged and the maintainer must re-raise the same feedback.

**Threshold rationale:** Hold. New cluster, count=1, prs={1301}, below the floor of K >= 3 misses across at least two PRs. The miss is minor (pre-release naming, fixed before merge), so the single-major bypass does not apply even though the fixer brief's reviewer-authorized-deferral rule already existed. Candidate improvement if the cluster grows: make the review responder's completion gate verify each CHANGES_REQUESTED item is either a commit on the PR head or carries an explicit reviewer-authorized deferral, and have the re-request-review step diff the head against the items before asking the maintainer to look again.
