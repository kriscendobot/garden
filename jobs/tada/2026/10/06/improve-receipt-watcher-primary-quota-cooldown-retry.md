## Completion report: improve-receipt-watcher-primary-quota-cooldown-retry

When the receipt watcher hits GitHub's primary hourly quota, it now opens the full one-hour cooldown instead of the 300s transient one. The change is pushed to `main2` as `c3f1b02ee6e`. The receipt-watcher suite has two failures, but both also fail on the unmodified `HEAD`.

**What changed**
- **`scripts/jobs/receipt-watcher.sh`:** `shared_availability_failure()` checks for primary quota (`is_gh_primary_rate_limit_text`) before the transient path. On a hit it requests `api_primary_quota_secs` (3600s by default) from `start_api_cooldown`, using a tag ending in `primary-quota`.
  - It handles a latch that `gh_api_retry` already set the way `comment-watcher.sh` does. `start_api_cooldown` adopts the existing marker and leaves its expiry unchanged, and this tick owns the single WARN.
  - The logged window is read back from the marker, so it shows the real remaining cooldown rather than the requested 3600s.
  - This covers all three callers: the journal prerequisite, the PR source and the receipt generate step.
- **`scripts/jobs/test/receipt-watcher-test.sh`:** two new regression tests, both passing:
  1. A source that fails with primary-quota text and no existing latch gets a window of about 3600s (not the short 120s test default), a `primary-quota` tag, and a WARN saying 3600s.
  2. A source that calls the real `gh_api_retry` against a fake `gh` returning a primary-quota error. The watcher keeps that latch: the expiry stays put, the tag becomes `receipt:…:primary-quota <- gh-api:…primary-quota`, there is exactly one WARN, and the logged seconds match what is actually left.

**Tests:** 18 passed, 2 failed. The failures are "fresh-clone outage lost its warning/cooldown" and "empty-stderr prerequisite exit lost its WARN…". Running the suite on an unmodified `HEAD` gives the same two failures (16 passed, 2 failed), so this change didn't cause them. I didn't investigate them, and they are a separate follow-up.

**Follow-ups:** besides those two failures, the parked `improve-receipt-primary-quota-cooldown` job is now redundant and can be dropped.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-receipt-watcher-primary-quota-cooldown-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1192424 cached reads)
- Output: 9337 tokens
- Cost: $1.0127208
- Wall-clock: 139s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
