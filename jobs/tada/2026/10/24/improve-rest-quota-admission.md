I added a host-wide REST quota budget that tracks GitHub's remaining REST quota and its reset time. Low-priority watchers now stop before the quota runs out. It's pushed to `main2` as `6e937942e4e`. The new test passes 32/32 after rebasing onto the latest `main2`. Nothing has been tested against live GitHub.

**How it works** (`scripts/jobs/common.sh`, new block just above `gh_api_retry`):
- **Sampling:** it reads the REST limit, remaining count and reset time from `gh api rate_limit`, which GitHub doesn't charge against the quota. It re-reads every 120s, or every 20s once the count is near the reserve or the reset time has passed. The result goes in `rest-budget` in the cooldown directory, written under the existing cooldown lock. Because the reading covers the whole account, it also picks up calls made outside `gh_api_retry`.
- **Counting:** each REST attempt admitted by `gh_api_retry` or `gh_read_retry rest` takes one off the running estimate. A `--paginate` read counts as one call, so the estimate runs high until the next sample corrects it.
- **Deferral:** six watchers now call `gh_rest_budget_defer` right after their cooldown check: comment-latency-watch, receipt, approval-reconciler, dependabot, mirror-closer and review-docket-reconcile. Once the estimate falls to the reserve (`GARDEN_GH_REST_LOW_RESERVE`, default 10%), they skip the whole tick and leave their cursor untouched. They log one WARN per quota window.
- **Normal calls:** the comment, issue-inbox, mention and CI watchers keep the reserve. They are stopped only by GitHub's own refusal or by a sample that reads exactly zero.
- **Pre-emptive block:** a sample of zero opens the existing primary-quota block before any request is spent, and it lasts until the sampled reset plus 15s.
- **Shorter blocks after a refusal:** when GitHub does refuse a REST call, the block now ends at the sampled reset instead of a fixed hour. `gh_api_retry`, `gh_read_retry` and the comment, issue-inbox and comment-latency watchers use this via `api_primary_quota_secs rest`.
- **Fallback:** if there's no usable sample (none yet, a failed read, a stale sample, or a past reset), nothing is deferred and the existing one-hour refusal block is the only guard.
- **GraphQL:** not counted or sampled; `api_primary_quota_secs` without `rest` behaves as before.
- **Off switches:** `GARDEN_GH_REST_BUDGET=0`, or `GARDEN_API_COOLDOWN_SECS=0`. It is also off by default inside tests, so existing gh stubs don't see an extra `rate_limit` call.

**One behaviour to know:** a block opened by a zero sample sits on the host-wide marker, so it also stops GraphQL calls until the reset. That is how the existing REST refusal block already behaves. I kept that rather than change it, and dropped a test assertion that had expected otherwise.

**Tests:**
- New `scripts/jobs/test/gh-rest-budget-test.sh` covers: off by default, counting, slower re-reads, reserve deferral and its single warning, the zero-sample block, refusal blocks ending at reset, the one-hour fallback without data, and picking up a new window.
- `gh-api-retry-test.sh` now sets `GARDEN_GH_REST_BUDGET=0`. It unsets `GARDEN_TEST`, so the budget's `rate_limit` read was showing up in its stub call counts. It passes 68/68.
- Run one at a time: api-cooldown, comment-latency-watch, mirror-closer, dependabot-watcher, receipt-watcher, comment-watcher, issue-inbox-watcher and ci-pr-source-cache passed.
- Run in parallel across 61 suites on a host at load average around 31–44, some failed:
  - **fetch-timeout and fork-watch-provisioner:** fail the same way on unmodified `origin/main2`, so they were already failing.
  - **approval-reconciler:** passed one-at-a-time with the budget changes, then failed its timing checks when re-run later at load ~31. I didn't run it on `origin/main2`, so it isn't confirmed that this was only load.
  - **comment-watcher, deploy-garden, fork-watch-provisioner, gauntlet, ironhorse-fuzz:** hit the 500s limit in the parallel run. I re-ran only comment-watcher and fork-watch-provisioner one at a time (above); deploy-garden, gauntlet and ironhorse-fuzz were not re-run.

**Follow-ups:**
- Confirm the 10% reserve and the choice of low-priority watchers against real quota data. The CI watcher and the comment watcher's per-PR review sweep are still normal priority.
- Once deployed, check that `.garden-state/gh-api-cooldown/rest-budget` is being filled in.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-rest-quota-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3915843 cached reads)
- Output: 38272 tokens
- Cost: $2.535352600000001
- Wall-clock: 2334s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
