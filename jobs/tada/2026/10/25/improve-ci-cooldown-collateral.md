I fixed the CI watcher's misreading of a refused request as a new primary-quota outage, and pushed it to main2 as `484008b2c22`. The CI watcher test suite passes (118/118), and the new test reproduces the incident against the old code.

**Cause.** When the shared gh-api cooldown is live, `gh_api_retry` refuses the request without sending it and returns rc 75. Its refusal message says "API rate limit already exceeded for user" no matter which latch is live. In `ci-watcher.sh`, the primary-quota check (old line 514) matched that wording. So a source that lost the race with a receipt-owned transient latch produced the 2026-10-25T04:29:34Z pair: the source's own "NOT ISSUED" warning echoed into the log, then a second "primary REST quota exhaustion" warning. It also replaced the receipt watcher's latch with a primary-quota one.

**Fix** (`scripts/jobs/ci-watcher.sh`). Right after a source failure, before any stderr echo or classification, the watcher now looks for `admission refused: host-shared gh-api cooldown live`. If it finds it, it throws away the incomplete source result and exits 0 without logging. The latch owner has already warned. This is the same check `issue-inbox-watcher.sh` already uses.

**Regression test** (`scripts/jobs/test/ci-watcher-test.sh`, new section "QUOTA-COLLATERAL-TRANSIENT"). The source stub prints a partial PR row, opens a live `receipt-watcher:` latch after the watcher's start-of-tick cooldown check, then calls the real `gh_api_retry` with a fake `gh` that counts calls. The test checks that:
- the watcher exits 0;
- no request is sent (zero `gh` calls);
- there is no primary-quota warning, no FATAL, and no echoed source stderr;
- the latch keeps its receipt owner and is not changed to primary-quota;
- no shepherd job is posted.

With the fix reverted, three of these fail, showing the exact paired warnings and the rewritten latch from the incident.

**Follow-ups:** none required. The other watchers (comment, issue-inbox, mention) already handle this refusal.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-cooldown-collateral.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1089976 cached reads)
- Output: 8597 tokens
- Cost: $0.9924151999999999
- Wall-clock: 875s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
