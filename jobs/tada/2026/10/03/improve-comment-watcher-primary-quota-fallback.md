**Completion report: `improve-comment-watcher-primary-quota-fallback`**

Sibling comment watchers no longer crash when another watcher hits GitHub's primary quota. Pushed to `main2` as `9f141a2608b`.

**The fix**
- **New helper in `scripts/jobs/common.sh`:** `api_primary_quota_cooldown_active [all|rest|graphql]`. It returns success when a live host-shared cooldown marker covers the caller and that marker was set for the primary quota (its tag contains `primary-quota`). This works whether a watcher set the marker or `gh_api_retry`'s admission check did.
- **`scripts/jobs/comment-watcher.sh`:** a new `quota_degrade_if_latched` now runs before both source-failure `die` sites: the generic one (formerly line 1835) and the one on auth retry. If a primary-quota cooldown is live, the watcher keeps its cursor where it was (it exits before reading the source output), records the heartbeat as `cooldown`, logs one line, and exits 0. Exit 0 means no unit restart. On the generic path it doesn't print the raw source stderr, because the watcher that set the cooldown has already warned. Failures with no primary-quota cooldown live still die loudly.

**Regression test** (new section `CQ` in `scripts/jobs/test/comment-watcher-test.sh`)
- **Concurrent case:** three watchers on different repos share one cooldown directory. A barrier makes them all pass the cooldown check at the top of the watcher together. Then one of them gets the real primary-quota refusal and sets the cooldown. The other two fail with an error no classifier recognizes (a jq error, rc 5). The test confirms all three exit 0, none prints FATAL, and all cursors stay frozen. It also confirms exactly one primary-quota warning, that both siblings logged their failure as collateral, and that they didn't print the raw stderr.
- **Control:** the same failure with no cooldown set still exits non-zero with FATAL.

**Test results**
- The new `CQ` section passes all 16 checks.
- The full comment-watcher suite gives 440 passed, 1 failed. The failure is the quote-reply dispatch check at `comment-watcher-test.sh:1059`. It fails the same way on the unmodified base (424 passed, 1 failed), so this change didn't cause it.
- `api-cooldown-test` (22/22) and `gh-api-retry-test` (61/61) pass.

**Follow-ups**
- The quote-reply test failure at `comment-watcher-test.sh:1059` needs its own investigation.
- Other watchers (ci-, issue-inbox-, dependabot-) may have the same gap: an unclassified source failure that dies even though a primary-quota cooldown is live. They could reuse `api_primary_quota_cooldown_active`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-primary-quota-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1344584 cached reads)
- Output: 14154 tokens
- Cost: $1.2251088
- Wall-clock: 956s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
