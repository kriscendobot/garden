---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-15T03:58:51Z
job: improve-budget-snapshot-cas-contention
claim: db03797c71a33458
---
Implemented and pushed commit 3146fd1cd58 to main2.

Changed the budget snapshot publisher so its final retry after repeated lost journal CASes waits in a wider deterministic host-keyed slot, then fetches the current journal tip immediately before grafting and pushing the host-owned snapshot. Non-CAS exhaustion remains bounded and fail-open.

Extended budget-snapshot-cas-retry-test.sh to force three consecutive peer wins, assert all peer writes survive, assert the final host stagger runs once, and assert every retry fetches immediately before its next write.

Verification: budget-snapshot-cas-retry-test.sh, budget-snapshot-replay-test.sh, budget-snapshot-publish-retry-test.sh, budget-snapshot-measure-first-test.sh, budget-snapshot-outage-reclone-test.sh, and budget-snapshot-warning-dedup-test.sh passed. bash -n, git diff --check, and focused shellcheck passed. The broader live-budget-admission-test.sh still has four unrelated fixture failures, and budget-live-percent-label-test.sh has an unrelated standing-backoff status expectation failure.

Self-improvement: nothing this time.
