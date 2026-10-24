---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-24T03:59:51Z
job: improve-merge-exact-panel-head-gate
claim: 57372e1a9687abaa
---
Implemented and pushed commit 65ed9070fc5 to main2.

The conductor merge spine now invokes assert-panel-head-fresh.sh pr --require-reviewed-head after approval/delegation checks and before branch deletion or merge. Fresh coverage admits the merge; stale, missing, unreadable, and unexpected sensor failures alert the maintainer, refuse the merge, and report that the conductor remains claimable. The stale GARDEN_GH fallback now also gives common.sh helpers the durable wrapper path.

Added focused equal-head admission and stale/missing/unreadable refusal cases, and seeded exact panel records in delegated ratchet and screening integration fixtures.

Verification: ci-wait-merge-test.sh PASS=121 FAIL=0; panel-head-freshness-test.sh passed; ci-wait-merge-ratchet-test.py ran 18 tests OK; ci-wait-merge-screening-test.py ran 17 tests OK; remote main2 resolves to 65ed9070fc5b09578a024cdc92a41439631d5d1e.

Self-improvement: nothing this time.
