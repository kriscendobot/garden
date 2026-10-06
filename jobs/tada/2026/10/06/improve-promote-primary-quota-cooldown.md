**Completion report: improve-promote-primary-quota-cooldown**

I fixed the defect and pushed it to `main2` as commit `1fc7b6236d1`. A primary-quota request now replaces a shorter transient latch that is still running, so REST watchers stay suppressed for the full quota window.

**What changed (`scripts/jobs/common.sh`)**
- **Latch kind:** each cooldown marker now has a third line saying whether it is `transient` or `primary-quota`. Markers written before this change are classified from their tag (a tag containing `primary-quota` counts as primary).
- **Promotion:** `_api_cooldown_record_locked` takes the kind as a new argument. When a primary-quota request arrives while a transient latch is still running and the request would end later, it rewrites the marker with:
  - the later expiry,
  - the tag `<new> <- <old>`,
  - the kind `primary-quota`.

  This happens under the existing flock. It also clears `.warned` and returns rc 0, so the caller that promoted the latch owns the warning for the new outage.
- **What stays the same:**
  - A primary-quota latch that is still running is never extended, so repeated detectors cannot push the window out indefinitely.
  - Ordinary transient callers never extend any latch.
  - A request that ends sooner than the running latch never shortens it.
  - The rule where the first detector adopts gh_api_retry's own latch is unchanged.
- **Which calls count as primary-quota:** `start_api_cooldown` treats any call with an explicit requested window as primary-quota (every such call site passes `api_primary_quota_secs`). gh_api_retry's direct latch passes `primary-quota` explicitly.
- **Extra fix:** `api_primary_quota_cooldown_active` had its `9>` redirect in the wrong place, so its read ran without the lock and printed `flock: 9: Bad file descriptor`. It now takes the lock properly.

**Regression coverage (`scripts/jobs/test/api-cooldown-test.sh`, 32/32 pass)**
- A receipt-watcher 300s latch followed by mirror-closer's 3600s primary-quota request gets promoted.
- The promoted latch lasts about an hour, records both tags and the `primary-quota` kind, and starts a fresh warning.
- REST watchers stay suppressed, and the latch also reads as primary-quota.
- Later transient callers and a second primary-quota detector only observe it, and the expiry is not extended.
- A transient caller never extends a running latch, and a shorter primary-quota request never shortens one.

**Other tests**
- **Pass:** mirror-closer, gh-api-retry, ci-watcher, approval-reconciler, dependabot-watcher, pages-watcher, comment-latency-watch and provider-cooldown.
- **Fail with the same counts with and without my change:** issue-inbox-watcher-test (13 failures) and receipt-watcher-test (2 failures).
- **Fails with a count that changes every run:** comment-watcher-test. It failed 15 times without my change, then 25 and 5 times with it, on a host with load around 6. The failing cases are timing and fan-out deadlines that run with the cooldown disabled (`GARDEN_API_COOLDOWN_SECS=0`), so they never reach the changed code.

**Follow-ups**
- Fix the three test suites that fail without my change: comment-watcher, issue-inbox-watcher and receipt-watcher.
- `api_primary_quota_cooldown_active` still decides from the tag alone. Primary latches tagged only `:source` (from ci, approval and dependabot) are therefore not recognised as primary-quota. It could read the new kind line instead.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-promote-primary-quota-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (939730 cached reads)
- Output: 12037 tokens
- Cost: $0.970454
- Wall-clock: 946s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
