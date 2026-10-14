---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-10-14T21:44:10Z
job: fix-reaper-auction-bid-dir-20261014
claim: cc70a70a059a6112
---
Fixed the superseded-job bid-directory cleanup and pushed commit cae895c91d3 to main2.

- scripts/jobs/reaper.sh now sources auction.sh, matching sibling consumers and loading both auction_bid_dir plus the reputation helpers through the existing source chain.
- scripts/jobs/test/reaper-scheduled-supersede-test.sh now creates bid directories for stale scheduled claims, verifies superseded claims remove them, and verifies a non-superseded requeue preserves its bid directory.
- Audited reaper helper references against reaper-local definitions and the common.sh -> auction.sh -> reputation.sh source set; no other missing helper source was found.
- Verification: all five scripts/jobs/test/reaper*-test.sh tests passed; bash -n and git diff --check passed; origin/main2 resolves to cae895c91d3.
- Follow-up: the broader auction-reputation-test.sh, which does not exercise the changed reaper path, reported existing worker-kind/reducer expectation failures.
- Self-improvement: nothing this time.
