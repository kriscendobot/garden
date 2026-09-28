I fixed `comment-watcher.sh` so that when the comment source hits GitHub's primary quota, the watcher opens the shared REST cooldown itself instead of leaving it for `comment-latency-watch` to open later. The change is pushed to `main2` as commit 9a9553c70e9. The full `comment-watcher-test.sh` suite passes (404 passed, 0 failed), including the new regression checks.

**What changed**
- **`scripts/jobs/comment-watcher.sh`:** in the rc-75 branch, after echoing the source's stderr, the watcher checks that stderr with `is_gh_primary_rate_limit_text`. On a match it:
  - calls `start_api_cooldown "comment:$slug:primary-quota" "$(api_primary_quota_secs)"`, which by default opens a one-hour window;
  - logs one WARN, only if this tick opened the window;
  - exits 0, skipping the tick cleanly.
- **Cursor stays frozen:** the new exit comes before the source output is read, so the cursor never moves past rows from a partial enumeration.
- **Heartbeat:** it reports `cooldown` through the existing EXIT trap, because the cooldown marker is now live.
- **Other rc 75 failures** without the primary-quota message behave as before and still propagate rc 75.
- **Behavior change:** a primary-quota tick now exits 0 instead of returning 75 for the self-heal wrapper to normalize. The wrapper treated 75 as a clean exit anyway, so the service outcome should look the same.

**Test (`scripts/jobs/test/comment-watcher-test.sh`)**
- **New case:** a fake source prints a partial row, the real `gh_api_retry` primary-quota stderr, and exits 75. The test checks that the watcher exits 0 with no FATAL, the cooldown lasts at least 3600s and is tagged `primary-quota`, it warns exactly once, and the cursor stays frozen.
- **Existing generic rc-75 case:** it now points its cooldown directory at a test directory instead of the host's shared one. It also asserts that no cooldown opens when the primary-quota message is absent.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-primary-quota-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (819681 cached reads)
- Output: 6931 tokens
- Cost: $0.8068361999999999
- Wall-clock: 130s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
