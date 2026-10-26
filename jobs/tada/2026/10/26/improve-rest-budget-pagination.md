Paginated REST reads now update the shared budget with the pages they actually used. The fix is pushed to `main2` as `0c6356a6815`.

**The problem:** a `gh api --paginate` read was admitted and charged as a single REST call, though it spends one request per page. Multi-page comment sweeps therefore kept the shared estimate too high, so low-priority deferral couldn't kick in before GitHub refused the comment watcher at 2026-10-26 21:26:53Z.

**What changed in `scripts/jobs/common.sh`:**
- **Re-check after paginated reads:** after a `--paginate` REST read succeeds, `gh_api_retry` immediately re-reads GitHub's `rate_limit` endpoint, which doesn't count against the quota. It does this before releasing the lock that callers queue on, so the next caller and the low-priority deferral check both see the real remaining count. The new helper is `_gh_rest_budget_reconcile_locked`, and it skips the normal 120s refresh interval on purpose.
- **Lock busy:** if the read had gone ahead without the lock (because the lock was busy), the re-check only runs if it can take the lock immediately, so the caller never waits a second time.
- **Re-check fails:** if the `rate_limit` read fails, the read still succeeds and the estimate keeps its one-call charge.
- **Unchanged:** reads that aren't paginated, GraphQL calls, refused calls, and runs with the budget turned off don't trigger the re-check.
- The block comment that described the old "counted once" undercount now describes the fix.

**Tests:** I added subtest 8 to `scripts/jobs/test/gh-rest-budget-test.sh`, covering the re-check, deferral engaging right after a sweep, and the cases that must not trigger it. That file passes 41/41, `gh-api-retry-test.sh` passes 68/68, and `comment-watcher-test.sh` passes. I ran the tests before rebasing onto the latest `main2`, not after.

**Follow-ups:**
- The fix only works on a host once it's deployed there.
- `gh_read_retry rest`, used for `gh pr list` and similar, still charges one call per command even when the command pages internally. If those reads turn out to use a lot of quota, the same re-check could be added there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rest-budget-pagination.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (710845 cached reads)
- Output: 8077 tokens
- Cost: $0.865173
- Wall-clock: 634s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
