---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/check-issue-refs.sh
scripts/jobs/check-issue-refs.sh:66 misclassifies a panel-item label such as `prover #3` as an `owner#N` GitHub reference, causing the gauntlet fix handler to fail after completing its work (2026-10-07T12:29:25Z).
Exempt known jury-seat item labels deterministically while retaining rejection for actual partial issue/PR references, and add a regression test.
