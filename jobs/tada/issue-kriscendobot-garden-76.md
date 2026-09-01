---
handed-off: issue-kriscendobot-garden-76-deploy-report
deliverable-complete: false
---
Implemented and pushed commit `0e682da6f066f31f4e41699fae6254e4fa05edf7` to `main2`.

Changes:
- Require exact, case-sensitive first-line `@kriscendobot ` addressing.
- Apply filtering to issue comments, watched comments, inline comments, and GitHub-wide mentions.
- Addressed reviews include all underlying comments; otherwise addressed inline comments remain independent.
- Updated documentation and regression coverage.

Verification:
- Mention watcher: 36 passed.
- Issue inbox: 43 passed.
- Comment watcher: 342 passed.
- Broad suite: 378 passed, with one unrelated existing HTTP 401 classification expectation failure.

Deployment correctly deferred because this gardener's active busy marker exceeded the long-job threshold. Posted blocked successor `issue-kriscendobot-garden-76-deploy-report`, carrying the issue note, to verify automatic deployment and comment on the still-open issue.

Self-improvement: updated the interaction skills to document exact-address routing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-76.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1183s

<!-- garden-usage-end -->
